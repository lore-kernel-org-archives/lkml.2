Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab0J1K1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 06:27:48 -0400
Received: from void.printf.net ([89.145.121.20]:52147 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab0J1K1q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 06:27:46 -0400
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [GIT PULL] MMC updates for 2.6.37-rc1
Date: Thu, 28 Oct 2010 06:28:28 -0400
Message-ID: <m3vd4md31v.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

to receive the MMC changes for v2.6.37-rc1.  There are currently no
merge conflicts.  Thanks.

Highlights are:
* Support for SDHC spec 3.0 controllers
* Support for MMC 4.4 DDR (Dual Data Rate) transfers
* SDIO runtime PM support (opt-in per driver, no change by default)
* New driver for CSR's USB SD Host Controller (USHC)
* New platform driver for Freescale eSDHC i.MX controllers
* New SDHCI driver for Marvell's PXA168/910/MMP2 ARM SoCs
* Support for Intel Medfield/Moorestown devices
* Support for STM ST40 platforms via the sdhci-pltfm driver


The following changes since commit 81280572ca6f54009edfa4deee563e8678784218:

  Merge branch 'upstream-merge' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2010-10-27 21:54:31 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

Adrian Hunter (5):
      mmc_test: fix performance tests that go over max_blk_count
      mmc_test: fix memory allocation segment limits
      mmc_test: fix display of .5 KiB
      mmc: Fixes for Dual Data Rate (DDR) support
      mmc: refine DDR support

Alan Cox (2):
      mmc: sdhci: Allow the probe handler to override slots
      mmc: sdhci: Add Moorestown device support

Andy Shevchenko (7):
      mmc: make mmc_dev_to_card() macro public
      mmc: rename dev_to_mmc_card() to mmc_dev_to_card()
      mmc_test: use API to check card type
      mmc_test: change simple_strtol() to strict_strtol()
      mmc_test: collect data and show it via sysfs by demand
      mmc_test: move files from sysfs to debugfs
      mmc: add a file to debugfs for changing host clock at runtime

David Vrabel (1):
      mmc: USB SD Host Controller (USHC) driver

Eric Bénard (1):
      mmc: sdhci: mmc_rescan: reduce verbosity

Ethan Du (1):
      mmc: name mmc queue thread by host index

George G. Davis (1):
      mmc: sdhci: Make consistent use of CONFIG_MMC_DEBUG for "DEBUG"ging

Giuseppe Cavallaro (4):
      mmc: sdhci: add MMC_CAP_8_BIT_DATA in the host capabilities
      mmc: sdhci-pltfm: add suspend/resume functions
      mmc: sdhci: fix "pwr may be used uninitialized" warning
      mmc: sdhci: split up sdhci.h for sdhci-pltfm users

H Hartley Sweeten (3):
      mmc: at91_mci.c: use resource_size()
      mmc: atmel-mci.c: use resource_size()
      mmc: au1xmmc.c: use resource_size()

Hanumath Prasad (1):
      mmc: MMC 4.4 DDR support

Hein Tibosch (1):
      mmc: Make ID freq configurable

Jaehoon Chung (1):
      mmc: sdhci: disable MMC_CAP_NEEDS_POLL in nonremovable case

JiebingLi (1):
      mmc: Use snprintf, not sprintf.

Linus Walleij (1):
      mmc: Move regulator handling closer to core

Martin K. Petersen (1):
      mmc: Remove distinction between hw and phys segments

Matt Fleming (1):
      mmc: Add helper function to check if a card is removable

Michał Mirosław (5):
      mmc: cb710: partially demystify clock selection
      mmc: cb710: implement get_cd() callback
      mmc: cb710: remove unnecessary msleep()
      mmc: cb710: clear irq handler on init() error path
      mmc: cb710: remove debugging printk (info duplicated from mmc-core)

Ohad Ben-Cohen (9):
      mmc: sdio: fully reconfigure oldcard on resume
      mmc: propagate power save/restore ops return value
      mmc: sdio: add power_restore support
      mmc: add runtime PM handlers
      mmc: sdio: use the generic runtime PM handlers
      mmc: sdio: enable runtime PM for SDIO cards
      mmc: sdio: enable runtime PM for SDIO functions
      mmc: sdio: ensure mmc_sdio_detect is powered
      mmc: sdio: support suspend/resume while runtime suspended

Olof Johansson (1):
      mmc: make number of mmcblk minors configurable

Philip Rakity (3):
      mmc: sdhci: print out controller name for register debug
      mmc: sdhci: highspeed: check for mmc as well as sd cards
      mmc: sdhci: allow for eMMC 74 clock generation by controller

Randy Dunlap (1):
      mmc: fix cb710 kconfig dependency warning

Sonic Zhang (1):
      mmc_spi: Recover from CRC errors for r/w operation over SPI.

Thomas Gleixner (1):
      mmc: Convert "mutex" to semaphore

Wolfram Sang (6):
      mmc: sdhci-pltfm: Add structure for host-specific data
      mmc: sdhci-pltfm: move .h file into appropriate subdir
      mmc: sdhci: introduce get_ro private write-protect hook
      mmc: sdhci_pltfm: pass more data on custom init call
      mmc: sdhci-of-esdhc: factor out common stuff
      mmc: sdhci-pltfm: add -pltfm driver for imx35/51

Xiaochen Shen (1):
      mmc: sdhci: Intel Medfield support

Zhangfei Gao (5):
      mmc: SDHC 3.0: support 10-bit divided clock mode
      mmc: SDHC 3.0: Base clock frequency change in spec 3.0
      mmc: SDHC 3.0: correct f_min calculation for SD 3.0 spec
      mmc: sdhci: Enable high-speed support for MMC cards
      mmc: add new sdhci-pxa driver for Marvell SoCs

matt mooney (1):
      mmc: Makefile: Fix EXTRA_CFLAGS assignment

 Documentation/devices.txt              |    6 +
 arch/arm/plat-pxa/include/plat/sdhci.h |   32 ++
 drivers/mmc/Makefile                   |    4 +-
 drivers/mmc/card/Kconfig               |   17 +
 drivers/mmc/card/Makefile              |    4 -
 drivers/mmc/card/block.c               |   61 ++--
 drivers/mmc/card/mmc_test.c            |  469 ++++++++++++++++++++++-----
 drivers/mmc/card/queue.c               |   14 +-
 drivers/mmc/core/Makefile              |    4 -
 drivers/mmc/core/bus.c                 |   58 +++-
 drivers/mmc/core/bus.h                 |    2 +-
 drivers/mmc/core/core.c                |  179 +++++++----
 drivers/mmc/core/core.h                |    7 +-
 drivers/mmc/core/debugfs.c             |   35 ++-
 drivers/mmc/core/host.c                |    3 +-
 drivers/mmc/core/mmc.c                 |   58 +++-
 drivers/mmc/core/sd.c                  |   10 +-
 drivers/mmc/core/sdio.c                |   54 +++-
 drivers/mmc/core/sdio_bus.c            |   85 +++++-
 drivers/mmc/host/Kconfig               |   37 ++
 drivers/mmc/host/Makefile              |    7 +-
 drivers/mmc/host/at91_mci.c            |   11 +-
 drivers/mmc/host/atmel-mci.c           |    5 +-
 drivers/mmc/host/au1xmmc.c             |    4 +-
 drivers/mmc/host/bfin_sdh.c            |    2 +-
 drivers/mmc/host/cb710-mmc.c           |   54 ++--
 drivers/mmc/host/davinci_mmc.c         |    8 +-
 drivers/mmc/host/imxmmc.c              |    3 +-
 drivers/mmc/host/jz4740_mmc.c          |    3 +-
 drivers/mmc/host/mmc_spi.c             |   24 ++-
 drivers/mmc/host/mmci.c                |   31 +-
 drivers/mmc/host/msm_sdcc.c            |    3 +-
 drivers/mmc/host/mvsdio.c              |    3 +-
 drivers/mmc/host/mxcmmc.c              |    3 +-
 drivers/mmc/host/omap.c                |    3 +-
 drivers/mmc/host/omap_hsmmc.c          |   24 +-
 drivers/mmc/host/pxamci.c              |   43 ++-
 drivers/mmc/host/s3cmci.c              |    3 +-
 drivers/mmc/host/sdhci-cns3xxx.c       |    2 +-
 drivers/mmc/host/sdhci-esdhc-imx.c     |  143 ++++++++
 drivers/mmc/host/sdhci-esdhc.h         |   83 +++++
 drivers/mmc/host/sdhci-of-esdhc.c      |   70 +----
 drivers/mmc/host/sdhci-pci.c           |   89 +++++
 drivers/mmc/host/sdhci-pltfm.c         |   44 ++-
 drivers/mmc/host/sdhci-pltfm.h         |   10 +-
 drivers/mmc/host/sdhci-pxa.c           |  253 ++++++++++++++
 drivers/mmc/host/sdhci.c               |   86 ++++--
 drivers/mmc/host/sdhci.h               |  150 ++--------
 drivers/mmc/host/sh_mmcif.c            |    3 +-
 drivers/mmc/host/tifm_sd.c             |    3 +-
 drivers/mmc/host/ushc.c                |  566 ++++++++++++++++++++++++++++++++
 drivers/mmc/host/via-sdmmc.c           |    3 +-
 drivers/mmc/host/wbsd.c                |    3 +-
 include/linux/mmc/card.h               |    6 +
 include/linux/mmc/core.h               |    2 +
 include/linux/mmc/host.h               |   48 +++-
 include/linux/mmc/mmc.h                |   10 +-
 include/linux/{ => mmc}/sdhci-pltfm.h  |    2 +-
 include/linux/mmc/sdhci.h              |  144 ++++++++
 include/linux/pci_ids.h                |    7 +
 60 files changed, 2535 insertions(+), 565 deletions(-)
 create mode 100644 arch/arm/plat-pxa/include/plat/sdhci.h
 create mode 100644 drivers/mmc/host/sdhci-esdhc-imx.c
 create mode 100644 drivers/mmc/host/sdhci-esdhc.h
 create mode 100644 drivers/mmc/host/sdhci-pxa.c
 create mode 100644 drivers/mmc/host/ushc.c
 rename include/linux/{ => mmc}/sdhci-pltfm.h (93%)
 create mode 100644 include/linux/mmc/sdhci.h

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
