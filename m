Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709Ab2DYBaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 21:30:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44662 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063Ab2DYBao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 21:30:44 -0400
Message-ID: <1335317436.24039.2.camel@phoenix>
Subject: [PATCH] mfd: tps65090: Return proper error if regmap_init_i2c fails
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Date: Wed, 25 Apr 2012 09:30:36 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return proper error instead of 0 if regmap_init_i2c fails.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/tps65090.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
index 47f802b..da821d9 100644
--- a/drivers/mfd/tps65090.c
+++ b/drivers/mfd/tps65090.c
@@ -286,10 +286,10 @@ static int __devinit tps65090_i2c_probe(struct i2c_client *client,
 	tps65090->rmap = regmap_init_i2c(tps65090->client,
 		&tps65090_regmap_config);
 	if (IS_ERR(tps65090->rmap)) {
-		dev_err(&client->dev, "regmap_init failed with err: %ld\n",
-			PTR_ERR(tps65090->rmap));
+		ret = PTR_ERR(tps65090->rmap);
+		dev_err(&client->dev, "regmap_init failed with err: %d\n", ret);
 		goto err_irq_exit;
-	};
+	}
 
 	ret = mfd_add_devices(tps65090->dev, -1, tps65090s,
 		ARRAY_SIZE(tps65090s), NULL, 0);
-- 
1.7.5.4



