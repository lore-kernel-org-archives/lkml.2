Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab1JaEnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 00:43:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:49660 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab1JaEnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 00:43:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="69475832"
Subject: [GIT PULL] slave-dmaengine updates
From: Vinod Koul <vinod.koul@intel.com>
To: Linus <torvalds@linux-foundation.org>
Cc: Dan <dan.j.williams@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Oct 2011 10:10:17 +0530
Message-ID: <1320036017.32205.11.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is the slave-dmaengine updates which include consolidation of
samsung dma drivers from arm drivers to use dmaengine, enhancements and
fixes to amba-pl08x driver along with other usual fixes.

Since I have not been able to get my key signed with enough people yet,
so not sending this with key. Hopefully next time it would be a signed
message which you can verify. Also my tree is on infradead servers (same
one you pulled last time), let me know if you are okay with this server
or i should consider moving it.

Thanks
~Vinod

The following changes since commit c6a389f123b9f68d605bb7e0f9b32ec1e3e14132:
  Linus Torvalds (1):
        Linux 3.1-rc4

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git next

Axel Lin (1):
      dmaengine i.MX DMA/SDMA: add missing include of linux/module.h

Barry Song (1):
      dmaengine: delete redundant chan_id and chancnt initialization in dma drivers

Boojin Kim (16):
      DMA: PL330: Add support runtime PM for PL330 DMAC
      DMA: PL330: Update PL330 DMA API driver
      DMA: PL330: Support DMA_SLAVE_CONFIG command
      DMA: PL330: Remove the start operation for handling DMA_TERMINATE_ALL command
      DMA: PL330: Add DMA_CYCLIC capability
      ARM: SAMSUNG: Update to use PL330-DMA driver
      ARM: SAMSUNG: Add common DMA operations
      ARM: EXYNOS4: Use generic DMA PL330 driver
      ARM: S5PV210: Use generic DMA PL330 driver
      ARM: S5PC100: Use generic DMA PL330 driver
      ARM: S5P64X0: Use generic DMA PL330 driver
      ARM: SAMSUNG: Remove S3C-PL330-DMA driver
      spi/s3c64xx: Add support DMA engine API
      spi/s3c64xx: Merge dma control code
      ASoC: Samsung: Update DMA interface
      ARM: SAMSUNG: Remove Samsung specific enum type for dma direction

Dan Carpenter (1):
      dma/timberdale: free_irq() on an error path

Guennadi Liakhovetski (4):
      dmatest: make dmatest threads freezable
      serial: sh-sci: don't filter on DMA device, use only channel ID
      dmaengine: shdma: protect against the IRQ handler
      dma: shdma: transfer based runtime PM

Lothar Waßmann (1):
      mxs-dma: enable CLKGATE before accessing registers

Mika Westerberg (1):
      dmaengine/ep93xx_dma: add module.h include

Nicolas Ferre (4):
      dmaengine: at_hdmac: replace spin_lock* with irqsave variants
      dmaengine: at_hdmac: improve power management routines
      dmaengine: at_hdmac: add wrappers for testing channel state
      dmaengine: at_hdmac: fix way to specify cyclic capability

Per Forlin (4):
      dmaengine/ste_dma40: add missing kernel doc for pending_queue
      dmaengine/ste_dma40: remove duplicate call to d40_pool_lli_free().
      dmaengine/ste_dma40: fix Oops due to double free of client descriptor
      dmaengine/ste_dma40: fix memory leak due to prepared descriptors

Russell King - ARM Linux (1):
      dmaengine: amba-pl08x: make filter check that the channel is owned by pl08x

Sascha Hauer (3):
      dmaengine i.MX SDMA: lock channel 0
      dmaengine i.MX SDMA: set firmware scripts addresses to negative value initially
      dmaengine i.MX SDMA: use request_firmware_nowait

Tomoya MORINAGA (2):
      pch_dma: Fix suspend issue
      pch_dma: Reduce wasting memory

Vinod Koul (5):
      dmaengine: add helper function for slave_single
      dmaengine: remove struct scatterlist for header
      Merge branch 'next' into v3.1-rc4
      Merge branch 'samsung_dma' into next
      dmaengine: mid_dma: mask_peripheral_interrupt only when dmac is idle

Viresh Kumar (21):
      dmaengine/dmatest: Terminate transfers on all channels in case of error or exit
      ARM: asm/pl080.h: Protect against multiple inclusion of header file
      dmaengine/amba-pl08x: Resolve formatting issues
      dmaengine/amba-pl08x: Rearrange inclusion of header files in ascending order
      dmaengine/amba-pl08x: pass (*ptr) to sizeof() instead of (struct xyz)
      dmaengine/amba-pl08x: Complete doc comment for struct pl08x_txd
      dmaengine/amba-pl08x: Remove redundant comment and rewrite original
      dmaengine/amba-pl08x: Changing few prints to dev_dbg from dev_info
      dmaengine/amba-pl08x: support runtime PM
      dmaengine/amba-pl08x: Simplify pl08x_ensure_on()
      dmaengine/amba-pl08x: No need to check "ch->signal < 0"
      dmaengine/amba-pl08x: Schedule tasklet in case of error interrupt
      dmaengine/amba-pl08x: Get rid of pl08x_pre_boundary()
      dmaengine/amba-pl08x: max_bytes_per_lli is TRANSFER_SIZE * src_width (not MIN(width))
      dmaengine/amba-pl08x: Add prep_single_byte_llis() routine
      dmaengine/amba-pl08x: Align lli_len to max(src.width, dst.width)
      dmaengine/amba-pl08x: Choose peripheral bus as master bus
      dmaengine/amba-pl08x: Pass flow controller information with slave channel data
      dmaengine/amba-pl08x: Call pl08x_free_txd() instead of calling kfree() directly
      dmaengine/amba-pl08x: Add support for sg len greater than one for slave transfers
      dmaengine/amba-pl08x: Check txd->llis_va before freeing dma_pool

 arch/arm/include/asm/hardware/pl080.h              |    4 +
 arch/arm/mach-exynos4/Kconfig                      |    2 +-
 arch/arm/mach-exynos4/clock.c                      |   11 +-
 arch/arm/mach-exynos4/dma.c                        |  299 +++--
 arch/arm/mach-exynos4/include/mach/dma.h           |    4 +-
 arch/arm/mach-s3c2410/include/mach/dma.h           |   20 +-
 arch/arm/mach-s3c2412/dma.c                        |    4 +-
 arch/arm/mach-s3c64xx/dma.c                        |   10 +-
 arch/arm/mach-s3c64xx/include/mach/dma.h           |    8 +-
 arch/arm/mach-s5p64x0/Kconfig                      |    4 +-
 arch/arm/mach-s5p64x0/clock-s5p6440.c              |    9 +-
 arch/arm/mach-s5p64x0/clock-s5p6450.c              |    9 +-
 arch/arm/mach-s5p64x0/dma.c                        |  273 +++--
 arch/arm/mach-s5p64x0/include/mach/dma.h           |    4 +-
 arch/arm/mach-s5pc100/Kconfig                      |    2 +-
 arch/arm/mach-s5pc100/clock.c                      |   11 +-
 arch/arm/mach-s5pc100/dma.c                        |  323 ++++--
 arch/arm/mach-s5pc100/include/mach/dma.h           |    4 +-
 arch/arm/mach-s5pv210/Kconfig                      |    2 +-
 arch/arm/mach-s5pv210/clock.c                      |   10 +-
 arch/arm/mach-s5pv210/dma.c                        |  316 ++++--
 arch/arm/mach-s5pv210/include/mach/dma.h           |    4 +-
 arch/arm/plat-s3c24xx/dma.c                        |   10 +-
 arch/arm/plat-samsung/Kconfig                      |    9 +-
 arch/arm/plat-samsung/Makefile                     |    4 +-
 arch/arm/plat-samsung/dma-ops.c                    |  131 ++
 arch/arm/plat-samsung/include/plat/dma-ops.h       |   63 +
 .../include/plat/{s3c-dma-pl330.h => dma-pl330.h}  |   24 +-
 arch/arm/plat-samsung/include/plat/dma-s3c24xx.h   |    2 +-
 arch/arm/plat-samsung/include/plat/dma.h           |   10 +-
 .../plat-samsung/include/plat/s3c-pl330-pdata.h    |   32 -
 arch/arm/plat-samsung/s3c-dma-ops.c                |  130 ++
 arch/arm/plat-samsung/s3c-pl330.c                  | 1244
--------------------
 drivers/dma/Kconfig                                |    3 +-
 drivers/dma/amba-pl08x.c                           |  640 +++++-----
 drivers/dma/at_hdmac.c                             |  164 ++-
 drivers/dma/at_hdmac_regs.h                        |   24 +
 drivers/dma/dmatest.c                              |   23 +-
 drivers/dma/dw_dmac.c                              |    5 +-
 drivers/dma/ep93xx_dma.c                           |    1 +
 drivers/dma/imx-dma.c                              |    1 +
 drivers/dma/imx-sdma.c                             |   48 +-
 drivers/dma/intel_mid_dma.c                        |    9 +-
 drivers/dma/mpc512x_dma.c                          |    1 -
 drivers/dma/mxs-dma.c                              |   45 +-
 drivers/dma/pch_dma.c                              |    7 +-
 drivers/dma/pl330.c                                |  231 ++++-
 drivers/dma/shdma.c                                |  129 ++-
 drivers/dma/shdma.h                                |    7 +
 drivers/dma/ste_dma40.c                            |   42 +-
 drivers/dma/timb_dma.c                             |    5 +-
 drivers/mmc/host/s3cmci.c                          |    6 +-
 drivers/spi/spi-s3c64xx.c                          |  175 ++--
 drivers/tty/serial/sh-sci.c                        |   25 +-
 include/linux/amba/pl08x.h                         |   30 +-
 include/linux/amba/pl330.h                         |    6 +-
 include/linux/dmaengine.h                          |   13 +-
 include/linux/serial_sci.h                         |    2 -
 sound/soc/samsung/ac97.c                           |   10 +-
 sound/soc/samsung/dma.c                            |  146 +--
 sound/soc/samsung/dma.h                            |    4 +-
 61 files changed, 2331 insertions(+), 2463 deletions(-)
 create mode 100644 arch/arm/plat-samsung/dma-ops.c
 create mode 100644 arch/arm/plat-samsung/include/plat/dma-ops.h
 rename arch/arm/plat-samsung/include/plat/{s3c-dma-pl330.h =>
dma-pl330.h} (84%)
 delete mode 100644 arch/arm/plat-samsung/include/plat/s3c-pl330-pdata.h
 create mode 100644 arch/arm/plat-samsung/s3c-dma-ops.c
 delete mode 100644 arch/arm/plat-samsung/s3c-pl330.c


-- 
~Vinod


