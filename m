Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab2BCU2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 15:28:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59863 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab2BCU2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 15:28:09 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/3] apple_bl: Convert printks to pr_<level>
Date: Fri,  3 Feb 2012 14:28:02 -0600
Message-Id: <1328300884-21551-2-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1328300884-21551-1-git-send-email-seth.forshee@canonical.com>
References: <1328300884-21551-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/video/backlight/apple_bl.c |   29 ++++++++---------------------
 1 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/video/backlight/apple_bl.c b/drivers/video/backlight/apple_bl.c
index be98d15..66d5bec 100644
--- a/drivers/video/backlight/apple_bl.c
+++ b/drivers/video/backlight/apple_bl.c
@@ -16,6 +16,8 @@
  *  get at the firmware code in order to figure out what it's actually doing.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -38,13 +40,6 @@ struct hw_data {
 
 static const struct hw_data *hw_data;
 
-#define DRIVER "apple_backlight: "
-
-/* Module parameters. */
-static int debug;
-module_param_named(debug, debug, int, 0644);
-MODULE_PARM_DESC(debug, "Set to one to enable debugging messages.");
-
 /*
  * Implementation for machines with Intel chipset.
  */
@@ -58,9 +53,7 @@ static int intel_chipset_send_intensity(struct backlight_device *bd)
 {
 	int intensity = bd->props.brightness;
 
-	if (debug)
-		printk(KERN_DEBUG DRIVER "setting brightness to %d\n",
-		       intensity);
+	pr_debug("setting brightness to %d\n", intensity);
 
 	intel_chipset_set_brightness(intensity);
 	return 0;
@@ -74,9 +67,7 @@ static int intel_chipset_get_intensity(struct backlight_device *bd)
 	outb(0xbf, 0xb2);
 	intensity = inb(0xb3) >> 4;
 
-	if (debug)
-		printk(KERN_DEBUG DRIVER "read brightness of %d\n",
-		       intensity);
+	pr_debug("read brightness of %d\n", intensity);
 
 	return intensity;
 }
@@ -105,9 +96,7 @@ static int nvidia_chipset_send_intensity(struct backlight_device *bd)
 {
 	int intensity = bd->props.brightness;
 
-	if (debug)
-		printk(KERN_DEBUG DRIVER "setting brightness to %d\n",
-		       intensity);
+	pr_debug("setting brightness to %d\n", intensity);
 
 	nvidia_chipset_set_brightness(intensity);
 	return 0;
@@ -121,9 +110,7 @@ static int nvidia_chipset_get_intensity(struct backlight_device *bd)
 	outb(0xbf, 0x52e);
 	intensity = inb(0x52f) >> 4;
 
-	if (debug)
-		printk(KERN_DEBUG DRIVER "read brightness of %d\n",
-		       intensity);
+	pr_debug("read brightness of %d\n", intensity);
 
 	return intensity;
 }
@@ -148,7 +135,7 @@ static int __devinit apple_bl_add(struct acpi_device *dev)
 	host = pci_get_bus_and_slot(0, 0);
 
 	if (!host) {
-		printk(KERN_ERR DRIVER "unable to find PCI host\n");
+		pr_err("unable to find PCI host\n");
 		return -ENODEV;
 	}
 
@@ -160,7 +147,7 @@ static int __devinit apple_bl_add(struct acpi_device *dev)
 	pci_dev_put(host);
 
 	if (!hw_data) {
-		printk(KERN_ERR DRIVER "unknown hardware\n");
+		pr_err("unknown hardware\n");
 		return -ENODEV;
 	}
 
-- 
1.7.8.3

