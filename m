Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab1KXH3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 02:29:24 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56972 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab1KXH3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 02:29:23 -0500
From: Rajendra Nayak <rnayak@ti.com>
To: <sfr@canb.auug.org.au>, <broonie@opensource.wolfsonmicro.com>,
        <lrg@slimlogic.co.uk>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <heiko@sntech.de>, Rajendra Nayak <rnayak@ti.com>
Subject: [PATCH] regulator: Fix compile break due to missing arguments to regulator_register
Date: Thu, 24 Nov 2011 12:57:17 +0530
Message-ID: <1322119637-32634-1-git-send-email-rnayak@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 2c043bcbf287 ("regulator: pass additional of_node to
regulator_register()") caused a compile break because it missed
updating the regulator_register() call in gpio-regulator.c with
the additional parameter (NULL).

The compile break as reported by Stephen Rothwell with the
x86_64 allmodconfig looked like this

drivers/regulator/gpio-regulator.c: In function 'gpio_regulator_probe':
drivers/regulator/gpio-regulator.c:287:8: error: too few arguments to function 'regulator_register'
include/linux/regulator/driver.h:215:23: note: declared here

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Rajendra Nayak <rnayak@ti.com>
---
 drivers/regulator/gpio-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index f0acf52..42e1cb1 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -284,7 +284,7 @@ static int __devinit gpio_regulator_probe(struct platform_device *pdev)
 	drvdata->state = state;
 
 	drvdata->dev = regulator_register(&drvdata->desc, &pdev->dev,
-					  config->init_data, drvdata);
+					  config->init_data, drvdata, NULL);
 	if (IS_ERR(drvdata->dev)) {
 		ret = PTR_ERR(drvdata->dev);
 		dev_err(&pdev->dev, "Failed to register regulator: %d\n", ret);
-- 
1.7.1

