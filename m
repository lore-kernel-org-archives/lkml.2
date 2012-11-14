Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab2KNHUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:20:11 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:59382 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450Ab2KNHUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:20:08 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, wenyou.yang@atmel.com, JM.Lin@atmel.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 09/11] watchdog/at91sam9_wdt: add support to device tree
Date: Wed, 14 Nov 2012 15:16:07 +0800
Message-Id: <1352877369-19740-10-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352877369-19740-1-git-send-email-wenyou.yang@atmel.com>
References: <1352877369-19740-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 14 Nov 2012 07:19:42.0322 (UTC) FILETIME=[6A6EDD20:01CDC238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Cc: grant.likely@secretlab.ca
Cc: rob.herring@calxeda.com
Cc: devicetree-discuss@lists.ozlabs.org
---
 drivers/watchdog/at91sam9_wdt.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index e7ce9ea..cba5c5d 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -32,6 +32,7 @@
 #include <linux/jiffies.h>
 #include <linux/timer.h>
 #include <linux/bitops.h>
+#include <linux/of.h>
 
 #include "at91sam9_wdt.h"
 
@@ -251,12 +252,21 @@ static int __exit at91wdt_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id at91wdt_match[] = {
+	{ .compatible = "atmel,at91sam-wdt" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, at91wdt_match);
+#endif
+
 static struct platform_driver at91wdt_driver = {
 	.probe		= at91wdt_probe,
 	.remove		= __exit_p(at91wdt_remove),
 	.driver		= {
 		.name	= "at91_wdt",
 		.owner	= THIS_MODULE,
+		.of_match_table	= of_match_ptr(at91wdt_match),
 	},
 };
 
-- 
1.7.9.5

