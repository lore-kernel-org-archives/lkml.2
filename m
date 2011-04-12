Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab1DLD7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 23:59:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57141 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509Ab1DLD7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 23:59:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jm+/NVi60Qky+Q/hqrfX7CWRv4Qnz5KDyt+lgt+7vcPaR35plKZQiVa7b/SNcdq0Xi
         wyqiW1oNbuymsnTHCacGpNMnnRbmc4/OoRigB8rYPV/5KcBJej80RAMJIaYK0kw2fhVP
         X/+NeFYlTZwoKVGpA67FtgBTUCsvFEddM9KXg=
From: Timothy Courrejou <timcour@gmail.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Timothy Courrejou <timcour@gmail.com>
Subject: [PATCH 2/2] ACPI: ac: fixed indentation, commenting and line length coding style issues
Date: Mon, 11 Apr 2011 20:59:23 -0700
Message-Id: <1302580763-11859-1-git-send-email-timcour@gmail.com>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issues.

Signed-off-by: Timothy Courrejou <timcour@gmail.com>
---
 drivers/acpi/ac.c |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index 183a035..58c3f74 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -85,7 +85,7 @@ static struct acpi_driver acpi_ac_driver = {
 
 struct acpi_ac {
 	struct power_supply charger;
-	struct acpi_device *device;
+	struct acpi_device * device;
 	unsigned long long state;
 };
 
@@ -101,9 +101,10 @@ static const struct file_operations acpi_ac_fops = {
 };
 #endif
 
-/*
- * AC Adapter Management
- */
+/* --------------------------------------------------------------------------
+                               AC Adapter Management
+   -------------------------------------------------------------------------- */
+
 static int acpi_ac_get_state(struct acpi_ac *ac)
 {
 	acpi_status status = AE_OK;
@@ -112,11 +113,9 @@ static int acpi_ac_get_state(struct acpi_ac *ac)
 	if (!ac)
 		return -EINVAL;
 
-	status = acpi_evaluate_integer(ac->device->handle,
-				       "_PSR", NULL, &ac->state);
+	status = acpi_evaluate_integer(ac->device->handle, "_PSR", NULL, &ac->state);
 	if (ACPI_FAILURE(status)) {
-		ACPI_EXCEPTION((AE_INFO, status,
-				"Error reading AC Adapter state"));
+		ACPI_EXCEPTION((AE_INFO, status, "Error reading AC Adapter state"));
 		ac->state = ACPI_AC_STATUS_UNKNOWN;
 		return -ENODEV;
 	}
@@ -124,9 +123,9 @@ static int acpi_ac_get_state(struct acpi_ac *ac)
 	return 0;
 }
 
-/*
- * sysfs I/F
- */
+/* --------------------------------------------------------------------------
+                            sysfs I/F
+   -------------------------------------------------------------------------- */
 static int get_ac_property(struct power_supply *psy,
 			   enum power_supply_property psp,
 			   union power_supply_propval *val)
@@ -154,10 +153,10 @@ static enum power_supply_property ac_props[] = {
 };
 
 #ifdef CONFIG_ACPI_PROCFS_POWER
+/* --------------------------------------------------------------------------
+                              FS Interface (/proc)
+   -------------------------------------------------------------------------- */
 
-/*
- * FS Interface (/proc)
- */
 static struct proc_dir_entry *acpi_ac_dir;
 
 static int acpi_ac_seq_show(struct seq_file *seq, void *offset)
@@ -230,9 +229,10 @@ static int acpi_ac_remove_fs(struct acpi_device *device)
 }
 #endif
 
-/*
- * Driver Model
- */
+/* --------------------------------------------------------------------------
+                                   Driver Model
+   -------------------------------------------------------------------------- */
+
 static void acpi_ac_notify(struct acpi_device *device, u32 event)
 {
 	struct acpi_ac *ac = acpi_driver_data(device);
@@ -298,7 +298,7 @@ static int acpi_ac_add(struct acpi_device *device)
 	       acpi_device_name(device), acpi_device_bid(device),
 	       ac->state ? "on-line" : "off-line");
 
-end:
+      end:
 	if (result) {
 #ifdef CONFIG_ACPI_PROCFS_POWER
 		acpi_ac_remove_fs(device);
-- 
1.7.4.2

