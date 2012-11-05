Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab2KELiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 06:38:19 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59221 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab2KELiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 06:38:18 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 2/2] staging/media: Use dev_ or pr_ printks in go7007/wis-saa7113.c
Date: Mon,  5 Nov 2012 20:38:12 +0900
Message-Id: <1352115492-8252-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352115408-8217-1-git-send-email-yamanetoshi@gmail.com>
References: <1352115408-8217-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
- WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(...  to printk(KERN_DEBUG ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/media/go7007/wis-saa7113.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/go7007/wis-saa7113.c b/drivers/staging/media/go7007/wis-saa7113.c
index 7f155cb..d7ce95f 100644
--- a/drivers/staging/media/go7007/wis-saa7113.c
+++ b/drivers/staging/media/go7007/wis-saa7113.c
@@ -281,12 +281,12 @@ static int wis_saa7113_probe(struct i2c_client *client,
 	dec->hue = 0;
 	i2c_set_clientdata(client, dec);
 
-	printk(KERN_DEBUG
+	dev_dbg(&client->dev,
 		"wis-saa7113: initializing SAA7113 at address %d on %s\n",
 		client->addr, adapter->name);
 
 	if (write_regs(client, initial_registers) < 0) {
-		printk(KERN_ERR
+		dev_err(&client->dev,
 			"wis-saa7113: error initializing SAA7113\n");
 		kfree(dec);
 		return -ENODEV;
-- 
1.7.9.5

