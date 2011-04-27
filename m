Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729Ab1D0SpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 14:45:17 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43822 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754Ab1D0SpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 14:45:15 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Zhangfei Gao <zhangfei.gao@marvell.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH] rtc: max8925: Set dev_set_drvdata before rtc_device_register
Date: Wed, 27 Apr 2011 11:44:29 -0700
Message-Id: <1303929869-25249-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhangfei Gao <zhangfei.gao@marvell.com>

	We now call rtc_read_alarm from rtc_device_register, so it
is important that the rtc device is fully initialized prior to
reigstration.

Because of this, With rtc-max8925, we see NULL pointer errors,
so call dev_set_drvdata before rtc_device_register

Thomas: This should go in for 2.6.39. 

CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Zhangfei Gao <zhangfei.gao@marvell.com>
[Reworded commit message -jstultz]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/rtc-max8925.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-max8925.c b/drivers/rtc/rtc-max8925.c
index 174036d..20494b5 100644
--- a/drivers/rtc/rtc-max8925.c
+++ b/drivers/rtc/rtc-max8925.c
@@ -257,6 +257,8 @@ static int __devinit max8925_rtc_probe(struct platform_device *pdev)
 		goto out_irq;
 	}
 
+	dev_set_drvdata(&pdev->dev, info);
+
 	info->rtc_dev = rtc_device_register("max8925-rtc", &pdev->dev,
 					&max8925_rtc_ops, THIS_MODULE);
 	ret = PTR_ERR(info->rtc_dev);
@@ -265,7 +267,6 @@ static int __devinit max8925_rtc_probe(struct platform_device *pdev)
 		goto out_rtc;
 	}
 
-	dev_set_drvdata(&pdev->dev, info);
 	platform_set_drvdata(pdev, info);
 
 	return 0;
-- 
1.7.3.2.146.gca209

