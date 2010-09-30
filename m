Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487Ab0I3VVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 17:21:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34648 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218Ab0I3VVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 17:21:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BgKxadQ9BgVrlldDDjWEyvnz2xNUbsCgwRmRszMUDLH5Iecl45Vw7hEbhOxO/Kc6B+
         pTjSoCzrQSviQb6hc+fLIEp3+ksdiSoguvWxmUkLpa288/rzaO8uLQ9Yr0eTnSENgzzI
         n8xPNkaiFUv21MUImFtPaNlHk0q6rPHDdly8s=
From: Rok Mandeljc <rok.mandeljc@gmail.com>
To: jkosina@suse.cz, chatty@enac.fr, cascardo@holoscopio.com, don@syst.com.br,
        peter.hutterer@who-t.net
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH] HID: add NOGET quirk for AXIS 295 Video Surveillance Joystick
Date: Thu, 30 Sep 2010 23:24:30 +0200
Message-Id: <1285881870-5184-1-git-send-email-rok.mandeljc@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the NOGET quirk for AXIS 295 Video Surveillance Joystick (despite AXIS brand the vendor is actually CH Products). Without the quirk, the joystick is detected but does not generate any events.

Signed-off-by: Rok Mandeljc <rok.mandeljc@gmail.com>
---
 drivers/hid/hid-ids.h           |    1 +
 drivers/hid/usbhid/hid-quirks.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 765a4f5..4c7081e 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -141,6 +141,7 @@
 #define USB_DEVICE_ID_CH_FLIGHT_SIM_ECLIPSE_YOKE       0x0051
 #define USB_DEVICE_ID_CH_FLIGHT_SIM_YOKE	0x00ff
 #define USB_DEVICE_ID_CH_3AXIS_5BUTTON_STICK	0x00d3
+#define USB_DEVICE_ID_CH_AXIS_295	0x001c
 
 #define USB_VENDOR_ID_CHERRY		0x046a
 #define USB_DEVICE_ID_CHERRY_CYMOTION	0x0023
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 70da318..f13adb2 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -62,6 +62,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_FLIGHT_SIM_YOKE, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_PRO_PEDALS, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_3AXIS_5BUTTON_STICK, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_AXIS_295, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_DMI, USB_DEVICE_ID_DMI_ENC, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_ELO, USB_DEVICE_ID_ELO_TS2700, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_PRODIGE, USB_DEVICE_ID_PRODIGE_CORDLESS, HID_QUIRK_NOGET },
-- 
1.7.2.3

