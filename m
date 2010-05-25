Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab0EYNbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 09:31:48 -0400
Received: from mail.ampazis.com ([86.35.2.10]:33221 "EHLO enigma.wired-net.gr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756943Ab0EYNbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 09:31:42 -0400
X-Greylist: delayed 1311 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 May 2010 09:31:40 EDT
From: nanakos@wired-net.gr
To: gregkh@suse.de
Cc: martyn.welch@ge.com, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org,
       Nanakos Chrysostomos <nanakos@wired-net.gr>
Subject: [PATCH] Staging: vme: devices: vme_user.c: fixed ERRORS and WARNINGS
Date: Tue, 25 May 2010 13:09:32 +0000
Message-Id: <1274792972-4620-1-git-send-email-nanakos@wired-net.gr>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nanakos Chrysostomos <nanakos@wired-net.gr>

Fixed ERRORS and WARNINGS

Signed-off-by: Nanakos Chrysostomos <nanakos@wired-net.gr>
---
 drivers/staging/vme/devices/vme_user.c |   90 +++++++++++++++----------------
 1 files changed, 44 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index bc16fc0..727dc0c 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -34,8 +34,8 @@
 #include <linux/smp_lock.h>
 #include <linux/types.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
 #include "../vme.h"
 #include "vme_user.h"
@@ -48,19 +48,19 @@ static int bus_num;
 /* Currently Documentation/devices.txt defines the following for VME:
  *
  * 221 char	VME bus
- * 		  0 = /dev/bus/vme/m0		First master image
- * 		  1 = /dev/bus/vme/m1		Second master image
- * 		  2 = /dev/bus/vme/m2		Third master image
- * 		  3 = /dev/bus/vme/m3		Fourth master image
- * 		  4 = /dev/bus/vme/s0		First slave image
- * 		  5 = /dev/bus/vme/s1		Second slave image
- * 		  6 = /dev/bus/vme/s2		Third slave image
- * 		  7 = /dev/bus/vme/s3		Fourth slave image
- * 		  8 = /dev/bus/vme/ctl		Control
+ *		0 = /dev/bus/vme/m0		First master image
+ *		1 = /dev/bus/vme/m1		Second master image
+ *		2 = /dev/bus/vme/m2		Third master image
+ *		3 = /dev/bus/vme/m3		Fourth master image
+ *		4 = /dev/bus/vme/s0		First slave image
+ *		5 = /dev/bus/vme/s1		Second slave image
+ *		6 = /dev/bus/vme/s2		Third slave image
+ *		7 = /dev/bus/vme/s3		Fourth slave image
+ *		8 = /dev/bus/vme/ctl		Control
  *
- * 		It is expected that all VME bus drivers will use the
- * 		same interface.  For interface documentation see
- * 		http://www.vmelinux.org/.
+ *		It is expected that all VME bus drivers will use the
+ *		same interface.  For interface documentation see
+ *		http://www.vmelinux.org/.
  *
  * However the VME driver at http://www.vmelinux.org/ is rather old and doesn't
  * even support the tsi148 chipset (which has 8 master and 8 slave windows).
@@ -136,13 +136,13 @@ static long vme_user_unlocked_ioctl(struct file *, unsigned int, unsigned long);
 static int __init vme_user_probe(struct device *, int, int);
 static int __exit vme_user_remove(struct device *, int, int);
 
-static struct file_operations vme_user_fops = {
-        .open = vme_user_open,
-        .release = vme_user_release,
-        .read = vme_user_read,
-        .write = vme_user_write,
-        .llseek = vme_user_llseek,
-        .unlocked_ioctl = vme_user_unlocked_ioctl,
+const static struct file_operations vme_user_fops = {
+	.open = vme_user_open,
+	.release = vme_user_release,
+	.read = vme_user_read,
+	.write = vme_user_write,
+	.llseek = vme_user_llseek,
+	.unlocked_ioctl = vme_user_unlocked_ioctl,
 };
 
 
@@ -151,13 +151,13 @@ static struct file_operations vme_user_fops = {
  */
 static void reset_counters(void)
 {
-        statistics.reads = 0;
-        statistics.writes = 0;
-        statistics.ioctls = 0;
-        statistics.irqs = 0;
-        statistics.berrs = 0;
-        statistics.dmaErrors = 0;
-        statistics.timeouts = 0;
+	statistics.reads = 0;
+	statistics.writes = 0;
+	statistics.ioctls = 0;
+	statistics.irqs = 0;
+	statistics.berrs = 0;
+	statistics.dmaErrors = 0;
+	statistics.timeouts = 0;
 }
 
 static int vme_user_open(struct inode *inode, struct file *file)
@@ -216,9 +216,8 @@ static ssize_t resource_to_user(int minor, char __user *buf, size_t count,
 		/* We copy to kernel buffer */
 		copied = vme_master_read(image[minor].resource,
 			image[minor].kern_buf, count, *ppos);
-		if (copied < 0) {
+		if (copied < 0)
 			return (int)copied;
-		}
 
 		retval = __copy_to_user(buf, image[minor].kern_buf,
 			(unsigned long)copied);
@@ -313,7 +312,7 @@ static ssize_t buffer_from_user(unsigned int minor, const char *buf,
 }
 
 static ssize_t vme_user_read(struct file *file, char *buf, size_t count,
-			loff_t * ppos)
+			loff_t *ppos)
 {
 	unsigned int minor = MINOR(file->f_dentry->d_inode->i_rdev);
 	ssize_t retval;
@@ -337,7 +336,7 @@ static ssize_t vme_user_read(struct file *file, char *buf, size_t count,
 	else
 		okcount = count;
 
-	switch (type[minor]){
+	switch (type[minor]) {
 	case MASTER_MINOR:
 		retval = resource_to_user(minor, buf, okcount, ppos);
 		break;
@@ -380,7 +379,7 @@ static ssize_t vme_user_write(struct file *file, const char *buf, size_t count,
 	else
 		okcount = count;
 
-	switch (type[minor]){
+	switch (type[minor]) {
 	case MASTER_MINOR:
 		retval = resource_from_user(minor, buf, okcount, ppos);
 		break;
@@ -571,7 +570,7 @@ vme_user_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 /*
  * Unallocate a previously allocated buffer
  */
-static void buf_unalloc (int num)
+static void buf_unalloc(int num)
 {
 	if (image[num].kern_buf) {
 #ifdef VME_DEBUG
@@ -594,8 +593,8 @@ static void buf_unalloc (int num)
 }
 
 static struct vme_driver vme_user_driver = {
-        .name = driver_name,
-        .probe = vme_user_probe,
+	.name = driver_name,
+	.probe = vme_user_probe,
 	.remove = vme_user_remove,
 };
 
@@ -770,16 +769,16 @@ static int __init vme_user_probe(struct device *dev, int cur_bus, int cur_slot)
 	}
 
 	/* Add sysfs Entries */
-	for (i=0; i<VME_DEVS; i++) {
+	for (i = 0; i < VME_DEVS; i++) {
 		switch (type[i]) {
 		case MASTER_MINOR:
-			sprintf(name,"bus/vme/m%%d");
+			sprintf(name, "bus/vme/m%%d");
 			break;
 		case CONTROL_MINOR:
-			sprintf(name,"bus/vme/ctl");
+			sprintf(name, "bus/vme/ctl");
 			break;
 		case SLAVE_MINOR:
-			sprintf(name,"bus/vme/s%%d");
+			sprintf(name, "bus/vme/s%%d");
 			break;
 		default:
 			err = -EINVAL;
@@ -788,9 +787,9 @@ static int __init vme_user_probe(struct device *dev, int cur_bus, int cur_slot)
 		}
 
 		image[i].device =
-			device_create(vme_user_sysfs_class, NULL,
-				MKDEV(VME_MAJOR, i), NULL, name,
-				(type[i] == SLAVE_MINOR)? i - (MASTER_MAX + 1) : i);
+		   device_create(vme_user_sysfs_class, NULL,
+			MKDEV(VME_MAJOR, i), NULL, name,
+			(type[i] == SLAVE_MINOR) ? i - (MASTER_MAX + 1) : i);
 		if (IS_ERR(image[i].device)) {
 			printk("%s: Error creating sysfs device\n",
 				driver_name);
@@ -804,7 +803,7 @@ static int __init vme_user_probe(struct device *dev, int cur_bus, int cur_slot)
 	/* Ensure counter set correcty to destroy all sysfs devices */
 	i = VME_DEVS;
 err_sysfs:
-	while (i > 0){
+	while (i > 0) {
 		i--;
 		device_destroy(vme_user_sysfs_class, MKDEV(VME_MAJOR, i));
 	}
@@ -845,9 +844,8 @@ static int __exit vme_user_remove(struct device *dev, int cur_bus, int cur_slot)
 	int i;
 
 	/* Remove sysfs Entries */
-	for(i=0; i<VME_DEVS; i++) {
+	for (i = 0; i < VME_DEVS; i++)
 		device_destroy(vme_user_sysfs_class, MKDEV(VME_MAJOR, i));
-	}
 	class_destroy(vme_user_sysfs_class);
 
 	for (i = MASTER_MINOR; i < (MASTER_MAX + 1); i++)
-- 
1.5.6.5

