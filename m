Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab2JBRt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 13:49:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54205 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755298Ab2JBRt4 (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Tue, 2 Oct 2012 13:49:56 -0400
Date: Tue, 2 Oct 2012 18:49:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Grant Likely <grant@secretlab.ca>, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] SPI updates for 3.7
Message-ID: <20121002174953.GZ4360@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 979570e02981d4a8fc20b3cc8fd651856c98ee9d:

  Linux 3.6-rc7 (2012-09-23 18:10:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git tags/spi-3.7

for you to fetch changes up to 536a53a300d0d40152796eefb0a9e6e36ca37f7d:

  spi: remove completely broken Tegra driver (2012-10-01 13:29:49 +0100)

I'm still looking after SPI for the time being while Grant's trying to
catch up with things.

----------------------------------------------------------------
spi: Updates for v3.7

No framework work here, only a bunch of driver updates of varying sizes:

- Factoring out of the core hardware support from the MXS MMC driver by
  Marek Vasut to allow the hardware to also be used for SPI.
- Lots of error handling cleanups from Guenter Roeck
- Removal of the existing Tegra driver which is quite comprehensively
  broken as detailed in the changelog for the removal.
- DT suppport for the PL022 and GPIO drivers.
- pinctrl support for OMAP and PL022.

----------------------------------------------------------------
Andrew Lunn (1):
      spi: Refactor spi-orion to use SPI framework queue.

Daniel Mack (2):
      spi: spi-gpio: store chipselect information in private structure
      spi: spi-gpio: Add DT bindings

Guenter Roeck (12):
      spi/pl022: Fix device remove function
      spi/mpc52xx: Fix error handling in probe function
      spi/mpc52xx: Fix device remove function
      spi/mpc52xx-psc: Avoid access to freed memory in device remove function
      spi/mpc512x-psc: Avoid access to freed memory in device remove function
      spi: Master driver for NXP SC18IS602/603
      spi/sc18is602: Return -EINVAL for probe failures due to I2C function mismatch
      spi/stmp: Fix device remove function
      spi/tegra: Fix device remove function
      spi/topcliff-pch: Fix device remove function
      spi/s3c64xx: Drop extra calls to spi_master_get in suspend/remove functions
      spi/mxs: Fix device remove function

Julia Lawall (2):
      drivers/spi/spi-s3c24xx.c: fix error return code
      spi: spi-sh-hspi: drop frees of devm_ alloc'd data

Knut Wohlrab (1):
      spi/imx: set the inactive state of the clock according to the clock polarity

Linus Walleij (2):
      spi/pl022: use more managed resources
      spi/pl022: get/put resources on suspend/resume

Marek Vasut (16):
      mmc: spi: Move SSP register definitions into separate file
      mmc: spi: Rename IMX2[38]_MMC to IMX2[38]_SSP
      mmc: spi: Add necessary bits into mxs-spi.h
      mmc: spi: Pull out parts shared between MMC and SPI
      mmc: spi: Pull out the SSP clock configuration function
      spi/mxs: Add SPI driver for mx233/mx28
      mmc: spi: Pull out common DMA parts from MXS MMC
      spi/mxs: Add DMA support into SPI driver
      spi/mxs: Add SSP/SPI device tree documentation
      mxs/spi: Restart the block after unsuccessful transfer
      mxs/spi: Fix misuse of init_completion
      mxs/spi: Fix issues when doing long continuous transfer
      mxs/spi: Increment the transfer length only if transfer succeeded
      mxs/spi: Decrement the DMA/PIO border
      mxs/spi: Rework the mxs_ssp_timeout to be more readable
      spi/mxs: Make the SPI block clock speed configurable via DT

Mark Brown (4):
      spi/gpio: Fix stub for spi_gpio_probe_dt()
      Merge tag 'v3.6-rc6' into spi-drivers
      Merge tag 'v3.6-rc6' into spi-mxs
      Merge branches 'spi-drivers' and 'spi-mxs' into spi-next

Matt Porter (1):
      spi: omap2-mcspi: add pinctrl support

Patrice Chotard (1):
      spi/pl022: adopt pinctrl support

Roland Stigge (5):
      spi/pl022: Add chip select handling via GPIO
      spi/pl022: Add devicetree support
      spi/dt: DT bindings documentation: "num-cs" property for SPI controllers
      spi/pl022: Fix chipselects pointer computation
      spi/pl022: Devicetree support w/o platform data

Sachin Kamat (1):
      spi: spi-tle62x0: Use module_spi_driver macro

Shubhrajyoti D (5):
      spi: omap2-mcspi: Remove the call to platform_set_drvdata(pdev, NULL)
      spi: omap2-mcspi: Remove the macro MOD_REG_BIT
      spi: omap2-mcspi: Call pm_runtime_* functions directly
      spi: omap2-mcspi: At remove dont use the runtime_autosuspend calls
      spi: omap2-mcspi: Cleanup the omap2_mcspi_txrx_dma function

Stephen Warren (1):
      spi: remove completely broken Tegra driver

Sylwester Nawrocki (1):
      spi/s3c64xx: Don't free controller_data on non-dt platforms

Tobias Klauser (1):
      spi: spi-altera: Use of_match_ptr

 Documentation/devicetree/bindings/spi/mxs-spi.txt  |   22 +
 Documentation/devicetree/bindings/spi/spi-bus.txt  |    3 +
 Documentation/devicetree/bindings/spi/spi-gpio.txt |   29 +
 .../devicetree/bindings/spi/spi-sc18is602.txt      |   23 +
 .../devicetree/bindings/spi/spi_pl022.txt          |   22 +
 Documentation/spi/spi-sc18is602                    |   36 +
 arch/arm/mach-u300/core.c                          |    3 -
 drivers/clk/mxs/Makefile                           |    2 +-
 drivers/clk/mxs/clk-ssp.c                          |   62 ++
 drivers/mmc/host/mxs-mmc.c                         |  323 +++------
 drivers/spi/Kconfig                                |   15 +-
 drivers/spi/Makefile                               |    3 +-
 drivers/spi/spi-altera.c                           |    4 +-
 drivers/spi/spi-gpio.c                             |  131 +++-
 drivers/spi/spi-imx.c                              |    6 +-
 drivers/spi/spi-mpc512x-psc.c                      |    3 +-
 drivers/spi/spi-mpc52xx-psc.c                      |    3 +-
 drivers/spi/spi-mpc52xx.c                          |    9 +-
 drivers/spi/spi-mxs.c                              |  674 +++++++++++++++++++
 drivers/spi/spi-omap2-mcspi.c                      |  321 +++++----
 drivers/spi/spi-orion.c                            |  209 ++----
 drivers/spi/spi-pl022.c                            |  251 +++++--
 drivers/spi/spi-s3c24xx.c                          |    1 +
 drivers/spi/spi-s3c64xx.c                          |   11 +-
 drivers/spi/spi-sc18is602.c                        |  364 ++++++++++
 drivers/spi/spi-sh-hspi.c                          |    5 +-
 drivers/spi/spi-stmp.c                             |    6 +-
 drivers/spi/spi-tegra.c                            |  700 --------------------
 drivers/spi/spi-tle62x0.c                          |   13 +-
 drivers/spi/spi-topcliff-pch.c                     |    2 -
 include/linux/amba/pl022.h                         |    2 +
 include/linux/platform_data/sc18is602.h            |   19 +
 include/linux/spi/mxs-spi.h                        |  150 +++++
 33 files changed, 2114 insertions(+), 1313 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/spi/mxs-spi.txt
 create mode 100644 Documentation/devicetree/bindings/spi/spi-gpio.txt
 create mode 100644 Documentation/devicetree/bindings/spi/spi-sc18is602.txt
 create mode 100644 Documentation/spi/spi-sc18is602
 create mode 100644 drivers/clk/mxs/clk-ssp.c
 create mode 100644 drivers/spi/spi-mxs.c
 create mode 100644 drivers/spi/spi-sc18is602.c
 delete mode 100644 drivers/spi/spi-tegra.c
 create mode 100644 include/linux/platform_data/sc18is602.h
 create mode 100644 include/linux/spi/mxs-spi.h
