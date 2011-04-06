Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab1DFJRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 05:17:12 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1753 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab1DFJRL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 05:17:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 06 Apr 2011 02:16:52 -0700
From: Wei Ni <wni@nvidia.com>
To: "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Wed, 6 Apr 2011 17:16:47 +0800
Subject: RE: [PATCH v9] mfd: tps6586x: add RTC driver for TI TPS6586x
Thread-Topic: [PATCH v9] mfd: tps6586x: add RTC driver for TI TPS6586x
Thread-Index: AcvtNB39IIBh9/dhQGOHgfiPDyC+wgHBy/Pw
Message-ID: <6B4D417B830BC44B8026029FD256F7F1C2CB3DD4A5@HKMAIL01.nvidia.com>
References: <1301308615-6507-1-git-send-email-wni@nvidia.com>
In-Reply-To: <1301308615-6507-1-git-send-email-wni@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could anyone review this issue?

Thanks
Wei.

-----Original Message-----
From: Wei Ni 
Sent: Monday, March 28, 2011 6:37 PM
To: rtc-linux@googlegroups.com; linux-kernel@vger.kernel.org; a.zummo@towertech.it
Cc: linux-tegra@vger.kernel.org; Wei Ni
Subject: [PATCH v9] mfd: tps6586x: add RTC driver for TI TPS6586x

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

