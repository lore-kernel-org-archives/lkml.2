Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266Ab2GDFMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:12:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54659 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab2GDFML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:12:11 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/25] leds: convert PCA9532 LED driver to devm_kzalloc()
Date: Wed,  4 Jul 2012 13:10:04 +0800
Message-Id: <1341378617-10386-13-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Riku Voipio <riku.voipio@iki.fi>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/leds-pca9532.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index ceccab4..cee8a5b 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -449,7 +449,6 @@ static int pca9532_probe(struct i2c_client *client,
 {
 	struct pca9532_data *data = i2c_get_clientdata(client);
 	struct pca9532_platform_data *pca9532_pdata = client->dev.platform_data;
-	int err;
 
 	if (!pca9532_pdata)
 		return -EIO;
@@ -458,7 +457,7 @@ static int pca9532_probe(struct i2c_client *client,
 		I2C_FUNC_SMBUS_BYTE_DATA))
 		return -EIO;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	data = devm_kzalloc(&client->dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
@@ -469,11 +468,7 @@ static int pca9532_probe(struct i2c_client *client,
 	data->client = client;
 	mutex_init(&data->update_lock);
 
-	err = pca9532_configure(client, data, pca9532_pdata);
-	if (err)
-		kfree(data);
-
-	return err;
+	return pca9532_configure(client, data, pca9532_pdata);
 }
 
 static int pca9532_remove(struct i2c_client *client)
@@ -485,7 +480,6 @@ static int pca9532_remove(struct i2c_client *client)
 	if (err)
 		return err;
 
-	kfree(data);
 	return 0;
 }
 
-- 
1.7.10.4

