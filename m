Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab2JLFov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 01:44:51 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45250 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab2JLFot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 01:44:49 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: vinod.koul@intel.com
Cc: linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        andriy.shevchenko@linux.intel.com,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 3/3] ARM: SPEAr13xx: Pass DW DMAC platform data from DT
Date: Fri, 12 Oct 2012 11:14:42 +0530
Message-Id: <841baa20a4af90761928b77ba59653cbcc29c18b.1350020375.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <91e41b4cc972d298f714cbd6f400569a9710304c.1350020375.git.viresh.kumar@linaro.org>
References: <91e41b4cc972d298f714cbd6f400569a9710304c.1350020375.git.viresh.kumar@linaro.org>
In-Reply-To: <142ef9170a2c69657d8a05ac127a9970d7b04965.1350020375.git.viresh.kumar@linaro.org>
References: <142ef9170a2c69657d8a05ac127a9970d7b04965.1350020375.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 12 Oct 2012 05:44:46.0607 (UTC) FILETIME=[AFE3F9F0:01CDA83C]
X-MC-Unique: 112101206444800201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q9C5iv2s014287

This patch adds dw_dmac's platform data to DT node. It also creates slave info
node for SPEAr13xx, for the devices which were using dw_dmac.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/boot/dts/spear1340.dtsi             | 19 ++++++++++
 arch/arm/boot/dts/spear13xx.dtsi             | 38 ++++++++++++++++++++
 arch/arm/mach-spear13xx/include/mach/spear.h |  2 --
 arch/arm/mach-spear13xx/spear1310.c          |  4 +--
 arch/arm/mach-spear13xx/spear1340.c          | 27 +++-----------
 arch/arm/mach-spear13xx/spear13xx.c          | 54 ++--------------------------
 6 files changed, 65 insertions(+), 79 deletions(-)

diff --git a/arch/arm/boot/dts/spear1340.dtsi b/arch/arm/boot/dts/spear1340.dtsi
index d71fe2a..8ea3f66 100644
--- a/arch/arm/boot/dts/spear1340.dtsi
+++ b/arch/arm/boot/dts/spear1340.dtsi
@@ -24,6 +24,25 @@
 			status = "disabled";
 		};
 
+		dma@ea800000 {
+			slave_info {
+				uart1_tx {
+					bus_id = "uart1_tx";
+					cfg_hi = <0x6000>;	/* 0xC << 11 */
+					cfg_lo = <0>;
+					src_master = <0>;
+					dst_master = <1>;
+				};
+				uart1_tx {
+					bus_id = "uart1_tx";
+					cfg_hi = <0x680>;	/* 0xD << 7 */
+					cfg_lo = <0>;
+					src_master = <1>;
+					dst_master = <0>;
+				};
+			};
+		};
+
 		spi1: spi@5d400000 {
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0x5d400000 0x1000>;
diff --git a/arch/arm/boot/dts/spear13xx.dtsi b/arch/arm/boot/dts/spear13xx.dtsi
index f7b84ac..f06bb50 100644
--- a/arch/arm/boot/dts/spear13xx.dtsi
+++ b/arch/arm/boot/dts/spear13xx.dtsi
@@ -91,6 +91,37 @@
 			reg = <0xea800000 0x1000>;
 			interrupts = <0 19 0x4>;
 			status = "disabled";
+
+			nr_channels = <8>;
+			chan_allocation_order = <1>;
+			chan_priority = <1>;
+			block_size = <0xfff>;
+			nr_masters = <2>;
+			data_width = <3 3 0 0>;
+
+			slave_info {
+				ssp0_tx {
+					bus_id = "ssp0_tx";
+					cfg_hi = <0x2000>;	/* 0x4 << 11 */
+					cfg_lo = <0>;
+					src_master = <0>;
+					dst_master = <0>;
+				};
+				ssp0_rx {
+					bus_id = "ssp0_rx";
+					cfg_hi = <0x280>;	/* 0x5 << 7 */
+					cfg_lo = <0>;
+					src_master = <0>;
+					dst_master = <0>;
+				};
+				cf {
+					bus_id = "cf";
+					cfg_hi = <0>;
+					cfg_lo = <0>;
+					src_master = <0>;
+					dst_master = <0>;
+				};
+			};
 		};
 
 		dma@eb000000 {
@@ -98,6 +129,13 @@
 			reg = <0xeb000000 0x1000>;
 			interrupts = <0 59 0x4>;
 			status = "disabled";
+
+			nr_channels = <8>;
+			chan_allocation_order = <1>;
+			chan_priority = <1>;
+			block_size = <0xfff>;
+			nr_masters = <2>;
+			data_width = <3 3 0 0>;
 		};
 
 		fsmc: flash@b0000000 {
diff --git a/arch/arm/mach-spear13xx/include/mach/spear.h b/arch/arm/mach-spear13xx/include/mach/spear.h
index 07d90ac..71bf5b6 100644
--- a/arch/arm/mach-spear13xx/include/mach/spear.h
+++ b/arch/arm/mach-spear13xx/include/mach/spear.h
@@ -43,8 +43,6 @@
 #define VA_L2CC_BASE				IOMEM(UL(0xFB000000))
 
 /* others */
-#define DMAC0_BASE				UL(0xEA800000)
-#define DMAC1_BASE				UL(0xEB000000)
 #define MCIF_CF_BASE				UL(0xB2800000)
 
 /* Devices present in SPEAr1310 */
diff --git a/arch/arm/mach-spear13xx/spear1310.c b/arch/arm/mach-spear13xx/spear1310.c
index 9fbbfc5..0e60195 100644
--- a/arch/arm/mach-spear13xx/spear1310.c
+++ b/arch/arm/mach-spear13xx/spear1310.c
@@ -36,9 +36,7 @@ static struct pl022_ssp_controller ssp1_plat_data = {
 
 /* Add SPEAr1310 auxdata to pass platform data */
 static struct of_dev_auxdata spear1310_auxdata_lookup[] __initdata = {
-	OF_DEV_AUXDATA("arasan,cf-spear1340", MCIF_CF_BASE, NULL, &cf_dma_priv),
-	OF_DEV_AUXDATA("snps,dma-spear1340", DMAC0_BASE, NULL, &dmac_plat_data),
-	OF_DEV_AUXDATA("snps,dma-spear1340", DMAC1_BASE, NULL, &dmac_plat_data),
+	OF_DEV_AUXDATA("arasan,cf-spear1340", MCIF_CF_BASE, NULL, "cf"),
 	OF_DEV_AUXDATA("arm,pl022", SSP_BASE, NULL, &pl022_plat_data),
 
 	OF_DEV_AUXDATA("arm,pl022", SPEAR1310_SSP1_BASE, NULL, &ssp1_plat_data),
diff --git a/arch/arm/mach-spear13xx/spear1340.c b/arch/arm/mach-spear13xx/spear1340.c
index 081014f..4ea4546 100644
--- a/arch/arm/mach-spear13xx/spear1340.c
+++ b/arch/arm/mach-spear13xx/spear1340.c
@@ -20,7 +20,6 @@
 #include <linux/of_platform.h>
 #include <asm/hardware/gic.h>
 #include <asm/mach/arch.h>
-#include <mach/dma.h>
 #include <mach/generic.h>
 #include <mach/spear.h>
 
@@ -78,26 +77,10 @@
 			(SPEAR1340_MIPHY_OSC_BYPASS_EXT | \
 			SPEAR1340_MIPHY_PLL_RATIO_TOP(25))
 
-static struct dw_dma_slave uart1_dma_param[] = {
-	{
-		/* Tx */
-		.cfg_hi = DWC_CFGH_DST_PER(SPEAR1340_DMA_REQ_UART1_TX),
-		.cfg_lo = 0,
-		.src_master = DMA_MASTER_MEMORY,
-		.dst_master = SPEAR1340_DMA_MASTER_UART1,
-	}, {
-		/* Rx */
-		.cfg_hi = DWC_CFGH_SRC_PER(SPEAR1340_DMA_REQ_UART1_RX),
-		.cfg_lo = 0,
-		.src_master = SPEAR1340_DMA_MASTER_UART1,
-		.dst_master = DMA_MASTER_MEMORY,
-	}
-};
-
 static struct amba_pl011_data uart1_data = {
-	.dma_filter = dw_dma_filter,
-	.dma_tx_param = &uart1_dma_param[0],
-	.dma_rx_param = &uart1_dma_param[1],
+	.dma_filter = dw_generic_filter,
+	.dma_tx_param = "uart1_tx",
+	.dma_rx_param = "uart1_rx",
 };
 
 /* SATA device registration */
@@ -158,9 +141,7 @@ static struct ahci_platform_data sata_pdata = {
 
 /* Add SPEAr1340 auxdata to pass platform data */
 static struct of_dev_auxdata spear1340_auxdata_lookup[] __initdata = {
-	OF_DEV_AUXDATA("arasan,cf-spear1340", MCIF_CF_BASE, NULL, &cf_dma_priv),
-	OF_DEV_AUXDATA("snps,dma-spear1340", DMAC0_BASE, NULL, &dmac_plat_data),
-	OF_DEV_AUXDATA("snps,dma-spear1340", DMAC1_BASE, NULL, &dmac_plat_data),
+	OF_DEV_AUXDATA("arasan,cf-spear1340", MCIF_CF_BASE, NULL, "cf"),
 	OF_DEV_AUXDATA("arm,pl022", SSP_BASE, NULL, &pl022_plat_data),
 
 	OF_DEV_AUXDATA("snps,spear-ahci", SPEAR1340_SATA_BASE, NULL,
diff --git a/arch/arm/mach-spear13xx/spear13xx.c b/arch/arm/mach-spear13xx/spear13xx.c
index 5633d69..90ec4ad 100644
--- a/arch/arm/mach-spear13xx/spear13xx.c
+++ b/arch/arm/mach-spear13xx/spear13xx.c
@@ -22,67 +22,19 @@
 #include <asm/hardware/gic.h>
 #include <asm/mach/map.h>
 #include <asm/smp_twd.h>
-#include <mach/dma.h>
 #include <mach/generic.h>
 #include <mach/spear.h>
 
-/* common dw_dma filter routine to be used by peripherals */
-bool dw_dma_filter(struct dma_chan *chan, void *slave)
-{
-	struct dw_dma_slave *dws = (struct dw_dma_slave *)slave;
-
-	if (chan->device->dev == dws->dma_dev) {
-		chan->private = slave;
-		return true;
-	} else {
-		return false;
-	}
-}
-
 /* ssp device registration */
-static struct dw_dma_slave ssp_dma_param[] = {
-	{
-		/* Tx */
-		.cfg_hi = DWC_CFGH_DST_PER(DMA_REQ_SSP0_TX),
-		.cfg_lo = 0,
-		.src_master = DMA_MASTER_MEMORY,
-		.dst_master = DMA_MASTER_SSP0,
-	}, {
-		/* Rx */
-		.cfg_hi = DWC_CFGH_SRC_PER(DMA_REQ_SSP0_RX),
-		.cfg_lo = 0,
-		.src_master = DMA_MASTER_SSP0,
-		.dst_master = DMA_MASTER_MEMORY,
-	}
-};
-
 struct pl022_ssp_controller pl022_plat_data = {
 	.bus_id = 0,
 	.enable_dma = 1,
-	.dma_filter = dw_dma_filter,
-	.dma_rx_param = &ssp_dma_param[1],
-	.dma_tx_param = &ssp_dma_param[0],
+	.dma_filter = dw_generic_filter,
+	.dma_rx_param = "ssp0_rx",
+	.dma_tx_param = "ssp0_tx",
 	.num_chipselect = 3,
 };
 
-/* CF device registration */
-struct dw_dma_slave cf_dma_priv = {
-	.cfg_hi = 0,
-	.cfg_lo = 0,
-	.src_master = 0,
-	.dst_master = 0,
-};
-
-/* dmac device registeration */
-struct dw_dma_platform_data dmac_plat_data = {
-	.nr_channels = 8,
-	.chan_allocation_order = CHAN_ALLOCATION_DESCENDING,
-	.chan_priority = CHAN_PRIORITY_DESCENDING,
-	.block_size = 4095U,
-	.nr_masters = 2,
-	.data_width = { 3, 3, 0, 0 },
-};
-
 void __init spear13xx_l2x0_init(void)
 {
 	/*
-- 
1.7.12.rc2.18.g61b472e


