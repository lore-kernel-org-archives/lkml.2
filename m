Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab2GaNnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:43:42 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53416 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab2GaNjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:39:32 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 06/19] ARM: ux500: Clean-up MSP platform code
Date: Tue, 31 Jul 2012 14:39:00 +0100
Message-Id: <1343741953-17828-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343741953-17828-1-git-send-email-lee.jones@linaro.org>
References: <1343741953-17828-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains a couple of general MSP clean-ups pertaining to
layout changes and changing functions to be void instead of int instead
of regardlessly returning '0'.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-msp.c |   26 ++++++++++++--------------
 arch/arm/mach-ux500/board-mop500-msp.h |   14 --------------
 arch/arm/mach-ux500/board-mop500.c     |    1 -
 arch/arm/mach-ux500/board-mop500.h     |    3 +++
 4 files changed, 15 insertions(+), 29 deletions(-)
 delete mode 100644 arch/arm/mach-ux500/board-mop500-msp.h

diff --git a/arch/arm/mach-ux500/board-mop500-msp.c b/arch/arm/mach-ux500/board-mop500-msp.c
index af65fb0..573d912 100644
--- a/arch/arm/mach-ux500/board-mop500-msp.c
+++ b/arch/arm/mach-ux500/board-mop500-msp.c
@@ -143,21 +143,21 @@ static struct platform_device *db8500_add_msp_i2s(struct device *parent,
 }
 
 /* Platform device for ASoC U8500 machine */
-static struct platform_device snd_soc_u8500 = {
-		.name = "snd-soc-u8500",
-		.id = 0,
-		.dev = {
-			.platform_data = NULL,
-		},
+static struct platform_device snd_soc_mop500 = {
+	.name = "snd-soc-mop500",
+	.id = 0,
+	.dev = {
+		.platform_data = NULL,
+	},
 };
 
 /* Platform device for Ux500-PCM */
 static struct platform_device ux500_pcm = {
-		.name = "ux500-pcm",
-		.id = 0,
-		.dev = {
-			.platform_data = NULL,
-		},
+	.name = "ux500-pcm",
+	.id = 0,
+	.dev = {
+		.platform_data = NULL,
+	},
 };
 
 static struct msp_i2s_platform_data msp2_platform_data = {
@@ -172,7 +172,7 @@ static struct msp_i2s_platform_data msp3_platform_data = {
 	.msp_i2s_dma_tx	= NULL,
 };
 
-int mop500_msp_init(struct device *parent)
+void mop500_msp_init(struct device *parent)
 {
 	pr_info("%s: Register platform-device 'snd-soc-u8500'.\n", __func__);
 	platform_device_register(&snd_soc_mop500);
@@ -189,6 +189,4 @@ int mop500_msp_init(struct device *parent)
 
 	pr_info("%s: Register platform-device 'ux500-pcm'\n", __func__);
 	platform_device_register(&ux500_pcm);
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
index 87a5cd7..6f53a6f 100644
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
index d04a8e6..1d7316b 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -92,6 +92,9 @@ void __init mop500_stuib_init(void);
 void __init mop500_pinmaps_init(void);
 void __init snowball_pinmaps_init(void);
 void __init hrefv60_pinmaps_init(void);
+void mop500_msp_init(struct device *parent);
+/* Due for removal once the MSP driver has been fully DT:ed. */
+void mop500_of_msp_init(struct device *parent);
 
 int __init mop500_uib_init(void);
 void mop500_uib_i2c_add(int busnum, struct i2c_board_info *info,
-- 
1.7.9.5

