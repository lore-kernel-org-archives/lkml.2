Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab0FSQ3O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 12:29:14 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1624 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819Ab0FSQ3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 12:29:10 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6018"; a="44783590"
From: Gregory Bean <gbean@codeaurora.org>
To: dwalker@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Gregory Bean <gbean@codeaurora.org>
Subject: [PATCH 3/3 v2] msm: 8x50: add gpio device configuration.
Date: Sat, 19 Jun 2010 09:29:04 -0700
Message-Id: <1276964944-11063-4-git-send-email-gbean@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1276964944-11063-1-git-send-email-gbean@codeaurora.org>
References: <1276964944-11063-1-git-send-email-gbean@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device configuration and board-init for gpio support on the QSD8x50.

Signed-off-by: Gregory Bean <gbean@codeaurora.org>
---
 arch/arm/mach-msm/board-qsd8x50.c   |   27 +++++++++++++++++++++++++--
 arch/arm/mach-msm/devices-qsd8x50.c |   21 +++++++++++++++++++++
 2 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/board-qsd8x50.c b/arch/arm/mach-msm/board-qsd8x50.c
index e3cc807..508333c 100644
--- a/arch/arm/mach-msm/board-qsd8x50.c
+++ b/arch/arm/mach-msm/board-qsd8x50.c
@@ -40,7 +40,29 @@ static struct msm_gpio uart3_config_data[] = {
 	{ GPIO_CFG(87, 1, GPIO_OUTPUT,  GPIO_PULL_DOWN, GPIO_2MA), "UART2_Tx"},
 };
 
-static struct platform_device *devices[] __initdata = {
+/*
+ * Early devices are those which provide a system service which will be
+ * required by one or more of the function calls in qsd8x50_init.
+ * These devices must be probed and online first in order for
+ * the init routine to run successfully.
+ */
+static struct platform_device *early_devices[] __initdata = {
+	&msm_gpio_devices[0],
+	&msm_gpio_devices[1],
+	&msm_gpio_devices[2],
+	&msm_gpio_devices[3],
+	&msm_gpio_devices[4],
+	&msm_gpio_devices[5],
+	&msm_gpio_devices[6],
+	&msm_gpio_devices[7],
+};
+
+/*
+ * Late devices are those which are dependent upon services initialized
+ * by qsd8x50_init, or which simply have no dependents and can have
+ * their initialization deferred.
+ */
+static struct platform_device *late_devices[] __initdata = {
 	&msm_device_uart3,
 };
 
@@ -64,8 +86,9 @@ static void __init qsd8x50_init_irq(void)
 
 static void __init qsd8x50_init(void)
 {
+	platform_add_devices(early_devices, ARRAY_SIZE(early_devices));
 	msm8x50_init_uart3();
-	platform_add_devices(devices, ARRAY_SIZE(devices));
+	platform_add_devices(late_devices, ARRAY_SIZE(late_devices));
 }
 
 MACHINE_START(QSD8X50_SURF, "QCT QSD8X50 SURF")
diff --git a/arch/arm/mach-msm/devices-qsd8x50.c b/arch/arm/mach-msm/devices-qsd8x50.c
index 4d4a507..2342654 100644
--- a/arch/arm/mach-msm/devices-qsd8x50.c
+++ b/arch/arm/mach-msm/devices-qsd8x50.c
@@ -90,3 +90,24 @@ struct clk msm_clocks_8x50[] = {
 
 unsigned msm_num_clocks_8x50 = ARRAY_SIZE(msm_clocks_8x50);
 
+static struct msm7200a_gpio_platform_data gpio_platform_data[] = {
+	MSM7200A_GPIO_PLATFORM_DATA(0,   0,  15, INT_GPIO_GROUP1),
+	MSM7200A_GPIO_PLATFORM_DATA(1,  16,  42, INT_GPIO_GROUP2),
+	MSM7200A_GPIO_PLATFORM_DATA(2,  43,  67, INT_GPIO_GROUP1),
+	MSM7200A_GPIO_PLATFORM_DATA(3,  68,  94, INT_GPIO_GROUP1),
+	MSM7200A_GPIO_PLATFORM_DATA(4,  95, 103, INT_GPIO_GROUP1),
+	MSM7200A_GPIO_PLATFORM_DATA(5, 104, 121, INT_GPIO_GROUP1),
+	MSM7200A_GPIO_PLATFORM_DATA(6, 122, 152, INT_GPIO_GROUP1),
+	MSM7200A_GPIO_PLATFORM_DATA(7, 153, 164, INT_GPIO_GROUP1),
+};
+
+struct platform_device msm_gpio_devices[] = {
+	MSM7200A_GPIO_DEVICE(0, gpio_platform_data),
+	MSM7200A_GPIO_DEVICE(1, gpio_platform_data),
+	MSM7200A_GPIO_DEVICE(2, gpio_platform_data),
+	MSM7200A_GPIO_DEVICE(3, gpio_platform_data),
+	MSM7200A_GPIO_DEVICE(4, gpio_platform_data),
+	MSM7200A_GPIO_DEVICE(5, gpio_platform_data),
+	MSM7200A_GPIO_DEVICE(6, gpio_platform_data),
+	MSM7200A_GPIO_DEVICE(7, gpio_platform_data),
+};
-- 
1.7.0.4

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
