Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab2FDE6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 00:58:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37214 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab2FDE6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 00:58:30 -0400
Message-ID: <1338785904.9793.3.camel@phoenix>
Subject: [PATCH RFT 2/2] regulator: max1586: Convert max1586_v6_ops to
 set_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Robert Jarzmik <robert.jarzmik@free.fr>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 04 Jun 2012 12:58:24 +0800
In-Reply-To: <1338785818.9793.1.camel@phoenix>
References: <1338785818.9793.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max1586.c |   27 +++++----------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
index f215195..126c7d8 100644
--- a/drivers/regulator/max1586.c
+++ b/drivers/regulator/max1586.c
@@ -105,33 +105,16 @@ static int max1586_v3_list(struct regulator_dev *rdev, unsigned selector)
 	return max1586_v3_calc_voltage(max1586, selector);
 }
 
-static int max1586_v6_set(struct regulator_dev *rdev, int min_uV, int max_uV,
-			  unsigned int *selector)
+static int max1586_v6_set_voltage_sel(struct regulator_dev *rdev,
+				      unsigned int selector)
 {
 	struct i2c_client *client = rdev_get_drvdata(rdev);
 	u8 v6_prog;
 
-	if (min_uV < MAX1586_V6_MIN_UV || min_uV > MAX1586_V6_MAX_UV)
-		return -EINVAL;
-	if (max_uV < MAX1586_V6_MIN_UV || max_uV > MAX1586_V6_MAX_UV)
-		return -EINVAL;
-
-	if (min_uV < 1800000)
-		*selector = 0;
-	else if (min_uV < 2500000)
-		*selector = 1;
-	else if (min_uV < 3000000)
-		*selector = 2;
-	else if (min_uV >= 3000000)
-		*selector = 3;
-
-	if (rdev->desc->volt_table[*selector] > max_uV)
-		return -EINVAL;
-
 	dev_dbg(&client->dev, "changing voltage v6 to %dmv\n",
-		rdev->desc->volt_table[*selector] / 1000);
+		rdev->desc->volt_table[selector] / 1000);
 
-	v6_prog = I2C_V6_SELECT | (u8) *selector;
+	v6_prog = I2C_V6_SELECT | (u8) selector;
 	return i2c_smbus_write_byte(client, v6_prog);
 }
 
@@ -145,7 +128,7 @@ static struct regulator_ops max1586_v3_ops = {
 };
 
 static struct regulator_ops max1586_v6_ops = {
-	.set_voltage = max1586_v6_set,
+	.set_voltage_sel = max1586_v6_set_voltage_sel,
 	.list_voltage = regulator_list_voltage_table,
 };
 
-- 
1.7.9.5



