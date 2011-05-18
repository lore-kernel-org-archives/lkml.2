Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402Ab1ERVwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:52:18 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43663 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091Ab1ERVvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:51:09 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6350"; a="92149655"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/7] msm: gpio: Remove chip-specific register definitions
Date: Wed, 18 May 2011 14:50:49 -0700
Message-Id: <1305755453-31112-4-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305755453-31112-1-git-send-email-davidb@codeaurora.org>
References: <1305755453-31112-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put an SOC prefix on each GPIO register definition, eliminating the
need to have SOC ifdefs around the definitions.

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/gpio.c    |   62 ++++----
 arch/arm/mach-msm/gpio_hw.h |  384 +++++++++++++++++++++----------------------
 2 files changed, 220 insertions(+), 226 deletions(-)

diff --git a/arch/arm/mach-msm/gpio.c b/arch/arm/mach-msm/gpio.c
index c358ced..335afbd 100644
--- a/arch/arm/mach-msm/gpio.c
+++ b/arch/arm/mach-msm/gpio.c
@@ -25,17 +25,17 @@
 
 #define FIRST_GPIO_IRQ MSM_GPIO_TO_INT(0)
 
-#define MSM_GPIO_BANK(bank, first, last)				\
+#define MSM_GPIO_BANK(soc, bank, first, last)				\
 	{								\
 		.regs = {						\
-			.out =         MSM_GPIO_OUT_##bank,		\
-			.in =          MSM_GPIO_IN_##bank,		\
-			.int_status =  MSM_GPIO_INT_STATUS_##bank,	\
-			.int_clear =   MSM_GPIO_INT_CLEAR_##bank,	\
-			.int_en =      MSM_GPIO_INT_EN_##bank,		\
-			.int_edge =    MSM_GPIO_INT_EDGE_##bank,	\
-			.int_pos =     MSM_GPIO_INT_POS_##bank,		\
-			.oe =          MSM_GPIO_OE_##bank,		\
+			.out =         soc##_GPIO_OUT_##bank,		\
+			.in =          soc##_GPIO_IN_##bank,		\
+			.int_status =  soc##_GPIO_INT_STATUS_##bank,	\
+			.int_clear =   soc##_GPIO_INT_CLEAR_##bank,	\
+			.int_en =      soc##_GPIO_INT_EN_##bank,	\
+			.int_edge =    soc##_GPIO_INT_EDGE_##bank,	\
+			.int_pos =     soc##_GPIO_INT_POS_##bank,	\
+			.oe =          soc##_GPIO_OE_##bank,		\
 		},							\
 		.chip = {						\
 			.base = (first),				\
@@ -191,30 +191,30 @@ static void msm_gpio_free(struct gpio_chip *chip, unsigned offset)
 
 struct msm_gpio_chip msm_gpio_chips[] = {
 #if defined(CONFIG_ARCH_MSM7X00A)
-	MSM_GPIO_BANK(0,   0,  15),
-	MSM_GPIO_BANK(1,  16,  42),
-	MSM_GPIO_BANK(2,  43,  67),
-	MSM_GPIO_BANK(3,  68,  94),
-	MSM_GPIO_BANK(4,  95, 106),
-	MSM_GPIO_BANK(5, 107, 121),
+	MSM_GPIO_BANK(MSM7X00, 0,   0,  15),
+	MSM_GPIO_BANK(MSM7X00, 1,  16,  42),
+	MSM_GPIO_BANK(MSM7X00, 2,  43,  67),
+	MSM_GPIO_BANK(MSM7X00, 3,  68,  94),
+	MSM_GPIO_BANK(MSM7X00, 4,  95, 106),
+	MSM_GPIO_BANK(MSM7X00, 5, 107, 121),
 #elif defined(CONFIG_ARCH_MSM7X30)
-	MSM_GPIO_BANK(0,   0,  15),
-	MSM_GPIO_BANK(1,  16,  43),
-	MSM_GPIO_BANK(2,  44,  67),
-	MSM_GPIO_BANK(3,  68,  94),
-	MSM_GPIO_BANK(4,  95, 106),
-	MSM_GPIO_BANK(5, 107, 133),
-	MSM_GPIO_BANK(6, 134, 150),
-	MSM_GPIO_BANK(7, 151, 181),
+	MSM_GPIO_BANK(MSM7X30, 0,   0,  15),
+	MSM_GPIO_BANK(MSM7X30, 1,  16,  43),
+	MSM_GPIO_BANK(MSM7X30, 2,  44,  67),
+	MSM_GPIO_BANK(MSM7X30, 3,  68,  94),
+	MSM_GPIO_BANK(MSM7X30, 4,  95, 106),
+	MSM_GPIO_BANK(MSM7X30, 5, 107, 133),
+	MSM_GPIO_BANK(MSM7X30, 6, 134, 150),
+	MSM_GPIO_BANK(MSM7X30, 7, 151, 181),
 #elif defined(CONFIG_ARCH_QSD8X50)
-	MSM_GPIO_BANK(0,   0,  15),
-	MSM_GPIO_BANK(1,  16,  42),
-	MSM_GPIO_BANK(2,  43,  67),
-	MSM_GPIO_BANK(3,  68,  94),
-	MSM_GPIO_BANK(4,  95, 103),
-	MSM_GPIO_BANK(5, 104, 121),
-	MSM_GPIO_BANK(6, 122, 152),
-	MSM_GPIO_BANK(7, 153, 164),
+	MSM_GPIO_BANK(QSD8X50, 0,   0,  15),
+	MSM_GPIO_BANK(QSD8X50, 1,  16,  42),
+	MSM_GPIO_BANK(QSD8X50, 2,  43,  67),
+	MSM_GPIO_BANK(QSD8X50, 3,  68,  94),
+	MSM_GPIO_BANK(QSD8X50, 4,  95, 103),
+	MSM_GPIO_BANK(QSD8X50, 5, 104, 121),
+	MSM_GPIO_BANK(QSD8X50, 6, 122, 152),
+	MSM_GPIO_BANK(QSD8X50, 7, 153, 164),
 #endif
 };
 
diff --git a/arch/arm/mach-msm/gpio_hw.h b/arch/arm/mach-msm/gpio_hw.h
index 6b50660..ba7972a 100644
--- a/arch/arm/mach-msm/gpio_hw.h
+++ b/arch/arm/mach-msm/gpio_hw.h
@@ -31,248 +31,242 @@
 ** macros.
 */
 
-#if defined(CONFIG_ARCH_MSM7X30)
 #define MSM_GPIO1_REG(off) (MSM_GPIO1_BASE + (off))
 #define MSM_GPIO2_REG(off) (MSM_GPIO2_BASE + 0x400 + (off))
-#else
-#define MSM_GPIO1_REG(off) (MSM_GPIO1_BASE + 0x800 + (off))
-#define MSM_GPIO2_REG(off) (MSM_GPIO2_BASE + 0xC00 + (off))
-#endif
-
-#if defined(CONFIG_ARCH_MSM7X00A) || defined(CONFIG_ARCH_MSM7X25) ||\
-    defined(CONFIG_ARCH_MSM7X27)
+#define MSM_GPIO1_SHADOW_REG(off) (MSM_GPIO1_BASE + 0x800 + (off))
+#define MSM_GPIO2_SHADOW_REG(off) (MSM_GPIO2_BASE + 0xC00 + (off))
 
+/*
+ * MSM7X00 registers
+ */
 /* output value */
-#define MSM_GPIO_OUT_0         MSM_GPIO1_REG(0x00)  /* gpio  15-0  */
-#define MSM_GPIO_OUT_1         MSM_GPIO2_REG(0x00)  /* gpio  42-16 */
-#define MSM_GPIO_OUT_2         MSM_GPIO1_REG(0x04)  /* gpio  67-43 */
-#define MSM_GPIO_OUT_3         MSM_GPIO1_REG(0x08)  /* gpio  94-68 */
-#define MSM_GPIO_OUT_4         MSM_GPIO1_REG(0x0C)  /* gpio 106-95 */
-#define MSM_GPIO_OUT_5         MSM_GPIO1_REG(0x50)  /* gpio 107-121 */
+#define MSM7X00_GPIO_OUT_0	MSM_GPIO1_SHADOW_REG(0x00)  /* gpio  15-0  */
+#define MSM7X00_GPIO_OUT_1	MSM_GPIO2_SHADOW_REG(0x00)  /* gpio  42-16 */
+#define MSM7X00_GPIO_OUT_2	MSM_GPIO1_SHADOW_REG(0x04)  /* gpio  67-43 */
+#define MSM7X00_GPIO_OUT_3	MSM_GPIO1_SHADOW_REG(0x08)  /* gpio  94-68 */
+#define MSM7X00_GPIO_OUT_4	MSM_GPIO1_SHADOW_REG(0x0C)  /* gpio 106-95 */
+#define MSM7X00_GPIO_OUT_5	MSM_GPIO1_SHADOW_REG(0x50)  /* gpio 107-121 */
 
 /* same pin map as above, output enable */
-#define MSM_GPIO_OE_0          MSM_GPIO1_REG(0x10)
-#define MSM_GPIO_OE_1          MSM_GPIO2_REG(0x08)
-#define MSM_GPIO_OE_2          MSM_GPIO1_REG(0x14)
-#define MSM_GPIO_OE_3          MSM_GPIO1_REG(0x18)
-#define MSM_GPIO_OE_4          MSM_GPIO1_REG(0x1C)
-#define MSM_GPIO_OE_5          MSM_GPIO1_REG(0x54)
+#define MSM7X00_GPIO_OE_0	MSM_GPIO1_SHADOW_REG(0x10)
+#define MSM7X00_GPIO_OE_1	MSM_GPIO2_SHADOW_REG(0x08)
+#define MSM7X00_GPIO_OE_2	MSM_GPIO1_SHADOW_REG(0x14)
+#define MSM7X00_GPIO_OE_3	MSM_GPIO1_SHADOW_REG(0x18)
+#define MSM7X00_GPIO_OE_4	MSM_GPIO1_SHADOW_REG(0x1C)
+#define MSM7X00_GPIO_OE_5	MSM_GPIO1_SHADOW_REG(0x54)
 
 /* same pin map as above, input read */
-#define MSM_GPIO_IN_0          MSM_GPIO1_REG(0x34)
-#define MSM_GPIO_IN_1          MSM_GPIO2_REG(0x20)
-#define MSM_GPIO_IN_2          MSM_GPIO1_REG(0x38)
-#define MSM_GPIO_IN_3          MSM_GPIO1_REG(0x3C)
-#define MSM_GPIO_IN_4          MSM_GPIO1_REG(0x40)
-#define MSM_GPIO_IN_5          MSM_GPIO1_REG(0x44)
+#define MSM7X00_GPIO_IN_0	MSM_GPIO1_SHADOW_REG(0x34)
+#define MSM7X00_GPIO_IN_1	MSM_GPIO2_SHADOW_REG(0x20)
+#define MSM7X00_GPIO_IN_2	MSM_GPIO1_SHADOW_REG(0x38)
+#define MSM7X00_GPIO_IN_3	MSM_GPIO1_SHADOW_REG(0x3C)
+#define MSM7X00_GPIO_IN_4	MSM_GPIO1_SHADOW_REG(0x40)
+#define MSM7X00_GPIO_IN_5	MSM_GPIO1_SHADOW_REG(0x44)
 
 /* same pin map as above, 1=edge 0=level interrup */
-#define MSM_GPIO_INT_EDGE_0    MSM_GPIO1_REG(0x60)
-#define MSM_GPIO_INT_EDGE_1    MSM_GPIO2_REG(0x50)
-#define MSM_GPIO_INT_EDGE_2    MSM_GPIO1_REG(0x64)
-#define MSM_GPIO_INT_EDGE_3    MSM_GPIO1_REG(0x68)
-#define MSM_GPIO_INT_EDGE_4    MSM_GPIO1_REG(0x6C)
-#define MSM_GPIO_INT_EDGE_5    MSM_GPIO1_REG(0xC0)
+#define MSM7X00_GPIO_INT_EDGE_0	MSM_GPIO1_SHADOW_REG(0x60)
+#define MSM7X00_GPIO_INT_EDGE_1	MSM_GPIO2_SHADOW_REG(0x50)
+#define MSM7X00_GPIO_INT_EDGE_2	MSM_GPIO1_SHADOW_REG(0x64)
+#define MSM7X00_GPIO_INT_EDGE_3	MSM_GPIO1_SHADOW_REG(0x68)
+#define MSM7X00_GPIO_INT_EDGE_4	MSM_GPIO1_SHADOW_REG(0x6C)
+#define MSM7X00_GPIO_INT_EDGE_5	MSM_GPIO1_SHADOW_REG(0xC0)
 
 /* same pin map as above, 1=positive 0=negative */
-#define MSM_GPIO_INT_POS_0     MSM_GPIO1_REG(0x70)
-#define MSM_GPIO_INT_POS_1     MSM_GPIO2_REG(0x58)
-#define MSM_GPIO_INT_POS_2     MSM_GPIO1_REG(0x74)
-#define MSM_GPIO_INT_POS_3     MSM_GPIO1_REG(0x78)
-#define MSM_GPIO_INT_POS_4     MSM_GPIO1_REG(0x7C)
-#define MSM_GPIO_INT_POS_5     MSM_GPIO1_REG(0xBC)
+#define MSM7X00_GPIO_INT_POS_0	MSM_GPIO1_SHADOW_REG(0x70)
+#define MSM7X00_GPIO_INT_POS_1	MSM_GPIO2_SHADOW_REG(0x58)
+#define MSM7X00_GPIO_INT_POS_2	MSM_GPIO1_SHADOW_REG(0x74)
+#define MSM7X00_GPIO_INT_POS_3	MSM_GPIO1_SHADOW_REG(0x78)
+#define MSM7X00_GPIO_INT_POS_4	MSM_GPIO1_SHADOW_REG(0x7C)
+#define MSM7X00_GPIO_INT_POS_5	MSM_GPIO1_SHADOW_REG(0xBC)
 
 /* same pin map as above, interrupt enable */
-#define MSM_GPIO_INT_EN_0      MSM_GPIO1_REG(0x80)
-#define MSM_GPIO_INT_EN_1      MSM_GPIO2_REG(0x60)
-#define MSM_GPIO_INT_EN_2      MSM_GPIO1_REG(0x84)
-#define MSM_GPIO_INT_EN_3      MSM_GPIO1_REG(0x88)
-#define MSM_GPIO_INT_EN_4      MSM_GPIO1_REG(0x8C)
-#define MSM_GPIO_INT_EN_5      MSM_GPIO1_REG(0xB8)
+#define MSM7X00_GPIO_INT_EN_0	MSM_GPIO1_SHADOW_REG(0x80)
+#define MSM7X00_GPIO_INT_EN_1	MSM_GPIO2_SHADOW_REG(0x60)
+#define MSM7X00_GPIO_INT_EN_2	MSM_GPIO1_SHADOW_REG(0x84)
+#define MSM7X00_GPIO_INT_EN_3	MSM_GPIO1_SHADOW_REG(0x88)
+#define MSM7X00_GPIO_INT_EN_4	MSM_GPIO1_SHADOW_REG(0x8C)
+#define MSM7X00_GPIO_INT_EN_5	MSM_GPIO1_SHADOW_REG(0xB8)
 
 /* same pin map as above, write 1 to clear interrupt */
-#define MSM_GPIO_INT_CLEAR_0   MSM_GPIO1_REG(0x90)
-#define MSM_GPIO_INT_CLEAR_1   MSM_GPIO2_REG(0x68)
-#define MSM_GPIO_INT_CLEAR_2   MSM_GPIO1_REG(0x94)
-#define MSM_GPIO_INT_CLEAR_3   MSM_GPIO1_REG(0x98)
-#define MSM_GPIO_INT_CLEAR_4   MSM_GPIO1_REG(0x9C)
-#define MSM_GPIO_INT_CLEAR_5   MSM_GPIO1_REG(0xB4)
+#define MSM7X00_GPIO_INT_CLEAR_0	MSM_GPIO1_SHADOW_REG(0x90)
+#define MSM7X00_GPIO_INT_CLEAR_1	MSM_GPIO2_SHADOW_REG(0x68)
+#define MSM7X00_GPIO_INT_CLEAR_2	MSM_GPIO1_SHADOW_REG(0x94)
+#define MSM7X00_GPIO_INT_CLEAR_3	MSM_GPIO1_SHADOW_REG(0x98)
+#define MSM7X00_GPIO_INT_CLEAR_4	MSM_GPIO1_SHADOW_REG(0x9C)
+#define MSM7X00_GPIO_INT_CLEAR_5	MSM_GPIO1_SHADOW_REG(0xB4)
 
 /* same pin map as above, 1=interrupt pending */
-#define MSM_GPIO_INT_STATUS_0  MSM_GPIO1_REG(0xA0)
-#define MSM_GPIO_INT_STATUS_1  MSM_GPIO2_REG(0x70)
-#define MSM_GPIO_INT_STATUS_2  MSM_GPIO1_REG(0xA4)
-#define MSM_GPIO_INT_STATUS_3  MSM_GPIO1_REG(0xA8)
-#define MSM_GPIO_INT_STATUS_4  MSM_GPIO1_REG(0xAC)
-#define MSM_GPIO_INT_STATUS_5  MSM_GPIO1_REG(0xB0)
-
-#endif
-
-#if defined(CONFIG_ARCH_QSD8X50)
+#define MSM7X00_GPIO_INT_STATUS_0	MSM_GPIO1_SHADOW_REG(0xA0)
+#define MSM7X00_GPIO_INT_STATUS_1	MSM_GPIO2_SHADOW_REG(0x70)
+#define MSM7X00_GPIO_INT_STATUS_2	MSM_GPIO1_SHADOW_REG(0xA4)
+#define MSM7X00_GPIO_INT_STATUS_3	MSM_GPIO1_SHADOW_REG(0xA8)
+#define MSM7X00_GPIO_INT_STATUS_4	MSM_GPIO1_SHADOW_REG(0xAC)
+#define MSM7X00_GPIO_INT_STATUS_5	MSM_GPIO1_SHADOW_REG(0xB0)
+
+/*
+ * QSD8X50 registers
+ */
 /* output value */
-#define MSM_GPIO_OUT_0         MSM_GPIO1_REG(0x00)  /* gpio  15-0   */
-#define MSM_GPIO_OUT_1         MSM_GPIO2_REG(0x00)  /* gpio  42-16  */
-#define MSM_GPIO_OUT_2         MSM_GPIO1_REG(0x04)  /* gpio  67-43  */
-#define MSM_GPIO_OUT_3         MSM_GPIO1_REG(0x08)  /* gpio  94-68  */
-#define MSM_GPIO_OUT_4         MSM_GPIO1_REG(0x0C)  /* gpio 103-95  */
-#define MSM_GPIO_OUT_5         MSM_GPIO1_REG(0x10)  /* gpio 121-104 */
-#define MSM_GPIO_OUT_6         MSM_GPIO1_REG(0x14)  /* gpio 152-122 */
-#define MSM_GPIO_OUT_7         MSM_GPIO1_REG(0x18)  /* gpio 164-153 */
+#define QSD8X50_GPIO_OUT_0	MSM_GPIO1_SHADOW_REG(0x00)  /* gpio  15-0   */
+#define QSD8X50_GPIO_OUT_1	MSM_GPIO2_SHADOW_REG(0x00)  /* gpio  42-16  */
+#define QSD8X50_GPIO_OUT_2	MSM_GPIO1_SHADOW_REG(0x04)  /* gpio  67-43  */
+#define QSD8X50_GPIO_OUT_3	MSM_GPIO1_SHADOW_REG(0x08)  /* gpio  94-68  */
+#define QSD8X50_GPIO_OUT_4	MSM_GPIO1_SHADOW_REG(0x0C)  /* gpio 103-95  */
+#define QSD8X50_GPIO_OUT_5	MSM_GPIO1_SHADOW_REG(0x10)  /* gpio 121-104 */
+#define QSD8X50_GPIO_OUT_6	MSM_GPIO1_SHADOW_REG(0x14)  /* gpio 152-122 */
+#define QSD8X50_GPIO_OUT_7	MSM_GPIO1_SHADOW_REG(0x18)  /* gpio 164-153 */
 
 /* same pin map as above, output enable */
-#define MSM_GPIO_OE_0          MSM_GPIO1_REG(0x20)
-#define MSM_GPIO_OE_1          MSM_GPIO2_REG(0x08)
-#define MSM_GPIO_OE_2          MSM_GPIO1_REG(0x24)
-#define MSM_GPIO_OE_3          MSM_GPIO1_REG(0x28)
-#define MSM_GPIO_OE_4          MSM_GPIO1_REG(0x2C)
-#define MSM_GPIO_OE_5          MSM_GPIO1_REG(0x30)
-#define MSM_GPIO_OE_6          MSM_GPIO1_REG(0x34)
-#define MSM_GPIO_OE_7          MSM_GPIO1_REG(0x38)
+#define QSD8X50_GPIO_OE_0	MSM_GPIO1_SHADOW_REG(0x20)
+#define QSD8X50_GPIO_OE_1	MSM_GPIO2_SHADOW_REG(0x08)
+#define QSD8X50_GPIO_OE_2	MSM_GPIO1_SHADOW_REG(0x24)
+#define QSD8X50_GPIO_OE_3	MSM_GPIO1_SHADOW_REG(0x28)
+#define QSD8X50_GPIO_OE_4	MSM_GPIO1_SHADOW_REG(0x2C)
+#define QSD8X50_GPIO_OE_5	MSM_GPIO1_SHADOW_REG(0x30)
+#define QSD8X50_GPIO_OE_6	MSM_GPIO1_SHADOW_REG(0x34)
+#define QSD8X50_GPIO_OE_7	MSM_GPIO1_SHADOW_REG(0x38)
 
 /* same pin map as above, input read */
-#define MSM_GPIO_IN_0          MSM_GPIO1_REG(0x50)
-#define MSM_GPIO_IN_1          MSM_GPIO2_REG(0x20)
-#define MSM_GPIO_IN_2          MSM_GPIO1_REG(0x54)
-#define MSM_GPIO_IN_3          MSM_GPIO1_REG(0x58)
-#define MSM_GPIO_IN_4          MSM_GPIO1_REG(0x5C)
-#define MSM_GPIO_IN_5          MSM_GPIO1_REG(0x60)
-#define MSM_GPIO_IN_6          MSM_GPIO1_REG(0x64)
-#define MSM_GPIO_IN_7          MSM_GPIO1_REG(0x68)
+#define QSD8X50_GPIO_IN_0	MSM_GPIO1_SHADOW_REG(0x50)
+#define QSD8X50_GPIO_IN_1	MSM_GPIO2_SHADOW_REG(0x20)
+#define QSD8X50_GPIO_IN_2	MSM_GPIO1_SHADOW_REG(0x54)
+#define QSD8X50_GPIO_IN_3	MSM_GPIO1_SHADOW_REG(0x58)
+#define QSD8X50_GPIO_IN_4	MSM_GPIO1_SHADOW_REG(0x5C)
+#define QSD8X50_GPIO_IN_5	MSM_GPIO1_SHADOW_REG(0x60)
+#define QSD8X50_GPIO_IN_6	MSM_GPIO1_SHADOW_REG(0x64)
+#define QSD8X50_GPIO_IN_7	MSM_GPIO1_SHADOW_REG(0x68)
 
 /* same pin map as above, 1=edge 0=level interrup */
-#define MSM_GPIO_INT_EDGE_0    MSM_GPIO1_REG(0x70)
-#define MSM_GPIO_INT_EDGE_1    MSM_GPIO2_REG(0x50)
-#define MSM_GPIO_INT_EDGE_2    MSM_GPIO1_REG(0x74)
-#define MSM_GPIO_INT_EDGE_3    MSM_GPIO1_REG(0x78)
-#define MSM_GPIO_INT_EDGE_4    MSM_GPIO1_REG(0x7C)
-#define MSM_GPIO_INT_EDGE_5    MSM_GPIO1_REG(0x80)
-#define MSM_GPIO_INT_EDGE_6    MSM_GPIO1_REG(0x84)
-#define MSM_GPIO_INT_EDGE_7    MSM_GPIO1_REG(0x88)
+#define QSD8X50_GPIO_INT_EDGE_0	MSM_GPIO1_SHADOW_REG(0x70)
+#define QSD8X50_GPIO_INT_EDGE_1	MSM_GPIO2_SHADOW_REG(0x50)
+#define QSD8X50_GPIO_INT_EDGE_2	MSM_GPIO1_SHADOW_REG(0x74)
+#define QSD8X50_GPIO_INT_EDGE_3	MSM_GPIO1_SHADOW_REG(0x78)
+#define QSD8X50_GPIO_INT_EDGE_4	MSM_GPIO1_SHADOW_REG(0x7C)
+#define QSD8X50_GPIO_INT_EDGE_5	MSM_GPIO1_SHADOW_REG(0x80)
+#define QSD8X50_GPIO_INT_EDGE_6	MSM_GPIO1_SHADOW_REG(0x84)
+#define QSD8X50_GPIO_INT_EDGE_7	MSM_GPIO1_SHADOW_REG(0x88)
 
 /* same pin map as above, 1=positive 0=negative */
-#define MSM_GPIO_INT_POS_0     MSM_GPIO1_REG(0x90)
-#define MSM_GPIO_INT_POS_1     MSM_GPIO2_REG(0x58)
-#define MSM_GPIO_INT_POS_2     MSM_GPIO1_REG(0x94)
-#define MSM_GPIO_INT_POS_3     MSM_GPIO1_REG(0x98)
-#define MSM_GPIO_INT_POS_4     MSM_GPIO1_REG(0x9C)
-#define MSM_GPIO_INT_POS_5     MSM_GPIO1_REG(0xA0)
-#define MSM_GPIO_INT_POS_6     MSM_GPIO1_REG(0xA4)
-#define MSM_GPIO_INT_POS_7     MSM_GPIO1_REG(0xA8)
+#define QSD8X50_GPIO_INT_POS_0	MSM_GPIO1_SHADOW_REG(0x90)
+#define QSD8X50_GPIO_INT_POS_1	MSM_GPIO2_SHADOW_REG(0x58)
+#define QSD8X50_GPIO_INT_POS_2	MSM_GPIO1_SHADOW_REG(0x94)
+#define QSD8X50_GPIO_INT_POS_3	MSM_GPIO1_SHADOW_REG(0x98)
+#define QSD8X50_GPIO_INT_POS_4	MSM_GPIO1_SHADOW_REG(0x9C)
+#define QSD8X50_GPIO_INT_POS_5	MSM_GPIO1_SHADOW_REG(0xA0)
+#define QSD8X50_GPIO_INT_POS_6	MSM_GPIO1_SHADOW_REG(0xA4)
+#define QSD8X50_GPIO_INT_POS_7	MSM_GPIO1_SHADOW_REG(0xA8)
 
 /* same pin map as above, interrupt enable */
-#define MSM_GPIO_INT_EN_0      MSM_GPIO1_REG(0xB0)
-#define MSM_GPIO_INT_EN_1      MSM_GPIO2_REG(0x60)
-#define MSM_GPIO_INT_EN_2      MSM_GPIO1_REG(0xB4)
-#define MSM_GPIO_INT_EN_3      MSM_GPIO1_REG(0xB8)
-#define MSM_GPIO_INT_EN_4      MSM_GPIO1_REG(0xBC)
-#define MSM_GPIO_INT_EN_5      MSM_GPIO1_REG(0xC0)
-#define MSM_GPIO_INT_EN_6      MSM_GPIO1_REG(0xC4)
-#define MSM_GPIO_INT_EN_7      MSM_GPIO1_REG(0xC8)
+#define QSD8X50_GPIO_INT_EN_0	MSM_GPIO1_SHADOW_REG(0xB0)
+#define QSD8X50_GPIO_INT_EN_1	MSM_GPIO2_SHADOW_REG(0x60)
+#define QSD8X50_GPIO_INT_EN_2	MSM_GPIO1_SHADOW_REG(0xB4)
+#define QSD8X50_GPIO_INT_EN_3	MSM_GPIO1_SHADOW_REG(0xB8)
+#define QSD8X50_GPIO_INT_EN_4	MSM_GPIO1_SHADOW_REG(0xBC)
+#define QSD8X50_GPIO_INT_EN_5	MSM_GPIO1_SHADOW_REG(0xC0)
+#define QSD8X50_GPIO_INT_EN_6	MSM_GPIO1_SHADOW_REG(0xC4)
+#define QSD8X50_GPIO_INT_EN_7	MSM_GPIO1_SHADOW_REG(0xC8)
 
 /* same pin map as above, write 1 to clear interrupt */
-#define MSM_GPIO_INT_CLEAR_0   MSM_GPIO1_REG(0xD0)
-#define MSM_GPIO_INT_CLEAR_1   MSM_GPIO2_REG(0x68)
-#define MSM_GPIO_INT_CLEAR_2   MSM_GPIO1_REG(0xD4)
-#define MSM_GPIO_INT_CLEAR_3   MSM_GPIO1_REG(0xD8)
-#define MSM_GPIO_INT_CLEAR_4   MSM_GPIO1_REG(0xDC)
-#define MSM_GPIO_INT_CLEAR_5   MSM_GPIO1_REG(0xE0)
-#define MSM_GPIO_INT_CLEAR_6   MSM_GPIO1_REG(0xE4)
-#define MSM_GPIO_INT_CLEAR_7   MSM_GPIO1_REG(0xE8)
+#define QSD8X50_GPIO_INT_CLEAR_0	MSM_GPIO1_SHADOW_REG(0xD0)
+#define QSD8X50_GPIO_INT_CLEAR_1	MSM_GPIO2_SHADOW_REG(0x68)
+#define QSD8X50_GPIO_INT_CLEAR_2	MSM_GPIO1_SHADOW_REG(0xD4)
+#define QSD8X50_GPIO_INT_CLEAR_3	MSM_GPIO1_SHADOW_REG(0xD8)
+#define QSD8X50_GPIO_INT_CLEAR_4	MSM_GPIO1_SHADOW_REG(0xDC)
+#define QSD8X50_GPIO_INT_CLEAR_5	MSM_GPIO1_SHADOW_REG(0xE0)
+#define QSD8X50_GPIO_INT_CLEAR_6	MSM_GPIO1_SHADOW_REG(0xE4)
+#define QSD8X50_GPIO_INT_CLEAR_7	MSM_GPIO1_SHADOW_REG(0xE8)
 
 /* same pin map as above, 1=interrupt pending */
-#define MSM_GPIO_INT_STATUS_0  MSM_GPIO1_REG(0xF0)
-#define MSM_GPIO_INT_STATUS_1  MSM_GPIO2_REG(0x70)
-#define MSM_GPIO_INT_STATUS_2  MSM_GPIO1_REG(0xF4)
-#define MSM_GPIO_INT_STATUS_3  MSM_GPIO1_REG(0xF8)
-#define MSM_GPIO_INT_STATUS_4  MSM_GPIO1_REG(0xFC)
-#define MSM_GPIO_INT_STATUS_5  MSM_GPIO1_REG(0x100)
-#define MSM_GPIO_INT_STATUS_6  MSM_GPIO1_REG(0x104)
-#define MSM_GPIO_INT_STATUS_7  MSM_GPIO1_REG(0x108)
-
-#endif
-
-#if defined(CONFIG_ARCH_MSM7X30)
-
+#define QSD8X50_GPIO_INT_STATUS_0	MSM_GPIO1_SHADOW_REG(0xF0)
+#define QSD8X50_GPIO_INT_STATUS_1	MSM_GPIO2_SHADOW_REG(0x70)
+#define QSD8X50_GPIO_INT_STATUS_2	MSM_GPIO1_SHADOW_REG(0xF4)
+#define QSD8X50_GPIO_INT_STATUS_3	MSM_GPIO1_SHADOW_REG(0xF8)
+#define QSD8X50_GPIO_INT_STATUS_4	MSM_GPIO1_SHADOW_REG(0xFC)
+#define QSD8X50_GPIO_INT_STATUS_5	MSM_GPIO1_SHADOW_REG(0x100)
+#define QSD8X50_GPIO_INT_STATUS_6	MSM_GPIO1_SHADOW_REG(0x104)
+#define QSD8X50_GPIO_INT_STATUS_7	MSM_GPIO1_SHADOW_REG(0x108)
+
+/*
+ * MSM7X30 registers
+ */
 /* output value */
-#define MSM_GPIO_OUT_0         MSM_GPIO1_REG(0x00)   /* gpio  15-0   */
-#define MSM_GPIO_OUT_1         MSM_GPIO2_REG(0x00)   /* gpio  43-16  */
-#define MSM_GPIO_OUT_2         MSM_GPIO1_REG(0x04)   /* gpio  67-44  */
-#define MSM_GPIO_OUT_3         MSM_GPIO1_REG(0x08)   /* gpio  94-68  */
-#define MSM_GPIO_OUT_4         MSM_GPIO1_REG(0x0C)   /* gpio 106-95  */
-#define MSM_GPIO_OUT_5         MSM_GPIO1_REG(0x50)   /* gpio 133-107 */
-#define MSM_GPIO_OUT_6         MSM_GPIO1_REG(0xC4)   /* gpio 150-134 */
-#define MSM_GPIO_OUT_7         MSM_GPIO1_REG(0x214)  /* gpio 181-151 */
+#define MSM7X30_GPIO_OUT_0	MSM_GPIO1_REG(0x00)   /* gpio  15-0   */
+#define MSM7X30_GPIO_OUT_1	MSM_GPIO2_REG(0x00)   /* gpio  43-16  */
+#define MSM7X30_GPIO_OUT_2	MSM_GPIO1_REG(0x04)   /* gpio  67-44  */
+#define MSM7X30_GPIO_OUT_3	MSM_GPIO1_REG(0x08)   /* gpio  94-68  */
+#define MSM7X30_GPIO_OUT_4	MSM_GPIO1_REG(0x0C)   /* gpio 106-95  */
+#define MSM7X30_GPIO_OUT_5	MSM_GPIO1_REG(0x50)   /* gpio 133-107 */
+#define MSM7X30_GPIO_OUT_6	MSM_GPIO1_REG(0xC4)   /* gpio 150-134 */
+#define MSM7X30_GPIO_OUT_7	MSM_GPIO1_REG(0x214)  /* gpio 181-151 */
 
 /* same pin map as above, output enable */
-#define MSM_GPIO_OE_0          MSM_GPIO1_REG(0x10)
-#define MSM_GPIO_OE_1          MSM_GPIO2_REG(0x08)
-#define MSM_GPIO_OE_2          MSM_GPIO1_REG(0x14)
-#define MSM_GPIO_OE_3          MSM_GPIO1_REG(0x18)
-#define MSM_GPIO_OE_4          MSM_GPIO1_REG(0x1C)
-#define MSM_GPIO_OE_5          MSM_GPIO1_REG(0x54)
-#define MSM_GPIO_OE_6          MSM_GPIO1_REG(0xC8)
-#define MSM_GPIO_OE_7          MSM_GPIO1_REG(0x218)
+#define MSM7X30_GPIO_OE_0	MSM_GPIO1_REG(0x10)
+#define MSM7X30_GPIO_OE_1	MSM_GPIO2_REG(0x08)
+#define MSM7X30_GPIO_OE_2	MSM_GPIO1_REG(0x14)
+#define MSM7X30_GPIO_OE_3	MSM_GPIO1_REG(0x18)
+#define MSM7X30_GPIO_OE_4	MSM_GPIO1_REG(0x1C)
+#define MSM7X30_GPIO_OE_5	MSM_GPIO1_REG(0x54)
+#define MSM7X30_GPIO_OE_6	MSM_GPIO1_REG(0xC8)
+#define MSM7X30_GPIO_OE_7	MSM_GPIO1_REG(0x218)
 
 /* same pin map as above, input read */
-#define MSM_GPIO_IN_0          MSM_GPIO1_REG(0x34)
-#define MSM_GPIO_IN_1          MSM_GPIO2_REG(0x20)
-#define MSM_GPIO_IN_2          MSM_GPIO1_REG(0x38)
-#define MSM_GPIO_IN_3          MSM_GPIO1_REG(0x3C)
-#define MSM_GPIO_IN_4          MSM_GPIO1_REG(0x40)
-#define MSM_GPIO_IN_5          MSM_GPIO1_REG(0x44)
-#define MSM_GPIO_IN_6          MSM_GPIO1_REG(0xCC)
-#define MSM_GPIO_IN_7          MSM_GPIO1_REG(0x21C)
+#define MSM7X30_GPIO_IN_0	MSM_GPIO1_REG(0x34)
+#define MSM7X30_GPIO_IN_1	MSM_GPIO2_REG(0x20)
+#define MSM7X30_GPIO_IN_2	MSM_GPIO1_REG(0x38)
+#define MSM7X30_GPIO_IN_3	MSM_GPIO1_REG(0x3C)
+#define MSM7X30_GPIO_IN_4	MSM_GPIO1_REG(0x40)
+#define MSM7X30_GPIO_IN_5	MSM_GPIO1_REG(0x44)
+#define MSM7X30_GPIO_IN_6	MSM_GPIO1_REG(0xCC)
+#define MSM7X30_GPIO_IN_7	MSM_GPIO1_REG(0x21C)
 
 /* same pin map as above, 1=edge 0=level interrup */
-#define MSM_GPIO_INT_EDGE_0    MSM_GPIO1_REG(0x60)
-#define MSM_GPIO_INT_EDGE_1    MSM_GPIO2_REG(0x50)
-#define MSM_GPIO_INT_EDGE_2    MSM_GPIO1_REG(0x64)
-#define MSM_GPIO_INT_EDGE_3    MSM_GPIO1_REG(0x68)
-#define MSM_GPIO_INT_EDGE_4    MSM_GPIO1_REG(0x6C)
-#define MSM_GPIO_INT_EDGE_5    MSM_GPIO1_REG(0xC0)
-#define MSM_GPIO_INT_EDGE_6    MSM_GPIO1_REG(0xD0)
-#define MSM_GPIO_INT_EDGE_7    MSM_GPIO1_REG(0x240)
+#define MSM7X30_GPIO_INT_EDGE_0	MSM_GPIO1_REG(0x60)
+#define MSM7X30_GPIO_INT_EDGE_1	MSM_GPIO2_REG(0x50)
+#define MSM7X30_GPIO_INT_EDGE_2	MSM_GPIO1_REG(0x64)
+#define MSM7X30_GPIO_INT_EDGE_3	MSM_GPIO1_REG(0x68)
+#define MSM7X30_GPIO_INT_EDGE_4	MSM_GPIO1_REG(0x6C)
+#define MSM7X30_GPIO_INT_EDGE_5	MSM_GPIO1_REG(0xC0)
+#define MSM7X30_GPIO_INT_EDGE_6	MSM_GPIO1_REG(0xD0)
+#define MSM7X30_GPIO_INT_EDGE_7	MSM_GPIO1_REG(0x240)
 
 /* same pin map as above, 1=positive 0=negative */
-#define MSM_GPIO_INT_POS_0     MSM_GPIO1_REG(0x70)
-#define MSM_GPIO_INT_POS_1     MSM_GPIO2_REG(0x58)
-#define MSM_GPIO_INT_POS_2     MSM_GPIO1_REG(0x74)
-#define MSM_GPIO_INT_POS_3     MSM_GPIO1_REG(0x78)
-#define MSM_GPIO_INT_POS_4     MSM_GPIO1_REG(0x7C)
-#define MSM_GPIO_INT_POS_5     MSM_GPIO1_REG(0xBC)
-#define MSM_GPIO_INT_POS_6     MSM_GPIO1_REG(0xD4)
-#define MSM_GPIO_INT_POS_7     MSM_GPIO1_REG(0x228)
+#define MSM7X30_GPIO_INT_POS_0	MSM_GPIO1_REG(0x70)
+#define MSM7X30_GPIO_INT_POS_1	MSM_GPIO2_REG(0x58)
+#define MSM7X30_GPIO_INT_POS_2	MSM_GPIO1_REG(0x74)
+#define MSM7X30_GPIO_INT_POS_3	MSM_GPIO1_REG(0x78)
+#define MSM7X30_GPIO_INT_POS_4	MSM_GPIO1_REG(0x7C)
+#define MSM7X30_GPIO_INT_POS_5	MSM_GPIO1_REG(0xBC)
+#define MSM7X30_GPIO_INT_POS_6	MSM_GPIO1_REG(0xD4)
+#define MSM7X30_GPIO_INT_POS_7	MSM_GPIO1_REG(0x228)
 
 /* same pin map as above, interrupt enable */
-#define MSM_GPIO_INT_EN_0      MSM_GPIO1_REG(0x80)
-#define MSM_GPIO_INT_EN_1      MSM_GPIO2_REG(0x60)
-#define MSM_GPIO_INT_EN_2      MSM_GPIO1_REG(0x84)
-#define MSM_GPIO_INT_EN_3      MSM_GPIO1_REG(0x88)
-#define MSM_GPIO_INT_EN_4      MSM_GPIO1_REG(0x8C)
-#define MSM_GPIO_INT_EN_5      MSM_GPIO1_REG(0xB8)
-#define MSM_GPIO_INT_EN_6      MSM_GPIO1_REG(0xD8)
-#define MSM_GPIO_INT_EN_7      MSM_GPIO1_REG(0x22C)
+#define MSM7X30_GPIO_INT_EN_0	MSM_GPIO1_REG(0x80)
+#define MSM7X30_GPIO_INT_EN_1	MSM_GPIO2_REG(0x60)
+#define MSM7X30_GPIO_INT_EN_2	MSM_GPIO1_REG(0x84)
+#define MSM7X30_GPIO_INT_EN_3	MSM_GPIO1_REG(0x88)
+#define MSM7X30_GPIO_INT_EN_4	MSM_GPIO1_REG(0x8C)
+#define MSM7X30_GPIO_INT_EN_5	MSM_GPIO1_REG(0xB8)
+#define MSM7X30_GPIO_INT_EN_6	MSM_GPIO1_REG(0xD8)
+#define MSM7X30_GPIO_INT_EN_7	MSM_GPIO1_REG(0x22C)
 
 /* same pin map as above, write 1 to clear interrupt */
-#define MSM_GPIO_INT_CLEAR_0   MSM_GPIO1_REG(0x90)
-#define MSM_GPIO_INT_CLEAR_1   MSM_GPIO2_REG(0x68)
-#define MSM_GPIO_INT_CLEAR_2   MSM_GPIO1_REG(0x94)
-#define MSM_GPIO_INT_CLEAR_3   MSM_GPIO1_REG(0x98)
-#define MSM_GPIO_INT_CLEAR_4   MSM_GPIO1_REG(0x9C)
-#define MSM_GPIO_INT_CLEAR_5   MSM_GPIO1_REG(0xB4)
-#define MSM_GPIO_INT_CLEAR_6   MSM_GPIO1_REG(0xDC)
-#define MSM_GPIO_INT_CLEAR_7   MSM_GPIO1_REG(0x230)
+#define MSM7X30_GPIO_INT_CLEAR_0	MSM_GPIO1_REG(0x90)
+#define MSM7X30_GPIO_INT_CLEAR_1	MSM_GPIO2_REG(0x68)
+#define MSM7X30_GPIO_INT_CLEAR_2	MSM_GPIO1_REG(0x94)
+#define MSM7X30_GPIO_INT_CLEAR_3	MSM_GPIO1_REG(0x98)
+#define MSM7X30_GPIO_INT_CLEAR_4	MSM_GPIO1_REG(0x9C)
+#define MSM7X30_GPIO_INT_CLEAR_5	MSM_GPIO1_REG(0xB4)
+#define MSM7X30_GPIO_INT_CLEAR_6	MSM_GPIO1_REG(0xDC)
+#define MSM7X30_GPIO_INT_CLEAR_7	MSM_GPIO1_REG(0x230)
 
 /* same pin map as above, 1=interrupt pending */
-#define MSM_GPIO_INT_STATUS_0  MSM_GPIO1_REG(0xA0)
-#define MSM_GPIO_INT_STATUS_1  MSM_GPIO2_REG(0x70)
-#define MSM_GPIO_INT_STATUS_2  MSM_GPIO1_REG(0xA4)
-#define MSM_GPIO_INT_STATUS_3  MSM_GPIO1_REG(0xA8)
-#define MSM_GPIO_INT_STATUS_4  MSM_GPIO1_REG(0xAC)
-#define MSM_GPIO_INT_STATUS_5  MSM_GPIO1_REG(0xB0)
-#define MSM_GPIO_INT_STATUS_6  MSM_GPIO1_REG(0xE0)
-#define MSM_GPIO_INT_STATUS_7  MSM_GPIO1_REG(0x234)
-
-#endif
+#define MSM7X30_GPIO_INT_STATUS_0	MSM_GPIO1_REG(0xA0)
+#define MSM7X30_GPIO_INT_STATUS_1	MSM_GPIO2_REG(0x70)
+#define MSM7X30_GPIO_INT_STATUS_2	MSM_GPIO1_REG(0xA4)
+#define MSM7X30_GPIO_INT_STATUS_3	MSM_GPIO1_REG(0xA8)
+#define MSM7X30_GPIO_INT_STATUS_4	MSM_GPIO1_REG(0xAC)
+#define MSM7X30_GPIO_INT_STATUS_5	MSM_GPIO1_REG(0xB0)
+#define MSM7X30_GPIO_INT_STATUS_6	MSM_GPIO1_REG(0xE0)
+#define MSM7X30_GPIO_INT_STATUS_7	MSM_GPIO1_REG(0x234)
 
 #endif
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

