Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760553Ab2DKPGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 11:06:53 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39117 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996Ab2DKPGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 11:06:52 -0400
Message-ID: <1334156807.4819.1.camel@phoenix>
Subject: [PATCH 2/3] regulator: max1586: Use devm_kzalloc()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Robert Jarzmik <robert.jarzmik@free.fr>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 11 Apr 2012 23:06:47 +0800
In-Reply-To: <1334156749.4819.0.camel@phoenix>
References: <1334156749.4819.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max1586.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
index ea832b4..b9444ee 100644
--- a/drivers/regulator/max1586.c
+++ b/drivers/regulator/max1586.c
@@ -189,18 +189,17 @@ static int __devinit max1586_pmic_probe(struct i2c_client *client,
 	struct max1586_data *max1586;
 	int i, id, ret = -ENOMEM;
 
-	max1586 = kzalloc(sizeof(struct max1586_data) +
+	max1586 = devm_kzalloc(&client->dev, sizeof(struct max1586_data) +
 			sizeof(struct regulator_dev *) * (MAX1586_V6 + 1),
 			GFP_KERNEL);
 	if (!max1586)
-		goto out;
+		return -ENOMEM;
 
 	max1586->client = client;
 
-	if (!pdata->v3_gain) {
-		ret = -EINVAL;
-		goto out_unmap;
-	}
+	if (!pdata->v3_gain)
+		return -EINVAL;
+
 	max1586->min_uV = MAX1586_V3_MIN_UV / 1000 * pdata->v3_gain / 1000;
 	max1586->max_uV = MAX1586_V3_MAX_UV / 1000 * pdata->v3_gain / 1000;
 
@@ -234,9 +233,6 @@ static int __devinit max1586_pmic_probe(struct i2c_client *client,
 err:
 	while (--i >= 0)
 		regulator_unregister(rdev[i]);
-out_unmap:
-	kfree(max1586);
-out:
 	return ret;
 }
 
@@ -248,8 +244,6 @@ static int __devexit max1586_pmic_remove(struct i2c_client *client)
 	for (i = 0; i <= MAX1586_V6; i++)
 		if (max1586->rdev[i])
 			regulator_unregister(max1586->rdev[i]);
-	kfree(max1586);
-
 	return 0;
 }
 
-- 
1.7.5.4



