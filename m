Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab2KFTkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 14:40:04 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35242 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab2KFTkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 14:40:01 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] Staging/media: Use dev_ printks in go7007/wis-uda1342.c
Date: Wed,  7 Nov 2012 04:39:54 +0900
Message-Id: <1352230794-9406-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warning.
- WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(...  to printk(KERN_DEBUG ...
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/media/go7007/wis-uda1342.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/go7007/wis-uda1342.c b/drivers/staging/media/go7007/wis-uda1342.c
index 0127be2..48e1407 100644
--- a/drivers/staging/media/go7007/wis-uda1342.c
+++ b/drivers/staging/media/go7007/wis-uda1342.c
@@ -47,8 +47,8 @@ static int wis_uda1342_command(struct i2c_client *client,
 			write_reg(client, 0x00, 0x1241); /* select input 1 */
 			break;
 		default:
-			printk(KERN_ERR "wis-uda1342: input %d not supported\n",
-					*inp);
+			dev_err(&client->dev, "input %d not supported\n",
+				*inp);
 			break;
 		}
 		break;
@@ -67,8 +67,7 @@ static int wis_uda1342_probe(struct i2c_client *client,
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA))
 		return -ENODEV;
 
-	printk(KERN_DEBUG
-		"wis-uda1342: initializing UDA1342 at address %d on %s\n",
+	dev_dbg(&client->dev, "initializing UDA1342 at address %d on %s\n",
 		client->addr, adapter->name);
 
 	write_reg(client, 0x00, 0x8000); /* reset registers */
-- 
1.7.9.5

