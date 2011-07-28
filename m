Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab1G1OFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 10:05:34 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38635 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab1G1OFc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 10:05:32 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Thu, 28 Jul 2011 16:05:31 +0200
Message-ID: <CA+icZUV7R5hqTupiuZZKWcsZ5LOBGmY6xgmMTM7W3ojJo0Sp4w@mail.gmail.com>
Subject: Re: linux-next: Tree for July 28 (fs/binfmt_misc.ko)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 5:57 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Just in case anyone needs reminding:  Please do not add anything destined
> for v3.2 into linux-next included trees until after v3.1-rc1.
>
> The powerpc allyesconfig build (at least) still fails today.
>
> Changes since 20110727:
>
> Linus' tree still has its build failure from the staging tree which I
> have still left.
>
> The slave-dma tree lost a conflict.
>
> The mfd tree lost its conflicts.
>
> The akpm tree lost its build failure.
>
> ----------------------------------------------------------------------------
>

Hi,

just see this build-break on the last mile:

[...]
  OBJCOPY arch/x86/boot/compressed/vmlinux.bin
  HOSTCC  arch/x86/boot/compressed/relocs
  HOSTCC  arch/x86/boot/compressed/mkpiggy
/mnt/sdb3/linux-kernel/linux-3.0/debian/build/source_i386_none/arch/x86/boot/compressed/relocs.c:
In function 'print_absolute_symbols':
/mnt/sdb3/linux-kernel/linux-3.0/debian/build/source_i386_none/arch/x86/boot/compressed/relocs.c:405:14:
warning: variable 'sh_symtab' set but not used
[-Wunused-but-set-variable]
ERROR: "copy_from_user_overflow" [fs/binfmt_misc.ko] undefined!
make[5]: *** [__modpost] Error 1
make[4]: *** [modules] Error 2
make[4]: *** Waiting for unfinished jobs....
  RELOCS  arch/x86/boot/compressed/vmlinux.relocs
  GZIP    arch/x86/boot/compressed/vmlinux.bin.gz
  MKPIGGY arch/x86/boot/compressed/piggy.S
  AS      arch/x86/boot/compressed/piggy.o
  LD      arch/x86/boot/compressed/vmlinux
  ZOFFSET arch/x86/boot/zoffset.h
  OBJCOPY arch/x86/boot/vmlinux.bin
  AS      arch/x86/boot/header.o
  LD      arch/x86/boot/setup.elf
  OBJCOPY arch/x86/boot/setup.bin
  BUILD   arch/x86/boot/bzImage
Setup is 15596 bytes (padded to 15872 bytes).
System is 2471 kB
CRC eb598167
Kernel: arch/x86/boot/bzImage is ready  (#1)
make[3]: *** [sub-make] Error 2
make[2]: *** [all] Error 2

I have these binfmt kernel-config options set:

CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=m

- Sedat -
