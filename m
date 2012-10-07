Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab2JGP4H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 11:56:07 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6687 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab2JGPzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 11:55:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 07 Oct 2012 08:45:15 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <vbyravarasu@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 3/5] mfd: tps65090: remove unused member of struct tps65090
Date: Sun, 7 Oct 2012 20:52:18 +0530
Message-ID: <1349623340-21807-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1349623340-21807-1-git-send-email-ldewangan@nvidia.com>
References: <1349623340-21807-1-git-send-email-ldewangan@nvidia.com>
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

