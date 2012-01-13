Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153Ab2AMNWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 08:22:19 -0500
Received: from void.printf.net ([89.145.121.20]:55234 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab2AMNWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 08:22:18 -0500
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] MMC updates for 3.3-rc1
Date: Fri, 13 Jan 2012 08:22:07 -0500
Message-ID: <m2boq7agao.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

to receive the MMC merge for 3.3.  I've signed an "mmc-merge-for-3.3-rc1"
tag.  There are no merge conflicts, and the patches have been tested in
linux-next.  Thanks.


The following changes since commit 8d362b0dea1a35bea8d7d281317eb7ccb713edcb:

  m68k: remove duplicate asm offset for task thread.info (2011-12-24 21:47:56 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

for you to fetch changes up to 0db13fc2abbb0b1a8d8efee20dfbd7f3c5d54022:

  mmc: fix a deadlock between system suspend and MMC block IO (2012-01-12 15:17:17 -0500)

----------------------------------------------------------------
MMC highlights for 3.3:

Core:
 * Support for the HS200 high-speed eMMC mode.
 * Support SDIO 3.0 Ultra High Speed cards.
 * Kill pending block requests immediately if card is removed.
 * Enable the eMMC feature for locking boot partitions read-only
   until next power on, exposed via sysfs.

Drivers:
 * Runtime PM support for Intel Medfield SDIO.
 * Suspend/resume support for sdhci-spear.
 * sh-mmcif now processes requests asynchronously.

----------------------------------------------------------------
Aaron Lu (2):
      mmc: sdhci: Fix tuning timer incorrect setting when suspending host
      mmc: sdhci: Deal with failure case in sdhci_suspend_host

Adrian Hunter (7):
      mmc: allow upper layers to know immediately if card has been removed
      mmc: sdhci: fix vmmc handling
      mmc: sdhci: prevent card detection activity for non-removable cards
      mmc: sdhci-pci: add platform data
      mmc: sdhci-pci: get gpio numbers from platform data
      mmc: sdhci-pci: remove SDHCI_QUIRK2_OWN_CARD_DETECTION
      mmc: sdhci-pci: enable runtime PM for Medfield SDIO

Alexander Elbs (1):
      mmc: sd: Fix SDR12 timing regression

Axel Lin (2):
      mmc: convert drivers/mmc/host/* to use module_platform_driver()
      mmc: sdhci-pci: simplify error handling

Balaji TK (1):
      mmc: omap: remove clock rate hard coding

Bastian Hecht (1):
      mmc: tmio_mmc: Hotplug code regrouping

Chris Ball (2):
      mmc: card: Use manufacturer ID symbols in card quirks.
      mmc: dw_mmc: Remove unnecessary else clauses

Cong Wang (1):
      mmc: remove the second argument of k[un]map_atomic()

Girish K S (3):
      mmc: core: Fix voltage select in DDR mode
      mmc: core: HS200 mode support for eMMC 4.5
      mmc: host: Adds support for eMMC 4.5 HS200 mode

Giuseppe CAVALLARO (1):
      mmc: debugfs: expose the SDCLK frq in sys ios

Guennadi Liakhovetski (8):
      mmc: sh_mmcif: simplify clock divisor calculation
      mmc: add a card hotplug handler context
      mmc: add a generic GPIO card-detect helper
      mmc: sh_mmcif: process error interrupts first
      mmc: sh_mmcif: cosmetic clean up
      mmc: sh_mmcif: process requests asynchronously
      mmc: sh_mmcif: remove now superfluous sh_mmcif_host::data member
      mmc: fix a deadlock between system suspend and MMC block IO

Jaehoon Chung (3):
      mmc: dw_mmc: use dev_pm_ops for dw_mmc controllers
      mmc: dw_mmc: fixed wrong bit operation for SDMMC_GET_FCNT()
      mmc: dw_mmc: miscaculated the fifo-depth with wrong bit operation

Jingoo Han (1):
      mmc: sdhci-s3c: use S3C_SDHCI_CONTROL2 instead of hardcoded offset value

Johan Rudholm (2):
      mmc: core: check for zero length ioctl data
      mmc: boot partition ro lock support

Lars-Peter Clausen (1):
      mmc: Remove redundant spi driver bus initialization

NeilBrown (1):
      mmc: omap_hsmmc: use threaded irq handler for card-detect.

Per Forlin (2):
      mmc: mmci: add capabilities2 for MMC_CAP2
      mmc: mmc_test: align max_seg_size

Philip Rakity (1):
      mmc: sdio: support SDIO UHS cards

Qiang Liu (1):
      mmc: sd: Macro name cleanup for high speed dtr

Sangwook Lee (2):
      mmc: sdhci-s3c: Add pm_caps into SD/MMC host
      ARM: SAMSUNG: Add pm_caps into platform data

Seungwon Jeon (5):
      mmc: dw_mmc: Add more capabilities field
      mmc: dw_mmc: Support predefined mutiple block transfers
      mmc: core: Add claiming of hosts during mmc_cache_ctrl
      mmc: dw_mmc: Clear the DDR mode for non-DDR
      mmc: core: Separate the timeout value for cache-ctrl

Shaohui Xie (1):
      mmc: sdhci: restore the enabled dma when do reset all

Stefan Nilsson XK (1):
      mmc: sdio: Fix to support any block size optimally

Stephen Boyd (1):
      mmc: core: Fixup delayed work clock gating patch

Sujit Reddy Thumma (2):
      mmc: core: Use delayed work in clock gating framework
      mmc: card: Kill block requests if card is removed

Todd Poynor (1):
      mmc: sdhci: Always pass clock request value zero to set_clock host op

Tony Lin (1):
      mmc: sdhci-esdhc: Change delay after setting clock from 100ms to 1ms

Ulf Hansson (1):
      mmc: core: Add option to prevent eMMC sleep command

Viresh Kumar (2):
      mmc: sdhci-spear: Implement suspend/resume
      mmc: sdhci-spear: Fix compilation error

 Documentation/mmc/mmc-dev-attrs.txt        |   10 +
 Documentation/mmc/mmc-dev-parts.txt        |   13 +
 arch/arm/plat-samsung/include/plat/sdhci.h |    1 +
 arch/arm/plat-samsung/platformdata.c       |    2 +
 drivers/Makefile                           |    2 +-
 drivers/mmc/Makefile                       |    3 +-
 drivers/mmc/card/block.c                   |  247 ++++++++---
 drivers/mmc/card/mmc_test.c                |    1 +
 drivers/mmc/card/queue.c                   |    5 +
 drivers/mmc/core/Makefile                  |    2 +-
 drivers/mmc/core/bus.c                     |    5 +-
 drivers/mmc/core/cd-gpio.c                 |   74 +++
 drivers/mmc/core/core.c                    |   95 +++-
 drivers/mmc/core/core.h                    |    3 +
 drivers/mmc/core/debugfs.c                 |    5 +
 drivers/mmc/core/host.c                    |   53 ++-
 drivers/mmc/core/mmc.c                     |  203 +++++++-
 drivers/mmc/core/sd.c                      |   21 +-
 drivers/mmc/core/sdio.c                    |  342 ++++++++++++-
 drivers/mmc/core/sdio_io.c                 |    8 +-
 drivers/mmc/core/sdio_ops.c                |   14 +-
 drivers/mmc/host/Makefile                  |    1 +
 drivers/mmc/host/at91_mci.c                |    8 +-
 drivers/mmc/host/bfin_sdh.c                |   12 +-
 drivers/mmc/host/cb710-mmc.c               |   13 +-
 drivers/mmc/host/dw_mmc.c                  |   71 ++-
 drivers/mmc/host/dw_mmc.h                  |    2 +-
 drivers/mmc/host/jz4740_mmc.c              |   12 +-
 drivers/mmc/host/mmc_spi.c                 |    1 -
 drivers/mmc/host/mmci.c                    |    1 +
 drivers/mmc/host/msm_sdcc.c                |   19 +-
 drivers/mmc/host/mxcmmc.c                  |   13 +-
 drivers/mmc/host/mxs-mmc.c                 |   13 +-
 drivers/mmc/host/omap_hsmmc.c              |   43 +--
 drivers/mmc/host/pxamci.c                  |   13 +-
 drivers/mmc/host/s3cmci.c                  |   13 +-
 drivers/mmc/host/sdhci-cns3xxx.c           |   12 +-
 drivers/mmc/host/sdhci-dove.c              |   12 +-
 drivers/mmc/host/sdhci-esdhc-imx.c         |   12 +-
 drivers/mmc/host/sdhci-esdhc.h             |    2 +-
 drivers/mmc/host/sdhci-of-esdhc.c          |   12 +-
 drivers/mmc/host/sdhci-of-hlwd.c           |   12 +-
 drivers/mmc/host/sdhci-pci-data.c          |    5 +
 drivers/mmc/host/sdhci-pci.c               |  181 ++++----
 drivers/mmc/host/sdhci-pxav2.c             |   12 +-
 drivers/mmc/host/sdhci-pxav3.c             |   12 +-
 drivers/mmc/host/sdhci-s3c.c               |   18 +-
 drivers/mmc/host/sdhci-spear.c             |   51 ++-
 drivers/mmc/host/sdhci-tegra.c             |   12 +-
 drivers/mmc/host/sdhci.c                   |  150 ++++--
 drivers/mmc/host/sdhci.h                   |    1 +
 drivers/mmc/host/sh_mmcif.c                |  726 ++++++++++++++++++----------
 drivers/mmc/host/sh_mobile_sdhi.c          |   13 +-
 drivers/mmc/host/tifm_sd.c                 |   16 +-
 drivers/mmc/host/tmio_mmc.c                |   14 +-
 drivers/mmc/host/tmio_mmc.h                |    4 +-
 drivers/mmc/host/tmio_mmc_pio.c            |   30 +-
 include/linux/amba/mmci.h                  |    2 +
 include/linux/mmc/card.h                   |   23 +-
 include/linux/mmc/cd-gpio.h                |   19 +
 include/linux/mmc/core.h                   |    2 +
 include/linux/mmc/dw_mmc.h                 |    1 +
 include/linux/mmc/host.h                   |   25 +-
 include/linux/mmc/mmc.h                    |   72 +++-
 include/linux/mmc/sdhci-pci-data.h         |   18 +
 include/linux/mmc/sdhci.h                  |    3 +-
 include/linux/mmc/sdio.h                   |   29 +-
 67 files changed, 1995 insertions(+), 850 deletions(-)
 create mode 100644 drivers/mmc/core/cd-gpio.c
 create mode 100644 drivers/mmc/host/sdhci-pci-data.c
 create mode 100644 include/linux/mmc/cd-gpio.h
 create mode 100644 include/linux/mmc/sdhci-pci-data.h

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
