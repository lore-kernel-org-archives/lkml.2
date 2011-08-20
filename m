Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab1HTWKN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 18:10:13 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56071 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab1HTWKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 18:10:10 -0400
MIME-Version: 1.0
Date: Sat, 20 Aug 2011 15:10:09 -0700
Message-ID: <CAK3+h2xAca9HVi_VBu4taSrG=BX_N=cbUqxFsfhn5xaX6gkbvA@mail.gmail.com>
Subject: Is arch/x86_64 kernel relocatable by default from redhat enterprise 5
 originated kernel?
From: Vincent Li <vincent.mc.li@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a custom distro that is variation of  redhat 5 kernel. the
custom distro kernel is built with 64 bit:

# uname -m
x86_64

# readelf -h vmlinuz
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 ff eb 3d 00 00 00 00 00 00
  Class:                             ELF64
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            Standalone App
  ABI Version:                       235
  Type:                              DYN (Shared object file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
  Entry point address:               0x100
  Start of program headers:          80 (bytes into file)
  Start of section headers:          0 (bytes into file)
  Flags:                             0x0
  Size of this header:               64 (bytes)
  Size of program headers:           56 (bytes)
  Number of program headers:         2
  Size of section headers:           64 (bytes)
  Number of section headers:         0
  Section header string table index: 0

I installed centos kexec i386 rpm package below on the distro and
tried to start up kdump, but it failed, after bit of digging through
the kdump start up script, I found it failed here:

 kexec rpm package: kexec-tools-1.102pre-126.el5.i386.rpm

kexec command:
/sbin/kexec  --args-linux -p --command-line=ro
root=UUID=0c84cbf1-e638-45df-87f4-c268ad9c9dc3 console=ttyS0,19200
panic=1 platform=Gemini quiet irqpoll maxcpus=1 reset_devices
--initrd=/boot/initrd-2.6.18-164.11.1.el5.1.0.f5appkdump.img
/boot/vmlinuz-2.6.18-164.11.1.el5.1.0.f5app

error:

BzImage is not relocatable. Can't be used as capture kernel.
Cannot load /boot/vmlinuz-2.6.18-164.11.1.el5.1.0.f5app

so it looks  the 64bit kernel is not relocatable according to above
error, then I went to the distro's kernel source directory and
couldn't find "RELOCATABLE" config in arch/x86_64/Kconfig, there is
"RELOCATABLE" config in arch/i386/Kconfig. so I am bit
confused if arch/x86_64 kernel is relocatable by default or
relocatable is not supported yet for the redhat 5 originated x86_64
kernel.

I also suspect that kexec-tools-1.102pre-126.el5.i386.rpm might be the
culprit here since it is for i386, but I couldn't install
kexec-tools-1.102pre-126.el5.x86_64.rpm  lack of 64 bit libc.so.6 on
the custom distro

could someone shed a light on this?

Thanks

Vincent
