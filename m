Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759153Ab2C2LXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 07:23:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:24788 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325Ab2C2LXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 07:23:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="135039892"
Subject: [GIT PULL] slave-dmaengine updates for 3.4
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Dan <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Mar 2012 16:56:19 +0530
Message-ID: <1333020379.1820.58.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Here is the slave-dmaengine update for 3.4 merge cycle.

This includes the cookie cleanup by Russell, the addition of context
parameter for dmaengine APIs, more arm dmaengine driver cleanup by
moving code to dmaengine, this time for imx by Javier and pl330 by
Boojin along with the usual driver fixes.

There are few merge conflicts with your tree, so I created a branch on
todays tip and merged the slave-dma.next. Results are at 
git://git.infradead.org/users/vkoul/slave-dma.git linus_master_merge 
for you to compare while merging.

Thanks
Vinod

------------------------------>


The following changes since commit dcd6c92267155e70a94b3927bce681ce74b80d1f:

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git next

Adrian Hunter (2):
      dmaengine: intel_mid_dma: fix error status mask
      dmaengine: intel_mid_dma: move pm_runtime_put

Alexandre Bounine (2):
      dmaengine/dma_slave: introduce inline wrappers
      dmaengine: add context parameter to prep_slave_sg and prep_dma_cyclic

Boojin Kim (3):
      DMA: PL330: Merge PL330 driver into drivers/dma/
      DMA: PL330: Removes useless function
      DMA: PL330: Support MEMTOMEM transmit w/o RMB, WMB

Danny Kukawka (1):
      drivers/dma: linux/module.h included twice

Dr. David Alan Gilbert (1):
      dmaengine: fix missing 'cnt' in ?: in dmatest

Fabio Estevam (4):
      dma: dmaengine: Distinguish between 'dmaengine: failed to get' messages
      dma: imx-sdma: Let the driver be probed even if no firware is found
      dma: imx-sdma: Print a message when firmare fails to be requested
      dma: imx-sdma: Treat firmware messages as warnings instead of erros

Guennadi Liakhovetski (2):
      dma: sh_dma: not all SH DMAC implementations support MEMCPY
      ARM: mach-shmobile: both USB DMAC instances on sh7372 are slave-only

Javier Martin (17):
      dmaengine: Add support for MEMCPY for imx-dma.
      dmaengine: Add support for multiple descriptors for imx-dma.
      dmaengine: imx-dma: merge old dma-v1.c with imx-dma.c
      dmaengine: imx-dma: remove data member from internal structure.
      dmaengine: imx-dma: remove dma_mode member of internal structure.
      dmaengine: imx-dma: remove 'imxdma_setup_mem2mem_hw' function.
      dmaengine: imx-dma: remove 'imxdma_config_channel_hw' function.
      dmaengine: imx-dma: remove 'imxdma_setup_sg_hw' function.
      dmaengine: imx-dma: remove sg member from internal structure.
      dmaengine: imx-dma: remove 'in_use' field of 'internal' structure.
      dmaengine: imx-dma: remove 'resbytes' field of 'internal' structure.
      dmaengine: imx-dma: remove internal structure.
      dmaengine: imx-dma: remove unused arg of imxdma_sg_next.
      dmaengine: imx-dma: remove 'imx_dmav1_baseaddr' and 'dma_clk'.
      dmaengine: imx-dma: use 'dev_dbg' and 'dev_warn' for messages.
      dmaengine: i.MX: Add support for interleaved transfers.
      dmaengine: i.MX: Fix merge of cookie branch.

Julia Lawall (2):
      drivers/dma/pl330.c: add missing iounmap
      drivers/dma/amba-pl08x.c: adjust double test

Nicolas Ferre (1):
      dmaengine: at_hdmac: add slave config operation

Nikolaus Voss (1):
      at_hdmac: bugfix for enabling channel irq

Philippe Rétornaz (1):
      i.MX SDMA: Fix burstsize settings

Rajeev KUMAR (1):
      dmaengine/dw_dmac: Hibernation support in dw_dmac

Richard Zhao (6):
      dma/imx-sdma: let sdma_run_channel call sdma_enable_channel
      dma/imx-sdma: use readl_relaxed/writel_relaxed and use writel when necessary
      dma/imx-sdma: call sdma_set_channel_priority after sdma_request_channel
      dma/imx-sdma: move clk_enable out of sdma_request_channel
      dma/imx-sdma: use num_events to validate event_id0
      dma/imx-sdma: convernt to use bit ops

Russell King - ARM Linux (9):
      dmaengine: mv_xor: remove write-only is_complete_cookie
      dmaengine: move last completed cookie into generic dma_chan structure
      dmaengine: add private header file
      dmaengine: consolidate assignment of DMA cookies
      dmaengine: provide a common function for completing a dma descriptor
      dmaengine: consolidate tx_status functions
      dmaengine: consolidate initialization of cookies
      dmaengine: fix cookie handling in iop-adma.c and ppc4xx/adma.c
      dmaengine: ensure all DMA engine drivers initialize their cookies

Sascha Hauer (4):
      mmc: mxcmmc: add missing dma_async_issue_pending
      ASoC: i.MX: Add missing dma_async_issue_pending
      dma: imx-dma: start transfer in issue_pending
      dma: imx-sdma: start transfer in issue_pending

Vinod Koul (8):
      Merge branch fixes of git://git.kernel.org/.../djbw/dmaengine.git
      Merge branch 'fixes' into next
      Merge branch 'fixes' into next
      Revert "drivers/dma: linux/module.h included twice"
      dmaengine: pl330: fix the pl330 build after cookie cleanup
      dmaengine: fix for cookie changes and merge
      Merge branch 'rmk_cookie_fixes2' into next
      dmaengine: imx: fix the build failure on x86_64

Viresh Kumar (10):
      dmaengine: Add flow controller information to dma_slave_config
      dmaengine: Pass dma_slave_config .device_fc = NULL for all existing users
      dmaengine/amba-pl08x: Take flow controller info from DMA_SLAVE_CONFIG
      dmaengine/dw_dmac: Don't use magic number for total number of channels
      dmaengine/dw_dmac: Use dev_get_platdata() instead of accessing dev directly
      dmaengine/dw_dmac: Don't handle block interrupts
      dmaengine/dw_dmac: Add 64 bit access width support for slave xfers on mem side
      dmaengine/dw_dmac: Add support for DMA_SLAVE_CONFIG
      dmaengine/dw_dmac: Fix dw_dmac user drivers to adapt to slave_config changes
      dmaengine/dw_dmac: Remove unused fields in struct dw_dma_slave

 arch/arm/common/Kconfig                         |    3 -
 arch/arm/common/Makefile                        |    1 -
 arch/arm/common/pl330.c                         | 1959 ---------------------
 arch/arm/include/asm/hardware/iop_adma.h        |    2 -
 arch/arm/include/asm/hardware/pl330.h           |  217 ---
 arch/arm/mach-at91/at91sam9g45_devices.c        |    1 -
 arch/arm/mach-at91/include/mach/at_hdmac.h      |   15 -
 arch/arm/mach-imx/Kconfig                       |    6 -
 arch/arm/mach-imx/Makefile                      |    2 -
 arch/arm/mach-imx/dma-v1.c                      |  846 ---------
 arch/arm/mach-imx/include/mach/dma-v1.h         |  103 --
 arch/arm/mach-shmobile/setup-sh7372.c           |    2 +
 arch/arm/plat-nomadik/include/plat/ste_dma40.h  |    3 +-
 arch/arm/plat-samsung/dma-ops.c                 |    4 +-
 arch/avr32/mach-at32ap/at32ap700x.c             |   13 -
 arch/avr32/mach-at32ap/include/mach/atmel-mci.h |    7 -
 drivers/dma/Kconfig                             |    3 +-
 drivers/dma/amba-pl08x.c                        |   46 +-
 drivers/dma/at_hdmac.c                          |  115 +-
 drivers/dma/at_hdmac_regs.h                     |   51 +-
 drivers/dma/coh901318.c                         |   41 +-
 drivers/dma/dmaengine.c                         |    8 +-
 drivers/dma/dmaengine.h                         |   89 +
 drivers/dma/dmatest.c                           |    2 +-
 drivers/dma/dw_dmac.c                           |  228 ++--
 drivers/dma/dw_dmac_regs.h                      |   16 +-
 drivers/dma/ep93xx_dma.c                        |   31 +-
 drivers/dma/fsldma.c                            |   28 +-
 drivers/dma/fsldma.h                            |    1 -
 drivers/dma/imx-dma.c                           |  950 +++++++++--
 drivers/dma/imx-sdma.c                          |  193 +--
 drivers/dma/intel_mid_dma.c                     |   46 +-
 drivers/dma/intel_mid_dma_regs.h                |    2 -
 drivers/dma/ioat/dma.c                          |   21 +-
 drivers/dma/ioat/dma.h                          |   23 -
 drivers/dma/ioat/dma_v2.c                       |   13 +-
 drivers/dma/ioat/dma_v3.c                       |   12 +-
 drivers/dma/iop-adma.c                          |   52 +-
 drivers/dma/ipu/ipu_idmac.c                     |   25 +-
 drivers/dma/mpc512x_dma.c                       |   25 +-
 drivers/dma/mv_xor.c                            |   34 +-
 drivers/dma/mv_xor.h                            |    3 -
 drivers/dma/mxs-dma.c                           |   28 +-
 drivers/dma/pch_dma.c                           |   37 +-
 drivers/dma/pl330.c                             | 2148 ++++++++++++++++++++++-
 drivers/dma/ppc4xx/adma.c                       |   49 +-
 drivers/dma/ppc4xx/adma.h                       |    2 -
 drivers/dma/shdma.c                             |   36 +-
 drivers/dma/shdma.h                             |    1 -
 drivers/dma/sirf-dma.c                          |   27 +-
 drivers/dma/ste_dma40.c                         |   41 +-
 drivers/dma/timb_dma.c                          |   37 +-
 drivers/dma/txx9dmac.c                          |   43 +-
 drivers/dma/txx9dmac.h                          |    1 -
 drivers/media/video/mx3_camera.c                |    2 +-
 drivers/media/video/timblogiw.c                 |    2 +-
 drivers/mmc/host/atmel-mci.c                    |   26 +-
 drivers/mmc/host/mmci.c                         |    4 +-
 drivers/mmc/host/mxcmmc.c                       |    5 +-
 drivers/mmc/host/mxs-mmc.c                      |    2 +-
 drivers/mmc/host/sh_mmcif.c                     |    4 +-
 drivers/mmc/host/tmio_mmc_dma.c                 |    4 +-
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c           |   25 +-
 drivers/net/ethernet/micrel/ks8842.c            |    4 +-
 drivers/spi/spi-dw-mid.c                        |    7 +-
 drivers/spi/spi-ep93xx.c                        |    4 +-
 drivers/spi/spi-pl022.c                         |    6 +-
 drivers/spi/spi-topcliff-pch.c                  |    4 +-
 drivers/tty/serial/amba-pl011.c                 |    9 +-
 drivers/tty/serial/pch_uart.c                   |    4 +-
 drivers/tty/serial/sh-sci.c                     |    4 +-
 drivers/usb/musb/ux500_dma.c                    |    4 +-
 drivers/usb/renesas_usbhs/fifo.c                |    5 +-
 drivers/video/mx3fb.c                           |    4 +-
 include/linux/amba/pl08x.h                      |   10 +-
 include/linux/amba/pl330.h                      |    1 -
 include/linux/dmaengine.h                       |   35 +-
 include/linux/dw_dmac.h                         |   38 -
 include/linux/sh_dma.h                          |    1 +
 sound/atmel/abdac.c                             |   18 +-
 sound/atmel/ac97c.c                             |   41 +-
 sound/soc/ep93xx/ep93xx-pcm.c                   |    3 +-
 sound/soc/imx/imx-pcm-dma-mx2.c                 |    6 +-
 sound/soc/mxs/mxs-pcm.c                         |    2 +-
 sound/soc/sh/siu_pcm.c                          |    4 +-
 sound/soc/txx9/txx9aclc.c                       |    2 +-
 86 files changed, 3732 insertions(+), 4250 deletions(-)
 delete mode 100644 arch/arm/common/pl330.c
 delete mode 100644 arch/arm/include/asm/hardware/pl330.h
 delete mode 100644 arch/arm/mach-imx/dma-v1.c
 delete mode 100644 arch/arm/mach-imx/include/mach/dma-v1.h
 create mode 100644 drivers/dma/dmaengine.h


-- 
~Vinod

