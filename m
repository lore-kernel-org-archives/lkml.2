Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab2DVPjp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 11:39:45 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16982 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab2DVPjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 11:39:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 22 Apr 2012 08:39:43 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
Cc: linux-kernel@vger.kernel.org, axel.lin@gmail.com,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V1] dma: arrange config names alphabetically in Kconfig and Makefile
Date: Sun, 22 Apr 2012 21:08:40 +0530
Message-Id: <1335109120-32009-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arranging the config names in alphabetical order.
In this way it is easy to find out proper placeholder to
add new driver.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
This patch just arrange the config variable name in alphabetical order
in Kconfig and Makefile.
When adding the TEGRA_DMA driver, it was not easy to findout the correct
location and did not want to put it on last.
This work is also inspired by the work done by Axel Lin in regulator
Kconfig/makefile.

 drivers/dma/Kconfig  |  266 +++++++++++++++++++++++++-------------------------
 drivers/dma/Makefile |   36 ++++----
 2 files changed, 151 insertions(+), 151 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index ef378b5..9b8b115 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -33,52 +33,54 @@ if DMADEVICES
 
 comment "DMA Devices"
 
-config INTEL_MID_DMAC
-	tristate "Intel MID DMA support for Peripheral DMA controllers"
-	depends on PCI && X86
+config AMBA_PL08X
+	bool "ARM PrimeCell PL080 or PL081 support"
+	depends on ARM_AMBA && EXPERIMENTAL
 	select DMA_ENGINE
-	default n
 	help
-	  Enable support for the Intel(R) MID DMA engine present
-	  in Intel MID chipsets.
+	  Platform has a PL08x DMAC device
+	  which can provide DMA engine support
 
-	  Say Y here if you have such a chipset.
+config AMCC_PPC440SPE_ADMA
+	tristate "AMCC PPC440SPe ADMA support"
+	depends on 440SPe || 440SP
+	select DMA_ENGINE
+	select ARCH_HAS_ASYNC_TX_FIND_CHANNEL
+	select ASYNC_TX_ENABLE_CHANNEL_SWITCH
+	help
+	  Enable support for the AMCC PPC440SPe RAID engines.
 
-	  If unsure, say N.
+config ARCH_HAS_ASYNC_TX_FIND_CHANNEL
+	bool
 
 config ASYNC_TX_ENABLE_CHANNEL_SWITCH
 	bool
 
-config AMBA_PL08X
-	bool "ARM PrimeCell PL080 or PL081 support"
-	depends on ARM_AMBA && EXPERIMENTAL
+config AT_HDMAC
+	tristate "Atmel AHB DMA support"
+	depends on ARCH_AT91
 	select DMA_ENGINE
 	help
-	  Platform has a PL08x DMAC device
-	  which can provide DMA engine support
+	  Support the Atmel AHB DMA controller.
 
-config INTEL_IOATDMA
-	tristate "Intel I/OAT DMA support"
-	depends on PCI && X86
+config COH901318
+	bool "ST-Ericsson COH901318 DMA support"
 	select DMA_ENGINE
-	select DCA
-	select ASYNC_TX_DISABLE_PQ_VAL_DMA
-	select ASYNC_TX_DISABLE_XOR_VAL_DMA
+	depends on ARCH_U300
 	help
-	  Enable support for the Intel(R) I/OAT DMA engine present
-	  in recent Intel Xeon chipsets.
-
-	  Say Y here if you have such a chipset.
+	  Enable support for ST-Ericsson COH 901 318 DMA.
 
-	  If unsure, say N.
+config DMA_ENGINE
+	bool
 
-config INTEL_IOP_ADMA
-	tristate "Intel IOP ADMA support"
-	depends on ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX
+config DMA_SA11X0
+	tristate "SA-11x0 DMA support"
+	depends on ARCH_SA1100
 	select DMA_ENGINE
-	select ASYNC_TX_ENABLE_CHANNEL_SWITCH
 	help
-	  Enable support for the Intel(R) IOP Series RAID engines.
+	  Support the DMA engine found on Intel StrongARM SA-1100 and
+	  SA-1110 SoCs.  This DMA engine can only be used with on-chip
+	  devices.
 
 config DW_DMAC
 	tristate "Synopsys DesignWare AHB DMA support"
@@ -89,12 +91,12 @@ config DW_DMAC
 	  Support the Synopsys DesignWare AHB DMA controller.  This
 	  can be integrated in chips such as the Atmel AT32ap7000.
 
-config AT_HDMAC
-	tristate "Atmel AHB DMA support"
-	depends on ARCH_AT91
+config EP93XX_DMA
+	bool "Cirrus Logic EP93xx DMA support"
+	depends on ARCH_EP93XX
 	select DMA_ENGINE
 	help
-	  Support the Atmel AHB DMA controller.
+	  Enable support for the Cirrus Logic EP93xx M2P/M2M DMA controller.
 
 config FSL_DMA
 	tristate "Freescale Elo and Elo Plus DMA support"
@@ -106,6 +108,58 @@ config FSL_DMA
 	  The Elo is the DMA controller on some 82xx and 83xx parts, and the
 	  Elo Plus is the DMA controller on 85xx and 86xx parts.
 
+config IMX_DMA
+	tristate "i.MX DMA support"
+	depends on ARCH_MXC
+	select DMA_ENGINE
+	help
+	  Support the i.MX DMA engine. This engine is integrated into
+	  Freescale i.MX1/21/27 chips.
+
+config IMX_SDMA
+	tristate "i.MX SDMA support"
+	depends on ARCH_MXC
+	select DMA_ENGINE
+	help
+	  Support the i.MX SDMA engine. This engine is integrated into
+	  Freescale i.MX25/31/35/51/53 chips.
+
+config INTEL_IOATDMA
+	tristate "Intel I/OAT DMA support"
+	depends on PCI && X86
+	select DMA_ENGINE
+	select DCA
+	select ASYNC_TX_DISABLE_PQ_VAL_DMA
+	select ASYNC_TX_DISABLE_XOR_VAL_DMA
+	help
+	  Enable support for the Intel(R) I/OAT DMA engine present
+	  in recent Intel Xeon chipsets.
+
+	  Say Y here if you have such a chipset.
+
+	  If unsure, say N.
+
+config INTEL_IOP_ADMA
+	tristate "Intel IOP ADMA support"
+	depends on ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX
+	select DMA_ENGINE
+	select ASYNC_TX_ENABLE_CHANNEL_SWITCH
+	help
+	  Enable support for the Intel(R) IOP Series RAID engines.
+
+config INTEL_MID_DMAC
+	tristate "Intel MID DMA support for Peripheral DMA controllers"
+	depends on PCI && X86
+	select DMA_ENGINE
+	default n
+	help
+	  Enable support for the Intel(R) MID DMA engine present
+	  in Intel MID chipsets.
+
+	  Say Y here if you have such a chipset.
+
+	  If unsure, say N.
+
 config MPC512X_DMA
 	tristate "Freescale MPC512x built-in DMA engine support"
 	depends on PPC_MPC512x || PPC_MPC831x
@@ -140,70 +194,13 @@ config MX3_IPU_IRQS
 	  To avoid bloating the irq_desc[] array we allocate a sufficient
 	  number of IRQ slots and map them dynamically to specific sources.
 
-config TXX9_DMAC
-	tristate "Toshiba TXx9 SoC DMA support"
-	depends on MACH_TX49XX || MACH_TX39XX
-	select DMA_ENGINE
-	help
-	  Support the TXx9 SoC internal DMA controller.  This can be
-	  integrated in chips such as the Toshiba TX4927/38/39.
-
-config SH_DMAE
-	tristate "Renesas SuperH DMAC support"
-	depends on (SUPERH && SH_DMA) || (ARM && ARCH_SHMOBILE)
-	depends on !SH_DMA_API
-	select DMA_ENGINE
-	help
-	  Enable support for the Renesas SuperH DMA controllers.
-
-config COH901318
-	bool "ST-Ericsson COH901318 DMA support"
-	select DMA_ENGINE
-	depends on ARCH_U300
-	help
-	  Enable support for ST-Ericsson COH 901 318 DMA.
-
-config STE_DMA40
-	bool "ST-Ericsson DMA40 support"
-	depends on ARCH_U8500
-	select DMA_ENGINE
-	help
-	  Support for ST-Ericsson DMA40 controller
-
-config AMCC_PPC440SPE_ADMA
-	tristate "AMCC PPC440SPe ADMA support"
-	depends on 440SPe || 440SP
-	select DMA_ENGINE
-	select ARCH_HAS_ASYNC_TX_FIND_CHANNEL
-	select ASYNC_TX_ENABLE_CHANNEL_SWITCH
-	help
-	  Enable support for the AMCC PPC440SPe RAID engines.
-
-config TIMB_DMA
-	tristate "Timberdale FPGA DMA support"
-	depends on MFD_TIMBERDALE || HAS_IOMEM
-	select DMA_ENGINE
-	help
-	  Enable support for the Timberdale FPGA DMA engine.
-
-config SIRF_DMA
-	tristate "CSR SiRFprimaII DMA support"
-	depends on ARCH_PRIMA2
-	select DMA_ENGINE
-	help
-	  Enable support for the CSR SiRFprimaII DMA engine.
-
-config ARCH_HAS_ASYNC_TX_FIND_CHANNEL
-	bool
-
-config PL330_DMA
-	tristate "DMA API Driver for PL330"
+config MXS_DMA
+	bool "MXS DMA support"
+	depends on SOC_IMX23 || SOC_IMX28
 	select DMA_ENGINE
-	depends on ARM_AMBA
 	help
-	  Select if your platform has one or more PL330 DMACs.
-	  You need to provide platform specific settings via
-	  platform_data for a dma-pl330 device.
+	  Support the MXS DMA engine. This engine including APBH-DMA
+	  and APBX-DMA is integrated into Freescale i.MX23/28 chips.
 
 config PCH_DMA
 	tristate "Intel EG20T PCH / LAPIS Semicon IOH(ML7213/ML7223/ML7831) DMA"
@@ -219,63 +216,55 @@ config PCH_DMA
 	  ML7213/ML7223/ML7831 is companion chip for Intel Atom E6xx series.
 	  ML7213/ML7223/ML7831 is completely compatible for Intel EG20T PCH.
 
-config IMX_SDMA
-	tristate "i.MX SDMA support"
-	depends on ARCH_MXC
+config PL330_DMA
+	tristate "DMA API Driver for PL330"
 	select DMA_ENGINE
+	depends on ARM_AMBA
 	help
-	  Support the i.MX SDMA engine. This engine is integrated into
-	  Freescale i.MX25/31/35/51/53 chips.
+	  Select if your platform has one or more PL330 DMACs.
+	  You need to provide platform specific settings via
+	  platform_data for a dma-pl330 device.
 
-config IMX_DMA
-	tristate "i.MX DMA support"
-	depends on ARCH_MXC
+config SH_DMAE
+	tristate "Renesas SuperH DMAC support"
+	depends on (SUPERH && SH_DMA) || (ARM && ARCH_SHMOBILE)
+	depends on !SH_DMA_API
 	select DMA_ENGINE
 	help
-	  Support the i.MX DMA engine. This engine is integrated into
-	  Freescale i.MX1/21/27 chips.
+	  Enable support for the Renesas SuperH DMA controllers.
 
-config MXS_DMA
-	bool "MXS DMA support"
-	depends on SOC_IMX23 || SOC_IMX28
+config SIRF_DMA
+	tristate "CSR SiRFprimaII DMA support"
+	depends on ARCH_PRIMA2
 	select DMA_ENGINE
 	help
-	  Support the MXS DMA engine. This engine including APBH-DMA
-	  and APBX-DMA is integrated into Freescale i.MX23/28 chips.
+	  Enable support for the CSR SiRFprimaII DMA engine.
 
-config EP93XX_DMA
-	bool "Cirrus Logic EP93xx DMA support"
-	depends on ARCH_EP93XX
+config STE_DMA40
+	bool "ST-Ericsson DMA40 support"
+	depends on ARCH_U8500
 	select DMA_ENGINE
 	help
-	  Enable support for the Cirrus Logic EP93xx M2P/M2M DMA controller.
+	  Support for ST-Ericsson DMA40 controller
 
-config DMA_SA11X0
-	tristate "SA-11x0 DMA support"
-	depends on ARCH_SA1100
+config TIMB_DMA
+	tristate "Timberdale FPGA DMA support"
+	depends on MFD_TIMBERDALE || HAS_IOMEM
 	select DMA_ENGINE
 	help
-	  Support the DMA engine found on Intel StrongARM SA-1100 and
-	  SA-1110 SoCs.  This DMA engine can only be used with on-chip
-	  devices.
+	  Enable support for the Timberdale FPGA DMA engine.
 
-config DMA_ENGINE
-	bool
+config TXX9_DMAC
+	tristate "Toshiba TXx9 SoC DMA support"
+	depends on MACH_TX49XX || MACH_TX39XX
+	select DMA_ENGINE
+	help
+	  Support the TXx9 SoC internal DMA controller.  This can be
+	  integrated in chips such as the Toshiba TX4927/38/39.
 
 comment "DMA Clients"
 	depends on DMA_ENGINE
 
-config NET_DMA
-	bool "Network: TCP receive copy offload"
-	depends on DMA_ENGINE && NET
-	default (INTEL_IOATDMA || FSL_DMA)
-	help
-	  This enables the use of DMA engines in the network stack to
-	  offload receive copy-to-user operations, freeing CPU cycles.
-
-	  Say Y here if you enabled INTEL_IOATDMA or FSL_DMA, otherwise
-	  say N.
-
 config ASYNC_TX_DMA
 	bool "Async_tx: Offload support for the async_tx api"
 	depends on DMA_ENGINE
@@ -294,4 +283,15 @@ config DMATEST
 	  Simple DMA test client. Say N unless you're debugging a
 	  DMA Device driver.
 
+config NET_DMA
+	bool "Network: TCP receive copy offload"
+	depends on DMA_ENGINE && NET
+	default (INTEL_IOATDMA || FSL_DMA)
+	help
+	  This enables the use of DMA engines in the network stack to
+	  offload receive copy-to-user operations, freeing CPU cycles.
+
+	  Say Y here if you enabled INTEL_IOATDMA or FSL_DMA, otherwise
+	  say N.
+
 endif
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index 86b795b..bc94b68 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -1,30 +1,30 @@
 ccflags-$(CONFIG_DMADEVICES_DEBUG)  := -DDEBUG
 ccflags-$(CONFIG_DMADEVICES_VDEBUG) += -DVERBOSE_DEBUG
 
+obj-$(CONFIG_AMBA_PL08X) += amba-pl08x.o
+obj-$(CONFIG_AMCC_PPC440SPE_ADMA) += ppc4xx/
+obj-$(CONFIG_AT_HDMAC) += at_hdmac.o
+obj-$(CONFIG_COH901318) += coh901318.o coh901318_lli.o
 obj-$(CONFIG_DMA_ENGINE) += dmaengine.o
-obj-$(CONFIG_NET_DMA) += iovlock.o
-obj-$(CONFIG_INTEL_MID_DMAC) += intel_mid_dma.o
-obj-$(CONFIG_DMATEST) += dmatest.o
+obj-$(CONFIG_DMA_SA11X0) += sa11x0-dma.o
+obj-$(CONFIG_DW_DMAC) += dw_dmac.o
+obj-$(CONFIG_EP93XX_DMA) += ep93xx_dma.o
+obj-$(CONFIG_FSL_DMA) += fsldma.o
+obj-$(CONFIG_IMX_DMA) += imx-dma.o
+obj-$(CONFIG_IMX_SDMA) += imx-sdma.o
 obj-$(CONFIG_INTEL_IOATDMA) += ioat/
 obj-$(CONFIG_INTEL_IOP_ADMA) += iop-adma.o
-obj-$(CONFIG_FSL_DMA) += fsldma.o
+obj-$(CONFIG_INTEL_MID_DMAC) += intel_mid_dma.o
 obj-$(CONFIG_MPC512X_DMA) += mpc512x_dma.o
 obj-$(CONFIG_MV_XOR) += mv_xor.o
-obj-$(CONFIG_DW_DMAC) += dw_dmac.o
-obj-$(CONFIG_AT_HDMAC) += at_hdmac.o
 obj-$(CONFIG_MX3_IPU) += ipu/
-obj-$(CONFIG_TXX9_DMAC) += txx9dmac.o
-obj-$(CONFIG_SH_DMAE) += shdma.o
-obj-$(CONFIG_COH901318) += coh901318.o coh901318_lli.o
-obj-$(CONFIG_AMCC_PPC440SPE_ADMA) += ppc4xx/
-obj-$(CONFIG_IMX_SDMA) += imx-sdma.o
-obj-$(CONFIG_IMX_DMA) += imx-dma.o
 obj-$(CONFIG_MXS_DMA) += mxs-dma.o
-obj-$(CONFIG_TIMB_DMA) += timb_dma.o
+obj-$(CONFIG_PCH_DMA) += pch_dma.o
+obj-$(CONFIG_PL330_DMA) += pl330.o
+obj-$(CONFIG_SH_DMAE) += shdma.o
 obj-$(CONFIG_SIRF_DMA) += sirf-dma.o
 obj-$(CONFIG_STE_DMA40) += ste_dma40.o ste_dma40_ll.o
-obj-$(CONFIG_PL330_DMA) += pl330.o
-obj-$(CONFIG_PCH_DMA) += pch_dma.o
-obj-$(CONFIG_AMBA_PL08X) += amba-pl08x.o
-obj-$(CONFIG_EP93XX_DMA) += ep93xx_dma.o
-obj-$(CONFIG_DMA_SA11X0) += sa11x0-dma.o
+obj-$(CONFIG_TIMB_DMA) += timb_dma.o
+obj-$(CONFIG_TXX9_DMAC) += txx9dmac.o
+obj-$(CONFIG_DMATEST) += dmatest.o
+obj-$(CONFIG_NET_DMA) += iovlock.o
-- 
1.7.1.1

