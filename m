Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab2KFTld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 14:41:33 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33209 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab2KFTla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 14:41:30 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] Staging/media: Use dev_ printks in go7007/wis-tw2804.c
Date: Wed,  7 Nov 2012 04:41:26 +0900
Message-Id: <1352230886-9508-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warning.
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
- WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(...  to printk(KERN_DEBUG ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/media/go7007/wis-tw2804.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/media/go7007/wis-tw2804.c b/drivers/staging/media/go7007/wis-tw2804.c
index 9134f03..69b9063 100644
--- a/drivers/staging/media/go7007/wis-tw2804.c
+++ b/drivers/staging/media/go7007/wis-tw2804.c
@@ -128,30 +128,32 @@ static int wis_tw2804_command(struct i2c_client *client,
 		int *input = arg;
 
 		if (*input < 0 || *input > 3) {
-			printk(KERN_ERR "wis-tw2804: channel %d is not "
-					"between 0 and 3!\n", *input);
+			dev_err(&client->dev,
+				"channel %d is not between 0 and 3!\n", *input);
 			return 0;
 		}
 		dec->channel = *input;
-		printk(KERN_DEBUG "wis-tw2804: initializing TW2804 "
-				"channel %d\n", dec->channel);
+		dev_dbg(&client->dev, "initializing TW2804 channel %d\n",
+			dec->channel);
 		if (dec->channel == 0 &&
 				write_regs(client, global_registers, 0) < 0) {
-			printk(KERN_ERR "wis-tw2804: error initializing "
-					"TW2804 global registers\n");
+			dev_err(&client->dev,
+				"error initializing TW2804 global registers\n");
 			return 0;
 		}
 		if (write_regs(client, channel_registers, dec->channel) < 0) {
-			printk(KERN_ERR "wis-tw2804: error initializing "
-					"TW2804 channel %d\n", dec->channel);
+			dev_err(&client->dev,
+				"error initializing TW2804 channel %d\n",
+				dec->channel);
 			return 0;
 		}
 		return 0;
 	}
 
 	if (dec->channel < 0) {
-		printk(KERN_DEBUG "wis-tw2804: ignoring command %08x until "
-				"channel number is set\n", cmd);
+		dev_dbg(&client->dev,
+			"ignoring command %08x until channel number is set\n",
+			cmd);
 		return 0;
 	}
 
@@ -311,7 +313,7 @@ static int wis_tw2804_probe(struct i2c_client *client,
 	dec->hue = 128;
 	i2c_set_clientdata(client, dec);
 
-	printk(KERN_DEBUG "wis-tw2804: creating TW2804 at address %d on %s\n",
+	dev_dbg(&client->dev, "creating TW2804 at address %d on %s\n",
 		client->addr, adapter->name);
 
 	return 0;
-- 
1.7.9.5

