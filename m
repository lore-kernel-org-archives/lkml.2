Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457Ab0IAFF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 01:05:56 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58124 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab0IAFFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 01:05:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=lJL1OdvD1XitP0iEJuPC+58X1ZBTUtNctM2oYLqHhf/MtjG6fz8PGzSCXy1JnTcGmJ
         hpcepko75O2DUudBBEO7K4LcIOWaT+sy9dmuiGLZZtHttP34chMLxgWCIMi7M/pzUQ69
         lwKS5gMEN9VVNocAPtmzXnp7wpX0MYOViitFs=
Subject: [PATCH] regulator: isl6271a-regulator - fix regulator_desc
	parameter for regulator_register()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Marek Vasut <marek.vasut@gmail.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Wed, 01 Sep 2010 13:09:41 +0800
Message-Id: <1283317781.5092.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/isl6271a-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/isl6271a-regulator.c b/drivers/regulator/isl6271a-regulator.c
index 65ecd82..b8cc638 100644
--- a/drivers/regulator/isl6271a-regulator.c
+++ b/drivers/regulator/isl6271a-regulator.c
@@ -165,7 +165,7 @@ static int __devinit isl6271a_probe(struct i2c_client *i2c,
 	mutex_init(&pmic->mtx);
 
 	for (i = 0; i < 3; i++) {
-		pmic->rdev[i] = regulator_register(&isl_rd[0], &i2c->dev,
+		pmic->rdev[i] = regulator_register(&isl_rd[i], &i2c->dev,
 						init_data, pmic);
 		if (IS_ERR(pmic->rdev[i])) {
 			dev_err(&i2c->dev, "failed to register %s\n", id->name);
-- 
1.7.2



