Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503Ab0JTGz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:55:57 -0400
Received: from mail.perches.com ([173.55.12.10]:3235 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758409Ab0JTGwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:52:13 -0400
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Eric Piel <eric.piel@tremplin-utc.net>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 16/32] drivers/hwmon/lis3lv02d.c: Use pr_fmt and pr_<level>
Date: Tue, 19 Oct 2010 23:51:40 -0700
Message-Id: <cdcaec8e81d54f31be9003f5f57453c46b160960.1287556801.git.joe@perches.com>
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
 drivers/hwmon/lis3lv02d.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index 25f3850..fcedcae 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -20,6 +20,8 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/dmi.h>
@@ -673,8 +675,7 @@ static void lis3lv02d_8b_configure(struct lis3lv02d *dev,
 					IRQF_ONESHOT,
 					DRIVER_NAME, &lis3_dev);
 		if (err < 0)
-			printk(KERN_ERR DRIVER_NAME
-				"No second IRQ. Limited functionality\n");
+			pr_err("No second IRQ. Limited functionality\n");
 	}
 }
 
@@ -691,7 +692,7 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 
 	switch (dev->whoami) {
 	case WAI_12B:
-		printk(KERN_INFO DRIVER_NAME ": 12 bits sensor found\n");
+		pr_info("12 bits sensor found\n");
 		dev->read_data = lis3lv02d_read_12;
 		dev->mdps_max_val = 2048;
 		dev->pwron_delay = LIS3_PWRON_DELAY_WAI_12B;
@@ -700,7 +701,7 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 		dev->scale = LIS3_SENSITIVITY_12B;
 		break;
 	case WAI_8B:
-		printk(KERN_INFO DRIVER_NAME ": 8 bits sensor found\n");
+		pr_info("8 bits sensor found\n");
 		dev->read_data = lis3lv02d_read_8;
 		dev->mdps_max_val = 128;
 		dev->pwron_delay = LIS3_PWRON_DELAY_WAI_8B;
@@ -709,7 +710,7 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 		dev->scale = LIS3_SENSITIVITY_8B;
 		break;
 	case WAI_3DC:
-		printk(KERN_INFO DRIVER_NAME ": 8 bits 3DC sensor found\n");
+		pr_info("8 bits 3DC sensor found\n");
 		dev->read_data = lis3lv02d_read_8;
 		dev->mdps_max_val = 128;
 		dev->pwron_delay = LIS3_PWRON_DELAY_WAI_8B;
@@ -718,8 +719,7 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 		dev->scale = LIS3_SENSITIVITY_8B;
 		break;
 	default:
-		printk(KERN_ERR DRIVER_NAME
-			": unknown sensor type 0x%X\n", dev->whoami);
+		pr_err("unknown sensor type 0x%X\n", dev->whoami);
 		return -EINVAL;
 	}
 
@@ -729,7 +729,7 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 	lis3lv02d_poweron(dev);
 
 	if (lis3lv02d_joystick_enable())
-		printk(KERN_ERR DRIVER_NAME ": joystick initialization failed\n");
+		pr_err("joystick initialization failed\n");
 
 	/* passing in platform specific data is purely optional and only
 	 * used by the SPI transport layer at the moment */
@@ -745,8 +745,7 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 
 	/* bail if we did not get an IRQ from the bus layer */
 	if (!dev->irq) {
-		printk(KERN_ERR DRIVER_NAME
-			": No IRQ. Disabling /dev/freefall\n");
+		pr_err("No IRQ. Disabling /dev/freefall\n");
 		goto out;
 	}
 
@@ -772,12 +771,12 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 				DRIVER_NAME, &lis3_dev);
 
 	if (err < 0) {
-		printk(KERN_ERR DRIVER_NAME "Cannot get IRQ\n");
+		pr_err("Cannot get IRQ\n");
 		goto out;
 	}
 
 	if (misc_register(&lis3lv02d_misc_device))
-		printk(KERN_ERR DRIVER_NAME ": misc_register failed\n");
+		pr_err("misc_register failed\n");
 out:
 	return 0;
 }
-- 
1.7.3.1.g432b3.dirty

