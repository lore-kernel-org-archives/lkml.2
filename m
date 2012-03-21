Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab2CUNkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 09:40:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:46852 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794Ab2CUNkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 09:40:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="131493782"
Subject: Re: [PATCH 0/2 V2] dmaengine: add context parameter to
 prep_slave_sg and prep_dma_cyclic
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: dan.j.williams@intel.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, jaswinder.singh@linaro.org,
        linus.walleij@stericsson.com, leoli@freescale.com, zw@zh-kernel.org,
        STEricsson_nomadik_linux@list.st.com, ben-linux@fluff.org,
        kgene.kim@samsung.com, mchehab@infradead.org,
        ludovic.desroches@atmel.com, cjb@laptop.org, g.liakhovetski@gmx.de,
        ian@mnementh.co.uk, dwmw2@infradead.org, grant.likely@secretlab.ca,
        alan@linux.intel.com, balbi@ti.com, FlorianSchandinat@gmx.de,
        perex@perex.cz, tiwai@suse.de, viresh.kumar@st.com,
        baohua.song@csr.com, srinidhi.kasagar@stericsson.com
In-Reply-To: <1331238913-25818-1-git-send-email-alexandre.bounine@idt.com>
References: <1331238913-25818-1-git-send-email-alexandre.bounine@idt.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Mar 2012 19:13:54 +0530
Message-ID: <1332337434.19804.5.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 15:35 -0500, Alexandre Bounine wrote:
Can you rebase this series with Acks collected so that I can merge.
The sequence fails to apply on current next, and SHA1 information in not
enough for me to perform a merge :(
> As we agreed during our discussion about adding DMA Engine support for RapidIO
> subsystem [1], RapidIO and similar clients may benefit from adding an extra
> context parameter to device_prep_slave_sg() and device_prep_dma_cyclic() interfaces.
> 
> Adding the context parameter will allow to pass client/target specific
> information associated with an individual data transfer request.
> 
> In the case of RapidIO support this additional information consists of target
> destination ID and its buffer address (which is not mapped into the local CPU
> memory space). Because a single RapidIO-capable DMA channel may queue data
> transfer requests to different target devices, the per-request configuration
> is required.
> 
> This set of patches presents changes to DMA_SLAVE and DMA_CYCLIC interfaces [2]
> and corresponding changes to all affected current drivers/clients.
> 
> V.2 of the patches is reworked to implement wrappers and use staged approach
> as proposed by Russell King [3]. 
> 
> DMA Engine support for RapidIO and device-specific driver for Tsi721 PCIe-to-SRIO
> bridge will follow as a separate set of patches.
> 
> [1] https://lkml.org/lkml/2011/10/24/275
> [2] https://lkml.org/lkml/2012/1/30/624
> [3] https://lkml.org/lkml/2012/2/3/269
> 
> Alexandre Bounine (2):
>   dmaengine/dma_slave: introduce inline wrappers
>   dmaengine: add context parameter to prep_slave_sg and prep_dma_cyclic
> 
>  arch/arm/plat-nomadik/include/plat/ste_dma40.h |    3 +-
>  arch/arm/plat-samsung/dma-ops.c                |    4 +-
>  drivers/dma/amba-pl08x.c                       |    2 +-
>  drivers/dma/at_hdmac.c                         |    7 ++++-
>  drivers/dma/coh901318.c                        |    2 +-
>  drivers/dma/dw_dmac.c                          |    2 +-
>  drivers/dma/ep93xx_dma.c                       |    6 +++-
>  drivers/dma/fsldma.c                           |    4 ++-
>  drivers/dma/imx-dma.c                          |    5 ++-
>  drivers/dma/imx-sdma.c                         |    5 ++-
>  drivers/dma/intel_mid_dma.c                    |    3 +-
>  drivers/dma/ipu/ipu_idmac.c                    |    3 +-
>  drivers/dma/mxs-dma.c                          |    5 ++-
>  drivers/dma/pch_dma.c                          |    3 +-
>  drivers/dma/pl330.c                            |    5 ++-
>  drivers/dma/shdma.c                            |    3 +-
>  drivers/dma/sirf-dma.c                         |    2 +-
>  drivers/dma/ste_dma40.c                        |    5 ++-
>  drivers/dma/timb_dma.c                         |    3 +-
>  drivers/dma/txx9dmac.c                         |    2 +-
>  drivers/media/video/mx3_camera.c               |    2 +-
>  drivers/media/video/timblogiw.c                |    2 +-
>  drivers/mmc/host/atmel-mci.c                   |    2 +-
>  drivers/mmc/host/mmci.c                        |    2 +-
>  drivers/mmc/host/mxcmmc.c                      |    2 +-
>  drivers/mmc/host/mxs-mmc.c                     |    2 +-
>  drivers/mmc/host/sh_mmcif.c                    |    4 +-
>  drivers/mmc/host/tmio_mmc_dma.c                |    4 +-
>  drivers/mtd/nand/gpmi-nand/gpmi-lib.c          |   25 ++++++++++-------------
>  drivers/net/ethernet/micrel/ks8842.c           |    4 +-
>  drivers/spi/spi-dw-mid.c                       |    4 +-
>  drivers/spi/spi-ep93xx.c                       |    4 +-
>  drivers/spi/spi-pl022.c                        |    4 +-
>  drivers/spi/spi-topcliff-pch.c                 |    4 +-
>  drivers/tty/serial/amba-pl011.c                |    6 +---
>  drivers/tty/serial/pch_uart.c                  |    4 +-
>  drivers/tty/serial/sh-sci.c                    |    4 +-
>  drivers/usb/musb/ux500_dma.c                   |    3 +-
>  drivers/usb/renesas_usbhs/fifo.c               |    5 +--
>  drivers/video/mx3fb.c                          |    4 +-
>  include/linux/dmaengine.h                      |   24 ++++++++++++++++++++--
>  sound/soc/ep93xx/ep93xx-pcm.c                  |    3 +-
>  sound/soc/imx/imx-pcm-dma-mx2.c                |    2 +-
>  sound/soc/mxs/mxs-pcm.c                        |    2 +-
>  sound/soc/sh/siu_pcm.c                         |    4 +-
>  sound/soc/txx9/txx9aclc.c                      |    2 +-
>  46 files changed, 114 insertions(+), 88 deletions(-)
> 


-- 
~Vinod

