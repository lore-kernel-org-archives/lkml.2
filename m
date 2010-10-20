Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394Ab0JTGw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:52:26 -0400
Received: from mail.perches.com ([173.55.12.10]:3257 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932233Ab0JTGwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:52:19 -0400
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Juerg Haefliger <juergh@gmail.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 28/32] drivers/hwmon/vt1211.c: Use pr_fmt and pr_<level>
Date: Tue, 19 Oct 2010 23:51:52 -0700
Message-Id: <d95988253a87f5d8367607266ab92792f90ffd34.1287556801.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <20101020035346.GA20178@ericsson.com>
References: <20101020035346.GA20178@ericsson.com>
In-Reply-To: <cover.1287556800.git.joe@perches.com>
References: <cover.1287556800.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added #define pr_fmt KBUILD_MODNAME ": " fmt
Converted printks to pr_<level>
Coalesced any long formats
Removed prefixes from formats

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/hwmon/vt1211.c |   30 +++++++++++++-----------------
 1 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/hwmon/vt1211.c b/drivers/hwmon/vt1211.c
index ae33bbb..77648c4 100644
--- a/drivers/hwmon/vt1211.c
+++ b/drivers/hwmon/vt1211.c
@@ -21,6 +21,8 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -1254,8 +1256,7 @@ static int __init vt1211_device_add(unsigned short address)
 	pdev = platform_device_alloc(DRVNAME, address);
 	if (!pdev) {
 		err = -ENOMEM;
-		printk(KERN_ERR DRVNAME ": Device allocation failed (%d)\n",
-		       err);
+		pr_err("Device allocation failed (%d)\n", err);
 		goto EXIT;
 	}
 
@@ -1266,15 +1267,13 @@ static int __init vt1211_device_add(unsigned short address)
 
 	err = platform_device_add_resources(pdev, &res, 1);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device resource addition failed "
-		       "(%d)\n", err);
+		pr_err("Device resource addition failed (%d)\n", err);
 		goto EXIT_DEV_PUT;
 	}
 
 	err = platform_device_add(pdev);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device addition failed (%d)\n",
-		       err);
+		pr_err("Device addition failed (%d)\n", err);
 		goto EXIT_DEV_PUT;
 	}
 
@@ -1301,23 +1300,20 @@ static int __init vt1211_find(int sio_cip, unsigned short *address)
 	superio_select(sio_cip, SIO_VT1211_LDN_HWMON);
 
 	if ((superio_inb(sio_cip, SIO_VT1211_ACTIVE) & 1) == 0) {
-		printk(KERN_WARNING DRVNAME ": HW monitor is disabled, "
-		       "skipping\n");
+		pr_warn("HW monitor is disabled, skipping\n");
 		goto EXIT;
 	}
 
 	*address = ((superio_inb(sio_cip, SIO_VT1211_BADDR) << 8) |
 		    (superio_inb(sio_cip, SIO_VT1211_BADDR + 1))) & 0xff00;
 	if (*address == 0) {
-		printk(KERN_WARNING DRVNAME ": Base address is not set, "
-		       "skipping\n");
+		pr_warn("Base address is not set, skipping\n");
 		goto EXIT;
 	}
 
 	err = 0;
-	printk(KERN_INFO DRVNAME ": Found VT1211 chip at 0x%04x, "
-	       "revision %u\n", *address,
-	       superio_inb(sio_cip, SIO_VT1211_DEVREV));
+	pr_info("Found VT1211 chip at 0x%04x, revision %u\n",
+		*address, superio_inb(sio_cip, SIO_VT1211_DEVREV));
 
 EXIT:
 	superio_exit(sio_cip);
@@ -1336,15 +1332,15 @@ static int __init vt1211_init(void)
 
 	if ((uch_config < -1) || (uch_config > 31)) {
 		err = -EINVAL;
-		printk(KERN_WARNING DRVNAME ": Invalid UCH configuration %d. "
-		       "Choose a value between 0 and 31.\n", uch_config);
+		pr_warn("Invalid UCH configuration %d. Choose a value between 0 and 31.\n",
+			uch_config);
 	  goto EXIT;
 	}
 
 	if ((int_mode < -1) || (int_mode > 0)) {
 		err = -EINVAL;
-		printk(KERN_WARNING DRVNAME ": Invalid interrupt mode %d. "
-		       "Only mode 0 is supported.\n", int_mode);
+		pr_warn("Invalid interrupt mode %d. Only mode 0 is supported.\n",
+			int_mode);
 	  goto EXIT;
 	}
 
-- 
1.7.3.1.g432b3.dirty

