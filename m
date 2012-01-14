Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab2ANI4z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 03:56:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45314 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab2ANI4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 03:56:54 -0500
Message-ID: <1326531403.4865.0.camel@phoenix>
Subject: [PATCH] devfreq: exynos4_bus: Use dev_get_drvdata at appropriate
 places
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Sat, 14 Jan 2012 16:56:43 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/devfreq/exynos4_bus.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos4_bus.c
index cd563da..0b67537 100644
--- a/drivers/devfreq/exynos4_bus.c
+++ b/drivers/devfreq/exynos4_bus.c
@@ -622,9 +622,7 @@ static int exynos4_bus_setvolt(struct busfreq_data *data, struct opp *opp,
 static int exynos4_bus_target(struct device *dev, unsigned long *_freq)
 {
 	int err = 0;
-	struct platform_device *pdev = container_of(dev, struct platform_device,
-						    dev);
-	struct busfreq_data *data = platform_get_drvdata(pdev);
+	struct busfreq_data *data = dev_get_drvdata(dev);
 	struct opp *opp = devfreq_recommended_opp(dev, _freq);
 	unsigned long old_freq = opp_get_freq(data->curr_opp);
 	unsigned long freq = opp_get_freq(opp);
@@ -689,9 +687,7 @@ static int exynos4_get_busier_dmc(struct busfreq_data *data)
 static int exynos4_bus_get_dev_status(struct device *dev,
 				      struct devfreq_dev_status *stat)
 {
-	struct platform_device *pdev = container_of(dev, struct platform_device,
-						    dev);
-	struct busfreq_data *data = platform_get_drvdata(pdev);
+	struct busfreq_data *data = dev_get_drvdata(dev);
 	int busier_dmc;
 	int cycles_x2 = 2; /* 2 x cycles */
 	void __iomem *addr;
@@ -739,9 +735,7 @@ static int exynos4_bus_get_dev_status(struct device *dev,
 
 static void exynos4_bus_exit(struct device *dev)
 {
-	struct platform_device *pdev = container_of(dev, struct platform_device,
-						    dev);
-	struct busfreq_data *data = platform_get_drvdata(pdev);
+	struct busfreq_data *data = dev_get_drvdata(dev);
 
 	devfreq_unregister_opp_notifier(dev, data->devfreq);
 }
@@ -1087,9 +1081,7 @@ static __devexit int exynos4_busfreq_remove(struct platform_device *pdev)
 
 static int exynos4_busfreq_resume(struct device *dev)
 {
-	struct platform_device *pdev = container_of(dev, struct platform_device,
-						    dev);
-	struct busfreq_data *data = platform_get_drvdata(pdev);
+	struct busfreq_data *data = dev_get_drvdata(dev);
 
 	busfreq_mon_reset(data);
 	return 0;
-- 
1.7.5.4



