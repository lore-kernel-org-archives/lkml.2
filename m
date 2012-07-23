Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab2GWAxP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 20:53:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42921 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab2GWAxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 20:53:14 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martyn Welch <martyn.welch@ge.com>,
        Manohar Vanga <manohar.vanga@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH] staging/vme: fix checkpatch warnings
Date: Mon, 23 Jul 2012 09:53:07 +0900
Message-Id: <1343004787-9163-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1342875651-16961-1-git-send-email-yamanetoshi@gmail.com>
References: <1342875651-16961-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now checkpatch clean.

$ find drivers/staging/vme -name "*.[ch]"|xargs ./scripts/checkpatch.pl \
-f --terse --nosummary|cut -f3- -d":"|sort |uniq -c|sort -n
      1  ERROR: trailing whitespace
      2  WARNING: Prefer pr_debug(... to printk(KERN_DEBUG, ...
      5  WARNING: Prefer pr_info(... to printk(KERN_INFO, ...
      7  WARNING: Prefer pr_err(... to printk(KERN_ERR, ...
      9  WARNING: quoted string split across lines
     13  WARNING: Prefer pr_warn(... to printk(KERN_WARNING, ...

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/vme/devices/vme_pio2_core.c |   10 ++--
 drivers/staging/vme/devices/vme_user.c      |   71 ++++++++++++---------------
 2 files changed, 36 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_pio2_core.c b/drivers/staging/vme/devices/vme_pio2_core.c
index 4bf8e05..dad8281 100644
--- a/drivers/staging/vme/devices/vme_pio2_core.c
+++ b/drivers/staging/vme/devices/vme_pio2_core.c
@@ -10,6 +10,8 @@
  * option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -163,15 +165,13 @@ static int __init pio2_init(void)
 	int retval = 0;
 
 	if (bus_num == 0) {
-		printk(KERN_ERR "%s: No cards, skipping registration\n",
-			driver_name);
+		pr_err("No cards, skipping registration\n");
 		goto err_nocard;
 	}
 
 	if (bus_num > PIO2_CARDS_MAX) {
-		printk(KERN_ERR
-			"%s: Driver only able to handle %d PIO2 Cards\n",
-			driver_name, PIO2_CARDS_MAX);
+		pr_err("Driver only able to handle %d PIO2 Cards\n",
+		       PIO2_CARDS_MAX);
 		bus_num = PIO2_CARDS_MAX;
 	}
 
diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index e25645e..7d28086 100644
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
@@ -170,7 +172,7 @@ static int vme_user_open(struct inode *inode, struct file *file)
 	mutex_lock(&image[minor].mutex);
 	/* Allow device to be opened if a resource is needed and allocated. */
 	if (minor < CONTROL_MINOR && image[minor].resource == NULL) {
-		printk(KERN_ERR "No resources allocated for device\n");
+		pr_err("No resources allocated for device\n");
 		err = -EINVAL;
 		goto err_res;
 	}
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
@@ -286,7 +288,7 @@ static ssize_t buffer_to_user(unsigned int minor, char __user *buf,
 	retval = __copy_to_user(buf, image_ptr, (unsigned long)count);
 	if (retval != 0) {
 		retval = (count - retval);
-		printk(KERN_WARNING "Partial copy to userspace\n");
+		pr_warn("Partial copy to userspace\n");
 	} else
 		retval = count;
 
@@ -305,7 +307,7 @@ static ssize_t buffer_from_user(unsigned int minor, const char __user *buf,
 	retval = __copy_from_user(image_ptr, buf, (unsigned long)count);
 	if (retval != 0) {
 		retval = (count - retval);
-		printk(KERN_WARNING "Partial copy to userspace\n");
+		pr_warn("Partial copy to userspace\n");
 	} else
 		retval = count;
 
@@ -396,7 +398,7 @@ static ssize_t vme_user_write(struct file *file, const char __user *buf,
 	default:
 		retval = -EINVAL;
 	}
-	
+
 	mutex_unlock(&image[minor].mutex);
 
 	if (retval > 0)
@@ -476,7 +478,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 			copied = copy_from_user(&irq_req, argp,
 						sizeof(struct vme_irq_id));
 			if (copied != 0) {
-				printk(KERN_WARNING "Partial copy from userspace\n");
+				pr_warn("Partial copy from userspace\n");
 				return -EFAULT;
 			}
 
@@ -503,8 +505,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 			copied = copy_to_user(argp, &master,
 				sizeof(struct vme_master));
 			if (copied != 0) {
-				printk(KERN_WARNING "Partial copy to "
-					"userspace\n");
+				pr_warn("Partial copy to userspace\n");
 				return -EFAULT;
 			}
 
@@ -515,8 +516,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 
 			copied = copy_from_user(&master, argp, sizeof(master));
 			if (copied != 0) {
-				printk(KERN_WARNING "Partial copy from "
-					"userspace\n");
+				pr_warn("Partial copy from userspace\n");
 				return -EFAULT;
 			}
 
@@ -546,8 +546,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 			copied = copy_to_user(argp, &slave,
 				sizeof(struct vme_slave));
 			if (copied != 0) {
-				printk(KERN_WARNING "Partial copy to "
-					"userspace\n");
+				pr_warn("Partial copy to userspace\n");
 				return -EFAULT;
 			}
 
@@ -558,8 +557,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 
 			copied = copy_from_user(&slave, argp, sizeof(slave));
 			if (copied != 0) {
-				printk(KERN_WARNING "Partial copy from "
-					"userspace\n");
+				pr_warn("Partial copy from userspace\n");
 				return -EFAULT;
 			}
 
@@ -599,8 +597,8 @@ static void buf_unalloc(int num)
 {
 	if (image[num].kern_buf) {
 #ifdef VME_DEBUG
-		printk(KERN_DEBUG "UniverseII:Releasing buffer at %p\n",
-			image[num].pci_buf);
+		pr_debug("UniverseII:Releasing buffer at %p\n",
+			 image[num].pci_buf);
 #endif
 
 		vme_free_consistent(image[num].resource, image[num].size_buf,
@@ -612,7 +610,7 @@ static void buf_unalloc(int num)
 
 #ifdef VME_DEBUG
 	} else {
-		printk(KERN_DEBUG "UniverseII: Buffer not allocated\n");
+		pr_debug("UniverseII: Buffer not allocated\n");
 #endif
 	}
 }
@@ -629,11 +627,10 @@ static int __init vme_user_init(void)
 {
 	int retval = 0;
 
-	printk(KERN_INFO "VME User Space Access Driver\n");
+	pr_info("VME User Space Access Driver\n");
 
 	if (bus_num == 0) {
-		printk(KERN_ERR "%s: No cards, skipping registration\n",
-			driver_name);
+		pr_err("No cards, skipping registration\n");
 		retval = -ENODEV;
 		goto err_nocard;
 	}
@@ -642,8 +639,8 @@ static int __init vme_user_init(void)
 	 * in future revisions if that ever becomes necessary.
 	 */
 	if (bus_num > VME_USER_BUS_MAX) {
-		printk(KERN_ERR "%s: Driver only able to handle %d buses\n",
-			driver_name, VME_USER_BUS_MAX);
+		pr_err("Driver only able to handle %d buses\n",
+		       VME_USER_BUS_MAX);
 		bus_num = VME_USER_BUS_MAX;
 	}
 
@@ -683,8 +680,7 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
 
 	/* Save pointer to the bridge device */
 	if (vme_user_bridge != NULL) {
-		printk(KERN_ERR "%s: Driver can only be loaded for 1 device\n",
-			driver_name);
+		pr_err("Driver can only be loaded for 1 device\n");
 		err = -EINVAL;
 		goto err_dev;
 	}
@@ -707,8 +703,8 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
 	err = register_chrdev_region(MKDEV(VME_MAJOR, 0), VME_DEVS,
 		driver_name);
 	if (err) {
-		printk(KERN_WARNING "%s: Error getting Major Number %d for "
-		"driver.\n", driver_name, VME_MAJOR);
+		pr_warn("Error getting Major Number %d for driver.\n",
+			VME_MAJOR);
 		goto err_region;
 	}
 
@@ -718,7 +714,7 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
 	vme_user_cdev->owner = THIS_MODULE;
 	err = cdev_add(vme_user_cdev, MKDEV(VME_MAJOR, 0), VME_DEVS);
 	if (err) {
-		printk(KERN_WARNING "%s: cdev_all failed\n", driver_name);
+		pr_warn("cdev_all failed\n");
 		goto err_char;
 	}
 
@@ -732,16 +728,14 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
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
@@ -758,15 +752,13 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
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
@@ -775,7 +767,7 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
 	/* Create sysfs entries - on udev systems this creates the dev files */
 	vme_user_sysfs_class = class_create(THIS_MODULE, driver_name);
 	if (IS_ERR(vme_user_sysfs_class)) {
-		printk(KERN_ERR "Error creating vme_user class.\n");
+		pr_err("Error creating vme_user class.\n");
 		err = PTR_ERR(vme_user_sysfs_class);
 		goto err_class;
 	}
@@ -803,8 +795,7 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
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
1.7.5.4

