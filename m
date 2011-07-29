Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab1G2Jpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 05:45:55 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41250 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab1G2Jpx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 05:45:53 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUVsJNSDzBvvH810POEydpaZxJZfM8J9bD+93+4d+88D_A@mail.gmail.com>
References: <CA+icZUV7R5hqTupiuZZKWcsZ5LOBGmY6xgmMTM7W3ojJo0Sp4w@mail.gmail.com>
	<20110728160136.771e2c0a.rdunlap@xenotime.net>
	<CA+icZUXLpThpEem+DPimemYVHqSKb5NAb5h_L-rMPWsD+WJTYg@mail.gmail.com>
	<20110728220926.6d1a91f4.rdunlap@xenotime.net>
	<CA+icZUVsJNSDzBvvH810POEydpaZxJZfM8J9bD+93+4d+88D_A@mail.gmail.com>
Date: Fri, 29 Jul 2011 11:45:52 +0200
Message-ID: <CA+icZUX=qM+xhJkteXs=F_RJP+k-Tzf3+Cp4ZdeatZ0cgHegBw@mail.gmail.com>
Subject: Re: linux-next: Tree for July 28 ("copy_from_user_overflow" undefined)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Helge Deller <deller@gmx.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 11:02 AM, Sedat Dilek
<sedat.dilek@googlemail.com> wrote:
> On Fri, Jul 29, 2011 at 7:09 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> On Fri, 29 Jul 2011 03:34:26 +0200 Sedat Dilek wrote:
>>
>>> On Fri, Jul 29, 2011 at 1:01 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>>> > On Thu, 28 Jul 2011 16:05:31 +0200 Sedat Dilek wrote:
>>> >
>>> >> Hi,
>>> >>
>>> >> just see this build-break on the last mile:
>>> >>
>>> >> [...]
>>> >>   OBJCOPY arch/x86/boot/compressed/vmlinux.bin
>>> >>   HOSTCC  arch/x86/boot/compressed/relocs
>>> >>   HOSTCC  arch/x86/boot/compressed/mkpiggy
>>> >> /mnt/sdb3/linux-kernel/linux-3.0/debian/build/source_i386_none/arch/x86/boot/compressed/relocs.c:
>>> >> In function 'print_absolute_symbols':
>>> >> /mnt/sdb3/linux-kernel/linux-3.0/debian/build/source_i386_none/arch/x86/boot/compressed/relocs.c:405:14:
>>> >> warning: variable 'sh_symtab' set but not used
>>> >> [-Wunused-but-set-variable]
>>> >> ERROR: "copy_from_user_overflow" [fs/binfmt_misc.ko] undefined!
>>> >> make[5]: *** [__modpost] Error 1
>>> >> make[4]: *** [modules] Error 2
>>> >> make[4]: *** Waiting for unfinished jobs....
>>> >>   RELOCS  arch/x86/boot/compressed/vmlinux.relocs
>>> >>   GZIP    arch/x86/boot/compressed/vmlinux.bin.gz
>>> >>   MKPIGGY arch/x86/boot/compressed/piggy.S
>>> >>   AS      arch/x86/boot/compressed/piggy.o
>>> >>   LD      arch/x86/boot/compressed/vmlinux
>>> >>   ZOFFSET arch/x86/boot/zoffset.h
>>> >>   OBJCOPY arch/x86/boot/vmlinux.bin
>>> >>   AS      arch/x86/boot/header.o
>>> >>   LD      arch/x86/boot/setup.elf
>>> >>   OBJCOPY arch/x86/boot/setup.bin
>>> >>   BUILD   arch/x86/boot/bzImage
>>> >> Setup is 15596 bytes (padded to 15872 bytes).
>>> >> System is 2471 kB
>>> >> CRC eb598167
>>> >> Kernel: arch/x86/boot/bzImage is ready  (#1)
>>> >> make[3]: *** [sub-make] Error 2
>>> >> make[2]: *** [all] Error 2
>>> >>
>>> >> I have these binfmt kernel-config options set:
>>> >>
>>> >> CONFIG_BINFMT_ELF=y
>>> >> # CONFIG_BINFMT_AOUT is not set
>>> >> CONFIG_BINFMT_MISC=m
>>> >
>>> > How does someone turn off this error message?
>>> >
>>> > I have:
>>> > # CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
>>> > # CONFIG_STRICT_DEVMEM is not set
>>> >
>>> > and I still cannot get this error to go away (on x86_64).
>>> >
>>> >
>>> > ---
>>> > ~Randy
>>> > *** Remember to use Documentation/SubmitChecklist when testing your code ***
>>> >
>>>
>>> Can you say with which linux-next version you saw this first?
>>> My last version was next-20110722 (which was OK).
>>
>> It looks like 2011-0727 has lots of these errors in my randconfig builds,
>> but I can't say that they are all incorrect, so it's not very conclusive.
>>
>> ---
>> ~Randy
>> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>>
>
> I can confirm next-20110726 is fine.
>
> # egrep 'BINFMT|DEBUG_STRICT_USER_COPY_CHECKS|STRICT_DEVMEM'
> /boot/config-3.0.0-next20110726.3-686-small
> CONFIG_BINFMT_ELF=y
> CONFIG_BINFMT_AOUT=m
> CONFIG_BINFMT_MISC=m
> CONFIG_STRICT_DEVMEM=y
> # CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
>
> So, the binfmt_misc culprit was introduced between next-20110726
> (good) and next-20110727 (bad).
> I'll try to look into the diff, but can't promise.
>
> - Sedat -
>

[ CCing all people from 0416 patch ]

OK, here a quick review and looking for suspicious commits:

$ git format-patch next-20110726..next-20110727

487 patches in total.

$ grep copy_from_user_overflow -nr *.patch

0389-x86_64-allmodconfig.patch
0414-Enabling-DEBUG_STRICT_USER_COPY_CHECKS-causes-the-fo.patch
0415-Strict-user-copy-checks-are-only-really-supported-on.patch
0416-The-help-text-for-this-config-is-duplicated-across-t.patch

0416 has thrown out...

-void copy_from_user_overflow(void)
-{
-       WARN(1, "Buffer overflow detected!\n");
-}
-EXPORT_SYMBOL(copy_from_user_overflow);

...and consilidated that in...

--- /dev/null
+++ b/lib/usercopy.c
@@ -0,0 +1,8 @@
+#include <linux/module.h>
+#include <linux/bug.h>
+
+void copy_from_user_overflow(void)
+{
+       WARN(1, "Buffer overflow detected!\n");
+}
+EXPORT_SYMBOL(copy_from_user_overflow);

...BUT builds usercopy.o only on
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS...

-- a/lib/Makefile
+++ b/lib/Makefile
@@ -14,6 +14,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
         proportions.o prio_heap.o ratelimit.o show_mem.o \
         is_single_threaded.o plist.o decompress.o find_next_bit.o

+lib-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o

So, I can rebuild next-201107{27,28} with
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y and look again if the
build-breakage in binfmt_misc is gone.

Any comments from x86 folk?

- Sedat -
