Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964951Ab2EOOhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:37:24 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52301 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964815Ab2EOOhU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:37:20 -0400
MIME-Version: 1.0
Reply-To: konrad@darnok.org
In-Reply-To: <4FB1BFFC.8080405@kernel.org>
References: <1336985134-31967-1-git-send-email-minchan@kernel.org>
	<1336985134-31967-2-git-send-email-minchan@kernel.org>
	<4FB119CA.2080606@linux.vnet.ibm.com>
	<4FB1BFFC.8080405@kernel.org>
Date: Tue, 15 May 2012 10:37:19 -0400
X-Google-Sender-Auth: 5hDH95SwK-MUCRWoh2JKTsmaD64
Message-ID: <CAPbh3rvOKvo5cxVR5f35xAmzJ_uoR+SO2dzoJzvLi4mMnm-DZQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] zram: remove comment in Kconfig
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> == CUT_HERE ==
>
> >From be81aec5a4f35139aae2bf3d18139fbc114897ca Mon Sep 17 00:00:00 2001
> From: Minchan Kim <minchan@kernel.org>
> Date: Tue, 15 May 2012 11:26:48 +0900
> Subject: [PATCH] [zram,zcache] remove dependency with x86
>
> Exactly saying, [zram|zcache] should has a dependency with
> zsmalloc, not x86. So replace x86 dependeny with ZSMALLOC.
>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

> ---
>  drivers/staging/zcache/Kconfig |    3 +--
>  drivers/staging/zram/Kconfig   |    3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/zcache/Kconfig b/drivers/staging/zcache/Kconfig
> index 7048e01..ceb7f28 100644
> --- a/drivers/staging/zcache/Kconfig
> +++ b/drivers/staging/zcache/Kconfig
> @@ -2,8 +2,7 @@ config ZCACHE
>        bool "Dynamic compression of swap pages and clean pagecache pages"
>        # X86 dependency is because zsmalloc uses non-portable pte/tlb
>        # functions
> -       depends on (CLEANCACHE || FRONTSWAP) && CRYPTO=y && X86
> -       select ZSMALLOC
> +       depends on (CLEANCACHE || FRONTSWAP) && CRYPTO=y && ZSMALLOC
>        select CRYPTO_LZO
>        default n
>        help
> diff --git a/drivers/staging/zram/Kconfig b/drivers/staging/zram/Kconfig
> index 9d11a4c..e3ac62d 100644
> --- a/drivers/staging/zram/Kconfig
> +++ b/drivers/staging/zram/Kconfig
> @@ -2,8 +2,7 @@ config ZRAM
>        tristate "Compressed RAM block device support"
>        # X86 dependency is because zsmalloc uses non-portable pte/tlb
>        # functions
> -       depends on BLOCK && SYSFS && X86
> -       select ZSMALLOC
> +       depends on BLOCK && SYSFS && ZSMALLOC
>        select LZO_COMPRESS
>        select LZO_DECOMPRESS
>        default n
> --
> 1.7.9.5
>
>
>
> --
> Kind regards,
> Minchan Kim
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
