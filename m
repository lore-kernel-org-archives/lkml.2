Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab1HaRsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 13:48:53 -0400
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:45609 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756939Ab1HaRsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 13:48:51 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-13.arcor-online.net D1FD22129BC
Subject: [PATCH] HID: roccat: Add support for Isku keyboard
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Randy Dunlap <rdunlap@xenotime.net>, Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 19:48:48 +0200
Message-ID: <1314812928.2341.1.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for Roccat Isku keyboard.
Userland tools can soon be found at http://sourceforge.net/projects/roccat

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 .../ABI/testing/sysfs-driver-hid-roccat-isku       |  135 ++++++
 drivers/hid/Kconfig                                |    7 +
 drivers/hid/Makefile                               |    1 +
 drivers/hid/hid-core.c                             |    1 +
 drivers/hid/hid-ids.h                              |    1 +
 drivers/hid/hid-roccat-isku.c                      |  487 ++++++++++++++++++++
 drivers/hid/hid-roccat-isku.h                      |  147 ++++++
 7 files changed, 779 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-isku
 create mode 100644 drivers/hid/hid-roccat-isku.c
 create mode 100644 drivers/hid/hid-roccat-isku.h

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-isku b/Documentation/ABI/testing/sysfs-driver-hid-roccat-isku
new file mode 100644
index 0000000..189dc43
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-isku
@@ -0,0 +1,135 @@
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/actual_profile
+Date:		June 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The integer value of this attribute ranges from 0-4.
+		When read, this attribute returns the number of the actual
+		profile. This value is persistent, so its equivalent to the
+		profile that's active when the device is powered on next time.
+		When written, this file sets the number of the startup profile
+		and the device activates this profile immediately.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/info
+Date:		June 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns general data like firmware version.
+		The data is 6 bytes long.
+		This file is readonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/key_mask
+Date:		June 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one deactivate certain keys like
+		windows and application keys, to prevent accidental presses.
+		Profile number for which this settings occur is included in
+		written data. The data has to be 6 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/keys_capslock
+Date:		June 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the function of the
+		capslock key for a specific profile. Profile number is included
+		in written data. The data has to be 6 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/keys_easyzone
+Date:		June 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the function of the
+		easyzone keys for a specific profile. Profile number is included
+		in written data. The data has to be 65 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/keys_function
+Date:		June 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the function of the
+		function keys for a specific profile. Profile number is included
+		in written data. The data has to be 41 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/keys_macro
+Date:		June 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the function of the macro
+		keys for a specific profile. Profile number is included in
+		written data. The data has to be 35 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/keys_media
+Date:		June 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the function of the media
+		keys for a specific profile. Profile number is included in
+		written data. The data has to be 29 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/keys_thumbster
+Date:		June 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the function of the
+		thumbster keys for a specific profile. Profile number is included
+		in written data. The data has to be 23 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/last_set
+Date:		June 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the time in secs since
+		epoch in which the last configuration took place.
+		The data has to be 20 bytes long.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/light
+Date:		June 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the backlight intensity for
+		a specific profile. Profile number is included in written data.
+		The data has to be 10 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/macro
+Date:		June 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one store macros with max 500
+		keystrokes for a specific button for a specific profile.
+		Button and profile numbers are included in written data.
+		The data has to be 2083 bytes long.
+		Before reading this file, control has to be written to select
+		which profile and key to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/control
+Date:		June 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one select which data from which
+		profile will be	read next. The data has to be 3 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/talk
+Date:		June 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one trigger easyshift functionality
+		from the host.
+		The data has to be 16 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 1130a89..e46baab 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -467,6 +467,13 @@ config HID_ROCCAT_ARVO
 	---help---
 	Support for Roccat Arvo keyboard.
 
+config HID_ROCCAT_ISKU
+	tristate "Roccat Isku keyboard support"
+	depends on USB_HID
+	depends on HID_ROCCAT
+	---help---
+	Support for Roccat Isku keyboard.
+
 config HID_ROCCAT_KONE
 	tristate "Roccat Kone Mouse support"
 	depends on USB_HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 0a0a38e..f8840aa 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -57,6 +57,7 @@ obj-$(CONFIG_HID_PICOLCD)	+= hid-picolcd.o
 obj-$(CONFIG_HID_ROCCAT)	+= hid-roccat.o
 obj-$(CONFIG_HID_ROCCAT_COMMON)	+= hid-roccat-common.o
 obj-$(CONFIG_HID_ROCCAT_ARVO)	+= hid-roccat-arvo.o
+obj-$(CONFIG_HID_ROCCAT_ISKU)	+= hid-roccat-isku.o
 obj-$(CONFIG_HID_ROCCAT_KONE)	+= hid-roccat-kone.o
 obj-$(CONFIG_HID_ROCCAT_KONEPLUS)	+= hid-roccat-koneplus.o
 obj-$(CONFIG_HID_ROCCAT_KOVAPLUS)	+= hid-roccat-kovaplus.o
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 242353d..fa058eb 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1465,6 +1465,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_ARVO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_ISKU) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONEPLUS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KOVAPLUS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_PYRA_WIRED) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 7d27d2b..7d88c06 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -566,6 +566,7 @@
 
 #define USB_VENDOR_ID_ROCCAT		0x1e7d
 #define USB_DEVICE_ID_ROCCAT_ARVO	0x30d4
+#define USB_DEVICE_ID_ROCCAT_ISKU	0x319c
 #define USB_DEVICE_ID_ROCCAT_KONE	0x2ced
 #define USB_DEVICE_ID_ROCCAT_KONEPLUS	0x2d51
 #define USB_DEVICE_ID_ROCCAT_KOVAPLUS	0x2d50
diff --git a/drivers/hid/hid-roccat-isku.c b/drivers/hid/hid-roccat-isku.c
new file mode 100644
index 0000000..0e4a0ab
--- /dev/null
+++ b/drivers/hid/hid-roccat-isku.c
@@ -0,0 +1,487 @@
+/*
+ * Roccat Isku driver for Linux
+ *
+ * Copyright (c) 2011 Stefan Achatz <erazor_de@users.sourceforge.net>
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+/*
+ * Roccat Isku is a gamer keyboard with macro keys that can be configured in
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
+#include "hid-roccat-isku.h"
+
+static struct class *isku_class;
+
+static void isku_profile_activated(struct isku_device *isku, uint new_profile)
+{
+	isku->actual_profile = new_profile;
+}
+
+static int isku_receive(struct usb_device *usb_dev, uint command,
+		void *buf, uint size)
+{
+	return roccat_common_receive(usb_dev, command, buf, size);
+}
+
+static int isku_receive_control_status(struct usb_device *usb_dev)
+{
+	int retval;
+	struct isku_control control;
+
+	do {
+		msleep(50);
+		retval = isku_receive(usb_dev, ISKU_COMMAND_CONTROL,
+				&control, sizeof(struct isku_control));
+
+		if (retval)
+			return retval;
+
+		switch (control.value) {
+		case ISKU_CONTROL_VALUE_STATUS_OK:
+			return 0;
+		case ISKU_CONTROL_VALUE_STATUS_WAIT:
+			continue;
+		case ISKU_CONTROL_VALUE_STATUS_INVALID:
+		/* seems to be critical - replug necessary */
+		case ISKU_CONTROL_VALUE_STATUS_OVERLOAD:
+			return -EINVAL;
+		default:
+			hid_err(usb_dev, "isku_receive_control_status: "
+					"unknown response value 0x%x\n",
+					control.value);
+			return -EINVAL;
+		}
+
+	} while (1);
+}
+
+static int isku_send(struct usb_device *usb_dev, uint command,
+		void const *buf, uint size)
+{
+	int retval;
+
+	retval = roccat_common_send(usb_dev, command, buf, size);
+	if (retval)
+		return retval;
+
+	return isku_receive_control_status(usb_dev);
+}
+
+static int isku_get_actual_profile(struct usb_device *usb_dev)
+{
+	struct isku_actual_profile buf;
+	int retval;
+
+	retval = isku_receive(usb_dev, ISKU_COMMAND_ACTUAL_PROFILE,
+			&buf, sizeof(struct isku_actual_profile));
+	return retval ? retval : buf.actual_profile;
+}
+
+static int isku_set_actual_profile(struct usb_device *usb_dev, int new_profile)
+{
+	struct isku_actual_profile buf;
+
+	buf.command = ISKU_COMMAND_ACTUAL_PROFILE;
+	buf.size = sizeof(struct isku_actual_profile);
+	buf.actual_profile = new_profile;
+	return isku_send(usb_dev, ISKU_COMMAND_ACTUAL_PROFILE, &buf,
+			sizeof(struct isku_actual_profile));
+}
+
+static ssize_t isku_sysfs_show_actual_profile(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct isku_device *isku =
+			hid_get_drvdata(dev_get_drvdata(dev->parent->parent));
+	return snprintf(buf, PAGE_SIZE, "%d\n", isku->actual_profile);
+}
+
+static ssize_t isku_sysfs_set_actual_profile(struct device *dev,
+		struct device_attribute *attr, char const *buf, size_t size)
+{
+	struct isku_device *isku;
+	struct usb_device *usb_dev;
+	unsigned long profile;
+	int retval;
+	struct isku_roccat_report roccat_report;
+
+	dev = dev->parent->parent;
+	isku = hid_get_drvdata(dev_get_drvdata(dev));
+	usb_dev = interface_to_usbdev(to_usb_interface(dev));
+
+	retval = strict_strtoul(buf, 10, &profile);
+	if (retval)
+		return retval;
+
+	if (profile > 4)
+		return -EINVAL;
+
+	mutex_lock(&isku->isku_lock);
+
+	retval = isku_set_actual_profile(usb_dev, profile);
+	if (retval) {
+		mutex_unlock(&isku->isku_lock);
+		return retval;
+	}
+
+	isku_profile_activated(isku, profile);
+
+	roccat_report.event = ISKU_REPORT_BUTTON_EVENT_PROFILE;
+	roccat_report.data1 = profile + 1;
+	roccat_report.data2 = 0;
+	roccat_report.profile = profile + 1;
+	roccat_report_event(isku->chrdev_minor, (uint8_t const *)&roccat_report);
+
+	mutex_unlock(&isku->isku_lock);
+
+	return size;
+}
+
+static struct device_attribute isku_attributes[] = {
+	__ATTR(actual_profile, 0660,
+			isku_sysfs_show_actual_profile,
+			isku_sysfs_set_actual_profile),
+	__ATTR_NULL
+};
+
+static ssize_t isku_sysfs_read(struct file *fp, struct kobject *kobj,
+		char *buf, loff_t off, size_t count,
+		size_t real_size, uint command)
+{
+	struct device *dev =
+			container_of(kobj, struct device, kobj)->parent->parent;
+	struct isku_device *isku = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int retval;
+
+	if (off >= real_size)
+		return 0;
+
+	if (off != 0 || count != real_size)
+		return -EINVAL;
+
+	mutex_lock(&isku->isku_lock);
+	retval = isku_receive(usb_dev, command, buf, real_size);
+	mutex_unlock(&isku->isku_lock);
+
+	return retval ? retval : real_size;
+}
+
+static ssize_t isku_sysfs_write(struct file *fp, struct kobject *kobj,
+		void const *buf, loff_t off, size_t count,
+		size_t real_size, uint command)
+{
+	struct device *dev =
+			container_of(kobj, struct device, kobj)->parent->parent;
+	struct isku_device *isku = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int retval;
+
+	if (off != 0 || count != real_size)
+		return -EINVAL;
+
+	mutex_lock(&isku->isku_lock);
+	retval = isku_send(usb_dev, command, (void *)buf, real_size);
+	mutex_unlock(&isku->isku_lock);
+
+	return retval ? retval : real_size;
+}
+
+#define ISKU_SYSFS_W(thingy, THINGY) \
+static ssize_t isku_sysfs_write_ ## thingy(struct file *fp, struct kobject *kobj, \
+		struct bin_attribute *attr, char *buf, \
+		loff_t off, size_t count) \
+{ \
+	return isku_sysfs_write(fp, kobj, buf, off, count, \
+			sizeof(struct isku_ ## thingy), ISKU_COMMAND_ ## THINGY); \
+}
+
+#define ISKU_SYSFS_R(thingy, THINGY) \
+static ssize_t isku_sysfs_read_ ## thingy(struct file *fp, struct kobject *kobj, \
+		struct bin_attribute *attr, char *buf, \
+		loff_t off, size_t count) \
+{ \
+	return isku_sysfs_read(fp, kobj, buf, off, count, \
+			sizeof(struct isku_ ## thingy), ISKU_COMMAND_ ## THINGY); \
+}
+
+#define ISKU_SYSFS_RW(thingy, THINGY) \
+ISKU_SYSFS_R(thingy, THINGY) \
+ISKU_SYSFS_W(thingy, THINGY)
+
+#define ISKU_BIN_ATTR_RW(thingy) \
+{ \
+	.attr = { .name = #thingy, .mode = 0660 }, \
+	.size = sizeof(struct isku_ ## thingy), \
+	.read = isku_sysfs_read_ ## thingy, \
+	.write = isku_sysfs_write_ ## thingy \
+}
+
+#define ISKU_BIN_ATTR_R(thingy) \
+{ \
+	.attr = { .name = #thingy, .mode = 0440 }, \
+	.size = sizeof(struct isku_ ## thingy), \
+	.read = isku_sysfs_read_ ## thingy, \
+}
+
+#define ISKU_BIN_ATTR_W(thingy) \
+{ \
+	.attr = { .name = #thingy, .mode = 0220 }, \
+	.size = sizeof(struct isku_ ## thingy), \
+	.write = isku_sysfs_write_ ## thingy \
+}
+
+ISKU_SYSFS_RW(macro, MACRO)
+ISKU_SYSFS_RW(keys_function, KEYS_FUNCTION)
+ISKU_SYSFS_RW(keys_easyzone, KEYS_EASYZONE)
+ISKU_SYSFS_RW(keys_media, KEYS_MEDIA)
+ISKU_SYSFS_RW(keys_thumbster, KEYS_THUMBSTER)
+ISKU_SYSFS_RW(keys_macro, KEYS_MACRO)
+ISKU_SYSFS_RW(keys_capslock, KEYS_CAPSLOCK)
+ISKU_SYSFS_RW(light, LIGHT)
+ISKU_SYSFS_RW(key_mask, KEY_MASK)
+ISKU_SYSFS_RW(last_set, LAST_SET)
+ISKU_SYSFS_W(talk, TALK)
+ISKU_SYSFS_R(info, INFO)
+ISKU_SYSFS_W(control, CONTROL)
+
+static struct bin_attribute isku_bin_attributes[] = {
+	ISKU_BIN_ATTR_RW(macro),
+	ISKU_BIN_ATTR_RW(keys_function),
+	ISKU_BIN_ATTR_RW(keys_easyzone),
+	ISKU_BIN_ATTR_RW(keys_media),
+	ISKU_BIN_ATTR_RW(keys_thumbster),
+	ISKU_BIN_ATTR_RW(keys_macro),
+	ISKU_BIN_ATTR_RW(keys_capslock),
+	ISKU_BIN_ATTR_RW(light),
+	ISKU_BIN_ATTR_RW(key_mask),
+	ISKU_BIN_ATTR_RW(last_set),
+	ISKU_BIN_ATTR_W(talk),
+	ISKU_BIN_ATTR_R(info),
+	ISKU_BIN_ATTR_W(control),
+	__ATTR_NULL
+};
+
+static int isku_init_isku_device_struct(struct usb_device *usb_dev,
+		struct isku_device *isku)
+{
+	int retval;
+
+	mutex_init(&isku->isku_lock);
+
+	retval = isku_get_actual_profile(usb_dev);
+	if (retval < 0)
+		return retval;
+	isku_profile_activated(isku, retval);
+
+	return 0;
+}
+
+static int isku_init_specials(struct hid_device *hdev)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct usb_device *usb_dev = interface_to_usbdev(intf);
+	struct isku_device *isku;
+	int retval;
+
+	if (intf->cur_altsetting->desc.bInterfaceProtocol
+			!= ISKU_USB_INTERFACE_PROTOCOL) {
+		hid_set_drvdata(hdev, NULL);
+		return 0;
+	}
+
+	isku = kzalloc(sizeof(*isku), GFP_KERNEL);
+	if (!isku) {
+		hid_err(hdev, "can't alloc device descriptor\n");
+		return -ENOMEM;
+	}
+	hid_set_drvdata(hdev, isku);
+
+	retval = isku_init_isku_device_struct(usb_dev, isku);
+	if (retval) {
+		hid_err(hdev, "couldn't init struct isku_device\n");
+		goto exit_free;
+	}
+
+	retval = roccat_connect(isku_class, hdev,
+			sizeof(struct isku_roccat_report));
+	if (retval < 0) {
+		hid_err(hdev, "couldn't init char dev\n");
+	} else {
+		isku->chrdev_minor = retval;
+		isku->roccat_claimed = 1;
+	}
+
+	return 0;
+exit_free:
+	kfree(isku);
+	return retval;
+}
+
+static void isku_remove_specials(struct hid_device *hdev)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct isku_device *isku;
+
+	if (intf->cur_altsetting->desc.bInterfaceProtocol
+			!= ISKU_USB_INTERFACE_PROTOCOL)
+		return;
+
+	isku = hid_get_drvdata(hdev);
+	if (isku->roccat_claimed)
+		roccat_disconnect(isku->chrdev_minor);
+	kfree(isku);
+}
+
+static int isku_probe(struct hid_device *hdev,
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
+	retval = isku_init_specials(hdev);
+	if (retval) {
+		hid_err(hdev, "couldn't install keyboard\n");
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
+static void isku_remove(struct hid_device *hdev)
+{
+	isku_remove_specials(hdev);
+	hid_hw_stop(hdev);
+}
+
+static void isku_keep_values_up_to_date(struct isku_device *isku,
+		u8 const *data)
+{
+	struct isku_report_button const *button_report;
+
+	switch (data[0]) {
+	case ISKU_REPORT_NUMBER_BUTTON:
+		button_report = (struct isku_report_button const *)data;
+		switch (button_report->event) {
+		case ISKU_REPORT_BUTTON_EVENT_PROFILE:
+			isku_profile_activated(isku, button_report->data1 - 1);
+			break;
+		}
+		break;
+	}
+}
+
+static void isku_report_to_chrdev(struct isku_device const *isku,
+		u8 const *data)
+{
+	struct isku_roccat_report roccat_report;
+	struct isku_report_button const *button_report;
+
+	if (data[0] != ISKU_REPORT_NUMBER_BUTTON)
+		return;
+
+	button_report = (struct isku_report_button const *)data;
+
+	roccat_report.event = button_report->event;
+	roccat_report.data1 = button_report->data1;
+	roccat_report.data2 = button_report->data2;
+	roccat_report.profile = isku->actual_profile + 1;
+	roccat_report_event(isku->chrdev_minor,
+			(uint8_t const *)&roccat_report);
+}
+
+static int isku_raw_event(struct hid_device *hdev,
+		struct hid_report *report, u8 *data, int size)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct isku_device *isku = hid_get_drvdata(hdev);
+
+	if (intf->cur_altsetting->desc.bInterfaceProtocol
+			!= ISKU_USB_INTERFACE_PROTOCOL)
+		return 0;
+
+	if (isku == NULL)
+		return 0;
+
+	isku_keep_values_up_to_date(isku, data);
+
+	if (isku->roccat_claimed)
+		isku_report_to_chrdev(isku, data);
+
+	return 0;
+}
+
+static const struct hid_device_id isku_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_ISKU) },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(hid, isku_devices);
+
+static struct hid_driver isku_driver = {
+		.name = "isku",
+		.id_table = isku_devices,
+		.probe = isku_probe,
+		.remove = isku_remove,
+		.raw_event = isku_raw_event
+};
+
+static int __init isku_init(void)
+{
+	int retval;
+	isku_class = class_create(THIS_MODULE, "isku");
+	if (IS_ERR(isku_class))
+		return PTR_ERR(isku_class);
+	isku_class->dev_attrs = isku_attributes;
+	isku_class->dev_bin_attrs = isku_bin_attributes;
+
+	retval = hid_register_driver(&isku_driver);
+	if (retval)
+		class_destroy(isku_class);
+	return retval;
+}
+
+static void __exit isku_exit(void)
+{
+	hid_unregister_driver(&isku_driver);
+	class_destroy(isku_class);
+}
+
+module_init(isku_init);
+module_exit(isku_exit);
+
+MODULE_AUTHOR("Stefan Achatz");
+MODULE_DESCRIPTION("USB Roccat Isku driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/hid/hid-roccat-isku.h b/drivers/hid/hid-roccat-isku.h
new file mode 100644
index 0000000..075f6ef
--- /dev/null
+++ b/drivers/hid/hid-roccat-isku.h
@@ -0,0 +1,147 @@
+#ifndef __HID_ROCCAT_ISKU_H
+#define __HID_ROCCAT_ISKU_H
+
+/*
+ * Copyright (c) 2011 Stefan Achatz <erazor_de@users.sourceforge.net>
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
+	ISKU_PROFILE_NUM = 5,
+	ISKU_USB_INTERFACE_PROTOCOL = 0,
+};
+
+struct isku_control {
+	uint8_t command; /* ISKU_COMMAND_CONTROL */
+	uint8_t value;
+	uint8_t request;
+} __packed;
+
+enum isku_control_values {
+	ISKU_CONTROL_VALUE_STATUS_OVERLOAD = 0,
+	ISKU_CONTROL_VALUE_STATUS_OK = 1,
+	ISKU_CONTROL_VALUE_STATUS_INVALID = 2,
+	ISKU_CONTROL_VALUE_STATUS_WAIT = 3,
+};
+
+struct isku_actual_profile {
+	uint8_t command; /* ISKU_COMMAND_ACTUAL_PROFILE */
+	uint8_t size; /* always 3 */
+	uint8_t actual_profile;
+} __packed;
+
+struct isku_key_mask {
+	uint8_t command; /* ISKU_COMMAND_KEY_MASK */
+	uint8_t size; /* 6 */
+	uint8_t profile_number; /* 0-4 */
+	uint8_t mask;
+	uint16_t checksum;
+} __packed;
+
+struct isku_keys_function {
+	uint8_t data[0x29];
+} __packed;
+
+struct isku_keys_easyzone {
+	uint8_t data[0x41];
+} __packed;
+
+struct isku_keys_media {
+	uint8_t data[0x1d];
+} __packed;
+
+struct isku_keys_thumbster {
+	uint8_t data[0x17];
+} __packed;
+
+struct isku_keys_macro {
+	uint8_t data[0x23];
+} __packed;
+
+struct isku_keys_capslock {
+	uint8_t data[0x6];
+} __packed;
+
+struct isku_macro {
+	uint8_t data[0x823];
+} __packed;
+
+struct isku_light {
+	uint8_t data[0xa];
+} __packed;
+
+struct isku_info {
+	uint8_t data[2];
+	uint8_t firmware_version;
+	uint8_t unknown[3];
+} __packed;
+
+struct isku_talk {
+	uint8_t data[0x10];
+} __packed;
+
+struct isku_last_set {
+	uint8_t data[0x14];
+} __packed;
+
+enum isku_commands {
+	ISKU_COMMAND_CONTROL = 0x4,
+	ISKU_COMMAND_ACTUAL_PROFILE = 0x5,
+	ISKU_COMMAND_KEY_MASK = 0x7,
+	ISKU_COMMAND_KEYS_FUNCTION = 0x8,
+	ISKU_COMMAND_KEYS_EASYZONE = 0x9,
+	ISKU_COMMAND_KEYS_MEDIA = 0xa,
+	ISKU_COMMAND_KEYS_THUMBSTER = 0xb,
+	ISKU_COMMAND_KEYS_MACRO = 0xd,
+	ISKU_COMMAND_MACRO = 0xe,
+	ISKU_COMMAND_INFO = 0xf,
+	ISKU_COMMAND_LIGHT = 0x10,
+	ISKU_COMMAND_KEYS_CAPSLOCK = 0x13,
+	ISKU_COMMAND_LAST_SET = 0x14,
+	ISKU_COMMAND_15 = 0x15,
+	ISKU_COMMAND_TALK = 0x16,
+	ISKU_COMMAND_FIRMWARE_WRITE = 0x1b,
+	ISKU_COMMAND_FIRMWARE_WRITE_CONTROL = 0x1c,
+};
+
+struct isku_report_button {
+	uint8_t number; /* ISKU_REPORT_NUMBER_BUTTON */
+	uint8_t zero;
+	uint8_t event;
+	uint8_t data1;
+	uint8_t data2;
+};
+
+enum isku_report_numbers {
+	ISKU_REPORT_NUMBER_BUTTON = 3,
+};
+
+enum isku_report_button_events {
+	ISKU_REPORT_BUTTON_EVENT_PROFILE = 0x2,
+};
+
+struct isku_roccat_report {
+	uint8_t event;
+	uint8_t data1;
+	uint8_t data2;
+	uint8_t profile;
+} __packed;
+
+struct isku_device {
+	int roccat_claimed;
+	int chrdev_minor;
+
+	struct mutex isku_lock;
+
+	int actual_profile;
+};
+
+#endif
-- 
1.7.3.4



