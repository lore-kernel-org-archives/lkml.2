Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab2LXJwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 04:52:19 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5537 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab2LXJwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 04:52:09 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 24 Dec 2012 01:51:45 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <a.zummo@towertech.it>
CC: <akpm@linuxfoundation.org>, <broonie@opensource.wolfsonmicro.com>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 3/4] rtc: tps65910: use sleep_pm_ops macro for initialising suspend/resume callbacks
Date: Mon, 24 Dec 2012 15:21:26 +0530
Message-ID: <1356342687-3432-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1356342687-3432-1-git-send-email-ldewangan@nvidia.com>
References: <1356342687-3432-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use SET_SYSTEM_SLEEP_PM_OPS for setting suspend/resume callbacks for
dev_pm_ops.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/rtc/rtc-tps65910.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/rtc/rtc-tps65910.c b/drivers/rtc/rtc-tps65910.c
index 728bb8b..ff98e18 100644
--- a/drivers/rtc/rtc-tps65910.c
+++ b/drivers/rtc/rtc-tps65910.c
@@ -22,6 +22,7 @@
 #include <linux/rtc.h>
 #include <linux/bcd.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/interrupt.h>
 #include <linux/mfd/tps65910.h>
 
@@ -304,7 +305,6 @@ static int __devexit tps65910_rtc_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM_SLEEP
-
 static int tps65910_rtc_suspend(struct device *dev)
 {
 	struct tps65910_rtc *tps_rtc = dev_get_drvdata(dev);
@@ -322,24 +322,19 @@ static int tps65910_rtc_resume(struct device *dev)
 		disable_irq_wake(tps_rtc->irq);
 	return 0;
 }
+#endif
 
 static const struct dev_pm_ops tps65910_rtc_pm_ops = {
-	.suspend	= tps65910_rtc_suspend,
-	.resume		= tps65910_rtc_resume,
+	SET_SYSTEM_SLEEP_PM_OPS(tps65910_rtc_suspend, tps65910_rtc_resume)
 };
 
-#define DEV_PM_OPS     (&tps65910_rtc_pm_ops)
-#else
-#define DEV_PM_OPS     NULL
-#endif
-
 static struct platform_driver tps65910_rtc_driver = {
 	.probe		= tps65910_rtc_probe,
 	.remove		= __devexit_p(tps65910_rtc_remove),
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= "tps65910-rtc",
-		.pm	= DEV_PM_OPS,
+		.pm	= &tps65910_rtc_pm_ops,
 	},
 };
 
-- 
1.7.1.1

