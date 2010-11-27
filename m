Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab0K0HfS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 02:35:18 -0500
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:40672 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750939Ab0K0HfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 02:35:14 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-06.arcor-online.net 15EEA1475C2
Subject: [PATCH] HID: roccat: replaced #pragma pack() with __packed macro
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>
In-Reply-To: <1290804616.3051.52.camel@localhost>
References: <1290801456.18750.164.camel@neuromancer>
	 <1290804616.3051.52.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Nov 2010 08:35:11 +0100
Message-ID: <1290843311.2308.3.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pragma pack() seems to be unwanted, so I replaced it with __packed.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-kone.h     |   22 +++++++---------------
 drivers/hid/hid-roccat-koneplus.h |   36 ++++++++++++++----------------------
 drivers/hid/hid-roccat-pyra.h     |   26 +++++++++-----------------
 3 files changed, 30 insertions(+), 54 deletions(-)

diff --git a/drivers/hid/hid-roccat-kone.h b/drivers/hid/hid-roccat-kone.h
index 11203a7..f4e220f 100644
--- a/drivers/hid/hid-roccat-kone.h
+++ b/drivers/hid/hid-roccat-kone.h
@@ -14,17 +14,11 @@
 
 #include <linux/types.h>
 
-/*
- * Binary data structures used for hardware communication must have no padding.
- */
-#pragma pack(push)
-#pragma pack(1)
-
 struct kone_keystroke {
 	uint8_t key;
 	uint8_t action;
 	uint16_t period; /* in milliseconds */
-};
+} __packed;
 
 enum kone_keystroke_buttons {
 	kone_keystroke_button_1 = 0xf0, /* left mouse button */
@@ -47,7 +41,7 @@ struct kone_button_info {
 	uint8_t macro_name[16]; /* can be max 15 chars long */
 	uint8_t count;
 	struct kone_keystroke keystrokes[20];
-};
+} __packed;
 
 enum kone_button_info_types {
 	/* valid button types until firmware 1.32 */
@@ -98,7 +92,7 @@ struct kone_light_info {
 	uint8_t red;   /* range 0x00-0xff */
 	uint8_t green; /* range 0x00-0xff */
 	uint8_t blue;  /* range 0x00-0xff */
-};
+} __packed;
 
 struct kone_profile {
 	uint16_t size; /* always 975 */
@@ -133,7 +127,7 @@ struct kone_profile {
 	struct kone_button_info button_infos[8];
 
 	uint16_t checksum; /* \brief holds checksum of struct */
-};
+} __packed;
 
 enum kone_polling_rates {
 	kone_polling_rate_125 = 1,
@@ -150,7 +144,7 @@ struct kone_settings {
 	uint8_t  calibration_data[4];
 	uint8_t  unknown3[2];
 	uint16_t checksum;
-};
+} __packed;
 
 /*
  * 12 byte mouse event read by interrupt_read
@@ -166,7 +160,7 @@ struct kone_mouse_event {
 	uint8_t event;
 	uint8_t value; /* press = 0, release = 1 */
 	uint8_t macro_key; /* 0 to 8 */
-};
+} __packed;
 
 enum kone_mouse_events {
 	/* osd events are thought to be display on screen */
@@ -194,9 +188,7 @@ struct kone_roccat_report {
 	uint8_t event;
 	uint8_t value; /* holds dpi or profile value */
 	uint8_t key; /* macro key on overlong macro execution */
-};
-
-#pragma pack(pop)
+} __packed;
 
 struct kone_device {
 	/*
diff --git a/drivers/hid/hid-roccat-koneplus.h b/drivers/hid/hid-roccat-koneplus.h
index 905e33d..e26eebf 100644
--- a/drivers/hid/hid-roccat-koneplus.h
+++ b/drivers/hid/hid-roccat-koneplus.h
@@ -15,12 +15,6 @@
 #include <linux/types.h>
 
 /*
- * Binary data structures used for hardware communication must have no padding.
- */
-#pragma pack(push)
-#pragma pack(1)
-
-/*
  * case 1: writes request 80 and reads value 1
  *
  */
@@ -32,7 +26,7 @@ struct koneplus_control {
 	 */
 	uint8_t value;
 	uint8_t request;
-};
+} __packed;
 
 enum koneplus_control_requests {
 	KONEPLUS_CONTROL_REQUEST_STATUS = 0x00,
@@ -50,7 +44,7 @@ struct koneplus_startup_profile {
 	uint8_t command; /* KONEPLUS_COMMAND_STARTUP_PROFILE */
 	uint8_t size; /* always 3 */
 	uint8_t startup_profile; /* Range 0-4! */
-};
+} __packed;
 
 struct koneplus_profile_settings {
 	uint8_t command; /* KONEPLUS_COMMAND_PROFILE_SETTINGS */
@@ -72,7 +66,7 @@ struct koneplus_profile_settings {
 	uint8_t light_effect_speed;
 	uint8_t lights[16];
 	uint16_t checksum;
-};
+} __packed;
 
 struct koneplus_profile_buttons {
 	uint8_t command; /* KONEPLUS_COMMAND_PROFILE_BUTTONS */
@@ -80,7 +74,7 @@ struct koneplus_profile_buttons {
 	uint8_t number; /* range 0-4 */
 	uint8_t data[72];
 	uint16_t checksum;
-};
+} __packed;
 
 struct koneplus_macro {
 	uint8_t command; /* KONEPLUS_COMMAND_MACRO */
@@ -89,31 +83,31 @@ struct koneplus_macro {
 	uint8_t button; /* range 0-23 */
 	uint8_t data[2075];
 	uint16_t checksum;
-};
+} __packed;
 
 struct koneplus_info {
 	uint8_t command; /* KONEPLUS_COMMAND_INFO */
 	uint8_t size; /* always 6 */
 	uint8_t firmware_version;
 	uint8_t unknown[3];
-};
+} __packed;
 
 struct koneplus_e {
 	uint8_t command; /* KONEPLUS_COMMAND_E */
 	uint8_t size; /* always 3 */
 	uint8_t unknown; /* TODO 1; 0 before firmware update */
-};
+} __packed;
 
 struct koneplus_sensor {
 	uint8_t command;  /* KONEPLUS_COMMAND_SENSOR */
 	uint8_t size; /* always 6 */
 	uint8_t data[4];
-};
+} __packed;
 
 struct koneplus_firmware_write {
 	uint8_t command; /* KONEPLUS_COMMAND_FIRMWARE_WRITE */
 	uint8_t unknown[1025];
-};
+} __packed;
 
 struct koneplus_firmware_write_control {
 	uint8_t command; /* KONEPLUS_COMMAND_FIRMWARE_WRITE_CONTROL */
@@ -123,18 +117,18 @@ struct koneplus_firmware_write_control {
 	 */
 	uint8_t value;
 	uint8_t unknown; /* always 0x75 */
-};
+} __packed;
 
 struct koneplus_tcu {
 	uint16_t usb_command; /* KONEPLUS_USB_COMMAND_TCU */
 	uint8_t data[2];
-};
+} __packed;
 
 struct koneplus_tcu_image {
 	uint16_t usb_command; /* KONEPLUS_USB_COMMAND_TCU */
 	uint8_t data[1024];
 	uint16_t checksum;
-};
+} __packed;
 
 enum koneplus_commands {
 	KONEPLUS_COMMAND_CONTROL = 0x4,
@@ -177,7 +171,7 @@ struct koneplus_mouse_report_button {
 	uint8_t data2;
 	uint8_t zero2;
 	uint8_t unknown[2];
-};
+} __packed;
 
 enum koneplus_mouse_report_button_types {
 	/* data1 = new profile range 1-5 */
@@ -211,9 +205,7 @@ struct koneplus_roccat_report {
 	uint8_t data1;
 	uint8_t data2;
 	uint8_t profile;
-};
-
-#pragma pack(pop)
+} __packed;
 
 struct koneplus_device {
 	int actual_profile;
diff --git a/drivers/hid/hid-roccat-pyra.h b/drivers/hid/hid-roccat-pyra.h
index ac5996e..4ab506f 100644
--- a/drivers/hid/hid-roccat-pyra.h
+++ b/drivers/hid/hid-roccat-pyra.h
@@ -14,17 +14,11 @@
 
 #include <linux/types.h>
 
-/*
- * Binary data structures used for hardware communication must have no padding.
- */
-#pragma pack(push)
-#pragma pack(1)
-
 struct pyra_b {
 	uint8_t command; /* PYRA_COMMAND_B */
 	uint8_t size; /* always 3 */
 	uint8_t unknown; /* 1 */
-};
+} __packed;
 
 struct pyra_control {
 	uint8_t command; /* PYRA_COMMAND_CONTROL */
@@ -34,7 +28,7 @@ struct pyra_control {
 	 */
 	uint8_t value; /* Range 0-4 */
 	uint8_t request;
-};
+} __packed;
 
 enum pyra_control_requests {
 	PYRA_CONTROL_REQUEST_STATUS = 0x00,
@@ -46,7 +40,7 @@ struct pyra_settings {
 	uint8_t command; /* PYRA_COMMAND_SETTINGS */
 	uint8_t size; /* always 3 */
 	uint8_t startup_profile; /* Range 0-4! */
-};
+} __packed;
 
 struct pyra_profile_settings {
 	uint8_t command; /* PYRA_COMMAND_PROFILE_SETTINGS */
@@ -61,7 +55,7 @@ struct pyra_profile_settings {
 	uint8_t light_effect;
 	uint8_t handedness;
 	uint16_t checksum; /* byte sum */
-};
+} __packed;
 
 struct pyra_profile_buttons {
 	uint8_t command; /* PYRA_COMMAND_PROFILE_BUTTONS */
@@ -69,7 +63,7 @@ struct pyra_profile_buttons {
 	uint8_t number; /* Range 0-4 */
 	uint8_t buttons[14];
 	uint16_t checksum; /* byte sum */
-};
+} __packed;
 
 struct pyra_info {
 	uint8_t command; /* PYRA_COMMAND_INFO */
@@ -78,7 +72,7 @@ struct pyra_info {
 	uint8_t unknown1; /* always 0 */
 	uint8_t unknown2; /* always 1 */
 	uint8_t unknown3; /* always 0 */
-};
+} __packed;
 
 enum pyra_commands {
 	PYRA_COMMAND_CONTROL = 0x4,
@@ -110,13 +104,13 @@ struct pyra_mouse_event_button {
 	uint8_t type;
 	uint8_t data1;
 	uint8_t data2;
-};
+} __packed;
 
 struct pyra_mouse_event_audio {
 	uint8_t report_number; /* always 2 */
 	uint8_t type;
 	uint8_t unused; /* always 0 */
-};
+} __packed;
 
 /* hid audio controls */
 enum pyra_mouse_event_audio_types {
@@ -170,9 +164,7 @@ struct pyra_roccat_report {
 	uint8_t type;
 	uint8_t value;
 	uint8_t key;
-};
-
-#pragma pack(pop)
+} __packed;
 
 struct pyra_device {
 	int actual_profile;
-- 
1.7.2.3



