Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab2GRQnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 12:43:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43049 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab2GRQnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 12:43:39 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        David Dajun Chen <dchen@diasemi.com>
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 3/3] rtc/rtc-da9052: remove unneed devm_kfree call
Date: Wed, 18 Jul 2012 22:13:32 +0530
Message-Id: <1342629812-13003-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

freeing will trigger when driver unloads, so using devm_kfree is
not needed.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/rtc/rtc-da9052.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-da9052.c b/drivers/rtc/rtc-da9052.c
index da6ab52..7807025 100644
--- a/drivers/rtc/rtc-da9052.c
+++ b/drivers/rtc/rtc-da9052.c
@@ -245,7 +245,7 @@ static int __devinit da9052_rtc_probe(struct platform_device *pdev)
 				   "ALM", rtc);
 	if (ret != 0) {
 		rtc_err(rtc->da9052, "irq registration failed: %d\n", ret);
-		goto err_mem;
+		return ret;
 	}
 
 	rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
@@ -259,8 +259,6 @@ static int __devinit da9052_rtc_probe(struct platform_device *pdev)
 
 err_free_irq:
 	free_irq(rtc->irq, rtc);
-err_mem:
-	devm_kfree(&pdev->dev, rtc);
 	return ret;
 }
 
@@ -271,7 +269,6 @@ static int __devexit da9052_rtc_remove(struct platform_device *pdev)
 	rtc_device_unregister(rtc->rtc);
 	free_irq(rtc->irq, rtc);
 	platform_set_drvdata(pdev, NULL);
-	devm_kfree(&pdev->dev, rtc);
 
 	return 0;
 }
-- 
1.7.0.4

