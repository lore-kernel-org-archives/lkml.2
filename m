Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab2EMLi7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 07:38:59 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:32013 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab2EMLi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 07:38:57 -0400
Message-ID: <4FAF9D3F.4010804@snapgear.com>
Date: Sun, 13 May 2012 21:38:39 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        Greg Ungerer <gerg@uclinux.org>, <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 2/4] m68k: Setup CROSS_COMPILE at the top
References: <1336855148-18817-1-git-send-email-geert@linux-m68k.org> <1336855148-18817-2-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1336855148-18817-2-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2012 06:39 AM, Geert Uytterhoeven wrote:
> CROSS_COMPILE must be setup before using e.g. cc-option (and a few other
> as-*, cc-*, ld-* macros), else they will check against the wrong compiler
> when cross-compiling, and may invoke the cross compiler with wrong or
> suboptimal compiler options.
>
> Signed-off-by: Geert Uytterhoeven<geert@linux-m68k.org>
> Cc: Greg Ungerer<gerg@uclinux.org>

Acked-by: Greg Ungerer<gerg@uclinux.org>

Regards
Greg


> Cc: linux-m68k@lists.linux-m68k.org
> ---
>   arch/m68k/Makefile |   13 +++++++------
>   1 files changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/arch/m68k/Makefile b/arch/m68k/Makefile
> index 804f139..b7f2e2d 100644
> --- a/arch/m68k/Makefile
> +++ b/arch/m68k/Makefile
> @@ -16,6 +16,13 @@
>
>   KBUILD_DEFCONFIG := multi_defconfig
>
> +ifneq ($(SUBARCH),$(ARCH))
> +	ifeq ($(CROSS_COMPILE),)
> +		CROSS_COMPILE := $(call cc-cross-prefix, \
> +			m68k-linux-gnu- m68k-linux- m68k-unknown-linux-gnu-)
> +	endif
> +endif
> +
>   #
>   #	Enable processor type. Ordering of these is important - we want to
>   #	use the minimum processor type of the range we support. The logic
> @@ -62,12 +69,6 @@ endif
>
>   LDFLAGS := -m m68kelf
>   KBUILD_LDFLAGS_MODULE += -T $(srctree)/arch/m68k/kernel/module.lds
> -ifneq ($(SUBARCH),$(ARCH))
> -	ifeq ($(CROSS_COMPILE),)
> -		CROSS_COMPILE := $(call cc-cross-prefix, \
> -			m68k-linux-gnu- m68k-linux- m68k-unknown-linux-gnu-)
> -	endif
> -endif
>
>   ifdef CONFIG_SUN3
>   LDFLAGS_vmlinux = -N


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close,                            FAX:         +61 7 3891 3630
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
