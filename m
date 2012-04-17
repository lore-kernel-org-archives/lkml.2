Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab2DQK1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 06:27:55 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64867 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab2DQK1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 06:27:53 -0400
From: Valentin Ilie <valentin.ilie@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Valentin Ilie <valentin.ilie@gmail.com>
Subject: [PATCH] Staging: telephony: phonedev: fixed checkpatch warnings
Date: Tue, 17 Apr 2012 13:27:21 +0300
Message-Id: <1334658441-4805-1-git-send-email-valentin.ilie@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed checkpatch warnings

Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
---
 drivers/staging/telephony/phonedev.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/telephony/phonedev.c b/drivers/staging/telephony/phonedev.c
index 1dd0b67..478aa46 100644
--- a/drivers/staging/telephony/phonedev.c
+++ b/drivers/staging/telephony/phonedev.c
@@ -23,8 +23,7 @@
 #include <linux/errno.h>
 #include <linux/phonedev.h>
 #include <linux/init.h>
-#include <asm/uaccess.h>
-
+#include <linux/uaccess.h>
 #include <linux/kmod.h>
 #include <linux/sem.h>
 #include <linux/mutex.h>
@@ -32,7 +31,7 @@
 #define PHONE_NUM_DEVICES	256
 
 /*
- *    Active devices 
+ *    Active devices
  */
 
 static struct phone_device *phone_device[PHONE_NUM_DEVICES];
@@ -61,9 +60,8 @@ static int phone_open(struct inode *inode, struct file *file)
 		request_module("char-major-%d-%d", PHONE_MAJOR, minor);
 		mutex_lock(&phone_lock);
 		p = phone_device[minor];
-		if (p == NULL || (new_fops = fops_get(p->f_op)) == NULL)
-		{
-			err=-ENODEV;
+		if (p == NULL || (new_fops = fops_get(p->f_op)) == NULL) {
+			err = -ENODEV;
 			goto end;
 		}
 	}
@@ -98,7 +96,7 @@ int phone_register_device(struct phone_device *p, int unit)
 		base = unit;
 		end = unit + 1;  /* enter the loop at least one time */
 	}
-	
+
 	mutex_lock(&phone_lock);
 	for (i = base; i < end; i++) {
 		if (phone_device[i] == NULL) {
@@ -111,6 +109,7 @@ int phone_register_device(struct phone_device *p, int unit)
 	mutex_unlock(&phone_lock);
 	return -ENFILE;
 }
+EXPORT_SYMBOL(phone_register_device);
 
 /*
  *    Unregister an unused Telephony for linux device
@@ -123,10 +122,9 @@ void phone_unregister_device(struct phone_device *pfd)
 		phone_device[pfd->minor] = NULL;
 	mutex_unlock(&phone_lock);
 }
+EXPORT_SYMBOL(phone_unregister_device);
 
-
-static const struct file_operations phone_fops =
-{
+static const struct file_operations phone_fops = {
 	.owner		= THIS_MODULE,
 	.open		= phone_open,
 	.llseek		= noop_llseek,
@@ -135,7 +133,7 @@ static const struct file_operations phone_fops =
 /*
  *	Board init functions
  */
- 
+
 
 /*
  *    Initialise Telephony for linux
@@ -161,6 +159,3 @@ module_init(telephony_init);
 module_exit(telephony_exit);
 
 MODULE_LICENSE("GPL");
-
-EXPORT_SYMBOL(phone_register_device);
-EXPORT_SYMBOL(phone_unregister_device);
-- 
1.7.9.5

