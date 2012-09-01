Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab2IANOJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 09:14:09 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40243 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab2IANOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 09:14:07 -0400
Date: Sat, 1 Sep 2012 09:14:42 -0400
From: Matt Porter <mporter@ti.com>
To: Vinod Koul <vkoul@infradead.org>
Cc: Sekhar Nori <nsekhar@ti.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        vinod.koul@intel.com, Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        grant.likely@secretlab.ca,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        cjb@laptop.org,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 3/3] spi: spi-davinci: convert to DMA engine API
Message-ID: <20120901131442.GE27758@beef>
References: <1345684176-21472-1-git-send-email-mporter@ti.com>
 <1345684176-21472-4-git-send-email-mporter@ti.com>
 <503F75C0.1050507@ti.com>
 <20120830144307.GA26737@beef>
 <5040E00A.3080600@ti.com>
 <1346430709.15463.15.camel@vkoul-mobl4>
 <5040E6C7.6030106@ti.com>
 <1346432577.15463.16.camel@vkoul-mobl4>
 <1346461349.2806.4.camel@vkoul-mobl4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346461349.2806.4.camel@vkoul-mobl4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 01, 2012 at 06:32:29AM +0530, Vinod Koul wrote:
> On Fri, 2012-08-31 at 22:32 +0530, Vinod Koul wrote:
> > On Fri, 2012-08-31 at 22:01 +0530, Sekhar Nori wrote:
> > > >> Yes, this was the problem. Since the SPI driver now depends on
> > > >> CONFIG_TI_EDMA for basic operation may be select CONFIG_TI_EDMA in
> > > >> Kconfig if SPI is enabled? That should do until the fallback to PIO
> > > is
> > > >> implemented.
> > > > Then this should be enabled for SPI. Care to send a patch
> > > 
> > > By 'this' you mean the Kconfig select? Then there should be no need of
> > > a
> > > new patch for this. It can be part of this patch itself, no? 
> > Either way is okay for me.
> And am in good mood :)

I am as well...thanks for taking care of the patch to address the Kconfig
issue and applying. It's nice to return from holiday and not have to do
anything with this series. :)

-Matt

> Applied all with this as well
> 
> >From b5f14330590118e6a0659255476c0f24ab681e05 Mon Sep 17 00:00:00 2001
> From: Vinod Koul <vinod.koul@linux.intel.com>
> Date: Sat, 1 Sep 2012 06:29:22 +0530
> Subject: [PATCH] spi: davici - make davinci select edma
> 
> Reported-by: Sekhar Nori <nsekhar@ti.com>
> Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
> ---
>  drivers/spi/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
> index 5f84b55..b9fb9a1 100644
> --- a/drivers/spi/Kconfig
> +++ b/drivers/spi/Kconfig
> @@ -134,6 +134,7 @@ config SPI_DAVINCI
>  	tristate "Texas Instruments DaVinci/DA8x/OMAP-L/AM1x SoC SPI
> controller"
>  	depends on ARCH_DAVINCI
>  	select SPI_BITBANG
> +	select TI_EDMA
>  	help
>  	  SPI master controller for DaVinci/DA8x/OMAP-L/AM1x SPI modules.
>  
> -- 
> 1.7.9.5
> 
> 
> 
> -- 
> ~Vinod Koul
> Intel Corp.
> 
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
