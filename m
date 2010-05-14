Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab0ENQbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:31:06 -0400
Received: from smtp114.plus.mail.re1.yahoo.com ([69.147.102.77]:37171 "HELO
	smtp114.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750876Ab0ENQbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:31:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:Content-Type:Content-Transfer-Encoding;
  b=IdQPiTQK5zBvSZMpOQFqRkLTAZLH2qRCQWAKF295KWTGz3cTzG7hKwcBya3uVEtKlBHqKS4Fabmv9GZcdu73qee9Exv/xi71v+qj6YUTdXmMtNsygrDITvxg4383KwlIznFk+ThMvnLNGYe70BP7Q8n9R6w63OPF4J+m0cqnGJk=  ;
X-Yahoo-SMTP: 7VYQSIiswBBpfI3oQQ5mbefGCpOrHbDC5qsO
X-YMail-OSG: .QRF9gIVM1kjQLRrbm6bW2a8HaMMS6epLpqQGTvlNtOINBs
 qcxK11YZnR83BM4TZB3RVUYn1Ef8_SfYSmivVlEcL5i113PjAyS195E042VY
 tj4rsBJzK8qm522LxCppg2ZIIAWxUmIR_kgSlO1BmmoYZFEP.rCXjO2R.on5
 TKXP_w5L0TEMIDkSg9VMWCIVw7mSo02jKc1.yeSPFO9J4bpHhqwwCC1Odrtw
 reEOqNiOiArPkPBCEGWnFHVnn50HXvqmDOnPbHvCnolMKnmZPftskel4FYlZ
 UO0.mfkyuLiPavByzAKA_fPgANFNMZBCDXTZkV897F0keJSZar_K59TztWft
 lEnPQ.xLaeeUIQPRuHWQe_0mYUSEwbmw5lVfQ1Ga7IeZjP4rkcoEsgYjgUg2
 jpm7IEx0dGCk.9eWIDG7oyDEdvKhtf.mQP_eJOFFtKVpq37vAl.9I3jo-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4BED7AC3.8090808@yahoo.co.uk>
Date: Fri, 14 May 2010 17:30:59 +0100
From: Don Prince <dhprince.devel@yahoo.co.uk>
Reply-To: dhprince.devel@yahoo.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100422 Mandriva/3.0.4-0.4mdv2010.0 (2010.0) Thunderbird/3.0.4
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.34-rc5 v2] HID: Zydacron Remote Control HID Driver
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A specialised HID driver for the Zydacron Remote Control (usb id: 13ec:0006).

The specialised HID driver adds support for the buttons which are not

currently handled by the default HID driver.

Signed-off-by: Don Prince <dhprince-devel@yahoo.co.uk>

---

Applied fixes as requested by Jiri Kosina.

This remote control is labelled Packard Bell.

Apply patch with "patch -p1 < <path to patch>"

---

diff -X /opt/scripts/diff-exclude.txt -Npaur a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
--- a/drivers/hid/hid-core.c	2010-04-22 18:52:46.445384754 +0100
+++ b/drivers/hid/hid-core.c	2010-05-12 11:38:12.770567799 +0100
@@ -1365,6 +1365,7 @@ static const struct hid_device_id hid_bl
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_WACOM, USB_DEVICE_ID_WACOM_GRAPHIRE_BLUETOOTH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0005) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0030) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ZYDACRON, USB_DEVICE_ID_ZYDACRON_REMOTE_CONTROL) },
 
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PRESENTER_8K_BT) },
 	{ }
diff -X /opt/scripts/diff-exclude.txt -Npaur a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
--- a/drivers/hid/hid-ids.h	2010-04-22 18:52:46.455385039 +0100
+++ b/drivers/hid/hid-ids.h	2010-05-12 11:38:12.771567630 +0100
@@ -474,6 +474,9 @@
 
 #define USB_VENDOR_ID_ZEROPLUS		0x0c12
 
+#define USB_VENDOR_ID_ZYDACRON	0x13EC
+#define USB_DEVICE_ID_ZYDACRON_REMOTE_CONTROL	0x0006
+
 #define USB_VENDOR_ID_KYE		0x0458
 #define USB_DEVICE_ID_KYE_ERGO_525V	0x0087
 #define USB_DEVICE_ID_KYE_GPEN_560	0x5003
diff -X /opt/scripts/diff-exclude.txt -Npaur a/drivers/hid/hid-zydacron.c b/drivers/hid/hid-zydacron.c
--- a/drivers/hid/hid-zydacron.c	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/hid/hid-zydacron.c	2010-05-14 16:12:43.398731848 +0100
@@ -0,0 +1,237 @@
+/*
+*  HID driver for zydacron remote control
+*
+*  Copyright (c) 2010 Don Prince <dhprince.devel@yahoo.co.uk>
+*/
+
+/*
+* This program is free software; you can redistribute it and/or modify it
+* under the terms of the GNU General Public License as published by the Free
+* Software Foundation; either version 2 of the License, or (at your option)
+* any later version.
+*/
+
+#include <linux/device.h>
+#include <linux/hid.h>
+#include <linux/module.h>
+
+#include "hid-ids.h"
+
+struct zc_device {
+	struct input_dev	*input_ep81;
+	unsigned short		last_key[4];
+};
+
+
+/*
+* Zydacron remote control has an invalid HID report descriptor,
+* that needs fixing before we can parse it.
+*/
+static void zc_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+	unsigned int rsize)
+{
+	if (rsize >= 253 &&
+		rdesc[0x96] == 0xbc && rdesc[0x97] == 0xff &&
+		rdesc[0xca] == 0xbc && rdesc[0xcb] == 0xff &&
+		rdesc[0xe1] == 0xbc && rdesc[0xe2] == 0xff) {
+			dev_info(&hdev->dev,
+				"fixing up zydacron remote control report "
+				"descriptor\n");
+			rdesc[0x96] = rdesc[0xca] = rdesc[0xe1] = 0x0c;
+			rdesc[0x97] = rdesc[0xcb] = rdesc[0xe2] = 0x00;
+		}
+}
+
+#define zc_map_key_clear(c) \
+	hid_map_usage_clear(hi, usage, bit, max, EV_KEY, (c))
+
+static int zc_input_mapping(struct hid_device *hdev, struct hid_input *hi,
+	struct hid_field *field, struct hid_usage *usage,
+	unsigned long **bit, int *max)
+{
+	int i;
+	struct zc_device *zc = hid_get_drvdata(hdev);
+	zc->input_ep81 = hi->input;
+
+	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_CONSUMER)
+		return 0;
+
+	dbg_hid("zynacron input mapping event [0x%x]\n",
+		usage->hid & HID_USAGE);
+
+	switch (usage->hid & HID_USAGE) {
+	/* report 2 */
+	case 0x10:
+		zc_map_key_clear(KEY_MODE);
+		break;
+	case 0x30:
+		zc_map_key_clear(KEY_SCREEN);
+		break;
+	case 0x70:
+		zc_map_key_clear(KEY_INFO);
+		break;
+	/* report 3 */
+	case 0x04:
+		zc_map_key_clear(KEY_RADIO);
+		break;
+	/* report 4 */
+	case 0x0d:
+		zc_map_key_clear(KEY_PVR);
+		break;
+	case 0x25:
+		zc_map_key_clear(KEY_TV);
+		break;
+	case 0x47:
+		zc_map_key_clear(KEY_AUDIO);
+		break;
+	case 0x49:
+		zc_map_key_clear(KEY_AUX);
+		break;
+	case 0x4a:
+		zc_map_key_clear(KEY_VIDEO);
+		break;
+	case 0x48:
+		zc_map_key_clear(KEY_DVD);
+		break;
+	case 0x24:
+		zc_map_key_clear(KEY_MENU);
+		break;
+	case 0x32:
+		zc_map_key_clear(KEY_TEXT);
+		break;
+	default:
+		return 0;
+	}
+
+	for (i = 0; i < 4; i++)
+		zc->last_key[i] = 0;
+
+	return 1;
+}
+
+static int zc_raw_event(struct hid_device *hdev, struct hid_report *report,
+	 u8 *data, int size)
+{
+	struct zc_device *zc = hid_get_drvdata(hdev);
+	int ret = 0;
+	unsigned key;
+	unsigned short index;
+
+	if (report->id == data[0]) {
+
+		/* break keys */
+		for (index = 0; index < 4; index++) {
+			key = zc->last_key[index];
+			if (key) {
+				input_event(zc->input_ep81, EV_KEY, key, 0);
+				zc->last_key[index] = 0;
+			}
+		}
+
+		key = 0;
+		switch (report->id) {
+		case 0x02:
+		case 0x03:
+			switch (data[1]) {
+			case 0x10:
+				key = KEY_MODE;
+				index = 0;
+				break;
+			case 0x30:
+				key = KEY_SCREEN;
+				index = 1;
+				break;
+			case 0x70:
+				key = KEY_INFO;
+				index = 2;
+				break;
+			case 0x04:
+				key = KEY_RADIO;
+				index = 3;
+				break;
+			}
+
+			if (key) {
+				input_event(zc->input_ep81, EV_KEY, key, 1);
+				zc->last_key[index] = key;
+			}
+
+			ret = 1;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static int zc_probe(struct hid_device *hdev, const struct hid_device_id *id)
+{
+	int ret;
+	struct zc_device *zc;
+
+	zc = kzalloc(sizeof(*zc), GFP_KERNEL);
+	if (zc == NULL) {
+		dev_err(&hdev->dev, "zydacron: can't alloc descriptor\n");
+		return -ENOMEM;
+	}
+
+	hid_set_drvdata(hdev, zc);
+
+	ret = hid_parse(hdev);
+	if (ret) {
+		dev_err(&hdev->dev, "zydacron: parse failed\n");
+		goto err_free;
+	}
+
+	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
+	if (ret) {
+		dev_err(&hdev->dev, "zydacron: hw start failed\n");
+		goto err_free;
+	}
+
+	return 0;
+err_free:
+	kfree(zc);
+
+	return ret;
+}
+
+static void zc_remove(struct hid_device *hdev)
+{
+	struct zc_device *zc = hid_get_drvdata(hdev);
+
+	hid_hw_stop(hdev);
+
+	if (NULL != zc)
+		kfree(zc);
+}
+
+static const struct hid_device_id zc_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ZYDACRON, USB_DEVICE_ID_ZYDACRON_REMOTE_CONTROL) },
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, zc_devices);
+
+static struct hid_driver zc_driver = {
+	.name = "zydacron",
+	.id_table = zc_devices,
+	.report_fixup = zc_report_fixup,
+	.input_mapping = zc_input_mapping,
+	.raw_event = zc_raw_event,
+	.probe = zc_probe,
+	.remove = zc_remove,
+};
+
+static int __init zc_init(void)
+{
+	return hid_register_driver(&zc_driver);
+}
+
+static void __exit zc_exit(void)
+{
+	hid_unregister_driver(&zc_driver);
+}
+
+module_init(zc_init);
+module_exit(zc_exit);
+MODULE_LICENSE("GPL");
diff -X /opt/scripts/diff-exclude.txt -Npaur a/drivers/hid/Kconfig b/drivers/hid/Kconfig
--- a/drivers/hid/Kconfig	2010-03-09 13:53:05.930183131 +0000
+++ b/drivers/hid/Kconfig	2010-05-12 11:38:12.773567293 +0100
@@ -372,6 +372,13 @@ config ZEROPLUS_FF
 	  Say Y here if you have a Zeroplus based game controller and want
 	  to have force feedback support for it.
 
+config HID_ZYDACRON
+	tristate "Zydacron remote control support" if EMBEDDED
+	depends on USB_HID
+	default !EMBEDDED
+	---help---
+	Support for Zydacron remote control.
+
 endmenu
 
 endif # HID_SUPPORT
diff -X /opt/scripts/diff-exclude.txt -Npaur a/drivers/hid/Makefile b/drivers/hid/Makefile
--- a/drivers/hid/Makefile	2010-03-09 13:53:06.036326844 +0000
+++ b/drivers/hid/Makefile	2010-05-12 11:38:12.774443286 +0100
@@ -54,6 +54,7 @@ obj-$(CONFIG_HID_THRUSTMASTER)	+= hid-tm
 obj-$(CONFIG_HID_TOPSEED)	+= hid-topseed.o
 obj-$(CONFIG_HID_TWINHAN)	+= hid-twinhan.o
 obj-$(CONFIG_HID_ZEROPLUS)	+= hid-zpff.o
+obj-$(CONFIG_HID_ZYDACRON)	+= hid-zydacron.o
 obj-$(CONFIG_HID_WACOM)		+= hid-wacom.o
 
 obj-$(CONFIG_USB_HID)		+= usbhid/



		
___________________________________________________________ 
Inbox full of spam? Get leading spam protection and 1GB storage with All New Yahoo! Mail. http://uk.docs.yahoo.com/nowyoucan.html
