Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab2ETUpA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 16:45:00 -0400
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:60743 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752453Ab2ETUo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 16:44:58 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-04.arcor-online.net 827CEAA3C5
Subject: [PATCH 1/4] HID: roccat: Added support for Roccat Savu
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        linux-doc@vger.kernel.orglinux-doc, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 May 2012 22:44:54 +0200
Message-ID: <1337546694.19878.28.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds rupport for Roccat Savu gaming mouse.

In comparison to the other Roccat modules I tried to move even more
functionality to userland.

Userland tools can soon be found at http://sourceforge.net/projects/roccat

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 .../ABI/testing/sysfs-driver-hid-roccat-savu       |   68 ++++
 drivers/hid/Makefile                               |    3 +-
 drivers/hid/hid-core.c                             |    1 +
 drivers/hid/hid-ids.h                              |    1 +
 drivers/hid/hid-roccat-savu.c                      |  357 ++++++++++++++++++++
 drivers/hid/hid-roccat-savu.h                      |  103 ++++++
 6 files changed, 532 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-savu
 create mode 100644 drivers/hid/hid-roccat-savu.c
 create mode 100644 drivers/hid/hid-roccat-savu.h

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-savu b/Documentation/ABI/testing/sysfs-driver-hid-roccat-savu
new file mode 100644
index 0000000..e233490
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-savu
@@ -0,0 +1,68 @@
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/savu/roccatsavu<minor>/buttons
+Date:		Mai 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile is split into general settings and
+		button settings. buttons holds informations about button layout.
+		When written, this file lets one write the respective profile
+		buttons to the mouse. The data has to be 47 bytes long.
+		The mouse will reject invalid data.
+		Which profile to write is determined by the profile number
+		contained in the data.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/savu/roccatsavu<minor>/control
+Date:		Mai 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one select which data from which
+		profile will be	read next. The data has to be 3 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/savu/roccatsavu<minor>/general
+Date:		Mai 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile is split into general settings and
+		button settings. profile holds informations like resolution, sensitivity
+		and light effects.
+		When written, this file lets one write the respective profile
+		settings back to the mouse. The data has to be 43 bytes long.
+		The mouse will reject invalid data.
+		Which profile to write is determined by the profile number
+		contained in the data.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/savu/roccatsavu<minor>/info
+Date:		Mai 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns general data like firmware version.
+		The data is 8 bytes long.
+		This file is readonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/savu/roccatsavu<minor>/macro
+Date:		Mai 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one store macros with max 500
+		keystrokes for a specific button for a specific profile.
+		Button and profile numbers are included in written data.
+		The data has to be 2083 bytes long.
+		Before reading this file, control has to be written to select
+		which profile and key to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/savu/roccatsavu<minor>/profile
+Date:		Mai 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. profile holds number of actual profile.
+		This value is persistent, so its value determines the profile
+		that's active when the mouse is powered on next time.
+		When written, the mouse activates the set profile immediately.
+		The data has to be 3 bytes long.
+		The mouse will reject invalid data.
+Users:		http://roccat.sourceforge.net
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 22f1d16..a5a190c 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -66,7 +66,8 @@ obj-$(CONFIG_HID_PICOLCD)	+= hid-picolcd.o
 obj-$(CONFIG_HID_PRIMAX)	+= hid-primax.o
 obj-$(CONFIG_HID_ROCCAT)	+= hid-roccat.o hid-roccat-common.o \
 	hid-roccat-arvo.o hid-roccat-isku.o hid-roccat-kone.o \
-	hid-roccat-koneplus.o hid-roccat-kovaplus.o hid-roccat-pyra.o
+	hid-roccat-koneplus.o hid-roccat-kovaplus.o hid-roccat-pyra.o \
+	hid-roccat-savu.o
 obj-$(CONFIG_HID_SAITEK)	+= hid-saitek.o
 obj-$(CONFIG_HID_SAMSUNG)	+= hid-samsung.o
 obj-$(CONFIG_HID_SMARTJOYPLUS)	+= hid-sjoy.o
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 4da66b4..05be390 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1530,6 +1530,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KOVAPLUS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_PYRA_WIRED) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_PYRA_WIRELESS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_SAVU) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_PS1000) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_WIRELESS_KBD_MOUSE) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index e39aecb..348e224 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -635,6 +635,7 @@
 #define USB_DEVICE_ID_ROCCAT_KOVAPLUS	0x2d50
 #define USB_DEVICE_ID_ROCCAT_PYRA_WIRED	0x2c24
 #define USB_DEVICE_ID_ROCCAT_PYRA_WIRELESS	0x2cf6
+#define USB_DEVICE_ID_ROCCAT_SAVU	0x2d5a
 
 #define USB_VENDOR_ID_SAITEK		0x06a3
 #define USB_DEVICE_ID_SAITEK_RUMBLEPAD	0xff17
diff --git a/drivers/hid/hid-roccat-savu.c b/drivers/hid/hid-roccat-savu.c
new file mode 100644
index 0000000..d6c82d5
--- /dev/null
+++ b/drivers/hid/hid-roccat-savu.c
@@ -0,0 +1,357 @@
+/*
+ * Roccat Savu driver for Linux
+ *
+ * Copyright (c) 2012 Stefan Achatz <erazor_de@users.sourceforge.net>
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+/* Roccat Savu is a gamer mouse with macro keys that can be configured in
+ * 5 profiles.
+ */
+
+#include <linux/device.h>
+#include <linux/input.h>
+#include <linux/hid.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/hid-roccat.h>
+#include "hid-ids.h"
+#include "hid-roccat-common.h"
+#include "hid-roccat-savu.h"
+
+static struct class *savu_class;
+
+static int savu_receive_control_status(struct usb_device *usb_dev)
+{
+	int retval;
+	struct savu_control control;
+
+	do {
+		msleep(50);
+		retval = roccat_common_receive(usb_dev, SAVU_COMMAND_CONTROL,
+				&control, sizeof(struct savu_control));
+
+		if (retval)
+			return retval;
+
+		switch (control.value) {
+		case SAVU_CONTROL_REQUEST_WRITE_CHECK_OK:
+			return 0;
+		case SAVU_CONTROL_REQUEST_WRITE_CHECK_WAIT:
+			continue;
+		case SAVU_CONTROL_REQUEST_WRITE_CHECK_INVALID:
+		/* seems to be critical - replug necessary */
+		case SAVU_CONTROL_REQUEST_WRITE_CHECK_OVERLOAD:
+			return -EINVAL;
+		default:
+			hid_err(usb_dev, "savu_receive_control_status: "
+					"unknown response value 0x%x\n",
+					control.value);
+			return -EINVAL;
+		}
+
+	} while (1);
+}
+
+static int savu_send(struct usb_device *usb_dev, uint command,
+		void const *buf, uint size)
+{
+	int retval;
+
+	retval = roccat_common_send(usb_dev, command, buf, size);
+	if (retval)
+		return retval;
+
+	return savu_receive_control_status(usb_dev);
+}
+
+static ssize_t savu_sysfs_read(struct file *fp, struct kobject *kobj,
+		char *buf, loff_t off, size_t count,
+		size_t real_size, uint command)
+{
+	struct device *dev =
+			container_of(kobj, struct device, kobj)->parent->parent;
+	struct savu_device *savu = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int retval;
+
+	if (off >= real_size)
+		return 0;
+
+	if (off != 0 || count != real_size)
+		return -EINVAL;
+
+	mutex_lock(&savu->savu_lock);
+	retval = roccat_common_receive(usb_dev, command, buf, real_size);
+	mutex_unlock(&savu->savu_lock);
+
+	return retval ? retval : real_size;
+}
+
+static ssize_t savu_sysfs_write(struct file *fp, struct kobject *kobj,
+		void const *buf, loff_t off, size_t count,
+		size_t real_size, uint command)
+{
+	struct device *dev =
+			container_of(kobj, struct device, kobj)->parent->parent;
+	struct savu_device *savu = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int retval;
+
+	if (off != 0 || count != real_size)
+		return -EINVAL;
+
+	mutex_lock(&savu->savu_lock);
+	retval = savu_send(usb_dev, command, (void *)buf, real_size);
+	mutex_unlock(&savu->savu_lock);
+
+	return retval ? retval : real_size;
+}
+
+#define SAVU_SYSFS_W(thingy, THINGY) \
+static ssize_t savu_sysfs_write_ ## thingy(struct file *fp, \
+		struct kobject *kobj, struct bin_attribute *attr, char *buf, \
+		loff_t off, size_t count) \
+{ \
+	return savu_sysfs_write(fp, kobj, buf, off, count, \
+			SAVU_SIZE_ ## THINGY, SAVU_COMMAND_ ## THINGY); \
+}
+
+#define SAVU_SYSFS_R(thingy, THINGY) \
+static ssize_t savu_sysfs_read_ ## thingy(struct file *fp, \
+		struct kobject *kobj, struct bin_attribute *attr, char *buf, \
+		loff_t off, size_t count) \
+{ \
+	return savu_sysfs_read(fp, kobj, buf, off, count, \
+			SAVU_SIZE_ ## THINGY, SAVU_COMMAND_ ## THINGY); \
+}
+
+#define SAVU_SYSFS_RW(thingy, THINGY) \
+SAVU_SYSFS_W(thingy, THINGY) \
+SAVU_SYSFS_R(thingy, THINGY)
+
+#define SAVU_BIN_ATTRIBUTE_RW(thingy, THINGY) \
+{ \
+	.attr = { .name = #thingy, .mode = 0660 }, \
+	.size = SAVU_SIZE_ ## THINGY, \
+	.read = savu_sysfs_read_ ## thingy, \
+	.write = savu_sysfs_write_ ## thingy \
+}
+
+#define SAVU_BIN_ATTRIBUTE_R(thingy, THINGY) \
+{ \
+	.attr = { .name = #thingy, .mode = 0440 }, \
+	.size = SAVU_SIZE_ ## THINGY, \
+	.read = savu_sysfs_read_ ## thingy, \
+}
+
+#define SAVU_BIN_ATTRIBUTE_W(thingy, THINGY) \
+{ \
+	.attr = { .name = #thingy, .mode = 0220 }, \
+	.size = SAVU_SIZE_ ## THINGY, \
+	.write = savu_sysfs_write_ ## thingy \
+}
+
+SAVU_SYSFS_W(control, CONTROL)
+SAVU_SYSFS_RW(profile, PROFILE)
+SAVU_SYSFS_RW(general, GENERAL)
+SAVU_SYSFS_RW(buttons, BUTTONS)
+SAVU_SYSFS_RW(macro, MACRO)
+SAVU_SYSFS_R(info, INFO)
+
+static struct bin_attribute savu_bin_attributes[] = {
+	SAVU_BIN_ATTRIBUTE_W(control, CONTROL),
+	SAVU_BIN_ATTRIBUTE_RW(profile, PROFILE),
+	SAVU_BIN_ATTRIBUTE_RW(general, GENERAL),
+	SAVU_BIN_ATTRIBUTE_RW(buttons, BUTTONS),
+	SAVU_BIN_ATTRIBUTE_RW(macro, MACRO),
+	SAVU_BIN_ATTRIBUTE_R(info, INFO),
+	__ATTR_NULL
+};
+
+static int savu_init_savu_device_struct(struct usb_device *usb_dev,
+		struct savu_device *savu)
+{
+	mutex_init(&savu->savu_lock);
+
+	return 0;
+}
+
+static int savu_init_specials(struct hid_device *hdev)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct usb_device *usb_dev = interface_to_usbdev(intf);
+	struct savu_device *savu;
+	int retval;
+
+	if (intf->cur_altsetting->desc.bInterfaceProtocol
+			!= USB_INTERFACE_PROTOCOL_MOUSE) {
+		hid_set_drvdata(hdev, NULL);
+		return 0;
+	}
+
+	savu = kzalloc(sizeof(*savu), GFP_KERNEL);
+	if (!savu) {
+		hid_err(hdev, "can't alloc device descriptor\n");
+		return -ENOMEM;
+	}
+	hid_set_drvdata(hdev, savu);
+
+	retval = savu_init_savu_device_struct(usb_dev, savu);
+	if (retval) {
+		hid_err(hdev, "couldn't init struct savu_device\n");
+		goto exit_free;
+	}
+
+	retval = roccat_connect(savu_class, hdev,
+			sizeof(struct savu_roccat_report));
+	if (retval < 0) {
+		hid_err(hdev, "couldn't init char dev\n");
+	} else {
+		savu->chrdev_minor = retval;
+		savu->roccat_claimed = 1;
+	}
+
+	return 0;
+exit_free:
+	kfree(savu);
+	return retval;
+}
+
+static void savu_remove_specials(struct hid_device *hdev)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct savu_device *savu;
+
+	if (intf->cur_altsetting->desc.bInterfaceProtocol
+			!= USB_INTERFACE_PROTOCOL_MOUSE)
+		return;
+
+	savu = hid_get_drvdata(hdev);
+	if (savu->roccat_claimed)
+		roccat_disconnect(savu->chrdev_minor);
+	kfree(savu);
+}
+
+static int savu_probe(struct hid_device *hdev,
+		const struct hid_device_id *id)
+{
+	int retval;
+
+	retval = hid_parse(hdev);
+	if (retval) {
+		hid_err(hdev, "parse failed\n");
+		goto exit;
+	}
+
+	retval = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
+	if (retval) {
+		hid_err(hdev, "hw start failed\n");
+		goto exit;
+	}
+
+	retval = savu_init_specials(hdev);
+	if (retval) {
+		hid_err(hdev, "couldn't install mouse\n");
+		goto exit_stop;
+	}
+
+	return 0;
+
+exit_stop:
+	hid_hw_stop(hdev);
+exit:
+	return retval;
+}
+
+static void savu_remove(struct hid_device *hdev)
+{
+	savu_remove_specials(hdev);
+	hid_hw_stop(hdev);
+}
+
+static void savu_report_to_chrdev(struct savu_device const *savu,
+		u8 const *data)
+{
+	struct savu_roccat_report roccat_report;
+	struct savu_mouse_report_special const *special_report;
+
+	if (data[0] != SAVU_MOUSE_REPORT_NUMBER_SPECIAL)
+		return;
+
+	special_report = (struct savu_mouse_report_special const *)data;
+
+	roccat_report.type = special_report->type;
+	roccat_report.data[0] = special_report->data[0];
+	roccat_report.data[1] = special_report->data[1];
+	roccat_report_event(savu->chrdev_minor,
+			(uint8_t const *)&roccat_report);
+}
+
+static int savu_raw_event(struct hid_device *hdev,
+		struct hid_report *report, u8 *data, int size)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct savu_device *savu = hid_get_drvdata(hdev);
+
+	if (intf->cur_altsetting->desc.bInterfaceProtocol
+			!= USB_INTERFACE_PROTOCOL_MOUSE)
+		return 0;
+
+	if (savu == NULL)
+		return 0;
+
+	if (savu->roccat_claimed)
+		savu_report_to_chrdev(savu, data);
+
+	return 0;
+}
+
+static const struct hid_device_id savu_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_SAVU) },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(hid, savu_devices);
+
+static struct hid_driver savu_driver = {
+		.name = "savu",
+		.id_table = savu_devices,
+		.probe = savu_probe,
+		.remove = savu_remove,
+		.raw_event = savu_raw_event
+};
+
+static int __init savu_init(void)
+{
+	int retval;
+
+	savu_class = class_create(THIS_MODULE, "savu");
+	if (IS_ERR(savu_class))
+		return PTR_ERR(savu_class);
+	savu_class->dev_bin_attrs = savu_bin_attributes;
+
+	retval = hid_register_driver(&savu_driver);
+	if (retval)
+		class_destroy(savu_class);
+	return retval;
+}
+
+static void __exit savu_exit(void)
+{
+	hid_unregister_driver(&savu_driver);
+	class_destroy(savu_class);
+}
+
+module_init(savu_init);
+module_exit(savu_exit);
+
+MODULE_AUTHOR("Stefan Achatz");
+MODULE_DESCRIPTION("USB Roccat Savu driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/hid/hid-roccat-savu.h b/drivers/hid/hid-roccat-savu.h
new file mode 100644
index 0000000..97b43d5
--- /dev/null
+++ b/drivers/hid/hid-roccat-savu.h
@@ -0,0 +1,103 @@
+#ifndef __HID_ROCCAT_SAVU_H
+#define __HID_ROCCAT_SAVU_H
+
+/*
+ * Copyright (c) 2012 Stefan Achatz <erazor_de@users.sourceforge.net>
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/types.h>
+
+enum {
+	SAVU_SIZE_CONTROL = 0x03,
+	SAVU_SIZE_PROFILE = 0x03,
+	SAVU_SIZE_GENERAL = 0x10,
+	SAVU_SIZE_BUTTONS = 0x2f,
+	SAVU_SIZE_MACRO = 0x0823,
+	SAVU_SIZE_INFO = 0x08,
+};
+
+struct savu_control {
+	uint8_t command; /* SAVU_COMMAND_CONTROL */
+	/*
+	 * value is profile number in range 0-4 for requesting settings and buttons
+	 * 1 if status ok for requesting status
+	 */
+	uint8_t value;
+	uint8_t request;
+} __packed;
+
+enum savu_control_requests {
+	SAVU_CONTROL_REQUEST_WRITE_CHECK = 0x00,
+	SAVU_CONTROL_REQUEST_GENERAL = 0x80,
+	SAVU_CONTROL_REQUEST_BUTTONS = 0x90,
+};
+
+enum savu_control_values {
+	SAVU_CONTROL_REQUEST_WRITE_CHECK_OVERLOAD = 0,
+	SAVU_CONTROL_REQUEST_WRITE_CHECK_OK = 1,
+	SAVU_CONTROL_REQUEST_WRITE_CHECK_INVALID = 2,
+	SAVU_CONTROL_REQUEST_WRITE_CHECK_WAIT = 3,
+};
+
+enum savu_commands {
+	SAVU_COMMAND_CONTROL = 0x4,
+	SAVU_COMMAND_PROFILE = 0x5,
+	SAVU_COMMAND_GENERAL = 0x6,
+	SAVU_COMMAND_BUTTONS = 0x7,
+	SAVU_COMMAND_MACRO = 0x8,
+	SAVU_COMMAND_INFO = 0x9,
+};
+
+struct savu_mouse_report_special {
+	uint8_t report_number; /* always 3 */
+	uint8_t zero;
+	uint8_t type;
+	uint8_t data[2];
+} __packed;
+
+enum {
+	SAVU_MOUSE_REPORT_NUMBER_SPECIAL = 3,
+};
+
+enum savu_mouse_report_button_types {
+	/* data1 = new profile range 1-5 */
+	SAVU_MOUSE_REPORT_BUTTON_TYPE_PROFILE = 0x20,
+
+	/* data1 = button number range 1-24; data2 = action */
+	SAVU_MOUSE_REPORT_BUTTON_TYPE_QUICKLAUNCH = 0x60,
+
+	/* data1 = button number range 1-24; data2 = action */
+	SAVU_MOUSE_REPORT_BUTTON_TYPE_TIMER = 0x80,
+
+	/* data1 = setting number range 1-5 */
+	SAVU_MOUSE_REPORT_BUTTON_TYPE_CPI = 0xb0,
+
+	/* data1 and data2 = range 0x1-0xb */
+	SAVU_MOUSE_REPORT_BUTTON_TYPE_SENSITIVITY = 0xc0,
+
+	/* data1 = 22 = next track...
+	 * data2 = action
+	 */
+	SAVU_MOUSE_REPORT_BUTTON_TYPE_MULTIMEDIA = 0xf0,
+};
+
+struct savu_roccat_report {
+	uint8_t type;
+	uint8_t data[2];
+} __packed;
+
+struct savu_device {
+	int roccat_claimed;
+	int chrdev_minor;
+
+	struct mutex savu_lock;
+};
+
+#endif
-- 
1.7.3.4



