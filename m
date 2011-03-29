Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab1C2TBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 15:01:18 -0400
Received: from void.printf.net ([89.145.121.20]:41505 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab1C2TBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 15:01:16 -0400
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: MMC cleanups for 2.6.39
Date: Tue, 29 Mar 2011 15:07:11 -0400
Message-ID: <m3ei5pd9uo.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

to receive a few small driver fixes, and a larger cleanup of the TMIO
MMC driver.  This splits up the driver and touches arch/arm, arch/sh
and drivers/mfd -- these patches all come with ACKs from the relevant
maintainers.  There are no currently no merge conflicts.  Thanks.


The following changes since commit d39dd11c3e6a7af5c20bfac40594db36cf270f42:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../viro/vfs-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

Chris Ball (1):
      mmc: mmc_test: Remove set-but-unused variable.

David Miller (1):
      mmc: of_mmc_spi: Need to include irq.h and of_irq.h

Guennadi Liakhovetski (15):
      mmc: tmio-mmc: Improve DMA stability on sh-mobile
      mmc: tmio: use PIO for short transfers
      mmc: tmio: split core functionality, DMA and MFD glue
      sh: ecovec: use the CONFIG_MMC_TMIO symbols instead of MFD
      mmc: tmio: convert the SDHI MMC driver from MFD to a platform driver
      ARM: mach-shmobile: convert boards to use linux/mmc/sh_mobile_sdhi.h
      sh: convert boards to use linux/mmc/sh_mobile_sdhi.h
      mfd: remove now redundant sh_mobile_sdhi.h header
      mmc: tmio: only access registers above 0xff, if available
      ARM: mach-shmobile: fix SDHI IO address-range
      sh: fix SDHI IO address-range
      mmc: tmio: remove work-around for unmasked SDIO interrupts
      mmc: tmio: fix power-mode interpretation
      mmc: tmio: support aggressive clock gating
      mmc: SDHI should depend on SUPERH || ARCH_SHMOBILE

Jaehoon Chung (1):
      mmc: dw_mmc: set fixed burst in BMOD register

Pawel Moll (1):
      mmc: mmci: Add ARM variant with extended FIFO

Richard Zhu (4):
      mmc: sdhci-esdhc: remove SDHCI_QUIRK_NO_CARD_NO_RESET from esdhc
      mmc: sdhci: add the abort CMDTYPE bits definition
      mmc: sdhci-esdhc: use writel/readl as general APIs
      mmc: sdhci-esdhc: enable esdhc on imx53

Sergei Shtylyov (1):
      mmc: use pci_dev->revision

Simon Horman (1):
      mmc: tmio_mmc: Move some defines into a shared header

Yoshihiro Shimoda (1):
      mmc: fix mmc_app_send_scr() for dma transfer

 arch/arm/mach-shmobile/board-ap4evb.c       |    6 +-
 arch/arm/mach-shmobile/board-g4evm.c        |    6 +-
 arch/arm/mach-shmobile/board-mackerel.c     |    8 +-
 arch/sh/boards/mach-ap325rxa/setup.c        |    6 +-
 arch/sh/boards/mach-ecovec24/setup.c        |   12 +-
 arch/sh/boards/mach-kfr2r09/setup.c         |    4 +-
 arch/sh/boards/mach-migor/setup.c           |    4 +-
 arch/sh/boards/mach-se/7724/setup.c         |    6 +-
 drivers/mfd/Kconfig                         |   14 -
 drivers/mfd/Makefile                        |    1 -
 drivers/mmc/card/mmc_test.c                 |    3 +-
 drivers/mmc/core/sd_ops.c                   |   14 +-
 drivers/mmc/host/Kconfig                    |   14 +-
 drivers/mmc/host/Makefile                   |    8 +-
 drivers/mmc/host/dw_mmc.c                   |    4 +-
 drivers/mmc/host/mmci.c                     |   13 +-
 drivers/mmc/host/of_mmc_spi.c               |    2 +
 drivers/mmc/host/sdhci-esdhc-imx.c          |   86 ++-
 drivers/mmc/host/sdhci-esdhc.h              |    3 +-
 drivers/mmc/host/sdhci-of-esdhc.c           |    3 +-
 drivers/mmc/host/sdhci-pci.c                |    6 +-
 drivers/mmc/host/sdhci-pltfm.h              |    2 +-
 drivers/mmc/host/sdhci.h                    |    1 +
 drivers/{mfd => mmc/host}/sh_mobile_sdhi.c  |   95 +--
 drivers/mmc/host/tmio_mmc.c                 | 1285 +--------------------------
 drivers/mmc/host/tmio_mmc.h                 |  123 +++
 drivers/mmc/host/tmio_mmc_dma.c             |  317 +++++++
 drivers/mmc/host/tmio_mmc_pio.c             |  897 +++++++++++++++++++
 drivers/mmc/host/via-sdmmc.c                |    5 +-
 include/linux/{mfd => mmc}/sh_mobile_sdhi.h |    0
 include/linux/mmc/tmio.h                    |   63 ++
 31 files changed, 1615 insertions(+), 1396 deletions(-)
 rename drivers/{mfd => mmc/host}/sh_mobile_sdhi.c (63%)
 create mode 100644 drivers/mmc/host/tmio_mmc.h
 create mode 100644 drivers/mmc/host/tmio_mmc_dma.c
 create mode 100644 drivers/mmc/host/tmio_mmc_pio.c
 rename include/linux/{mfd => mmc}/sh_mobile_sdhi.h (100%)
 create mode 100644 include/linux/mmc/tmio.h

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
