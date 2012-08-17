Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab2HQFGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 01:06:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57112 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab2HQFGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 01:06:02 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martyn Welch <martyn.welch@ge.com>,
        Manohar Vanga <manohar.vanga@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 4/5] staging/vme: fix checkpatch warning
Date: Fri, 17 Aug 2012 14:05:54 +0900
Message-Id: <1345179954-8375-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345179867-8266-1-git-send-email-yamanetoshi@gmail.com>
References: <1345179867-8266-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below checkpatch warnings was fixed.

-WARNING: Prefer pr_warn(... to printk(KERN_WARNING, ...

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/vme/devices/vme_user.c |   36 +++++++++++++-------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index ef4b821..e47fc41 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -288,7 +288,7 @@ static ssize_t buffer_to_user(unsigned int minor, char __user *buf,
 	retval = __copy_to_user(buf, image_ptr, (unsigned long)count);
 	if (retval != 0) {
 		retval = (count - retval);
-		printk(KERN_WARNING "Partial copy to userspace\n");
+		pr_warn("Partial copy to userspace\n");
 	} else
 		retval = count;
 
@@ -307,7 +307,7 @@ static ssize_t buffer_from_user(unsigned int minor, const char __user *buf,
 	retval = __copy_from_user(image_ptr, buf, (unsigned long)count);
 	if (retval != 0) {
 		retval = (count - retval);
-		printk(KERN_WARNING "Partial copy to userspace\n");
+		pr_warn("Partial copy to userspace\n");
 	} else
 		retval = count;
 
@@ -478,7 +478,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 			copied = copy_from_user(&irq_req, argp,
 						sizeof(struct vme_irq_id));
 			if (copied != 0) {
-				printk(KERN_WARNING "Partial copy from userspace\n");
+				pr_warn("Partial copy from userspace\n");
 				return -EFAULT;
 			}
 
@@ -505,8 +505,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 			copied = copy_to_user(argp, &master,
 				sizeof(struct vme_master));
 			if (copied != 0) {
-				printk(KERN_WARNING "Partial copy to "
-					"userspace\n");
+				pr_warn("Partial copy to userspace\n");
 				return -EFAULT;
 			}
 
@@ -517,8 +516,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 
 			copied = copy_from_user(&master, argp, sizeof(master));
 			if (copied != 0) {
-				printk(KERN_WARNING "Partial copy from "
-					"userspace\n");
+				pr_warn("Partial copy from userspace\n");
 				return -EFAULT;
 			}
 
@@ -548,8 +546,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 			copied = copy_to_user(argp, &slave,
 				sizeof(struct vme_slave));
 			if (copied != 0) {
-				printk(KERN_WARNING "Partial copy to "
-					"userspace\n");
+				pr_warn("Partial copy to userspace\n");
 				return -EFAULT;
 			}
 
@@ -560,8 +557,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 
 			copied = copy_from_user(&slave, argp, sizeof(slave));
 			if (copied != 0) {
-				printk(KERN_WARNING "Partial copy from "
-					"userspace\n");
+				pr_warn("Partial copy from userspace\n");
 				return -EFAULT;
 			}
 
@@ -709,8 +705,8 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
 	err = register_chrdev_region(MKDEV(VME_MAJOR, 0), VME_DEVS,
 		driver_name);
 	if (err) {
-		printk(KERN_WARNING "%s: Error getting Major Number %d for "
-		"driver.\n", driver_name, VME_MAJOR);
+		pr_warn("Error getting Major Number %d for driver.\n",
+			VME_MAJOR);
 		goto err_region;
 	}
 
@@ -720,7 +716,7 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
 	vme_user_cdev->owner = THIS_MODULE;
 	err = cdev_add(vme_user_cdev, MKDEV(VME_MAJOR, 0), VME_DEVS);
 	if (err) {
-		printk(KERN_WARNING "%s: cdev_all failed\n", driver_name);
+		pr_warn("cdev_all failed\n");
 		goto err_char;
 	}
 
@@ -734,16 +730,14 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
 		image[i].resource = vme_slave_request(vme_user_bridge,
 			VME_A24, VME_SCT);
 		if (image[i].resource == NULL) {
-			printk(KERN_WARNING "Unable to allocate slave "
-				"resource\n");
+			pr_warn("Unable to allocate slave resource\n");
 			goto err_slave;
 		}
 		image[i].size_buf = PCI_BUF_SIZE;
 		image[i].kern_buf = vme_alloc_consistent(image[i].resource,
 			image[i].size_buf, &image[i].pci_buf);
 		if (image[i].kern_buf == NULL) {
-			printk(KERN_WARNING "Unable to allocate memory for "
-				"buffer\n");
+			pr_warn("Unable to allocate memory for buffer\n");
 			image[i].pci_buf = 0;
 			vme_slave_free(image[i].resource);
 			err = -ENOMEM;
@@ -760,15 +754,13 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
 		image[i].resource = vme_master_request(vme_user_bridge,
 			VME_A32, VME_SCT, VME_D32);
 		if (image[i].resource == NULL) {
-			printk(KERN_WARNING "Unable to allocate master "
-				"resource\n");
+			pr_warn("Unable to allocate master resource\n");
 			goto err_master;
 		}
 		image[i].size_buf = PCI_BUF_SIZE;
 		image[i].kern_buf = kmalloc(image[i].size_buf, GFP_KERNEL);
 		if (image[i].kern_buf == NULL) {
-			printk(KERN_WARNING "Unable to allocate memory for "
-				"master window buffers\n");
+			pr_warn("Unable to allocate memory for master window buffers\n");
 			err = -ENOMEM;
 			goto err_master_buf;
 		}
-- 
1.7.9.5

