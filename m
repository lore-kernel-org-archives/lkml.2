Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab1FFHSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 03:18:32 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:52921 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab1FFHSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 03:18:30 -0400
Subject: [PATCH v2] spi: reorganize drivers
To: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 06 Jun 2011 01:18:29 -0600
Message-ID: <20110606071829.10334.90865.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sort the SPI makefile and enforce the naming convention spi_*.c for
spi drivers.

This change also rolls the contents of atmel_spi.h into the .c file
since there is only one user of that particular include file.

v2: - Use 'spi-' prefix instead of 'spi_' to match what seems to be
      be the predominant pattern for subsystem prefixes.
    - Clean up filenames in Kconfig and header comment blocks

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/spi/Kconfig             |   18 ----
 drivers/spi/Makefile            |  112 ++++++++++++--------------
 drivers/spi/atmel_spi.h         |  167 ---------------------------------------
 drivers/spi/spi-altera.c        |    0 
 drivers/spi/spi-ath79.c         |    0 
 drivers/spi/spi-atmel.c         |  155 ++++++++++++++++++++++++++++++++++++
 drivers/spi/spi-au1550.c        |    2 
 drivers/spi/spi-bfin-sport.c    |    0 
 drivers/spi/spi-bfin5xx.c       |    0 
 drivers/spi/spi-bitbang-txrx.h  |    0 
 drivers/spi/spi-bitbang.c       |    2 
 drivers/spi/spi-butterfly.c     |    4 -
 drivers/spi/spi-coldfire-qspi.c |    0 
 drivers/spi/spi-davinci.c       |    0 
 drivers/spi/spi-dw-mid.c        |    4 -
 drivers/spi/spi-dw-mmio.c       |    4 -
 drivers/spi/spi-dw-pci.c        |    4 -
 drivers/spi/spi-dw.c            |    4 -
 drivers/spi/spi-dw.h            |    0 
 drivers/spi/spi-ep93xx.c        |    0 
 drivers/spi/spi-fsl-espi.c      |    2 
 drivers/spi/spi-fsl-lib.c       |    2 
 drivers/spi/spi-fsl-lib.h       |    0 
 drivers/spi/spi-fsl-spi.c       |    2 
 drivers/spi/spi-gpio.c          |    6 +
 drivers/spi/spi-imx.c           |    0 
 drivers/spi/spi-lm70llp.c       |    4 -
 drivers/spi/spi-mpc512x-psc.c   |    0 
 drivers/spi/spi-mpc52xx-psc.c   |    0 
 drivers/spi/spi-mpc52xx.c       |    0 
 drivers/spi/spi-nuc900.c        |    5 -
 drivers/spi/spi-oc-tiny.c       |    0 
 drivers/spi/spi-omap-100k.c     |    0 
 drivers/spi/spi-omap-uwire.c    |    2 
 drivers/spi/spi-omap2-mcspi.c   |    0 
 drivers/spi/spi-orion.c         |    2 
 drivers/spi/spi-pl022.c         |    2 
 drivers/spi/spi-ppc4xx.c        |    0 
 drivers/spi/spi-pxa2xx-pci.c    |    0 
 drivers/spi/spi-pxa2xx.c        |    0 
 drivers/spi/spi-s3c24xx-fiq.S   |    2 
 drivers/spi/spi-s3c24xx-fiq.h   |    0 
 drivers/spi/spi-s3c24xx-gpio.c  |    5 -
 drivers/spi/spi-s3c24xx.c       |    5 -
 drivers/spi/spi-s3c64xx.c       |    3 -
 drivers/spi/spi-sh-msiof.c      |    0 
 drivers/spi/spi-sh-sci.c        |    2 
 drivers/spi/spi-sh.c            |    0 
 drivers/spi/spi-stmp.c          |    0 
 drivers/spi/spi-tegra.c         |    0 
 drivers/spi/spi-ti-ssp.c        |    0 
 drivers/spi/spi-tle62x0.c       |    2 
 drivers/spi/spi-topcliff-pch.c  |    0 
 drivers/spi/spi-txx9.c          |    2 
 drivers/spi/spi-xilinx.c        |    0 
 drivers/spi/spi.c               |    2 
 drivers/spi/spidev.c            |    2 
 57 files changed, 239 insertions(+), 289 deletions(-)
 delete mode 100644 drivers/spi/atmel_spi.h
 rename drivers/spi/{spi_altera.c => spi-altera.c} (100%)
 rename drivers/spi/{ath79_spi.c => spi-ath79.c} (100%)
 rename drivers/spi/{atmel_spi.c => spi-atmel.c} (85%)
 rename drivers/spi/{au1550_spi.c => spi-au1550.c} (99%)
 rename drivers/spi/{spi_bfin_sport.c => spi-bfin-sport.c} (100%)
 rename drivers/spi/{spi_bfin5xx.c => spi-bfin5xx.c} (100%)
 rename drivers/spi/{spi_bitbang_txrx.h => spi-bitbang-txrx.h} (100%)
 rename drivers/spi/{spi_bitbang.c => spi-bitbang.c} (99%)
 rename drivers/spi/{spi_butterfly.c => spi-butterfly.c} (99%)
 rename drivers/spi/{coldfire_qspi.c => spi-coldfire-qspi.c} (100%)
 rename drivers/spi/{davinci_spi.c => spi-davinci.c} (100%)
 rename drivers/spi/{dw_spi_mid.c => spi-dw-mid.c} (98%)
 rename drivers/spi/{dw_spi_mmio.c => spi-dw-mmio.c} (97%)
 rename drivers/spi/{dw_spi_pci.c => spi-dw-pci.c} (98%)
 rename drivers/spi/{dw_spi.c => spi-dw.c} (99%)
 rename drivers/spi/{dw_spi.h => spi-dw.h} (100%)
 rename drivers/spi/{ep93xx_spi.c => spi-ep93xx.c} (100%)
 rename drivers/spi/{spi_fsl_espi.c => spi-fsl-espi.c} (99%)
 rename drivers/spi/{spi_fsl_lib.c => spi-fsl-lib.c} (99%)
 rename drivers/spi/{spi_fsl_lib.h => spi-fsl-lib.h} (100%)
 rename drivers/spi/{spi_fsl_spi.c => spi-fsl-spi.c} (99%)
 rename drivers/spi/{spi_gpio.c => spi-gpio.c} (99%)
 rename drivers/spi/{spi_imx.c => spi-imx.c} (100%)
 rename drivers/spi/{spi_lm70llp.c => spi-lm70llp.c} (98%)
 rename drivers/spi/{mpc512x_psc_spi.c => spi-mpc512x-psc.c} (100%)
 rename drivers/spi/{mpc52xx_psc_spi.c => spi-mpc52xx-psc.c} (100%)
 rename drivers/spi/{mpc52xx_spi.c => spi-mpc52xx.c} (100%)
 rename drivers/spi/{spi_nuc900.c => spi-nuc900.c} (99%)
 rename drivers/spi/{spi_oc_tiny.c => spi-oc-tiny.c} (100%)
 rename drivers/spi/{omap_spi_100k.c => spi-omap-100k.c} (100%)
 rename drivers/spi/{omap_uwire.c => spi-omap-uwire.c} (99%)
 rename drivers/spi/{omap2_mcspi.c => spi-omap2-mcspi.c} (100%)
 rename drivers/spi/{orion_spi.c => spi-orion.c} (99%)
 rename drivers/spi/{amba-pl022.c => spi-pl022.c} (99%)
 rename drivers/spi/{spi_ppc4xx.c => spi-ppc4xx.c} (100%)
 rename drivers/spi/{pxa2xx_spi_pci.c => spi-pxa2xx-pci.c} (100%)
 rename drivers/spi/{pxa2xx_spi.c => spi-pxa2xx.c} (100%)
 rename drivers/spi/{spi_s3c24xx_fiq.S => spi-s3c24xx-fiq.S} (99%)
 rename drivers/spi/{spi_s3c24xx_fiq.h => spi-s3c24xx-fiq.h} (100%)
 rename drivers/spi/{spi_s3c24xx_gpio.c => spi-s3c24xx-gpio.c} (98%)
 rename drivers/spi/{spi_s3c24xx.c => spi-s3c24xx.c} (99%)
 rename drivers/spi/{spi_s3c64xx.c => spi-s3c64xx.c} (99%)
 rename drivers/spi/{spi_sh_msiof.c => spi-sh-msiof.c} (100%)
 rename drivers/spi/{spi_sh_sci.c => spi-sh-sci.c} (99%)
 rename drivers/spi/{spi_sh.c => spi-sh.c} (100%)
 rename drivers/spi/{spi_stmp.c => spi-stmp.c} (100%)
 rename drivers/spi/{spi_tegra.c => spi-tegra.c} (100%)
 rename drivers/spi/{ti-ssp-spi.c => spi-ti-ssp.c} (100%)
 rename drivers/spi/{tle62x0.c => spi-tle62x0.c} (99%)
 rename drivers/spi/{spi_topcliff_pch.c => spi-topcliff-pch.c} (100%)
 rename drivers/spi/{spi_txx9.c => spi-txx9.c} (99%)
 rename drivers/spi/{xilinx_spi.c => spi-xilinx.c} (100%)

 drivers/spi/Kconfig                                |   18 --
 drivers/spi/Makefile                               |  112 ++++++-------
 drivers/spi/atmel_spi.h                            |  167 --------------------
 drivers/spi/{spi_altera.c => spi-altera.c}         |    0
 drivers/spi/{ath79_spi.c => spi-ath79.c}           |    0
 drivers/spi/{atmel_spi.c => spi-atmel.c}           |  155 ++++++++++++++++++-
 drivers/spi/{au1550_spi.c => spi-au1550.c}         |    2 +-
 drivers/spi/{spi_bfin_sport.c => spi-bfin-sport.c} |    0
 drivers/spi/{spi_bfin5xx.c => spi-bfin5xx.c}       |    0
 .../spi/{spi_bitbang_txrx.h => spi-bitbang-txrx.h} |    0
 drivers/spi/{spi_bitbang.c => spi-bitbang.c}       |    2 +-
 drivers/spi/{spi_butterfly.c => spi-butterfly.c}   |    4 +-
 .../spi/{coldfire_qspi.c => spi-coldfire-qspi.c}   |    0
 drivers/spi/{davinci_spi.c => spi-davinci.c}       |    0
 drivers/spi/{dw_spi_mid.c => spi-dw-mid.c}         |    4 +-
 drivers/spi/{dw_spi_mmio.c => spi-dw-mmio.c}       |    4 +-
 drivers/spi/{dw_spi_pci.c => spi-dw-pci.c}         |    4 +-
 drivers/spi/{dw_spi.c => spi-dw.c}                 |    4 +-
 drivers/spi/{dw_spi.h => spi-dw.h}                 |    0
 drivers/spi/{ep93xx_spi.c => spi-ep93xx.c}         |    0
 drivers/spi/{spi_fsl_espi.c => spi-fsl-espi.c}     |    2 +-
 drivers/spi/{spi_fsl_lib.c => spi-fsl-lib.c}       |    2 +-
 drivers/spi/{spi_fsl_lib.h => spi-fsl-lib.h}       |    0
 drivers/spi/{spi_fsl_spi.c => spi-fsl-spi.c}       |    2 +-
 drivers/spi/{spi_gpio.c => spi-gpio.c}             |    6 +-
 drivers/spi/{spi_imx.c => spi-imx.c}               |    0
 drivers/spi/{spi_lm70llp.c => spi-lm70llp.c}       |    4 +-
 .../spi/{mpc512x_psc_spi.c => spi-mpc512x-psc.c}   |    0
 .../spi/{mpc52xx_psc_spi.c => spi-mpc52xx-psc.c}   |    0
 drivers/spi/{mpc52xx_spi.c => spi-mpc52xx.c}       |    0
 drivers/spi/{spi_nuc900.c => spi-nuc900.c}         |    5 +-
 drivers/spi/{spi_oc_tiny.c => spi-oc-tiny.c}       |    0
 drivers/spi/{omap_spi_100k.c => spi-omap-100k.c}   |    0
 drivers/spi/{omap_uwire.c => spi-omap-uwire.c}     |    2 +-
 drivers/spi/{omap2_mcspi.c => spi-omap2-mcspi.c}   |    0
 drivers/spi/{orion_spi.c => spi-orion.c}           |    2 +-
 drivers/spi/{amba-pl022.c => spi-pl022.c}          |    2 -
 drivers/spi/{spi_ppc4xx.c => spi-ppc4xx.c}         |    0
 drivers/spi/{pxa2xx_spi_pci.c => spi-pxa2xx-pci.c} |    0
 drivers/spi/{pxa2xx_spi.c => spi-pxa2xx.c}         |    0
 .../spi/{spi_s3c24xx_fiq.S => spi-s3c24xx-fiq.S}   |    2 +-
 .../spi/{spi_s3c24xx_fiq.h => spi-s3c24xx-fiq.h}   |    0
 .../spi/{spi_s3c24xx_gpio.c => spi-s3c24xx-gpio.c} |    5 +-
 drivers/spi/{spi_s3c24xx.c => spi-s3c24xx.c}       |    5 +-
 drivers/spi/{spi_s3c64xx.c => spi-s3c64xx.c}       |    3 +-
 drivers/spi/{spi_sh_msiof.c => spi-sh-msiof.c}     |    0
 drivers/spi/{spi_sh_sci.c => spi-sh-sci.c}         |    2 +-
 drivers/spi/{spi_sh.c => spi-sh.c}                 |    0
 drivers/spi/{spi_stmp.c => spi-stmp.c}             |    0
 drivers/spi/{spi_tegra.c => spi-tegra.c}           |    0
 drivers/spi/{ti-ssp-spi.c => spi-ti-ssp.c}         |    0
 drivers/spi/{tle62x0.c => spi-tle62x0.c}           |    2 +-
 .../spi/{spi_topcliff_pch.c => spi-topcliff-pch.c} |    0
 drivers/spi/{spi_txx9.c => spi-txx9.c}             |    2 +-
 drivers/spi/{xilinx_spi.c => spi-xilinx.c}         |    0
 drivers/spi/spi.c                                  |    2 +-
 drivers/spi/spidev.c                               |    2 +-
 57 files changed, 239 insertions(+), 289 deletions(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index de35c3a..9578a84 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -86,9 +86,6 @@ config SPI_BFIN_SPORT
 	help
 	  Enable support for a SPI bus via the Blackfin SPORT peripheral.
 
-	  This driver can also be built as a module.  If so, the module
-	  will be called spi_bfin_sport.
-
 config SPI_AU1550
 	tristate "Au1550/Au12x0 SPI Controller"
 	depends on (SOC_AU1550 || SOC_AU1200) && EXPERIMENTAL
@@ -97,9 +94,6 @@ config SPI_AU1550
 	  If you say yes to this option, support will be included for the
 	  Au1550 SPI controller (may also work with Au1200,Au1210,Au1250).
 
-	  This driver can also be built as a module.  If so, the module
-	  will be called au1550_spi.
-
 config SPI_BITBANG
 	tristate "Utilities for Bitbanging SPI masters"
 	help
@@ -130,9 +124,6 @@ config SPI_COLDFIRE_QSPI
 	  This enables support for the Coldfire QSPI controller in master
 	  mode.
 
-	  This driver can also be built as a module.  If so, the module
-	  will be called coldfire_qspi.
-
 config SPI_DAVINCI
 	tristate "Texas Instruments DaVinci/DA8x/OMAP-L/AM1x SoC SPI controller"
 	depends on SPI_MASTER && ARCH_DAVINCI
@@ -140,9 +131,6 @@ config SPI_DAVINCI
 	help
 	  SPI master controller for DaVinci/DA8x/OMAP-L/AM1x SPI modules.
 
-	  This driver can also be built as a module. The module will be called
-	  davinci_spi.
-
 config SPI_EP93XX
 	tristate "Cirrus Logic EP93xx SPI controller"
 	depends on ARCH_EP93XX
@@ -150,9 +138,6 @@ config SPI_EP93XX
 	  This enables using the Cirrus EP93xx SPI controller in master
 	  mode.
 
-	  To compile this driver as a module, choose M here. The module will be
-	  called ep93xx_spi.
-
 config SPI_GPIO
 	tristate "GPIO-based bitbanging SPI Master"
 	depends on GENERIC_GPIO
@@ -385,9 +370,6 @@ config SPI_TI_SSP
 	  This selects an SPI master implementation using a TI sequencer
 	  serial port.
 
-	  To compile this driver as a module, choose M here: the
-	  module will be called ti-ssp-spi.
-
 config SPI_TOPCLIFF_PCH
 	tristate "Topcliff PCH SPI Controller"
 	depends on PCI
diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
index 0f8c69b..f6d5018 100644
--- a/drivers/spi/Makefile
+++ b/drivers/spi/Makefile
@@ -7,68 +7,56 @@ ccflags-$(CONFIG_SPI_DEBUG) := -DDEBUG
 # small core, mostly translating board-specific
 # config declarations into driver model code
 obj-$(CONFIG_SPI_MASTER)		+= spi.o
+obj-$(CONFIG_SPI_SPIDEV)		+= spidev.o
 
 # SPI master controller drivers (bus)
-obj-$(CONFIG_SPI_ALTERA)		+= spi_altera.o
-obj-$(CONFIG_SPI_ATMEL)			+= atmel_spi.o
-obj-$(CONFIG_SPI_ATH79)			+= ath79_spi.o
-obj-$(CONFIG_SPI_BFIN)			+= spi_bfin5xx.o
-obj-$(CONFIG_SPI_BFIN_SPORT)		+= spi_bfin_sport.o
-obj-$(CONFIG_SPI_BITBANG)		+= spi_bitbang.o
-obj-$(CONFIG_SPI_AU1550)		+= au1550_spi.o
-obj-$(CONFIG_SPI_BUTTERFLY)		+= spi_butterfly.o
-obj-$(CONFIG_SPI_COLDFIRE_QSPI)		+= coldfire_qspi.o
-obj-$(CONFIG_SPI_DAVINCI)		+= davinci_spi.o
-obj-$(CONFIG_SPI_DESIGNWARE)		+= dw_spi.o
-obj-$(CONFIG_SPI_DW_PCI)		+= dw_spi_midpci.o
-dw_spi_midpci-objs			:= dw_spi_pci.o dw_spi_mid.o
-obj-$(CONFIG_SPI_DW_MMIO)		+= dw_spi_mmio.o
-obj-$(CONFIG_SPI_EP93XX)		+= ep93xx_spi.o
-obj-$(CONFIG_SPI_GPIO)			+= spi_gpio.o
-obj-$(CONFIG_SPI_IMX)			+= spi_imx.o
-obj-$(CONFIG_SPI_LM70_LLP)		+= spi_lm70llp.o
-obj-$(CONFIG_SPI_PXA2XX)		+= pxa2xx_spi.o
-obj-$(CONFIG_SPI_PXA2XX_PCI)		+= pxa2xx_spi_pci.o
-obj-$(CONFIG_SPI_OC_TINY)		+= spi_oc_tiny.o
-obj-$(CONFIG_SPI_OMAP_UWIRE)		+= omap_uwire.o
-obj-$(CONFIG_SPI_OMAP24XX)		+= omap2_mcspi.o
-obj-$(CONFIG_SPI_OMAP_100K)		+= omap_spi_100k.o
-obj-$(CONFIG_SPI_ORION)			+= orion_spi.o
-obj-$(CONFIG_SPI_PL022)			+= amba-pl022.o
-obj-$(CONFIG_SPI_MPC512x_PSC)		+= mpc512x_psc_spi.o
-obj-$(CONFIG_SPI_MPC52xx_PSC)		+= mpc52xx_psc_spi.o
-obj-$(CONFIG_SPI_MPC52xx)		+= mpc52xx_spi.o
-obj-$(CONFIG_SPI_FSL_LIB)		+= spi_fsl_lib.o
-obj-$(CONFIG_SPI_FSL_ESPI)		+= spi_fsl_espi.o
-obj-$(CONFIG_SPI_FSL_SPI)		+= spi_fsl_spi.o
-obj-$(CONFIG_SPI_PPC4xx)		+= spi_ppc4xx.o
-obj-$(CONFIG_SPI_S3C24XX_GPIO)		+= spi_s3c24xx_gpio.o
-obj-$(CONFIG_SPI_S3C24XX)		+= spi_s3c24xx_hw.o
-obj-$(CONFIG_SPI_S3C64XX)		+= spi_s3c64xx.o
-obj-$(CONFIG_SPI_TEGRA)			+= spi_tegra.o
-obj-$(CONFIG_SPI_TI_SSP)		+= ti-ssp-spi.o
-obj-$(CONFIG_SPI_TOPCLIFF_PCH)		+= spi_topcliff_pch.o
-obj-$(CONFIG_SPI_TXX9)			+= spi_txx9.o
-obj-$(CONFIG_SPI_XILINX)		+= xilinx_spi.o
-obj-$(CONFIG_SPI_SH)			+= spi_sh.o
-obj-$(CONFIG_SPI_SH_SCI)		+= spi_sh_sci.o
-obj-$(CONFIG_SPI_SH_MSIOF)		+= spi_sh_msiof.o
-obj-$(CONFIG_SPI_STMP3XXX)		+= spi_stmp.o
-obj-$(CONFIG_SPI_NUC900)		+= spi_nuc900.o
+obj-$(CONFIG_SPI_ALTERA)		+= spi-altera.o
+obj-$(CONFIG_SPI_ATMEL)			+= spi-atmel.o
+obj-$(CONFIG_SPI_ATH79)			+= spi-ath79.o
+obj-$(CONFIG_SPI_AU1550)		+= spi-au1550.o
+obj-$(CONFIG_SPI_BFIN)			+= spi-bfin5xx.o
+obj-$(CONFIG_SPI_BFIN_SPORT)		+= spi-bfin-sport.o
+obj-$(CONFIG_SPI_BITBANG)		+= spi-bitbang.o
+obj-$(CONFIG_SPI_BUTTERFLY)		+= spi-butterfly.o
+obj-$(CONFIG_SPI_COLDFIRE_QSPI)		+= spi-coldfire-qspi.o
+obj-$(CONFIG_SPI_DAVINCI)		+= spi-davinci.o
+obj-$(CONFIG_SPI_DESIGNWARE)		+= spi-dw.o
+obj-$(CONFIG_SPI_DW_MMIO)		+= spi-dw-mmio.o
+obj-$(CONFIG_SPI_DW_PCI)		+= spi-dw-midpci.o
+spi_dw_midpci-objs			:= spi-dw-pci.o spi-dw-mid.o
+obj-$(CONFIG_SPI_EP93XX)		+= spi-ep93xx.o
+obj-$(CONFIG_SPI_FSL_LIB)		+= spi-fsl-lib.o
+obj-$(CONFIG_SPI_FSL_ESPI)		+= spi-fsl-espi.o
+obj-$(CONFIG_SPI_FSL_SPI)		+= spi-fsl-spi.o
+obj-$(CONFIG_SPI_GPIO)			+= spi-gpio.o
+obj-$(CONFIG_SPI_IMX)			+= spi-imx.o
+obj-$(CONFIG_SPI_LM70_LLP)		+= spi-lm70llp.o
+obj-$(CONFIG_SPI_MPC512x_PSC)		+= spi-mpc512x-psc.o
+obj-$(CONFIG_SPI_MPC52xx_PSC)		+= spi-mpc52xx-psc.o
+obj-$(CONFIG_SPI_MPC52xx)		+= spi-mpc52xx.o
+obj-$(CONFIG_SPI_NUC900)		+= spi-nuc900.o
+obj-$(CONFIG_SPI_OC_TINY)		+= spi-oc-tiny.o
+obj-$(CONFIG_SPI_OMAP_UWIRE)		+= spi-omap-uwire.o
+obj-$(CONFIG_SPI_OMAP_100K)		+= spi-omap-100k.o
+obj-$(CONFIG_SPI_OMAP24XX)		+= spi-omap2-mcspi.o
+obj-$(CONFIG_SPI_ORION)			+= spi-orion.o
+obj-$(CONFIG_SPI_PL022)			+= spi-pl022.o
+obj-$(CONFIG_SPI_PPC4xx)		+= spi-ppc4xx.o
+obj-$(CONFIG_SPI_PXA2XX)		+= spi-pxa2xx.o
+obj-$(CONFIG_SPI_PXA2XX_PCI)		+= spi-pxa2xx-pci.o
+obj-$(CONFIG_SPI_S3C24XX_GPIO)		+= spi-s3c24xx-gpio.o
+obj-$(CONFIG_SPI_S3C24XX)		+= spi-s3c24xx-hw.o
+spi-s3c24xx-hw-y			:= spi-s3c24xx.o
+spi-s3c24xx-hw-$(CONFIG_SPI_S3C24XX_FIQ) += spi-s3c24xx-fiq.o
+obj-$(CONFIG_SPI_S3C64XX)		+= spi-s3c64xx.o
+obj-$(CONFIG_SPI_SH)			+= spi-sh.o
+obj-$(CONFIG_SPI_SH_MSIOF)		+= spi-sh-msiof.o
+obj-$(CONFIG_SPI_SH_SCI)		+= spi-sh-sci.o
+obj-$(CONFIG_SPI_STMP3XXX)		+= spi-stmp.o
+obj-$(CONFIG_SPI_TEGRA)			+= spi-tegra.o
+obj-$(CONFIG_SPI_TI_SSP)		+= spi-ti-ssp.o
+obj-$(CONFIG_SPI_TLE62X0)		+= spi-tle62x0.o
+obj-$(CONFIG_SPI_TOPCLIFF_PCH)		+= spi-topcliff-pch.o
+obj-$(CONFIG_SPI_TXX9)			+= spi-txx9.o
+obj-$(CONFIG_SPI_XILINX)		+= spi-xilinx.o
 
-# special build for s3c24xx spi driver with fiq support
-spi_s3c24xx_hw-y			:= spi_s3c24xx.o
-spi_s3c24xx_hw-$(CONFIG_SPI_S3C24XX_FIQ) += spi_s3c24xx_fiq.o
-
-# 	... add above this line ...
-
-# SPI protocol drivers (device/link on bus)
-obj-$(CONFIG_SPI_SPIDEV)	+= spidev.o
-obj-$(CONFIG_SPI_TLE62X0)	+= tle62x0.o
-# 	... add above this line ...
-
-# SPI slave controller drivers (upstream link)
-# 	... add above this line ...
-
-# SPI slave drivers (protocol for that link)
-# 	... add above this line ...
diff --git a/drivers/spi/atmel_spi.h b/drivers/spi/atmel_spi.h
deleted file mode 100644
index 6e06b6a..0000000
--- a/drivers/spi/atmel_spi.h
+++ /dev/null
@@ -1,167 +0,0 @@
-/*
- * Register definitions for Atmel Serial Peripheral Interface (SPI)
- *
- * Copyright (C) 2006 Atmel Corporation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#ifndef __ATMEL_SPI_H__
-#define __ATMEL_SPI_H__
-
-/* SPI register offsets */
-#define SPI_CR					0x0000
-#define SPI_MR					0x0004
-#define SPI_RDR					0x0008
-#define SPI_TDR					0x000c
-#define SPI_SR					0x0010
-#define SPI_IER					0x0014
-#define SPI_IDR					0x0018
-#define SPI_IMR					0x001c
-#define SPI_CSR0				0x0030
-#define SPI_CSR1				0x0034
-#define SPI_CSR2				0x0038
-#define SPI_CSR3				0x003c
-#define SPI_RPR					0x0100
-#define SPI_RCR					0x0104
-#define SPI_TPR					0x0108
-#define SPI_TCR					0x010c
-#define SPI_RNPR				0x0110
-#define SPI_RNCR				0x0114
-#define SPI_TNPR				0x0118
-#define SPI_TNCR				0x011c
-#define SPI_PTCR				0x0120
-#define SPI_PTSR				0x0124
-
-/* Bitfields in CR */
-#define SPI_SPIEN_OFFSET			0
-#define SPI_SPIEN_SIZE				1
-#define SPI_SPIDIS_OFFSET			1
-#define SPI_SPIDIS_SIZE				1
-#define SPI_SWRST_OFFSET			7
-#define SPI_SWRST_SIZE				1
-#define SPI_LASTXFER_OFFSET			24
-#define SPI_LASTXFER_SIZE			1
-
-/* Bitfields in MR */
-#define SPI_MSTR_OFFSET				0
-#define SPI_MSTR_SIZE				1
-#define SPI_PS_OFFSET				1
-#define SPI_PS_SIZE				1
-#define SPI_PCSDEC_OFFSET			2
-#define SPI_PCSDEC_SIZE				1
-#define SPI_FDIV_OFFSET				3
-#define SPI_FDIV_SIZE				1
-#define SPI_MODFDIS_OFFSET			4
-#define SPI_MODFDIS_SIZE			1
-#define SPI_LLB_OFFSET				7
-#define SPI_LLB_SIZE				1
-#define SPI_PCS_OFFSET				16
-#define SPI_PCS_SIZE				4
-#define SPI_DLYBCS_OFFSET			24
-#define SPI_DLYBCS_SIZE				8
-
-/* Bitfields in RDR */
-#define SPI_RD_OFFSET				0
-#define SPI_RD_SIZE				16
-
-/* Bitfields in TDR */
-#define SPI_TD_OFFSET				0
-#define SPI_TD_SIZE				16
-
-/* Bitfields in SR */
-#define SPI_RDRF_OFFSET				0
-#define SPI_RDRF_SIZE				1
-#define SPI_TDRE_OFFSET				1
-#define SPI_TDRE_SIZE				1
-#define SPI_MODF_OFFSET				2
-#define SPI_MODF_SIZE				1
-#define SPI_OVRES_OFFSET			3
-#define SPI_OVRES_SIZE				1
-#define SPI_ENDRX_OFFSET			4
-#define SPI_ENDRX_SIZE				1
-#define SPI_ENDTX_OFFSET			5
-#define SPI_ENDTX_SIZE				1
-#define SPI_RXBUFF_OFFSET			6
-#define SPI_RXBUFF_SIZE				1
-#define SPI_TXBUFE_OFFSET			7
-#define SPI_TXBUFE_SIZE				1
-#define SPI_NSSR_OFFSET				8
-#define SPI_NSSR_SIZE				1
-#define SPI_TXEMPTY_OFFSET			9
-#define SPI_TXEMPTY_SIZE			1
-#define SPI_SPIENS_OFFSET			16
-#define SPI_SPIENS_SIZE				1
-
-/* Bitfields in CSR0 */
-#define SPI_CPOL_OFFSET				0
-#define SPI_CPOL_SIZE				1
-#define SPI_NCPHA_OFFSET			1
-#define SPI_NCPHA_SIZE				1
-#define SPI_CSAAT_OFFSET			3
-#define SPI_CSAAT_SIZE				1
-#define SPI_BITS_OFFSET				4
-#define SPI_BITS_SIZE				4
-#define SPI_SCBR_OFFSET				8
-#define SPI_SCBR_SIZE				8
-#define SPI_DLYBS_OFFSET			16
-#define SPI_DLYBS_SIZE				8
-#define SPI_DLYBCT_OFFSET			24
-#define SPI_DLYBCT_SIZE				8
-
-/* Bitfields in RCR */
-#define SPI_RXCTR_OFFSET			0
-#define SPI_RXCTR_SIZE				16
-
-/* Bitfields in TCR */
-#define SPI_TXCTR_OFFSET			0
-#define SPI_TXCTR_SIZE				16
-
-/* Bitfields in RNCR */
-#define SPI_RXNCR_OFFSET			0
-#define SPI_RXNCR_SIZE				16
-
-/* Bitfields in TNCR */
-#define SPI_TXNCR_OFFSET			0
-#define SPI_TXNCR_SIZE				16
-
-/* Bitfields in PTCR */
-#define SPI_RXTEN_OFFSET			0
-#define SPI_RXTEN_SIZE				1
-#define SPI_RXTDIS_OFFSET			1
-#define SPI_RXTDIS_SIZE				1
-#define SPI_TXTEN_OFFSET			8
-#define SPI_TXTEN_SIZE				1
-#define SPI_TXTDIS_OFFSET			9
-#define SPI_TXTDIS_SIZE				1
-
-/* Constants for BITS */
-#define SPI_BITS_8_BPT				0
-#define SPI_BITS_9_BPT				1
-#define SPI_BITS_10_BPT				2
-#define SPI_BITS_11_BPT				3
-#define SPI_BITS_12_BPT				4
-#define SPI_BITS_13_BPT				5
-#define SPI_BITS_14_BPT				6
-#define SPI_BITS_15_BPT				7
-#define SPI_BITS_16_BPT				8
-
-/* Bit manipulation macros */
-#define SPI_BIT(name) \
-	(1 << SPI_##name##_OFFSET)
-#define SPI_BF(name,value) \
-	(((value) & ((1 << SPI_##name##_SIZE) - 1)) << SPI_##name##_OFFSET)
-#define SPI_BFEXT(name,value) \
-	(((value) >> SPI_##name##_OFFSET) & ((1 << SPI_##name##_SIZE) - 1))
-#define SPI_BFINS(name,value,old) \
-	( ((old) & ~(((1 << SPI_##name##_SIZE) - 1) << SPI_##name##_OFFSET)) \
-	  | SPI_BF(name,value))
-
-/* Register access macros */
-#define spi_readl(port,reg) \
-	__raw_readl((port)->regs + SPI_##reg)
-#define spi_writel(port,reg,value) \
-	__raw_writel((value), (port)->regs + SPI_##reg)
-
-#endif /* __ATMEL_SPI_H__ */
diff --git a/drivers/spi/spi_altera.c b/drivers/spi/spi-altera.c
similarity index 100%
rename from drivers/spi/spi_altera.c
rename to drivers/spi/spi-altera.c
diff --git a/drivers/spi/ath79_spi.c b/drivers/spi/spi-ath79.c
similarity index 100%
rename from drivers/spi/ath79_spi.c
rename to drivers/spi/spi-ath79.c
diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/spi-atmel.c
similarity index 85%
rename from drivers/spi/atmel_spi.c
rename to drivers/spi/spi-atmel.c
index 08711e9..82dee9a 100644
--- a/drivers/spi/atmel_spi.c
+++ b/drivers/spi/spi-atmel.c
@@ -25,7 +25,160 @@
 #include <mach/gpio.h>
 #include <mach/cpu.h>
 
-#include "atmel_spi.h"
+/* SPI register offsets */
+#define SPI_CR					0x0000
+#define SPI_MR					0x0004
+#define SPI_RDR					0x0008
+#define SPI_TDR					0x000c
+#define SPI_SR					0x0010
+#define SPI_IER					0x0014
+#define SPI_IDR					0x0018
+#define SPI_IMR					0x001c
+#define SPI_CSR0				0x0030
+#define SPI_CSR1				0x0034
+#define SPI_CSR2				0x0038
+#define SPI_CSR3				0x003c
+#define SPI_RPR					0x0100
+#define SPI_RCR					0x0104
+#define SPI_TPR					0x0108
+#define SPI_TCR					0x010c
+#define SPI_RNPR				0x0110
+#define SPI_RNCR				0x0114
+#define SPI_TNPR				0x0118
+#define SPI_TNCR				0x011c
+#define SPI_PTCR				0x0120
+#define SPI_PTSR				0x0124
+
+/* Bitfields in CR */
+#define SPI_SPIEN_OFFSET			0
+#define SPI_SPIEN_SIZE				1
+#define SPI_SPIDIS_OFFSET			1
+#define SPI_SPIDIS_SIZE				1
+#define SPI_SWRST_OFFSET			7
+#define SPI_SWRST_SIZE				1
+#define SPI_LASTXFER_OFFSET			24
+#define SPI_LASTXFER_SIZE			1
+
+/* Bitfields in MR */
+#define SPI_MSTR_OFFSET				0
+#define SPI_MSTR_SIZE				1
+#define SPI_PS_OFFSET				1
+#define SPI_PS_SIZE				1
+#define SPI_PCSDEC_OFFSET			2
+#define SPI_PCSDEC_SIZE				1
+#define SPI_FDIV_OFFSET				3
+#define SPI_FDIV_SIZE				1
+#define SPI_MODFDIS_OFFSET			4
+#define SPI_MODFDIS_SIZE			1
+#define SPI_LLB_OFFSET				7
+#define SPI_LLB_SIZE				1
+#define SPI_PCS_OFFSET				16
+#define SPI_PCS_SIZE				4
+#define SPI_DLYBCS_OFFSET			24
+#define SPI_DLYBCS_SIZE				8
+
+/* Bitfields in RDR */
+#define SPI_RD_OFFSET				0
+#define SPI_RD_SIZE				16
+
+/* Bitfields in TDR */
+#define SPI_TD_OFFSET				0
+#define SPI_TD_SIZE				16
+
+/* Bitfields in SR */
+#define SPI_RDRF_OFFSET				0
+#define SPI_RDRF_SIZE				1
+#define SPI_TDRE_OFFSET				1
+#define SPI_TDRE_SIZE				1
+#define SPI_MODF_OFFSET				2
+#define SPI_MODF_SIZE				1
+#define SPI_OVRES_OFFSET			3
+#define SPI_OVRES_SIZE				1
+#define SPI_ENDRX_OFFSET			4
+#define SPI_ENDRX_SIZE				1
+#define SPI_ENDTX_OFFSET			5
+#define SPI_ENDTX_SIZE				1
+#define SPI_RXBUFF_OFFSET			6
+#define SPI_RXBUFF_SIZE				1
+#define SPI_TXBUFE_OFFSET			7
+#define SPI_TXBUFE_SIZE				1
+#define SPI_NSSR_OFFSET				8
+#define SPI_NSSR_SIZE				1
+#define SPI_TXEMPTY_OFFSET			9
+#define SPI_TXEMPTY_SIZE			1
+#define SPI_SPIENS_OFFSET			16
+#define SPI_SPIENS_SIZE				1
+
+/* Bitfields in CSR0 */
+#define SPI_CPOL_OFFSET				0
+#define SPI_CPOL_SIZE				1
+#define SPI_NCPHA_OFFSET			1
+#define SPI_NCPHA_SIZE				1
+#define SPI_CSAAT_OFFSET			3
+#define SPI_CSAAT_SIZE				1
+#define SPI_BITS_OFFSET				4
+#define SPI_BITS_SIZE				4
+#define SPI_SCBR_OFFSET				8
+#define SPI_SCBR_SIZE				8
+#define SPI_DLYBS_OFFSET			16
+#define SPI_DLYBS_SIZE				8
+#define SPI_DLYBCT_OFFSET			24
+#define SPI_DLYBCT_SIZE				8
+
+/* Bitfields in RCR */
+#define SPI_RXCTR_OFFSET			0
+#define SPI_RXCTR_SIZE				16
+
+/* Bitfields in TCR */
+#define SPI_TXCTR_OFFSET			0
+#define SPI_TXCTR_SIZE				16
+
+/* Bitfields in RNCR */
+#define SPI_RXNCR_OFFSET			0
+#define SPI_RXNCR_SIZE				16
+
+/* Bitfields in TNCR */
+#define SPI_TXNCR_OFFSET			0
+#define SPI_TXNCR_SIZE				16
+
+/* Bitfields in PTCR */
+#define SPI_RXTEN_OFFSET			0
+#define SPI_RXTEN_SIZE				1
+#define SPI_RXTDIS_OFFSET			1
+#define SPI_RXTDIS_SIZE				1
+#define SPI_TXTEN_OFFSET			8
+#define SPI_TXTEN_SIZE				1
+#define SPI_TXTDIS_OFFSET			9
+#define SPI_TXTDIS_SIZE				1
+
+/* Constants for BITS */
+#define SPI_BITS_8_BPT				0
+#define SPI_BITS_9_BPT				1
+#define SPI_BITS_10_BPT				2
+#define SPI_BITS_11_BPT				3
+#define SPI_BITS_12_BPT				4
+#define SPI_BITS_13_BPT				5
+#define SPI_BITS_14_BPT				6
+#define SPI_BITS_15_BPT				7
+#define SPI_BITS_16_BPT				8
+
+/* Bit manipulation macros */
+#define SPI_BIT(name) \
+	(1 << SPI_##name##_OFFSET)
+#define SPI_BF(name,value) \
+	(((value) & ((1 << SPI_##name##_SIZE) - 1)) << SPI_##name##_OFFSET)
+#define SPI_BFEXT(name,value) \
+	(((value) >> SPI_##name##_OFFSET) & ((1 << SPI_##name##_SIZE) - 1))
+#define SPI_BFINS(name,value,old) \
+	( ((old) & ~(((1 << SPI_##name##_SIZE) - 1) << SPI_##name##_OFFSET)) \
+	  | SPI_BF(name,value))
+
+/* Register access macros */
+#define spi_readl(port,reg) \
+	__raw_readl((port)->regs + SPI_##reg)
+#define spi_writel(port,reg,value) \
+	__raw_writel((value), (port)->regs + SPI_##reg)
+
 
 /*
  * The core SPI transfer engine just talks to a register bank to set up
diff --git a/drivers/spi/au1550_spi.c b/drivers/spi/spi-au1550.c
similarity index 99%
rename from drivers/spi/au1550_spi.c
rename to drivers/spi/spi-au1550.c
index b50563d..bddee5f 100644
--- a/drivers/spi/au1550_spi.c
+++ b/drivers/spi/spi-au1550.c
@@ -1,5 +1,5 @@
 /*
- * au1550_spi.c - au1550 psc spi controller driver
+ * au1550 psc spi controller driver
  * may work also with au1200, au1210, au1250
  * will not work on au1000, au1100 and au1500 (no full spi controller there)
  *
diff --git a/drivers/spi/spi_bfin_sport.c b/drivers/spi/spi-bfin-sport.c
similarity index 100%
rename from drivers/spi/spi_bfin_sport.c
rename to drivers/spi/spi-bfin-sport.c
diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi-bfin5xx.c
similarity index 100%
rename from drivers/spi/spi_bfin5xx.c
rename to drivers/spi/spi-bfin5xx.c
diff --git a/drivers/spi/spi_bitbang_txrx.h b/drivers/spi/spi-bitbang-txrx.h
similarity index 100%
rename from drivers/spi/spi_bitbang_txrx.h
rename to drivers/spi/spi-bitbang-txrx.h
diff --git a/drivers/spi/spi_bitbang.c b/drivers/spi/spi-bitbang.c
similarity index 99%
rename from drivers/spi/spi_bitbang.c
rename to drivers/spi/spi-bitbang.c
index bb38c83..02d57fb 100644
--- a/drivers/spi/spi_bitbang.c
+++ b/drivers/spi/spi-bitbang.c
@@ -1,5 +1,5 @@
 /*
- * spi_bitbang.c - polling/bitbanging SPI master controller driver utilities
+ * polling/bitbanging SPI master controller driver utilities
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/spi/spi_butterfly.c b/drivers/spi/spi-butterfly.c
similarity index 99%
rename from drivers/spi/spi_butterfly.c
rename to drivers/spi/spi-butterfly.c
index 0d4ceba..9f907ec 100644
--- a/drivers/spi/spi_butterfly.c
+++ b/drivers/spi/spi-butterfly.c
@@ -1,5 +1,5 @@
 /*
- * spi_butterfly.c - parport-to-butterfly adapter
+ * parport-to-butterfly adapter
  *
  * Copyright (C) 2005 David Brownell
  *
@@ -149,7 +149,7 @@ static void butterfly_chipselect(struct spi_device *spi, int value)
 #define	spidelay(X)	do{}while(0)
 //#define	spidelay	ndelay
 
-#include "spi_bitbang_txrx.h"
+#include "spi-bitbang-txrx.h"
 
 static u32
 butterfly_txrx_word_mode0(struct spi_device *spi,
diff --git a/drivers/spi/coldfire_qspi.c b/drivers/spi/spi-coldfire-qspi.c
similarity index 100%
rename from drivers/spi/coldfire_qspi.c
rename to drivers/spi/spi-coldfire-qspi.c
diff --git a/drivers/spi/davinci_spi.c b/drivers/spi/spi-davinci.c
similarity index 100%
rename from drivers/spi/davinci_spi.c
rename to drivers/spi/spi-davinci.c
diff --git a/drivers/spi/dw_spi_mid.c b/drivers/spi/spi-dw-mid.c
similarity index 98%
rename from drivers/spi/dw_spi_mid.c
rename to drivers/spi/spi-dw-mid.c
index 4891782..130e555 100644
--- a/drivers/spi/dw_spi_mid.c
+++ b/drivers/spi/spi-dw-mid.c
@@ -1,5 +1,5 @@
 /*
- * dw_spi_mid.c - special handling for DW core on Intel MID platform
+ * Special handling for DW core on Intel MID platform
  *
  * Copyright (c) 2009, Intel Corporation.
  *
@@ -23,7 +23,7 @@
 #include <linux/slab.h>
 #include <linux/spi/spi.h>
 
-#include "dw_spi.h"
+#include "spi-dw.h"
 
 #ifdef CONFIG_SPI_DW_MID_DMA
 #include <linux/intel_mid_dma.h>
diff --git a/drivers/spi/dw_spi_mmio.c b/drivers/spi/spi-dw-mmio.c
similarity index 97%
rename from drivers/spi/dw_spi_mmio.c
rename to drivers/spi/spi-dw-mmio.c
index e0e813d..34eb665 100644
--- a/drivers/spi/dw_spi_mmio.c
+++ b/drivers/spi/spi-dw-mmio.c
@@ -1,5 +1,5 @@
 /*
- * dw_spi_mmio.c - Memory-mapped interface driver for DW SPI Core
+ * Memory-mapped interface driver for DW SPI Core
  *
  * Copyright (c) 2010, Octasic semiconductor.
  *
@@ -16,7 +16,7 @@
 #include <linux/spi/spi.h>
 #include <linux/scatterlist.h>
 
-#include "dw_spi.h"
+#include "spi-dw.h"
 
 #define DRIVER_NAME "dw_spi_mmio"
 
diff --git a/drivers/spi/dw_spi_pci.c b/drivers/spi/spi-dw-pci.c
similarity index 98%
rename from drivers/spi/dw_spi_pci.c
rename to drivers/spi/spi-dw-pci.c
index ad260aa..c5f37f0 100644
--- a/drivers/spi/dw_spi_pci.c
+++ b/drivers/spi/spi-dw-pci.c
@@ -1,5 +1,5 @@
 /*
- * dw_spi_pci.c - PCI interface driver for DW SPI Core
+ * PCI interface driver for DW SPI Core
  *
  * Copyright (c) 2009, Intel Corporation.
  *
@@ -22,7 +22,7 @@
 #include <linux/slab.h>
 #include <linux/spi/spi.h>
 
-#include "dw_spi.h"
+#include "spi-dw.h"
 
 #define DRIVER_NAME "dw_spi_pci"
 
diff --git a/drivers/spi/dw_spi.c b/drivers/spi/spi-dw.c
similarity index 99%
rename from drivers/spi/dw_spi.c
rename to drivers/spi/spi-dw.c
index 919fa9d..ece5f69 100644
--- a/drivers/spi/dw_spi.c
+++ b/drivers/spi/spi-dw.c
@@ -1,5 +1,5 @@
 /*
- * dw_spi.c - Designware SPI core controller driver (refer pxa2xx_spi.c)
+ * Designware SPI core controller driver (refer pxa2xx_spi.c)
  *
  * Copyright (c) 2009, Intel Corporation.
  *
@@ -24,7 +24,7 @@
 #include <linux/slab.h>
 #include <linux/spi/spi.h>
 
-#include "dw_spi.h"
+#include "spi-dw.h"
 
 #ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
diff --git a/drivers/spi/dw_spi.h b/drivers/spi/spi-dw.h
similarity index 100%
rename from drivers/spi/dw_spi.h
rename to drivers/spi/spi-dw.h
diff --git a/drivers/spi/ep93xx_spi.c b/drivers/spi/spi-ep93xx.c
similarity index 100%
rename from drivers/spi/ep93xx_spi.c
rename to drivers/spi/spi-ep93xx.c
diff --git a/drivers/spi/spi_fsl_espi.c b/drivers/spi/spi-fsl-espi.c
similarity index 99%
rename from drivers/spi/spi_fsl_espi.c
rename to drivers/spi/spi-fsl-espi.c
index 496f895..54e499d 100644
--- a/drivers/spi/spi_fsl_espi.c
+++ b/drivers/spi/spi-fsl-espi.c
@@ -22,7 +22,7 @@
 #include <linux/err.h>
 #include <sysdev/fsl_soc.h>
 
-#include "spi_fsl_lib.h"
+#include "spi-fsl-lib.h"
 
 /* eSPI Controller registers */
 struct fsl_espi_reg {
diff --git a/drivers/spi/spi_fsl_lib.c b/drivers/spi/spi-fsl-lib.c
similarity index 99%
rename from drivers/spi/spi_fsl_lib.c
rename to drivers/spi/spi-fsl-lib.c
index ff59f42..2674fad 100644
--- a/drivers/spi/spi_fsl_lib.c
+++ b/drivers/spi/spi-fsl-lib.c
@@ -25,7 +25,7 @@
 #include <linux/of_spi.h>
 #include <sysdev/fsl_soc.h>
 
-#include "spi_fsl_lib.h"
+#include "spi-fsl-lib.h"
 
 #define MPC8XXX_SPI_RX_BUF(type) 					  \
 void mpc8xxx_spi_rx_buf_##type(u32 data, struct mpc8xxx_spi *mpc8xxx_spi) \
diff --git a/drivers/spi/spi_fsl_lib.h b/drivers/spi/spi-fsl-lib.h
similarity index 100%
rename from drivers/spi/spi_fsl_lib.h
rename to drivers/spi/spi-fsl-lib.h
diff --git a/drivers/spi/spi_fsl_spi.c b/drivers/spi/spi-fsl-spi.c
similarity index 99%
rename from drivers/spi/spi_fsl_spi.c
rename to drivers/spi/spi-fsl-spi.c
index 7963c9b..e013117 100644
--- a/drivers/spi/spi_fsl_spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -37,7 +37,7 @@
 #include <asm/cpm.h>
 #include <asm/qe.h>
 
-#include "spi_fsl_lib.h"
+#include "spi-fsl-lib.h"
 
 /* CPM1 and CPM2 are mutually exclusive. */
 #ifdef CONFIG_CPM1
diff --git a/drivers/spi/spi_gpio.c b/drivers/spi/spi-gpio.c
similarity index 99%
rename from drivers/spi/spi_gpio.c
rename to drivers/spi/spi-gpio.c
index 63e51b0..0e88ab7 100644
--- a/drivers/spi/spi_gpio.c
+++ b/drivers/spi/spi-gpio.c
@@ -1,5 +1,5 @@
 /*
- * spi_gpio.c - SPI master driver using generic bitbanged GPIO
+ * SPI master driver using generic bitbanged GPIO
  *
  * Copyright (C) 2006,2008 David Brownell
  *
@@ -69,7 +69,7 @@ struct spi_gpio {
  *		#define	SPI_MOSI_GPIO	120
  *		#define	SPI_SCK_GPIO	121
  *		#define	SPI_N_CHIPSEL	4
- *		#include "spi_gpio.c"
+ *		#include "spi-gpio.c"
  */
 
 #ifndef DRIVER_NAME
@@ -127,7 +127,7 @@ static inline int getmiso(const struct spi_device *spi)
  */
 #define spidelay(nsecs)	do {} while (0)
 
-#include "spi_bitbang_txrx.h"
+#include "spi-bitbang-txrx.h"
 
 /*
  * These functions can leverage inline expansion of GPIO calls to shrink
diff --git a/drivers/spi/spi_imx.c b/drivers/spi/spi-imx.c
similarity index 100%
rename from drivers/spi/spi_imx.c
rename to drivers/spi/spi-imx.c
diff --git a/drivers/spi/spi_lm70llp.c b/drivers/spi/spi-lm70llp.c
similarity index 98%
rename from drivers/spi/spi_lm70llp.c
rename to drivers/spi/spi-lm70llp.c
index 7746a41..933eb9d 100644
--- a/drivers/spi/spi_lm70llp.c
+++ b/drivers/spi/spi-lm70llp.c
@@ -1,5 +1,5 @@
 /*
- * spi_lm70llp.c - driver for LM70EVAL-LLP board for the LM70 sensor
+ * Driver for LM70EVAL-LLP board for the LM70 sensor
  *
  * Copyright (C) 2006 Kaiwan N Billimoria <kaiwan@designergraphix.com>
  *
@@ -174,7 +174,7 @@ static inline int getmiso(struct spi_device *s)
 }
 /*--------------------------------------------------------------------*/
 
-#include "spi_bitbang_txrx.h"
+#include "spi-bitbang-txrx.h"
 
 static void lm70_chipselect(struct spi_device *spi, int value)
 {
diff --git a/drivers/spi/mpc512x_psc_spi.c b/drivers/spi/spi-mpc512x-psc.c
similarity index 100%
rename from drivers/spi/mpc512x_psc_spi.c
rename to drivers/spi/spi-mpc512x-psc.c
diff --git a/drivers/spi/mpc52xx_psc_spi.c b/drivers/spi/spi-mpc52xx-psc.c
similarity index 100%
rename from drivers/spi/mpc52xx_psc_spi.c
rename to drivers/spi/spi-mpc52xx-psc.c
diff --git a/drivers/spi/mpc52xx_spi.c b/drivers/spi/spi-mpc52xx.c
similarity index 100%
rename from drivers/spi/mpc52xx_spi.c
rename to drivers/spi/spi-mpc52xx.c
diff --git a/drivers/spi/spi_nuc900.c b/drivers/spi/spi-nuc900.c
similarity index 99%
rename from drivers/spi/spi_nuc900.c
rename to drivers/spi/spi-nuc900.c
index 3cd15f6..c0a6ce8 100644
--- a/drivers/spi/spi_nuc900.c
+++ b/drivers/spi/spi-nuc900.c
@@ -1,5 +1,4 @@
-/* linux/drivers/spi/spi_nuc900.c
- *
+/*
  * Copyright (c) 2009 Nuvoton technology.
  * Wan ZongShun <mcuos.com@gmail.com>
  *
@@ -7,7 +6,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
-*/
+ */
 
 #include <linux/init.h>
 #include <linux/spinlock.h>
diff --git a/drivers/spi/spi_oc_tiny.c b/drivers/spi/spi-oc-tiny.c
similarity index 100%
rename from drivers/spi/spi_oc_tiny.c
rename to drivers/spi/spi-oc-tiny.c
diff --git a/drivers/spi/omap_spi_100k.c b/drivers/spi/spi-omap-100k.c
similarity index 100%
rename from drivers/spi/omap_spi_100k.c
rename to drivers/spi/spi-omap-100k.c
diff --git a/drivers/spi/omap_uwire.c b/drivers/spi/spi-omap-uwire.c
similarity index 99%
rename from drivers/spi/omap_uwire.c
rename to drivers/spi/spi-omap-uwire.c
index 160d326..00a8e9d 100644
--- a/drivers/spi/omap_uwire.c
+++ b/drivers/spi/spi-omap-uwire.c
@@ -1,5 +1,5 @@
 /*
- * omap_uwire.c -- MicroWire interface driver for OMAP
+ * MicroWire interface driver for OMAP
  *
  * Copyright 2003 MontaVista Software Inc. <source@mvista.com>
  *
diff --git a/drivers/spi/omap2_mcspi.c b/drivers/spi/spi-omap2-mcspi.c
similarity index 100%
rename from drivers/spi/omap2_mcspi.c
rename to drivers/spi/spi-omap2-mcspi.c
diff --git a/drivers/spi/orion_spi.c b/drivers/spi/spi-orion.c
similarity index 99%
rename from drivers/spi/orion_spi.c
rename to drivers/spi/spi-orion.c
index 0b677dc..d482628 100644
--- a/drivers/spi/orion_spi.c
+++ b/drivers/spi/spi-orion.c
@@ -1,5 +1,5 @@
 /*
- * orion_spi.c -- Marvell Orion SPI controller driver
+ * Marvell Orion SPI controller driver
  *
  * Author: Shadi Ammouri <shadi@marvell.com>
  * Copyright (C) 2007-2008 Marvell Ltd.
diff --git a/drivers/spi/amba-pl022.c b/drivers/spi/spi-pl022.c
similarity index 99%
rename from drivers/spi/amba-pl022.c
rename to drivers/spi/spi-pl022.c
index 6a9e58d..2541705 100644
--- a/drivers/spi/amba-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -1,6 +1,4 @@
 /*
- * drivers/spi/amba-pl022.c
- *
  * A driver for the ARM PL022 PrimeCell SSP/SPI bus master.
  *
  * Copyright (C) 2008-2009 ST-Ericsson AB
diff --git a/drivers/spi/spi_ppc4xx.c b/drivers/spi/spi-ppc4xx.c
similarity index 100%
rename from drivers/spi/spi_ppc4xx.c
rename to drivers/spi/spi-ppc4xx.c
diff --git a/drivers/spi/pxa2xx_spi_pci.c b/drivers/spi/spi-pxa2xx-pci.c
similarity index 100%
rename from drivers/spi/pxa2xx_spi_pci.c
rename to drivers/spi/spi-pxa2xx-pci.c
diff --git a/drivers/spi/pxa2xx_spi.c b/drivers/spi/spi-pxa2xx.c
similarity index 100%
rename from drivers/spi/pxa2xx_spi.c
rename to drivers/spi/spi-pxa2xx.c
diff --git a/drivers/spi/spi_s3c24xx_fiq.S b/drivers/spi/spi-s3c24xx-fiq.S
similarity index 99%
rename from drivers/spi/spi_s3c24xx_fiq.S
rename to drivers/spi/spi-s3c24xx-fiq.S
index 3793cae..059f2dc 100644
--- a/drivers/spi/spi_s3c24xx_fiq.S
+++ b/drivers/spi/spi-s3c24xx-fiq.S
@@ -17,7 +17,7 @@
 #include <mach/regs-irq.h>
 #include <plat/regs-spi.h>
 
-#include "spi_s3c24xx_fiq.h"
+#include "spi-s3c24xx-fiq.h"
 
 	.text
 
diff --git a/drivers/spi/spi_s3c24xx_fiq.h b/drivers/spi/spi-s3c24xx-fiq.h
similarity index 100%
rename from drivers/spi/spi_s3c24xx_fiq.h
rename to drivers/spi/spi-s3c24xx-fiq.h
diff --git a/drivers/spi/spi_s3c24xx_gpio.c b/drivers/spi/spi-s3c24xx-gpio.c
similarity index 98%
rename from drivers/spi/spi_s3c24xx_gpio.c
rename to drivers/spi/spi-s3c24xx-gpio.c
index be99135..2d3c085 100644
--- a/drivers/spi/spi_s3c24xx_gpio.c
+++ b/drivers/spi/spi-s3c24xx-gpio.c
@@ -1,5 +1,4 @@
-/* linux/drivers/spi/spi_s3c24xx_gpio.c
- *
+/*
  * Copyright (c) 2006 Ben Dooks
  * Copyright (c) 2006 Simtec Electronics
  *
@@ -58,7 +57,7 @@ static inline u32 getmiso(struct spi_device *dev)
 
 #define spidelay(x) ndelay(x)
 
-#include "spi_bitbang_txrx.h"
+#include "spi-bitbang-txrx.h"
 
 
 static u32 s3c2410_spigpio_txrx_mode0(struct spi_device *spi,
diff --git a/drivers/spi/spi_s3c24xx.c b/drivers/spi/spi-s3c24xx.c
similarity index 99%
rename from drivers/spi/spi_s3c24xx.c
rename to drivers/spi/spi-s3c24xx.c
index 1a5fcab..1996ac5 100644
--- a/drivers/spi/spi_s3c24xx.c
+++ b/drivers/spi/spi-s3c24xx.c
@@ -1,5 +1,4 @@
-/* linux/drivers/spi/spi_s3c24xx.c
- *
+/*
  * Copyright (c) 2006 Ben Dooks
  * Copyright 2006-2009 Simtec Electronics
  *	Ben Dooks <ben@simtec.co.uk>
@@ -32,7 +31,7 @@
 #include <plat/fiq.h>
 #include <asm/fiq.h>
 
-#include "spi_s3c24xx_fiq.h"
+#include "spi-s3c24xx-fiq.h"
 
 /**
  * s3c24xx_spi_devstate - per device data
diff --git a/drivers/spi/spi_s3c64xx.c b/drivers/spi/spi-s3c64xx.c
similarity index 99%
rename from drivers/spi/spi_s3c64xx.c
rename to drivers/spi/spi-s3c64xx.c
index 795828b9..75e3a9b 100644
--- a/drivers/spi/spi_s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -1,5 +1,4 @@
-/* linux/drivers/spi/spi_s3c64xx.c
- *
+/*
  * Copyright (C) 2009 Samsung Electronics Ltd.
  *	Jaswinder Singh <jassi.brar@samsung.com>
  *
diff --git a/drivers/spi/spi_sh_msiof.c b/drivers/spi/spi-sh-msiof.c
similarity index 100%
rename from drivers/spi/spi_sh_msiof.c
rename to drivers/spi/spi-sh-msiof.c
diff --git a/drivers/spi/spi_sh_sci.c b/drivers/spi/spi-sh-sci.c
similarity index 99%
rename from drivers/spi/spi_sh_sci.c
rename to drivers/spi/spi-sh-sci.c
index 5c64391..e7779c0 100644
--- a/drivers/spi/spi_sh_sci.c
+++ b/drivers/spi/spi-sh-sci.c
@@ -78,7 +78,7 @@ static inline u32 getmiso(struct spi_device *dev)
 
 #define spidelay(x) ndelay(x)
 
-#include "spi_bitbang_txrx.h"
+#include "spi-bitbang-txrx.h"
 
 static u32 sh_sci_spi_txrx_mode0(struct spi_device *spi,
 				      unsigned nsecs, u32 word, u8 bits)
diff --git a/drivers/spi/spi_sh.c b/drivers/spi/spi-sh.c
similarity index 100%
rename from drivers/spi/spi_sh.c
rename to drivers/spi/spi-sh.c
diff --git a/drivers/spi/spi_stmp.c b/drivers/spi/spi-stmp.c
similarity index 100%
rename from drivers/spi/spi_stmp.c
rename to drivers/spi/spi-stmp.c
diff --git a/drivers/spi/spi_tegra.c b/drivers/spi/spi-tegra.c
similarity index 100%
rename from drivers/spi/spi_tegra.c
rename to drivers/spi/spi-tegra.c
diff --git a/drivers/spi/ti-ssp-spi.c b/drivers/spi/spi-ti-ssp.c
similarity index 100%
rename from drivers/spi/ti-ssp-spi.c
rename to drivers/spi/spi-ti-ssp.c
diff --git a/drivers/spi/tle62x0.c b/drivers/spi/spi-tle62x0.c
similarity index 99%
rename from drivers/spi/tle62x0.c
rename to drivers/spi/spi-tle62x0.c
index 32a4087..940e73d 100644
--- a/drivers/spi/tle62x0.c
+++ b/drivers/spi/spi-tle62x0.c
@@ -1,5 +1,5 @@
 /*
- * tle62x0.c -- support Infineon TLE62x0 driver chips
+ * Support Infineon TLE62x0 driver chips
  *
  * Copyright (c) 2007 Simtec Electronics
  *	Ben Dooks, <ben@simtec.co.uk>
diff --git a/drivers/spi/spi_topcliff_pch.c b/drivers/spi/spi-topcliff-pch.c
similarity index 100%
rename from drivers/spi/spi_topcliff_pch.c
rename to drivers/spi/spi-topcliff-pch.c
diff --git a/drivers/spi/spi_txx9.c b/drivers/spi/spi-txx9.c
similarity index 99%
rename from drivers/spi/spi_txx9.c
rename to drivers/spi/spi-txx9.c
index dfa024b..f0a2ab0 100644
--- a/drivers/spi/spi_txx9.c
+++ b/drivers/spi/spi-txx9.c
@@ -1,5 +1,5 @@
 /*
- * spi_txx9.c - TXx9 SPI controller driver.
+ * TXx9 SPI controller driver.
  *
  * Based on linux/arch/mips/tx4938/toshiba_rbtx4938/spi_txx9.c
  * Copyright (C) 2000-2001 Toshiba Corporation
diff --git a/drivers/spi/xilinx_spi.c b/drivers/spi/spi-xilinx.c
similarity index 100%
rename from drivers/spi/xilinx_spi.c
rename to drivers/spi/spi-xilinx.c
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 2e13a14..4d1b9f5 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1,5 +1,5 @@
 /*
- * spi.c - SPI init/core code
+ * SPI init/core code
  *
  * Copyright (C) 2005 David Brownell
  *
diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index d9fd862..830adbe 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -1,5 +1,5 @@
 /*
- * spidev.c -- simple synchronous userspace interface to SPI devices
+ * Simple synchronous userspace interface to SPI devices
  *
  * Copyright (C) 2006 SWAPP
  *	Andrea Paterniani <a.paterniani@swapp-eng.it>

