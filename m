Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1LAA3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 19:29:13 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26385 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab1LAA3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 19:29:09 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6546"; a="140146346"
From: David Brown <davidb@codeaurora.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/3] gpio_msm: remove support for MSM7x01
Date: Wed, 30 Nov 2011 16:29:03 -0800
Message-Id: <1322699344-28422-2-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322699344-28422-1-git-send-email-davidb@codeaurora.org>
References: <1322699344-28422-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove support for the device that has been removed from the SOC
support.

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 drivers/gpio/gpio-msm-v1.c |   81 +-------------------------------------------
 1 files changed, 1 insertions(+), 80 deletions(-)

diff --git a/drivers/gpio/gpio-msm-v1.c b/drivers/gpio/gpio-msm-v1.c
index 52a4d42..dcd05be 100644
--- a/drivers/gpio/gpio-msm-v1.c
+++ b/drivers/gpio/gpio-msm-v1.c
@@ -40,73 +40,6 @@
 #define MSM_GPIO2_SHADOW_REG(off) (MSM_GPIO2_BASE + 0xC00 + (off))
 
 /*
- * MSM7X00 registers
- */
-/* output value */
-#define MSM7X00_GPIO_OUT_0	MSM_GPIO1_SHADOW_REG(0x00)  /* gpio  15-0  */
-#define MSM7X00_GPIO_OUT_1	MSM_GPIO2_SHADOW_REG(0x00)  /* gpio  42-16 */
-#define MSM7X00_GPIO_OUT_2	MSM_GPIO1_SHADOW_REG(0x04)  /* gpio  67-43 */
-#define MSM7X00_GPIO_OUT_3	MSM_GPIO1_SHADOW_REG(0x08)  /* gpio  94-68 */
-#define MSM7X00_GPIO_OUT_4	MSM_GPIO1_SHADOW_REG(0x0C)  /* gpio 106-95 */
-#define MSM7X00_GPIO_OUT_5	MSM_GPIO1_SHADOW_REG(0x50)  /* gpio 107-121 */
-
-/* same pin map as above, output enable */
-#define MSM7X00_GPIO_OE_0	MSM_GPIO1_SHADOW_REG(0x10)
-#define MSM7X00_GPIO_OE_1	MSM_GPIO2_SHADOW_REG(0x08)
-#define MSM7X00_GPIO_OE_2	MSM_GPIO1_SHADOW_REG(0x14)
-#define MSM7X00_GPIO_OE_3	MSM_GPIO1_SHADOW_REG(0x18)
-#define MSM7X00_GPIO_OE_4	MSM_GPIO1_SHADOW_REG(0x1C)
-#define MSM7X00_GPIO_OE_5	MSM_GPIO1_SHADOW_REG(0x54)
-
-/* same pin map as above, input read */
-#define MSM7X00_GPIO_IN_0	MSM_GPIO1_SHADOW_REG(0x34)
-#define MSM7X00_GPIO_IN_1	MSM_GPIO2_SHADOW_REG(0x20)
-#define MSM7X00_GPIO_IN_2	MSM_GPIO1_SHADOW_REG(0x38)
-#define MSM7X00_GPIO_IN_3	MSM_GPIO1_SHADOW_REG(0x3C)
-#define MSM7X00_GPIO_IN_4	MSM_GPIO1_SHADOW_REG(0x40)
-#define MSM7X00_GPIO_IN_5	MSM_GPIO1_SHADOW_REG(0x44)
-
-/* same pin map as above, 1=edge 0=level interrup */
-#define MSM7X00_GPIO_INT_EDGE_0	MSM_GPIO1_SHADOW_REG(0x60)
-#define MSM7X00_GPIO_INT_EDGE_1	MSM_GPIO2_SHADOW_REG(0x50)
-#define MSM7X00_GPIO_INT_EDGE_2	MSM_GPIO1_SHADOW_REG(0x64)
-#define MSM7X00_GPIO_INT_EDGE_3	MSM_GPIO1_SHADOW_REG(0x68)
-#define MSM7X00_GPIO_INT_EDGE_4	MSM_GPIO1_SHADOW_REG(0x6C)
-#define MSM7X00_GPIO_INT_EDGE_5	MSM_GPIO1_SHADOW_REG(0xC0)
-
-/* same pin map as above, 1=positive 0=negative */
-#define MSM7X00_GPIO_INT_POS_0	MSM_GPIO1_SHADOW_REG(0x70)
-#define MSM7X00_GPIO_INT_POS_1	MSM_GPIO2_SHADOW_REG(0x58)
-#define MSM7X00_GPIO_INT_POS_2	MSM_GPIO1_SHADOW_REG(0x74)
-#define MSM7X00_GPIO_INT_POS_3	MSM_GPIO1_SHADOW_REG(0x78)
-#define MSM7X00_GPIO_INT_POS_4	MSM_GPIO1_SHADOW_REG(0x7C)
-#define MSM7X00_GPIO_INT_POS_5	MSM_GPIO1_SHADOW_REG(0xBC)
-
-/* same pin map as above, interrupt enable */
-#define MSM7X00_GPIO_INT_EN_0	MSM_GPIO1_SHADOW_REG(0x80)
-#define MSM7X00_GPIO_INT_EN_1	MSM_GPIO2_SHADOW_REG(0x60)
-#define MSM7X00_GPIO_INT_EN_2	MSM_GPIO1_SHADOW_REG(0x84)
-#define MSM7X00_GPIO_INT_EN_3	MSM_GPIO1_SHADOW_REG(0x88)
-#define MSM7X00_GPIO_INT_EN_4	MSM_GPIO1_SHADOW_REG(0x8C)
-#define MSM7X00_GPIO_INT_EN_5	MSM_GPIO1_SHADOW_REG(0xB8)
-
-/* same pin map as above, write 1 to clear interrupt */
-#define MSM7X00_GPIO_INT_CLEAR_0	MSM_GPIO1_SHADOW_REG(0x90)
-#define MSM7X00_GPIO_INT_CLEAR_1	MSM_GPIO2_SHADOW_REG(0x68)
-#define MSM7X00_GPIO_INT_CLEAR_2	MSM_GPIO1_SHADOW_REG(0x94)
-#define MSM7X00_GPIO_INT_CLEAR_3	MSM_GPIO1_SHADOW_REG(0x98)
-#define MSM7X00_GPIO_INT_CLEAR_4	MSM_GPIO1_SHADOW_REG(0x9C)
-#define MSM7X00_GPIO_INT_CLEAR_5	MSM_GPIO1_SHADOW_REG(0xB4)
-
-/* same pin map as above, 1=interrupt pending */
-#define MSM7X00_GPIO_INT_STATUS_0	MSM_GPIO1_SHADOW_REG(0xA0)
-#define MSM7X00_GPIO_INT_STATUS_1	MSM_GPIO2_SHADOW_REG(0x70)
-#define MSM7X00_GPIO_INT_STATUS_2	MSM_GPIO1_SHADOW_REG(0xA4)
-#define MSM7X00_GPIO_INT_STATUS_3	MSM_GPIO1_SHADOW_REG(0xA8)
-#define MSM7X00_GPIO_INT_STATUS_4	MSM_GPIO1_SHADOW_REG(0xAC)
-#define MSM7X00_GPIO_INT_STATUS_5	MSM_GPIO1_SHADOW_REG(0xB0)
-
-/*
  * QSD8X50 registers
  */
 /* output value */
@@ -441,15 +374,6 @@ static void msm_gpio_free(struct gpio_chip *chip, unsigned offset)
 static struct msm_gpio_chip *msm_gpio_chips;
 static int msm_gpio_count;
 
-static struct msm_gpio_chip msm_gpio_chips_msm7x01[] = {
-	MSM_GPIO_BANK(MSM7X00, 0,   0,  15),
-	MSM_GPIO_BANK(MSM7X00, 1,  16,  42),
-	MSM_GPIO_BANK(MSM7X00, 2,  43,  67),
-	MSM_GPIO_BANK(MSM7X00, 3,  68,  94),
-	MSM_GPIO_BANK(MSM7X00, 4,  95, 106),
-	MSM_GPIO_BANK(MSM7X00, 5, 107, 121),
-};
-
 static struct msm_gpio_chip msm_gpio_chips_msm7x30[] = {
 	MSM_GPIO_BANK(MSM7X30, 0,   0,  15),
 	MSM_GPIO_BANK(MSM7X30, 1,  16,  43),
@@ -596,10 +520,7 @@ static int __init msm_init_gpio(void)
 {
 	int i, j = 0;
 
-	if (cpu_is_msm7x01()) {
-		msm_gpio_chips = msm_gpio_chips_msm7x01;
-		msm_gpio_count = ARRAY_SIZE(msm_gpio_chips_msm7x01);
-	} else if (cpu_is_msm7x30()) {
+	if (cpu_is_msm7x30()) {
 		msm_gpio_chips = msm_gpio_chips_msm7x30;
 		msm_gpio_count = ARRAY_SIZE(msm_gpio_chips_msm7x30);
 	} else if (cpu_is_qsd8x50()) {
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

