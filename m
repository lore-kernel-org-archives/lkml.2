Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab2F2Qg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:36:57 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:46080 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab2F2Qgz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:36:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120628082009.GC21764@linux-sh.org>
References: <1340740795-19603-1-git-send-email-geert@linux-m68k.org>
	<CAMuHMdXY1DFNV+jTiJkT99TbX7ZL5eEiKcG0iqZkUa8T7YZG4g@mail.gmail.com>
	<20120628082009.GC21764@linux-sh.org>
Date: Fri, 29 Jun 2012 18:36:53 +0200
X-Google-Sender-Auth: Eh9zohO4xK2WxA0O4C4gUM9uKko
Message-ID: <CAMuHMdX_C1u_FsG4ZTrK8T2HNb7Tu84u6xOL4Z5Z5txpkNnZdQ@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.5-rc4
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org, Linux-sh list <linux-sh@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Thu, Jun 28, 2012 at 10:20 AM, Paul Mundt <lethal@linux-sh.org> wrote:
> On Tue, Jun 26, 2012 at 10:06:27PM +0200, Geert Uytterhoeven wrote:
>> On Tue, Jun 26, 2012 at 9:59 PM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>> > JFYI, when comparing v3.5-rc4 to v3.5-rc3[3], the summaries are:
>> > ??- build errors: +11/-219
>>
>> 11 regressions:
>>   + arch/sh/include/asm/fixmap.h: error: implicit declaration of
>> function 'BUG_ON' [-Werror=implicit-function-declaration]:  => 133:2
>>   + arch/sh/include/asm/thread_info.h: error: implicit declaration of
>> function 'WARN_ON' [-Werror=implicit-function-declaration]:  => 172:2
>>   + include/linux/huge_mm.h: error: implicit declaration of function
>> 'BUG' [-Werror=implicit-function-declaration]:  => 185:2
>>
>> shmin_defconfig, se7712_defconfig, se7721_defconfig, sh-allnoconfig
>>
> I'm unable to reproduce any of these, is there some specific compiler
> version or warning flag configuration I'm supposed to be using? I'm
> building with 4.5.1 at the moment.

Mine (from Tony) is:

sh4-linux-gcc -v
Using built-in specs.
COLLECT_GCC=/usr/local/gcc-4.6.3-nolibc/sh4-linux/bin/sh4-linux-gcc
COLLECT_LTO_WRAPPER=/usr/local/gcc-4.6.3-nolibc/sh4-linux/bin/../libexec/gcc/sh4-linux/4.6.3/lto-wrapper
Target: sh4-linux
Configured with: /home/tony/buildall/src/gcc/configure
--target=sh4-linux --host=x86_64-linux-gnu --build=x86_64-linux-gnu
--enable-targets=all --prefix=/opt/cross/gcc-4.6.3-nolibc/sh4-linux/
--enable-languages=c --with-newlib --without-headers --disable-nls
--disable-threads --disable-shared --disable-libmudflap
--disable-libssp --disable-libgomp --disable-decimal-float
--enable-checking=release --with-multilib-list=m4,m4-nofpu
--with-mpfr=/home/tony/buildall/src/sys-x86_64
--with-gmp=/home/tony/buildall/src/sys-x86_64 --disable-bootstrap
--disable-libquadmath
Thread model: single
gcc version 4.6.3 (GCC)

Using v3.5-rc4:

se7721_defconfig:

sh4-linux-gcc -Wp,-MD,arch/sh/kernel/.asm-offsets.s.d  -nostdinc
-isystem /usr/local/gcc-4.6.3-nolibc/sh4-linux/bin/../lib/gcc/sh4-linux/4.6.3/include
-Iarch/sh/include -Iarch/sh/include/generated -Iinclude  -include
include/linux/kconfig.h -D__KERNEL__ -m4-nofpu -ml -Wa,-isa=any
-ffreestanding -Iarch/sh/include/cpu-sh3 -Iarch/sh/include/cpu-common
-Iarch/sh/include/mach-se -Iarch/sh/include/mach-common -Wall -Wundef
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common
-Werror-implicit-function-declaration -Wno-format-security
-fno-delete-null-pointer-checks -O2 -pipe -m4-nofpu -ml -Wa,-isa=any
-ffreestanding -Iarch/sh/include/cpu-sh3 -Iarch/sh/include/cpu-common
-Iarch/sh/include/mach-se -Iarch/sh/include/mach-common
-Wframe-larger-than=1024 -fno-stack-protector
-Wno-unused-but-set-variable -fno-omit-frame-pointer
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement
-Wno-pointer-sign -fno-strict-overflow -fconserve-stack
-DCC_HAVE_ASM_GOTO    -D"KBUILD_STR(s)=#s"
-D"KBUILD_BASENAME=KBUILD_STR(asm_offsets)"
-D"KBUILD_MODNAME=KBUILD_STR(asm_offsets)" -fverbose-asm -S -o
arch/sh/kernel/asm-offsets.s arch/sh/kernel/asm-offsets.c
In file included from include/linux/thread_info.h:54:0,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from arch/sh/kernel/asm-offsets.c:13:
arch/sh/include/asm/thread_info.h: In function 'set_restore_sigmask':
arch/sh/include/asm/thread_info.h:172:2: error: implicit declaration
of function 'WARN_ON' [-Werror=implicit-function-declaration]
In file included from arch/sh/include/asm/pgtable.h:25:0,
                 from include/linux/mm.h:44,
                 from arch/sh/kernel/asm-offsets.c:13:
arch/sh/include/asm/fixmap.h: In function 'virt_to_fix':
arch/sh/include/asm/fixmap.h:133:2: error: implicit declaration of
function 'BUG_ON' [-Werror=implicit-function-declaration]
In file included from arch/sh/include/asm/pgtable.h:164:0,
                 from include/linux/mm.h:44,
                 from arch/sh/kernel/asm-offsets.c:13:
include/asm-generic/pgtable.h: In function 'pmdp_test_and_clear_young':
include/asm-generic/pgtable.h:56:2: error: implicit declaration of
function 'BUG' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[1]: *** [arch/sh/kernel/asm-offsets.s] Error 1


allnoconfig:

sh4-linux-gcc -Wp,-MD,arch/sh/kernel/.asm-offsets.s.d  -nostdinc
-isystem /usr/local/gcc-4.6.3-nolibc/sh4-linux/bin/../lib/gcc/sh4-linux/4.6.3/include
-Iarch/sh/include -Iarch/sh/include/generated -Iinclude  -include
include/linux/kconfig.h -D__KERNEL__ -m4-nofpu -ml -Wa,-isa=any
-ffreestanding -Iarch/sh/include/cpu-sh2 -Iarch/sh/include/cpu-common
-Iarch/sh/include/mach-common -Wall -Wundef -Wstrict-prototypes
-Wno-trigraphs -fno-strict-aliasing -fno-common
-Werror-implicit-function-declaration -Wno-format-security
-fno-delete-null-pointer-checks -O2 -pipe -m4-nofpu -ml -Wa,-isa=any
-ffreestanding -Iarch/sh/include/cpu-sh2 -Iarch/sh/include/cpu-common
-Iarch/sh/include/mach-common -Wframe-larger-than=1024
-fno-stack-protector -Wno-unused-but-set-variable -fomit-frame-pointer
-Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow
-fconserve-stack -DCC_HAVE_ASM_GOTO    -D"KBUILD_STR(s)=#s"
-D"KBUILD_BASENAME=KBUILD_STR(asm_offsets)"
-D"KBUILD_MODNAME=KBUILD_STR(asm_offsets)" -fverbose-asm -S -o
arch/sh/kernel/asm-offsets.s arch/sh/kernel/asm-offsets.c
In file included from include/linux/thread_info.h:54:0,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from arch/sh/kernel/asm-offsets.c:13:
arch/sh/include/asm/thread_info.h: In function 'set_restore_sigmask':
arch/sh/include/asm/thread_info.h:172:2: error: implicit declaration
of function 'WARN_ON' [-Werror=implicit-function-declaration]
In file included from arch/sh/include/asm/pgtable.h:25:0,
                 from include/linux/mm.h:44,
                 from arch/sh/kernel/asm-offsets.c:13:
arch/sh/include/asm/fixmap.h: In function 'virt_to_fix':
arch/sh/include/asm/fixmap.h:133:2: error: implicit declaration of
function 'BUG_ON' [-Werror=implicit-function-declaration]
In file included from include/linux/mm.h:257:0,
                 from arch/sh/kernel/asm-offsets.c:13:
include/linux/huge_mm.h: In function 'hugepage_madvise':
include/linux/huge_mm.h:185:2: error: implicit declaration of function
'BUG' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[1]: *** [arch/sh/kernel/asm-offsets.s] Error 1

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
