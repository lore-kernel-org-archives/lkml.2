Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab1FEHOC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 03:14:02 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:52016 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab1FEHOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 03:14:00 -0400
Subject: [PATCH] spi: reorganize drivers
To: spi-devel-generl@lists.sourceforge.net, linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 05 Jun 2011 01:13:58 -0600
Message-ID: <20110605071331.26277.15066.stgit@ponder>
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

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/spi/Makefile            |   80 ++++++++-----------
 drivers/spi/atmel_spi.h         |  167 ---------------------------------------
 drivers/spi/spi_ath79.c         |    0 
 drivers/spi/spi_atmel.c         |  155 ++++++++++++++++++++++++++++++++++++
 drivers/spi/spi_au1550.c        |    0 
 drivers/spi/spi_coldfire_qspi.c |    0 
 drivers/spi/spi_davinci.c       |    0 
 drivers/spi/spi_dw.c            |    2 
 drivers/spi/spi_dw.h            |    0 
 drivers/spi/spi_dw_mid.c        |    2 
 drivers/spi/spi_dw_mmio.c       |    2 
 drivers/spi/spi_dw_pci.c        |    2 
 drivers/spi/spi_ep93xx.c        |    0 
 drivers/spi/spi_mpc512x_psc.c   |    0 
 drivers/spi/spi_mpc52xx.c       |    0 
 drivers/spi/spi_mpc52xx_psc.c   |    0 
 drivers/spi/spi_omap2_mcspi.c   |    0 
 drivers/spi/spi_omap_100k.c     |    0 
 drivers/spi/spi_omap_uwire.c    |    0 
 drivers/spi/spi_orion.c         |    0 
 drivers/spi/spi_pl022.c         |    0 
 drivers/spi/spi_pxa2xx.c        |    0 
 drivers/spi/spi_pxa2xx_pci.c    |    0 
 drivers/spi/spi_ti_ssp.c        |    0 
 drivers/spi/spi_tle62x0.c       |    0 
 drivers/spi/spi_xilinx.c        |    0 
 26 files changed, 192 insertions(+), 218 deletions(-)
 delete mode 100644 drivers/spi/atmel_spi.h
 rename drivers/spi/{ath79_spi.c => spi_ath79.c} (100%)
 rename drivers/spi/{atmel_spi.c => spi_atmel.c} (85%)
 rename drivers/spi/{au1550_spi.c => spi_au1550.c} (100%)
 rename drivers/spi/{coldfire_qspi.c => spi_coldfire_qspi.c} (100%)
 rename drivers/spi/{davinci_spi.c => spi_davinci.c} (100%)
 rename drivers/spi/{dw_spi.c => spi_dw.c} (99%)
 rename drivers/spi/{dw_spi.h => spi_dw.h} (100%)
 rename drivers/spi/{dw_spi_mid.c => spi_dw_mid.c} (99%)
 rename drivers/spi/{dw_spi_mmio.c => spi_dw_mmio.c} (99%)
 rename drivers/spi/{dw_spi_pci.c => spi_dw_pci.c} (99%)
 rename drivers/spi/{ep93xx_spi.c => spi_ep93xx.c} (100%)
 rename drivers/spi/{mpc512x_psc_spi.c => spi_mpc512x_psc.c} (100%)
 rename drivers/spi/{mpc52xx_spi.c => spi_mpc52xx.c} (100%)
 rename drivers/spi/{mpc52xx_psc_spi.c => spi_mpc52xx_psc.c} (100%)
 rename drivers/spi/{omap2_mcspi.c => spi_omap2_mcspi.c} (100%)
 rename drivers/spi/{omap_spi_100k.c => spi_omap_100k.c} (100%)
 rename drivers/spi/{omap_uwire.c => spi_omap_uwire.c} (100%)
 rename drivers/spi/{orion_spi.c => spi_orion.c} (100%)
 rename drivers/spi/{amba-pl022.c => spi_pl022.c} (100%)
 rename drivers/spi/{pxa2xx_spi.c => spi_pxa2xx.c} (100%)
 rename drivers/spi/{pxa2xx_spi_pci.c => spi_pxa2xx_pci.c} (100%)
 rename drivers/spi/{ti-ssp-spi.c => spi_ti_ssp.c} (100%)
 rename drivers/spi/{tle62x0.c => spi_tle62x0.c} (100%)
 rename drivers/spi/{xilinx_spi.c => spi_xilinx.c} (100%)

diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
index 0f8c69b..39ab8e3 100644
--- a/drivers/spi/Makefile
+++ b/drivers/spi/Makefile
@@ -7,68 +7,56 @@ ccflags-$(CONFIG_SPI_DEBUG) := -DDEBUG
 # small core, mostly translating board-specific
 # config declarations into driver model code
 obj-$(CONFIG_SPI_MASTER)		+= spi.o
+obj-$(CONFIG_SPI_SPIDEV)		+= spidev.o
 
 # SPI master controller drivers (bus)
 obj-$(CONFIG_SPI_ALTERA)		+= spi_altera.o
-obj-$(CONFIG_SPI_ATMEL)			+= atmel_spi.o
-obj-$(CONFIG_SPI_ATH79)			+= ath79_spi.o
+obj-$(CONFIG_SPI_ATMEL)			+= spi_atmel.o
+obj-$(CONFIG_SPI_ATH79)			+= spi_ath79.o
+obj-$(CONFIG_SPI_AU1550)		+= spi_au1550.o
 obj-$(CONFIG_SPI_BFIN)			+= spi_bfin5xx.o
 obj-$(CONFIG_SPI_BFIN_SPORT)		+= spi_bfin_sport.o
 obj-$(CONFIG_SPI_BITBANG)		+= spi_bitbang.o
-obj-$(CONFIG_SPI_AU1550)		+= au1550_spi.o
 obj-$(CONFIG_SPI_BUTTERFLY)		+= spi_butterfly.o
-obj-$(CONFIG_SPI_COLDFIRE_QSPI)		+= coldfire_qspi.o
-obj-$(CONFIG_SPI_DAVINCI)		+= davinci_spi.o
-obj-$(CONFIG_SPI_DESIGNWARE)		+= dw_spi.o
-obj-$(CONFIG_SPI_DW_PCI)		+= dw_spi_midpci.o
-dw_spi_midpci-objs			:= dw_spi_pci.o dw_spi_mid.o
-obj-$(CONFIG_SPI_DW_MMIO)		+= dw_spi_mmio.o
-obj-$(CONFIG_SPI_EP93XX)		+= ep93xx_spi.o
+obj-$(CONFIG_SPI_COLDFIRE_QSPI)		+= spi_coldfire_qspi.o
+obj-$(CONFIG_SPI_DAVINCI)		+= spi_davinci.o
+obj-$(CONFIG_SPI_DESIGNWARE)		+= spi_dw.o
+obj-$(CONFIG_SPI_DW_MMIO)		+= spi_dw_mmio.o
+obj-$(CONFIG_SPI_DW_PCI)		+= spi_dw_midpci.o
+spi_dw_midpci-objs			:= spi_dw_pci.o spi_dw_mid.o
+obj-$(CONFIG_SPI_EP93XX)		+= spi_ep93xx.o
+obj-$(CONFIG_SPI_FSL_LIB)		+= spi_fsl_lib.o
+obj-$(CONFIG_SPI_FSL_ESPI)		+= spi_fsl_espi.o
+obj-$(CONFIG_SPI_FSL_SPI)		+= spi_fsl_spi.o
 obj-$(CONFIG_SPI_GPIO)			+= spi_gpio.o
 obj-$(CONFIG_SPI_IMX)			+= spi_imx.o
 obj-$(CONFIG_SPI_LM70_LLP)		+= spi_lm70llp.o
-obj-$(CONFIG_SPI_PXA2XX)		+= pxa2xx_spi.o
-obj-$(CONFIG_SPI_PXA2XX_PCI)		+= pxa2xx_spi_pci.o
+obj-$(CONFIG_SPI_MPC512x_PSC)		+= spi_mpc512x_psc.o
+obj-$(CONFIG_SPI_MPC52xx_PSC)		+= spi_mpc52xx_psc.o
+obj-$(CONFIG_SPI_MPC52xx)		+= spi_mpc52xx.o
+obj-$(CONFIG_SPI_NUC900)		+= spi_nuc900.o
 obj-$(CONFIG_SPI_OC_TINY)		+= spi_oc_tiny.o
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
+obj-$(CONFIG_SPI_OMAP_UWIRE)		+= spi_omap_uwire.o
+obj-$(CONFIG_SPI_OMAP_100K)		+= spi_omap_100k.o
+obj-$(CONFIG_SPI_OMAP24XX)		+= spi_omap2_mcspi.o
+obj-$(CONFIG_SPI_ORION)			+= spi_orion.o
+obj-$(CONFIG_SPI_PL022)			+= spi_pl022.o
 obj-$(CONFIG_SPI_PPC4xx)		+= spi_ppc4xx.o
+obj-$(CONFIG_SPI_PXA2XX)		+= spi_pxa2xx.o
+obj-$(CONFIG_SPI_PXA2XX_PCI)		+= spi_pxa2xx_pci.o
 obj-$(CONFIG_SPI_S3C24XX_GPIO)		+= spi_s3c24xx_gpio.o
 obj-$(CONFIG_SPI_S3C24XX)		+= spi_s3c24xx_hw.o
+spi_s3c24xx_hw-y			:= spi_s3c24xx.o
+spi_s3c24xx_hw-$(CONFIG_SPI_S3C24XX_FIQ) += spi_s3c24xx_fiq.o
 obj-$(CONFIG_SPI_S3C64XX)		+= spi_s3c64xx.o
-obj-$(CONFIG_SPI_TEGRA)			+= spi_tegra.o
-obj-$(CONFIG_SPI_TI_SSP)		+= ti-ssp-spi.o
-obj-$(CONFIG_SPI_TOPCLIFF_PCH)		+= spi_topcliff_pch.o
-obj-$(CONFIG_SPI_TXX9)			+= spi_txx9.o
-obj-$(CONFIG_SPI_XILINX)		+= xilinx_spi.o
 obj-$(CONFIG_SPI_SH)			+= spi_sh.o
-obj-$(CONFIG_SPI_SH_SCI)		+= spi_sh_sci.o
 obj-$(CONFIG_SPI_SH_MSIOF)		+= spi_sh_msiof.o
+obj-$(CONFIG_SPI_SH_SCI)		+= spi_sh_sci.o
 obj-$(CONFIG_SPI_STMP3XXX)		+= spi_stmp.o
-obj-$(CONFIG_SPI_NUC900)		+= spi_nuc900.o
-
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
+obj-$(CONFIG_SPI_TEGRA)			+= spi_tegra.o
+obj-$(CONFIG_SPI_TI_SSP)		+= spi_ti_ssp.o
+obj-$(CONFIG_SPI_TLE62X0)	+= spi_tle62x0.o
+obj-$(CONFIG_SPI_TOPCLIFF_PCH)		+= spi_topcliff_pch.o
+obj-$(CONFIG_SPI_TXX9)			+= spi_txx9.o
+obj-$(CONFIG_SPI_XILINX)		+= spi_xilinx.o
 
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
diff --git a/drivers/spi/ath79_spi.c b/drivers/spi/spi_ath79.c
similarity index 100%
rename from drivers/spi/ath79_spi.c
rename to drivers/spi/spi_ath79.c
diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/spi_atmel.c
similarity index 85%
rename from drivers/spi/atmel_spi.c
rename to drivers/spi/spi_atmel.c
index 08711e9..82dee9a 100644
--- a/drivers/spi/atmel_spi.c
+++ b/drivers/spi/spi_atmel.c
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
diff --git a/drivers/spi/au1550_spi.c b/drivers/spi/spi_au1550.c
similarity index 100%
rename from drivers/spi/au1550_spi.c
rename to drivers/spi/spi_au1550.c
diff --git a/drivers/spi/coldfire_qspi.c b/drivers/spi/spi_coldfire_qspi.c
similarity index 100%
rename from drivers/spi/coldfire_qspi.c
rename to drivers/spi/spi_coldfire_qspi.c
diff --git a/drivers/spi/davinci_spi.c b/drivers/spi/spi_davinci.c
similarity index 100%
rename from drivers/spi/davinci_spi.c
rename to drivers/spi/spi_davinci.c
diff --git a/drivers/spi/dw_spi.c b/drivers/spi/spi_dw.c
similarity index 99%
rename from drivers/spi/dw_spi.c
rename to drivers/spi/spi_dw.c
index 919fa9d..33b2b76 100644
--- a/drivers/spi/dw_spi.c
+++ b/drivers/spi/spi_dw.c
@@ -24,7 +24,7 @@
 #include <linux/slab.h>
 #include <linux/spi/spi.h>
 
-#include "dw_spi.h"
+#include "spi_dw.h"
 
 #ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
diff --git a/drivers/spi/dw_spi.h b/drivers/spi/spi_dw.h
similarity index 100%
rename from drivers/spi/dw_spi.h
rename to drivers/spi/spi_dw.h
diff --git a/drivers/spi/dw_spi_mid.c b/drivers/spi/spi_dw_mid.c
similarity index 99%
rename from drivers/spi/dw_spi_mid.c
rename to drivers/spi/spi_dw_mid.c
index 4891782..83311f8 100644
--- a/drivers/spi/dw_spi_mid.c
+++ b/drivers/spi/spi_dw_mid.c
@@ -23,7 +23,7 @@
 #include <linux/slab.h>
 #include <linux/spi/spi.h>
 
-#include "dw_spi.h"
+#include "spi_dw.h"
 
 #ifdef CONFIG_SPI_DW_MID_DMA
 #include <linux/intel_mid_dma.h>
diff --git a/drivers/spi/dw_spi_mmio.c b/drivers/spi/spi_dw_mmio.c
similarity index 99%
rename from drivers/spi/dw_spi_mmio.c
rename to drivers/spi/spi_dw_mmio.c
index e0e813d..9f0a2ce 100644
--- a/drivers/spi/dw_spi_mmio.c
+++ b/drivers/spi/spi_dw_mmio.c
@@ -16,7 +16,7 @@
 #include <linux/spi/spi.h>
 #include <linux/scatterlist.h>
 
-#include "dw_spi.h"
+#include "spi_dw.h"
 
 #define DRIVER_NAME "dw_spi_mmio"
 
diff --git a/drivers/spi/dw_spi_pci.c b/drivers/spi/spi_dw_pci.c
similarity index 99%
rename from drivers/spi/dw_spi_pci.c
rename to drivers/spi/spi_dw_pci.c
index ad260aa..4877d1a 100644
--- a/drivers/spi/dw_spi_pci.c
+++ b/drivers/spi/spi_dw_pci.c
@@ -22,7 +22,7 @@
 #include <linux/slab.h>
 #include <linux/spi/spi.h>
 
-#include "dw_spi.h"
+#include "spi_dw.h"
 
 #define DRIVER_NAME "dw_spi_pci"
 
diff --git a/drivers/spi/ep93xx_spi.c b/drivers/spi/spi_ep93xx.c
similarity index 100%
rename from drivers/spi/ep93xx_spi.c
rename to drivers/spi/spi_ep93xx.c
diff --git a/drivers/spi/mpc512x_psc_spi.c b/drivers/spi/spi_mpc512x_psc.c
similarity index 100%
rename from drivers/spi/mpc512x_psc_spi.c
rename to drivers/spi/spi_mpc512x_psc.c
diff --git a/drivers/spi/mpc52xx_spi.c b/drivers/spi/spi_mpc52xx.c
similarity index 100%
rename from drivers/spi/mpc52xx_spi.c
rename to drivers/spi/spi_mpc52xx.c
diff --git a/drivers/spi/mpc52xx_psc_spi.c b/drivers/spi/spi_mpc52xx_psc.c
similarity index 100%
rename from drivers/spi/mpc52xx_psc_spi.c
rename to drivers/spi/spi_mpc52xx_psc.c
diff --git a/drivers/spi/omap2_mcspi.c b/drivers/spi/spi_omap2_mcspi.c
similarity index 100%
rename from drivers/spi/omap2_mcspi.c
rename to drivers/spi/spi_omap2_mcspi.c
diff --git a/drivers/spi/omap_spi_100k.c b/drivers/spi/spi_omap_100k.c
similarity index 100%
rename from drivers/spi/omap_spi_100k.c
rename to drivers/spi/spi_omap_100k.c
diff --git a/drivers/spi/omap_uwire.c b/drivers/spi/spi_omap_uwire.c
similarity index 100%
rename from drivers/spi/omap_uwire.c
rename to drivers/spi/spi_omap_uwire.c
diff --git a/drivers/spi/orion_spi.c b/drivers/spi/spi_orion.c
similarity index 100%
rename from drivers/spi/orion_spi.c
rename to drivers/spi/spi_orion.c
diff --git a/drivers/spi/amba-pl022.c b/drivers/spi/spi_pl022.c
similarity index 100%
rename from drivers/spi/amba-pl022.c
rename to drivers/spi/spi_pl022.c
diff --git a/drivers/spi/pxa2xx_spi.c b/drivers/spi/spi_pxa2xx.c
similarity index 100%
rename from drivers/spi/pxa2xx_spi.c
rename to drivers/spi/spi_pxa2xx.c
diff --git a/drivers/spi/pxa2xx_spi_pci.c b/drivers/spi/spi_pxa2xx_pci.c
similarity index 100%
rename from drivers/spi/pxa2xx_spi_pci.c
rename to drivers/spi/spi_pxa2xx_pci.c
diff --git a/drivers/spi/ti-ssp-spi.c b/drivers/spi/spi_ti_ssp.c
similarity index 100%
rename from drivers/spi/ti-ssp-spi.c
rename to drivers/spi/spi_ti_ssp.c
diff --git a/drivers/spi/tle62x0.c b/drivers/spi/spi_tle62x0.c
similarity index 100%
rename from drivers/spi/tle62x0.c
rename to drivers/spi/spi_tle62x0.c
diff --git a/drivers/spi/xilinx_spi.c b/drivers/spi/spi_xilinx.c
similarity index 100%
rename from drivers/spi/xilinx_spi.c
rename to drivers/spi/spi_xilinx.c

