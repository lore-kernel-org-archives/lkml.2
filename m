Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab2KTDQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 22:16:03 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11785 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab2KTDPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 22:15:21 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 19 Nov 2012 19:15:17 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH RESEND 3/5] mfd: tps65090: remove unused member of struct tps65090
Date: Tue, 20 Nov 2012 08:44:47 +0530
Message-ID: <1353381289-11643-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1353381289-11643-1-git-send-email-ldewangan@nvidia.com>
References: <1353381289-11643-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused member from tps65090 data structure as
these are not used.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/mfd/tps65090.c       |    6 +-----
 include/linux/mfd/tps65090.h |   11 -----------
 2 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
index f95f7f6..3cfc9dc 100644
--- a/drivers/mfd/tps65090.c
+++ b/drivers/mfd/tps65090.c
@@ -269,12 +269,9 @@ static int __devinit tps65090_i2c_probe(struct i2c_client *client,
 		return -ENOMEM;
 	}
 
-	tps65090->client = client;
 	tps65090->dev = &client->dev;
 	i2c_set_clientdata(client, tps65090);
 
-	mutex_init(&tps65090->lock);
-
 	if (client->irq) {
 		ret = tps65090_irq_init(tps65090, client->irq, pdata->irq_base);
 		if (ret) {
@@ -284,8 +281,7 @@ static int __devinit tps65090_i2c_probe(struct i2c_client *client,
 		}
 	}
 
-	tps65090->rmap = devm_regmap_init_i2c(tps65090->client,
-					      &tps65090_regmap_config);
+	tps65090->rmap = devm_regmap_init_i2c(client, &tps65090_regmap_config);
 	if (IS_ERR(tps65090->rmap)) {
 		ret = PTR_ERR(tps65090->rmap);
 		dev_err(&client->dev, "regmap_init failed with err: %d\n", ret);
diff --git a/include/linux/mfd/tps65090.h b/include/linux/mfd/tps65090.h
index 6bc31d8..6c57622 100644
--- a/include/linux/mfd/tps65090.h
+++ b/include/linux/mfd/tps65090.h
@@ -25,26 +25,15 @@
 #include <linux/irq.h>
 
 struct tps65090 {
-	struct mutex		lock;
 	struct device		*dev;
-	struct i2c_client	*client;
 	struct regmap		*rmap;
 	struct irq_chip		irq_chip;
 	struct mutex		irq_lock;
 	int			irq_base;
-	unsigned int		id;
-};
-
-struct tps65090_subdev_info {
-	int		id;
-	const char	*name;
-	void		*platform_data;
 };
 
 struct tps65090_platform_data {
 	int irq_base;
-	int num_subdevs;
-	struct tps65090_subdev_info *subdevs;
 };
 
 /*
-- 
1.7.1.1

