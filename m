Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab2GXFTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 01:19:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:7830 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229Ab2GXFTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 01:19:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="197152593"
Subject: [GIT PULL] slave-dmaengine updates for v3.6
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, dan.j.williams@gmail.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Jul 2012 10:49:25 +0530
Message-ID: <1343107165.1726.5996.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Here is the slave-dmaengine update for 3.6

This time we have new dmaengine driver from tegra folks. Also we have
Guennadi's cleanup of sh drivers which incudes a library for sh drivers.
And the usual odd fixes in bunch of drivers and some nice cleanup of
dw_dmac from Andy.


The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git next

Andy Shevchenko (12):
      dw_dmac: fix constant in the comment
      dw_dmac: use proper casting to print dma_addr_t values
      dw_dmac: introduce dwc_dump_chan_regs to dump registers
      dw_dmac: print correct number of scanned descriptors
      dw_dmac: use __func__ constant in the debug prints
      dw_dmac: disable dma in optimal way in probe
      dw_dmac: disable BLOCK interrupts
      dw_dmac: introduce dwc_fast_fls()
      dw_dmac: move from __init to __devinit
      dw_dmac: introduce dwc_chan_disable
      dw_dmac: mark dwc_dump_lli inline
      dw_dmac: use 'u32' for LLI structure members, not dma_addr_t

Attila Kinali (1):
      dma: mxs-dma: Export missing symbols from mxs-dma.c

Guennadi Liakhovetski (17):
      dma: move shdma driver to an own directory
      dmaengine: add an shdma-base library
      dma: shdma: prepare for conversion to the shdma base library
      mmc: sh_mmcif: remove unneeded struct sh_mmcif_dma, prepare to shdma conversion
      mmc: sh_mobile_sdhi: prepare for conversion to the shdma base library
      serial: sh-sci: prepare for conversion to the shdma base library
      ASoC: siu: prepare for conversion to the shdma base library
      usb: renesas_usbhs: prepare for conversion to the shdma base library
      ASoC: fsi: prepare for conversion to the shdma base library
      dma: shdma: convert to the shdma base library
      dmaengine: shdma: (cosmetic) simplify a static function
      ASoC: siu: don't use DMA device for channel filtering
      sh: remove unused DMA device pointer from SIU platform data
      dmaengine: shdma: prepare to stop using struct dma_chan::private
      dma: sh: use an integer slave ID to improve API compatibility
      dma: sh: provide a migration path for slave drivers to stop using .private
      mmc: sh_mmcif: switch to the new DMA channel allocation and configuration

Huang Shijie (1):
      dma: enable mxs-dma for imx6q

Javi Merino (1):
      DMA: PL330: Fix racy mutex unlock

Joe Perches (1):
      dmaengine: Cleanup logging messages

Lars-Peter Clausen (1):
      dmaengine: Add wrapper for device_tx_status callback

Laxman Dewangan (7):
      dma: dmaengine: add slave req id in slave_config
      dma: tegra: add dmaengine based dma driver
      dma: tegra: use sg_dma_address() for getting dma buffer address
      dma: tegra: do not set transfer desc flag to DMA_CTRL_ACK in cyclic mode
      dma: tegra: set DMA_CYCLIC capability
      dma: tegra: fix residual calculation for cyclic case
      dma: tegra: rename driver and compatible to match with dts

Linus Walleij (1):
      dma: coh901318: use devm allocation

Nicolas Ferre (1):
      dmaengine: at_hdmac: trivial: fix comment in header

Prashant Gaikwad (1):
      dma: tegra: add clk_prepare/clk_unprepare

Richard Zhao (1):
      dma: imx-sdma: buf_tail should be initialize in prepare function

Sachin Kamat (1):
      DMA: PL330: Add missing static storage class specifier

Tushar Behera (1):
      dmaengine: pl330: dont complete descriptor for cyclic dma

Uwe Kleine-König (1):
      dmaengine: at_hdmac: add a few const qualifiers

Vinod Koul (2):
      Merge branch 'fixes' into next
      dmaengine: mmp_tdma: fix the arch dependency

Zhangfei Gao (1):
      dmaengine: mmp_tdma: add mmp tdma support

 arch/sh/include/asm/siu.h              |    1 -
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c |    1 -
 drivers/dma/Kconfig                    |   26 +-
 drivers/dma/Makefile                   |    4 +-
 drivers/dma/at_hdmac.c                 |   11 +-
 drivers/dma/coh901318.c                |   72 +-
 drivers/dma/dmaengine.c                |   20 +-
 drivers/dma/dw_dmac.c                  |  182 ++---
 drivers/dma/dw_dmac_regs.h             |    8 +-
 drivers/dma/imx-sdma.c                 |    6 +-
 drivers/dma/mmp_tdma.c                 |  610 +++++++++++++
 drivers/dma/mxs-dma.c                  |    3 +-
 drivers/dma/pl330.c                    |   30 +-
 drivers/dma/sh/Makefile                |    2 +
 drivers/dma/sh/shdma-base.c            |  934 +++++++++++++++++++
 drivers/dma/sh/shdma.c                 |  943 ++++++++++++++++++++
 drivers/dma/{ => sh}/shdma.h           |   46 +-
 drivers/dma/shdma.c                    | 1524 --------------------------------
 drivers/dma/tegra20-apb-dma.c          | 1415 +++++++++++++++++++++++++++++
 drivers/mmc/host/sh_mmcif.c            |   94 ++-
 drivers/mmc/host/sh_mobile_sdhi.c      |    8 +-
 drivers/tty/serial/sh-sci.c            |    8 +-
 drivers/usb/renesas_usbhs/fifo.c       |   10 +-
 include/linux/dmaengine.h              |   10 +
 include/linux/mmc/sh_mmcif.h           |    8 +-
 include/linux/sh_dma.h                 |   41 +-
 include/linux/shdma-base.h             |  124 +++
 sound/soc/sh/fsi.c                     |    4 +-
 sound/soc/sh/siu_pcm.c                 |   12 +-
 29 files changed, 4320 insertions(+), 1837 deletions(-)
 create mode 100644 drivers/dma/mmp_tdma.c
 create mode 100644 drivers/dma/sh/Makefile
 create mode 100644 drivers/dma/sh/shdma-base.c
 create mode 100644 drivers/dma/sh/shdma.c
 rename drivers/dma/{ => sh}/shdma.h (58%)
 delete mode 100644 drivers/dma/shdma.c
 create mode 100644 drivers/dma/tegra20-apb-dma.c
 create mode 100644 include/linux/shdma-base.h

-- 
~Vinod

