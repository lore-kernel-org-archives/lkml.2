Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab1HGTs2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 15:48:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58625 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab1HGTsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 15:48:25 -0400
MIME-Version: 1.0
In-Reply-To: <20110807110429.57161269.rdunlap@xenotime.net>
References: <CAC-yRPQS7r-MMh13Y1m0O+oLBu2OmQqmXS8iHFtCOS9YwrxrkA@mail.gmail.com>
 <20110807110429.57161269.rdunlap@xenotime.net>
From: Amirali Shambayati <amirali.shambayati@gmail.com>
Date: Mon, 8 Aug 2011 00:18:04 +0430
Message-ID: <CAC-yRPTFiU4AwtcpDNse3+eRjjprVPYng9WFbYJMf_Ebe8MGYQ@mail.gmail.com>
Subject: Re: Compile kernel for various times and problem of too long time consuming
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Would you say how you rebuild kernel?

On Sun, Aug 7, 2011 at 10:34 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Sun, 7 Aug 2011 21:39:12 +0430 Amirali Shambayati wrote:
>
>> Hi all,
>> Since I want to evaluate performance improvements by changing just one
>> file in kernel(noop-iosched) and compiling kernel is too much
>> time-consuming, I want to know that if I compile kernel for more than
>> one time, does it take similar time to first time?
>>
>> I use following commands. If I don't use "make-kpkg clean" for next
>> times, does it just compile the files which have been modified or it
>> compile whole kernel package again?
>>
>> make-kpkg clean
>> fakeroot make-kpkg --initrd --append-to-version=-some-string-here
>> kernel-image kernel-headers
>
> Since I never use make-kpkg, I can only tell you that when I modified
> block/noop-iosched.c and rebuilt the kernel, here is what was rebuilt:
>
>  GEN     /lnx/src/NEXT/linux-next-20110805/X32/Makefile
>  CHK     include/linux/version.h
>  Using /lnx/src/NEXT/linux-next-20110805 as source for kernel
>  CHK     include/generated/utsrelease.h
>  CALL    /lnx/src/NEXT/linux-next-20110805/scripts/checksyscalls.sh
>  CHK     include/generated/compile.h
>  CHK     kernel/config_data.h
>  CC      block/noop-iosched.o
>  LD      block/built-in.o
>  LD      vmlinux.o
>  MODPOST vmlinux.o
>  GEN     .version
>  CHK     include/generated/compile.h
>  UPD     include/generated/compile.h
>  CC      init/version.o
>  LD      init/built-in.o
>  LD      .tmp_vmlinux1
>  KSYM    .tmp_kallsyms1.S
>  AS      .tmp_kallsyms1.o
>  LD      .tmp_vmlinux2
>  KSYM    .tmp_kallsyms2.S
>  AS      .tmp_kallsyms2.o
>  LD      vmlinux
>  SYSMAP  System.map
>  SYSMAP  .tmp_System.map
>  Building modules, stage 2.
>  VOFFSET arch/x86/boot/voffset.h
>  CC      arch/x86/boot/version.o
>  OBJCOPY arch/x86/boot/compressed/vmlinux.bin
>  LZMA    arch/x86/boot/compressed/vmlinux.bin.lzma
>  MODPOST 575 modules
>  MKPIGGY arch/x86/boot/compressed/piggy.S
>  AS      arch/x86/boot/compressed/piggy.o
>  LD      arch/x86/boot/compressed/vmlinux
>  ZOFFSET arch/x86/boot/zoffset.h
>  OBJCOPY arch/x86/boot/vmlinux.bin
>  AS      arch/x86/boot/header.o
>  LD      arch/x86/boot/setup.elf
>  OBJCOPY arch/x86/boot/setup.bin
>  BUILD   arch/x86/boot/bzImage
> Setup is 14972 bytes (padded to 15360 bytes).
> System is 1287 kB
> CRC 64ecf4d
> Kernel: arch/x86/boot/bzImage is ready  (#18)
>
>
> so it's a minimal rebuild, not a full kernel rebuild.
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>



-- 
Amirali Shambayati
Bachelor Student
Computer Engineering Department
Sharif University of Technology
Tehran, Iran
