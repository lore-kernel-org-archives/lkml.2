Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab0IHAZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 20:25:36 -0400
Received: from kroah.org ([198.145.64.141]:51491 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757064Ab0IHAZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 20:25:27 -0400
Date: Tue, 7 Sep 2010 16:58:00 -0700
From: Greg KH <greg@kroah.com>
To: David Cross <david.cross@cypress.com>
Cc: tony@atomide.com, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] gpmc, EXPORT_SYMBOLS, west bridge related
Message-ID: <20100907235800.GD12823@kroah.com>
References: <1283887607.7250.10.camel@odc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283887607.7250.10.camel@odc-laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 12:26:47PM -0700, David Cross wrote:
> This patch exports some of the gpmc driver functions in OMAP3. The purpose behind this patch 
> is to allow device drivers compiled as loadable modules to be interfaced to the GPMC. I am
> hoping that Tony is the correct maintainer and willing to ACK this change. Please let me know 
> if there are any issues or concerns with this patch.
> Thanks,
> David
> 
> Signed-off-by: David Cross <david.cross@cypress.com>
> 
> diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/arch/arm/mach-omap2/gpmc.c linux-next-incl-sdk/arch/arm/mach-omap2/gpmc.c
> --- linux-next-vanilla/arch/arm/mach-omap2/gpmc.c	2010-08-31 19:32:51.000000000 -0700
> +++ linux-next-incl-sdk/arch/arm/mach-omap2/gpmc.c	2010-09-01 16:10:21.000000000 -0700
> @@ -133,6 +133,7 @@ void gpmc_cs_write_reg(int cs, int idx, 
>  	reg_addr = gpmc_base + GPMC_CS0_OFFSET + (cs * GPMC_CS_SIZE) + idx;
>  	__raw_writel(val, reg_addr);
>  }
> +EXPORT_SYMBOL(gpmc_cs_write_reg);

EXPORT_SYMBOL_GPL() perhaps?

What about platforms that don't have this symbol, how will the driver
build properly then?  Shouldn't something like this be in a arch-neutral
place in the kernel tree?

thanks,

greg k-h
