Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab2HQFF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 01:05:29 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62695 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab2HQFF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 01:05:28 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martyn Welch <martyn.welch@ge.com>,
        Manohar Vanga <manohar.vanga@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 2/5] staging/vme: fix checkpatch warning
Date: Fri, 17 Aug 2012 14:05:20 +0900
Message-Id: <1345179920-8303-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345179867-8266-1-git-send-email-yamanetoshi@gmail.com>
References: <1345179867-8266-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below checkpatch warnings was fixed,

-WARNING: Prefer pr_info(... to printk(KERN_INFO, ...

and added pr_fmt.

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/vme/devices/vme_user.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index e39d273..f12945c 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -15,6 +15,8 @@
  * option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/cdev.h>
 #include <linux/delay.h>
 #include <linux/device.h>
@@ -225,13 +227,13 @@ static ssize_t resource_to_user(int minor, char __user *buf, size_t count,
 			(unsigned long)copied);
 		if (retval != 0) {
 			copied = (copied - retval);
-			printk(KERN_INFO "User copy failed\n");
+			pr_info("User copy failed\n");
 			return -EINVAL;
 		}
 
 	} else {
 		/* XXX Need to write this */
-		printk(KERN_INFO "Currently don't support large transfers\n");
+		pr_info("Currently don't support large transfers\n");
 		/* Map in pages from userspace */
 
 		/* Call vme_master_read to do the transfer */
@@ -265,7 +267,7 @@ static ssize_t resource_from_user(unsigned int minor, const char __user *buf,
 			image[minor].kern_buf, copied, *ppos);
 	} else {
 		/* XXX Need to write this */
-		printk(KERN_INFO "Currently don't support large transfers\n");
+		pr_info("Currently don't support large transfers\n");
 		/* Map in pages from userspace */
 
 		/* Call vme_master_write to do the transfer */
@@ -629,7 +631,7 @@ static int __init vme_user_init(void)
 {
 	int retval = 0;
 
-	printk(KERN_INFO "VME User Space Access Driver\n");
+	pr_info("VME User Space Access Driver\n");
 
 	if (bus_num == 0) {
 		printk(KERN_ERR "%s: No cards, skipping registration\n",
@@ -803,8 +805,7 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
 		image[i].device = device_create(vme_user_sysfs_class, NULL,
 					MKDEV(VME_MAJOR, i), NULL, name, num);
 		if (IS_ERR(image[i].device)) {
-			printk(KERN_INFO "%s: Error creating sysfs device\n",
-				driver_name);
+			pr_info("Error creating sysfs device\n");
 			err = PTR_ERR(image[i].device);
 			goto err_sysfs;
 		}
-- 
1.7.9.5

