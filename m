Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab0H0QTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 12:19:49 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6502 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab0H0QTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 12:19:39 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6086"; a="52339604"
From: Gregory Bean <gbean@codeaurora.org>
To: dwalker@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Gregory Bean <gbean@codeaurora.org>
Subject: [PATCH 3/5 v3] msm: convert 8x50 to gpiomux.
Date: Fri, 27 Aug 2010 09:19:33 -0700
Message-Id: <1282925975-26367-3-git-send-email-gbean@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282925975-26367-1-git-send-email-gbean@codeaurora.org>
References: <1282925975-26367-1-git-send-email-gbean@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the gpio-init code from deprecated gpio_tlmm_config
to the new gpiomux api.

Signed-off-by: Gregory Bean <gbean@codeaurora.org>
---
 arch/arm/mach-msm/board-qsd8x50.c |   12 ------------
 arch/arm/mach-msm/gpiomux-8x50.c  |   11 ++++++++++-
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-msm/board-qsd8x50.c b/arch/arm/mach-msm/board-qsd8x50.c
index e3cc807..fb0fe67 100644
--- a/arch/arm/mach-msm/board-qsd8x50.c
+++ b/arch/arm/mach-msm/board-qsd8x50.c
@@ -35,21 +35,10 @@
 
 extern struct sys_timer msm_timer;
 
-static struct msm_gpio uart3_config_data[] = {
-	{ GPIO_CFG(86, 1, GPIO_INPUT,   GPIO_PULL_DOWN, GPIO_2MA), "UART2_Rx"},
-	{ GPIO_CFG(87, 1, GPIO_OUTPUT,  GPIO_PULL_DOWN, GPIO_2MA), "UART2_Tx"},
-};
-
 static struct platform_device *devices[] __initdata = {
 	&msm_device_uart3,
 };
 
-static void msm8x50_init_uart3(void)
-{
-	msm_gpios_request_enable(uart3_config_data,
-				ARRAY_SIZE(uart3_config_data));
-}
-
 static void __init qsd8x50_map_io(void)
 {
 	msm_map_qsd8x50_io();
@@ -64,7 +53,6 @@ static void __init qsd8x50_init_irq(void)
 
 static void __init qsd8x50_init(void)
 {
-	msm8x50_init_uart3();
 	platform_add_devices(devices, ARRAY_SIZE(devices));
 }
 
diff --git a/arch/arm/mach-msm/gpiomux-8x50.c b/arch/arm/mach-msm/gpiomux-8x50.c
index 7b380b3..4406e0f 100644
--- a/arch/arm/mach-msm/gpiomux-8x50.c
+++ b/arch/arm/mach-msm/gpiomux-8x50.c
@@ -16,4 +16,13 @@
  */
 #include "gpiomux.h"
 
-struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS] = {};
+struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS] = {
+	[86] = { /* UART3 RX */
+		.suspended = GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |
+			     GPIOMUX_FUNC_1 | GPIOMUX_VALID,
+	},
+	[87] = { /* UART3 TX */
+		.suspended = GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |
+			     GPIOMUX_FUNC_1 | GPIOMUX_VALID,
+	},
+};
-- 
1.7.0.4

/usr2/gbean/.signature.codeaurora.org
