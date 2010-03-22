Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab0CVOsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 10:48:33 -0400
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:35446 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751916Ab0CVOsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 10:48:31 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-05.arcor-online.net D396D332B63
Subject: [PATCH 2/2] Updated hid_blacklist, reformatted code and removed
 unused variable
From: Stefan Achatz <erazor_de@users.sourceforge.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Stephane Chatty <chatty@enac.fr>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, wylda@volny.cz,
       Michael Poole <mdpoole@troilus.org>, simon.windows@gmail.com,
       Sean Hildebrand <silverwraithii@gmail.com>,
       Sid Boyce <sboyce@blueyonder.co.uk>, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org, linux-input@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1003220936270.18642@pobox.suse.cz>
References: <1268926981.11269.3.camel@localhost>
	 <alpine.LNX.2.00.1003220936270.18642@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Mar 2010 15:48:24 +0100
Message-ID: <1269269304.2236.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated hid_blacklist[] so that generic driver keeps his hands off.
Reformatted code so that definition of kone_driver and kone_devices[]
have one initialization per line and closing brace is on extra line.
Removed an unused variable declaration.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-core.c        |    1 +
 drivers/hid/hid-roccat-kone.c |   15 ++++++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 368fbb0..dbd6fb8 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1346,6 +1346,7 @@ static const struct hid_device_id hid_blacklist[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PETALYNX, USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS3_CONTROLLER) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS3_CONTROLLER) },
diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
index 1a5e993..2b1412e 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -509,7 +509,7 @@ static ssize_t kone_sysfs_set_tcu(struct device *dev,
 {
 	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
 	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
-	int retval, checksum;
+	int retval;
 	unsigned long state;
 
 	retval = strict_strtoul(buf, 10, &state);
@@ -975,13 +975,18 @@ static int kone_raw_event(struct hid_device *hdev, struct hid_report *report,
 
 static const struct hid_device_id kone_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONE) },
-	{ } };
+	{ }
+};
 
 MODULE_DEVICE_TABLE(hid, kone_devices);
 
-static struct hid_driver kone_driver = { .name = "kone",
-		.id_table = kone_devices, .probe = kone_probe,
-		.remove = kone_remove, .raw_event = kone_raw_event, };
+static struct hid_driver kone_driver = {
+		.name = "kone",
+		.id_table = kone_devices,
+		.probe = kone_probe,
+		.remove = kone_remove,
+		.raw_event = kone_raw_event
+};
 
 static int kone_init(void)
 {
-- 
1.6.6.1



