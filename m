Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab1C2W0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:26:17 -0400
Received: from mail.perches.com ([173.55.12.10]:4364 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758Ab1C2WWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:22:25 -0400
From: Joe Perches <joe@perches.com>
To: Matthew Garrett <mjg@redhat.com>,
        Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/23] fujitsu-laptop: Convert printks to pr_<level>
Date: Tue, 29 Mar 2011 15:21:39 -0700
Message-Id: <20baaa2f09235d33f2cf751eaf6ad6f1bbb24d64.1301436234.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1301436234.git.joe@perches.com>
References: <cover.1301436234.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added pr_fmt, converted printks and removed
hard coded prefixes.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/platform/x86/fujitsu-laptop.c |   39 ++++++++++++++++-----------------
 1 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
index 493054c..6b26666 100644
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -56,6 +56,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -585,8 +587,7 @@ static struct platform_driver fujitsupf_driver = {
 static void dmi_check_cb_common(const struct dmi_system_id *id)
 {
 	acpi_handle handle;
-	printk(KERN_INFO "fujitsu-laptop: Identified laptop model '%s'.\n",
-	       id->ident);
+	pr_info("Identified laptop model '%s'\n", id->ident);
 	if (use_alt_lcd_levels == -1) {
 		if (ACPI_SUCCESS(acpi_get_handle(NULL,
 				"\\_SB.PCI0.LPCB.FJEX.SBL2", &handle)))
@@ -691,11 +692,11 @@ static int acpi_fujitsu_add(struct acpi_device *device)
 
 	result = acpi_bus_update_power(fujitsu->acpi_handle, &state);
 	if (result) {
-		printk(KERN_ERR "Error reading power state\n");
+		pr_err("Error reading power state\n");
 		goto err_unregister_input_dev;
 	}
 
-	printk(KERN_INFO "ACPI: %s [%s] (%s)\n",
+	pr_info("ACPI: %s [%s] (%s)\n",
 	       acpi_device_name(device), acpi_device_bid(device),
 	       !device->power.state ? "on" : "off");
 
@@ -707,7 +708,7 @@ static int acpi_fujitsu_add(struct acpi_device *device)
 		if (ACPI_FAILURE
 		    (acpi_evaluate_object
 		     (device->handle, METHOD_NAME__INI, NULL, NULL)))
-			printk(KERN_ERR "_INI Method failed\n");
+			pr_err("_INI Method failed\n");
 	}
 
 	/* do config (detect defaults) */
@@ -827,7 +828,7 @@ static int acpi_fujitsu_hotkey_add(struct acpi_device *device)
 	error = kfifo_alloc(&fujitsu_hotkey->fifo, RINGBUFFERSIZE * sizeof(int),
 			GFP_KERNEL);
 	if (error) {
-		printk(KERN_ERR "kfifo_alloc failed\n");
+		pr_err("kfifo_alloc failed\n");
 		goto err_stop;
 	}
 
@@ -859,13 +860,13 @@ static int acpi_fujitsu_hotkey_add(struct acpi_device *device)
 
 	result = acpi_bus_update_power(fujitsu_hotkey->acpi_handle, &state);
 	if (result) {
-		printk(KERN_ERR "Error reading power state\n");
+		pr_err("Error reading power state\n");
 		goto err_unregister_input_dev;
 	}
 
-	printk(KERN_INFO "ACPI: %s [%s] (%s)\n",
-	       acpi_device_name(device), acpi_device_bid(device),
-	       !device->power.state ? "on" : "off");
+	pr_info("ACPI: %s [%s] (%s)\n",
+		acpi_device_name(device), acpi_device_bid(device),
+		!device->power.state ? "on" : "off");
 
 	fujitsu_hotkey->dev = device;
 
@@ -875,7 +876,7 @@ static int acpi_fujitsu_hotkey_add(struct acpi_device *device)
 		if (ACPI_FAILURE
 		    (acpi_evaluate_object
 		     (device->handle, METHOD_NAME__INI, NULL, NULL)))
-			printk(KERN_ERR "_INI Method failed\n");
+			pr_err("_INI Method failed\n");
 	}
 
 	i = 0;
@@ -897,8 +898,7 @@ static int acpi_fujitsu_hotkey_add(struct acpi_device *device)
 			call_fext_func(FUNC_RFKILL, 0x4, 0x0, 0x0);
 
 	/* Suspect this is a keymap of the application panel, print it */
-	printk(KERN_INFO "fujitsu-laptop: BTNI: [0x%x]\n",
-		call_fext_func(FUNC_BUTTONS, 0x0, 0x0, 0x0));
+	pr_info("BTNI: [0x%x]\n", call_fext_func(FUNC_BUTTONS, 0x0, 0x0, 0x0));
 
 #if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
 	if (call_fext_func(FUNC_LEDS, 0x0, 0x0, 0x0) & LOGOLAMP_POWERON) {
@@ -907,8 +907,8 @@ static int acpi_fujitsu_hotkey_add(struct acpi_device *device)
 		if (result == 0) {
 			fujitsu_hotkey->logolamp_registered = 1;
 		} else {
-			printk(KERN_ERR "fujitsu-laptop: Could not register "
-			"LED handler for logo lamp, error %i\n", result);
+			pr_err("Could not register LED handler for logo lamp, error %i\n",
+			       result);
 		}
 	}
 
@@ -919,8 +919,8 @@ static int acpi_fujitsu_hotkey_add(struct acpi_device *device)
 		if (result == 0) {
 			fujitsu_hotkey->kblamps_registered = 1;
 		} else {
-			printk(KERN_ERR "fujitsu-laptop: Could not register "
-			"LED handler for keyboard lamps, error %i\n", result);
+			pr_err("Could not register LED handler for keyboard lamps, error %i\n",
+			       result);
 		}
 	}
 #endif
@@ -1169,8 +1169,7 @@ static int __init fujitsu_init(void)
 			fujitsu->bl_device->props.power = 0;
 	}
 
-	printk(KERN_INFO "fujitsu-laptop: driver " FUJITSU_DRIVER_VERSION
-	       " successfully loaded.\n");
+	pr_info("driver " FUJITSU_DRIVER_VERSION " successfully loaded\n");
 
 	return 0;
 
@@ -1216,7 +1215,7 @@ static void __exit fujitsu_cleanup(void)
 
 	kfree(fujitsu);
 
-	printk(KERN_INFO "fujitsu-laptop: driver unloaded.\n");
+	pr_info("driver unloaded\n");
 }
 
 module_init(fujitsu_init);
-- 
1.7.4.2.g597a6.dirty

