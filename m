Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755Ab2DYCFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 22:05:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59667 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757318Ab2DYCFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 22:05:04 -0400
Message-ID: <1335319498.30909.6.camel@phoenix>
Subject: [PATCH 3/5] mfd: tps65090: Convert to devm_regmap_init_i2c()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Date: Wed, 25 Apr 2012 10:04:58 +0800
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
 drivers/mfd/tps65090.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
index da821d9..3e12bba 100644
--- a/drivers/mfd/tps65090.c
+++ b/drivers/mfd/tps65090.c
@@ -283,8 +283,8 @@ static int __devinit tps65090_i2c_probe(struct i2c_client *client,
 		}
 	}
 
-	tps65090->rmap = regmap_init_i2c(tps65090->client,
-		&tps65090_regmap_config);
+	tps65090->rmap = devm_regmap_init_i2c(tps65090->client,
+					      &tps65090_regmap_config);
 	if (IS_ERR(tps65090->rmap)) {
 		ret = PTR_ERR(tps65090->rmap);
 		dev_err(&client->dev, "regmap_init failed with err: %d\n", ret);
@@ -296,14 +296,11 @@ static int __devinit tps65090_i2c_probe(struct i2c_client *client,
 	if (ret) {
 		dev_err(&client->dev, "add mfd devices failed with err: %d\n",
 			ret);
-		goto err_regmap_exit;
+		goto err_irq_exit;
 	}
 
 	return 0;
 
-err_regmap_exit:
-	regmap_exit(tps65090->rmap);
-
 err_irq_exit:
 	if (client->irq)
 		free_irq(client->irq, tps65090);
@@ -316,7 +313,6 @@ static int __devexit tps65090_i2c_remove(struct i2c_client *client)
 	struct tps65090 *tps65090 = i2c_get_clientdata(client);
 
 	mfd_remove_devices(tps65090->dev);
-	regmap_exit(tps65090->rmap);
 	if (client->irq)
 		free_irq(client->irq, tps65090);
 
-- 
1.7.5.4



