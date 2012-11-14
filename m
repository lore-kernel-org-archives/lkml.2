Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab2KNHTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:19:49 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:34153 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323Ab2KNHTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:19:46 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, wenyou.yang@atmel.com, JM.Lin@atmel.com
Subject: [PATCH 08/11] watchdog/at91sam9_wdt: use module_platform_driver()
Date: Wed, 14 Nov 2012 15:16:06 +0800
Message-Id: <1352877369-19740-9-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352877369-19740-1-git-send-email-wenyou.yang@atmel.com>
References: <1352877369-19740-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 14 Nov 2012 07:19:39.0134 (UTC) FILETIME=[688869E0:01CDC238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using module_platform_driver() replaces module_init() and module_exit()
and makes the code simpler.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 drivers/watchdog/at91sam9_wdt.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index 187e33f..e7ce9ea 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -252,6 +252,7 @@ static int __exit at91wdt_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver at91wdt_driver = {
+	.probe		= at91wdt_probe,
 	.remove		= __exit_p(at91wdt_remove),
 	.driver		= {
 		.name	= "at91_wdt",
@@ -259,18 +260,7 @@ static struct platform_driver at91wdt_driver = {
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
+module_platform_driver(at91wdt_driver);
 
 MODULE_AUTHOR("Renaud CERRATO <r.cerrato@til-technologies.fr>");
 MODULE_DESCRIPTION("Watchdog driver for Atmel AT91SAM9x processors");
-- 
1.7.9.5

