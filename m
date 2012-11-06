Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab2KFMeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 07:34:13 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53156 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab2KFMeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 07:34:09 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 2/2] Staging/media: Use dev_ printks in go7007/wis-tw9903.c
Date: Tue,  6 Nov 2012 21:34:02 +0900
Message-Id: <1352205243-5829-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352205206-5794-1-git-send-email-yamanetoshi@gmail.com>
References: <1352205206-5794-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warning.
- WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(...  to printk(KERN_DEBUG ...
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/media/go7007/wis-tw9903.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/go7007/wis-tw9903.c b/drivers/staging/media/go7007/wis-tw9903.c
index 3821cd5..246ce17 100644
--- a/drivers/staging/media/go7007/wis-tw9903.c
+++ b/drivers/staging/media/go7007/wis-tw9903.c
@@ -127,8 +127,8 @@ static int wis_tw9903_command(struct i2c_client *client,
 			0x06, 0xc0, /* reset device */
 			0,	0,
 		};
-		printk(KERN_DEBUG "vscale is %04x, hscale is %04x\n",
-				vscale, hscale);
+		dev_dbg(&client->dev, "vscale is %04x, hscale is %04x\n",
+			vscale, hscale);
 		/*write_regs(client, regs);*/
 		break;
 	}
@@ -287,12 +287,11 @@ static int wis_tw9903_probe(struct i2c_client *client,
 	dec->hue = 0;
 	i2c_set_clientdata(client, dec);
 
-	printk(KERN_DEBUG
-		"wis-tw9903: initializing TW9903 at address %d on %s\n",
+	dev_dbg(&client->dev, "initializing TW9903 at address %d on %s\n",
 		client->addr, adapter->name);
 
 	if (write_regs(client, initial_registers) < 0) {
-		printk(KERN_ERR "wis-tw9903: error initializing TW9903\n");
+		dev_err(&client->dev, "error initializing TW9903\n");
 		kfree(dec);
 		return -ENODEV;
 	}
-- 
1.7.9.5

