Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab3AILQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 06:16:09 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:48197 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab3AILPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 06:15:38 -0500
From: Fabio Porcedda <fabio.porcedda@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org, linux-usb@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/3] watchdog: convert drivers/watchdog/* to use module_platform_driver_probe
Date: Wed,  9 Jan 2013 12:15:27 +0100
Message-Id: <1357730128-23018-3-git-send-email-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <1357730128-23018-1-git-send-email-fabio.porcedda@gmail.com>
References: <1357730128-23018-1-git-send-email-fabio.porcedda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the code a bit smaller by getting rid of
some boilerplate code.

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: linux-watchdog@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/watchdog/at32ap700x_wdt.c | 12 +-----------
 drivers/watchdog/at91sam9_wdt.c   | 13 +------------
 drivers/watchdog/coh901327_wdt.c  | 12 +-----------
 drivers/watchdog/imx2_wdt.c       | 12 +-----------
 drivers/watchdog/txx9wdt.c        | 13 +------------
 5 files changed, 5 insertions(+), 57 deletions(-)

diff --git a/drivers/watchdog/at32ap700x_wdt.c b/drivers/watchdog/at32ap700x_wdt.c
index 2896430..7a715e3 100644
--- a/drivers/watchdog/at32ap700x_wdt.c
+++ b/drivers/watchdog/at32ap700x_wdt.c
@@ -436,17 +436,7 @@ static struct platform_driver at32_wdt_driver = {
 	.shutdown	= at32_wdt_shutdown,
 };
 
-static int __init at32_wdt_init(void)
-{
-	return platform_driver_probe(&at32_wdt_driver, at32_wdt_probe);
-}
-module_init(at32_wdt_init);
-
-static void __exit at32_wdt_exit(void)
-{
-	platform_driver_unregister(&at32_wdt_driver);
-}
-module_exit(at32_wdt_exit);
+module_platform_driver_probe(at32_wdt_driver, at32_wdt_probe);
 
 MODULE_AUTHOR("Hans-Christian Egtvedt <egtvedt@samfundet.no>");
 MODULE_DESCRIPTION("Watchdog driver for Atmel AT32AP700X");
diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index d864dc4..60bc700 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -331,18 +331,7 @@ static struct platform_driver at91wdt_driver = {
 	},
 };
 
-static int __init at91sam_wdt_init(void)
-{
-	return platform_driver_probe(&at91wdt_driver, at91wdt_probe);
-}
-
-static void __exit at91sam_wdt_exit(void)
-{
-	platform_driver_unregister(&at91wdt_driver);
-}
-
-module_init(at91sam_wdt_init);
-module_exit(at91sam_wdt_exit);
+module_platform_driver_probe(at91wdt_driver, at91wdt_probe);
 
 MODULE_AUTHOR("Renaud CERRATO <r.cerrato@til-technologies.fr>");
 MODULE_DESCRIPTION("Watchdog driver for Atmel AT91SAM9x processors");
diff --git a/drivers/watchdog/coh901327_wdt.c b/drivers/watchdog/coh901327_wdt.c
index cb5da5c..b9b8a8b 100644
--- a/drivers/watchdog/coh901327_wdt.c
+++ b/drivers/watchdog/coh901327_wdt.c
@@ -451,17 +451,7 @@ static struct platform_driver coh901327_driver = {
 	.resume		= coh901327_resume,
 };
 
-static int __init coh901327_init(void)
-{
-	return platform_driver_probe(&coh901327_driver, coh901327_probe);
-}
-module_init(coh901327_init);
-
-static void __exit coh901327_exit(void)
-{
-	platform_driver_unregister(&coh901327_driver);
-}
-module_exit(coh901327_exit);
+module_platform_driver_probe(coh901327_driver, coh901327_probe);
 
 MODULE_AUTHOR("Linus Walleij <linus.walleij@stericsson.com>");
 MODULE_DESCRIPTION("COH 901 327 Watchdog");
diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index 9a45d029..bc17dec 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -342,17 +342,7 @@ static struct platform_driver imx2_wdt_driver = {
 	},
 };
 
-static int __init imx2_wdt_init(void)
-{
-	return platform_driver_probe(&imx2_wdt_driver, imx2_wdt_probe);
-}
-module_init(imx2_wdt_init);
-
-static void __exit imx2_wdt_exit(void)
-{
-	platform_driver_unregister(&imx2_wdt_driver);
-}
-module_exit(imx2_wdt_exit);
+module_platform_driver_probe(imx2_wdt_driver, imx2_wdt_probe);
 
 MODULE_AUTHOR("Wolfram Sang");
 MODULE_DESCRIPTION("Watchdog driver for IMX2 and later");
diff --git a/drivers/watchdog/txx9wdt.c b/drivers/watchdog/txx9wdt.c
index 98e1637..b04c92b 100644
--- a/drivers/watchdog/txx9wdt.c
+++ b/drivers/watchdog/txx9wdt.c
@@ -172,18 +172,7 @@ static struct platform_driver txx9wdt_driver = {
 	},
 };
 
-static int __init watchdog_init(void)
-{
-	return platform_driver_probe(&txx9wdt_driver, txx9wdt_probe);
-}
-
-static void __exit watchdog_exit(void)
-{
-	platform_driver_unregister(&txx9wdt_driver);
-}
-
-module_init(watchdog_init);
-module_exit(watchdog_exit);
+module_platform_driver_probe(txx9wdt_driver, txx9wdt_probe);
 
 MODULE_DESCRIPTION("TXx9 Watchdog Driver");
 MODULE_LICENSE("GPL");
-- 
1.8.0.3

