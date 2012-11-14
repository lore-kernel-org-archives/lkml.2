Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab2KNHUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:20:06 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:18838 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450Ab2KNHUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:20:01 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, wenyou.yang@atmel.com, JM.Lin@atmel.com
Subject: [PATCH 10/11] watchdog/at91sam9_wdt: using dev_info replaces pr_info, dev_crit repalces pr_crit
Date: Wed, 14 Nov 2012 15:16:08 +0800
Message-Id: <1352877369-19740-11-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352877369-19740-1-git-send-email-wenyou.yang@atmel.com>
References: <1352877369-19740-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 14 Nov 2012 07:19:45.0931 (UTC) FILETIME=[6C958DB0:01CDC238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 drivers/watchdog/at91sam9_wdt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index cba5c5d..bd74f40 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -106,7 +106,7 @@ static void at91wdt_timer_tick(unsigned long data)
 		if (!watchdog_is_open(wddev))
 			driver_data->next_heartbeat = jiffies + heartbeat * HZ;
 	} else
-		pr_crit("I will reset your machine !\n");
+		dev_crit(wddev->dev, "I will reset your machine !\n");
 }
 
 static int at91wdt_enable(struct watchdog_device *wddev, unsigned int timeout)
@@ -239,7 +239,7 @@ static int __init at91wdt_probe(struct platform_device *pdev)
 					(unsigned long)&at91_wddev);
 	mod_timer(&driver_data->timer, jiffies + WDT_TIMEOUT);
 
-	pr_info("enabled (heartbeat=%d sec, nowayout=%d)\n",
+	dev_info(&pdev->dev, "enabled (heartbeat=%d sec, nowayout=%d)\n",
 		heartbeat, nowayout);
 
 	return 0;
-- 
1.7.9.5

