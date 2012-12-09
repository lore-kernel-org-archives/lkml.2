Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934050Ab2LIM0G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 07:26:06 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39660 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933962Ab2LIM0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 07:26:05 -0500
Message-ID: <1355055955.8506.1.camel@phoenix>
Subject: [PATCH] mfd: tps6507x: Convert to devm_kzalloc
From: Axel Lin <axel.lin@ingics.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Todd Fischer <todd.fischer@ridgerun.com>, linux-kernel@vger.kernel.org
Date: Sun, 09 Dec 2012 20:25:55 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/mfd/tps6507x.c |   21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/mfd/tps6507x.c b/drivers/mfd/tps6507x.c
index 1b20349..409afa2 100644
--- a/drivers/mfd/tps6507x.c
+++ b/drivers/mfd/tps6507x.c
@@ -86,9 +86,9 @@ static int tps6507x_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
 	struct tps6507x_dev *tps6507x;
-	int ret = 0;
 
-	tps6507x = kzalloc(sizeof(struct tps6507x_dev), GFP_KERNEL);
+	tps6507x = devm_kzalloc(&i2c->dev, sizeof(struct tps6507x_dev),
+				GFP_KERNEL);
 	if (tps6507x == NULL)
 		return -ENOMEM;
 
@@ -98,19 +98,8 @@ static int tps6507x_i2c_probe(struct i2c_client *i2c,
 	tps6507x->read_dev = tps6507x_i2c_read_device;
 	tps6507x->write_dev = tps6507x_i2c_write_device;
 
-	ret = mfd_add_devices(tps6507x->dev, -1,
-			      tps6507x_devs, ARRAY_SIZE(tps6507x_devs),
-			      NULL, 0, NULL);
-
-	if (ret < 0)
-		goto err;
-
-	return ret;
-
-err:
-	mfd_remove_devices(tps6507x->dev);
-	kfree(tps6507x);
-	return ret;
+	return mfd_add_devices(tps6507x->dev, -1, tps6507x_devs,
+			       ARRAY_SIZE(tps6507x_devs), NULL, 0, NULL);
 }
 
 static int tps6507x_i2c_remove(struct i2c_client *i2c)
@@ -118,8 +107,6 @@ static int tps6507x_i2c_remove(struct i2c_client *i2c)
 	struct tps6507x_dev *tps6507x = i2c_get_clientdata(i2c);
 
 	mfd_remove_devices(tps6507x->dev);
-	kfree(tps6507x);
-
 	return 0;
 }
 
-- 
1.7.9.5



