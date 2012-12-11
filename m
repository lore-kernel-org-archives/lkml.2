Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab2LKELX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 23:11:23 -0500
Received: from void.printf.net ([89.145.121.20]:39865 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab2LKELV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 23:11:21 -0500
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [GIT PULL] MMC updates for 3.8-rc1
Date: Mon, 10 Dec 2012 23:11:14 -0500
Message-ID: <878v95449p.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-updates-for-3.8-rc1

to receive the MMC merge for 3.8.  There are currently no conflicts,
and these patches have been tested in linux-next.  Thanks.


The following changes since commit 91ab252ac5a5c3461dd6910797611e9172626aed:

  mmc: sh-mmcif: avoid oops on spurious interrupts (second try) (2012-12-06 13:54:35 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-updates-for-3.8-rc1

for you to fetch changes up to 71e69211eac889898dec5a21270347591eb2d001:

  mmc: sdhci: implement the .card_event() method (2012-12-07 13:56:03 -0500)

----------------------------------------------------------------
MMC highlights for 3.8:
Core:
 - Expose access to the eMMC RPMB ("Replay Protected Memory Block") area
   by extending the existing mmc_block ioctl.
 - Add SDIO powered-suspend DT properties to the core MMC DT binding.
 - Add no-1-8-v DT flag for boards where the SD controller reports that it
   supports 1.8V but the board itself has no way to switch to 1.8V.
 - More work on switching to 1.8V UHS support using a vqmmc regulator.
 - Fix up a case where the slot-gpio helper may fail to reset the host
   controller properly if a card was removed during a transfer.
 - Fix several cases where a broken device could cause an infinite loop
   while we wait for a register to update.

Drivers:
 - at91-mci: Remove obsolete driver, atmel-mci handles these devices now.
 - sdhci-dove: Allow using GPIOs for card-detect notifications.
 - sdhci-esdhc: Fix for recovering from ADMA errors on broken silicon.
 - sdhci-s3c: Add pinctrl support.
 - wmt-sdmmc: New driver for WonderMedia SD/MMC controllers.

----------------------------------------------------------------
Abhilash Kesavan (4):
      mmc: dt: Fix typo in filename
      mmc: dt: Add optional pm properties to core binding
      mmc: sdhci-pltfm: Support optional pm properties
      mmc: dw_mmc: Add sdio power bindings

Al Cooper (1):
      mmc: Limit MMC speed to 52MHz if not HS200

Andy Shevchenko (2):
      mmc: dw_mmc: use __devexit_p macro for .remove()
      mmc: dw_mmc: use helper macro module_platform_driver()

Arnd Bergmann (1):
      mmc: dw_mmc: fix more const pointer warnings

Balaji T K (4):
      mmc: omap_hsmmc: remove warning message for debounce clock
      mmc: omap_hsmmc: Fix Oops in case of data errors
      mmc: omap_hsmmc: No reset of cmd state machine for DCRC
      mmc: omap_hsmmc: Update error code for response_busy cmd

Daniel Drake (2):
      mmc: sdhci: add quirk for lack of 1.8v support
      mmc: dt: add no-1-8-v device tree flag

Daniel Mack (2):
      mmc: omap_hsmmc: claim pinctrl at probe time
      mmc: omap_hsmmc: add DT property for max bus frequency

Fabio Estevam (1):
      mmc: mxs-mmc: Remove platform data

Felipe Balbi (1):
      mmc: omap_hsmmc: Introduce omap_hsmmc_prepare/complete

Guennadi Liakhovetski (6):
      mmc: sh_mobile_sdhi: fix clock frequency printing
      mmc: sh_mobile_sdhi: remove unneeded clock connection ID
      mmc: sh_mmcif: remove unneeded clock connection ID
      mmc: add a card-event host operation
      mmc: extend the slot-gpio card-detection to use host's .card_event() method
      mmc: sdhci: implement the .card_event() method

Haijun Zhang (1):
      mmc: eSDHC: Recover from ADMA errors

Hebbar, Gururaja (1):
      mmc: omap_hsmmc: Enable HSPE bit for high speed cards

Jaehoon Chung (2):
      mmc: dw_mmc: relocate where dw_mci_setup_bus() is called from
      mmc: dw_mmc: remove duplicated buswidth code

Javier Martin (1):
      mmc: mxcmmc: fix SD cards not being detected sometimes.

Jerry Huang (1):
      mmc: sdhci-of-esdhc: support commands with busy response expecting TC

Johan Rudholm (1):
      mmc: core: debugfs: Add signal_voltage to ios dump

Kevin Liu (5):
      mmc: sdhci: Balance vmmc regulator_enable(), and always enable vqmmc
      mmc: sdhci-pxav3: Add base clock quirk
      mmc: host: Make UHS timing values fully unique
      mmc: sdhci: Use regulator min/max voltage range according to spec
      mmc: sdhci-pxav3: add quirks2

Kyoungil Kim (1):
      mmc: sdio: Use multiple scatter/gather list

Lee Jones (1):
      mmc: Standardise capability type

Loic Pallardy (5):
      mmc: core: Expose access to RPMB partition
      mmc: card: Do not scan RPMB partitions
      mmc: core: Extend sysfs to ext_csd parameters for RPMB support
      mmc: core: Add mmc_set_blockcount feature
      mmc: card: Add RPMB support in IOCTL interface

Ludovic Desroches (1):
      mmc: at91-mci: remove obsolete driver

Madhvapathi Sriram (1):
      mmc: sdhci-pci: Enable SDHCI_CAN_DO_HISPD for Ricoh SDHCI controller

Marina Makienko (1):
      mmc: vub300: add missing usb_put_dev

Rafael J. Wysocki (1):
      mmc: sdio: Add empty bus-level suspend/resume callbacks

Russell King (3):
      mmc: sdhci-dove: use devm_clk_get()
      mmc: sdhci-dove: use two-stage initialization for sdhci-pltfm
      mmc: sdhci-dove: allow GPIOs to be used for card detection on Dove

Sachin Kamat (3):
      mmc: Remove redundant null check before kfree in sdio_bus.c
      mmc: Remove redundant null check before kfree in bus.c
      mmc: sdhci-s3c: Fix compilation warning

Seungwon Jeon (2):
      mmc: queue: amend buffer swap for non-blocking transfer
      mmc: dw_mmc: use devres functions in dw_mmc

Shawn Guo (1):
      mmc: sdhci-imx-esdhc: use more devm_* functions

Tomasz Figa (2):
      mmc: host: sdhci-s3c: Use devm_gpio_request to request GPIOs
      mmc: host: sdhci-s3c: Add support for pinctrl

Tony Prisk (1):
      mmc: SD/MMC Host Controller for Wondermedia WM8505/WM8650

Trey Ramsay (1):
      mmc: core: Fix some driver hangs when dealing with broken devices

Tushar Behera (1):
      mmc: sdhci-s3c: Use NULL instead of 0 for pointers

Venkatraman S (2):
      mmc: omap_hsmmc: Convert critical failure reports to dev_err
      mmc: omap_hsmmc: Cleanup bitmap definitions of Interrupt Register

Vipul Kumar Samar (1):
      mmc: sdhci-spear: Initialize sdhci clk to 50 MHz

Viresh Kumar (1):
      mmc: sdhci-spear: Don't call clk_{un}prepare() in suspend/resume

 Documentation/devicetree/bindings/mmc/mmc.txt      |    8 +
 .../devicetree/bindings/mmc/samsung-sdhci.txt      |   20 +-
 .../{synposis-dw-mshc.txt => synopsis-dw-mshc.txt} |    0
 .../devicetree/bindings/mmc/ti-omap-hsmmc.txt      |    1 +
 .../devicetree/bindings/mmc/vt8500-sdmmc.txt       |   23 +
 Documentation/mmc/mmc-dev-attrs.txt                |    7 +
 MAINTAINERS                                        |    9 +-
 arch/arm/mach-at91/include/mach/board.h            |   10 -
 arch/arm/plat-omap/include/plat/mmc.h              |    1 +
 drivers/mmc/card/block.c                           |   81 ++
 drivers/mmc/card/queue.c                           |   17 +-
 drivers/mmc/core/bus.c                             |    3 +-
 drivers/mmc/core/core.c                            |   32 +-
 drivers/mmc/core/debugfs.c                         |   16 +
 drivers/mmc/core/mmc.c                             |   19 +-
 drivers/mmc/core/mmc_ops.c                         |   11 +
 drivers/mmc/core/sdio_bus.c                        |   17 +-
 drivers/mmc/core/sdio_io.c                         |   10 +-
 drivers/mmc/core/sdio_ops.c                        |   32 +-
 drivers/mmc/core/slot-gpio.c                       |    8 +-
 drivers/mmc/host/Kconfig                           |   33 +-
 drivers/mmc/host/Makefile                          |    2 +-
 drivers/mmc/host/at91_mci.c                        | 1219 --------------------
 drivers/mmc/host/at91_mci.h                        |  115 --
 drivers/mmc/host/dw_mmc-pci.c                      |    2 +-
 drivers/mmc/host/dw_mmc-pltfm.c                    |   16 +-
 drivers/mmc/host/dw_mmc.c                          |   86 +-
 drivers/mmc/host/mxcmmc.c                          |    2 +-
 drivers/mmc/host/mxs-mmc.c                         |   31 +-
 drivers/mmc/host/omap_hsmmc.c                      |  177 ++-
 drivers/mmc/host/sdhci-dove.c                      |  108 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |   56 +-
 drivers/mmc/host/sdhci-of-esdhc.c                  |   54 +-
 drivers/mmc/host/sdhci-pci.c                       |    1 +
 drivers/mmc/host/sdhci-pltfm.c                     |    9 +
 drivers/mmc/host/sdhci-pxav3.c                     |   13 +-
 drivers/mmc/host/sdhci-s3c.c                       |   58 +-
 drivers/mmc/host/sdhci-spear.c                     |    9 +-
 drivers/mmc/host/sdhci.c                           |   79 +-
 drivers/mmc/host/sdhci.h                           |    5 +-
 drivers/mmc/host/sh_mmcif.c                        |    6 +-
 drivers/mmc/host/sh_mobile_sdhi.c                  |    8 +-
 drivers/mmc/host/vub300.c                          |    1 +
 drivers/mmc/host/wmt-sdmmc.c                       | 1029 +++++++++++++++++
 include/linux/mmc/card.h                           |    2 +
 include/linux/mmc/core.h                           |    2 +
 include/linux/mmc/dw_mmc.h                         |    5 +-
 include/linux/mmc/host.h                           |   17 +-
 include/linux/mmc/mmc.h                            |    2 +
 include/linux/mmc/mxs-mmc.h                        |   19 -
 include/linux/mmc/sdhci.h                          |    6 +-
 include/linux/platform_data/pxa_sdhci.h            |    6 +-
 52 files changed, 1781 insertions(+), 1722 deletions(-)
 rename Documentation/devicetree/bindings/mmc/{synposis-dw-mshc.txt => synopsis-dw-mshc.txt} (100%)
 create mode 100644 Documentation/devicetree/bindings/mmc/vt8500-sdmmc.txt
 delete mode 100644 drivers/mmc/host/at91_mci.c
 delete mode 100644 drivers/mmc/host/at91_mci.h
 create mode 100644 drivers/mmc/host/wmt-sdmmc.c
 delete mode 100644 include/linux/mmc/mxs-mmc.h

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
