Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab2LCFny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 00:43:54 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:51604 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921Ab2LCFnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 00:43:53 -0500
From: Qing Xu <qingx@marvell.com>
To: a.zummo@towertech.it, qingx@marvell.com, zhouqiao@marvell.com,
        sameo@linux.intel.com, cxie4@marvell.com, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Subject: [PATCH 4/4] rtc: 88pm80x: update irq base
Date: Mon,  3 Dec 2012 13:43:47 +0800
Message-Id: <1354513427-21266-1-git-send-email-qingx@marvell.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 03 Dec 2012 05:43:43.0678 (UTC) FILETIME=[27DCC5E0:01CDD119]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing Xu <qingx@marvell.com>

irq base is stored in 88pm80x's drv data, we need to add irq
base to get the correct irq num

Signed-off-by: Qiao Zhou <zhouqiao@marvell.com>
Signed-off-by: Qing Xu <qingx@marvell.com>
---
 drivers/rtc/rtc-88pm80x.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-88pm80x.c b/drivers/rtc/rtc-88pm80x.c
index 6367984..7c3a264 100644
--- a/drivers/rtc/rtc-88pm80x.c
+++ b/drivers/rtc/rtc-88pm80x.c
@@ -256,7 +256,7 @@ static int __devinit pm80x_rtc_probe(struct platform_device *pdev)
 	struct pm80x_rtc_info *info;
 	struct rtc_time tm;
 	unsigned long ticks = 0;
-	int ret;
+	int irq, ret;
 
 	pdata = pdev->dev.platform_data;
 	if (pdata == NULL)
@@ -266,12 +266,13 @@ static int __devinit pm80x_rtc_probe(struct platform_device *pdev)
 	    devm_kzalloc(&pdev->dev, sizeof(struct pm80x_rtc_info), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
-	info->irq = platform_get_irq(pdev, 0);
-	if (info->irq < 0) {
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
 		dev_err(&pdev->dev, "No IRQ resource!\n");
 		ret = -EINVAL;
 		goto out;
 	}
+	info->irq = irq + chip->irq_base;
 
 	info->chip = chip;
 	info->map = chip->regmap;
-- 
1.7.0.4

