Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab2IIIUN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 04:20:13 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:42041 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab2IIIUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 04:20:08 -0400
MIME-Version: 1.0
In-Reply-To: <1336855148-18817-4-git-send-email-geert@linux-m68k.org>
References: <1336855148-18817-1-git-send-email-geert@linux-m68k.org>
	<1336855148-18817-4-git-send-email-geert@linux-m68k.org>
Date: Sun, 9 Sep 2012 10:20:07 +0200
X-Google-Sender-Auth: aPo3_-bkefMROPaGyIaVxAok62E
Message-ID: <CAMuHMdXi9+vRk2R61qnzGg7p9e7p9DR1C_Ozw6MFCv+YqhSpVg@mail.gmail.com>
Subject: Re: [PATCH 4/4] xtensa: Setup CROSS_COMPILE at the top
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Chris Zankel <chris@zankel.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2012 at 10:39 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> CROSS_COMPILE must be setup before using e.g. cc-option (and a few other
> as-*, cc-*, ld-* macros), else they will check against the wrong compiler
> when cross-compiling, and may invoke the cross compiler with wrong or
> suboptimal compiler options.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Chris Zankel <chris@zankel.net>

Ping?

> ---
>  arch/xtensa/Makefile |   24 ++++++++++++------------
>  1 files changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/arch/xtensa/Makefile b/arch/xtensa/Makefile
> index 7608559..d41f9ed 100644
> --- a/arch/xtensa/Makefile
> +++ b/arch/xtensa/Makefile
> @@ -21,6 +21,18 @@ variant-$(CONFIG_XTENSA_VARIANT_LINUX_CUSTOM)        := custom
>  VARIANT = $(variant-y)
>  export VARIANT
>
> +# Test for cross compiling
> +
> +ifneq ($(VARIANT),)
> +  COMPILE_ARCH = $(shell uname -m)
> +
> +  ifneq ($(COMPILE_ARCH), xtensa)
> +    ifndef CROSS_COMPILE
> +      CROSS_COMPILE = xtensa_$(VARIANT)-
> +    endif
> +  endif
> +endif
> +
>  # Platform configuration
>
>  platform-$(CONFIG_XTENSA_PLATFORM_XT2000)      := xt2000
> @@ -54,18 +66,6 @@ KBUILD_DEFCONFIG := iss_defconfig
>
>  core-$(CONFIG_EMBEDDED_RAMDISK)        += arch/xtensa/boot/ramdisk/
>
> -# Test for cross compiling
> -
> -ifneq ($(VARIANT),)
> -  COMPILE_ARCH = $(shell uname -m)
> -
> -  ifneq ($(COMPILE_ARCH), xtensa)
> -    ifndef CROSS_COMPILE
> -      CROSS_COMPILE = xtensa_$(VARIANT)-
> -    endif
> -  endif
> -endif
> -
>  # Only build variant and/or platform if it includes a Makefile
>
>  buildvar := $(shell test -a $(srctree)/arch/xtensa/variants/$(VARIANT)/Makefile && echo arch/xtensa/variants/$(VARIANT)/)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
