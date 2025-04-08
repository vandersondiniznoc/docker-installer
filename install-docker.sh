#!/bin/bash

echo "==== INSTALADOR DOCKER E DOCKER COMPOSE ===="
echo "Selecione sua distribuição:"
echo "1) Debian 11"
echo "2) Debian 12"
echo "3) Ubuntu"
echo "4) Rocky Linux"
read -p "Digite o número correspondente: " distro

install_docker_common() {
  echo "[+] Atualizando pacotes..."
  sudo apt update -y && sudo apt upgrade -y
  echo "[+] Instalando dependências..."
  sudo apt install -y ca-certificates curl gnupg lsb-release
}

install_docker_debian_ubuntu() {
  install_docker_common

  echo "[+] Adicionando chave GPG do Docker..."
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/$1/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

  echo "[+] Adicionando repositório do Docker..."
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/$1 \
    $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt update -y
  echo "[+] Instalando Docker e Docker Compose..."
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  echo "[+] Ativando o Docker..."
  sudo systemctl enable docker
  sudo systemctl start docker
}

install_docker_rocky() {
  echo "[+] Instalando dependências..."
  sudo dnf install -y dnf-plugins-core
  echo "[+] Adicionando repositório Docker..."
  sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  echo "[+] Instalando Docker e Docker Compose..."
  sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  echo "[+] Ativando o Docker..."
  sudo systemctl enable docker
  sudo systemctl start docker
}

case "$distro" in
  1)
    echo "[*] Instalando para Debian 11..."
    install_docker_debian_ubuntu debian
    ;;
  2)
    echo "[*] Instalando para Debian 12..."
    install_docker_debian_ubuntu debian
    ;;
  3)
    echo "[*] Instalando para Ubuntu..."
    install_docker_debian_ubuntu ubuntu
    ;;
  4)
    echo "[*] Instalando para Rocky Linux..."
    install_docker_rocky
    ;;
  *)
    echo "Opção inválida."
    exit 1
    ;;
esac

echo "✅ Docker e Docker Compose instalados com sucesso!"
echo "🚀 Teste com: docker run hello-world"
"Adiciona script de instalação do Docker e Docker Compose".
