resource "aws_instance" "r100c96" {
  ami               = "ami-068257025f72f470d"
  instance_type     = "t2.micro"
  availability_zone = "ap-south-1b"
  key_name          = "ec2-demo1"
  tags = {
    Name = "Terraform-diff-linux"
  }

  provisioner "remote-exec" {
    inline = [ "sudo hostnamectl set-hostname cloudEc2.technix.com" ]
    connection {
      host        = aws_instance.r100c96.public_dns
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("./aws-exam-testing.pem")
    }
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.r100c96.public_dns} > inventory"
  }

  provisioner "local-exec" {
    command = "ansible all -m shell -a 'apt install -y apache2; systemctl restart apache2'"
  }
}

output "ip" {
  value = aws_instance.r100c96.public_ip
}

output "publicName" {
  value = aws_instance.r100c96.public_dns
}
