Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab1ARJaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 04:30:00 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59018 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab1ARJ37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 04:29:59 -0500
From: shubhrajyoti@ti.com
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Shubhrajyoti Datta <shubhrajyoti@ti.com>
Subject: [PATCH ] bmp085: optimisations
Date: Tue, 18 Jan 2011 14:59:16 +0530
Message-Id: <1295342956-5561-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shubhrajyoti Datta <shubhrajyoti@ti.com>

Free the memory that is used only at init

Signed-off-by: Shubhrajyoti Datta <shubhrajyoti@ti.com>
---
 drivers/misc/bmp085.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/bmp085.c b/drivers/misc/bmp085.c
index 63ee4c1..cc05e0b 100644
--- a/drivers/misc/bmp085.c
+++ b/drivers/misc/bmp085.c
@@ -402,7 +402,7 @@ exit:
 	return status;
 }
 
-static int bmp085_probe(struct i2c_client *client,
+static int __devinit bmp085_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
 	struct bmp085_data *data;
@@ -438,7 +438,7 @@ exit:
 	return err;
 }
 
-static int bmp085_remove(struct i2c_client *client)
+static int __devexit bmp085_remove(struct i2c_client *client)
 {
 	sysfs_remove_group(&client->dev.kobj, &bmp085_attr_group);
 	kfree(i2c_get_clientdata(client));
@@ -457,7 +457,7 @@ static struct i2c_driver bmp085_driver = {
 	},
 	.id_table	= bmp085_id,
 	.probe		= bmp085_probe,
-	.remove		= bmp085_remove,
+	.remove		= __devexit_p(bmp085_remove),
 
 	.detect		= bmp085_detect,
 	.address_list	= normal_i2c
-- 
1.7.1

