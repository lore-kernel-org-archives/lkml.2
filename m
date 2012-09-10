Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab2IJRb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:31:59 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35761 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752001Ab2IJRb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:31:57 -0400
X-Sasl-enc: SEG+d3oiwrskGCsbW1E3+yQ2iAU9T7oO9u66yd6N6Cvu 1347298314
Date: Mon, 10 Sep 2012 10:31:53 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Cotey <puff65537@bansheeslibrary.com>
Subject: Re: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-ID: <20120910173153.GA25033@kroah.com>
References: <20120910170409.59b71819008bc527130d3987@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910170409.59b71819008bc527130d3987@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 05:04:09PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/staging/silicom/bypasslib/built-in.o: In function `.is_bypass':
> (.text+0x3254): multiple definition of `.is_bypass'
> drivers/staging/silicom/bpctl_mod.o:(.text+0x1d938): first defined here
> drivers/staging/silicom/bypasslib/built-in.o: In function `is_bypass':
> (.opd+0x480): multiple definition of `is_bypass'
> drivers/staging/silicom/bpctl_mod.o:(.opd+0x15f0): first defined here
> 
> Caused by commit 7040e556c90a ("staging: add Silicom Bypass driver").
> 
> I added this patch to disable the driver:
> 
> From 884437b30775214e9f34696adb2be2f24f1e6df7 Mon Sep 17 00:00:00 2001
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 10 Sep 2012 17:01:05 +1000
> Subject: [PATCH] staging: disable Silicom Bypass driver
> 
> due to build breakage:
> 
> rivers/staging/silicom/bypasslib/built-in.o: In function `.is_bypass':
> (.text+0x3254): multiple definition of `.is_bypass'
> drivers/staging/silicom/bpctl_mod.o:(.text+0x1d938): first defined here
> drivers/staging/silicom/bypasslib/built-in.o: In function `is_bypass':
> (.opd+0x480): multiple definition of `is_bypass'
> drivers/staging/silicom/bpctl_mod.o:(.opd+0x15f0): first defined here
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/staging/silicom/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/silicom/Kconfig b/drivers/staging/silicom/Kconfig
> index 3493ee8..1914844 100644
> --- a/drivers/staging/silicom/Kconfig
> +++ b/drivers/staging/silicom/Kconfig
> @@ -6,6 +6,7 @@ config NET_VENDOR_SILICOM
>  	bool "Silicom devices"
>  	default y
>  	depends on (SSB_POSSIBLE && HAS_DMA) || PCI 
> +	depends on BROKEN

I think forcing this driver to be a module will resolve this issue.
It seems to be quite a common problem for most staging drivers when they
first land in the tree, sorry for not catching this one.

greg k-h
