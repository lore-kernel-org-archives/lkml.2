Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab2IYQNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:13:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756968Ab2IYQNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:12 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 04/57] power: ab8500: bm: movimg back to ab8500 platform data managment
Date: Tue, 25 Sep 2012 10:12:01 -0600
Message-Id: <1348589574-25655-5-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Langlais <philippe.langlais@linaro.org>

Signed-off-by: Philippe Langlais <philippe.langlais@linaro.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/power/ab8500_btemp.c      |    8 ++------
 drivers/power/ab8500_charger.c    |    9 +++------
 drivers/power/ab8500_fg.c         |    8 ++------
 drivers/power/abx500_chargalg.c   |    7 ++++---
 include/linux/mfd/abx500/ab8500.h |    7 ++++++-
 5 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index 94a3ee8..41a8ce4 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -973,14 +973,9 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
 {
 	int irq, i, ret = 0;
 	u8 val;
-	struct abx500_bm_plat_data *plat_data = pdev->dev.platform_data;
+	struct ab8500_platform_data *plat_data;
 	struct ab8500_btemp *di;
 
-	if (!plat_data) {
-		dev_err(&pdev->dev, "No platform data\n");
-		return -EINVAL;
-	}
-
 	di = kzalloc(sizeof(*di), GFP_KERNEL);
 	if (!di)
 		return -ENOMEM;
@@ -993,6 +988,7 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
 	di->initialized = false;
 
 	/* get btemp specific platform data */
+	plat_data = dev_get_platdata(di->parent->dev);
 	di->pdata = plat_data->btemp;
 	if (!di->pdata) {
 		dev_err(di->dev, "no btemp platform data supplied\n");
diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 3ceb788..22076f5 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -2628,14 +2628,9 @@ static int __devexit ab8500_charger_remove(struct platform_device *pdev)
 static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 {
 	int irq, i, charger_status, ret = 0;
-	struct abx500_bm_plat_data *plat_data = pdev->dev.platform_data;
+	struct ab8500_platform_data *plat_data;
 	struct ab8500_charger *di;
 
-	if (!plat_data) {
-		dev_err(&pdev->dev, "No platform data\n");
-		return -EINVAL;
-	}
-
 	di = kzalloc(sizeof(*di), GFP_KERNEL);
 	if (!di)
 		return -ENOMEM;
@@ -2649,6 +2644,8 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 	spin_lock_init(&di->usb_state.usb_lock);
 
 	/* get charger specific platform data */
+	plat_data = dev_get_platdata(di->parent->dev);
+
 	di->pdata = plat_data->charger;
 	if (!di->pdata) {
 		dev_err(di->dev, "no charger platform data supplied\n");
diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index af792a8..c098ddd 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -2446,14 +2446,9 @@ static int __devinit ab8500_fg_probe(struct platform_device *pdev)
 {
 	int i, irq;
 	int ret = 0;
-	struct abx500_bm_plat_data *plat_data = pdev->dev.platform_data;
+	struct ab8500_platform_data *plat_data;
 	struct ab8500_fg *di;
 
-	if (!plat_data) {
-		dev_err(&pdev->dev, "No platform data\n");
-		return -EINVAL;
-	}
-
 	di = kzalloc(sizeof(*di), GFP_KERNEL);
 	if (!di)
 		return -ENOMEM;
@@ -2466,6 +2461,7 @@ static int __devinit ab8500_fg_probe(struct platform_device *pdev)
 	di->gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
 
 	/* get fg specific platform data */
+	plat_data = dev_get_platdata(di->parent->dev);
 	di->pdata = plat_data->fg;
 	if (!di->pdata) {
 		dev_err(di->dev, "no fg platform data supplied\n");
diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index 804b88c..032b27d 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -220,6 +220,7 @@ enum maxim_ret {
  */
 struct abx500_chargalg {
 	struct device *dev;
+	struct ab8500 *parent;
 	int charge_status;
 	int eoc_cnt;
 	int rch_cnt;
@@ -1802,7 +1803,7 @@ static int __devexit abx500_chargalg_remove(struct platform_device *pdev)
 
 static int __devinit abx500_chargalg_probe(struct platform_device *pdev)
 {
-	struct abx500_bm_plat_data *plat_data;
+	struct ab8500_platform_data *plat_data;
 	int ret = 0;
 
 	struct abx500_chargalg *di =
@@ -1812,8 +1813,8 @@ static int __devinit abx500_chargalg_probe(struct platform_device *pdev)
 
 	/* get device struct */
 	di->dev = &pdev->dev;
-
-	plat_data = pdev->dev.platform_data;
+	di->parent = dev_get_drvdata(pdev->dev.parent);
+	plat_data = dev_get_platdata(di->parent->dev);
 	di->pdata = plat_data->chargalg;
 	di->bat = plat_data->battery;
 
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index 3764cb6..db8a1e3 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -170,7 +170,7 @@ enum ab8500_version {
 #define AB8500_INT_ID_DET_R2F		99
 #define AB8500_INT_ID_DET_R3F		100
 #define AB8500_INT_ID_DET_R4F		101
-#define AB8500_INT_CHAUTORESTARTAFTSEC  102
+#define AB8500_INT_CHAUTORESTARTAFTSEC	102
 #define AB8500_INT_CHSTOPBYSEC		103
 /* ab8500_irq_regoffset[13] -> IT[Source|Latch|Mask]22 */
 #define AB8500_INT_USB_CH_TH_PROT_F	104
@@ -289,6 +289,11 @@ struct ab8500_platform_data {
 	struct regulator_init_data *regulator;
 	struct ab8500_gpio_platform_data *gpio;
 	struct ab8500_codec_platform_data *codec;
+	struct abx500_bm_data *battery;
+	struct abx500_charger_platform_data *charger;
+	struct abx500_btemp_platform_data *btemp;
+	struct abx500_fg_platform_data *fg;
+	struct abx500_chargalg_platform_data *chargalg;
 };
 
 extern int __devinit ab8500_init(struct ab8500 *ab8500,
-- 
1.7.5.4

