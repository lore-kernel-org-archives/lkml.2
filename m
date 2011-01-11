Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262Ab1AKFHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 00:07:22 -0500
Received: from void.printf.net ([89.145.121.20]:42085 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765Ab1AKFHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 00:07:17 -0500
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [GIT PULL] MMC updates for 2.6.38-rc1
Date: Tue, 11 Jan 2011 00:12:11 -0500
Message-ID: <m3lj2s58ic.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

to receive the MMC merge for 2.6.38-rc1.  There are currently no merge
conflicts, and the patches have been tested in linux-next.  Thanks.

Highlights are:
Core:
 * Clock gating framework from Linus Walleij.
 * Bus-width testing for MMC devices.
Drivers:
 * Support for the Marvell Dove SDHCI controller.
 * Support for the JMicron 388 SD/MMC controller.
 * Support for the Tegra SoC SDHCI controller.
 * Support for the Synopsys DesignWare SD/MMC controller.
 * SDIO interrupt support for DaVinci and TMIO controllers.
 (TMIO comes with an MFD subsystem change that has a maintainer ACK.)


The following changes since commit 5b2eef966cb2ae307aa4ef1767f7307774bc96ca:

  Merge branch 'drm-core-next' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6 (2011-01-10 17:11:39 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

Alagu Sankar (1):
      mmc: davinci: add support for SDIO irq handling

Alberto Panizzo (2):
      mmc: mxcmmc: Allow binding a regulator to manage the MMC card voltage
      mmc: mxcmmc: update the regulator support code to the latest API

Andy Ross (1):
      mmc: Fix sd/sdio/mmc initialization frequency retries

Aries Lee (1):
      mmc: Test bus-width for old MMC devices

Arnd Hannemann (5):
      mmc: tmio_mmc: silence compiler warnings
      mmc: tmio_mmc: implement SDIO IRQ support
      mfd: sh_mobile_sdhi: activate SDIO IRQ for tmio_mmc
      mmc: tmio_mmc: handle missing HW interrupts
      mmc: tmio_mmc: fix CMD irq handling

Axel Lin (1):
      mmc: mxcmmc: remove a unnecessary release_resource() call

Chris Ball (2):
      mmc: Explain why we make adjacent mmc_bus_{put,get} calls during rescan.
      mmc: MMC_BLOCK_MINORS should depend on MMC_BLOCK.

Guennadi Liakhovetski (5):
      mmc: tmio_mmc: allow multi-element scatter-gather lists
      mmc: tmio_mmc: fix PIO fallback on DMA descriptor allocation failure
      mmc: tmio_mmc: merge the private header into the driver
      mmc: tmio_mmc: implement a bounce buffer for unaligned DMA
      mfd: sdhi: require the tmio-mmc driver to bounce unaligned buffers

Jennifer Li (1):
      mmc: sdhci: Disable ADMA on some O2Micro SD/MMC parts.

Jeongbae Seo (2):
      mmc: sdhci-s3c: Support additional host capabilities
      mmc: sdhci-s3c: Support controllers with no internal clock divider

Joe Perches (1):
      mmc: davinci_mmc: Remove unnecessary semicolon

Linus Walleij (3):
      mmc: Aggressive clock gating framework
      mmc: check for > 1 clk_requests when disabling gating
      mmc: fix division by zero in MMC core

Michal Miroslaw (1):
      mmc: fix detection of memory part of SD-combo card with broken SDIO

Mike Rapoport (2):
      mmc: Add support for the Marvell Dove SDHCI controller
      ARM: dove: Switch SDHCI devices over to "sdhci-dove" driver

Ohad Ben-Cohen (3):
      mmc: skip detection of nonremovable cards on rescan
      mmc: sdio: don't power up cards on system suspend
      mmc: sdio: don't reinitialize nonremovable powered-resumed cards

Olof Johansson (2):
      mmc: sdhci: add quirk for max len ADMA descriptors
      mmc: add sdhci-tegra driver for Tegra SoCs

Philip Rakity (1):
      mmc: sdhci: print SD Command and CAPABILITY_1 when dumping registers

Takashi Iwai (3):
      mmc: Add support for JMicron 388 SD/MMC controller
      mmc: sdhci: Enable bus-width test for JMicron controllers
      mmc: fix mmc_set_bus_width_ddr() call without bus-width-test cap

Viresh Kumar (1):
      mmc: Register debugfs dir before calling card probe function.

Will Newton (1):
      mmc: dw_mmc: Add Synopsys DesignWare mmc host driver.

 arch/arm/mach-dove/common.c              |    4 +-
 arch/arm/mach-tegra/include/mach/sdhci.h |   29 +
 drivers/mfd/sh_mobile_sdhi.c             |    6 +
 drivers/mmc/card/Kconfig                 |    1 +
 drivers/mmc/core/Kconfig                 |   11 +
 drivers/mmc/core/bus.c                   |    8 +-
 drivers/mmc/core/core.c                  |  206 ++--
 drivers/mmc/core/core.h                  |    9 +-
 drivers/mmc/core/debugfs.c               |    5 +
 drivers/mmc/core/host.c                  |  206 ++++-
 drivers/mmc/core/host.h                  |   21 +
 drivers/mmc/core/mmc.c                   |   91 +-
 drivers/mmc/core/mmc_ops.c               |  101 ++
 drivers/mmc/core/mmc_ops.h               |    1 +
 drivers/mmc/core/sd.c                    |   16 +-
 drivers/mmc/core/sdio.c                  |   36 +-
 drivers/mmc/core/sdio_bus.c              |   32 -
 drivers/mmc/host/Kconfig                 |   37 +
 drivers/mmc/host/Makefile                |    3 +
 drivers/mmc/host/davinci_mmc.c           |   80 ++-
 drivers/mmc/host/dw_mmc.c                | 1796 ++++++++++++++++++++++++++++++
 drivers/mmc/host/dw_mmc.h                |  168 +++
 drivers/mmc/host/mxcmmc.c                |   53 +-
 drivers/mmc/host/sdhci-dove.c            |   70 ++
 drivers/mmc/host/sdhci-pci.c             |  161 +++-
 drivers/mmc/host/sdhci-pltfm.c           |    6 +
 drivers/mmc/host/sdhci-pltfm.h           |    2 +
 drivers/mmc/host/sdhci-s3c.c             |   66 ++
 drivers/mmc/host/sdhci-tegra.c           |  257 +++++
 drivers/mmc/host/sdhci.c                 |   45 +-
 drivers/mmc/host/sdhci.h                 |    3 +-
 drivers/mmc/host/tmio_mmc.c              |  561 +++++++++--
 drivers/mmc/host/tmio_mmc.h              |  228 ----
 include/linux/mfd/tmio.h                 |    5 +
 include/linux/mmc/dw_mmc.h               |  217 ++++
 include/linux/mmc/host.h                 |   19 +
 include/linux/mmc/mmc.h                  |    2 +
 include/linux/mmc/sdhci.h                |    6 +
 include/linux/pci_ids.h                  |    7 +
 39 files changed, 4083 insertions(+), 492 deletions(-)
 create mode 100644 arch/arm/mach-tegra/include/mach/sdhci.h
 create mode 100644 drivers/mmc/host/dw_mmc.c
 create mode 100644 drivers/mmc/host/dw_mmc.h
 create mode 100644 drivers/mmc/host/sdhci-dove.c
 create mode 100644 drivers/mmc/host/sdhci-tegra.c
 delete mode 100644 drivers/mmc/host/tmio_mmc.h
 create mode 100644 include/linux/mmc/dw_mmc.h

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
