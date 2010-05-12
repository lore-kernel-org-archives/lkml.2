Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab0ELTGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 15:06:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50762 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463Ab0ELTGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 15:06:40 -0400
Date: Wed, 12 May 2010 12:03:00 -0700
From: Greg KH <gregkh@suse.de>
To: Matthew Garrett <mjg@redhat.com>,
       Lennart Poettering <mzxreary@0pointer.de>,
       Richard Purdie <rpurdie@linux.intel.com>,
       "Lee, Chun-Yi" <jlee@novell.com>, linux-kernel@vger.kernel.org,
       platform-driver-x86@vger.kernel.org
Subject: [PATCH 5/4] msi-laptop: fix up some coding style issues found by
 checkpatch
Message-ID: <20100512190300.GD28990@suse.de>
References: <20100512165645.GA27064@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512165645.GA27064@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

Cc: Lee, Chun-Yi <jlee@novell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/platform/x86/msi-laptop.c |   37 ++++++++++++++++++++++++-------------
 1 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
index 0b17590..ce4a8ff 100644
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -119,7 +119,8 @@ static int set_lcd_level(int level)
 	buf[0] = 0x80;
 	buf[1] = (u8) (level*31);
 
-	return ec_transaction(MSI_EC_COMMAND_LCD_LEVEL, buf, sizeof(buf), NULL, 0, 1);
+	return ec_transaction(MSI_EC_COMMAND_LCD_LEVEL, buf, sizeof(buf),
+			      NULL, 0, 1);
 }
 
 static int get_lcd_level(void)
@@ -127,7 +128,8 @@ static int get_lcd_level(void)
 	u8 wdata = 0, rdata;
 	int result;
 
-	result = ec_transaction(MSI_EC_COMMAND_LCD_LEVEL, &wdata, 1, &rdata, 1, 1);
+	result = ec_transaction(MSI_EC_COMMAND_LCD_LEVEL, &wdata, 1,
+				&rdata, 1, 1);
 	if (result < 0)
 		return result;
 
@@ -139,7 +141,8 @@ static int get_auto_brightness(void)
 	u8 wdata = 4, rdata;
 	int result;
 
-	result = ec_transaction(MSI_EC_COMMAND_LCD_LEVEL, &wdata, 1, &rdata, 1, 1);
+	result = ec_transaction(MSI_EC_COMMAND_LCD_LEVEL, &wdata, 1,
+				&rdata, 1, 1);
 	if (result < 0)
 		return result;
 
@@ -153,14 +156,16 @@ static int set_auto_brightness(int enable)
 
 	wdata[0] = 4;
 
-	result = ec_transaction(MSI_EC_COMMAND_LCD_LEVEL, wdata, 1, &rdata, 1, 1);
+	result = ec_transaction(MSI_EC_COMMAND_LCD_LEVEL, wdata, 1,
+				&rdata, 1, 1);
 	if (result < 0)
 		return result;
 
 	wdata[0] = 0x84;
 	wdata[1] = (rdata & 0xF7) | (enable ? 8 : 0);
 
-	return ec_transaction(MSI_EC_COMMAND_LCD_LEVEL, wdata, 2, NULL, 0, 1);
+	return ec_transaction(MSI_EC_COMMAND_LCD_LEVEL, wdata, 2,
+			      NULL, 0, 1);
 }
 
 static ssize_t set_device_state(const char *buf, size_t count, u8 mask)
@@ -255,7 +260,7 @@ static int bl_update_status(struct backlight_device *b)
 	return set_lcd_level(b->props.brightness);
 }
 
-static struct backlight_ops msibl_ops = {
+static const struct backlight_ops msibl_ops = {
 	.get_brightness = bl_get_brightness,
 	.update_status  = bl_update_status,
 };
@@ -354,7 +359,8 @@ static ssize_t store_lcd_level(struct device *dev,
 
 	int level, ret;
 
-	if (sscanf(buf, "%i", &level) != 1 || (level < 0 || level >= MSI_LCD_LEVEL_MAX))
+	if (sscanf(buf, "%i", &level) != 1 ||
+	    (level < 0 || level >= MSI_LCD_LEVEL_MAX))
 		return -EINVAL;
 
 	ret = set_lcd_level(level);
@@ -394,7 +400,8 @@ static ssize_t store_auto_brightness(struct device *dev,
 }
 
 static DEVICE_ATTR(lcd_level, 0644, show_lcd_level, store_lcd_level);
-static DEVICE_ATTR(auto_brightness, 0644, show_auto_brightness, store_auto_brightness);
+static DEVICE_ATTR(auto_brightness, 0644, show_auto_brightness,
+		   store_auto_brightness);
 static DEVICE_ATTR(bluetooth, 0444, show_bluetooth, NULL);
 static DEVICE_ATTR(wlan, 0444, show_wlan, NULL);
 static DEVICE_ATTR(threeg, 0444, show_threeg, NULL);
@@ -425,8 +432,9 @@ static struct platform_device *msipf_device;
 
 static int dmi_check_cb(const struct dmi_system_id *id)
 {
-        printk("msi-laptop: Identified laptop model '%s'.\n", id->ident);
-        return 0;
+	printk(KERN_INFO "msi-laptop: Identified laptop model '%s'.\n",
+	       id->ident);
+	return 0;
 }
 
 static struct dmi_system_id __initdata msi_dmi_table[] = {
@@ -436,7 +444,8 @@ static struct dmi_system_id __initdata msi_dmi_table[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "MICRO-STAR INT'L CO.,LTD"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "MS-1013"),
 			DMI_MATCH(DMI_PRODUCT_VERSION, "0131"),
-			DMI_MATCH(DMI_CHASSIS_VENDOR, "MICRO-STAR INT'L CO.,LTD")
+			DMI_MATCH(DMI_CHASSIS_VENDOR,
+				  "MICRO-STAR INT'L CO.,LTD")
 		},
 		.callback = dmi_check_cb
 	},
@@ -466,7 +475,8 @@ static struct dmi_system_id __initdata msi_dmi_table[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "NOTEBOOK"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "SAM2000"),
 			DMI_MATCH(DMI_PRODUCT_VERSION, "0131"),
-			DMI_MATCH(DMI_CHASSIS_VENDOR, "MICRO-STAR INT'L CO.,LTD")
+			DMI_MATCH(DMI_CHASSIS_VENDOR,
+				  "MICRO-STAR INT'L CO.,LTD")
 		},
 		.callback = dmi_check_cb
 	},
@@ -823,7 +833,8 @@ static int __init msi_init(void)
 		goto fail_platform_device1;
 	}
 
-	ret = sysfs_create_group(&msipf_device->dev.kobj, &msipf_attribute_group);
+	ret = sysfs_create_group(&msipf_device->dev.kobj,
+				 &msipf_attribute_group);
 	if (ret)
 		goto fail_platform_device2;
 
-- 
1.7.1

