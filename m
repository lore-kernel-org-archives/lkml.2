Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab2AXCqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:46:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50410 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932535Ab2AXCqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:46:40 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:31 2012
Message-Id: <20120124023931.583421981@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:35:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>
Subject: [086/129] HID: multitouch: add support of Atmel multitouch panels
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1598
Lines: 52

From: Benjamin Tissoires <benjamin.tissoires@gmail.com>

commit b105712469d957cf1ab223c1ea72b7ba88edb926 upstream.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Acked-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/Kconfig          |    1 +
 drivers/hid/hid-ids.h        |    3 +++
 drivers/hid/hid-multitouch.c |    5 +++++
 3 files changed, 9 insertions(+)

--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -335,6 +335,7 @@ config HID_MULTITOUCH
 	  Say Y here if you have one of the following devices:
 	  - 3M PCT touch screens
 	  - ActionStar dual touch panels
+	  - Atmel panels
 	  - Cando dual touch panels
 	  - Chunghwa panels
 	  - CVTouch panels
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -145,6 +145,9 @@
 #define USB_DEVICE_ID_ATEN_4PORTKVM	0x2205
 #define USB_DEVICE_ID_ATEN_4PORTKVMC	0x2208
 
+#define USB_VENDOR_ID_ATMEL		0x03eb
+#define USB_DEVICE_ID_ATMEL_MULTITOUCH	0x211c
+
 #define USB_VENDOR_ID_AVERMEDIA		0x07ca
 #define USB_DEVICE_ID_AVER_FM_MR800	0xb800
 
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -615,6 +615,11 @@ static const struct hid_device_id mt_dev
 		HID_USB_DEVICE(USB_VENDOR_ID_ACTIONSTAR,
 			USB_DEVICE_ID_ACTIONSTAR_1011) },
 
+	/* Atmel panels */
+	{ .driver_data = MT_CLS_SERIAL,
+		HID_USB_DEVICE(USB_VENDOR_ID_ATMEL,
+			USB_DEVICE_ID_ATMEL_MULTITOUCH) },
+
 	/* Cando panels */
 	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
 		HID_USB_DEVICE(USB_VENDOR_ID_CANDO,


