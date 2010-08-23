Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab0HWUM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 16:12:58 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45103 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab0HWUMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 16:12:52 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6083"; a="51829544"
From: Gregory Bean <gbean@codeaurora.org>
To: dwalker@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Gregory Bean <gbean@codeaurora.org>
Subject: [PATCH 4/5] msm: convert 7x30 to gpiomux.
Date: Mon, 23 Aug 2010 13:12:47 -0700
Message-Id: <1282594368-5791-4-git-send-email-gbean@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282594368-5791-1-git-send-email-gbean@codeaurora.org>
References: <1282594368-5791-1-git-send-email-gbean@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change deprecated gpio_tlmm_config calls to gpiomux calls.

Signed-off-by: Gregory Bean <gbean@codeaurora.org>
---
 arch/arm/mach-msm/board-msm7x30.c |   20 --------------------
 arch/arm/mach-msm/gpiomux-7x30.c  |   21 ++++++++++++++++++++-
 2 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-msm/board-msm7x30.c b/arch/arm/mach-msm/board-msm7x30.c
index e329819..74abb74 100644
--- a/arch/arm/mach-msm/board-msm7x30.c
+++ b/arch/arm/mach-msm/board-msm7x30.c
@@ -39,22 +39,6 @@
 
 extern struct sys_timer msm_timer;
 
-#ifdef CONFIG_SERIAL_MSM_CONSOLE
-static struct msm_gpio uart2_config_data[] = {
-	{ GPIO_CFG(49, 2, GPIO_OUTPUT,  GPIO_PULL_DOWN, GPIO_2MA), "UART2_RFR"},
-	{ GPIO_CFG(50, 2, GPIO_INPUT,   GPIO_PULL_DOWN, GPIO_2MA), "UART2_CTS"},
-	{ GPIO_CFG(51, 2, GPIO_INPUT,   GPIO_PULL_DOWN, GPIO_2MA), "UART2_Rx"},
-	{ GPIO_CFG(52, 2, GPIO_OUTPUT,  GPIO_PULL_DOWN, GPIO_2MA), "UART2_Tx"},
-};
-
-static void msm7x30_init_uart2(void)
-{
-	msm_gpios_request_enable(uart2_config_data,
-			ARRAY_SIZE(uart2_config_data));
-
-}
-#endif
-
 static struct platform_device *devices[] __initdata = {
 #if defined(CONFIG_SERIAL_MSM) || defined(CONFIG_MSM_SERIAL_DEBUGGER)
         &msm_device_uart2,
@@ -70,10 +54,6 @@ static void __init msm7x30_init_irq(void)
 static void __init msm7x30_init(void)
 {
 	platform_add_devices(devices, ARRAY_SIZE(devices));
-#ifdef CONFIG_SERIAL_MSM_CONSOLE
-	msm7x30_init_uart2();
-#endif
-
 }
 
 static void __init msm7x30_map_io(void)
diff --git a/arch/arm/mach-msm/gpiomux-7x30.c b/arch/arm/mach-msm/gpiomux-7x30.c
index 7b380b3..6ce41c5 100644
--- a/arch/arm/mach-msm/gpiomux-7x30.c
+++ b/arch/arm/mach-msm/gpiomux-7x30.c
@@ -16,4 +16,23 @@
  */
 #include "gpiomux.h"
 
-struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS] = {};
+struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS] = {
+#ifdef CONFIG_SERIAL_MSM_CONSOLE
+	[49] = { /* UART2 RFR */
+		.suspended = GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |
+			     GPIOMUX_FUNC_2 | GPIOMUX_VALID,
+	},
+	[50] = { /* UART2 CTS */
+		.suspended = GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |
+			     GPIOMUX_FUNC_2 | GPIOMUX_VALID,
+	},
+	[51] = { /* UART2 RX */
+		.suspended = GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |
+			     GPIOMUX_FUNC_2 | GPIOMUX_VALID,
+	},
+	[52] = { /* UART2 TX */
+		.suspended = GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |
+			     GPIOMUX_FUNC_2 | GPIOMUX_VALID,
+	},
+#endif
+};
-- 
1.7.0.4

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
