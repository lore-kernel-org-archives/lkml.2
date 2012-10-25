Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946270Ab2JYPT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 11:19:56 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:57900 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946216Ab2JYPTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 11:19:36 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [RESEND PATCH v3 5/6] watchdog: omap_wdt: delete redundant platform_set_drvdata() calls
Date: Thu, 25 Oct 2012 18:19:11 +0300
Message-Id: <1351178352-3989-6-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1351178352-3989-1-git-send-email-aaro.koskinen@iki.fi>
References: <1351178352-3989-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not needed to manually reset the driver data.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
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

