Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab2BNPvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 10:51:40 -0500
Received: from mail.cs.tut.fi ([130.230.4.42]:64373 "HELO mail.cs.tut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751147Ab2BNPvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 10:51:36 -0500
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Feb 2012 10:51:26 EST
Message-ID: <4F3A80DC.4090203@iki.fi>
Date: Tue, 14 Feb 2012 17:42:20 +0200
From: Ville Ranki <ville.ranki@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH] HID: Add quirk for CH Products Fighterstick
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CH Fighterstick requires HID_QUIRK_NOGET as many other
CH devices do. This patch adds device id for Fighterstick
and adds necessary line to HID quirk list.

Tested only on one PC only. The fix is trivial and
well understood so I believe this is enough.

Signed-off-by: Ville Ranki <ville.ranki@iki.fi>
---
 drivers/hid/hid-ids.h           |    1 +
 drivers/hid/usbhid/hid-quirks.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index b8574cd..f4b5a73 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -173,6 +173,7 @@
 #define USB_VENDOR_ID_CH		0x068e
 #define USB_DEVICE_ID_CH_PRO_THROTTLE	0x00f1
 #define USB_DEVICE_ID_CH_PRO_PEDALS	0x00f2
+#define USB_DEVICE_ID_CH_FIGHTERSTICK	0x00f3
 #define USB_DEVICE_ID_CH_COMBATSTICK	0x00f4
 #define USB_DEVICE_ID_CH_FLIGHT_SIM_ECLIPSE_YOKE       0x0051
 #define USB_DEVICE_ID_CH_FLIGHT_SIM_YOKE	0x00ff
diff --git a/drivers/hid/usbhid/hid-quirks.c
b/drivers/hid/usbhid/hid-quirks.c
index c831af9..ae7d283 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -59,6 +59,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_ATEN, USB_DEVICE_ID_ATEN_2PORTKVM, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_ATEN, USB_DEVICE_ID_ATEN_4PORTKVM, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_ATEN, USB_DEVICE_ID_ATEN_4PORTKVMC, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_FIGHTERSTICK, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_COMBATSTICK, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_FLIGHT_SIM_ECLIPSE_YOKE,
HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_FLIGHT_SIM_YOKE, HID_QUIRK_NOGET },
-- 
1.7.5.4

-- 
Ville Ranki <ville.ranki@iki.fi>
http://www.iki.fi/~cos
