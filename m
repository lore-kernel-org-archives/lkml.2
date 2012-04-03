Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab2DCWXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 18:23:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42244 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753999Ab2DCWXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 18:23:17 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Heiko Stuebner <heiko@sntech.de>, Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regulator: gpio-regulator: Basic devm_kzalloc() conversion
Date: Tue,  3 Apr 2012 23:23:09 +0100
Message-Id: <1333491789-15883-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1333491789-15883-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1333491789-15883-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's some other allocations but they're not so trivial as they use
kmemdup() and kstrdup().

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/gpio-regulator.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 5f9b6ad..ad0fc78 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -174,7 +174,8 @@ static int __devinit gpio_regulator_probe(struct platform_device *pdev)
 	struct gpio_regulator_data *drvdata;
 	int ptr, ret, state;
 
-	drvdata = kzalloc(sizeof(struct gpio_regulator_data), GFP_KERNEL);
+	drvdata = devm_kzalloc(&pdev->dev, sizeof(struct gpio_regulator_data),
+			       GFP_KERNEL);
 	if (drvdata == NULL) {
 		dev_err(&pdev->dev, "Failed to allocate device data\n");
 		return -ENOMEM;
@@ -307,7 +308,6 @@ err_memgpio:
 err_name:
 	kfree(drvdata->desc.name);
 err:
-	kfree(drvdata);
 	return ret;
 }
 
@@ -326,7 +326,6 @@ static int __devexit gpio_regulator_remove(struct platform_device *pdev)
 		gpio_free(drvdata->enable_gpio);
 
 	kfree(drvdata->desc.name);
-	kfree(drvdata);
 
 	return 0;
 }
-- 
1.7.9.1

