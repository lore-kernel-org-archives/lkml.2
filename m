Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920Ab2EPCK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 22:10:29 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:42088 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758373Ab2EPCK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 22:10:27 -0400
Message-ID: <1337134222.5940.3.camel@phoenix>
Subject: [PATCH RFT 2/3] regulator: isl6271a: Convert to get_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Vasut <marek.vasut@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 16 May 2012 10:10:22 +0800
In-Reply-To: <1337134167.5940.2.camel@phoenix>
References: <1337134167.5940.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/isl6271a-regulator.c |   17 +++++------------
 1 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/isl6271a-regulator.c b/drivers/regulator/isl6271a-regulator.c
index 78cdc90..00cb288 100644
--- a/drivers/regulator/isl6271a-regulator.c
+++ b/drivers/regulator/isl6271a-regulator.c
@@ -35,26 +35,19 @@ struct isl_pmic {
 	struct mutex		mtx;
 };
 
-static int isl6271a_get_voltage(struct regulator_dev *dev)
+static int isl6271a_get_voltage_sel(struct regulator_dev *dev)
 {
 	struct isl_pmic *pmic = rdev_get_drvdata(dev);
-	int idx, data;
+	int idx;
 
 	mutex_lock(&pmic->mtx);
 
 	idx = i2c_smbus_read_byte(pmic->client);
-	if (idx < 0) {
+	if (idx < 0)
 		dev_err(&pmic->client->dev, "Error getting voltage\n");
-		data = idx;
-		goto out;
-	}
-
-	/* Convert the data from chip to microvolts */
-	data = ISL6271A_VOLTAGE_MIN + (ISL6271A_VOLTAGE_STEP * (idx & 0xf));
 
-out:
 	mutex_unlock(&pmic->mtx);
-	return data;
+	return idx;
 }
 
 static int isl6271a_set_voltage(struct regulator_dev *dev,
@@ -84,7 +77,7 @@ static int isl6271a_set_voltage(struct regulator_dev *dev,
 }
 
 static struct regulator_ops isl_core_ops = {
-	.get_voltage	= isl6271a_get_voltage,
+	.get_voltage_sel = isl6271a_get_voltage_sel,
 	.set_voltage	= isl6271a_set_voltage,
 	.list_voltage	= regulator_list_voltage_linear,
 };
-- 
1.7.5.4



