Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab2DYCJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 22:09:53 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56539 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab2DYCJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 22:09:51 -0400
Message-ID: <1335319786.30909.11.camel@phoenix>
Subject: [PATCH 5/5] mfd: twl6040-core: Convert to devm_regmap_init_i2c()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Misael Lopez Cruz <misael.lopez@ti.com>
Date: Wed, 25 Apr 2012 10:09:46 +0800
In-Reply-To: <1335319315.30909.2.camel@phoenix>
References: <1335319315.30909.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/twl6040-core.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index 2d6beda..493f4a6 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -524,7 +524,7 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 		goto err;
 	}
 
-	twl6040->regmap = regmap_init_i2c(client, &twl6040_regmap_config);
+	twl6040->regmap = devm_regmap_init_i2c(client, &twl6040_regmap_config);
 	if (IS_ERR(twl6040->regmap)) {
 		ret = PTR_ERR(twl6040->regmap);
 		goto err;
@@ -623,7 +623,6 @@ gpio2_err:
 		gpio_free(twl6040->audpwron);
 gpio1_err:
 	i2c_set_clientdata(client, NULL);
-	regmap_exit(twl6040->regmap);
 err:
 	return ret;
 }
@@ -643,7 +642,6 @@ static int __devexit twl6040_remove(struct i2c_client *client)
 
 	mfd_remove_devices(&client->dev);
 	i2c_set_clientdata(client, NULL);
-	regmap_exit(twl6040->regmap);
 
 	return 0;
 }
-- 
1.7.5.4



