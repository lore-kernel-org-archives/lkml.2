Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab1CWTlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 15:41:08 -0400
Received: from adelie.canonical.com ([91.189.90.139]:42472 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756621Ab1CWTlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 15:41:05 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Corentin Chary <corentincj@iksaif.net>
Cc: Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] eeepc-wmi: Add support for T101MT "Express Gate" key
Date: Wed, 23 Mar 2011 14:39:49 -0500
Message-Id: <1300909189-4135-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---

This button is unusual. On press it emits scanocde 0xe4, on release
0xe5, and when held for a few seconds it begins emitting 0xea about
twice per second. I chose to handle only the press event in order to
make it behave like the other hotkeys.

Probably the closest thing to the intended function of this button
would be to alternate the display orientation between portrait and
landscape, but since there doesn't appear to be a keycode defined for
that function I went with KEY_PROG2. I'm open to other suggestions
however.

 drivers/platform/x86/eeepc-wmi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index 0ddc434..d761f60 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -70,6 +70,7 @@ static const struct key_entry eeepc_wmi_keymap[] = {
 	{ KE_KEY, 0xcc, { KEY_SWITCHVIDEOMODE } },
 	{ KE_KEY, 0xe0, { KEY_PROG1 } }, /* Task Manager */
 	{ KE_KEY, 0xe1, { KEY_F14 } }, /* Change Resolution */
+	{ KE_KEY, 0xe4, { KEY_PROG2 } }, /* Rotate Display */
 	{ KE_KEY, 0xe9, { KEY_BRIGHTNESS_ZERO } },
 	{ KE_KEY, 0xeb, { KEY_CAMERA_ZOOMOUT } },
 	{ KE_KEY, 0xec, { KEY_CAMERA_UP } },
-- 
1.7.4.1

