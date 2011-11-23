Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447Ab1KWBBC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 20:01:02 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39929 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759406Ab1KWBBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 20:01:00 -0500
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: mjg@redhat.com
Cc: linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>,
        Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Dmitry Torokhov <dtor@mail.ru>, Corentin Chary <corentincj@iksaif.net>,
        Thomas Renninger <trenn@suse.de>
Subject: [PATCH] acer-wmi: remove useless input argument for internal wmi
Date: Wed, 23 Nov 2011 08:58:58 +0800
Message-Id: <1322009938-8875-1-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lee, Chun-Yi" <jlee@suse.com>

The "wmi_interface *iface" is a useless input argument for internal wmi get/set
functions, remove it to clear up source code.

Tested on Lenovo E520.
Tested on Acer TravelMate 4750.

Tested-by: mr.kobzar <mr.kobzar@gmail.com>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 drivers/platform/x86/acer-wmi.c |   30 ++++++++++++++----------------
 1 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index b848277..88dfecf 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -536,8 +536,7 @@ struct acpi_buffer *result)
 	return status;
 }
 
-static acpi_status AMW0_get_u32(u32 *value, u32 cap,
-struct wmi_interface *iface)
+static acpi_status AMW0_get_u32(u32 *value, u32 cap)
 {
 	int err;
 	u8 result;
@@ -607,7 +606,7 @@ struct wmi_interface *iface)
 	return AE_OK;
 }
 
-static acpi_status AMW0_set_u32(u32 value, u32 cap, struct wmi_interface *iface)
+static acpi_status AMW0_set_u32(u32 value, u32 cap)
 {
 	struct wmab_args args;
 
@@ -799,8 +798,7 @@ WMI_execute_u32(u32 method_id, u32 in, u32 *out)
 	return status;
 }
 
-static acpi_status WMID_get_u32(u32 *value, u32 cap,
-struct wmi_interface *iface)
+static acpi_status WMID_get_u32(u32 *value, u32 cap)
 {
 	acpi_status status;
 	u8 tmp;
@@ -836,7 +834,7 @@ struct wmi_interface *iface)
 	return status;
 }
 
-static acpi_status WMID_set_u32(u32 value, u32 cap, struct wmi_interface *iface)
+static acpi_status WMID_set_u32(u32 value, u32 cap)
 {
 	u32 method_id = 0;
 	char param;
@@ -1126,15 +1124,15 @@ static acpi_status get_u32(u32 *value, u32 cap)
 
 	switch (interface->type) {
 	case ACER_AMW0:
-		status = AMW0_get_u32(value, cap, interface);
+		status = AMW0_get_u32(value, cap);
 		break;
 	case ACER_AMW0_V2:
 		if (cap == ACER_CAP_MAILLED) {
-			status = AMW0_get_u32(value, cap, interface);
+			status = AMW0_get_u32(value, cap);
 			break;
 		}
 	case ACER_WMID:
-		status = WMID_get_u32(value, cap, interface);
+		status = WMID_get_u32(value, cap);
 		break;
 	case ACER_WMID_v2:
 		if (cap & (ACER_CAP_WIRELESS |
@@ -1142,7 +1140,7 @@ static acpi_status get_u32(u32 *value, u32 cap)
 			   ACER_CAP_THREEG))
 			status = wmid_v2_get_u32(value, cap);
 		else if (wmi_has_guid(WMID_GUID2))
-			status = WMID_get_u32(value, cap, interface);
+			status = WMID_get_u32(value, cap);
 		break;
 	}
 
@@ -1156,10 +1154,10 @@ static acpi_status set_u32(u32 value, u32 cap)
 	if (interface->capability & cap) {
 		switch (interface->type) {
 		case ACER_AMW0:
-			return AMW0_set_u32(value, cap, interface);
+			return AMW0_set_u32(value, cap);
 		case ACER_AMW0_V2:
 			if (cap == ACER_CAP_MAILLED)
-				return AMW0_set_u32(value, cap, interface);
+				return AMW0_set_u32(value, cap);
 
 			/*
 			 * On some models, some WMID methods don't toggle
@@ -1169,21 +1167,21 @@ static acpi_status set_u32(u32 value, u32 cap)
 			 */
 			if (cap == ACER_CAP_WIRELESS ||
 				cap == ACER_CAP_BLUETOOTH) {
-				status = WMID_set_u32(value, cap, interface);
+				status = WMID_set_u32(value, cap);
 				if (ACPI_FAILURE(status))
 					return status;
 
-				return AMW0_set_u32(value, cap, interface);
+				return AMW0_set_u32(value, cap);
 			}
 		case ACER_WMID:
-			return WMID_set_u32(value, cap, interface);
+			return WMID_set_u32(value, cap);
 		case ACER_WMID_v2:
 			if (cap & (ACER_CAP_WIRELESS |
 				   ACER_CAP_BLUETOOTH |
 				   ACER_CAP_THREEG))
 				return wmid_v2_set_u32(value, cap);
 			else if (wmi_has_guid(WMID_GUID2))
-				return WMID_set_u32(value, cap, interface);
+				return WMID_set_u32(value, cap);
 		default:
 			return AE_BAD_PARAMETER;
 		}
-- 
1.7.7

