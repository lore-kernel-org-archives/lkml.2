Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab2ENQMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:12:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44726 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290Ab2ENQMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:12:19 -0400
Message-ID: <1337011930.13224.1.camel@phoenix>
Subject: [PATCH 1/4] regulator: max8649: Convert to get_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jonghwan Choi <jhbird.choi@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Tue, 15 May 2012 00:12:10 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8649.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index 4ce7208..3b73a7f 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -76,7 +76,7 @@ static int max8649_list_voltage(struct regulator_dev *rdev, unsigned index)
 	return (MAX8649_DCDC_VMIN + index * MAX8649_DCDC_STEP);
 }
 
-static int max8649_get_voltage(struct regulator_dev *rdev)
+static int max8649_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct max8649_regulator_info *info = rdev_get_drvdata(rdev);
 	unsigned int val;
@@ -87,7 +87,7 @@ static int max8649_get_voltage(struct regulator_dev *rdev)
 	if (ret != 0)
 		return ret;
 	data = (unsigned char)val & MAX8649_VOL_MASK;
-	return max8649_list_voltage(rdev, data);
+	return data;
 }
 
 static int max8649_set_voltage(struct regulator_dev *rdev,
@@ -196,7 +196,7 @@ static unsigned int max8649_get_mode(struct regulator_dev *rdev)
 
 static struct regulator_ops max8649_dcdc_ops = {
 	.set_voltage	= max8649_set_voltage,
-	.get_voltage	= max8649_get_voltage,
+	.get_voltage_sel = max8649_get_voltage_sel,
 	.list_voltage	= max8649_list_voltage,
 	.enable		= max8649_enable,
 	.disable	= max8649_disable,
-- 
1.7.5.4



