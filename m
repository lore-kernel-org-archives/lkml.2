Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab1GWOSl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 10:18:41 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:53274 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab1GWOSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 10:18:34 -0400
Date: Sat, 23 Jul 2011 16:18:31 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: Andy Lutomirski <luto@mit.edu>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.1 git: ld: error: dot may not move backward
Message-ID: <20110723141831.GB1631@x4.trippels.de>
References: <201107231559.23537.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107231559.23537.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.07.23 at 15:59 +0200, Arkadiusz Miskiewicz wrote:
> 
> Hello,
> 
> current git (bbd9d6f7fbb0305c9a592bf05a32e87eb364a4ff)
> 
> [arekm@ixion-pld linux]$ gcc -v
> Reading specs from /usr/lib64/gcc/x86_64-pld-linux/4.6.1/specs
> COLLECT_GCC=gcc
> COLLECT_LTO_WRAPPER=/usr/lib64/gcc/x86_64-pld-linux/4.6.1/lto-wrapper
> Target: x86_64-pld-linux
> Configured with: ../configure --prefix=/usr --with-local-prefix=/usr/local --
> libdir=/usr/lib64 --libexecdir=/usr/lib64 --infodir=/usr/share/info --
> mandir=/usr/share/man --x-libraries=/usr/lib64 --enable-checking=release --
> enable-gnu-unique-object --enable-shared --enable-threads=posix --enable-
> linker-build-id --enable-linux-futex --enable-
> languages=c,c++,fortran,objc,obj-c++,ada,java --enable-libgomp --enable-
> libmudflap --enable-c99 --enable-long-long --enable-decimal-float=yes --
> enable-nls --disable-werror --enable-lto --enable-plugin --disable-cld --with-
> gnu-as --with-gnu-ld --with-demangler-in-ld --with-system-zlib --with-
> slibdir=/lib64 --without-system-libunwind --enable-cmath --with-long-
> double-128 --with-gxx-include-dir=/usr/include/c++/4.6.1 --disable-libstdcxx-
> pch --enable-__cxa_atexit --enable-libstdcxx-allocator=new --enable-libjava-
> multilib=no --disable-gconf-peer --enable-java-awt=xlib,gtk --enable-libgcj --
> enable-libgcj-multifile --enable-libgcj-database --enable-gtk-cairo --enable-
> jni --enable-xmlj --enable-bootstrap --with-pkgversion=PLD-Linux --with-
> bugurl=http://bugs.pld-linux.org x86_64-pld-linux
> Thread model: posix
> gcc version 4.6.1 20110714 (release) (PLD-Linux)
> 
> [arekm@ixion-pld linux]$ ld -v
> GNU gold (Linux/GNU Binutils 2.21.53.0.1.20110716) 1.11
> 
> and at make bzImage 
> 
>   ld -m elf_x86_64 --build-id  -o .tmp_vmlinux1 -T arch/x86/kernel/vmlinux.lds 
> arch/x86/kernel/head_64.o arch/x86/kernel/head64.o arch/x86/kernel/head.o 
> arch/x86/kernel/init_task.o  init/built-in.o --start-group  usr/built-in.o  
> arch/x86/built-in.o  kernel/built-in.o  mm/built-in.o  fs/built-in.o  
> ipc/built-in.o  security/built-in.o  crypto/built-in.o  block/built-in.o  
> lib/lib.a  arch/x86/lib/lib.a  lib/built-in.o  arch/x86/lib/built-in.o  
> drivers/built-in.o  sound/built-in.o  firmware/built-in.o  arch/x86/pci/built-
> in.o  arch/x86/power/built-in.o  arch/x86/video/built-in.o  net/built-in.o --
> end-group
> ld: error: dot may not move backward
> ld: error: dot may not move backward
> ld: error: load segment overlap [0x1800000 -> 0x18850e0] and [0x1884000 -> 
> 0x1884c10]

Please note that ld.bfd links just fine. I've opened a gold bug here:
http://sourceware.org/bugzilla/show_bug.cgi?id=13019

-- 
Markus
