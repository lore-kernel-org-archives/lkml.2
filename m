Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165Ab2KELfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 06:35:13 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42627 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab2KELfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 06:35:11 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/media: Use dev_ or pr_ printks in go7007/go7007-i2c.c
Date: Mon,  5 Nov 2012 20:35:06 +0900
Message-Id: <1352115306-8115-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
- WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(...  to printk(KERN_DEBUG ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/media/go7007/go7007-i2c.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-i2c.c b/drivers/staging/media/go7007/go7007-i2c.c
index 6bc82aa..39456a3 100644
--- a/drivers/staging/media/go7007/go7007-i2c.c
+++ b/drivers/staging/media/go7007/go7007-i2c.c
@@ -60,10 +60,10 @@ static int go7007_i2c_xfer(struct go7007 *go, u16 addr, int read,
 
 #ifdef GO7007_I2C_DEBUG
 	if (read)
-		printk(KERN_DEBUG "go7007-i2c: reading 0x%02x on 0x%02x\n",
+		dev_dbg(go->dev, "go7007-i2c: reading 0x%02x on 0x%02x\n",
 			command, addr);
 	else
-		printk(KERN_DEBUG
+		dev_dbg(go->dev,
 			"go7007-i2c: writing 0x%02x to 0x%02x on 0x%02x\n",
 			*data, command, addr);
 #endif
@@ -85,7 +85,7 @@ static int go7007_i2c_xfer(struct go7007 *go, u16 addr, int read,
 		msleep(100);
 	}
 	if (i == 10) {
-		printk(KERN_ERR "go7007-i2c: I2C adapter is hung\n");
+		dev_err(go->dev, "go7007-i2c: I2C adapter is hung\n");
 		goto i2c_done;
 	}
 
@@ -119,7 +119,7 @@ static int go7007_i2c_xfer(struct go7007 *go, u16 addr, int read,
 		msleep(100);
 	}
 	if (i == 10) {
-		printk(KERN_ERR "go7007-i2c: I2C adapter is hung\n");
+		dev_err(go->dev, "go7007-i2c: I2C adapter is hung\n");
 		goto i2c_done;
 	}
 
@@ -216,7 +216,7 @@ int go7007_i2c_init(struct go7007 *go)
 	go->i2c_adapter.dev.parent = go->dev;
 	i2c_set_adapdata(&go->i2c_adapter, go);
 	if (i2c_add_adapter(&go->i2c_adapter) < 0) {
-		printk(KERN_ERR
+		dev_err(go->dev,
 			"go7007-i2c: error: i2c_add_adapter failed\n");
 		return -1;
 	}
-- 
1.7.9.5

