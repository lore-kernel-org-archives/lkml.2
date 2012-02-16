Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab2BPHNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 02:13:07 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54472 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757359Ab2BPHNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 02:13:04 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: wm8994: Convert to devm_kzalloc()
Date: Wed, 15 Feb 2012 23:12:59 -0800
Message-Id: <1329376379-10653-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm8994-regulator.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index 435e335..75ed402 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -241,7 +241,7 @@ static __devinit int wm8994_ldo_probe(struct platform_device *pdev)
 	if (!pdata)
 		return -ENODEV;
 
-	ldo = kzalloc(sizeof(struct wm8994_ldo), GFP_KERNEL);
+	ldo = devm_kzalloc(&pdev->dev, sizeof(struct wm8994_ldo), GFP_KERNEL);
 	if (ldo == NULL) {
 		dev_err(&pdev->dev, "Unable to allocate private data\n");
 		return -ENOMEM;
@@ -285,7 +285,6 @@ err_gpio:
 	if (gpio_is_valid(ldo->enable))
 		gpio_free(ldo->enable);
 err:
-	kfree(ldo);
 	return ret;
 }
 
@@ -298,7 +297,6 @@ static __devexit int wm8994_ldo_remove(struct platform_device *pdev)
 	regulator_unregister(ldo->regulator);
 	if (gpio_is_valid(ldo->enable))
 		gpio_free(ldo->enable);
-	kfree(ldo);
 
 	return 0;
 }
-- 
1.7.9.rc1

