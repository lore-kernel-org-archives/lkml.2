Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab2LMR2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 12:28:15 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:44738 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab2LMR2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 12:28:14 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 13 Dec 2012 17:27:53 +0000
X-Google-Sender-Auth: kJlQXNqgcve8DdwvN3690dY_AaQ
Message-ID: <CACxGe6vuJd2vC6phw+e1RYyhg5MSR=2_KJvH39mEHm=hBgbk5w@mail.gmail.com>
Subject: [GIT PULL] SPI changes for v3.8
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        spi-devel-general@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the below SPI changes as described below.

g.

The following changes since commit b69f0859dc8e633c5d8c06845811588fe17e68b3:

  Linux 3.7-rc8 (2012-12-03 11:22:37 -0800)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 tags/spi-for-linus

for you to fetch changes up to 7cb943615aabbd72624f77f0a84b8c5d627cf846:

  spi/sparc: Allow of_register_spi_devices for sparc (2012-12-10 22:31:37 +0000)

----------------------------------------------------------------
SPI changes for v3.8

Primarily SPI device driver bug fixes, one removal of an old driver, and
some new tegra support. There is some core code change too, but all in
all pretty small stuff. The new features to note are:
- Common code for describing GPIO CS lines in the device tree
- Remove the SPI_BUFSIZ limitation on spi_write_the_read()
- core spi ensures bits_per_word is set correctly
- SPARC can now use SPI

----------------------------------------------------------------
Abhilash Kesavan (1):
      spi: s3c64xx: Add fix for crash in spi suspend/resume

Alexander Shiyan (1):
      spi/clps711x: New SPI master driver

Andreas Larsson (1):
      spi/sparc: Allow of_register_spi_devices for sparc

Bastian Hecht (2):
      spi/sh-msiof: Remove unneeded clock name
      spi/sh: Add SH Mobile series as dependency to MSIOF controller

Daniel Mack (2):
      spi/mcspi: allow configuration of pin directions
      spi/omap: fix D0/D1 direction confusion

Florian Fainelli (3):
      spi/bcm63xx: remove driver version
      spi/bcm63xx: add missing spi_master_{resume,suspend} calls to PM callbacks
      spi/bcm63xx: remove useless call to bcm63xx_spi_check_transfer()

Grant Likely (4):
      Merge branch 'spi-next' from git://git.kernel.org/.../broonie/misc.git
      spi: Fix comparison of different integer types
      Merge tag 'v3.7-rc8' into spi/next
      spi: Remove HOTPLUG section attributes

Guennadi Liakhovetski (2):
      spi/bitbang: avoid needless loop flow manipulations
      spi/bitbang: (cosmetic) simplify list manipulation

Jason Gunthorpe (1):
      spi/orion: Add SPI_CHPA and SPI_CPOL support to kirkwood driver.

Jean-Christophe PLAGNIOL-VILLARD (1):
      of_spi: add generic binding support to specify cs gpio

Lars-Peter Clausen (1):
      spi: Add support for specifying 3-wire mode via device tree

Laxman Dewangan (5):
      spi: tegra: add spi driver for SLINK controller
      spi: make sure all transfer has bits_per_word set
      spi: tegra: sequence compatible strings as per preference
      spi: Dont call master->setup if not populated
      spi: tegra: add spi driver for sflash controller

Mark Brown (11):
      Merge branch 'spi-linus', remote-tracking branches
'misc/spi/bcm63xx', 'misc/spi/mcspi', 'misc/spi/mxs' and
'misc/spi/s3c64xx' into spi-next
      Merge branch 'spi-pl022' into spi-next
      Merge tag 'spi-linus' into spi-next
      Merge branch 'spi-tegra' into spi-next
      Merge branch 'spi-spidev' into spi-next
      Merge branch 'spi-linus' into spi-next
      Merge branch 'spi-fix-s3c64xx' into spi-next
      Merge branches 'spi-core' and 'spi-tegra' into spi-next
      Merge branch 'spi-tegra' into spi-next
      Merge branch 'spi-mcspi' into spi-next
      spi: Remove SPI_BUFSIZ restriction on spi_write_then_read()

Maxime Ripard (2):
      spi: spidev: Add device tree bindings
      spi: spidev: Add Rohm DH2228FV DAC compatible string

Patrice Chotard (1):
      spi/pl022: add IDLE state pin management

Phil Edworthy (1):
      spi/sh-hspi: add CS manual control support

Sachin Kamat (1):
      spi: omap2-mcspi: remove duplicate inclusion of linux/err.h

Shubhrajyoti D (2):
      spi: omap2-mcspi: Reorder the wait_for_completion for tx
      spi: omap2-mcspi: Fix the redifine warning

Thomas Abraham (1):
      spi/s3c64xx: use clk_prepare_enable and clk_disable_unprepare

Ulf Hansson (3):
      spi/pl022: Revert "spi/pl022: fix spi-pl022 pm enable at probe"
      spi/pl022: Minor simplification for runtime pm
      spi/pl022: Activate resourses before deactivate them in suspend

Wei Yongjun (1):
      spi: omap2-mcspi: remove duplicated include from spi-omap2-mcspi.c

Wolfram Sang (1):
      spi/stmp: remove obsolete driver

 .../bindings/spi/nvidia,tegra20-sflash.txt         |   26 +
 .../bindings/spi/nvidia,tegra20-slink.txt          |   26 +
 Documentation/devicetree/bindings/spi/omap-spi.txt |    4 +-
 Documentation/devicetree/bindings/spi/spi-bus.txt  |   22 +
 drivers/spi/Kconfig                                |   31 +-
 drivers/spi/Makefile                               |    5 +-
 drivers/spi/spi-altera.c                           |    6 +-
 drivers/spi/spi-ath79.c                            |    6 +-
 drivers/spi/spi-atmel.c                            |    4 +-
 drivers/spi/spi-bcm63xx.c                          |   22 +-
 drivers/spi/spi-bfin-sport.c                       |    8 +-
 drivers/spi/spi-bfin5xx.c                          |    4 +-
 drivers/spi/spi-bitbang.c                          |   27 +-
 drivers/spi/spi-clps711x.c                         |  296 +++++
 drivers/spi/spi-coldfire-qspi.c                    |    6 +-
 drivers/spi/spi-davinci.c                          |    6 +-
 drivers/spi/spi-dw-mmio.c                          |    6 +-
 drivers/spi/spi-dw-pci.c                           |    6 +-
 drivers/spi/spi-dw.c                               |    6 +-
 drivers/spi/spi-ep93xx.c                           |    6 +-
 drivers/spi/spi-falcon.c                           |    6 +-
 drivers/spi/spi-fsl-espi.c                         |    8 +-
 drivers/spi/spi-fsl-lib.c                          |    4 +-
 drivers/spi/spi-fsl-spi.c                          |   14 +-
 drivers/spi/spi-gpio.c                             |   13 +-
 drivers/spi/spi-imx.c                              |    6 +-
 drivers/spi/spi-mpc512x-psc.c                      |   10 +-
 drivers/spi/spi-mpc52xx-psc.c                      |    8 +-
 drivers/spi/spi-mpc52xx.c                          |    8 +-
 drivers/spi/spi-mxs.c                              |    6 +-
 drivers/spi/spi-nuc900.c                           |    6 +-
 drivers/spi/spi-oc-tiny.c                          |   10 +-
 drivers/spi/spi-octeon.c                           |    6 +-
 drivers/spi/spi-omap-100k.c                        |    2 +-
 drivers/spi/spi-omap2-mcspi.c                      |   76 +-
 drivers/spi/spi-orion.c                            |   27 +-
 drivers/spi/spi-pl022.c                            |   61 +-
 drivers/spi/spi-pxa2xx-pci.c                       |    6 +-
 drivers/spi/spi-pxa2xx.c                           |    4 +-
 drivers/spi/spi-rspi.c                             |   10 +-
 drivers/spi/spi-s3c24xx.c                          |    6 +-
 drivers/spi/spi-s3c64xx.c                          |   38 +-
 drivers/spi/spi-sh-hspi.c                          |   49 +-
 drivers/spi/spi-sh-msiof.c                         |    6 +-
 drivers/spi/spi-sh.c                               |    6 +-
 drivers/spi/spi-sirf.c                             |    6 +-
 drivers/spi/spi-stmp.c                             |  664 ----------
 drivers/spi/spi-tegra20-sflash.c                   |  665 ++++++++++
 drivers/spi/spi-tegra20-slink.c                    | 1358 ++++++++++++++++++++
 drivers/spi/spi-ti-ssp.c                           |    6 +-
 drivers/spi/spi-tle62x0.c                          |    6 +-
 drivers/spi/spi-topcliff-pch.c                     |   12 +-
 drivers/spi/spi-xcomm.c                            |    6 +-
 drivers/spi/spi-xilinx.c                           |    6 +-
 drivers/spi/spi.c                                  |  101 +-
 drivers/spi/spidev.c                               |   16 +-
 include/linux/platform_data/spi-clps711x.h         |   21 +
 include/linux/platform_data/spi-omap2-mcspi.h      |    4 +
 include/linux/spi/spi-tegra.h                      |   40 +
 include/linux/spi/spi.h                            |    3 +
 60 files changed, 2894 insertions(+), 939 deletions(-)
 create mode 100644
Documentation/devicetree/bindings/spi/nvidia,tegra20-sflash.txt
 create mode 100644
Documentation/devicetree/bindings/spi/nvidia,tegra20-slink.txt
 create mode 100644 drivers/spi/spi-clps711x.c
 delete mode 100644 drivers/spi/spi-stmp.c
 create mode 100644 drivers/spi/spi-tegra20-sflash.c
 create mode 100644 drivers/spi/spi-tegra20-slink.c
 create mode 100644 include/linux/platform_data/spi-clps711x.h
 create mode 100644 include/linux/spi/spi-tegra.h

--
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
