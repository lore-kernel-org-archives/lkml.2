Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab2KBMJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 08:09:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55903 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab2KBMJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 08:09:35 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 2/2] Staging/media: Use dev_ printks in go7007/wis-ov7640.c
Date: Fri,  2 Nov 2012 21:09:29 +0900
Message-Id: <1351858169-5742-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351858121-5708-1-git-send-email-yamanetoshi@gmail.com>
References: <1351858121-5708-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
- WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(...  to printk(KERN_DEBUG ...
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/media/go7007/wis-ov7640.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/go7007/wis-ov7640.c b/drivers/staging/media/go7007/wis-ov7640.c
index eb5efc9..fe46374 100644
--- a/drivers/staging/media/go7007/wis-ov7640.c
+++ b/drivers/staging/media/go7007/wis-ov7640.c
@@ -59,12 +59,12 @@ static int wis_ov7640_probe(struct i2c_client *client,
 
 	client->flags = I2C_CLIENT_SCCB;
 
-	printk(KERN_DEBUG
+	dev_dbg(&client->dev,
 		"wis-ov7640: initializing OV7640 at address %d on %s\n",
 		client->addr, adapter->name);
 
 	if (write_regs(client, initial_registers) < 0) {
-		printk(KERN_ERR "wis-ov7640: error initializing OV7640\n");
+		dev_err(&client->dev, "wis-ov7640: error initializing OV7640\n");
 		return -ENODEV;
 	}
 
-- 
1.7.9.5

