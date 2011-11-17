Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab1KQJZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 04:25:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:20496 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365Ab1KQJZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 04:25:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="76651647"
Subject: Re: [PATCH 00/10] dmaengine: move to enum dma_transfer_direction
From: Vinod Koul <vinod.koul@linux.intel.com>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, jaswinder.singh@linaro.org,
        21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Viresh Kumar <viresh.kumar@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Li Yang <leoli@freescale.com>, Zhang Wei <zw@zh-kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Shawn Guo <shawn.guo@freescale.com>, Yong Wang <yong.y.wang@intel.com>,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Boojin Kim <boojin.kim@samsung.com>, Barry Song <Baohua.Song@csr.com>
In-Reply-To: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 14:49:51 +0530
Message-ID: <1321521591.1516.195.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 11:08 +0530, Vinod Koul wrote:
> From: Vinod Koul <vinod.koul@linux.intel.com>
> 
> As discussed recently on new interleaved dma patchset, the direction in
> dmaengine needs improvement and as suggested by Jassi, this patchset move
> dmaengine and dmacs, clients to use new enum dma_transfer_direction to indicate
> the dma direction and mode
> 
> Vinod Koul (10):
>   dmaengine: add new enum dma_transfer_direction
>   dmaengine: move drivers to dma_transfer_direction
>   plat-samsung: move to dma_transfer_direction
>   media-video: move to dma_transfer_direction
>   carma: move to dma_transfer_direction
>   mmc-host: move to dma_transfer_direction
>   spi, serial: move to dma_transfer_direction
>   sound-soc: move to dma_transfer_direction
>   USB: move to dma_transfer_direction
>   net-ks8842: move to dma_transfer_direction
> 
the version 2 of this patchset is available now
in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git dma_slave_direction

The change being the addition of DMA_xxx to the dma_slave_direction
values  as suggesting during last review. I have also added the acks
received from various folks.

Please note I plan to merge this tomorrow which would be followed by
merge of the 2d-xfer patches. If you have any objection on either series
please let me know.

Vinod Koul (11):
      dmaengine: add new enum dma_transfer_direction
      dmaengine: move drivers to dma_transfer_direction
      plat-samsung: move to dma_transfer_direction
      media, video: move to dma_transfer_direction
      carma: move to dma_transfer_direction
      mmc-host: move to dma_transfer_direction
      spi, serial: move to dma_transfer_direction
      sound-soc: move to dma_transfer_direction
      net-ks8842: move to dma_transfer_direction
      USB-musb: move to dma_transfer_direction
      USB-renesas: move to dma_transfer_direction

 arch/arm/mach-ep93xx/include/mach/dma.h        |    6 ++--
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |    4 +-
 arch/arm/plat-samsung/dma-ops.c                |    4 +-
 arch/arm/plat-samsung/include/plat/dma-ops.h   |    4 +-
 drivers/dma/amba-pl08x.c                       |   24 +++++++++++-----------
 drivers/dma/at_hdmac.c                         |   22 ++++++++++----------
 drivers/dma/coh901318.c                        |   12 +++++-----
 drivers/dma/coh901318_lli.c                    |   23 ++++++++++-----------
 drivers/dma/coh901318_lli.h                    |    4 +-
 drivers/dma/dw_dmac.c                          |   14 ++++++------
 drivers/dma/ep93xx_dma.c                       |   22 ++++++++++----------
 drivers/dma/fsldma.c                           |    4 +-
 drivers/dma/imx-dma.c                          |   10 ++++----
 drivers/dma/imx-sdma.c                         |   10 ++++----
 drivers/dma/intel_mid_dma.c                    |   14 ++++++------
 drivers/dma/intel_mid_dma_regs.h               |    2 +-
 drivers/dma/ipu/ipu_idmac.c                    |    4 +-
 drivers/dma/mxs-dma.c                          |    8 +++---
 drivers/dma/pch_dma.c                          |   12 +++++-----
 drivers/dma/pl330.c                            |   18 ++++++++--------
 drivers/dma/shdma.c                            |   25 +++++++++++------------
 drivers/dma/ste_dma40.c                        |   26 ++++++++++++------------
 drivers/dma/timb_dma.c                         |   18 ++++++++--------
 drivers/dma/txx9dmac.c                         |   12 +++++-----
 drivers/media/video/mx3_camera.c               |    2 +-
 drivers/media/video/timblogiw.c                |    2 +-
 drivers/misc/carma/carma-fpga-program.c        |    2 +-
 drivers/mmc/host/atmel-mci.c                   |   10 ++++++--
 drivers/mmc/host/mmci.c                        |   11 ++++++---
 drivers/mmc/host/mxcmmc.c                      |   10 ++++++--
 drivers/mmc/host/mxs-mmc.c                     |    7 +++++-
 drivers/mmc/host/sh_mmcif.c                    |    4 +-
 drivers/mmc/host/tmio_mmc_dma.c                |    4 +-
 drivers/net/ks8842.c                           |    4 +-
 drivers/spi/spi-dw-mid.c                       |    8 +++---
 drivers/spi/spi-ep93xx.c                       |    9 +++++--
 drivers/spi/spi-pl022.c                        |    8 +++---
 drivers/spi/spi-topcliff-pch.c                 |    4 +-
 drivers/tty/serial/amba-pl011.c                |    8 +++---
 drivers/tty/serial/pch_uart.c                  |    4 +-
 drivers/tty/serial/sh-sci.c                    |    4 +-
 drivers/usb/musb/ux500_dma.c                   |    4 +-
 drivers/usb/renesas_usbhs/fifo.c               |    4 +-
 drivers/video/mx3fb.c                          |    4 +-
 include/linux/amba/pl08x.h                     |    4 +-
 include/linux/dmaengine.h                      |   22 +++++++++++++++----
 include/linux/dw_dmac.h                        |    2 +-
 include/linux/sh_dma.h                         |    2 +-
 sound/atmel/abdac.c                            |    2 +-
 sound/atmel/ac97c.c                            |   10 ++++----
 sound/soc/ep93xx/ep93xx-pcm.c                  |    4 +-
 sound/soc/imx/imx-pcm-dma-mx2.c                |    6 ++--
 sound/soc/samsung/dma.c                        |    4 +-
 sound/soc/sh/siu_pcm.c                         |    4 +-
 sound/soc/txx9/txx9aclc.c                      |    2 +-
 55 files changed, 253 insertions(+), 224 deletions(-)



-- 
~Vinod

