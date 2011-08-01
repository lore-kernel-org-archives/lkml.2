Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab1HAUqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 16:46:19 -0400
Received: from adelie.canonical.com ([91.189.90.139]:49812 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab1HAUqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 16:46:14 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dell-wmi: Add keys for Dell XPS L502X
Date: Mon,  1 Aug 2011 15:46:10 -0500
Message-Id: <1312231570-16376-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All of these keys are being reported on the keyboard
controller but are also generating WMI events. Add them
to the legacy keymap to silence the noise.

BugLink: http://bugs.launchpad.net/bugs/815914
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/platform/x86/dell-wmi.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
index ce79082..fa9a217 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -54,6 +54,8 @@ MODULE_ALIAS("wmi:"DELL_EVENT_GUID);
  */
 
 static const struct key_entry dell_wmi_legacy_keymap[] __initconst = {
+	{ KE_IGNORE, 0x003a, { KEY_CAPSLOCK } },
+
 	{ KE_KEY, 0xe045, { KEY_PROG1 } },
 	{ KE_KEY, 0xe009, { KEY_EJECTCD } },
 
@@ -85,6 +87,11 @@ static const struct key_entry dell_wmi_legacy_keymap[] __initconst = {
 	{ KE_IGNORE, 0xe013, { KEY_RESERVED } },
 
 	{ KE_IGNORE, 0xe020, { KEY_MUTE } },
+
+	/* Shortcut and audio panel keys */
+	{ KE_IGNORE, 0xe025, { KEY_RESERVED } },
+	{ KE_IGNORE, 0xe026, { KEY_RESERVED } },
+
 	{ KE_IGNORE, 0xe02e, { KEY_VOLUMEDOWN } },
 	{ KE_IGNORE, 0xe030, { KEY_VOLUMEUP } },
 	{ KE_IGNORE, 0xe033, { KEY_KBDILLUMUP } },
@@ -92,6 +99,9 @@ static const struct key_entry dell_wmi_legacy_keymap[] __initconst = {
 	{ KE_IGNORE, 0xe03a, { KEY_CAPSLOCK } },
 	{ KE_IGNORE, 0xe045, { KEY_NUMLOCK } },
 	{ KE_IGNORE, 0xe046, { KEY_SCROLLLOCK } },
+	{ KE_IGNORE, 0xe0f7, { KEY_MUTE } },
+	{ KE_IGNORE, 0xe0f8, { KEY_VOLUMEDOWN } },
+	{ KE_IGNORE, 0xe0f9, { KEY_VOLUMEUP } },
 	{ KE_END, 0 }
 };
 
-- 
1.7.4.1

