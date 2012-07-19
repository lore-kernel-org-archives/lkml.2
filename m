Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab2GSBIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:08:51 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:63594 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab2GSBIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:08:50 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>, David Taht <d@teklibre.com>,
        linux-kernel@vger.kernel.org
Cc: Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH] staging/frontier: fix checkpatch warnings
Date: Thu, 19 Jul 2012 10:08:42 +0900
Message-Id: <1342660122-8008-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below checkpatch warns was fixed,

drivers/staging/frontier/tranzport.c:356: WARNING: Prefer pr_err(... to printk(KERN_ERR, ...
drivers/staging/frontier/tranzport.c:523: WARNING: Prefer pr_err(... to printk(KERN_ERR, ...
drivers/staging/frontier/tranzport.c:696: WARNING: Prefer pr_err(... to printk(KERN_ERR, ...
drivers/staging/frontier/alphatrack.c:336: WARNING: Prefer pr_err(... to printk(KERN_ERR, ...
drivers/staging/frontier/alphatrack.c:497: WARNING: Prefer pr_err(... to printk(KERN_ERR, ...
drivers/staging/frontier/alphatrack.c:568: WARNING: Prefer pr_err(... to printk(KERN_ERR, ...

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/frontier/alphatrack.c |    6 +++---
 drivers/staging/frontier/tranzport.c  |   12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/frontier/alphatrack.c b/drivers/staging/frontier/alphatrack.c
index acbb2cc..33085782 100644
--- a/drivers/staging/frontier/alphatrack.c
+++ b/drivers/staging/frontier/alphatrack.c
@@ -333,7 +333,7 @@ static int usb_alphatrack_open(struct inode *inode, struct file *file)
 	interface = usb_find_interface(&usb_alphatrack_driver, subminor);
 
 	if (!interface) {
-		printk(KERN_ERR "%s - error, can't find device for minor %d\n",
+		pr_err("%s - error, can't find device for minor %d\n",
 		       __func__, subminor);
 		retval = -ENODEV;
 		goto unlock_disconnect_exit;
@@ -494,7 +494,7 @@ static ssize_t usb_alphatrack_read(struct file *file, char __user *buffer,
 	/* verify that the device wasn't unplugged */
 	if (dev->intf == NULL) {
 		retval = -ENODEV;
-		printk(KERN_ERR "%s: No device or device unplugged %d\n",
+		pr_err("%s: No device or device unplugged %d\n",
 		       __func__, retval);
 		goto unlock_exit;
 	}
@@ -565,7 +565,7 @@ static ssize_t usb_alphatrack_write(struct file *file,
 	/* verify that the device wasn't unplugged */
 	if (dev->intf == NULL) {
 		retval = -ENODEV;
-		printk(KERN_ERR "%s: No device or device unplugged %d\n",
+		pr_err("%s: No device or device unplugged %d\n",
 		       __func__, retval);
 		goto unlock_exit;
 	}
diff --git a/drivers/staging/frontier/tranzport.c b/drivers/staging/frontier/tranzport.c
index 376706f..5196a4e 100644
--- a/drivers/staging/frontier/tranzport.c
+++ b/drivers/staging/frontier/tranzport.c
@@ -353,8 +353,8 @@ static int usb_tranzport_open(struct inode *inode, struct file *file)
 	interface = usb_find_interface(&usb_tranzport_driver, subminor);
 
 	if (!interface) {
-		printk(KERN_ERR "%s - error, can't find device for minor %d\n",
-			__func__, subminor);
+		pr_err("%s - error, can't find device for minor %d\n",
+		       __func__, subminor);
 		retval = -ENODEV;
 		goto unlock_disconnect_exit;
 	}
@@ -520,8 +520,8 @@ static ssize_t usb_tranzport_read(struct file *file, char __user *buffer,
 	/* verify that the device wasn't unplugged */
 	if (dev->intf == NULL) {
 		retval = -ENODEV;
-		printk(KERN_ERR "%s: No device or device unplugged %d\n",
-			__func__, retval);
+		pr_err("%s: No device or device unplugged %d\n",
+		       __func__, retval);
 		goto unlock_exit;
 	}
 
@@ -693,8 +693,8 @@ static ssize_t usb_tranzport_write(struct file *file,
 	/* verify that the device wasn't unplugged */
 	if (dev->intf == NULL) {
 		retval = -ENODEV;
-		printk(KERN_ERR "%s: No device or device unplugged %d\n",
-			__func__, retval);
+		pr_err("%s: No device or device unplugged %d\n",
+		       __func__, retval);
 		goto unlock_exit;
 	}
 
-- 
1.7.5.4

