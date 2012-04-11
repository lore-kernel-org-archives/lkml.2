Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760458Ab2DKPF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 11:05:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54498 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996Ab2DKPF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 11:05:56 -0400
Message-ID: <1334156749.4819.0.camel@phoenix>
Subject: [PATCH 1/3] regulator: isl6271a-regulator: Use devm_kzalloc()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Vasut <marek.vasut@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 11 Apr 2012 23:05:49 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/isl6271a-regulator.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/isl6271a-regulator.c b/drivers/regulator/isl6271a-regulator.c
index 863f45a..60044c3 100644
--- a/drivers/regulator/isl6271a-regulator.c
+++ b/drivers/regulator/isl6271a-regulator.c
@@ -148,7 +148,7 @@ static int __devinit isl6271a_probe(struct i2c_client *i2c,
 	if (!i2c_check_functionality(i2c->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -EIO;
 
-	pmic = kzalloc(sizeof(struct isl_pmic), GFP_KERNEL);
+	pmic = devm_kzalloc(&i2c->dev, sizeof(struct isl_pmic), GFP_KERNEL);
 	if (!pmic)
 		return -ENOMEM;
 
@@ -179,8 +179,6 @@ static int __devinit isl6271a_probe(struct i2c_client *i2c,
 error:
 	while (--i >= 0)
 		regulator_unregister(pmic->rdev[i]);
-
-	kfree(pmic);
 	return err;
 }
 
@@ -191,9 +189,6 @@ static int __devexit isl6271a_remove(struct i2c_client *i2c)
 
 	for (i = 0; i < 3; i++)
 		regulator_unregister(pmic->rdev[i]);
-
-	kfree(pmic);
-
 	return 0;
 }
 
-- 
1.7.5.4



