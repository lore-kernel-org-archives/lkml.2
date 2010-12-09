Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396Ab0LIKYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 05:24:46 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:37595 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323Ab0LIKYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 05:24:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=m5W/ycEJQ/AxAnmxv7Qur3Vk4WFX0rgyJ+ekcFeaqx4BNWXmpVNcTdGnJ0ryBZfD+l
         jsOqBIzk4LbslTLm17WG80FSNqb9D3XLTA0Hs/oasgo5etlkyZ3l+e9m3R8LGls5CwOs
         pDqE4X9HvnZi9OOJhBwXddlwndGDW6yXp4wuQ=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 8/8] staging: ft1000: Fix debug messages.
Date: Thu,  9 Dec 2010 11:26:53 +0100
Message-Id: <1291890413-15255-9-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291890413-15255-1-git-send-email-marek.belisko@open-nandra.com>
References: <1291890413-15255-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
index d249c8a..da76f11 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -148,18 +148,18 @@ int ft1000_create_dev(struct ft1000_device *dev)
     // make a new device name
     sprintf(info->DeviceName, "%s%d", "FT1000_", info->CardNumber);
 
-    DEBUG("ft1000_CreateDevice: number of instance = %d\n", ft1000_flarion_cnt);
+    DEBUG("%s: number of instance = %d\n", __func__, ft1000_flarion_cnt);
     DEBUG("DeviceCreated = %x\n", info->DeviceCreated);
 
     if (info->DeviceCreated)
     {
-	DEBUG("ft1000_CreateDevice: \"%s\" already registered\n", info->DeviceName);
+	DEBUG("%s: \"%s\" already registered\n", __func__, info->DeviceName);
 	return -EIO;
     }
 
 
     // register the device
-    DEBUG("ft1000_CreateDevice: \"%s\" device registration\n", info->DeviceName);
+    DEBUG("%s: \"%s\" debugfs device registration\n", __func__, info->DeviceName);
 
 	tmp = kmalloc(sizeof(struct ft1000_debug_dirs), GFP_KERNEL);
 	if (tmp == NULL) {
@@ -185,7 +185,7 @@ int ft1000_create_dev(struct ft1000_device *dev)
 	tmp->int_number = info->CardNumber;
 	list_add(&(tmp->list), &(info->nodes.list));
 
-    DEBUG("ft1000_CreateDevice: registered char device \"%s\"\n", info->DeviceName);
+    DEBUG("%s: registered debugfs directory \"%s\"\n", __func__, info->DeviceName);
 
     // initialize application information
     info->appcnt = 0;
@@ -234,7 +234,7 @@ void ft1000_destroy_dev(struct net_device *dev)
 	struct list_head *pos, *q;
 	struct ft1000_debug_dirs *dir;
 
-    DEBUG("ft1000_chdev:ft1000_DestroyDevice called\n");
+    DEBUG("%s called\n", __func__);
 
 
 
@@ -250,7 +250,7 @@ void ft1000_destroy_dev(struct net_device *dev)
 				kfree(dir);
 			}
 		}
-		DEBUG("ft1000_DestroyDevice: unregistered device \"%s\"\n",
+		DEBUG("%s: unregistered device \"%s\"\n", __func__,
 					   info->DeviceName);
 
         // Make sure we free any memory reserve for slow Queue
@@ -295,7 +295,7 @@ static int ft1000_open (struct inode *inode, struct file *file)
 	struct ft1000_device *dev = (struct ft1000_device *)inode->i_private;
     int i,num;
 
-    DEBUG("ft1000_open called\n");
+    DEBUG("%s called\n", __func__);
     num = (MINOR(inode->i_rdev) & 0xf);
     DEBUG("ft1000_open: minor number=%d\n", num);
 
-- 
1.7.1

