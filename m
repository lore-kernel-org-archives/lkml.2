Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab1C1KhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 06:37:19 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19585 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab1C1KhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 06:37:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 28 Mar 2011 03:37:17 -0700
From: wni@nvidia.com
To: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        a.zummo@towertech.it
Cc: linux-tegra@vger.kernel.org, Wei Ni <wni@nvidia.com>
Subject: [PATCH v9] mfd: tps6586x: add RTC driver for TI TPS6586x
Date: Mon, 28 Mar 2011 18:36:54 +0800
Message-Id: <1301308615-6507-1-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Ni <wni@nvidia.com>

this driver supports setting of alarms, and
reading/setting of time

Signed-off-by: Wei Ni <wni@nvidia.com>
---
v9: check the enable_irq_wake/disable_irq_wake return value.
fix these two function's fisrt paremeter, it should use "&pdev->dev"

 drivers/rtc/rtc-tps6586x.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-tps6586x.c b/drivers/rtc/rtc-tps6586x.c
index b891899..a3944a5 100644
--- a/drivers/rtc/rtc-tps6586x.c
+++ b/drivers/rtc/rtc-tps6586x.c
@@ -335,19 +335,29 @@ static int __devexit tps6586x_rtc_remove(struct platform_device *pdev)
 static int tps6586x_rtc_suspend(struct platform_device *pdev,
 				pm_message_t state)
 {
+	int ret;
 	struct tps6586x_rtc *rtc = dev_get_drvdata(&pdev->dev);
 
-	if (device_may_wakeup(pdev))
-		enable_irq_wake(rtc->irq);
+	if (device_may_wakeup(&pdev->dev))
+		ret = enable_irq_wake(rtc->irq);
+
+	if (ret)
+		dev_warn(&pdev->dev, "enable irq wakeup failed.\n");
+
 	return 0;
 }
 
 static int tps6586x_rtc_resume(struct platform_device *pdev)
 {
+	int ret;
 	struct tps6586x_rtc *rtc = dev_get_drvdata(&pdev->dev);
 
-	if (device_may_wakeup(pdev))
-		disable_irq_wake(rtc->irq);
+	if (device_may_wakeup(&pdev->dev))
+		ret = disable_irq_wake(rtc->irq);
+
+	if (ret)
+		dev_warn(&pdev->dev, "disable irq wakeup failed.\n");
+
 	return 0;
 }
 
-- 
1.7.0

