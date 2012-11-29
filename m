Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab2K2IN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 03:13:56 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:34935 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134Ab2K2INx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 03:13:53 -0500
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/11] asus-wmi: always report brightness key events
Date: Thu, 29 Nov 2012 09:12:38 +0100
Message-Id: <1354176759-630-11-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1354176759-630-1-git-send-email-corentin.chary@gmail.com>
References: <1354176759-630-1-git-send-email-corentin.chary@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-nb-wmi.c |    2 ++
 drivers/platform/x86/asus-wmi.c    |    8 ++++----
 drivers/platform/x86/asus-wmi.h    |    2 ++
 drivers/platform/x86/eeepc-wmi.c   |    2 ++
 4 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 9aa6642..210b5b8 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -190,6 +190,8 @@ static void asus_nb_wmi_quirks(struct asus_wmi_driver *driver)
 }
 
 static const struct key_entry asus_nb_wmi_keymap[] = {
+	{ KE_KEY, ASUS_WMI_BRN_DOWN, { KEY_BRIGHTNESSDOWN } },
+	{ KE_KEY, ASUS_WMI_BRN_UP, { KEY_BRIGHTNESSUP } },
 	{ KE_KEY, 0x30, { KEY_VOLUMEUP } },
 	{ KE_KEY, 0x31, { KEY_VOLUMEDOWN } },
 	{ KE_KEY, 0x32, { KEY_MUTE } },
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 6327a1b..c11b242 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1386,16 +1386,16 @@ static void asus_wmi_notify(u32 value, void *context)
 	}
 
 	if (code >= NOTIFY_BRNUP_MIN && code <= NOTIFY_BRNUP_MAX)
-		code = NOTIFY_BRNUP_MIN;
+		code = ASUS_WMI_BRN_UP;
 	else if (code >= NOTIFY_BRNDOWN_MIN &&
 		 code <= NOTIFY_BRNDOWN_MAX)
-		code = NOTIFY_BRNDOWN_MIN;
+		code = ASUS_WMI_BRN_DOWN;
 
-	if (code == NOTIFY_BRNUP_MIN || code == NOTIFY_BRNDOWN_MIN) {
+	if (code == ASUS_WMI_BRN_DOWN || code == ASUS_WMI_BRN_UP) {
 		if (!acpi_video_backlight_support()) {
 			asus_wmi_backlight_notify(asus, orig_code);
+			goto exit;
 		}
-		goto exit;
 	}
 
 	if (is_display_toggle(code) &&
diff --git a/drivers/platform/x86/asus-wmi.h b/drivers/platform/x86/asus-wmi.h
index 776524c..4da4c8b 100644
--- a/drivers/platform/x86/asus-wmi.h
+++ b/drivers/platform/x86/asus-wmi.h
@@ -30,6 +30,8 @@
 #include <linux/platform_device.h>
 
 #define ASUS_WMI_KEY_IGNORE (-1)
+#define ASUS_WMI_BRN_DOWN	0x20
+#define ASUS_WMI_BRN_UP		0x2f
 
 struct module;
 struct key_entry;
diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index 60cb76a..af67e6e 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -63,6 +63,8 @@ MODULE_PARM_DESC(hotplug_wireless,
 #define HOME_RELEASE	0xe5
 
 static const struct key_entry eeepc_wmi_keymap[] = {
+	{ KE_KEY, ASUS_WMI_BRN_DOWN, { KEY_BRIGHTNESSDOWN } },
+	{ KE_KEY, ASUS_WMI_BRN_UP, { KEY_BRIGHTNESSUP } },
 	/* Sleep already handled via generic ACPI code */
 	{ KE_KEY, 0x30, { KEY_VOLUMEUP } },
 	{ KE_KEY, 0x31, { KEY_VOLUMEDOWN } },
-- 
1.7.8.6

