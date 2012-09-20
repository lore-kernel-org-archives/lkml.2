Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab2ITMSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:18:08 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55161 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab2ITMNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:13:31 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olof.johansson@gmail.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 16/32] ARM: ux500: Clean-up MSP platform code
Date: Thu, 20 Sep 2012 14:12:34 +0200
Message-Id: <1348143170-2130-17-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348143170-2130-1-git-send-email-lee.jones@linaro.org>
References: <1348143170-2130-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains a couple of general MSP clean-ups pertaining to
layout changes and changing functions to be void instead of int instead
of regardlessly returning '0'.

Acked-by: Ola Lilja <ola.o.lilja@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-msp.c |   14 ++++++--------
 arch/arm/mach-ux500/board-mop500-msp.h |   14 --------------
 arch/arm/mach-ux500/board-mop500.c     |    1 -
 arch/arm/mach-ux500/board-mop500.h     |    1 +
 4 files changed, 7 insertions(+), 23 deletions(-)
 delete mode 100644 arch/arm/mach-ux500/board-mop500-msp.h

diff --git a/arch/arm/mach-ux500/board-mop500-msp.c b/arch/arm/mach-ux500/board-mop500-msp.c
index ace6c05..dcf5ea9 100644
--- a/arch/arm/mach-ux500/board-mop500-msp.c
+++ b/arch/arm/mach-ux500/board-mop500-msp.c
@@ -143,11 +143,11 @@ static struct platform_device *db8500_add_msp_i2s(struct device *parent,
 
 /* Platform device for ASoC MOP500 machine */
 static struct platform_device snd_soc_mop500 = {
-		.name = "snd-soc-mop500",
-		.id = 0,
-		.dev = {
-			.platform_data = NULL,
-		},
+	.name = "snd-soc-mop500",
+	.id = 0,
+	.dev = {
+		.platform_data = NULL,
+	},
 };
 
 /* Platform device for Ux500-PCM */
@@ -171,7 +171,7 @@ static struct msp_i2s_platform_data msp3_platform_data = {
 	.msp_i2s_dma_tx	= NULL,
 };
 
-int mop500_msp_init(struct device *parent)
+void mop500_msp_init(struct device *parent)
 {
 	pr_info("%s: Register platform-device 'snd-soc-mop500'.\n", __func__);
 	platform_device_register(&snd_soc_mop500);
@@ -185,6 +185,4 @@ int mop500_msp_init(struct device *parent)
 			   &msp2_platform_data);
 	db8500_add_msp_i2s(parent, 3, U8500_MSP3_BASE, IRQ_DB8500_MSP1,
 			   &msp3_platform_data);
-
-	return 0;
 }
diff --git a/arch/arm/mach-ux500/board-mop500-msp.h b/arch/arm/mach-ux500/board-mop500-msp.h
deleted file mode 100644
index 6fcfb5e..0000000
--- a/arch/arm/mach-ux500/board-mop500-msp.h
+++ /dev/null
@@ -1,14 +0,0 @@
-/*
- * Copyright (C) ST-Ericsson SA 2012
- *
- * Author: Ola Lilja <ola.o.lilja@stericsson.com>,
- *         for ST-Ericsson.
- *
- * License terms:
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as published
- * by the Free Software Foundation.
- */
-
-void mop500_msp_init(struct device *parent);
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 8890b19..a799477 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -54,7 +54,6 @@
 #include "devices-db8500.h"
 #include "board-mop500.h"
 #include "board-mop500-regulators.h"
-#include "board-mop500-msp.h"
 
 static struct gpio_led snowball_led_array[] = {
 	{
diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index eb421f9..bdae9b0 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -94,6 +94,7 @@ void __init mop500_stuib_init(void);
 void __init mop500_pinmaps_init(void);
 void __init snowball_pinmaps_init(void);
 void __init hrefv60_pinmaps_init(void);
+void mop500_msp_init(struct device *parent);
 
 int __init mop500_uib_init(void);
 void mop500_uib_i2c_add(int busnum, struct i2c_board_info *info,
-- 
1.7.9.5

