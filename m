Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab2KFToE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 14:44:04 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33209 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab2KFTlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 14:41:08 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 2/2] Staging/media: Use dev_ printks in go7007/s2250-board.c
Date: Wed,  7 Nov 2012 04:41:03 +0900
Message-Id: <1352230863-9474-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352230817-9440-1-git-send-email-yamanetoshi@gmail.com>
References: <1352230817-9440-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warning.
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/media/go7007/s2250-board.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/media/go7007/s2250-board.c b/drivers/staging/media/go7007/s2250-board.c
index 6f94c17..d1cfefe 100644
--- a/drivers/staging/media/go7007/s2250-board.c
+++ b/drivers/staging/media/go7007/s2250-board.c
@@ -173,7 +173,7 @@ static int write_reg(struct i2c_client *client, u8 reg, u8 value)
 
 	usb = go->hpi_context;
 	if (mutex_lock_interruptible(&usb->i2c_lock) != 0) {
-		printk(KERN_INFO "i2c lock failed\n");
+		dev_info(&client->dev, "i2c lock failed\n");
 		kfree(buf);
 		return -EINTR;
 	}
@@ -212,7 +212,7 @@ static int write_reg_fp(struct i2c_client *client, u16 addr, u16 val)
 
 	usb = go->hpi_context;
 	if (mutex_lock_interruptible(&usb->i2c_lock) != 0) {
-		printk(KERN_INFO "i2c lock failed\n");
+		dev_info(&client->dev, "i2c lock failed\n");
 		kfree(buf);
 		return -EINTR;
 	}
@@ -230,13 +230,13 @@ static int write_reg_fp(struct i2c_client *client, u16 addr, u16 val)
 		val_read = (buf[2] << 8) + buf[3];
 		kfree(buf);
 		if (val_read != val) {
-			printk(KERN_INFO "invalid fp write %x %x\n",
-			       val_read, val);
+			dev_info(&client->dev, "invalid fp write %x %x\n",
+				 val_read, val);
 			return -EFAULT;
 		}
 		if (subaddr != addr) {
-			printk(KERN_INFO "invalid fp write addr %x %x\n",
-			       subaddr, addr);
+			dev_info(&client->dev, "invalid fp write addr %x %x\n",
+				 subaddr, addr);
 			return -EFAULT;
 		}
 	} else {
@@ -274,7 +274,7 @@ static int read_reg_fp(struct i2c_client *client, u16 addr, u16 *val)
 	memset(buf, 0xcd, 6);
 	usb = go->hpi_context;
 	if (mutex_lock_interruptible(&usb->i2c_lock) != 0) {
-		printk(KERN_INFO "i2c lock failed\n");
+		dev_info(&client->dev, "i2c lock failed\n");
 		kfree(buf);
 		return -EINTR;
 	}
@@ -298,7 +298,7 @@ static int write_regs(struct i2c_client *client, u8 *regs)
 
 	for (i = 0; !((regs[i] == 0x00) && (regs[i+1] == 0x00)); i += 2) {
 		if (write_reg(client, regs[i], regs[i+1]) < 0) {
-			printk(KERN_INFO "s2250: failed\n");
+			dev_info(&client->dev, "failed\n");
 			return -1;
 		}
 	}
@@ -311,7 +311,7 @@ static int write_regs_fp(struct i2c_client *client, u16 *regs)
 
 	for (i = 0; !((regs[i] == 0x00) && (regs[i+1] == 0x00)); i += 2) {
 		if (write_reg_fp(client, regs[i], regs[i+1]) < 0) {
-			printk(KERN_INFO "s2250: failed fp\n");
+			dev_info(&client->dev, "failed fp\n");
 			return -1;
 		}
 	}
@@ -605,23 +605,20 @@ static int s2250_probe(struct i2c_client *client,
 
 	/* initialize the audio */
 	if (write_regs(audio, aud_regs) < 0) {
-		printk(KERN_ERR
-		       "s2250: error initializing audio\n");
+		dev_err(&client->dev, "error initializing audio\n");
 		i2c_unregister_device(audio);
 		kfree(state);
 		return 0;
 	}
 
 	if (write_regs(client, vid_regs) < 0) {
-		printk(KERN_ERR
-		       "s2250: error initializing decoder\n");
+		dev_err(&client->dev, "error initializing decoder\n");
 		i2c_unregister_device(audio);
 		kfree(state);
 		return 0;
 	}
 	if (write_regs_fp(client, vid_regs_fp) < 0) {
-		printk(KERN_ERR
-		       "s2250: error initializing decoder\n");
+		dev_err(&client->dev, "error initializing decoder\n");
 		i2c_unregister_device(audio);
 		kfree(state);
 		return 0;
-- 
1.7.9.5

