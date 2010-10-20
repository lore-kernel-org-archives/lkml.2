Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596Ab0JTG4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:56:54 -0400
Received: from mail.perches.com ([173.55.12.10]:3220 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758378Ab0JTGwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:52:09 -0400
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/32] drivers/hwmon/f71805f.c: Use pr_fmt and pr_<level>
Date: Tue, 19 Oct 2010 23:51:33 -0700
Message-Id: <23cbb0d31160c359e187431af643865d0872a5a3.1287556801.git.joe@perches.com>
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
 drivers/hwmon/f71805f.c |   29 +++++++++++++----------------
 1 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/hwmon/f71805f.c b/drivers/hwmon/f71805f.c
index 525a00b..92f9497 100644
--- a/drivers/hwmon/f71805f.c
+++ b/drivers/hwmon/f71805f.c
@@ -28,6 +28,8 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -1309,7 +1311,7 @@ static int __devinit f71805f_probe(struct platform_device *pdev)
 
 	if (!(data = kzalloc(sizeof(struct f71805f_data), GFP_KERNEL))) {
 		err = -ENOMEM;
-		printk(KERN_ERR DRVNAME ": Out of memory\n");
+		pr_err("Out of memory\n");
 		goto exit;
 	}
 
@@ -1451,7 +1453,7 @@ static int __init f71805f_device_add(unsigned short address,
 	pdev = platform_device_alloc(DRVNAME, address);
 	if (!pdev) {
 		err = -ENOMEM;
-		printk(KERN_ERR DRVNAME ": Device allocation failed\n");
+		pr_err("Device allocation failed\n");
 		goto exit;
 	}
 
@@ -1462,22 +1464,20 @@ static int __init f71805f_device_add(unsigned short address,
 
 	err = platform_device_add_resources(pdev, &res, 1);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device resource addition failed "
-		       "(%d)\n", err);
+		pr_err("Device resource addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
 	err = platform_device_add_data(pdev, sio_data,
 				       sizeof(struct f71805f_sio_data));
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Platform data allocation failed\n");
+		pr_err("Platform data allocation failed\n");
 		goto exit_device_put;
 	}
 
 	err = platform_device_add(pdev);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device addition failed (%d)\n",
-		       err);
+		pr_err("Device addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
@@ -1516,30 +1516,27 @@ static int __init f71805f_find(int sioaddr, unsigned short *address,
 		sio_data->fnsel1 = superio_inb(sioaddr, SIO_REG_FNSEL1);
 		break;
 	default:
-		printk(KERN_INFO DRVNAME ": Unsupported Fintek device, "
-		       "skipping\n");
+		pr_info("Unsupported Fintek device, skipping\n");
 		goto exit;
 	}
 
 	superio_select(sioaddr, F71805F_LD_HWM);
 	if (!(superio_inb(sioaddr, SIO_REG_ENABLE) & 0x01)) {
-		printk(KERN_WARNING DRVNAME ": Device not activated, "
-		       "skipping\n");
+		pr_warn("Device not activated, skipping\n");
 		goto exit;
 	}
 
 	*address = superio_inw(sioaddr, SIO_REG_ADDR);
 	if (*address == 0) {
-		printk(KERN_WARNING DRVNAME ": Base address not set, "
-		       "skipping\n");
+		pr_warn("Base address not set, skipping\n");
 		goto exit;
 	}
 	*address &= ~(REGION_LENGTH - 1);	/* Ignore 3 LSB */
 
 	err = 0;
-	printk(KERN_INFO DRVNAME ": Found %s chip at %#x, revision %u\n",
-	       names[sio_data->kind], *address,
-	       superio_inb(sioaddr, SIO_REG_DEVREV));
+	pr_info("Found %s chip at %#x, revision %u\n",
+		names[sio_data->kind], *address,
+		superio_inb(sioaddr, SIO_REG_DEVREV));
 
 exit:
 	superio_exit(sioaddr);
-- 
1.7.3.1.g432b3.dirty

