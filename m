Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab1G2Be3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 21:34:29 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57760 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719Ab1G2Be1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 21:34:27 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110728160136.771e2c0a.rdunlap@xenotime.net>
References: <CA+icZUV7R5hqTupiuZZKWcsZ5LOBGmY6xgmMTM7W3ojJo0Sp4w@mail.gmail.com>
	<20110728160136.771e2c0a.rdunlap@xenotime.net>
Date: Fri, 29 Jul 2011 03:34:26 +0200
Message-ID: <CA+icZUXLpThpEem+DPimemYVHqSKb5NAb5h_L-rMPWsD+WJTYg@mail.gmail.com>
Subject: Re: linux-next: Tree for July 28 ("copy_from_user_overflow" undefined)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 1:01 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Thu, 28 Jul 2011 16:05:31 +0200 Sedat Dilek wrote:
>
>> Hi,
>>
>> just see this build-break on the last mile:
>>
>> [...]
>>   OBJCOPY arch/x86/boot/compressed/vmlinux.bin
>>   HOSTCC  arch/x86/boot/compressed/relocs
>>   HOSTCC  arch/x86/boot/compressed/mkpiggy
>> /mnt/sdb3/linux-kernel/linux-3.0/debian/build/source_i386_none/arch/x86/boot/compressed/relocs.c:
>> In function 'print_absolute_symbols':
>> /mnt/sdb3/linux-kernel/linux-3.0/debian/build/source_i386_none/arch/x86/boot/compressed/relocs.c:405:14:
>> warning: variable 'sh_symtab' set but not used
>> [-Wunused-but-set-variable]
>> ERROR: "copy_from_user_overflow" [fs/binfmt_misc.ko] undefined!
>> make[5]: *** [__modpost] Error 1
>> make[4]: *** [modules] Error 2
>> make[4]: *** Waiting for unfinished jobs....
>>   RELOCS  arch/x86/boot/compressed/vmlinux.relocs
>>   GZIP    arch/x86/boot/compressed/vmlinux.bin.gz
>>   MKPIGGY arch/x86/boot/compressed/piggy.S
>>   AS      arch/x86/boot/compressed/piggy.o
>>   LD      arch/x86/boot/compressed/vmlinux
>>   ZOFFSET arch/x86/boot/zoffset.h
>>   OBJCOPY arch/x86/boot/vmlinux.bin
>>   AS      arch/x86/boot/header.o
>>   LD      arch/x86/boot/setup.elf
>>   OBJCOPY arch/x86/boot/setup.bin
>>   BUILD   arch/x86/boot/bzImage
>> Setup is 15596 bytes (padded to 15872 bytes).
>> System is 2471 kB
>> CRC eb598167
>> Kernel: arch/x86/boot/bzImage is ready  (#1)
>> make[3]: *** [sub-make] Error 2
>> make[2]: *** [all] Error 2
>>
>> I have these binfmt kernel-config options set:
>>
>> CONFIG_BINFMT_ELF=y
>> # CONFIG_BINFMT_AOUT is not set
>> CONFIG_BINFMT_MISC=m
>
> How does someone turn off this error message?
>
> I have:
> # CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
> # CONFIG_STRICT_DEVMEM is not set
>
> and I still cannot get this error to go away (on x86_64).
>
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>

Can you say with which linux-next version you saw this first?
My last version was next-20110722 (which was OK).

- Sedat -
