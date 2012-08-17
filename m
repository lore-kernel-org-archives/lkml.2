Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab2HQFGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 01:06:23 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51584 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab2HQFGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 01:06:20 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martyn Welch <martyn.welch@ge.com>,
        Manohar Vanga <manohar.vanga@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 5/5] staging/vme: fix checkpatch warning
Date: Fri, 17 Aug 2012 14:06:13 +0900
Message-Id: <1345179973-8410-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345179867-8266-1-git-send-email-yamanetoshi@gmail.com>
References: <1345179867-8266-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below checkpatch warnings was fixed,

-WARNING: Prefer pr_err(... to printk(KERN_ERR, ...

and added pr_fmt.

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/vme/devices/vme_pio2_core.c |   10 +++++-----
 drivers/staging/vme/devices/vme_user.c      |   14 ++++++--------
 2 files changed, 11 insertions(+), 13 deletions(-)

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
index e47fc41..7d28086 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -172,7 +172,7 @@ static int vme_user_open(struct inode *inode, struct file *file)
 	mutex_lock(&image[minor].mutex);
 	/* Allow device to be opened if a resource is needed and allocated. */
 	if (minor < CONTROL_MINOR && image[minor].resource == NULL) {
-		printk(KERN_ERR "No resources allocated for device\n");
+		pr_err("No resources allocated for device\n");
 		err = -EINVAL;
 		goto err_res;
 	}
@@ -630,8 +630,7 @@ static int __init vme_user_init(void)
 	pr_info("VME User Space Access Driver\n");
 
 	if (bus_num == 0) {
-		printk(KERN_ERR "%s: No cards, skipping registration\n",
-			driver_name);
+		pr_err("No cards, skipping registration\n");
 		retval = -ENODEV;
 		goto err_nocard;
 	}
@@ -640,8 +639,8 @@ static int __init vme_user_init(void)
 	 * in future revisions if that ever becomes necessary.
 	 */
 	if (bus_num > VME_USER_BUS_MAX) {
-		printk(KERN_ERR "%s: Driver only able to handle %d buses\n",
-			driver_name, VME_USER_BUS_MAX);
+		pr_err("Driver only able to handle %d buses\n",
+		       VME_USER_BUS_MAX);
 		bus_num = VME_USER_BUS_MAX;
 	}
 
@@ -681,8 +680,7 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
 
 	/* Save pointer to the bridge device */
 	if (vme_user_bridge != NULL) {
-		printk(KERN_ERR "%s: Driver can only be loaded for 1 device\n",
-			driver_name);
+		pr_err("Driver can only be loaded for 1 device\n");
 		err = -EINVAL;
 		goto err_dev;
 	}
@@ -769,7 +767,7 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
 	/* Create sysfs entries - on udev systems this creates the dev files */
 	vme_user_sysfs_class = class_create(THIS_MODULE, driver_name);
 	if (IS_ERR(vme_user_sysfs_class)) {
-		printk(KERN_ERR "Error creating vme_user class.\n");
+		pr_err("Error creating vme_user class.\n");
 		err = PTR_ERR(vme_user_sysfs_class);
 		goto err_class;
 	}
-- 
1.7.9.5

