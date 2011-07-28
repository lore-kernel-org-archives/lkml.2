Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab1G1XBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:01:41 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:34033 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752980Ab1G1XBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:01:40 -0400
Date: Thu, 28 Jul 2011 16:01:36 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: sedat.dilek@gmail.com
Cc: Sedat Dilek <sedat.dilek@googlemail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 28 ("copy_from_user_overflow"
 undefined)
Message-Id: <20110728160136.771e2c0a.rdunlap@xenotime.net>
In-Reply-To: <CA+icZUV7R5hqTupiuZZKWcsZ5LOBGmY6xgmMTM7W3ojJo0Sp4w@mail.gmail.com>
References: <CA+icZUV7R5hqTupiuZZKWcsZ5LOBGmY6xgmMTM7W3ojJo0Sp4w@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jul 2011 16:05:31 +0200 Sedat Dilek wrote:

> Hi,
> 
> just see this build-break on the last mile:
> 
> [...]
>   OBJCOPY arch/x86/boot/compressed/vmlinux.bin
>   HOSTCC  arch/x86/boot/compressed/relocs
>   HOSTCC  arch/x86/boot/compressed/mkpiggy
> /mnt/sdb3/linux-kernel/linux-3.0/debian/build/source_i386_none/arch/x86/boot/compressed/relocs.c:
> In function 'print_absolute_symbols':
> /mnt/sdb3/linux-kernel/linux-3.0/debian/build/source_i386_none/arch/x86/boot/compressed/relocs.c:405:14:
> warning: variable 'sh_symtab' set but not used
> [-Wunused-but-set-variable]
> ERROR: "copy_from_user_overflow" [fs/binfmt_misc.ko] undefined!
> make[5]: *** [__modpost] Error 1
> make[4]: *** [modules] Error 2
> make[4]: *** Waiting for unfinished jobs....
>   RELOCS  arch/x86/boot/compressed/vmlinux.relocs
>   GZIP    arch/x86/boot/compressed/vmlinux.bin.gz
>   MKPIGGY arch/x86/boot/compressed/piggy.S
>   AS      arch/x86/boot/compressed/piggy.o
>   LD      arch/x86/boot/compressed/vmlinux
>   ZOFFSET arch/x86/boot/zoffset.h
>   OBJCOPY arch/x86/boot/vmlinux.bin
>   AS      arch/x86/boot/header.o
>   LD      arch/x86/boot/setup.elf
>   OBJCOPY arch/x86/boot/setup.bin
>   BUILD   arch/x86/boot/bzImage
> Setup is 15596 bytes (padded to 15872 bytes).
> System is 2471 kB
> CRC eb598167
> Kernel: arch/x86/boot/bzImage is ready  (#1)
> make[3]: *** [sub-make] Error 2
> make[2]: *** [all] Error 2
> 
> I have these binfmt kernel-config options set:
> 
> CONFIG_BINFMT_ELF=y
> # CONFIG_BINFMT_AOUT is not set
> CONFIG_BINFMT_MISC=m

How does someone turn off this error message?

I have:
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_STRICT_DEVMEM is not set

and I still cannot get this error to go away (on x86_64).


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
