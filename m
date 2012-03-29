Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab2C2Dto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 23:49:44 -0400
Received: from void.printf.net ([89.145.121.20]:54265 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558Ab2C2Dtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 23:49:36 -0400
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] MMC updates for 3.4-rc1
Date: Wed, 28 Mar 2012 23:47:19 -0400
Message-ID: <87iphot6ew.fsf@laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

to receive the MMC merge for 3.4.  I've signed an "mmc-merge-for-3.4-rc1"
tag.  There are no merge conflicts, and the patches have all been tested
in linux-next.  Thanks.


The following changes since commit e2a0883e4071237d09b604a342c28b96b44a04b3:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs (2012-03-21 13:36:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

for you to fetch changes up to 135111cc5595c6a24dd826d503e2d2bae92da1c4:

  mmc: sh_mmcif: simplify bitmask macros (2012-03-27 12:20:20 -0400)

----------------------------------------------------------------
MMC highlights for 3.4:
Core:
 * Support for MMC 4.5 Data Tag feature -- we tag REQ_META, so devices
   that support Data Tag will provide increased throughput for metadata.
 * Faster detection of card removal on I/O errors.

Drivers:
 * dw_mmc now supports eMMC Power Off Notify, has PCI support, and
   implements pre_req and post_req for asynchronous requests.
 * omap_hsmmc now supports device tree.
 * esdhc now has power management support.
 * sdhci-tegra now supports Tegra30 devices.
 * sdhci-spear now supports hibernation.
 * tmio_mmc now supports using a GPIO for card detection.
 * Intel PCH now supports 8-bit bus transfers.

----------------------------------------------------------------
Adrian Hunter (5):
      mmc: start removing enable / disable API
      mmc: core: add high-capacity erase size capability flag
      mmc: sdhci-pci: select HC erase size for Medfield eMMC
      mmc: sdhci: add quirk for keeping card power during suspend
      mmc: sdhci-pci: add SDHCI_QUIRK2_HOST_OFF_CARD_ON for Medfield SDIO

Alexander Stein (3):
      mmc: sdhci-pci: Add MSI support
      mmc: sdhci: check interrupt flags in ISR again
      mmc: sdhci-pci: allow 8-bit bus width for Intel PCH

Balaji T K (3):
      mmc: omap_hsmmc: use platform_get_resource_byname for tx/rx DMA channels
      mmc: omap_hsmmc: remove unused .set_sleep function
      mmc: omap_hsmmc: Use OMAP_HSMMC_SUPPORTS_DUAL_VOLT flag to remove host->id based hardcoding

Bastian Hecht (1):
      mmc: sh_mobile_sdhi: add a callback for board specific init code

Chris Ball (1):
      mmc: sdhci: Add platform suspend/resume hooks.

Daniel Mack (1):
      ARM: OMAP: hsmmc: add max_freq field

Guennadi Liakhovetski (11):
      mmc: tmio_mmc: do not enable card hotplug interrupts, if unused
      mmc: simplify mmc_cd_gpio_request() by removing two parameters
      mmc: tmio: calculate the native hotplug condition only once
      mmc: tmio_mmc: support the generic MMC GPIO card hotplug helper
      mmc: sh_mobile_sdhi: pass card hotplug GPIO number to TMIO MMC
      mmc: tmio_mmc: power status flag doesn't have to be exposed in platform data
      mmc: tmio_mmc: remove unused sdio_irq_enabled flag
      mmc: sh_mobile_sdhi: do not manage PM clocks manually
      mmc: tmio: cosmetic: prettify the tmio_mmc_set_ios() function
      mmc: sh_mobile_sdhi: support modular mmc-core with non-standard hotplug
      mmc: sh_mmcif: simplify bitmask macros

Ido Yariv (2):
      mmc: davinci: Eliminate spurious interrupts
      mmc: davinci: Poll status for small size transfers

Jaehoon Chung (6):
      mmc: dw_mmc: add support for eMMC Power Off Notify feature
      mmc: dw_mmc: Override blk_settings with platdata on IDMAC
      mmc: core: add a debug message for SET_BLOCK_COUNT
      mmc: dw_mmc: shift with slot-id for CLKENA register
      mmc: dw_mmc: fix compile error when CONFIG_MMC_DW_IDMAC is disabled
      mmc: core: warn when card doesn't support HPI

Jerry Huang (2):
      mmc: esdhc: Implement power management for ESDHC
      mmc: esdhc: Workaround for data crc error on p1010rdb

Ludovic Desroches (1):
      mmc: atmel-mci: fix typo

Rajendra Nayak (6):
      mmc: omap_hsmmc: Get rid of omap_hsmmc_1_set_power function
      mmc: omap_hsmmc: Get rid of omap_hsmmc_4_set_power function
      mmc: omap_hsmmc: Don't expect MMC1 to always have vmmc supply
      mmc: omap_hsmmc: convert all pr_* to dev_*
      mmc: omap_hsmmc: Convert hsmmc driver to use device tree
      mmc: omap_hsmmc: Avoid a regulator voltage change with dt

Saugata Das (1):
      mmc: MMC-4.5 Data Tag Support

Seungwon Jeon (2):
      mmc: dw_mmc: Add support for pre_req and post_req
      mmc: dw_mmc: Regression fix for non-IDMAC DMA

Shashidhar Hiremath (1):
      mmc: Support of PCI mode in the dw_mmc driver

Shimoda, Yoshihiro (1):
      mmc: sh_mmcif: fix MMC_GEN_CMD setting

Shiraz Hashim (1):
      mmc: sdhci-spear: add pm callbacks to support hibernation

Stephen Warren (1):
      mmc: sdhci-tegra: Explicitly support Tegra30

Subhash Jadavani (1):
      mmc: core: hs200 fixes

Tony Lindgren (1):
      mmc: omap_hsmmc: Fix "Unbalanced pm_runtime_enable!" warning

Ulf Hansson (2):
      mmc: core: Detect card removal on I/O error
      mmc: core: Clean up after mmc_pre_req if card was removed

 .../devicetree/bindings/mmc/ti-omap-hsmmc.txt      |   33 +++
 arch/arm/mach-exynos/mach-nuri.c                   |    5 +-
 arch/arm/mach-exynos/mach-universal_c210.c         |    9 +-
 arch/arm/mach-omap2/hsmmc.c                        |    1 +
 arch/arm/mach-omap2/hsmmc.h                        |    2 +
 arch/arm/plat-omap/include/plat/mmc.h              |    2 -
 drivers/mmc/card/block.c                           |   21 +-
 drivers/mmc/core/cd-gpio.c                         |   13 +-
 drivers/mmc/core/core.c                            |  252 ++++-------------
 drivers/mmc/core/host.c                            |    1 -
 drivers/mmc/core/host.h                            |    1 -
 drivers/mmc/core/mmc.c                             |   55 +++--
 drivers/mmc/core/mmc_ops.c                         |   12 +-
 drivers/mmc/host/Kconfig                           |   25 ++
 drivers/mmc/host/Makefile                          |    2 +
 drivers/mmc/host/atmel-mci.c                       |    2 +-
 drivers/mmc/host/davinci_mmc.c                     |   66 ++++-
 drivers/mmc/host/dw_mmc-pci.c                      |  158 +++++++++++
 drivers/mmc/host/dw_mmc-pltfm.c                    |  134 +++++++++
 drivers/mmc/host/dw_mmc.c                          |  280 ++++++++++---------
 drivers/mmc/host/dw_mmc.h                          |    7 +
 drivers/mmc/host/omap_hsmmc.c                      |  293 ++++++++------------
 drivers/mmc/host/sdhci-of-esdhc.c                  |   37 +++-
 drivers/mmc/host/sdhci-pci.c                       |   47 +++-
 drivers/mmc/host/sdhci-spear.c                     |    9 +-
 drivers/mmc/host/sdhci-tegra.c                     |  100 ++++++-
 drivers/mmc/host/sdhci.c                           |   38 ++-
 drivers/mmc/host/sdhci.h                           |    2 +
 drivers/mmc/host/sh_mmcif.c                        |    2 -
 drivers/mmc/host/sh_mobile_sdhi.c                  |   29 ++-
 drivers/mmc/host/tmio_mmc.h                        |    9 +-
 drivers/mmc/host/tmio_mmc_pio.c                    |  108 ++++----
 include/linux/mfd/tmio.h                           |   26 ++-
 include/linux/mmc/card.h                           |    2 +
 include/linux/mmc/cd-gpio.h                        |    3 +-
 include/linux/mmc/core.h                           |    1 -
 include/linux/mmc/dw_mmc.h                         |    8 +-
 include/linux/mmc/host.h                           |   48 +---
 include/linux/mmc/mmc.h                            |    3 +
 include/linux/mmc/sdhci.h                          |    2 +
 include/linux/mmc/sh_mmcif.h                       |   21 +-
 include/linux/mmc/sh_mobile_sdhi.h                 |   14 +
 42 files changed, 1161 insertions(+), 722 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
 create mode 100644 drivers/mmc/host/dw_mmc-pci.c
 create mode 100644 drivers/mmc/host/dw_mmc-pltfm.c

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
