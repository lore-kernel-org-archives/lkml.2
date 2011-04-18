Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab1DROKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:10:22 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:58507 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab1DROJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:09:57 -0400
X-ASG-Debug-ID: 1303135796-082d70330001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        a.zummo@towertech.it, johnpol@2ka.mipt.ru, cbou@mail.ru,
        dwmw2@infradead.org, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
X-ASG-Orig-Subj: [PATCH 14/14] regulator: 88pm8607: avoid to use constraint name in driver
Subject: [PATCH 14/14] regulator: 88pm8607: avoid to use constraint name in driver
Date: Mon, 18 Apr 2011 22:04:11 +0800
X-ASG-Orig-Subj: [PATCH 14/14] regulator: 88pm8607: avoid to use constraint name in driver
Message-Id: <1303135451-26362-15-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <2011041801>
References: <2011041801>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1303135796
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid to use constraint name in driver. So use driver_data instead to
store regulator name in platform driver.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/88pm8607.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index 784ea77..63fc34e 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -402,12 +402,13 @@ static int __devinit pm8607_regulator_probe(struct platform_device *pdev)
 	int i;
 
 	pdata = pdev->dev.platform_data;
-	if (pdata == NULL)
+	if ((pdata == NULL) || (pdata->driver_data == NULL))
 		return -EINVAL;
 
 	for (i = 0; i < ARRAY_SIZE(pm8607_regulator_info); i++) {
 		info = &pm8607_regulator_info[i];
-		if (!strcmp(info->desc.name, pdata->constraints.name))
+		/* pdata->driver_data stores the name of regulator */
+		if (!strcmp(info->desc.name, pdata->driver_data))
 			break;
 	}
 	if (i > ARRAY_SIZE(pm8607_regulator_info)) {
@@ -424,6 +425,7 @@ static int __devinit pm8607_regulator_probe(struct platform_device *pdev)
 		if (info->chip->buck3_double)
 			info->slope_double = 1;
 
+	/* replace driver_data with info */
 	info->regulator = regulator_register(&info->desc, &pdev->dev,
 					     pdata, info);
 	if (IS_ERR(info->regulator)) {
-- 
1.5.6.5

