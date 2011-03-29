Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab1C2WWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:22:23 -0400
Received: from mail.perches.com ([173.55.12.10]:4359 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652Ab1C2WWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:22:21 -0400
From: Joe Perches <joe@perches.com>
To: Matthew Garrett <mjg@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/23] dell: Convert printks to pr_<level>
Date: Tue, 29 Mar 2011 15:21:37 -0700
Message-Id: <0d6e50d5caa832a8a9bf20996991ab56c576b894.1301436234.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1301436234.git.joe@perches.com>
References: <cover.1301436234.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pr_fmt.
Remove hard coded prefixes and use pr_<level>.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/platform/x86/dell-laptop.c  |   12 ++++++------
 drivers/platform/x86/dell-wmi-aio.c |    3 ++-
 drivers/platform/x86/dell-wmi.c     |   17 ++++++++---------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index de301aa..d3841de 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -11,6 +11,8 @@
  *  published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -434,8 +436,7 @@ static int __init dell_setup_rfkill(void)
 	int ret;
 
 	if (dmi_check_system(dell_blacklist)) {
-		printk(KERN_INFO "dell-laptop: Blacklisted hardware detected - "
-				"not enabling rfkill\n");
+		pr_info("Blacklisted hardware detected - not enabling rfkill\n");
 		return 0;
 	}
 
@@ -606,7 +607,7 @@ static int __init dell_init(void)
 	dmi_walk(find_tokens, NULL);
 
 	if (!da_tokens)  {
-		printk(KERN_INFO "dell-laptop: Unable to find dmi tokens\n");
+		pr_info("Unable to find dmi tokens\n");
 		return -ENODEV;
 	}
 
@@ -636,14 +637,13 @@ static int __init dell_init(void)
 	ret = dell_setup_rfkill();
 
 	if (ret) {
-		printk(KERN_WARNING "dell-laptop: Unable to setup rfkill\n");
+		pr_warn("Unable to setup rfkill\n");
 		goto fail_rfkill;
 	}
 
 	ret = i8042_install_filter(dell_laptop_i8042_filter);
 	if (ret) {
-		printk(KERN_WARNING
-		       "dell-laptop: Unable to install key filter\n");
+		pr_warn("Unable to install key filter\n");
 		goto fail_filter;
 	}
 
diff --git a/drivers/platform/x86/dell-wmi-aio.c b/drivers/platform/x86/dell-wmi-aio.c
index 0ed8457..3f94545 100644
--- a/drivers/platform/x86/dell-wmi-aio.c
+++ b/drivers/platform/x86/dell-wmi-aio.c
@@ -15,6 +15,7 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
+
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
@@ -138,7 +139,7 @@ static int __init dell_wmi_aio_init(void)
 
 	guid = dell_wmi_aio_find();
 	if (!guid) {
-		pr_warning("No known WMI GUID found\n");
+		pr_warn("No known WMI GUID found\n");
 		return -ENXIO;
 	}
 
diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
index 77f1d55..ce79082 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -23,6 +23,8 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -141,7 +143,7 @@ static void dell_wmi_notify(u32 value, void *context)
 
 	status = wmi_get_event_data(value, &response);
 	if (status != AE_OK) {
-		printk(KERN_INFO "dell-wmi: bad event status 0x%x\n", status);
+		pr_info("bad event status 0x%x\n", status);
 		return;
 	}
 
@@ -153,8 +155,8 @@ static void dell_wmi_notify(u32 value, void *context)
 		u16 *buffer_entry = (u16 *)obj->buffer.pointer;
 
 		if (dell_new_hk_type && (buffer_entry[1] != 0x10)) {
-			printk(KERN_INFO "dell-wmi: Received unknown WMI event"
-					 " (0x%x)\n", buffer_entry[1]);
+			pr_info("Received unknown WMI event (0x%x)\n",
+				buffer_entry[1]);
 			kfree(obj);
 			return;
 		}
@@ -167,8 +169,7 @@ static void dell_wmi_notify(u32 value, void *context)
 		key = sparse_keymap_entry_from_scancode(dell_wmi_input_dev,
 							reported_key);
 		if (!key) {
-			printk(KERN_INFO "dell-wmi: Unknown key %x pressed\n",
-				reported_key);
+			pr_info("Unknown key %x pressed\n", reported_key);
 		} else if ((key->keycode == KEY_BRIGHTNESSUP ||
 			    key->keycode == KEY_BRIGHTNESSDOWN) && acpi_video) {
 			/* Don't report brightness notifications that will also
@@ -275,7 +276,7 @@ static int __init dell_wmi_init(void)
 	acpi_status status;
 
 	if (!wmi_has_guid(DELL_EVENT_GUID)) {
-		printk(KERN_WARNING "dell-wmi: No known WMI GUID found\n");
+		pr_warn("No known WMI GUID found\n");
 		return -ENODEV;
 	}
 
@@ -290,9 +291,7 @@ static int __init dell_wmi_init(void)
 					 dell_wmi_notify, NULL);
 	if (ACPI_FAILURE(status)) {
 		dell_wmi_input_destroy();
-		printk(KERN_ERR
-			"dell-wmi: Unable to register notify handler - %d\n",
-			status);
+		pr_err("Unable to register notify handler - %d\n", status);
 		return -ENODEV;
 	}
 
-- 
1.7.4.2.g597a6.dirty

