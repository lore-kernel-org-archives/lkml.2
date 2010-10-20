Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab0JTG4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:56:20 -0400
Received: from mail.perches.com ([173.55.12.10]:3231 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758426Ab0JTGwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:52:12 -0400
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [PATCH 15/32] drivers/hwmon/it87.c: Use pr_fmt and pr_<level>
Date: Tue, 19 Oct 2010 23:51:39 -0700
Message-Id: <ca9c0c999e7108d20fab9d4be3b310736bbdd7a6.1287556801.git.joe@perches.com>
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
 drivers/hwmon/it87.c |   30 ++++++++++++++----------------
 1 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/hwmon/it87.c b/drivers/hwmon/it87.c
index f770129..3d3da59 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -36,6 +36,8 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -1493,26 +1495,25 @@ static int __init it87_find(unsigned short *address,
 	case 0xffff:	/* No device at all */
 		goto exit;
 	default:
-		pr_debug(DRVNAME ": Unsupported chip (DEVID=0x%x)\n",
-			 chip_type);
+		pr_debug("Unsupported chip (DEVID=0x%x)\n", chip_type);
 		goto exit;
 	}
 
 	superio_select(PME);
 	if (!(superio_inb(IT87_ACT_REG) & 0x01)) {
-		pr_info("it87: Device not activated, skipping\n");
+		pr_info("Device not activated, skipping\n");
 		goto exit;
 	}
 
 	*address = superio_inw(IT87_BASE_REG) & ~(IT87_EXTENT - 1);
 	if (*address == 0) {
-		pr_info("it87: Base address not set, skipping\n");
+		pr_info("Base address not set, skipping\n");
 		goto exit;
 	}
 
 	err = 0;
 	sio_data->revision = superio_inb(DEVREV) & 0x0f;
-	pr_info("it87: Found IT%04xF chip at 0x%x, revision %d\n",
+	pr_info("Found IT%04xF chip at 0x%x, revision %d\n",
 		chip_type, *address, sio_data->revision);
 
 	/* in8 (Vbat) is always internal */
@@ -1533,7 +1534,7 @@ static int __init it87_find(unsigned short *address,
 		/* We need at least 4 VID pins */
 		reg = superio_inb(IT87_SIO_GPIO3_REG);
 		if (reg & 0x0f) {
-			pr_info("it87: VID is disabled (pins used for GPIO)\n");
+			pr_info("VID is disabled (pins used for GPIO)\n");
 			sio_data->skip_vid = 1;
 		}
 
@@ -1568,7 +1569,7 @@ static int __init it87_find(unsigned short *address,
 		if (sio_data->type == it8720 && !(reg & (1 << 1))) {
 			reg |= (1 << 1);
 			superio_outb(IT87_SIO_PINX2_REG, reg);
-			pr_notice("it87: Routing internal VCCH to in7\n");
+			pr_notice("Routing internal VCCH to in7\n");
 		}
 		if (reg & (1 << 0))
 			sio_data->internal |= (1 << 0);
@@ -1578,7 +1579,7 @@ static int __init it87_find(unsigned short *address,
 		sio_data->beep_pin = superio_inb(IT87_SIO_BEEP_PIN_REG) & 0x3f;
 	}
 	if (sio_data->beep_pin)
-		pr_info("it87: Beeping is supported\n");
+		pr_info("Beeping is supported\n");
 
 	/* Disable specific features based on DMI strings */
 	board_vendor = dmi_get_system_info(DMI_BOARD_VENDOR);
@@ -1592,8 +1593,7 @@ static int __init it87_find(unsigned short *address,
 			   the PWM2 duty cycle, so we disable it.
 			   I use the board name string as the trigger in case
 			   the same board is ever used in other systems. */
-			pr_info("it87: Disabling pwm2 due to "
-				"hardware constraints\n");
+			pr_info("Disabling pwm2 due to hardware constraints\n");
 			sio_data->skip_pwm = (1 << 1);
 		}
 	}
@@ -2086,28 +2086,26 @@ static int __init it87_device_add(unsigned short address,
 	pdev = platform_device_alloc(DRVNAME, address);
 	if (!pdev) {
 		err = -ENOMEM;
-		printk(KERN_ERR DRVNAME ": Device allocation failed\n");
+		pr_err("Device allocation failed\n");
 		goto exit;
 	}
 
 	err = platform_device_add_resources(pdev, &res, 1);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device resource addition failed "
-		       "(%d)\n", err);
+		pr_err("Device resource addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
 	err = platform_device_add_data(pdev, sio_data,
 				       sizeof(struct it87_sio_data));
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
 
-- 
1.7.3.1.g432b3.dirty

