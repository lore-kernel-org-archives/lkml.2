Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937139Ab0COXJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 19:09:42 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:2098 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937102Ab0COXJl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 19:09:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OQp9sWV1QWkwxpxQ41OFAIRq2wSGeWbzyMBWh4SU0DZG+Xlt2VSgOCOi5eAfypjIGf
         2tZWdQpiwfO6J+kos1tbfBTdAQs/9zKDOIzjknKVXO5Eb3vS9h9PgAlCnr9aiac80m77
         JqudbfcYE45c7WnM/KgcirbIy0xlU6SkpV5Mk=
MIME-Version: 1.0
Date: Mon, 15 Mar 2010 19:09:40 -0400
Message-ID: <b4198de61003151609je8a94ceyf6dd39acfd1a5876@mail.gmail.com>
Subject: Will's kernel compilation error
From: Matt Turner <mattst88@gmail.com>
To: Will L Givens <wlgivens@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your email was entirely unrelated to the previous thread, so I split it off.

On Mon, Mar 15, 2010 at 6:54 PM, Will L Givens <wlgivens@gmail.com> wrote:
> Thanks for the patch... now it brings me right back the same error I get
> with the release 'stable' and 'git snapshot, respectfully 2.33.1 and
> 2.6.34-rc1. I've tried several different builds of GCC (3.2.3, 3.4.3, 4.3.4,
> 4.4.2) and various releases of binutils (2.15 - no go, 2.17.90, and 2.20.1).
> This was after several failed builds after adjusting the CFLAGS and adding
> either -Wl,--no-relax and -relax.

If you can reproduce this with such a wide variety versions, send your
.config and I'll see if I can reproduce it locally.

> [root@jericho linux]# as -v
> GNU assembler version 2.20.1 (alphaev5-alpha-linux) using BFD version (GNU
> Binutils) 2.20.1.20100303
>
> [root@jericho linux]# gcc-3.4.3 -v
> Reading specs from /usr/lib/gcc/alphaev5-alpha-linux/3.4.3/specs
> Configured with: ../gcc-3.4.3/configure --prefix=/usr --sysconfdir=/etc
> --mandir=/usr/share/man --infodir=/usr/share/info
> --build=alphaev5-alpha-linux --host=alphaev5-alpha-linux
> --target=alphaev5-alpha-linux --program-suffix=-3.4.3 --enable-languages=all
>
> Thread model: posix
> gcc version 3.4.3
> [root@jericho linux]# make -v
> GNU Make 3.80
> Copyright (C) 2002  Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.
> There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
> PARTICULAR PURPOSE.
>
> gcc-3.4.3 -Wp,-MD,arch/alpha/lib/.__remqu.o.d  -nostdinc -isystem
> /usr/lib/gcc/alphaev5-alpha-linux/3.4.3/include
> -I/usr/src/linux-2.6.34-rc1/arch/alpha/include -Iinclude  -include
> include/generated/autoconf.h -D__KERNEL__ -D__ASSEMBLY__    -Wall -Wundef
> -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common
> -Werror-implicit-function-declaration -Wno-format-security
> -fno-delete-null-pointer-checks -pipe -Os -pipe -mno-fp-regs -ffixed-8
> -msmall-data  -mcpu=ev67 -Wa,-mev6   -fomit-frame-pointer
> -Wdeclaration-after-statement     -DREM  -c -o arch/alpha/lib/__remqu.o
> arch/alpha/lib/ev6-divide.S

Why is your CHOST alphaev5-alpha-linux but you're compiling for EV67?

>  AS      arch/alpha/lib/callback_srm.o
>  CC      arch/alpha/lib/checksum.o
>  CC      arch/alpha/lib/csum_partial_copy.o
>  AS      arch/alpha/lib/ev6-clear_page.o
>  AS      arch/alpha/lib/ev6-clear_user.o
>  AS      arch/alpha/lib/ev6-copy_page.o
>  AS      arch/alpha/lib/ev6-copy_user.o
>  AS      arch/alpha/lib/ev6-csum_ipv6_magic.o
>  AS      arch/alpha/lib/ev6-memchr.o
>  AS      arch/alpha/lib/ev6-memcpy.o
>  AS      arch/alpha/lib/ev6-memset.o
>  AS      arch/alpha/lib/ev6-strncpy_from_user.o
>  AS      arch/alpha/lib/ev6-stxcpy.o
>  AS      arch/alpha/lib/ev6-stxncpy.o
>  AS      arch/alpha/lib/ev67-strcat.o
>  AS      arch/alpha/lib/ev67-strchr.o
>  AS      arch/alpha/lib/ev67-strlen.o
>  AS      arch/alpha/lib/ev67-strlen_user.o
>  AS      arch/alpha/lib/ev67-strncat.o
>  AS      arch/alpha/lib/ev67-strrchr.o
>  CC      arch/alpha/lib/fls.o
>  CC      arch/alpha/lib/fpreg.o
>  AS      arch/alpha/lib/memmove.o
>  CC      arch/alpha/lib/srm_printk.o
>  CC      arch/alpha/lib/srm_puts.o
>  AS      arch/alpha/lib/strcpy.o
>  AS      arch/alpha/lib/strncpy.o
>  CC      arch/alpha/lib/udelay.o
>  AR      arch/alpha/lib/lib.a
>  LD      vmlinux.o
>  MODPOST vmlinux.o
> WARNING: modpost: Found 1 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>  GEN     .version
>  CHK     include/generated/compile.h
>  UPD     include/generated/compile.h
>  CC      init/version.o
>  LD      init/built-in.o
>  LD      .tmp_vmlinux1
> kernel/built-in.o: In function `kthread_create':
> (.text+0x1ece4): relocation truncated to fit: GPREL16 against symbol
> `kthreadd_task' defined in .sbss section in kernel/built-in.o
> kernel/built-in.o: In function `check_cpu_itimer':
> (.text+0x21784): relocation truncated to fit: GPREL16 against `.sbss'
> kernel/built-in.o: In function `check_cpu_itimer':
> (.text+0x2179c): relocation truncated to fit: GPREL16 against `.sbss'
> kernel/built-in.o: In function `free_nsproxy':
> (.text+0x23064): relocation truncated to fit: GPREL16 against `.sbss'
> kernel/built-in.o: In function `create_new_namespaces':
> (.text+0x230a4): relocation truncated to fit: GPREL16 against `.sbss'
> kernel/built-in.o: In function `create_new_namespaces':
> (.text+0x23254): relocation truncated to fit: GPREL16 against `.sbss'
> kernel/built-in.o: In function `notify_die':
> (.text+0x2413c): relocation truncated to fit: GPREL16 against `.sbss'
> kernel/built-in.o: In function `register_die_notifier':
> (.text+0x241a4): relocation truncated to fit: GPREL16 against `.sbss'
> kernel/built-in.o: In function `unregister_die_notifier':
> (.text+0x241bc): relocation truncated to fit: GPREL16 against `.sbss'
> kernel/built-in.o: In function `sched_clock_init':
> (.text+0x24ba4): relocation truncated to fit: GPREL16 against `.sbss'
> kernel/built-in.o: In function `sched_clock_cpu':
> (.text+0x24bb4): additional relocation overflows omitted from the output
> make: *** [.tmp_vmlinux1] Error 1
