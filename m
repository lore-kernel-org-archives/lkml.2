Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab1IVGWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 02:22:48 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:34736 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751927Ab1IVGWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 02:22:44 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/4] mach-ux500: ab5500 platform code added
Date: Thu, 22 Sep 2011 08:22:27 +0200
Message-ID: <1316672547-7700-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattias Wallin <mattias.wallin@stericsson.com>

This patch adds the platform part needed to get the
ab5500-core driver started.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/board-u5500.c |   29 ++++++++++++++++++++++++++++-
 1 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-ux500/board-u5500.c b/arch/arm/mach-ux500/board-u5500.c
index e58f0f5..5c9e665 100644
--- a/arch/arm/mach-ux500/board-u5500.c
+++ b/arch/arm/mach-ux500/board-u5500.c
@@ -11,6 +11,7 @@
 #include <linux/gpio.h>
 #include <linux/irq.h>
 #include <linux/i2c.h>
+#include <linux/mfd/ab5500/ab5500.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>
@@ -87,7 +88,6 @@ static struct lm3530_platform_data u5500_als_platform_data = {
 	.brt_val = 0x7F,	/* Max brightness */
 };
 
-
 static struct i2c_board_info __initdata u5500_i2c2_devices[] = {
 	{
 		/* Backlight */
@@ -101,6 +101,30 @@ static void __init u5500_i2c_init(void)
 	db5500_add_i2c2(&u5500_i2c2_data);
 	i2c_register_board_info(2, ARRAY_AND_SIZE(u5500_i2c2_devices));
 }
+
+static struct ab5500_platform_data ab5500_plf_data = {
+	.irq = {
+		.base = 0,
+		.count = 0,
+	},
+	.init_settings = NULL,
+	.init_settings_sz = 0,
+	.pm_power_off = false,
+};
+
+static struct platform_device ab5500_device = {
+	.name = "ab5500-core",
+	.id = 0,
+	.dev = {
+		.platform_data = &ab5500_plf_data,
+	},
+	.num_resources = 0,
+};
+
+static struct platform_device *u5500_platform_devices[] __initdata = {
+	&ab5500_device,
+};
+
 static void __init u5500_uart_init(void)
 {
 	db5500_add_uart0(NULL);
@@ -115,6 +139,9 @@ static void __init u5500_init_machine(void)
 	u5500_i2c_init();
 	u5500_sdi_init();
 	u5500_uart_init();
+
+	platform_add_devices(u5500_platform_devices,
+		ARRAY_SIZE(u5500_platform_devices));
 }
 
 MACHINE_START(U5500, "ST-Ericsson U5500 Platform")
-- 
1.7.3.2

