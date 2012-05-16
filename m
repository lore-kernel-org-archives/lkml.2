Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901Ab2EPRNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 13:13:15 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60012 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758514Ab2EPRNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 13:13:12 -0400
Message-ID: <4FB3DFDB.80605@linux.vnet.ibm.com>
Date: Wed, 16 May 2012 12:11:55 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/3] remove dependency with x86
References: <1337133919-4182-1-git-send-email-minchan@kernel.org> <1337133919-4182-2-git-send-email-minchan@kernel.org>
In-Reply-To: <1337133919-4182-2-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051617-9360-0000-0000-0000066727E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 09:05 PM, Minchan Kim wrote:

> Exactly saying, [zram|zcache] should has a dependency with
> zsmalloc, not x86. So replace x86 dependeny with ZSMALLOC.
> 
> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  drivers/staging/zcache/Kconfig |    3 +--
>  drivers/staging/zram/Kconfig   |    3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/zcache/Kconfig b/drivers/staging/zcache/Kconfig
> index 7048e01..ceb7f28 100644
> --- a/drivers/staging/zcache/Kconfig
> +++ b/drivers/staging/zcache/Kconfig
> @@ -2,8 +2,7 @@ config ZCACHE
>  	bool "Dynamic compression of swap pages and clean pagecache pages"
>  	# X86 dependency is because zsmalloc uses non-portable pte/tlb
>  	# functions
> -	depends on (CLEANCACHE || FRONTSWAP) && CRYPTO=y && X86
> -	select ZSMALLOC
> +	depends on (CLEANCACHE || FRONTSWAP) && CRYPTO=y && ZSMALLOC


Sorry Minchan, I should have said this the first time around.  I ran
into this issue before with CRYTPO vs CRYPTO=y.  ZCACHE is a bool where
ZSMALLOC is a tristate.  It is not sufficient for ZSMALLOC to be set; it
_must_ be builtin, otherwise you get linker errors.

The dependency should be ZSMALLOC=y.

Thanks,
Seth

