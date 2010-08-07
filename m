Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762290Ab0HGAeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 20:34:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762280Ab0HGAeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 20:34:01 -0400
Date: Fri, 6 Aug 2010 17:33:20 -0700
From: Greg KH <gregkh@suse.de>
To: David Cross <david.cross@cypress.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] West Bridge Astoria Driver 2.6.35
Message-ID: <20100807003320.GA22459@suse.de>
References: <1281140943.4035.7.camel@odc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281140943.4035.7.camel@odc-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 05:29:03PM -0700, David Cross wrote:
> Re-Re-Re-Re-Re-sending with unnecessary files removed, line wrap turned off in
> new email client, Signed-off-by included in the correct place, and TODO file added.

Looks much better.

I can queue this up in the staging-next tree for the .37 merge, after
the .36 merge window closes, if you don't mind me removing the non
drivers/staging/ file changes here.

Is that ok?

> --- linux-2.6-35-vanilla/arch/arm/mach-omap2/gpmc.c	2010-08-03 14:40:10.000000000 -0700
> +++ linux-2.6-35_incl_sdk/arch/arm/mach-omap2/gpmc.c	2010-08-05 16:50:24.000000000 -0700
> @@ -115,6 +115,7 @@ void gpmc_cs_write_reg(int cs, int idx, 
>  	reg_addr = gpmc_base + GPMC_CS0 + (cs * GPMC_CS_SIZE) + idx;
>  	__raw_writel(val, reg_addr);
>  }
> +EXPORT_SYMBOL(gpmc_cs_write_reg);
>  
>  u32 gpmc_cs_read_reg(int cs, int idx)
>  {
> @@ -123,6 +124,7 @@ u32 gpmc_cs_read_reg(int cs, int idx)
>  	reg_addr = gpmc_base + GPMC_CS0 + (cs * GPMC_CS_SIZE) + idx;
>  	return __raw_readl(reg_addr);
>  }
> +EXPORT_SYMBOL(gpmc_cs_read_reg);
>  
>  /* TODO: Add support for gpmc_fck to clock framework and use it */
>  unsigned long gpmc_get_fclk_period(void)
> @@ -276,6 +278,7 @@ int gpmc_cs_set_timings(int cs, const st
>  
>  	return 0;
>  }
> +EXPORT_SYMBOL(gpmc_cs_set_timings);
>  
>  static void gpmc_cs_enable_mem(int cs, u32 base, u32 size)
>  {

What are these symbols needed for?

Can they be marked EXPORT_SYMBOL_GPL()?

thanks,

greg k-h
