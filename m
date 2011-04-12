Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab1DLAOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 20:14:23 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46778 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467Ab1DLAOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 20:14:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VhU12rO5niKExVh7ZNrha7r5lNvaAWFo8Dw6sODDzzQ1y3lyg2ZiWrsL+MAVSZxDoV
         4BuCcIGQNsgANXnpQajfbbc8TTKduIrYMKK61GzrXWO4m+iDZe79RLRqCdIKaZL6YDwn
         dZupVN530a6Uiz/5dIZXzeIGmhe55abx+5xfA=
From: Timothy Courrejou <timcour@gmail.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Timothy Courrejou <timcour@gmail.com>
Subject: [PATCH] ACPI: ac: fixed indentation, commenting and line length coding style issues
Date: Mon, 11 Apr 2011 17:14:10 -0700
Message-Id: <1302567250-6893-1-git-send-email-timcour@gmail.com>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issues.
---
 drivers/acpi/ac.c |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index 58c3f74..183a035 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -85,7 +85,7 @@ static struct acpi_driver acpi_ac_driver = {
 
 struct acpi_ac {
 	struct power_supply charger;
-	struct acpi_device * device;
+	struct acpi_device *device;
 	unsigned long long state;
 };
 
@@ -101,10 +101,9 @@ static const struct file_operations acpi_ac_fops = {
 };
 #endif
 
-/* --------------------------------------------------------------------------
-                               AC Adapter Management
-   -------------------------------------------------------------------------- */
-
+/*
+ * AC Adapter Management
+ */
 static int acpi_ac_get_state(struct acpi_ac *ac)
 {
 	acpi_status status = AE_OK;
@@ -113,9 +112,11 @@ static int acpi_ac_get_state(struct acpi_ac *ac)
 	if (!ac)
 		return -EINVAL;
 
-	status = acpi_evaluate_integer(ac->device->handle, "_PSR", NULL, &ac->state);
+	status = acpi_evaluate_integer(ac->device->handle,
+				       "_PSR", NULL, &ac->state);
 	if (ACPI_FAILURE(status)) {
-		ACPI_EXCEPTION((AE_INFO, status, "Error reading AC Adapter state"));
+		ACPI_EXCEPTION((AE_INFO, status,
+				"Error reading AC Adapter state"));
 		ac->state = ACPI_AC_STATUS_UNKNOWN;
 		return -ENODEV;
 	}
@@ -123,9 +124,9 @@ static int acpi_ac_get_state(struct acpi_ac *ac)
 	return 0;
 }
 
-/* --------------------------------------------------------------------------
-                            sysfs I/F
-   -------------------------------------------------------------------------- */
+/*
+ * sysfs I/F
+ */
 static int get_ac_property(struct power_supply *psy,
 			   enum power_supply_property psp,
 			   union power_supply_propval *val)
@@ -153,10 +154,10 @@ static enum power_supply_property ac_props[] = {
 };
 
 #ifdef CONFIG_ACPI_PROCFS_POWER
-/* --------------------------------------------------------------------------
-                              FS Interface (/proc)
-   -------------------------------------------------------------------------- */
 
+/*
+ * FS Interface (/proc)
+ */
 static struct proc_dir_entry *acpi_ac_dir;
 
 static int acpi_ac_seq_show(struct seq_file *seq, void *offset)
@@ -229,10 +230,9 @@ static int acpi_ac_remove_fs(struct acpi_device *device)
 }
 #endif
 
-/* --------------------------------------------------------------------------
-                                   Driver Model
-   -------------------------------------------------------------------------- */
-
+/*
+ * Driver Model
+ */
 static void acpi_ac_notify(struct acpi_device *device, u32 event)
 {
 	struct acpi_ac *ac = acpi_driver_data(device);
@@ -298,7 +298,7 @@ static int acpi_ac_add(struct acpi_device *device)
 	       acpi_device_name(device), acpi_device_bid(device),
 	       ac->state ? "on-line" : "off-line");
 
-      end:
+end:
 	if (result) {
 #ifdef CONFIG_ACPI_PROCFS_POWER
 		acpi_ac_remove_fs(device);
-- 
1.7.4.2

