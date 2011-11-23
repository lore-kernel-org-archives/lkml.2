Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab1KWPWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 10:22:44 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53934 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756248Ab1KWPWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 10:22:43 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] watchdog: Convert Wolfson drivers to module_platform_driver
Date: Wed, 23 Nov 2011 15:22:36 +0000
Message-Id: <1322061756-29942-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factors out some boilerplate code.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/watchdog/wm831x_wdt.c |   12 +-----------
 drivers/watchdog/wm8350_wdt.c |   12 +-----------
 2 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/watchdog/wm831x_wdt.c b/drivers/watchdog/wm831x_wdt.c
index e789a47..beb3ad2 100644
--- a/drivers/watchdog/wm831x_wdt.c
+++ b/drivers/watchdog/wm831x_wdt.c
@@ -320,17 +320,7 @@ static struct platform_driver wm831x_wdt_driver = {
 	},
 };
 
-static int __init wm831x_wdt_init(void)
-{
-	return platform_driver_register(&wm831x_wdt_driver);
-}
-module_init(wm831x_wdt_init);
-
-static void __exit wm831x_wdt_exit(void)
-{
-	platform_driver_unregister(&wm831x_wdt_driver);
-}
-module_exit(wm831x_wdt_exit);
+module_platform_driver(wm831x_wdt_driver);
 
 MODULE_AUTHOR("Mark Brown");
 MODULE_DESCRIPTION("WM831x Watchdog");
diff --git a/drivers/watchdog/wm8350_wdt.c b/drivers/watchdog/wm8350_wdt.c
index b68d928..909c786 100644
--- a/drivers/watchdog/wm8350_wdt.c
+++ b/drivers/watchdog/wm8350_wdt.c
@@ -311,17 +311,7 @@ static struct platform_driver wm8350_wdt_driver = {
 	},
 };
 
-static int __init wm8350_wdt_init(void)
-{
-	return platform_driver_register(&wm8350_wdt_driver);
-}
-module_init(wm8350_wdt_init);
-
-static void __exit wm8350_wdt_exit(void)
-{
-	platform_driver_unregister(&wm8350_wdt_driver);
-}
-module_exit(wm8350_wdt_exit);
+module_platform_driver(wm8350_wdt_driver);
 
 MODULE_AUTHOR("Mark Brown");
 MODULE_DESCRIPTION("WM8350 Watchdog");
-- 
1.7.7.3

