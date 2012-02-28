Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab2B1H2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 02:28:23 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:47876 "HELO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756172Ab2B1H2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 02:28:16 -0500
From: zhaoy <zhaoy@marvell.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nicolas.pitre@linaro.org, linux@arm.linux.org.uk, hzhuang1@marvell.com,
        cxie4@marvell.com, leoy@marvell.com
Cc: zhaoy <zhaoy@marvell.com>
Subject: [PATCH 01/13] DMA:define second level irq definition
Date: Tue, 28 Feb 2012 15:27:33 +0800
Message-Id: <1330414065-2949-2-git-send-email-zhaoy@marvell.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <Y>
References: <Y>
X-OriginalArrivalTime: 28 Feb 2012 07:27:55.0361 (UTC) FILETIME=[7CE7A510:01CCF5EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	1.add second level irq definition

Change-Id: I9b1d52dbf411c4f79f7dc9891168f9fd7216d18e
Signed-off-by: zhaoy <zhaoy@marvell.com>
---
 arch/arm/mach-mmp/include/mach/irqs.h     |   18 ++++++++++++++----
 arch/arm/mach-mmp/include/mach/regs-icu.h |   12 +++++++++---
 arch/arm/mach-mmp/irq-mmp2.c              |    4 ++++
 arch/arm/mach-mmp/irq-mmp3.c              |    3 +++
 4 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-mmp/include/mach/irqs.h b/arch/arm/mach-mmp/include/mach/irqs.h
index 7126450..df746f4 100644
--- a/arch/arm/mach-mmp/include/mach/irqs.h
+++ b/arch/arm/mach-mmp/include/mach/irqs.h
@@ -166,7 +166,7 @@
 #define IRQ_MMP2_NAND			45
 #define IRQ_MMP2_UART4			46
 #define IRQ_MMP2_DMA_FIQ		47
-#define IRQ_MMP2_DMA_RIQ		48
+#define IRQ_MMP2_DMA_IRQ		48
 #define IRQ_MMP2_GPIO			49
 #define IRQ_MMP2_MIPI_HSI1_MUX		51
 #define IRQ_MMP2_MMC2			52
@@ -234,8 +234,13 @@
 #define IRQ_MMP2_HSI0_CAWAKE		(IRQ_MMP2_MIPI_HSI0_BASE + 0)
 #define IRQ_MMP2_MIPI_HSI_INT0		(IRQ_MMP2_MIPI_HSI0_BASE + 1)
 
-#define IRQ_MMP2_MUX_END		(IRQ_MMP2_MIPI_HSI0_BASE + 2)
 
+#define IRQ_MMP2_DMA_BASE			128
+#define IRQ_MMP2_DMA_SECONDARY(x)		(IRQ_MMP2_DMA_BASE + (x))
+#define IRQ_MMP2_GPIO_START			(IRQ_MMP2_DMA_BASE + 32)
+#define IRQ_MMP2_DMA_NUM			32
+
+#define IRQ_MMP2_MUX_END		(IRQ_MMP2_DMA_BASE + 32)
 /*
  * Interrupt numbers for MMP3
  */
@@ -440,14 +445,19 @@
 #define IRQ_MMP3_UNIPRO_INT_0		(IRQ_MMP3_HSI0_BASE + 3)
 #define IRQ_MMP3_HSI0			(IRQ_MMP3_HSI0_BASE + 4)
 
-#define IRQ_MMP3_MUX_END		(IRQ_MMP3_HSI0_BASE + 5)
+#define IRQ_MMP3_DMA_BASE			(IRQ_MMP3_HSI0_BASE + 5)
+#define IRQ_MMP3_DMA_SECONDARY(x)		(IRQ_MMP3_DMA_BASE + (x))
+#define IRQ_MMP3_GPIO_START			(IRQ_MMP3_DMA_BASE + 32)
+#define IRQ_MMP3_DMA_NUM			32
 
+#define IRQ_MMP3_MUX_END		(IRQ_MMP3_DMA_BASE + 32)
 
 #ifdef CONFIG_CPU_MMP3
 #define IRQ_GPIO_START			IRQ_MMP3_MUX_END
 #else
-#define IRQ_GPIO_START			128
+#define IRQ_GPIO_START			IRQ_MMP2_MUX_END
 #endif
+
 #define IRQ_GPIO_NUM			192
 #define IRQ_GPIO(x)			(IRQ_GPIO_START + (x))
 
diff --git a/arch/arm/mach-mmp/include/mach/regs-icu.h b/arch/arm/mach-mmp/include/mach/regs-icu.h
index f4cff2b..759a182 100644
--- a/arch/arm/mach-mmp/include/mach/regs-icu.h
+++ b/arch/arm/mach-mmp/include/mach/regs-icu.h
@@ -69,6 +69,10 @@
 #define MMP2_ICU_PJ4_IRQ_SEL		ICU_REG(0x104)
 #define MMP2_ICU_PJ4_FIQ_SEL		ICU_REG(0x108)
 
+#define MMP2_ICU_DMA_IRQ_MASK		ICU_REG(0x11c)
+#define MMP2_ICU_DMA_FIQ_MASK		ICU_REG(0x120)
+#define MMP2_ICU_DMA_IRQ_STATUS		ICU_REG(0x128)
+
 #define MMP2_ICU_INVERT			ICU_REG(0x164)
 
 #define MMP2_ICU_INV_PMIC		(1 << 0)
@@ -107,9 +111,11 @@
 #define MMP3_ICU_GBL_IRQ0_MSK		ICU1_REG(0x10C)
 #define MMP3_ICU_GBL_IRQ1_MSK		ICU1_REG(0x110)
 #define MMP3_ICU_GBL_IRQ2_MSK		ICU1_REG(0x114)
-#define MMP3_ICU_DMA_IRQ0_MSK		ICU1_REG(0x118)
-#define MMP3_ICU_DMA_IRQ1_MSK		ICU1_REG(0x11C)
-#define MMP3_ICU_DMA_IRQ2_MSK		ICU1_REG(0x120)
+
+#define MMP3_ICU_DMA_IRQ0_MASK		ICU1_REG(0x118)
+#define MMP3_ICU_DMA_IRQ1_MASK		ICU1_REG(0x11C)
+#define MMP3_ICU_DMA_IRQ2_MASK		ICU1_REG(0x120)
+
 #define MMP3_ICU_DMA_IRQ0_STATUS	ICU1_REG(0x124)
 #define MMP3_ICU_DMA_IRQ1_STATUS	ICU1_REG(0x128)
 #define MMP3_ICU_DMA_IRQ2_STATUS	ICU1_REG(0x12C)
diff --git a/arch/arm/mach-mmp/irq-mmp2.c b/arch/arm/mach-mmp/irq-mmp2.c
index afd74f2..9daf43e 100644
--- a/arch/arm/mach-mmp/irq-mmp2.c
+++ b/arch/arm/mach-mmp/irq-mmp2.c
@@ -149,6 +149,7 @@ SECOND_IRQ_CHIP(twsi, IRQ_MMP2_TWSI_BASE, MMP2_ICU_INT17);
 SECOND_IRQ_CHIP(misc, IRQ_MMP2_MISC_BASE, MMP2_ICU_INT35);
 SECOND_IRQ_CHIP(mipi_hsi1,  IRQ_MMP2_MIPI_HSI1_BASE,  MMP2_ICU_INT51);
 SECOND_IRQ_CHIP(mipi_hsi0,  IRQ_MMP2_MIPI_HSI0_BASE,  MMP2_ICU_INT55);
+SECOND_IRQ_CHIP(dma, IRQ_MMP2_DMA_BASE, MMP2_ICU_DMA_IRQ);
 
 static void init_mux_irq(struct irq_chip *chip, int start, int num)
 {
@@ -185,6 +186,7 @@ void __init mmp2_init_icu(void)
 		case IRQ_MMP2_MIPI_HSI1_MUX:
 		case IRQ_MMP2_MIPI_HSI0_MUX:
 		case IRQ_MMP2_KEYPAD_MUX:
+		case IRQ_MMP2_DMA_IRQ:
 			break;
 		default:
 			irq_set_handler(irq, handle_level_irq);
@@ -206,6 +208,7 @@ void __init mmp2_init_icu(void)
 	init_mux_irq(&mipi_hsi1_irq_chip, IRQ_MMP2_MIPI_HSI1_BASE, 2);
 	init_mux_irq(&keypad_irq_chip, IRQ_MMP2_KEYPAD_BASE, 3);
 	init_mux_irq(&mipi_hsi0_irq_chip, IRQ_MMP2_MIPI_HSI0_BASE, 2);
+	init_mux_irq(&dma_irq_chip, IRQ_MMP2_DMA_BASE, 24);
 
 	irq_set_chained_handler(IRQ_MMP2_PMIC_MUX, pmic_irq_demux);
 	irq_set_chained_handler(IRQ_MMP2_RTC_MUX, rtc_irq_demux);
@@ -214,4 +217,5 @@ void __init mmp2_init_icu(void)
 	irq_set_chained_handler(IRQ_MMP2_MIPI_HSI1_MUX, mipi_hsi1_irq_demux);
 	irq_set_chained_handler(IRQ_MMP2_KEYPAD_MUX, keypad_irq_demux);
 	irq_set_chained_handler(IRQ_MMP2_MIPI_HSI0_MUX, mipi_hsi0_irq_demux);
+	irq_set_chained_handler(IRQ_MMP2_DMA_IRQ, dma_irq_demux);
 }
diff --git a/arch/arm/mach-mmp/irq-mmp3.c b/arch/arm/mach-mmp/irq-mmp3.c
index 829e63c..0f5bf50 100644
--- a/arch/arm/mach-mmp/irq-mmp3.c
+++ b/arch/arm/mach-mmp/irq-mmp3.c
@@ -107,6 +107,7 @@ DEFINE_ICU_MUX_IRQ(ssp,		IRQ_MMP3_SSP_BASE,	MMP3_ICU_INT_51);
 DEFINE_ICU_MUX_IRQ(hsi1,	IRQ_MMP3_HSI1_BASE,	MMP3_ICU_INT_55);
 DEFINE_ICU_MUX_IRQ(misc2,	IRQ_MMP3_SSP_BASE,	MMP3_ICU_INT_57);
 DEFINE_ICU_MUX_IRQ(hsi0,	IRQ_MMP3_SSP_BASE,	MMP3_ICU_INT_58);
+DEFINE_ICU_MUX_IRQ(dma,		IRQ_MMP3_DMA_BASE,	MMP3_ICU_DMA_IRQ1);
 
 static void init_mux_irq(struct icu_mux_irq_chip_data *chip_data,
 	int mux_irq, int mux_start, int count, irq_flow_handler_t mux_handle)
@@ -188,6 +189,8 @@ void __init mmp3_init_gic(void)
 			IRQ_MMP3_MISC2_BASE, 20, misc2_irq_demux);
 	init_mux_irq(&hsi0_icu_chip_data, IRQ_MMP3_HSI0_MUX,
 			IRQ_MMP3_HSI0_BASE, 5, hsi0_irq_demux);
+	init_mux_irq(&dma_icu_chip_data, IRQ_MMP3_DMA_RIQ,
+			IRQ_MMP3_DMA_BASE, 24, dma_irq_demux);
 
 	/*
 	 * Note: IRQ_MMP3_PMIC requires the PMIC MFPR register
-- 
1.7.0.4

