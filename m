Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759780Ab2EPIJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 04:09:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13489 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759408Ab2EPIJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 04:09:19 -0400
X-AuditID: cbfee61b-b7b94ae000002e44-3b-4fb360ad2b35
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Matthew Garrett'" <mjg@redhat.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH v3 2/7] backlight: apple_bl: use pr_debug/err instead of printk
Date: Wed, 16 May 2012 17:09:17 +0900
Message-id: <003501cd333b$30620670$91261350$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0zOzBIKK4c4IzNSXWXcGxC1sxFzg==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses pr_debug/err instead of printk to allow dynamic debugging.
The pr_fmt prefix for pr_ macros is used. It also fixes checkpatch
warnings as below:

WARNING: Prefer pr_debug(... to printk(KERN_DEBUG, ...
WARNING: Prefer pr_err(... to printk(KERN_ERR, ...

Cc: Matthew Garrett <mjg@redhat.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/apple_bl.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/video/backlight/apple_bl.c b/drivers/video/backlight/apple_bl.c
index ef5ca0d..9dc73ac 100644
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
@@ -40,8 +42,6 @@ struct hw_data {
 
 static const struct hw_data *hw_data;
 
-#define DRIVER "apple_backlight: "
-
 /* Module parameters. */
 static int debug;
 module_param_named(debug, debug, int, 0644);
@@ -61,8 +61,7 @@ static int intel_chipset_send_intensity(struct backlight_device *bd)
 	int intensity = bd->props.brightness;
 
 	if (debug)
-		printk(KERN_DEBUG DRIVER "setting brightness to %d\n",
-		       intensity);
+		pr_debug("setting brightness to %d\n", intensity);
 
 	intel_chipset_set_brightness(intensity);
 	return 0;
@@ -77,8 +76,7 @@ static int intel_chipset_get_intensity(struct backlight_device *bd)
 	intensity = inb(0xb3) >> 4;
 
 	if (debug)
-		printk(KERN_DEBUG DRIVER "read brightness of %d\n",
-		       intensity);
+		pr_debug("read brightness of %d\n", intensity);
 
 	return intensity;
 }
@@ -108,8 +106,7 @@ static int nvidia_chipset_send_intensity(struct backlight_device *bd)
 	int intensity = bd->props.brightness;
 
 	if (debug)
-		printk(KERN_DEBUG DRIVER "setting brightness to %d\n",
-		       intensity);
+		pr_debug("setting brightness to %d\n", intensity);
 
 	nvidia_chipset_set_brightness(intensity);
 	return 0;
@@ -124,8 +121,7 @@ static int nvidia_chipset_get_intensity(struct backlight_device *bd)
 	intensity = inb(0x52f) >> 4;
 
 	if (debug)
-		printk(KERN_DEBUG DRIVER "read brightness of %d\n",
-		       intensity);
+		pr_debug("read brightness of %d\n", intensity);
 
 	return intensity;
 }
@@ -150,7 +146,7 @@ static int __devinit apple_bl_add(struct acpi_device *dev)
 	host = pci_get_bus_and_slot(0, 0);
 
 	if (!host) {
-		printk(KERN_ERR DRIVER "unable to find PCI host\n");
+		pr_err("unable to find PCI host\n");
 		return -ENODEV;
 	}
 
@@ -162,7 +158,7 @@ static int __devinit apple_bl_add(struct acpi_device *dev)
 	pci_dev_put(host);
 
 	if (!hw_data) {
-		printk(KERN_ERR DRIVER "unknown hardware\n");
+		pr_err("unknown hardware\n");
 		return -ENODEV;
 	}
 
-- 
1.7.1


