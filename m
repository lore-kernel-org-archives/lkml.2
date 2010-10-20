Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab0JTGwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:52:22 -0400
Received: from mail.perches.com ([173.55.12.10]:3257 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932246Ab0JTGwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:52:20 -0400
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [PATCH 30/32] drivers/hwmon/w83627ehf.c: Use pr_fmt and pr_<level>
Date: Tue, 19 Oct 2010 23:51:54 -0700
Message-Id: <1ad0784ebd2944f51677c3be40a17e4b63a22dd0.1287556801.git.joe@perches.com>
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
 drivers/hwmon/w83627ehf.c |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index 072c580..073eabe 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -42,6 +42,8 @@
     w83667hg-b   9      5       3       3      0xb350 0xc1    0x5ca3
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -1668,8 +1670,7 @@ static int __init w83627ehf_find(int sioaddr, unsigned short *addr,
 		break;
 	default:
 		if (val != 0xffff)
-			pr_debug(DRVNAME ": unsupported chip ID: 0x%04x\n",
-				 val);
+			pr_debug("unsupported chip ID: 0x%04x\n", val);
 		superio_exit(sioaddr);
 		return -ENODEV;
 	}
@@ -1680,8 +1681,7 @@ static int __init w83627ehf_find(int sioaddr, unsigned short *addr,
 	    | superio_inb(sioaddr, SIO_REG_ADDR + 1);
 	*addr = val & IOREGION_ALIGNMENT;
 	if (*addr == 0) {
-		printk(KERN_ERR DRVNAME ": Refusing to enable a Super-I/O "
-		       "device with a base I/O port 0.\n");
+		pr_err("Refusing to enable a Super-I/O device with a base I/O port 0\n");
 		superio_exit(sioaddr);
 		return -ENODEV;
 	}
@@ -1689,13 +1689,12 @@ static int __init w83627ehf_find(int sioaddr, unsigned short *addr,
 	/* Activate logical device if needed */
 	val = superio_inb(sioaddr, SIO_REG_ENABLE);
 	if (!(val & 0x01)) {
-		printk(KERN_WARNING DRVNAME ": Forcibly enabling Super-I/O. "
-		       "Sensor is probably unusable.\n");
+		pr_warn("Forcibly enabling Super-I/O. Sensor is probably unusable.\n");
 		superio_outb(sioaddr, SIO_REG_ENABLE, val | 0x01);
 	}
 
 	superio_exit(sioaddr);
-	pr_info(DRVNAME ": Found %s chip at %#x\n", sio_name, *addr);
+	pr_info("Found %s chip at %#x\n", sio_name, *addr);
 	sio_data->sioreg = sioaddr;
 
 	return 0;
@@ -1729,14 +1728,14 @@ static int __init sensors_w83627ehf_init(void)
 
 	if (!(pdev = platform_device_alloc(DRVNAME, address))) {
 		err = -ENOMEM;
-		printk(KERN_ERR DRVNAME ": Device allocation failed\n");
+		pr_err("Device allocation failed\n");
 		goto exit_unregister;
 	}
 
 	err = platform_device_add_data(pdev, &sio_data,
 				       sizeof(struct w83627ehf_sio_data));
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Platform data allocation failed\n");
+		pr_err("Platform data allocation failed\n");
 		goto exit_device_put;
 	}
 
@@ -1752,16 +1751,14 @@ static int __init sensors_w83627ehf_init(void)
 
 	err = platform_device_add_resources(pdev, &res, 1);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device resource addition failed "
-		       "(%d)\n", err);
+		pr_err("Device resource addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
 	/* platform_device_add calls probe() */
 	err = platform_device_add(pdev);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device addition failed (%d)\n",
-		       err);
+		pr_err("Device addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
-- 
1.7.3.1.g432b3.dirty

