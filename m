Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592Ab2C1RK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 13:10:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40834 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758561Ab2C1RKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 13:10:54 -0400
Date: Wed, 28 Mar 2012 19:10:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: Trevor Turner <turn3r.tr3v0r@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: K7/Athlon Optimization Causes Build Fail on Kernel 3.3 i686
Message-ID: <20120328171059.GA7919@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Trevor Turner <turn3r.tr3v0r@gmail.com>,
	linux-kernel@vger.kernel.org
References: <CANYHJ6jjuO7yV_kbPsnJ6X+KXrsz2PRPPXHN4Rkr-vgoSG-E4A@mail.gmail.com>
 <20120328111957.GA6765@x1.osrc.amd.com>
 <CANYHJ6j6cxz47TGk8kdU58eau17Fi1K=fH2icmd=v19VjNggKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANYHJ6j6cxz47TGk8kdU58eau17Fi1K=fH2icmd=v19VjNggKw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 09:33:35AM -0700, Trevor Turner wrote:
> On Wed, Mar 28, 2012 at 04:19, Borislav Petkov <bp@alien8.de> wrote:
> > Right, can you try this with the upstream kernel, i.e.
> >
> > 1. get one from kernel.org
> > 2. copy the .config into the directory where you've unpacked the sources
> > 3. do 'make oldconfig' and then 'make menuconfig' and go and select Athlon build
> > 4. do 'make -j3 > w.log 2>&1' so that you can catch the build output into w.log
> > which you can send later
> >
> > Also, which build tools are you using, simply do
> >
> > ./scripts/ver_linux
> >
> > in the kernel source directory, catch the output and send it on pls.
> 
> Here's the output of ver_linux:
> Linux Dark-Server 3.3.0-1-ck #1 SMP Mon Mar 26 07:53:51 PDT 2012 i686
> AMD Athlon(TM) MP 2000+ AuthenticAMD GNU/Linux
> 

<snip a _lot_ of output>

>   LD      drivers/usb/built-in.o
>   LD      drivers/built-in.o
>   LD      vmlinux.o
>   MODPOST vmlinux.o
> WARNING: modpost: Found 1 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>   GEN     .version
>   CHK     include/generated/compile.h
>   UPD     include/generated/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
>   KSYM    .tmp_kallsyms1.S
>   AS      .tmp_kallsyms1.o
>   LD      .tmp_vmlinux2
>   KSYM    .tmp_kallsyms2.S
>   AS      .tmp_kallsyms2.o
>   LD      vmlinux
>   SYSMAP  System.map
>   SYSMAP  .tmp_System.map
>   Building modules, stage 2.
>   MODPOST 518 modules
>   CC      arch/x86/boot/a20.o
>   AS      arch/x86/boot/bioscall.o
>   CC      arch/x86/boot/cmdline.o
>   AS      arch/x86/boot/copy.o
>   HOSTCC  arch/x86/boot/mkcpustr
>   CC      arch/x86/boot/cpucheck.o
>   CC      arch/x86/boot/early_serial_console.o
>   CC      arch/x86/boot/edd.o
>   VOFFSET arch/x86/boot/voffset.h
>   LDS     arch/x86/boot/compressed/vmlinux.lds
>   AS      arch/x86/boot/compressed/head_32.o
>   CC      arch/x86/boot/compressed/misc.o
>   CC      arch/x86/boot/main.o
>   CC      arch/x86/boot/mca.o
>   CC      arch/x86/boot/memory.o
>   CC      arch/x86/boot/compressed/string.o
>   CC      arch/x86/boot/compressed/cmdline.o
>   CC      arch/x86/boot/compressed/early_serial_console.o
>   OBJCOPY arch/x86/boot/compressed/vmlinux.bin
>   HOSTCC  arch/x86/boot/compressed/relocs
>   HOSTCC  arch/x86/boot/compressed/mkpiggy
> arch/x86/boot/compressed/relocs.c: In function ‘print_absolute_symbols’:
> arch/x86/boot/compressed/relocs.c:405:14: warning: variable
> ‘sh_symtab’ set but not used [-Wunused-but-set-variable]
>   CC      arch/x86/boot/compressed/eboot.o
>   AS      arch/x86/boot/compressed/efi_stub_32.o
>   RELOCS  arch/x86/boot/compressed/vmlinux.relocs
>   GZIP    arch/x86/boot/compressed/vmlinux.bin.gz
>   CC      crypto/arc4.mod.o
>   CC      arch/x86/boot/pm.o
>   AS      arch/x86/boot/pmjump.o
>   CC      crypto/crc32c.mod.o
>   CC      arch/x86/boot/printf.o
>   CC      crypto/deflate.mod.o
>   CC      arch/x86/boot/regs.o
>   CC      arch/x86/boot/string.o
>   CC      arch/x86/boot/tty.o
>   CC      crypto/des_generic.mod.o
>   MKPIGGY arch/x86/boot/compressed/piggy.S
>   AS      arch/x86/boot/compressed/piggy.o
>   CC      arch/x86/boot/video.o
>   CC      crypto/ecb.mod.o
> arch/x86/boot/compressed/eboot.o: In function `efi_main':
> eboot.c:(.text+0x1530): undefined reference to `_mmx_memcpy'
> eboot.c:(.text+0x17d0): undefined reference to `_mmx_memcpy'
> make[2]: *** [arch/x86/boot/compressed/vmlinux] Error 1
> make[1]: *** [arch/x86/boot/compressed/vmlinux] Error 2
> make[1]: *** Waiting for unfinished jobs....

This is the problem and I was able to reproduce it on a similar box
here:

processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 6
model           : 6
model name      : AMD Athlon(tm) XP 1800+
stepping        : 2
cpu MHz         : 1533.265
cache size      : 256 KB

It should be fixed by disabling

CONFIG_EFI=y
CONFIG_EFI_STUB=y

in your config. K7 and EFI are from different epochs anyway and cannot
obviously be enabled both on the same system with the current Kconfig
for EFI.

Thanks.

-- 
Regards/Gruss,
Boris.
