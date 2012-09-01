Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab2IAAzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 20:55:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41932 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab2IAAzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 20:55:18 -0400
Message-ID: <1346461349.2806.4.camel@vkoul-mobl4>
Subject: Re: [PATCH v3 3/3] spi: spi-davinci: convert to DMA engine API
From: Vinod Koul <vkoul@infradead.org>
To: Sekhar Nori <nsekhar@ti.com>
Cc: vinod.koul@intel.com, Matt Porter <mporter@ti.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        grant.likely@secretlab.ca,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        cjb@laptop.org,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Date: Sat, 01 Sep 2012 06:32:29 +0530
In-Reply-To: <1346432577.15463.16.camel@vkoul-mobl4>
References: <1345684176-21472-1-git-send-email-mporter@ti.com>
	 <1345684176-21472-4-git-send-email-mporter@ti.com>
	 <503F75C0.1050507@ti.com> <20120830144307.GA26737@beef>
	 <5040E00A.3080600@ti.com> <1346430709.15463.15.camel@vkoul-mobl4>
	 <5040E6C7.6030106@ti.com> <1346432577.15463.16.camel@vkoul-mobl4>
Organization: 
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-31 at 22:32 +0530, Vinod Koul wrote:
> On Fri, 2012-08-31 at 22:01 +0530, Sekhar Nori wrote:
> > >> Yes, this was the problem. Since the SPI driver now depends on
> > >> CONFIG_TI_EDMA for basic operation may be select CONFIG_TI_EDMA in
> > >> Kconfig if SPI is enabled? That should do until the fallback to PIO
> > is
> > >> implemented.
> > > Then this should be enabled for SPI. Care to send a patch
> > 
> > By 'this' you mean the Kconfig select? Then there should be no need of
> > a
> > new patch for this. It can be part of this patch itself, no? 
> Either way is okay for me.
And am in good mood :)

Applied all with this as well

>From b5f14330590118e6a0659255476c0f24ab681e05 Mon Sep 17 00:00:00 2001
From: Vinod Koul <vinod.koul@linux.intel.com>
Date: Sat, 1 Sep 2012 06:29:22 +0530
Subject: [PATCH] spi: davici - make davinci select edma

Reported-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
---
 drivers/spi/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 5f84b55..b9fb9a1 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -134,6 +134,7 @@ config SPI_DAVINCI
 	tristate "Texas Instruments DaVinci/DA8x/OMAP-L/AM1x SoC SPI
controller"
 	depends on ARCH_DAVINCI
 	select SPI_BITBANG
+	select TI_EDMA
 	help
 	  SPI master controller for DaVinci/DA8x/OMAP-L/AM1x SPI modules.
 
-- 
1.7.9.5



-- 
~Vinod Koul
Intel Corp.

