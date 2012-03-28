Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805Ab2C1HBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 03:01:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49929 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab2C1HBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 03:01:53 -0400
Message-ID: <1332918108.19101.4.camel@phoenix>
Subject: [PATCH 4/4] regulator: Convert 88pm8607 to get_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Jett.Zhou" <jtzhou@marvell.com>
Date: Wed, 28 Mar 2012 15:01:48 +0800
In-Reply-To: <1332917909.19101.1.camel@phoenix>
References: <1332917909.19101.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/88pm8607.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index 7fafff2..11e5ddd 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -246,7 +246,7 @@ static int pm8607_set_voltage_sel(struct regulator_dev *rdev, unsigned selector)
 	return ret;
 }
 
-static int pm8607_get_voltage(struct regulator_dev *rdev)
+static int pm8607_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct pm8607_regulator_info *info = rdev_get_drvdata(rdev);
 	uint8_t val, mask;
@@ -259,7 +259,7 @@ static int pm8607_get_voltage(struct regulator_dev *rdev)
 	mask = (rdev->desc->n_voltages - 1)  << info->vol_shift;
 	val = ((unsigned char)ret & mask) >> info->vol_shift;
 
-	return pm8607_list_voltage(rdev, val);
+	return val;
 }
 
 static int pm8607_enable(struct regulator_dev *rdev)
@@ -294,7 +294,7 @@ static int pm8607_is_enabled(struct regulator_dev *rdev)
 static struct regulator_ops pm8607_regulator_ops = {
 	.list_voltage	= pm8607_list_voltage,
 	.set_voltage_sel = pm8607_set_voltage_sel,
-	.get_voltage	= pm8607_get_voltage,
+	.get_voltage_sel = pm8607_get_voltage_sel,
 	.enable		= pm8607_enable,
 	.disable	= pm8607_disable,
 	.is_enabled	= pm8607_is_enabled,
-- 
1.7.5.4



