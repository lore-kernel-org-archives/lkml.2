Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab1C2WW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:22:26 -0400
Received: from mail.perches.com ([173.55.12.10]:4362 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757Ab1C2WWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:22:23 -0400
From: Joe Perches <joe@perches.com>
To: Matthew Garrett <mjg@redhat.com>, Corentin Chary <corentincj@iksaif.net>
Cc: acpi4asus-user@lists.sourceforge.net, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/23] eeepc: Use pr_warn
Date: Tue, 29 Mar 2011 15:21:38 -0700
Message-Id: <50c96cbf511199e7a42d178028d513623bc4ba3d.1301436234.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1301436234.git.joe@perches.com>
References: <cover.1301436234.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a trivial pr_warning to pr_warn conversion
while adding a few missing newlines.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/platform/x86/eeepc-laptop.c |   20 ++++++++++----------
 drivers/platform/x86/eeepc-wmi.c    |   14 +++++++-------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 5f2dd38..e5feadd 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -228,7 +228,7 @@ static int set_acpi(struct eeepc_laptop *eeepc, int cm, int value)
 		return -ENODEV;
 
 	if (write_acpi_int(eeepc->handle, method, value))
-		pr_warning("Error writing %s\n", method);
+		pr_warn("Error writing %s\n", method);
 	return 0;
 }
 
@@ -243,7 +243,7 @@ static int get_acpi(struct eeepc_laptop *eeepc, int cm)
 		return -ENODEV;
 
 	if (read_acpi_int(eeepc->handle, method, &value))
-		pr_warning("Error reading %s\n", method);
+		pr_warn("Error reading %s\n", method);
 	return value;
 }
 
@@ -261,7 +261,7 @@ static int acpi_setter_handle(struct eeepc_laptop *eeepc, int cm,
 	status = acpi_get_handle(eeepc->handle, (char *)method,
 				 handle);
 	if (status != AE_OK) {
-		pr_warning("Error finding %s\n", method);
+		pr_warn("Error finding %s\n", method);
 		return -ENODEV;
 	}
 	return 0;
@@ -417,7 +417,7 @@ static ssize_t store_cpufv_disabled(struct device *dev,
 	switch (value) {
 	case 0:
 		if (eeepc->cpufv_disabled)
-			pr_warning("cpufv enabled (not officially supported "
+			pr_warn("cpufv enabled (not officially supported "
 				"on this model)\n");
 		eeepc->cpufv_disabled = false;
 		return rv;
@@ -601,7 +601,7 @@ static void eeepc_rfkill_hotplug(struct eeepc_laptop *eeepc)
 	if (eeepc->hotplug_slot) {
 		bus = pci_find_bus(0, 1);
 		if (!bus) {
-			pr_warning("Unable to find PCI bus 1?\n");
+			pr_warn("Unable to find PCI bus 1?\n");
 			goto out_unlock;
 		}
 
@@ -612,12 +612,12 @@ static void eeepc_rfkill_hotplug(struct eeepc_laptop *eeepc)
 		absent = (l == 0xffffffff);
 
 		if (blocked != absent) {
-			pr_warning("BIOS says wireless lan is %s, "
-					"but the pci device is %s\n",
+			pr_warn("BIOS says wireless lan is %s, "
+				"but the pci device is %s\n",
 				blocked ? "blocked" : "unblocked",
 				absent ? "absent" : "present");
-			pr_warning("skipped wireless hotplug as probably "
-					"inappropriate for this model\n");
+			pr_warn("skipped wireless hotplug as probably "
+				"inappropriate for this model\n");
 			goto out_unlock;
 		}
 
@@ -671,7 +671,7 @@ static int eeepc_register_rfkill_notifier(struct eeepc_laptop *eeepc,
 						     eeepc_rfkill_notify,
 						     eeepc);
 		if (ACPI_FAILURE(status))
-			pr_warning("Failed to register notify on %s\n", node);
+			pr_warn("Failed to register notify on %s\n", node);
 	} else
 		return -ENODEV;
 
diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index 0ddc434..4155884 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -82,7 +82,7 @@ static const struct key_entry eeepc_wmi_keymap[] = {
 static acpi_status eeepc_wmi_parse_device(acpi_handle handle, u32 level,
 						 void *context, void **retval)
 {
-	pr_warning("Found legacy ATKD device (%s)", EEEPC_ACPI_HID);
+	pr_warn("Found legacy ATKD device (%s)\n", EEEPC_ACPI_HID);
 	*(bool *)context = true;
 	return AE_CTRL_TERMINATE;
 }
@@ -103,12 +103,12 @@ static int eeepc_wmi_check_atkd(void)
 static int eeepc_wmi_probe(struct platform_device *pdev)
 {
 	if (eeepc_wmi_check_atkd()) {
-		pr_warning("WMI device present, but legacy ATKD device is also "
-			   "present and enabled.");
-		pr_warning("You probably booted with acpi_osi=\"Linux\" or "
-			   "acpi_osi=\"!Windows 2009\"");
-		pr_warning("Can't load eeepc-wmi, use default acpi_osi "
-			   "(preferred) or eeepc-laptop");
+		pr_warn("WMI device present, but legacy ATKD device is also "
+			"present and enabled\n");
+		pr_warn("You probably booted with acpi_osi=\"Linux\" or "
+			"acpi_osi=\"!Windows 2009\"\n");
+		pr_warn("Can't load eeepc-wmi, use default acpi_osi "
+			"(preferred) or eeepc-laptop\n");
 		return -EBUSY;
 	}
 	return 0;
-- 
1.7.4.2.g597a6.dirty

