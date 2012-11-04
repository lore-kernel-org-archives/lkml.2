Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab2KDUkc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 15:40:32 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46548 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab2KDUk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 15:40:29 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/media: Use dev_ printks in go7007/go7007-driver.c
Date: Mon,  5 Nov 2012 05:40:22 +0900
Message-Id: <1352061622-5869-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warning.
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/media/go7007/go7007-driver.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
index ece2dd1..c9dfc75 100644
--- a/drivers/staging/media/go7007/go7007-driver.c
+++ b/drivers/staging/media/go7007/go7007-driver.c
@@ -201,7 +201,8 @@ static int init_i2c_module(struct i2c_adapter *adapter, const char *type,
 	if (v4l2_i2c_new_subdev(v4l2_dev, adapter, type, addr, NULL))
 		return 0;
 
-	printk(KERN_INFO "go7007: probing for module i2c:%s failed\n", type);
+	dev_info(&adapter->dev,
+		 "go7007: probing for module i2c:%s failed\n", type);
 	return -1;
 }
 
@@ -217,7 +218,7 @@ int go7007_register_encoder(struct go7007 *go)
 {
 	int i, ret;
 
-	printk(KERN_INFO "go7007: registering new %s\n", go->name);
+	dev_info(go->dev, "go7007: registering new %s\n", go->name);
 
 	mutex_lock(&go->hw_lock);
 	ret = go7007_init_encoder(go);
-- 
1.7.9.5

