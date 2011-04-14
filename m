Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467Ab1DNCVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 22:21:18 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:45316 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758322Ab1DNCVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 22:21:17 -0400
X-ASG-Debug-ID: 1302747676-082e4d270001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
X-ASG-Orig-Subj: [PATCH 11/13] power_supply: max8925: use platform_data from cell
Subject: [PATCH 11/13] power_supply: max8925: use platform_data from cell
Date: Thu, 14 Apr 2011 10:16:20 +0800
X-ASG-Orig-Subj: [PATCH 11/13] power_supply: max8925: use platform_data from cell
Message-Id: <1302747380-22836-1-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1302706264-25815-12-git-send-email-haojian.zhuang@marvell.com>
References: <1302706264-25815-12-git-send-email-haojian.zhuang@marvell.com>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1302747676
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid to get platform_data from parent device. Get it from mfd cell
device instead.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/power/max8925_power.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
index 8e5aec2..a70e16d 100644
--- a/drivers/power/max8925_power.c
+++ b/drivers/power/max8925_power.c
@@ -425,16 +425,11 @@ static __devexit int max8925_deinit_charger(struct max8925_power_info *info)
 static __devinit int max8925_power_probe(struct platform_device *pdev)
 {
 	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
-	struct max8925_platform_data *max8925_pdata;
 	struct max8925_power_pdata *pdata = NULL;
 	struct max8925_power_info *info;
 	int ret;
 
-	if (pdev->dev.parent->platform_data) {
-		max8925_pdata = pdev->dev.parent->platform_data;
-		pdata = max8925_pdata->power;
-	}
-
+	pdata = pdev->dev.platform_data;
 	if (!pdata) {
 		dev_err(&pdev->dev, "platform data isn't assigned to "
 			"power supply\n");
@@ -447,6 +442,7 @@ static __devinit int max8925_power_probe(struct platform_device *pdev)
 	info->chip = chip;
 	info->gpm = chip->i2c;
 	info->adc = chip->adc;
+	platform_set_drvdata(pdev, info);
 
 	info->ac.name = "max8925-ac";
 	info->ac.type = POWER_SUPPLY_TYPE_MAINS;
@@ -482,8 +478,6 @@ static __devinit int max8925_power_probe(struct platform_device *pdev)
 	info->topoff_threshold = pdata->topoff_threshold;
 	info->fast_charge = pdata->fast_charge;
 	info->set_charger = pdata->set_charger;
-	dev_set_drvdata(&pdev->dev, info);
-	platform_set_drvdata(pdev, info);
 
 	max8925_init_charger(chip, info);
 	return 0;
-- 
1.5.6.5

