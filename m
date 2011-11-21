Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab1KUUtC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 15:49:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55393 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1KUUtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 15:49:00 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dell-wmi: Change debug statements from pr_info to pr_debug
Date: Mon, 21 Nov 2011 14:48:56 -0600
Message-Id: <1321908536-5163-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The debug statements reporting unkown WMI and hotkey events are
polluting the log in some systems and generating unnecessary
concern from users. Change these to pr_debug to hide them normally
while keeping them available for when they're needed.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/platform/x86/dell-wmi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
index fa9a217..1881e28 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -165,8 +165,8 @@ static void dell_wmi_notify(u32 value, void *context)
 		u16 *buffer_entry = (u16 *)obj->buffer.pointer;
 
 		if (dell_new_hk_type && (buffer_entry[1] != 0x10)) {
-			pr_info("Received unknown WMI event (0x%x)\n",
-				buffer_entry[1]);
+			pr_debug("Received unknown WMI event (0x%x)\n",
+				 buffer_entry[1]);
 			kfree(obj);
 			return;
 		}
@@ -179,7 +179,7 @@ static void dell_wmi_notify(u32 value, void *context)
 		key = sparse_keymap_entry_from_scancode(dell_wmi_input_dev,
 							reported_key);
 		if (!key) {
-			pr_info("Unknown key %x pressed\n", reported_key);
+			pr_debug("Unknown key %x pressed\n", reported_key);
 		} else if ((key->keycode == KEY_BRIGHTNESSUP ||
 			    key->keycode == KEY_BRIGHTNESSDOWN) && acpi_video) {
 			/* Don't report brightness notifications that will also
-- 
1.7.5.4

