Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab3AECo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 21:44:56 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:43588 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646Ab3AECox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 21:44:53 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com, JM.Lin@atmel.com,
        wenyou.yang@atmel.com, wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [v3 PATCH 5/9] watchdog/at91sam9_wdt: Add nowayout helpers to Watchdog Timer Driver Kernel API
Date: Sat,  5 Jan 2013 10:38:45 +0800
Message-Id: <1357353529-20901-6-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357353529-20901-1-git-send-email-wenyou.yang@atmel.com>
References: <1357353529-20901-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 05 Jan 2013 02:44:33.0816 (UTC) FILETIME=[9813C180:01CDEAEE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Cc: wim@iguana.be
Cc: linux-watchdog@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/watchdog/at91sam9_wdt.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index a3d1a09..53ede84 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -235,6 +235,8 @@ static int __init at91wdt_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	watchdog_set_nowayout(&at91wdt_wdd, nowayout);
+
 	watchdog_init_timeout(&at91wdt_wdd, heartbeat, pdev->dev.of_node);
 
 	ret = at91wdt_enable(&at91wdt_wdd, ms_to_ticks(WDT_HW_TIMEOUT * 1000));
-- 
1.7.9.5

