Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143Ab1FIKvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 06:51:51 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:54204 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755252Ab1FIKvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 06:51:50 -0400
From: Mattias Wallin <mattias.wallin@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Subject: [PATCH 2/2] mach-ux500: ab5500 platform code added
Date: Thu, 9 Jun 2011 12:51:33 +0200
Message-ID: <1307616693-2067-1-git-send-email-mattias.wallin@stericsson.com>
X-Mailer: git-send-email 1.7.5.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the platform part needed to get the
ab5500-core driver started.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/board-u5500.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-ux500/board-u5500.c b/arch/arm/mach-ux500/board-u5500.c
index 44fd3b5..81e0475 100644
--- a/arch/arm/mach-ux500/board-u5500.c
+++ b/arch/arm/mach-ux500/board-u5500.c
@@ -10,6 +10,7 @@
 #include <linux/amba/bus.h>
 #include <linux/gpio.h>
 #include <linux/irq.h>
+#include <linux/mfd/ab5500/ab5500.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>
@@ -20,6 +21,29 @@
 
 #include "devices-db5500.h"
 
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
@@ -33,6 +57,9 @@ static void __init u5500_init_machine(void)
 
 	u5500_sdi_init();
 	u5500_uart_init();
+
+	platform_add_devices(u5500_platform_devices,
+		ARRAY_SIZE(u5500_platform_devices));
 }
 
 MACHINE_START(U5500, "ST-Ericsson U5500 Platform")
-- 
1.7.4.3

