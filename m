Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab2IUI2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 04:28:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53907 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394Ab2IUI1z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 04:27:55 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: "Porter, Matt" <mporter@ti.com>, Tony Lindgren <tony@atomide.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>
CC: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: RE: [RFC PATCH 00/13] DMA Engine support for AM33xx
Thread-Topic: [RFC PATCH 00/13] DMA Engine support for AM33xx
Thread-Index: AQHNlz4pAMb10R6XBUK0URnxVtmz6ZeUdpuw
Date: Fri, 21 Sep 2012 08:27:07 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EA8A79D@DBDE01.ent.ti.com>
References: <1348152226-13588-1-git-send-email-mporter@ti.com>
In-Reply-To: <1348152226-13588-1-git-send-email-mporter@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 20:13:33, Porter, Matt wrote:
> This series adds DMA Engine support for AM33xx, which uses
> an EDMA DMAC. The EDMA DMAC has been previously supported by only
> a private API implementation (much like the situation with OMAP
> DMA) found on the DaVinci family of SoCs.
> 
> There are a mind-boggling number of dependencies for this series:
> 
> 	- Jon Hunter's OF DMA helpers series
> 	  https://patchwork.kernel.org/patch/1461061/
> 	  https://patchwork.kernel.org/patch/1461051/
> 	- Patch to address OF DMA helpers naming issues:
> 	  https://patchwork.kernel.org/patch/1477921/
> 	- EDMA DMA Engine wrapper driver in linux-next
> 	  c2dde5f8f2095d7c623ff3565c1462e190272273
> 	- EDMA DMA Engine wrapper driver bug fix:
> 	  https://patchwork.kernel.org/patch/1474411/  
> 	- A huge number of patches in linux-next for AM33xx boot
> 	  (too numerous to list)
> 
> The approach taken is similar to how OMAP DMA is being converted to
> DMA Engine support. With the functional EDMA private API already
> existing in mach-davinci/dma.c, we first move that to an ARM common
> area so it can be shared. Adding DT and runtime PM support to the
> private EDMA API implementation allows it to run on AM33xx. AM33xx
> *only* boots using DT so we leverage Jon's generic DT DMA helpers to
> register EDMA DMAC with the of_dma framework and then add support
> for calling the dma_request_slave_channel() API to both the mmc
> and spi drivers.
> 
> What works? Well, with this series we now have MMC and SPI support
> on AM33xx. The only caveat for MMC is that the mmc3 controller has
> its events on the crossbar and is not usable right now.
> 
> This is tested on BeagleBone with a SPI framebuffer driver and SD
> card.
> 
> After this series, the plan is to convert the last in-tree user
> of the private EDMA API (davinci-pcm/mcasp) and then eliminate
> the private EDMA API by folding its functionality into
> drivers/dma/edma.c.
> 
> TODO:
> 	add AM33xx crossbar support to the private EDMA API
> 	(any EDMA events on the crossbar are not supported)
> 


Can you please mention the base repo you have taken as starting point.
(repo + extra patches ...).

This will help us to test the code.

This is because I looked at the patch 12/13 and I see that mmc
device-node is modified. But in mainline I don’t see device 
node for mmc (yet).

> Matt Porter (13):
>   ARM: davinci: move private EDMA API to arm/common
>   ARM: edma: remove unused transfer controller handlers
>   ARM: edma: add DT and runtime PM support for AM335x
>   dmaengine: edma: enable build for AM335x
>   dma: Add TI EDMA device tree binding
>   ARM: omap: add hsmmc am33xx specific init
>   mmc: omap_hsmmc: dma_request_slave_channel() support for DT platforms
>   mmc: omap_hsmmc: limit max_segs with the EDMA DMAC
>   mmc: omap_hsmmc: add generic DMA request support to the DT binding
>   spi: omap2-mcspi: dma_request_slave_channel() support for DT
>     platforms
>   spi: omap2-mcspi: add generic DMA request support to the DT binding
>   ARM: dts: add am33xx EDMA support
>   Documentation: add schedule for removing private EDMA API
> 
>  Documentation/devicetree/bindings/dma/ti-edma.txt  |   49 +
>  .../devicetree/bindings/mmc/ti-omap-hsmmc.txt      |   25 +-
>  Documentation/devicetree/bindings/spi/omap-spi.txt |   27 +-
>  Documentation/feature-removal-schedule.txt         |   10 +
>  arch/arm/Kconfig                                   |    1 +
>  arch/arm/boot/dts/am33xx.dtsi                      |   46 +
>  arch/arm/common/Kconfig                            |    3 +
>  arch/arm/common/Makefile                           |    1 +
>  arch/arm/common/edma.c                             | 1779 ++++++++++++++++++++
>  arch/arm/include/asm/mach/edma.h                   |  267 +++
>  arch/arm/mach-davinci/Makefile                     |    2 +-
>  arch/arm/mach-davinci/devices.c                    |    3 +-
>  arch/arm/mach-davinci/dm355.c                      |    2 +-
>  arch/arm/mach-davinci/dm365.c                      |    2 +-
>  arch/arm/mach-davinci/dm644x.c                     |    2 +-
>  arch/arm/mach-davinci/dm646x.c                     |    2 +-
>  arch/arm/mach-davinci/dma.c                        | 1588 -----------------
>  arch/arm/mach-davinci/include/mach/asp.h           |    2 +-
>  arch/arm/mach-davinci/include/mach/da8xx.h         |    3 +-
>  arch/arm/mach-davinci/include/mach/edma.h          |  267 ---
>  arch/arm/mach-davinci/include/mach/spi.h           |    2 +-
>  arch/arm/mach-omap2/hsmmc.c                        |    7 +-
>  arch/arm/plat-omap/Kconfig                         |    1 +
>  drivers/dma/Kconfig                                |    2 +-
>  drivers/dma/edma.c                                 |    2 +-
>  drivers/mmc/host/omap_hsmmc.c                      |   26 +-
>  drivers/spi/spi-omap2-mcspi.c                      |   68 +-
>  27 files changed, 2296 insertions(+), 1893 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/dma/ti-edma.txt
>  create mode 100644 arch/arm/common/edma.c
>  create mode 100644 arch/arm/include/asm/mach/edma.h
>  delete mode 100644 arch/arm/mach-davinci/dma.c
>  delete mode 100644 arch/arm/mach-davinci/include/mach/edma.h
> 
> -- 
> 1.7.9.5
> 
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
> 


Regards, 
Gururaja
