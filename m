Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab1LUAUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 19:20:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50457 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753340Ab1LUAUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 19:20:36 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant@secretlab.ca>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/4] gpio: Explicitly index samsung_gpio_cfgs
Date: Wed, 21 Dec 2011 00:20:14 +0000
Message-Id: <1324426817-2196-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it easier to follow the by number references into samsung_gpio_cfgs
by putting the indexes into the code initialising the array, improving
readability a bit. Ideally we wouldn't be using magic array indexes at all
but this is easier than coming up with a better way.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
---
 drivers/gpio/gpio-samsung.c |   29 +++++++++++++++++++----------
 1 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index 6b4d23f..f1c1ecd 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -470,33 +470,42 @@ static struct samsung_gpio_cfg s5p64x0_gpio_cfg_rbank = {
 #endif
 
 static struct samsung_gpio_cfg samsung_gpio_cfgs[] = {
-	{
+	[0] = {
 		.cfg_eint	= 0x0,
-	}, {
+	},
+	[1] = {
 		.cfg_eint	= 0x3,
-	}, {
+	},
+	[2] = {
 		.cfg_eint	= 0x7,
-	}, {
+	},
+	[3] = {
 		.cfg_eint	= 0xF,
-	}, {
+	},
+	[4] = {
 		.cfg_eint	= 0x0,
 		.set_config	= samsung_gpio_setcfg_2bit,
 		.get_config	= samsung_gpio_getcfg_2bit,
-	}, {
+	},
+	[5] = {
 		.cfg_eint	= 0x2,
 		.set_config	= samsung_gpio_setcfg_2bit,
 		.get_config	= samsung_gpio_getcfg_2bit,
-	}, {
+	},
+	[6] = {
 		.cfg_eint	= 0x3,
 		.set_config	= samsung_gpio_setcfg_2bit,
 		.get_config	= samsung_gpio_getcfg_2bit,
-	}, {
+	},
+	[7] = {
 		.set_config	= samsung_gpio_setcfg_2bit,
 		.get_config	= samsung_gpio_getcfg_2bit,
-	}, {
+	},
+	[8] = {
 		.set_pull	= exynos4_gpio_setpull,
 		.get_pull	= exynos4_gpio_getpull,
-	}, {
+	},
+	[9] = {
 		.cfg_eint	= 0x3,
 		.set_pull	= exynos4_gpio_setpull,
 		.get_pull	= exynos4_gpio_getpull,
-- 
1.7.7.3

