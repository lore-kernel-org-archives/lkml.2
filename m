Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab2GFMna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 08:43:30 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47505 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab2GFMn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 08:43:28 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/1] mfd: ab8500: Clean-up the last two ab8500 related DT match tables
Date: Fri,  6 Jul 2012 13:43:18 +0100
Message-Id: <1341578598-9307-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A patch was recently submitted to stop all ab8500 devices from
being registered through Device Tree. Instead, only the db8500
will be DT:ed and the rest will continue to be registered via
the MFD API, as they always were.

Two patches have recently been applied which enable Device Tree
probing; one for rtc-ab8500 and the other for ponkey-ab8500.
These two need to be removed to prevent double-probing these
devices with Device Tree is enabled.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/input/misc/ab8500-ponkey.c |    8 --------
 drivers/rtc/rtc-ab8500.c           |    6 ------
 2 files changed, 14 deletions(-)

diff --git a/drivers/input/misc/ab8500-ponkey.c b/drivers/input/misc/ab8500-ponkey.c
index 84ec691..5ceb23e 100644
--- a/drivers/input/misc/ab8500-ponkey.c
+++ b/drivers/input/misc/ab8500-ponkey.c
@@ -132,18 +132,10 @@ static int __devexit ab8500_ponkey_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_OF
-static const struct of_device_id ab8500_ponkey_match[] = {
-	{ .compatible = "stericsson,ab8500-ponkey", },
-	{}
-};
-#endif
-
 static struct platform_driver ab8500_ponkey_driver = {
 	.driver		= {
 		.name	= "ab8500-poweron-key",
 		.owner	= THIS_MODULE,
-		.of_match_table = of_match_ptr(ab8500_ponkey_match),
 	},
 	.probe		= ab8500_ponkey_probe,
 	.remove		= __devexit_p(ab8500_ponkey_remove),
diff --git a/drivers/rtc/rtc-ab8500.c b/drivers/rtc/rtc-ab8500.c
index bf3c2f6..2e5970f 100644
--- a/drivers/rtc/rtc-ab8500.c
+++ b/drivers/rtc/rtc-ab8500.c
@@ -462,16 +462,10 @@ static int __devexit ab8500_rtc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct of_device_id ab8500_rtc_match[] = {
-	{ .compatible = "stericsson,ab8500-rtc", },
-	{}
-};
-
 static struct platform_driver ab8500_rtc_driver = {
 	.driver = {
 		.name = "ab8500-rtc",
 		.owner = THIS_MODULE,
-		.of_match_table = ab8500_rtc_match,
 	},
 	.probe	= ab8500_rtc_probe,
 	.remove = __devexit_p(ab8500_rtc_remove),
-- 
1.7.9.5

