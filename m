Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab1BFMcD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 07:32:03 -0500
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:34131 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab1BFMcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 07:32:00 -0500
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.40
X-Originating-IP: 82.241.209.44
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Corentin Chary <corentincj@iksaif.net>, Dmitry Torokhov <dtor@mail.ru>,
        Henrik Rydberg <rydberg@euromail.se>, Daniel Mack <daniel@caiaq.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] eeepc-wmi: add camera keys
Date: Sun,  6 Feb 2011 13:30:47 +0100
Message-Id: <1296995448-5591-2-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <1296995448-5591-1-git-send-email-corentincj@iksaif.net>
References: <1296995448-5591-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These keys are supposed to be handled by any software
using the camera (like webKam or cheese...). They can
also be used to actually move the camera when possible.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/eeepc-wmi.c |    7 +++++++
 include/linux/input.h            |    7 +++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index b0b5a8f..bbcbd0f 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -114,11 +114,18 @@ static const struct key_entry eeepc_wmi_keymap[] = {
 	{ KE_KEY, 0x5c, { KEY_F15 } },
 	{ KE_KEY, 0x5d, { KEY_WLAN } },
 	{ KE_KEY, 0x6b, { KEY_F13 } }, /* Disable Touchpad */
+	{ KE_KEY, 0x82, { KEY_CAMERA } },
+	{ KE_KEY, 0x83, { KEY_CAMERA_ZOOMIN } },
 	{ KE_KEY, 0x88, { KEY_WLAN } },
 	{ KE_KEY, 0xcc, { KEY_SWITCHVIDEOMODE } },
 	{ KE_KEY, 0xe0, { KEY_PROG1 } },
 	{ KE_KEY, 0xe1, { KEY_F14 } },
 	{ KE_KEY, 0xe9, { KEY_BRIGHTNESS_ZERO } },
+	{ KE_KEY, 0xeb, { KEY_CAMERA_ZOOMOUT } },
+	{ KE_KEY, 0xec, { KEY_CAMERA_UP } },
+	{ KE_KEY, 0xed, { KEY_CAMERA_DOWN } },
+	{ KE_KEY, 0xee, { KEY_CAMERA_LEFT } },
+	{ KE_KEY, 0xef, { KEY_CAMERA_RIGHT } },
 	{ KE_END, 0},
 };
 
diff --git a/include/linux/input.h b/include/linux/input.h
index f7a6e19..4ca126f 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -651,6 +651,13 @@ struct input_keymap_entry {
 #define KEY_TOUCHPAD_ON		0x213
 #define KEY_TOUCHPAD_OFF	0x214
 
+#define KEY_CAMERA_ZOOMIN	0x215
+#define KEY_CAMERA_ZOOMOUT	0x216
+#define KEY_CAMERA_UP		0x217
+#define KEY_CAMERA_DOWN		0x218
+#define KEY_CAMERA_LEFT		0x219
+#define KEY_CAMERA_RIGHT	0x21a
+
 #define BTN_TRIGGER_HAPPY		0x2c0
 #define BTN_TRIGGER_HAPPY1		0x2c0
 #define BTN_TRIGGER_HAPPY2		0x2c1
-- 
1.7.4.rc3

