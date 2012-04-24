Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab2DXC1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 22:27:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59771 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236Ab2DXC1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 22:27:07 -0400
Date: Mon, 23 Apr 2012 19:27:02 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Autif Khan <autif.mlist@gmail.com>
Subject: Re: [PATCH] drivers: staging: zcache: fix Kconfig crypto dependency
Message-ID: <20120424022702.GA6573@kroah.com>
References: <1335231230-29344-1-git-send-email-sjenning@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335231230-29344-1-git-send-email-sjenning@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 08:33:50PM -0500, Seth Jennings wrote:
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

Ok, this fixes one of the build problems reported, what about the other
one?

greg k-h
