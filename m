Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab1FFHOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 03:14:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:51238 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab1FFHOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 03:14:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,325,1304319600"; 
   d="scan'208";a="14090269"
Subject: Re: [PATCH v2 0/5] ep93xx DMA patches
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Mika Westerberg <mika.westerberg@iki.fi>
Cc: hsweeten@visionengravers.com, rmallon@gmail.com, dan.j.williams@intel.com,
        lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20110605081904.GA16018@acer>
References: <cover.1306662317.git.mika.westerberg@iki.fi>
	 <20110605081904.GA16018@acer>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 12:09:40 +0530
Message-ID: <1307342380.10976.79.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-06-05 at 11:19 +0300, Mika Westerberg wrote:
> Vinod,
> 
> As this series has acks for all the subsystem maintainers, would it be ok for
> you to take the entire series via your tree? Or do you have any idea how to
> get it merged?
Please don't top post :(

I have applied this series to next including the asoc and spi changes,
if anyone has any objections please let me know

> 
> On Sun, May 29, 2011 at 01:10:01PM +0300, Mika Westerberg wrote:
> > This is an updated version of the ep93xx DMA patches. Previous version can be
> > found here: https://lkml.org/lkml/2011/5/22/86.
> > 
> > Changes to v1:
> >  * removed unnecessary header
> >  * corrected SPI driver documentation
> >  * DMA driver platform code is only compiled when CONFIG_EP93XX_DMA is
> >    enabled
> > 
> > I tried to put all the acks in place, hope I got them right.
> > 
> > There is a dependency between patch 1 and patch 4 which I'm not entirely sure
> > how to solve. Basically it is required that we have patch 1 applied before
> > patch 4 or merge conflict results.
> > 
> > Otherwise it shouldn't matter in which order the patches arrive to the
> > mainline.
> > 
> > Unless someone has a better idea, I suggest that these patches will go through
> > their respective subsystem trees. All the maintainers should be copied.
> > 
> > Thanks,
> > MW
> > 
> > Mika Westerberg (5):
> >   dmaengine: add ep93xx DMA support
> >   ep93xx: add dmaengine platform code
> >   ASoC: ep93xx: convert to use the DMA engine API
> >   ep93xx: remove the old M2P DMA code
> >   spi/ep93xx: add DMA support
> > 
> >  Documentation/spi/ep93xx_spi                   |   10 +
> >  arch/arm/mach-ep93xx/Makefile                  |    4 +-
> >  arch/arm/mach-ep93xx/core.c                    |    6 +-
> >  arch/arm/mach-ep93xx/dma-m2p.c                 |  411 -------
> >  arch/arm/mach-ep93xx/dma.c                     |  108 ++
> >  arch/arm/mach-ep93xx/include/mach/dma.h        |  190 ++---
> >  arch/arm/mach-ep93xx/include/mach/ep93xx_spi.h |    2 +
> >  drivers/dma/Kconfig                            |    7 +
> >  drivers/dma/Makefile                           |    1 +
> >  drivers/dma/ep93xx_dma.c                       | 1355 ++++++++++++++++++++++++
> >  drivers/spi/ep93xx_spi.c                       |  303 +++++-
> >  sound/soc/ep93xx/ep93xx-ac97.c                 |    4 +-
> >  sound/soc/ep93xx/ep93xx-i2s.c                  |    4 +-
> >  sound/soc/ep93xx/ep93xx-pcm.c                  |  137 ++--
> >  14 files changed, 1930 insertions(+), 612 deletions(-)
> >  delete mode 100644 arch/arm/mach-ep93xx/dma-m2p.c
> >  create mode 100644 arch/arm/mach-ep93xx/dma.c
> >  create mode 100644 drivers/dma/ep93xx_dma.c
> > 
> > -- 
> > 1.7.4.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
~Vinod

