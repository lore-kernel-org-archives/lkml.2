Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab1C2WWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:22:20 -0400
Received: from mail.perches.com ([173.55.12.10]:4357 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652Ab1C2WWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:22:18 -0400
From: Joe Perches <joe@perches.com>
To: Matthew Garrett <mjg@redhat.com>,
        Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/23] compal-laptop: Convert printks to pr_<level>
Date: Tue, 29 Mar 2011 15:21:36 -0700
Message-Id: <884fbb2e33c99f00d795a9c360fef46da6ddfcb7.1301436234.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1301436234.git.joe@perches.com>
References: <cover.1301436234.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pr_fmt.
Convert printks to pr_<level> removing DRIVER_NAME prefix.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/platform/x86/compal-laptop.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
index c16a276..4c4a742 100644
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -68,6 +68,8 @@
  * only enabled on a JHL90 board until it is verified that they work on the
  * other boards too.  See the extra_features variable. */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -760,16 +762,14 @@ static struct rfkill *bt_rfkill;
 
 static int dmi_check_cb(const struct dmi_system_id *id)
 {
-	printk(KERN_INFO DRIVER_NAME": Identified laptop model '%s'\n",
-		id->ident);
+	pr_info("Identified laptop model '%s'\n", id->ident);
 	extra_features = false;
 	return 1;
 }
 
 static int dmi_check_cb_extra(const struct dmi_system_id *id)
 {
-	printk(KERN_INFO DRIVER_NAME": Identified laptop model '%s', "
-		"enabling extra features\n",
+	pr_info("Identified laptop model '%s', enabling extra features\n",
 		id->ident);
 	extra_features = true;
 	return 1;
@@ -956,14 +956,12 @@ static int __init compal_init(void)
 	int ret;
 
 	if (acpi_disabled) {
-		printk(KERN_ERR DRIVER_NAME": ACPI needs to be enabled for "
-						"this driver to work!\n");
+		pr_err("ACPI needs to be enabled for this driver to work!\n");
 		return -ENODEV;
 	}
 
 	if (!force && !dmi_check_system(compal_dmi_table)) {
-		printk(KERN_ERR DRIVER_NAME": Motherboard not recognized (You "
-				"could try the module's force-parameter)");
+		pr_err("Motherboard not recognized (You could try the module's force-parameter)\n");
 		return -ENODEV;
 	}
 
@@ -998,8 +996,7 @@ static int __init compal_init(void)
 	if (ret)
 		goto err_rfkill;
 
-	printk(KERN_INFO DRIVER_NAME": Driver "DRIVER_VERSION
-						" successfully loaded\n");
+	pr_info("Driver " DRIVER_VERSION " successfully loaded\n");
 	return 0;
 
 err_rfkill:
@@ -1064,7 +1061,7 @@ static void __exit compal_cleanup(void)
 	rfkill_destroy(wifi_rfkill);
 	rfkill_destroy(bt_rfkill);
 
-	printk(KERN_INFO DRIVER_NAME": Driver unloaded\n");
+	pr_info("Driver unloaded\n");
 }
 
 static int __devexit compal_remove(struct platform_device *pdev)
@@ -1074,8 +1071,7 @@ static int __devexit compal_remove(struct platform_device *pdev)
 	if (!extra_features)
 		return 0;
 
-	printk(KERN_INFO DRIVER_NAME": Unloading: resetting fan control "
-							"to motherboard\n");
+	pr_info("Unloading: resetting fan control to motherboard\n");
 	pwm_disable_control();
 
 	data = platform_get_drvdata(pdev);
-- 
1.7.4.2.g597a6.dirty

