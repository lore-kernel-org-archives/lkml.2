Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761552Ab2FEKKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 06:10:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40075 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab2FEKKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 06:10:17 -0400
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH] regulator: max8649: fix missing regmap in rdev
Date: Tue,  5 Jun 2012 18:10:10 +0800
Message-Id: <1338891010-24805-1-git-send-email-haojian.zhuang@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In probe(), rdev->regmap must be assigned.

Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
---
 drivers/regulator/max8649.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index 1f4bb80..9d540cd 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -259,6 +259,7 @@ static int __devinit max8649_regulator_probe(struct i2c_client *client,
 	config.dev = &client->dev;
 	config.init_data = pdata->regulator;
 	config.driver_data = info;
+	config.regmap = info->regmap;
 
 	info->regulator = regulator_register(&dcdc_desc, &config);
 	if (IS_ERR(info->regulator)) {
-- 
1.7.5.4

