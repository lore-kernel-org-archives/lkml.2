Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab2JHNE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 09:04:58 -0400
Received: from void.printf.net ([89.145.121.20]:39212 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474Ab2JHNE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 09:04:56 -0400
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [GIT PULL] MMC updates for 3.7-rc1
Date: Mon, 08 Oct 2012 09:04:45 -0400
Message-ID: <87a9vxdsia.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-merge-for-3.7-rc1

to receive the MMC merge for 3.7.  There are currently two conflicts
due to header renames for the ARM single zImage work; they should be
resolved by taking the changes already in your tree.  Thanks.


The following changes since commit 75b53aee2f4fe6375c6007226bf68d75b5c4a929:

  mmc: omap: fix broken PIO mode (2012-09-04 13:58:11 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-merge-for-3.7-rc1

for you to fetch changes up to e6c085863f97f0a8f009753e1baaf83e4aac7b42:

  mmc: core: Fixup broken suspend and eMMC4.5 power off notify (2012-10-07 17:41:45 -0400)

----------------------------------------------------------------
MMC highlights for 3.7:

Core:
 - Add DT properties for card detection (broken-cd, cd-gpios, non-removable)
 - Don't poll non-removable devices
 - Fixup/rework eMMC sleep mode/"power off notify" feature
 - Support eMMC background operations (BKOPS).  To set the one-time
   programmable fuse that enables bkops on an eMMC that doesn't already
   have it set, you can use the "mmc bkops enable" command in:
     git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc-utils.git

Drivers:
 - atmel-mci, dw_mmc, pxa-mci, dove, s3c, spear: Add device tree support
 - bfin_sdh: Add support for the controller in bf60x
 - dw_mmc: Support Samsung Exynos SoCs
 - eSDHC: Add ADMA support
 - sdhci: Support testing a cd-gpio (from slot-gpio) instead of presence bit
 - sdhci-pltfm: Support broken-cd DT property
 - tegra: Convert to only supporting DT (mach-tegra has gone DT-only)

----------------------------------------------------------------
Chander Kashyap (3):
      mmc: sdhci-s3c: Enable only required bus clock
      mmc: sdhci-s3c: Fix crash on module insertion for second time
      mmc: sdhci-s3c: Add clk_(enable/disable) in runtime suspend/resume

Chao Xie (1):
      mmc: sdhci-pxav2, sdhci-pxav3: use clk_prepare/unprepare APIs

Chris Ball (6):
      mmc: dt: Add card-detection properties to core binding.
      mmc: slot-gpio: Fix missing assignment to ctx->ro_gpio
      mmc: sdhci-pxav3: dt: Support "cd-gpios" property
      mmc: dt: Support "broken-cd" property in sdhci-pltfm
      mmc: sdhci-pxav3: Use sdhci_get_of_property for parsing DT quirks
      mmc: core: Replace MMC_CAP2_BROKEN_VOLTAGE with test for fixed regulator

Daniel Mack (1):
      mmc: pxa-mci: add DT bindings

Guennadi Liakhovetski (3):
      mmc: sdhci: Test cd-gpio instead of SDHCI presence when probing
      mmc: sh-mmcif: properly handle MMC_WRITE_MULTIPLE_BLOCK completion IRQ
      mmc: sh-mmcif: avoid oops on spurious interrupts

Hein_Tibosch (2):
      mmc: atmel-mci: DMA can be used with other controllers
      mmc: atmel-mci: AP700x PDC is not connected to MCI

Jaehoon Chung (3):
      mmc: dw_mmc: fixed a section mismatch in dw_mci_init_slot
      mmc: support BKOPS feature for eMMC
      mmc: sdhci-s3c: fix the wrong number of max bus clocks

Javier Martin (1):
      mmc: mxcmmc: fix bug that may block a data transfer forever

Jerry Huang (1):
      mmc: eSDHC: Add ADMA mode support

Jingoo Han (1):
      mmc: sdhci-s3c: fix checkpatch error and warnings

Johan Rudholm (1):
      mmc: core: Do not rescan non-removable devices

Joseph Lo (1):
      mmc: tegra: convert to device tree support only

Julia Lawall (2):
      mmc: vub300: add missing usb_free_urb
      mmc: mmci: use clk_prepare_enable and clk_disable_unprepare

Kyungsik Lee (1):
      mmc: core: Remove bounce buffer in mmc_send_cxd_data()

Ludovic Desroches (1):
      mmc: atmel-mci: add device tree support

Matt Porter (1):
      mmc: davinci_mmc: convert to DMA engine API

NeilBrown (1):
      mmc: omap_hsmmc: Handle failure of regulator_get better.

Philip Rakity (2):
      mmc: sdhci: Add regulator support for vccq (voltage regualor)
      mmc: sdhci: vmmc regulator should be explicitly enabled/disabled

Sachin Kamat (4):
      mmc: mmc_spi: Use module_spi_driver
      mmc: sdhci-pci: Use module_pci_driver
      mmc: dw_mmc-pci: Use module_pci_driver
      mmc: via-sdmmc: Use module_pci_driver

Sebastian Hesselbarth (1):
      mmc: sdhci-dove: DT support for sdhci-dove

Seungwon Jeon (1):
      mmc: Revert "mmc: dw_mmc: Add check for IDMAC configuration"

Sonic Zhang (5):
      mmc: bfin_sdh: Update blackfin sd driver email in MAINTAINERS.
      mmc: bfin_sdh: limit mmc DMA segment len to 1 for bf518.
      mmc: bfin_sdh: Add support for new RSI controller in bf60x
      mmc: bfin_sdh: Remove redundant suspend and resume setting.
      mmc: bfin_sdh: Reset SD controller when resume from power saving mode.

Thierry Reding (1):
      mmc: sdio: Fix PM_SLEEP related build warnings

Thomas Abraham (10):
      mmc: dw_mmc: convert copy of struct device in struct dw_mci to a reference
      mmc: dw_mmc: Use devm_* functions in dw_mmc platform driver
      mmc: dw_mmc: allow probe to succeed even if one slot is initialized
      mmc: dw_mmc: lookup for optional biu and ciu clocks
      mmc: dw_mmc: add quirk to indicate missing write protect line
      mmc: dw_mmc: add device tree support
      mmc: dw_mmc: prepare functions in dw_mmc-pltfm for reuse
      mmc: dw_mmc: add support for implementation specific callbacks
      mmc: dw_mmc: add support for exynos specific implementation of dw-mshc
      mmc: sdhci-s3c: Add device tree support

Ulf Hansson (1):
      mmc: core: Fixup broken suspend and eMMC4.5 power off notify

Vaibhav Bedia (1):
      mmc: omap_hsmmc: Pass on the suspend failure to the PM core

Venkatraman S (9):
      mmc: core: Add TRANsfer state to non-HPI state
      mmc: debugfs: Print ext_csd in ascending order
      mmc: omap: remove unused variables and includes
      mmc: omap: fix mmc_omap_report_irq to use dev_dbg macros
      mmc: omap_hsmmc: remove unused vars and includes
      mmc: omap_hsmmc: remove access to SYSCONFIG register
      mmc: omap_hsmmc: consolidate flush posted writes for HSMMC IRQs
      mmc: omap_hsmmc: consolidate error report handling of HSMMC IRQ
      mmc: omap_hsmmc: Move to Maintained state in MAINTAINERS

Viresh Kumar (2):
      mmc: sdhci-spear: add device tree bindings
      mmc: sdhci-spear: Add clk_{un}prepare() support

 .../devicetree/bindings/mmc/atmel-hsmci.txt        |  68 +++++
 .../devicetree/bindings/mmc/exynos-dw-mshc.txt     |  87 ++++++
 Documentation/devicetree/bindings/mmc/mmc.txt      |   9 +-
 Documentation/devicetree/bindings/mmc/pxa-mmc.txt  |  25 ++
 .../devicetree/bindings/mmc/samsung-sdhci.txt      |  53 ++++
 .../devicetree/bindings/mmc/sdhci-dove.txt         |  14 +
 .../devicetree/bindings/mmc/sdhci-spear.txt        |  18 ++
 .../devicetree/bindings/mmc/synposis-dw-mshc.txt   |  79 +++++
 MAINTAINERS                                        |   6 +-
 arch/arm/boot/dts/spear300-evb.dts                 |   3 +-
 arch/arm/boot/dts/spear320-evb.dts                 |   2 -
 drivers/mmc/core/core.c                            | 240 ++++++++++-----
 drivers/mmc/core/debugfs.c                         |   2 +-
 drivers/mmc/core/mmc.c                             |  57 +++-
 drivers/mmc/core/mmc_ops.c                         |  84 ++++--
 drivers/mmc/core/sdio_bus.c                        |   7 -
 drivers/mmc/core/slot-gpio.c                       |   8 +-
 drivers/mmc/host/Kconfig                           |   9 +
 drivers/mmc/host/Makefile                          |   1 +
 drivers/mmc/host/atmel-mci-regs.h                  |   7 +
 drivers/mmc/host/atmel-mci.c                       | 113 ++++++-
 drivers/mmc/host/bfin_sdh.c                        | 210 ++++++++-----
 drivers/mmc/host/davinci_mmc.c                     | 271 ++++++-----------
 drivers/mmc/host/dw_mmc-exynos.c                   | 253 ++++++++++++++++
 drivers/mmc/host/dw_mmc-pci.c                      |  15 +-
 drivers/mmc/host/dw_mmc-pltfm.c                    |  62 ++--
 drivers/mmc/host/dw_mmc-pltfm.h                    |  20 ++
 drivers/mmc/host/dw_mmc.c                          | 326 +++++++++++++++++----
 drivers/mmc/host/dw_mmc.h                          |  24 ++
 drivers/mmc/host/mmc_spi.c                         |  15 +-
 drivers/mmc/host/mmci.c                            |  13 +-
 drivers/mmc/host/mxcmmc.c                          |  76 ++++-
 drivers/mmc/host/omap.c                            |  39 ++-
 drivers/mmc/host/omap_hsmmc.c                      | 125 +++-----
 drivers/mmc/host/pxamci.c                          |  52 ++++
 drivers/mmc/host/sdhci-dove.c                      |   8 +
 drivers/mmc/host/sdhci-of-esdhc.c                  |  36 ++-
 drivers/mmc/host/sdhci-pci.c                       |  19 +-
 drivers/mmc/host/sdhci-pltfm.c                     |   3 +
 drivers/mmc/host/sdhci-pxav2.c                     |   6 +-
 drivers/mmc/host/sdhci-pxav3.c                     |  35 ++-
 drivers/mmc/host/sdhci-s3c.c                       | 216 ++++++++++++--
 drivers/mmc/host/sdhci-spear.c                     |  67 ++++-
 drivers/mmc/host/sdhci-tegra.c                     |   7 +-
 drivers/mmc/host/sdhci.c                           | 205 ++++++++-----
 drivers/mmc/host/sh_mmcif.c                        |   8 +-
 drivers/mmc/host/via-sdmmc.c                       |  16 +-
 drivers/mmc/host/vub300.c                          |   4 +-
 include/linux/mmc/card.h                           |  18 +-
 include/linux/mmc/core.h                           |   4 +
 include/linux/mmc/dw_mmc.h                         |  15 +-
 include/linux/mmc/host.h                           |   5 +-
 include/linux/mmc/mmc.h                            |  19 ++
 include/linux/mmc/sdhci.h                          |   3 +-
 include/linux/platform_data/pxa_sdhci.h            |   1 +
 55 files changed, 2277 insertions(+), 811 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mmc/atmel-hsmci.txt
 create mode 100644 Documentation/devicetree/bindings/mmc/exynos-dw-mshc.txt
 create mode 100644 Documentation/devicetree/bindings/mmc/pxa-mmc.txt
 create mode 100644 Documentation/devicetree/bindings/mmc/samsung-sdhci.txt
 create mode 100644 Documentation/devicetree/bindings/mmc/sdhci-dove.txt
 create mode 100644 Documentation/devicetree/bindings/mmc/sdhci-spear.txt
 create mode 100644 Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt
 create mode 100644 drivers/mmc/host/dw_mmc-exynos.c
 create mode 100644 drivers/mmc/host/dw_mmc-pltfm.h

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
