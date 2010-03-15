Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965521Ab0COWzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 18:55:06 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:49132 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937047Ab0COWzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 18:55:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:cc:references:in-reply-to:subject:date:message-id:mime-version
         :content-type:content-transfer-encoding:x-mailer:thread-index
         :content-language;
        b=WcdlhuQe+Ll2daKf8jaHcPGwyMt7p+ZbnvZEFIYcfeXq9Z2fUmF8MftQn4Y+vQb8Bj
         xjw8bZC9nJSoTyijktS/1rQS/lT4JrosR1dVXnw+CyInQQ8s7njzDCv7O+RAh8f519Oa
         2mXclW7hRhmHhCSm4m3vUDjD7OoSZBhLHWxj4=
From: "Will L Givens" <wlgivens@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-alpha@vger.kernel.org>
References: <4B9DDCD8.4070902@orcon.net.nz> <20100315192321I.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100315192321I.fujita.tomonori@lab.ntt.co.jp>
Subject: RE: Alpha:  Compilation error 2.6.34-rc1 git a3d3203e4b
Date: Mon, 15 Mar 2010 17:54:43 -0500
Message-ID: <001201cac492$82380860$86a81920$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcrEKaS8QOibpTQmTdyEOBuI+8I59QAZ1bJQ
Content-Language: en-us
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-alpha-owner@vger.kernel.org [mailto:linux-alpha-
> owner@vger.kernel.org] On Behalf Of FUJITA Tomonori
> Sent: Monday, March 15, 2010 05:24
> To: mcree@orcon.net.nz
> Cc: linux-kernel@vger.kernel.org; linux-alpha@vger.kernel.org;
> akpm@linux-foundation.org
> Subject: Re: Alpha: Compilation error 2.6.34-rc1 git a3d3203e4b
> 
> On Mon, 15 Mar 2010 20:08:08 +1300
> Michael Cree <mcree@orcon.net.nz> wrote:
> 
> > I note that for_each_sg is defined in include/linux/scatterlist.h,
> which
> > arch/alpha/include/asm/dma-mapping.h attempts to load, however
> > include/linux/scatterlist.h was the one that included (indirectly)
> > arch/alpha/include/asm/dma-mapping.h.  There is therefore a complete
> > loop of includes from include/linux/scatterlist.h back to itself.
> 
> Very sorry about that. Seems that I broke CONFIG_ALPHA_{TSUNAMI,
> TITAN, RAWHIDE, MARVEL}.
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] alpha: fix compile errors in dma-mapping-common.h
> 
> The commit c186caca3dbe7f44da624cb4f9d78e1b1dfb13b8 leads to the
> following errors with CONFIG_ALPHA_{TSUNAMI, TITAN, RAWHIDE, MARVEL}:
> 
> /home/fujita/git/linux-2.6/include/asm-generic/dma-mapping-common.h: In
> function `dma_map_sg_attrs':
> /home/fujita/git/linux-2.6/include/asm-generic/dma-mapping-common.h:49:
> error: implicit declaration of function `for_each_sg'
> /home/fujita/git/linux-2.6/include/asm-generic/dma-mapping-common.h:50:
> error: syntax error before "kmemcheck_mark_initialized"
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Reported-by: Michael Cree <mcree@orcon.net.nz>
> ---
>  arch/alpha/include/asm/core_marvel.h  |    1 -
>  arch/alpha/include/asm/core_mcpcia.h  |    1 -
>  arch/alpha/include/asm/core_titan.h   |    1 -
>  arch/alpha/include/asm/core_tsunami.h |    1 -
>  4 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/alpha/include/asm/core_marvel.h
> b/arch/alpha/include/asm/core_marvel.h
> index 30d55fe..dad300f 100644
> --- a/arch/alpha/include/asm/core_marvel.h
> +++ b/arch/alpha/include/asm/core_marvel.h
> @@ -12,7 +12,6 @@
>  #define __ALPHA_MARVEL__H__
> 
>  #include <linux/types.h>
> -#include <linux/pci.h>
>  #include <linux/spinlock.h>
> 
>  #include <asm/compiler.h>
> diff --git a/arch/alpha/include/asm/core_mcpcia.h
> b/arch/alpha/include/asm/core_mcpcia.h
> index acf55b4..21ac533 100644
> --- a/arch/alpha/include/asm/core_mcpcia.h
> +++ b/arch/alpha/include/asm/core_mcpcia.h
> @@ -6,7 +6,6 @@
>  #define MCPCIA_ONE_HAE_WINDOW 1
> 
>  #include <linux/types.h>
> -#include <linux/pci.h>
>  #include <asm/compiler.h>
> 
>  /*
> diff --git a/arch/alpha/include/asm/core_titan.h
> b/arch/alpha/include/asm/core_titan.h
> index a17f6f3..8cf79d1 100644
> --- a/arch/alpha/include/asm/core_titan.h
> +++ b/arch/alpha/include/asm/core_titan.h
> @@ -2,7 +2,6 @@
>  #define __ALPHA_TITAN__H__
> 
>  #include <linux/types.h>
> -#include <linux/pci.h>
>  #include <asm/compiler.h>
> 
>  /*
> diff --git a/arch/alpha/include/asm/core_tsunami.h
> b/arch/alpha/include/asm/core_tsunami.h
> index 58d4fe4..8e39ecf 100644
> --- a/arch/alpha/include/asm/core_tsunami.h
> +++ b/arch/alpha/include/asm/core_tsunami.h
> @@ -2,7 +2,6 @@
>  #define __ALPHA_TSUNAMI__H__
> 
>  #include <linux/types.h>
> -#include <linux/pci.h>
>  #include <asm/compiler.h>
> 
>  /*
> --
> 1.7.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-alpha"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks for the patch... now it brings me right back the same error I get
with the release 'stable' and 'git snapshot, respectfully 2.33.1 and
2.6.34-rc1. I've tried several different builds of GCC (3.2.3, 3.4.3, 4.3.4,
4.4.2) and various releases of binutils (2.15 - no go, 2.17.90, and 2.20.1).
This was after several failed builds after adjusting the CFLAGS and adding
either -Wl,--no-relax and -relax.

[root@jericho linux]# as -v
GNU assembler version 2.20.1 (alphaev5-alpha-linux) using BFD version (GNU
Binutils) 2.20.1.20100303

[root@jericho linux]# gcc-3.4.3 -v
Reading specs from /usr/lib/gcc/alphaev5-alpha-linux/3.4.3/specs
Configured with: ../gcc-3.4.3/configure --prefix=/usr --sysconfdir=/etc
--mandir=/usr/share/man --infodir=/usr/share/info
--build=alphaev5-alpha-linux --host=alphaev5-alpha-linux
--target=alphaev5-alpha-linux --program-suffix=-3.4.3 --enable-languages=all

Thread model: posix
gcc version 3.4.3
[root@jericho linux]# make -v
GNU Make 3.80
Copyright (C) 2002  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

gcc-3.4.3 -Wp,-MD,arch/alpha/lib/.__remqu.o.d  -nostdinc -isystem
/usr/lib/gcc/alphaev5-alpha-linux/3.4.3/include
-I/usr/src/linux-2.6.34-rc1/arch/alpha/include -Iinclude  -include
include/generated/autoconf.h -D__KERNEL__ -D__ASSEMBLY__    -Wall -Wundef
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common
-Werror-implicit-function-declaration -Wno-format-security
-fno-delete-null-pointer-checks -pipe -Os -pipe -mno-fp-regs -ffixed-8
-msmall-data  -mcpu=ev67 -Wa,-mev6   -fomit-frame-pointer
-Wdeclaration-after-statement     -DREM  -c -o arch/alpha/lib/__remqu.o
arch/alpha/lib/ev6-divide.S
  AS      arch/alpha/lib/callback_srm.o
  CC      arch/alpha/lib/checksum.o
  CC      arch/alpha/lib/csum_partial_copy.o
  AS      arch/alpha/lib/ev6-clear_page.o
  AS      arch/alpha/lib/ev6-clear_user.o
  AS      arch/alpha/lib/ev6-copy_page.o
  AS      arch/alpha/lib/ev6-copy_user.o
  AS      arch/alpha/lib/ev6-csum_ipv6_magic.o
  AS      arch/alpha/lib/ev6-memchr.o
  AS      arch/alpha/lib/ev6-memcpy.o
  AS      arch/alpha/lib/ev6-memset.o
  AS      arch/alpha/lib/ev6-strncpy_from_user.o
  AS      arch/alpha/lib/ev6-stxcpy.o
  AS      arch/alpha/lib/ev6-stxncpy.o
  AS      arch/alpha/lib/ev67-strcat.o
  AS      arch/alpha/lib/ev67-strchr.o
  AS      arch/alpha/lib/ev67-strlen.o
  AS      arch/alpha/lib/ev67-strlen_user.o
  AS      arch/alpha/lib/ev67-strncat.o
  AS      arch/alpha/lib/ev67-strrchr.o
  CC      arch/alpha/lib/fls.o
  CC      arch/alpha/lib/fpreg.o
  AS      arch/alpha/lib/memmove.o
  CC      arch/alpha/lib/srm_printk.o
  CC      arch/alpha/lib/srm_puts.o
  AS      arch/alpha/lib/strcpy.o
  AS      arch/alpha/lib/strncpy.o
  CC      arch/alpha/lib/udelay.o
  AR      arch/alpha/lib/lib.a
  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: modpost: Found 1 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
kernel/built-in.o: In function `kthread_create':
(.text+0x1ece4): relocation truncated to fit: GPREL16 against symbol
`kthreadd_task' defined in .sbss section in kernel/built-in.o
kernel/built-in.o: In function `check_cpu_itimer':
(.text+0x21784): relocation truncated to fit: GPREL16 against `.sbss'
kernel/built-in.o: In function `check_cpu_itimer':
(.text+0x2179c): relocation truncated to fit: GPREL16 against `.sbss'
kernel/built-in.o: In function `free_nsproxy':
(.text+0x23064): relocation truncated to fit: GPREL16 against `.sbss'
kernel/built-in.o: In function `create_new_namespaces':
(.text+0x230a4): relocation truncated to fit: GPREL16 against `.sbss'
kernel/built-in.o: In function `create_new_namespaces':
(.text+0x23254): relocation truncated to fit: GPREL16 against `.sbss'
kernel/built-in.o: In function `notify_die':
(.text+0x2413c): relocation truncated to fit: GPREL16 against `.sbss'
kernel/built-in.o: In function `register_die_notifier':
(.text+0x241a4): relocation truncated to fit: GPREL16 against `.sbss'
kernel/built-in.o: In function `unregister_die_notifier':
(.text+0x241bc): relocation truncated to fit: GPREL16 against `.sbss'
kernel/built-in.o: In function `sched_clock_init':
(.text+0x24ba4): relocation truncated to fit: GPREL16 against `.sbss'
kernel/built-in.o: In function `sched_clock_cpu':
(.text+0x24bb4): additional relocation overflows omitted from the output
make: *** [.tmp_vmlinux1] Error 1
[root@jericho linux]#


