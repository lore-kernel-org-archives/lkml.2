Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366Ab2D1Ahj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 20:37:39 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:53297 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757665Ab2D1Ahi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 20:37:38 -0400
Message-ID: <4F9B3BEB.1040805@xenotime.net>
Date: Fri, 27 Apr 2012 17:38:03 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Autif Khan <autif.mlist@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH] drivers: staging: zcache: fix Kconfig crypto dependency
References: <1335231230-29344-1-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1335231230-29344-1-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 06:33 PM, Seth Jennings wrote:

> ZCACHE is a boolean in the Kconfig.  When selected, it
> should require that CRYPTO be builtin (=y).
> 
> Currently, ZCACHE=y and CRYPTO=m is a valid configuration
> when it should not be.
> 
> This patch changes the zcache Kconfig to enforce this
> dependency.
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>


Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  drivers/staging/zcache/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/zcache/Kconfig b/drivers/staging/zcache/Kconfig
> index 3ed2c8f..7048e01 100644
> --- a/drivers/staging/zcache/Kconfig
> +++ b/drivers/staging/zcache/Kconfig
> @@ -2,7 +2,7 @@ config ZCACHE
>  	bool "Dynamic compression of swap pages and clean pagecache pages"
>  	# X86 dependency is because zsmalloc uses non-portable pte/tlb
>  	# functions
> -	depends on (CLEANCACHE || FRONTSWAP) && CRYPTO && X86
> +	depends on (CLEANCACHE || FRONTSWAP) && CRYPTO=y && X86
>  	select ZSMALLOC
>  	select CRYPTO_LZO
>  	default n



-- 
~Randy
