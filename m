Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab2APPFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 10:05:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:8882 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888Ab2APPFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 10:05:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="112796218"
Subject: [GIT PULL] slave-dmaengine updates
From: Vinod Koul <vinod.koul@intel.com>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Dan <dan.j.williams@intel.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Jan 2012 20:36:20 +0530
Message-ID: <1326726380.1540.112.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Here is the slave-dmaengine updates which include a new DMA engine API
for 2D interleaved transfers along with fixes for slave dma_tranfer
direction along with usual fixes and updates on bunch of the slave dma
drivers.


Thanks
~Vinod


The following changes since commit 1ea6b8f48918282bdca0b32a34095504ee65bab5:
  Linus Torvalds (1):
        Linux 3.2-rc1

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git next

Adrian Hunter (2):
      dmaengine: intel_mid_dma: locking and freeing fixes
      dmaengine: intel_mid_dma: error path fix

Axel Lin (1):
      dmaengine: convert drivers/dma/* to use module_platform_driver()

Boojin Kim (1):
      DMA: PL330: Fix build warning

Ciaran McCormick (1):
      dma: fix spacing for method declaration, coding style issue in iop-adma.c

Guennadi Liakhovetski (2):
      dma: shdma: fix runtime PM: clear channel buffers on reset
      ARM: mach-shmobile: specify CHCLR registers on SH7372

Haitao Zhang (1):
      dma/imx-sdma: save irq flags when use spin_lock in sdma_tx_submit

Huang Shijie (3):
      IMX/DMA : set the DMA direction in the sdma_control()
      IMX/SDMA : save the real count for one DMA transaction.
      mtd: fix compile error for gpmi-nand

Jassi Brar (1):
      DMAEngine: Define interleaved transfer request api

Kristen Carlson Accardi (1):
      dmaengine: intel_mid_dma: remove legacy pm interface

Lothar Waßmann (4):
      dma: mxs-dma: fix a typo in comment
      dma: mxs-dma: Always leave mxs_dma_init() with the clock disabled.
      dma: mxs-dma: make mxs_dma_prep_slave_sg() multi user safe
      dma: mxs-dma: Don't use CLKGATE bits in CTRL0 to disable DMA channels

Mika Westerberg (1):
      dma/ep93xx_dma: prevent ep93xx_dma_tasklet() to reference an empty list

Narayanan G (3):
      dmaengine/ste_dma40: support pm in dma40
      dmaengine/ste_dma40: Add support to use lcla area from esram
      dmaengine/ste_dma40: allow fixed physical channel

Nicolas Ferre (5):
      dmaengine: at_hdmac: platform data move to use .id_table
      dmaengine: at_hdmac: add device tree support
      dmaengine: at_hdmac: add const to struct platform_device_id definition
      dmaengine: at_hdmac: empty entry shape modification
      dmaengine: at_hdmac: simplify device selection from platform data or DT

Rabin Vincent (1):
      dmaengine/ste_dma40: clear LNK on channel startup

Rafal Prylowski (1):
      dma/ep93xx_dma: fix initialization of M2M control register

Rongjun Ying (1):
      dmaengine: add CSR SiRFprimaII DMAC driver

Sascha Hauer (3):
      dma i.MX: remove individual SOC dependency
      i.MX IPU DMA: Fix wrong burstsize settings
      video i.MX IPU: Fix display connections

Shawn Guo (4):
      dmaengine: add DMA_TRANS_NONE to dma_transfer_direction
      mmc: mxs-mmc: fix the dma_transfer_direction migration
      mtd: gpmi-nand: move to dma_transfer_direction
      ASoC: mxs: correct 'direction' of device_prep_dma_cyclic

Tomoya MORINAGA (2):
      pch_dma: Change company name OKI SEMICONDUCTOR to LAPIS Semiconductor
      pch_dma: Support new device LAPIS Semiconductor ML7831 IOH

Tushar Behera (1):
      DMA: PL330: Remove pm_runtime_xxx calls from pl330 probe/remove

Vinod Koul (13):
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
      Merge branch 'dma_slave_direction' into next_test_dirn
      dmaengine: timb_dma: fix the spare warinings

Viresh Kumar (2):
      dmaengine/dw_dmac: Reconfigure interrupt and chan_cfg register on resume
      dmaengine/amba-pl08x: Config ccfg and increment phychan_hold if phychan is true

 .../devicetree/bindings/dma/atmel-dma.txt          |   14 +
 Documentation/dmaengine.txt                        |    8 +
 MAINTAINERS                                        |    1 +
 arch/arm/mach-ep93xx/include/mach/dma.h            |    6 +-
 arch/arm/mach-shmobile/setup-sh7372.c              |   15 +-
 arch/arm/plat-mxc/include/mach/mx3fb.h             |   15 +
 arch/arm/plat-nomadik/include/plat/ste_dma40.h     |   11 +-
 arch/arm/plat-samsung/dma-ops.c                    |    4 +-
 arch/arm/plat-samsung/include/plat/dma-ops.h       |    4 +-
 drivers/dma/Kconfig                                |   27 +-
 drivers/dma/Makefile                               |    1 +
 drivers/dma/amba-pl08x.c                           |   41 +-
 drivers/dma/at_hdmac.c                             |  103 +++-
 drivers/dma/at_hdmac_regs.h                        |    1 +
 drivers/dma/coh901318.c                            |   12 +-
 drivers/dma/coh901318_lli.c                        |   23 +-
 drivers/dma/coh901318_lli.h                        |    4 +-
 drivers/dma/dmaengine.c                            |    4 +-
 drivers/dma/dw_dmac.c                              |   83 ++-
 drivers/dma/dw_dmac_regs.h                         |    1 +
 drivers/dma/ep93xx_dma.c                           |   90 ++-
 drivers/dma/fsldma.c                               |    4 +-
 drivers/dma/imx-dma.c                              |   10 +-
 drivers/dma/imx-sdma.c                             |   27 +-
 drivers/dma/intel_mid_dma.c                        |   39 +-
 drivers/dma/intel_mid_dma_regs.h                   |    4 +-
 drivers/dma/iop-adma.c                             |   16 +-
 drivers/dma/ipu/ipu_idmac.c                        |   29 +-
 drivers/dma/mpc512x_dma.c                          |   12 +-
 drivers/dma/mxs-dma.c                              |   53 +--
 drivers/dma/pch_dma.c                              |   20 +-
 drivers/dma/pl330.c                                |   38 +-
 drivers/dma/shdma.c                                |   72 ++-
 drivers/dma/sirf-dma.c                             |  707 ++++++++++++++++++++
 drivers/dma/ste_dma40.c                            |  441 +++++++++++--
 drivers/dma/ste_dma40_ll.h                         |   11 +
 drivers/dma/timb_dma.c                             |   30 +-
 drivers/dma/txx9dmac.c                             |   12 +-
 drivers/media/video/mx3_camera.c                   |    2 +-
 drivers/media/video/timblogiw.c                    |    2 +-
 drivers/misc/carma/carma-fpga-program.c            |    2 +-
 drivers/mmc/host/atmel-mci.c                       |   10 +-
 drivers/mmc/host/mmci.c                            |   11 +-
 drivers/mmc/host/mxcmmc.c                          |   10 +-
 drivers/mmc/host/mxs-mmc.c                         |   10 +-
 drivers/mmc/host/sh_mmcif.c                        |    4 +-
 drivers/mmc/host/tmio_mmc_dma.c                    |    4 +-
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c              |   22 +-
 drivers/net/ethernet/micrel/ks8842.c               |    4 +-
 drivers/spi/spi-dw-mid.c                           |    8 +-
 drivers/spi/spi-ep93xx.c                           |    9 +-
 drivers/spi/spi-pl022.c                            |    8 +-
 drivers/spi/spi-topcliff-pch.c                     |    4 +-
 drivers/tty/serial/amba-pl011.c                    |    8 +-
 drivers/tty/serial/pch_uart.c                      |    4 +-
 drivers/tty/serial/sh-sci.c                        |    4 +-
 drivers/usb/musb/ux500_dma.c                       |    4 +-
 drivers/usb/renesas_usbhs/fifo.c                   |    4 +-
 drivers/video/mx3fb.c                              |   65 +--
 include/linux/amba/pl08x.h                         |    4 +-
 include/linux/dmaengine.h                          |   99 +++-
 include/linux/dw_dmac.h                            |    2 +-
 include/linux/mtd/gpmi-nand.h                      |   68 ++
 include/linux/sh_dma.h                             |    4 +-
 include/linux/sirfsoc_dma.h                        |    6 +
 sound/atmel/abdac.c                                |    2 +-
 sound/atmel/ac97c.c                                |   10 +-
 sound/soc/ep93xx/ep93xx-pcm.c                      |    4 +-
 sound/soc/imx/imx-pcm-dma-mx2.c                    |    6 +-
 sound/soc/mxs/mxs-pcm.c                            |    2 +-
 sound/soc/samsung/dma.c                            |    4 +-
 sound/soc/sh/siu_pcm.c                             |    4 +-
 sound/soc/txx9/txx9aclc.c                          |    2 +-
 73 files changed, 1876 insertions(+), 533 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/dma/atmel-dma.txt
 create mode 100644 drivers/dma/sirf-dma.c
 create mode 100644 include/linux/mtd/gpmi-nand.h
 create mode 100644 include/linux/sirfsoc_dma.h


-- 
~Vinod

