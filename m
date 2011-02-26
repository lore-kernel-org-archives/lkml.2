Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab1BZJWq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 04:22:46 -0500
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:37331 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab1BZJWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 04:22:39 -0500
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.38
X-Originating-IP: 82.241.209.44
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net (open list:ASUS NOTEBOOKS AN...),
        platform-driver-x86@vger.kernel.org (open list:ASUS NOTEBOOKS AN...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 03/14] asus-wmi: minor cleanups
Date: Sat, 26 Feb 2011 10:20:32 +0100
Message-Id: <1298712045-17671-4-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298712045-17671-1-git-send-email-corentincj@iksaif.net>
References: <1298712045-17671-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-wmi.c  |   34 +++++++++++++++++-----------------
 drivers/platform/x86/eeepc-wmi.c |    2 +-
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 35e6bb6..4c3f68a 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -2,7 +2,7 @@
  * Asus PC WMI hotkey driver
  *
  * Copyright(C) 2010 Intel Corporation.
- * Copyright(C) 2010 Corentin Chary <corentin.chary@gmail.com>
+ * Copyright(C) 2010-2011 Corentin Chary <corentin.chary@gmail.com>
  *
  * Portions based on wistron_btns.c:
  * Copyright (C) 2005 Miloslav Trmac <mitr@volny.cz>
@@ -87,7 +87,7 @@ MODULE_LICENSE("GPL");
 #define ASUS_WMI_DEVID_CARDREADER	0x00080013
 
 /* Input */
-#define ASUS_WMI_DEVID_TOUCHPAD	0x00100011
+#define ASUS_WMI_DEVID_TOUCHPAD		0x00100011
 #define ASUS_WMI_DEVID_TOUCHPAD_LED	0x00100012
 
 /* DSTS masks */
@@ -903,25 +903,25 @@ static void asus_wmi_notify(u32 value, void *context)
 
 	obj = (union acpi_object *)response.pointer;
 
-	if (obj && obj->type == ACPI_TYPE_INTEGER) {
-		code = obj->integer.value;
-		orig_code = code;
+	if (!obj || obj->type != ACPI_TYPE_INTEGER)
+		goto exit;
 
-		if (code >= NOTIFY_BRNUP_MIN && code <= NOTIFY_BRNUP_MAX)
-			code = NOTIFY_BRNUP_MIN;
-		else if (code >= NOTIFY_BRNDOWN_MIN &&
-			 code <= NOTIFY_BRNDOWN_MAX)
-			code = NOTIFY_BRNDOWN_MIN;
+	code = obj->integer.value;
+	orig_code = code;
 
-		if (code == NOTIFY_BRNUP_MIN || code == NOTIFY_BRNDOWN_MIN) {
-			if (!acpi_video_backlight_support())
-				asus_wmi_backlight_notify(asus, orig_code);
-		}
+	if (code >= NOTIFY_BRNUP_MIN && code <= NOTIFY_BRNUP_MAX)
+		code = NOTIFY_BRNUP_MIN;
+	else if (code >= NOTIFY_BRNDOWN_MIN &&
+		 code <= NOTIFY_BRNDOWN_MAX)
+		code = NOTIFY_BRNDOWN_MIN;
 
-		if (!sparse_keymap_report_event(asus->inputdev, code, 1, true))
-			pr_info("Unknown key %x pressed\n", code);
-	}
+	if (code == NOTIFY_BRNUP_MIN || code == NOTIFY_BRNDOWN_MIN) {
+		if (!acpi_video_backlight_support())
+			asus_wmi_backlight_notify(asus, orig_code);
+	} else if (!sparse_keymap_report_event(asus->inputdev, code, 1, true))
+		pr_info("Unknown key %x pressed\n", code);
 
+exit:
 	kfree(obj);
 }
 
diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index 3a060ae..e69701f 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -2,7 +2,7 @@
  * Eee PC WMI hotkey driver
  *
  * Copyright(C) 2010 Intel Corporation.
- * Copyright(C) 2010 Corentin Chary <corentin.chary@gmail.com>
+ * Copyright(C) 2010-2011 Corentin Chary <corentin.chary@gmail.com>
  *
  * Portions based on wistron_btns.c:
  * Copyright (C) 2005 Miloslav Trmac <mitr@volny.cz>
-- 
1.7.4

