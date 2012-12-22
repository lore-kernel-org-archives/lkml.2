Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab2LVB7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 20:59:50 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:46900 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab2LVB6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 20:58:43 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 23/25] video/exynos: don't use [delayed_]work_pending()
Date: Fri, 21 Dec 2012 17:57:13 -0800
Message-Id: <1356141435-17340-24-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356141435-17340-1-git-send-email-tj@kernel.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to test whether a (delayed) work item in pending
before queueing, flushing or cancelling it.  Most uses are unnecessary
and quite a few of them are buggy.

Remove unnecessary pending tests from exynos_dp_core.  Only compile
tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---
Please let me know how this patch should be routed.  I can take it
through the workqueue tree if necessary.

Thanks.

 drivers/video/exynos/exynos_dp_core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/video/exynos/exynos_dp_core.c b/drivers/video/exynos/exynos_dp_core.c
index 28fd686..3002a6a 100644
--- a/drivers/video/exynos/exynos_dp_core.c
+++ b/drivers/video/exynos/exynos_dp_core.c
@@ -1121,8 +1121,7 @@ static int __devexit exynos_dp_remove(struct platform_device *pdev)
 
 	disable_irq(dp->irq);
 
-	if (work_pending(&dp->hotplug_work))
-		flush_work(&dp->hotplug_work);
+	flush_work(&dp->hotplug_work);
 
 	if (pdev->dev.of_node) {
 		if (dp->phy_addr)
@@ -1144,8 +1143,7 @@ static int exynos_dp_suspend(struct device *dev)
 	struct exynos_dp_platdata *pdata = dev->platform_data;
 	struct exynos_dp_device *dp = dev_get_drvdata(dev);
 
-	if (work_pending(&dp->hotplug_work))
-		flush_work(&dp->hotplug_work);
+	flush_work(&dp->hotplug_work);
 
 	if (dev->of_node) {
 		if (dp->phy_addr)
-- 
1.8.0.2

