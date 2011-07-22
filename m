Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab1GVDLD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 23:11:03 -0400
Received: from void.printf.net ([89.145.121.20]:53179 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399Ab1GVDLB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 23:11:01 -0400
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [GIT PULL] MMC updates for 3.1-rc1.
Date: Thu, 21 Jul 2011 23:10:50 -0400
Message-ID: <m28vrr57t1.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

to receive MMC updates for 3.1.  There are currently no merge conflicts,
and the patches have been tested in linux-next.  Thanks.

Highlights are:

Core:
 * New non-blocking request framework from Per Forlin for removing DMA
   preparation overhead, used by adding pre_req() and post_req() driver
   hooks for preparing DMA descriptors ahead of time as described in
   Documentation/mmc/mmc-async-req.txt.

 * Improved MMC error detection and recovery from Russell King.

Drivers:
 * Fix errors with the Ricoh e823 controller (as found in ThinkPad X220,
   Tecra R850, Portégé R830) by lowering its SD bus frequency to 50MHz.

 * Runtime PM support for omap_hsmmc, tmio_mmc, and sh_mmcif.

 * sdhci-pltfm architecture rework by Shawn Guo.

 * Split up sdhci-pxa into independent sdhci-pxav2 (pxa910) and
   sdhci-pxav3 (MMP2) drivers.

 * Implement non-blocking framework hooks for the mmci driver.


The following changes since commit d1e9ae47a0285d3f1699e8219ce50f656243b93f:

  Merge branch 'rcu/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu into core/urgent (2011-07-20 20:59:26 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

Adrian Hunter (5):
      mmc: queue: let host controllers specify maximum discard timeout
      mmc: sdhci: specify maximum discard timeout
      mmc: sdhci-pci: allow 8-bit bus width for Intel Medfield eMMCs
      mmc: omap_hsmmc: correct debug report error status mnemonics
      mmc: omap_hsmmc: fix oops in omap_hsmmc_dma_cb()

Andy Shevchenko (5):
      mmc: omap_hsmmc: move hardcoded frequency constants to defines
      mmc: omap_hsmmc: split duplicate code to calc_divisor() function
      mmc: omap_hsmmc: introduce start_clock and re-use stop_clock
      mmc: omap_hsmmc: fix a few bugs when setting the clock divisor
      mmc: omap_hsmmc: refactor duplicated code

Balaji T K (3):
      mmc: omap_hsmmc: Remove lazy_disable
      mmc: omap_hsmmc: add runtime pm support
      mmc: omap_hsmmc: Remove unused iclk

Daniel Drake (1):
      mmc: print debug messages for runtime PM actions

Guennadi Liakhovetski (6):
      mmc: tmio: fix recursive spinlock, don't schedule with interrupts disabled
      mmc: tmio: maximize power saving
      mmc: sh_mmcif: maximize power saving
      mmc: tmio: fix a recently introduced bug in DMA code
      mmc: tmio: fix a deadlock
      mmc: MAINTAINERS: add myself as a tmio-mmc maintainer

Jaehoon Chung (1):
      mmc: block: fixed NULL pointer dereference

James Hogan (10):
      mmc: dw_mmc: clear TXDR/RXDR ints before enabling
      mmc: dw_mmc: fix race with request and removal
      mmc: dw_mmc: convert card tasklet to workqueue
      mmc: dw_mmc: brackets in register access macros
      mmc: dw_mmc: don't hard code fifo depth, fix usage
      mmc: dw_mmc: handle unaligned buffers and sizes
      mmc: dw_mmc: fix stop when fallen back to PIO
      mmc: dw_mmc: remove unnecessary error messages
      mmc: dw_mmc: handle "no CRC status" error
      mmc: dw_mmc: reset FIFO after an error

Jean-Christophe PLAGNIOL-VILLARD (1):
      mmc: at91_mci: move register header from include/ to drivers/

Koen Beel (1):
      mmc: mxs-mmc: fix clock rate setting

Madhusudhan Chikkature (1):
      mmc: MAINTAINERS: change omap_hsmmc maintainence to orphan

Major Lee (1):
      mmc: sdhci-pci: add 8-bit bus width support for mrst hc0

Manoj Iyer (1):
      mmc: Added quirks for Ricoh 1180:e823 lower base clock frequency

Nicolas Ferre (2):
      mmc: atmel-mci: add suspend/resume support
      mmc: kconfig: remove EXPERIMENTAL from the DMA selection of atmel-mci

Ohad Ben-Cohen (1):
      mmc: fix runtime PM with -ENOSYS suspend case

Paul Parsons (2):
      mmc: tmio: Fix build error without CONFIG_MMC_SDHI
      mmc: tmio: Fix race condition resulting in spurious interrupts

Per Forlin (12):
      mmc: core: add non-blocking mmc request function
      mmc: omap_hsmmc: add support for pre_req and post_req
      mmc: mmci: implement pre_req() and post_req()
      mmc: mmc_test: add debugfs file to list all tests
      mmc: mmc_test: add test for non-blocking transfers
      mmc: mmc_test: test to measure how sg_len affect performance
      mmc: block: add member in mmc queue struct to hold request data
      mmc: block: add a block request prepare function
      mmc: block: move error path in issue_rw_rq to a separate function.
      mmc: queue: add a second mmc queue request member
      mmc: block: add handling for two parallel block requests in issue_rw_rq
      mmc: documentation of mmc non-blocking request usage and design.

Philip Rakity (1):
      mmc: core: Set non-default Drive Strength via platform hook

Robert P. J. Day (1):
      mmc: Standardize header file inclusion checks.

Russell King - ARM Linux (3):
      mmc: block: allow get_card_status() to return error status
      mmc: block: improve error recovery from command channel errors
      mmc: block: add checking of r/w command response

Seungwon Jeon (2):
      mmc: dw_mmc: set the card_width bit per card.
      mmc: dw_mmc: protect a sequence of request and request-done.

Shawn Guo (8):
      mmc: sdhci: make sdhci-pltfm device drivers self registered
      mmc: sdhci: eliminate sdhci_of_host and sdhci_of_data
      mmc: sdhci: make sdhci-of device drivers self registered
      mmc: sdhci: merge two sdhci-pltfm.h into one
      mmc: sdhci: change sdhci-pltfm into a module
      mmc: sdhci: fix interrupt storm from card detection
      mmc: sdhci-esdhc-imx: SDHCI_CARD_PRESENT does not get cleared
      mmc: sdhci-esdhc-imx: remove "WP" from flag ESDHC_FLAG_GPIO_FOR_CD_WP

Simon Horman (3):
      mmc: tmio: name 0xd8 as CTL_DMA_ENABLE
      mmc: tmio: Share register access functions
      mmc: sdhi: Add write16_hook

Wonil Choi (1):
      mmc: sdhci-s3c: Fix return value in sdhci_s3c_suspend/resume()

Zhangfei Gao (6):
      mmc: host: split up sdhci-pxa, create sdhci-pxav3.c
      mmc: host: split up sdhci-pxa, create sdhci-pxav2.c
      mmc: update mmp2 mmc resources in arch/arm
      mmc: host: delete obsolete sdhci-pxa.c
      mmc: sdhci-pxa: move platform data to include/linux/platform_data
      ARM: mmp2: update mmp2_defconfig to support mmc

 Documentation/mmc/00-INDEX                         |    2 +
 Documentation/mmc/mmc-async-req.txt                |   87 +++
 MAINTAINERS                                        |   10 +-
 arch/arm/configs/mmp2_defconfig                    |    9 +-
 arch/arm/mach-mmp/brownstone.c                     |   10 +-
 arch/arm/mach-mmp/include/mach/mmp2.h              |    2 +-
 arch/arm/mach-mmp/jasper.c                         |    2 +-
 arch/arm/mach-mmp/mmp2.c                           |   16 +-
 arch/arm/plat-pxa/include/plat/sdhci.h             |   35 -
 drivers/mmc/card/block.c                           |  681 +++++++++++++-------
 drivers/mmc/card/mmc_test.c                        |  498 ++++++++++++++-
 drivers/mmc/card/queue.c                           |  217 ++++---
 drivers/mmc/card/queue.h                           |   33 +-
 drivers/mmc/core/core.c                            |  197 ++++++-
 drivers/mmc/core/sd.c                              |   68 ++-
 drivers/mmc/core/sdio_bus.c                        |    8 +-
 drivers/mmc/host/Kconfig                           |   84 ++-
 drivers/mmc/host/Makefile                          |   25 +-
 drivers/mmc/host/at91_mci.c                        |    3 +-
 .../include/mach => drivers/mmc/host}/at91_mci.h   |    2 +-
 drivers/mmc/host/atmel-mci.c                       |   63 ++
 drivers/mmc/host/dw_mmc.c                          |  446 ++++++++++---
 drivers/mmc/host/dw_mmc.h                          |   17 +-
 drivers/mmc/host/mmci.c                            |  147 ++++-
 drivers/mmc/host/mmci.h                            |    8 +
 drivers/mmc/host/mxs-mmc.c                         |   30 +-
 drivers/mmc/host/omap_hsmmc.c                      |  671 +++++++------------
 drivers/mmc/host/sdhci-cns3xxx.c                   |   44 ++-
 drivers/mmc/host/sdhci-dove.c                      |   43 ++-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |  125 +++--
 drivers/mmc/host/sdhci-of-core.c                   |  253 --------
 drivers/mmc/host/sdhci-of-esdhc.c                  |   86 ++-
 drivers/mmc/host/sdhci-of-hlwd.c                   |   67 ++-
 drivers/mmc/host/sdhci-of.h                        |   42 --
 drivers/mmc/host/sdhci-pci.c                       |   54 ++-
 drivers/mmc/host/sdhci-pltfm.c                     |  216 +++----
 drivers/mmc/host/sdhci-pltfm.h                     |   90 +++-
 drivers/mmc/host/sdhci-pxa.c                       |  303 ---------
 drivers/mmc/host/sdhci-pxav2.c                     |  244 +++++++
 drivers/mmc/host/sdhci-pxav3.c                     |  289 +++++++++
 drivers/mmc/host/sdhci-s3c.c                       |    6 +-
 drivers/mmc/host/sdhci-tegra.c                     |  117 +++-
 drivers/mmc/host/sdhci.c                           |   34 +-
 drivers/mmc/host/sh_mmcif.c                        |   27 +-
 drivers/mmc/host/sh_mobile_sdhi.c                  |   36 +
 drivers/mmc/host/tmio_mmc.h                        |   53 ++-
 drivers/mmc/host/tmio_mmc_dma.c                    |    7 +-
 drivers/mmc/host/tmio_mmc_pio.c                    |  205 +++----
 drivers/pci/quirks.c                               |   23 +
 include/linux/mfd/tmio.h                           |    8 +
 include/linux/mmc/boot.h                           |    6 +-
 include/linux/mmc/card.h                           |    2 +-
 include/linux/mmc/core.h                           |    9 +-
 include/linux/mmc/dw_mmc.h                         |   28 +-
 include/linux/mmc/host.h                           |   26 +-
 include/linux/mmc/ioctl.h                          |    2 +-
 include/linux/mmc/mmc.h                            |   17 +-
 include/linux/mmc/pm.h                             |    2 +-
 include/linux/mmc/sd.h                             |    7 +-
 include/linux/mmc/sdhci-pltfm.h                    |   35 -
 include/linux/mmc/sdhci-spear.h                    |    6 +-
 include/linux/mmc/sdhci.h                          |    6 +-
 include/linux/mmc/sdio.h                           |    7 +-
 include/linux/mmc/sdio_func.h                      |    7 +-
 include/linux/mmc/sdio_ids.h                       |    6 +-
 include/linux/mmc/sh_mmcif.h                       |    6 +-
 include/linux/mmc/sh_mobile_sdhi.h                 |    6 +-
 include/linux/mmc/tmio.h                           |    8 +-
 include/linux/platform_data/pxa_sdhci.h            |   60 ++
 69 files changed, 3928 insertions(+), 2061 deletions(-)
 create mode 100644 Documentation/mmc/mmc-async-req.txt
 delete mode 100644 arch/arm/plat-pxa/include/plat/sdhci.h
 rename {arch/arm/mach-at91/include/mach => drivers/mmc/host}/at91_mci.h (99%)
 delete mode 100644 drivers/mmc/host/sdhci-of-core.c
 delete mode 100644 drivers/mmc/host/sdhci-of.h
 delete mode 100644 drivers/mmc/host/sdhci-pxa.c
 create mode 100644 drivers/mmc/host/sdhci-pxav2.c
 create mode 100644 drivers/mmc/host/sdhci-pxav3.c
 delete mode 100644 include/linux/mmc/sdhci-pltfm.h
 create mode 100644 include/linux/platform_data/pxa_sdhci.h

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
