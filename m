Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614Ab2EOHwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 03:52:54 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:54693 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756824Ab2EOHww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 03:52:52 -0400
X-AuditID: cbfee61a-b7bbeae000003a71-d8-4fb20b52b197
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Matthew Garrett'" <mjg@redhat.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 2/7] backlight: apple_bl: use pr_debug/err instead of printk
Date: Tue, 15 May 2012 16:52:50 +0900
Message-id: <000d01cd326f$b9d5d610$2d818230$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0yb7mubNkZQlGmREy4Dd8ONcl1+w==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses pr_debug/err instead of printk to allow dynamic debugging.
It also fixes checkpatch warnings as below:

WARNING: Prefer pr_debug(... to printk(KERN_DEBUG, ...
WARNING: Prefer pr_err(... to printk(KERN_ERR, ...

Cc: Matthew Garrett <mjg@redhat.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/apple_bl.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/video/backlight/apple_bl.c b/drivers/video/backlight/apple_bl.c
index ef5ca0d..9236e95 100644
--- a/drivers/video/backlight/apple_bl.c
+++ b/drivers/video/backlight/apple_bl.c
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


