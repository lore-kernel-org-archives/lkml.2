Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab2KLSrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 13:47:19 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:46256 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab2KLSrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 13:47:17 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [RESEND PATCH v3 5/6] watchdog: omap_wdt: delete redundant platform_set_drvdata() calls
Date: Mon, 12 Nov 2012 20:47:04 +0200
Message-Id: <1352746025-1669-6-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1352746025-1669-1-git-send-email-aaro.koskinen@iki.fi>
References: <1352746025-1669-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not needed to manually reset the driver data.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Wim Van Sebroeck <wim@iguana.be>
---
 drivers/watchdog/omap_wdt.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 7e8d3e0..af1e72e 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -280,7 +280,6 @@ static int __devinit omap_wdt_probe(struct platform_device *pdev)
 
 err_misc:
 	pm_runtime_disable(wdev->dev);
-	platform_set_drvdata(pdev, NULL);
 
 	return ret;
 }
@@ -306,7 +305,6 @@ static int __devexit omap_wdt_remove(struct platform_device *pdev)
 
 	pm_runtime_disable(wdev->dev);
 	watchdog_unregister_device(wdog);
-	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
-- 
1.7.2.5

