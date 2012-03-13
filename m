Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965201Ab2CMAbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:31:43 -0400
Received: from mail.windriver.com ([147.11.1.11]:48848 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965162Ab2CMAYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:45 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "michael@alice-dsl.net" <michael@alice-dsl.net>,
        =?UTF-8?q?Michael=20M=C3=BCller?= <mueller_michael@alice-dsl.net>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Patrick Boettcher <pboettcher@kernellabs.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 145/196] V4L/DVB: Add Elgato EyeTV Diversity to dibcom driver
Date: Mon, 12 Mar 2012 20:20:58 -0400
Message-Id: <1331598109-31424-100-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "michael@alice-dsl.net" <michael@alice-dsl.net>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 84e2f037ce9672d0fb118e3e82cecfe6122ace3f upstream.

This patch introduces support for DVB-T for the following dibcom
based card: Elgato EyeTV Diversity (USB-ID: 0fd9:0011)

Support for the Elgato silver IR remote is added too (set parameter
dvb_usb_dib0700_ir_proto=0)

[w.sang@pengutronix.de: rebased to current linuxtv-master]
Signed-off-by: Michael Müller <mueller_michael@alice-dsl.net>
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Patrick Boettcher <pboettcher@kernellabs.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/media/dvb/dvb-usb/dib0700_devices.c |   46 +++++++++++++++++++++++++--
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h     |    1 +
 2 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index 34eab05..f9052be 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -794,6 +794,43 @@ static struct dvb_usb_rc_key dib0700_rc_keys[] = {
 	{ 0x7a13, KEY_VOLUMEDOWN },
 	{ 0x7a40, KEY_POWER },
 	{ 0x7a41, KEY_MUTE },
+
+	/* Key codes for the Elgato EyeTV Diversity silver remote,
+	   set dvb_usb_dib0700_ir_proto=0 */
+	{ 0x4501, KEY_POWER },
+	{ 0x4502, KEY_MUTE },
+	{ 0x4503, KEY_1 },
+	{ 0x4504, KEY_2 },
+	{ 0x4505, KEY_3 },
+	{ 0x4506, KEY_4 },
+	{ 0x4507, KEY_5 },
+	{ 0x4508, KEY_6 },
+	{ 0x4509, KEY_7 },
+	{ 0x450a, KEY_8 },
+	{ 0x450b, KEY_9 },
+	{ 0x450c, KEY_LAST },
+	{ 0x450d, KEY_0 },
+	{ 0x450e, KEY_ENTER },
+	{ 0x450f, KEY_RED },
+	{ 0x4510, KEY_CHANNELUP },
+	{ 0x4511, KEY_GREEN },
+	{ 0x4512, KEY_VOLUMEDOWN },
+	{ 0x4513, KEY_OK },
+	{ 0x4514, KEY_VOLUMEUP },
+	{ 0x4515, KEY_YELLOW },
+	{ 0x4516, KEY_CHANNELDOWN },
+	{ 0x4517, KEY_BLUE },
+	{ 0x4518, KEY_LEFT }, /* Skip backwards */
+	{ 0x4519, KEY_PLAYPAUSE },
+	{ 0x451a, KEY_RIGHT }, /* Skip forward */
+	{ 0x451b, KEY_REWIND },
+	{ 0x451c, KEY_L }, /* Live */
+	{ 0x451d, KEY_FASTFORWARD },
+	{ 0x451e, KEY_STOP }, /* 'Reveal' for Teletext */
+	{ 0x451f, KEY_MENU }, /* KEY_TEXT for Teletext */
+	{ 0x4540, KEY_RECORD }, /* Font 'Size' for Teletext */
+	{ 0x4541, KEY_SCREEN }, /*  Full screen toggle, 'Hold' for Teletext */
+	{ 0x4542, KEY_SELECT }, /* Select video input, 'Select' for Teletext */
 };
 
 /* STK7700P: Hauppauge Nova-T Stick, AVerMedia Volar */
@@ -2049,6 +2086,7 @@ struct usb_device_id dib0700_usb_id_table[] = {
 /* 65 */{ USB_DEVICE(USB_VID_PINNACLE,	USB_PID_PINNACLE_PCTV73ESE) },
 	{ USB_DEVICE(USB_VID_PINNACLE,	USB_PID_PINNACLE_PCTV282E) },
 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK8096GP) },
+	{ USB_DEVICE(USB_VID_ELGATO,    USB_PID_ELGATO_EYETV_DIVERSITY) },
 	{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -2393,7 +2431,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			}
 		},
 
-		.num_device_descs = 6,
+		.num_device_descs = 7,
 		.devices = {
 			{   "DiBcom STK7070PD reference design",
 				{ &dib0700_usb_id_table[17], NULL },
@@ -2419,7 +2457,11 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			{  "Sony PlayTV",
 				{ &dib0700_usb_id_table[44], NULL },
 				{ NULL },
-			}
+			},
+			{   "Elgato EyeTV Diversity",
+				{ &dib0700_usb_id_table[68], NULL },
+				{ NULL },
+			},
 		},
 		.rc_interval      = DEFAULT_RC_INTERVAL,
 		.rc_key_map       = dib0700_rc_keys,
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index ae8b57a..71dfc7c 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -288,6 +288,7 @@
 #define USB_PID_MSI_DIGI_VOX_MINI_III                   0x8807
 #define USB_PID_SONY_PLAYTV				0x0003
 #define USB_PID_MYGICA_D689				0xd811
+#define USB_PID_ELGATO_EYETV_DIVERSITY			0x0011
 #define USB_PID_ELGATO_EYETV_DTT			0x0021
 #define USB_PID_ELGATO_EYETV_DTT_Dlx			0x0020
 #define USB_PID_DVB_T_USB_STICK_HIGH_SPEED_COLD		0x5000
-- 
1.7.9.3

