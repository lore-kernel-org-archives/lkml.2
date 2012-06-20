Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab2FTD0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 23:26:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55491 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab2FTD0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 23:26:36 -0400
From: Alex Hung <alex.hung@canonical.com>
To: alex.hung@canonical.com, corentincj@iksaif.net, mjg@redhat.com,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] eeepc-wmi: change wireless key event to toggle all wireless devices.
Date: Wed, 20 Jun 2012 11:26:28 +0800
Message-Id: <1340162788-531-1-git-send-email-alex.hung@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original key event from Fn+F2 hotkey only toggles the state of wireless
LAN and leaves other wireless devices such as bluetooth uncontrolled. This
fix change Fn+F2 to generate an event to toggle all wireless devices.

Signed-off-by: Alex Hung <alex.hung@canonical.com>
---
 drivers/platform/x86/eeepc-wmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index 5568c43..ef361fc 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -68,7 +68,7 @@ static const struct key_entry eeepc_wmi_keymap[] = {
 	{ KE_KEY, 0x31, { KEY_VOLUMEDOWN } },
 	{ KE_KEY, 0x32, { KEY_MUTE } },
 	{ KE_KEY, 0x5c, { KEY_F15 } }, /* Power Gear key */
-	{ KE_KEY, 0x5d, { KEY_WLAN } },
+	{ KE_KEY, 0x5d, { KEY_RFKILL } },
 	{ KE_KEY, 0x6b, { KEY_TOUCHPAD_TOGGLE } }, /* Toggle Touchpad */
 	{ KE_KEY, 0x82, { KEY_CAMERA } },
 	{ KE_KEY, 0x83, { KEY_CAMERA_ZOOMIN } },
-- 
1.7.0.4

