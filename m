Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab1C2WWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:22:51 -0400
Received: from mail.perches.com ([173.55.12.10]:4390 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755020Ab1C2WWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:22:42 -0400
From: Joe Perches <joe@perches.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 21/23] toshiba: Convert printks to pr_<level>
Date: Tue, 29 Mar 2011 15:21:52 -0700
Message-Id: <8d28e96c4035791ab9baec4dd0199e950688b40f.1301436234.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1301436234.git.joe@perches.com>
References: <cover.1301436234.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pr_fmt.
Remove local MY_<foo> #defines.
Convert printks to pr_<level>.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/platform/x86/toshiba_acpi.c      |   59 ++++++++++++++----------------
 drivers/platform/x86/toshiba_bluetooth.c |   11 +++---
 2 files changed, 34 insertions(+), 36 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 63f42a2..cb009b2 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -35,6 +35,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define TOSHIBA_ACPI_VERSION	"0.19"
 #define PROC_INTERFACE_VERSION	1
 
@@ -60,11 +62,6 @@ MODULE_AUTHOR("John Belmonte");
 MODULE_DESCRIPTION("Toshiba Laptop ACPI Extras Driver");
 MODULE_LICENSE("GPL");
 
-#define MY_LOGPREFIX "toshiba_acpi: "
-#define MY_ERR KERN_ERR MY_LOGPREFIX
-#define MY_NOTICE KERN_NOTICE MY_LOGPREFIX
-#define MY_INFO KERN_INFO MY_LOGPREFIX
-
 /* Toshiba ACPI method paths */
 #define METHOD_LCD_BRIGHTNESS	"\\_SB_.PCI0.VGA_.LCD_._BCM"
 #define TOSH_INTERFACE_1	"\\_SB_.VALD"
@@ -301,7 +298,7 @@ static int toshiba_illumination_available(void)
 	in[0] = 0xf100;
 	status = hci_raw(in, out);
 	if (ACPI_FAILURE(status)) {
-		printk(MY_INFO "Illumination device not available\n");
+		pr_info("Illumination device not available\n");
 		return 0;
 	}
 	in[0] = 0xf400;
@@ -320,7 +317,7 @@ static void toshiba_illumination_set(struct led_classdev *cdev,
 	in[0] = 0xf100;
 	status = hci_raw(in, out);
 	if (ACPI_FAILURE(status)) {
-		printk(MY_INFO "Illumination device not available\n");
+		pr_info("Illumination device not available\n");
 		return;
 	}
 
@@ -331,7 +328,7 @@ static void toshiba_illumination_set(struct led_classdev *cdev,
 		in[2] = 1;
 		status = hci_raw(in, out);
 		if (ACPI_FAILURE(status)) {
-			printk(MY_INFO "ACPI call for illumination failed.\n");
+			pr_info("ACPI call for illumination failed\n");
 			return;
 		}
 	} else {
@@ -341,7 +338,7 @@ static void toshiba_illumination_set(struct led_classdev *cdev,
 		in[2] = 0;
 		status = hci_raw(in, out);
 		if (ACPI_FAILURE(status)) {
-			printk(MY_INFO "ACPI call for illumination failed.\n");
+			pr_info("ACPI call for illumination failed.\n");
 			return;
 		}
 	}
@@ -364,7 +361,7 @@ static enum led_brightness toshiba_illumination_get(struct led_classdev *cdev)
 	in[0] = 0xf100;
 	status = hci_raw(in, out);
 	if (ACPI_FAILURE(status)) {
-		printk(MY_INFO "Illumination device not available\n");
+		pr_info("Illumination device not available\n");
 		return LED_OFF;
 	}
 
@@ -373,7 +370,7 @@ static enum led_brightness toshiba_illumination_get(struct led_classdev *cdev)
 	in[1] = 0x14e;
 	status = hci_raw(in, out);
 	if (ACPI_FAILURE(status)) {
-		printk(MY_INFO "ACPI call for illumination failed.\n");
+		pr_info("ACPI call for illumination failed.\n");
 		return LED_OFF;
 	}
 
@@ -517,7 +514,7 @@ static int lcd_proc_show(struct seq_file *m, void *v)
 		seq_printf(m, "brightness_levels:       %d\n",
 			     HCI_LCD_BRIGHTNESS_LEVELS);
 	} else {
-		printk(MY_ERR "Error reading LCD brightness\n");
+		pr_err("Error reading LCD brightness\n");
 	}
 
 	return 0;
@@ -592,7 +589,7 @@ static int video_proc_show(struct seq_file *m, void *v)
 		seq_printf(m, "crt_out:                 %d\n", is_crt);
 		seq_printf(m, "tv_out:                  %d\n", is_tv);
 	} else {
-		printk(MY_ERR "Error reading video out status\n");
+		pr_err("Error reading video out status\n");
 	}
 
 	return 0;
@@ -686,7 +683,7 @@ static int fan_proc_show(struct seq_file *m, void *v)
 		seq_printf(m, "running:                 %d\n", (value > 0));
 		seq_printf(m, "force_on:                %d\n", force_fan);
 	} else {
-		printk(MY_ERR "Error reading fan status\n");
+		pr_err("Error reading fan status\n");
 	}
 
 	return 0;
@@ -750,9 +747,9 @@ static int keys_proc_show(struct seq_file *m, void *v)
 			 * some machines where system events sporadically
 			 * become disabled. */
 			hci_write1(HCI_SYSTEM_EVENT, 1, &hci_result);
-			printk(MY_NOTICE "Re-enabled hotkeys\n");
+			pr_notice("Re-enabled hotkeys\n");
 		} else {
-			printk(MY_ERR "Error reading hotkey status\n");
+			pr_err("Error reading hotkey status\n");
 			goto end;
 		}
 	}
@@ -863,7 +860,7 @@ static void toshiba_acpi_notify(acpi_handle handle, u32 event, void *context)
 
 			if (!sparse_keymap_report_event(toshiba_acpi.hotkey_dev,
 							value, 1, true)) {
-				printk(MY_INFO "Unknown key %x\n",
+				pr_info("Unknown key %x\n",
 				       value);
 			}
 		} else if (hci_result == HCI_NOT_SUPPORTED) {
@@ -871,7 +868,7 @@ static void toshiba_acpi_notify(acpi_handle handle, u32 event, void *context)
 			 * some machines where system events sporadically
 			 * become disabled. */
 			hci_write1(HCI_SYSTEM_EVENT, 1, &hci_result);
-			printk(MY_NOTICE "Re-enabled hotkeys\n");
+			pr_notice("Re-enabled hotkeys\n");
 		}
 	} while (hci_result != HCI_EMPTY);
 }
@@ -883,13 +880,13 @@ static int __init toshiba_acpi_setup_keyboard(char *device)
 
 	status = acpi_get_handle(NULL, device, &toshiba_acpi.handle);
 	if (ACPI_FAILURE(status)) {
-		printk(MY_INFO "Unable to get notification device\n");
+		pr_info("Unable to get notification device\n");
 		return -ENODEV;
 	}
 
 	toshiba_acpi.hotkey_dev = input_allocate_device();
 	if (!toshiba_acpi.hotkey_dev) {
-		printk(MY_INFO "Unable to register input device\n");
+		pr_info("Unable to register input device\n");
 		return -ENOMEM;
 	}
 
@@ -905,21 +902,21 @@ static int __init toshiba_acpi_setup_keyboard(char *device)
 	status = acpi_install_notify_handler(toshiba_acpi.handle,
 				ACPI_DEVICE_NOTIFY, toshiba_acpi_notify, NULL);
 	if (ACPI_FAILURE(status)) {
-		printk(MY_INFO "Unable to install hotkey notification\n");
+		pr_info("Unable to install hotkey notification\n");
 		error = -ENODEV;
 		goto err_free_keymap;
 	}
 
 	status = acpi_evaluate_object(toshiba_acpi.handle, "ENAB", NULL, NULL);
 	if (ACPI_FAILURE(status)) {
-		printk(MY_INFO "Unable to enable hotkeys\n");
+		pr_info("Unable to enable hotkeys\n");
 		error = -ENODEV;
 		goto err_remove_notify;
 	}
 
 	error = input_register_device(toshiba_acpi.hotkey_dev);
 	if (error) {
-		printk(MY_INFO "Unable to register input device\n");
+		pr_info("Unable to register input device\n");
 		goto err_remove_notify;
 	}
 
@@ -980,17 +977,17 @@ static int __init toshiba_acpi_init(void)
 	if (is_valid_acpi_path(TOSH_INTERFACE_1 GHCI_METHOD)) {
 		method_hci = TOSH_INTERFACE_1 GHCI_METHOD;
 		if (toshiba_acpi_setup_keyboard(TOSH_INTERFACE_1))
-			printk(MY_INFO "Unable to activate hotkeys\n");
+			pr_info("Unable to activate hotkeys\n");
 	} else if (is_valid_acpi_path(TOSH_INTERFACE_2 GHCI_METHOD)) {
 		method_hci = TOSH_INTERFACE_2 GHCI_METHOD;
 		if (toshiba_acpi_setup_keyboard(TOSH_INTERFACE_2))
-			printk(MY_INFO "Unable to activate hotkeys\n");
+			pr_info("Unable to activate hotkeys\n");
 	} else
 		return -ENODEV;
 
-	printk(MY_INFO "Toshiba Laptop ACPI Extras version %s\n",
+	pr_info("Toshiba Laptop ACPI Extras version %s\n",
 	       TOSHIBA_ACPI_VERSION);
-	printk(MY_INFO "    HCI method: %s\n", method_hci);
+	pr_info("    HCI method: %s\n", method_hci);
 
 	mutex_init(&toshiba_acpi.mutex);
 
@@ -998,7 +995,7 @@ static int __init toshiba_acpi_init(void)
 							      -1, NULL, 0);
 	if (IS_ERR(toshiba_acpi.p_dev)) {
 		ret = PTR_ERR(toshiba_acpi.p_dev);
-		printk(MY_ERR "unable to register platform device\n");
+		pr_err("unable to register platform device\n");
 		toshiba_acpi.p_dev = NULL;
 		toshiba_acpi_exit();
 		return ret;
@@ -1028,7 +1025,7 @@ static int __init toshiba_acpi_init(void)
         if (IS_ERR(toshiba_backlight_device)) {
 		ret = PTR_ERR(toshiba_backlight_device);
 
-		printk(KERN_ERR "Could not register toshiba backlight device\n");
+		pr_err("Could not register toshiba backlight device\n");
 		toshiba_backlight_device = NULL;
 		toshiba_acpi_exit();
 		return ret;
@@ -1042,14 +1039,14 @@ static int __init toshiba_acpi_init(void)
 						   &toshiba_rfk_ops,
 						   &toshiba_acpi);
 		if (!toshiba_acpi.bt_rfk) {
-			printk(MY_ERR "unable to allocate rfkill device\n");
+			pr_err("unable to allocate rfkill device\n");
 			toshiba_acpi_exit();
 			return -ENOMEM;
 		}
 
 		ret = rfkill_register(toshiba_acpi.bt_rfk);
 		if (ret) {
-			printk(MY_ERR "unable to register rfkill device\n");
+			pr_err("unable to register rfkill device\n");
 			rfkill_destroy(toshiba_acpi.bt_rfk);
 			toshiba_acpi_exit();
 			return ret;
diff --git a/drivers/platform/x86/toshiba_bluetooth.c b/drivers/platform/x86/toshiba_bluetooth.c
index 9440686..5fb7186 100644
--- a/drivers/platform/x86/toshiba_bluetooth.c
+++ b/drivers/platform/x86/toshiba_bluetooth.c
@@ -17,6 +17,8 @@
  * delivered.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -70,14 +72,13 @@ static int toshiba_bluetooth_enable(acpi_handle handle)
 	if (!(result & 0x01))
 		return 0;
 
-	printk(KERN_INFO "toshiba_bluetooth: Re-enabling Toshiba Bluetooth\n");
+	pr_info("Re-enabling Toshiba Bluetooth\n");
 	res1 = acpi_evaluate_object(handle, "AUSB", NULL, NULL);
 	res2 = acpi_evaluate_object(handle, "BTPO", NULL, NULL);
 	if (!ACPI_FAILURE(res1) || !ACPI_FAILURE(res2))
 		return 0;
 
-	printk(KERN_WARNING "toshiba_bluetooth: Failed to re-enable "
-	       "Toshiba Bluetooth\n");
+	pr_warn("Failed to re-enable Toshiba Bluetooth\n");
 
 	return -ENODEV;
 }
@@ -107,8 +108,8 @@ static int toshiba_bt_rfkill_add(struct acpi_device *device)
 				       &bt_present);
 
 	if (!ACPI_FAILURE(status) && bt_present) {
-		printk(KERN_INFO "Detected Toshiba ACPI Bluetooth device - "
-		      "installing RFKill handler\n");
+		pr_info("Detected Toshiba ACPI Bluetooth device - "
+			"installing RFKill handler\n");
 		result = toshiba_bluetooth_enable(device->handle);
 	}
 
-- 
1.7.4.2.g597a6.dirty

