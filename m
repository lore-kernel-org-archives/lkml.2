Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993046Ab2K3TCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:02:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:59622 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992945Ab2K3TC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:02:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Marek Vasut <marex@denx.de>, Chen Peter <B29397@freescale.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 39/54] HID: add quirk for Freescale i.MX28 ROM recovery
Date: Fri, 30 Nov 2012 10:56:10 -0800
Message-Id: <20121130185211.872118616@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185207.894301294@linuxfoundation.org>
References: <20121130185207.894301294@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

commit 2843b673d03421e0e73cf061820d1db328f7c8eb upstream.

The USB recovery mode present in i.MX28 ROM emulates USB HID.
It needs this quirk to behave properly.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Chen Peter <B29397@freescale.com>
Cc: Jiri Kosina <jkosina@suse.cz>
[jkosina@suse.cz: fix alphabetical ordering]
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-ids.h           |    3 +++
 drivers/hid/usbhid/hid-quirks.c |    1 +
 2 files changed, 4 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -296,6 +296,9 @@
 #define USB_VENDOR_ID_EZKEY		0x0518
 #define USB_DEVICE_ID_BTC_8193		0x0002
 
+#define USB_VENDOR_ID_FREESCALE		0x15A2
+#define USB_DEVICE_ID_FREESCALE_MX28	0x004F
+
 #define USB_VENDOR_ID_FRUCTEL	0x25B6
 #define USB_DEVICE_ID_GAMETEL_MT_MODE	0x0002
 
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -70,6 +70,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_AXIS_295, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_DMI, USB_DEVICE_ID_DMI_ENC, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_ELO, USB_DEVICE_ID_ELO_TS2700, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_FREESCALE, USB_DEVICE_ID_FREESCALE_MX28, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_MGE, USB_DEVICE_ID_MGE_UPS, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN1, HID_QUIRK_NO_INIT_REPORTS },


