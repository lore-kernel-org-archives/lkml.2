Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202Ab2LCFmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 00:42:12 -0500
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:37140 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750882Ab2LCFmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 00:42:10 -0500
From: Qing Xu <qingx@marvell.com>
To: dmitry.torokhov@gmail.com, qingx@marvell.com, zhouqiao@marvell.com,
        sameo@linux.intel.com, cxie4@marvell.com, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] onkey: 88pm80x: update irq base
Date: Mon,  3 Dec 2012 13:42:06 +0800
Message-Id: <1354513326-21026-1-git-send-email-qingx@marvell.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 03 Dec 2012 05:42:06.0287 (UTC) FILETIME=[EDD015F0:01CDD118]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing Xu <qingx@marvell.com>

irq base is stored in 88pm80x's drv data, we need to add irq
base to get the correct irq num

Signed-off-by: Qiao Zhou <zhouqiao@marvell.com>
Signed-off-by: Qing Xu <qingx@marvell.com>
---
 drivers/input/misc/88pm80x_onkey.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/input/misc/88pm80x_onkey.c b/drivers/input/misc/88pm80x_onkey.c
index 7f26e7b..cc352f9 100644
--- a/drivers/input/misc/88pm80x_onkey.c
+++ b/drivers/input/misc/88pm80x_onkey.c
@@ -67,7 +67,7 @@ static int __devinit pm80x_onkey_probe(struct platform_device *pdev)
 
 	struct pm80x_chip *chip = dev_get_drvdata(pdev->dev.parent);
 	struct pm80x_onkey_info *info;
-	int err;
+	int irq, err;
 
 	info = kzalloc(sizeof(struct pm80x_onkey_info), GFP_KERNEL);
 	if (!info)
@@ -75,13 +75,14 @@ static int __devinit pm80x_onkey_probe(struct platform_device *pdev)
 
 	info->pm80x = chip;
 
-	info->irq = platform_get_irq(pdev, 0);
-	if (info->irq < 0) {
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
 		dev_err(&pdev->dev, "No IRQ resource!\n");
 		err = -EINVAL;
 		goto out;
 	}
 
+	info->irq = irq + chip->irq_base;
 	info->map = info->pm80x->regmap;
 	if (!info->map) {
 		dev_err(&pdev->dev, "no regmap!\n");
-- 
1.7.0.4

