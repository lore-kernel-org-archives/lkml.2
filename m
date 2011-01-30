Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab1A3Mil (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 07:38:41 -0500
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:46446 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754164Ab1A3Mic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 07:38:32 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-15.arcor-online.net 8B6941AB5F8
Subject: [PATCH 4/8] HID: roccat: Add support for Kova[+] mouse
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Randy Dunlap <rdunlap@xenotime.net>, Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Weber <weber@corscience.de>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 30 Jan 2011 13:38:24 +0100
Message-ID: <1296391104.2283.183.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for Roccat Kova[+] mouse.
Userland tools can soon be found at http://sourceforge.net/projects/roccat

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 .../ABI/testing/sysfs-driver-hid-roccat-kovaplus   |   91 +++
 drivers/hid/Kconfig                                |    8 +
 drivers/hid/Makefile                               |    1 +
 drivers/hid/hid-core.c                             |    1 +
 drivers/hid/hid-ids.h                              |    1 +
 drivers/hid/hid-roccat-kovaplus.c                  |  715 ++++++++++++++++++++
 drivers/hid/hid-roccat-kovaplus.h                  |  157 +++++
 7 files changed, 974 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus
 create mode 100644 drivers/hid/hid-roccat-kovaplus.c
 create mode 100644 drivers/hid/hid-roccat-kovaplus.h

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus
new file mode 100644
index 0000000..9e54af4
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus
@@ -0,0 +1,91 @@
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/actual_cpi
+Date:		January 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The integer value of this attribute ranges from 1-4.
+		When read, this attribute returns the number of the active
+		cpi level.
+		This file is readonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/actual_profile
+Date:		January 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The integer value of this attribute ranges from 0-4.
+		When read, this attribute returns the number of the active
+		profile.
+		When written, the mouse activates this profile immediately.
+		The profile that's active when powered down is the same that's
+		active when the mouse is powered on.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/actual_sensitivity_x
+Date:		January 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The integer value of this attribute ranges from 1-10.
+		When read, this attribute returns the number of the actual
+		sensitivity in x direction.
+		This file is readonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/actual_sensitivity_y
+Date:		January 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The integer value of this attribute ranges from 1-10.
+		When read, this attribute returns the number of the actual
+		sensitivity in y direction.
+		This file is readonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/firmware_version
+Date:		January 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns the raw integer version number of the
+		firmware reported by the mouse. Using the integer value eases
+		further usage in other programs. To receive the real version
+		number the decimal point has to be shifted 2 positions to the
+		left. E.g. a returned value of 121 means 1.21
+		This file is readonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/profile_buttons
+Date:		January 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile is split in settings and buttons.
+		profile_buttons holds informations about button layout.
+		When written, this file lets one write the respective profile
+		buttons back to the mouse. The data has to be 23 bytes long.
+		The mouse will reject invalid data.
+		Which profile to write is determined by the profile number
+		contained in the data.
+		This file is writeonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/profile[1-5]_buttons
+Date:		January 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile is split in settings and buttons.
+		profile_buttons holds informations about button layout.
+		When read, these files return the respective profile buttons.
+		The returned data is 23 bytes in size.
+		This file is readonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/profile_settings
+Date:		January 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile is split in settings and buttons.
+		profile_settings holds informations like resolution, sensitivity
+		and light effects.
+		When written, this file lets one write the respective profile
+		settings back to the mouse. The data has to be 16 bytes long.
+		The mouse will reject invalid data.
+		Which profile to write is determined by the profile number
+		contained in the data.
+		This file is writeonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/profile[1-5]_settings
+Date:		January 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile is split in settings and buttons.
+		profile_settings holds informations like resolution, sensitivity
+		and light effects.
+		When read, these files return the respective profile settings.
+		The returned data is 16 bytes in size.
+		This file is readonly.
diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 7952369..022515f 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -444,6 +444,14 @@ config HID_ROCCAT_KONEPLUS
 	---help---
 	Support for Roccat Kone[+] mouse.
 
+config HID_ROCCAT_KOVAPLUS
+	tristate "Roccat Kova[+] mouse support"
+	depends on USB_HID
+	select HID_ROCCAT
+	select HID_ROCCAT_COMMON
+	---help---
+	Support for Roccat Kova[+] mouse.
+
 config HID_ROCCAT_PYRA
 	tristate "Roccat Pyra mouse support"
 	depends on USB_HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 086cf62..cb80181 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -60,6 +60,7 @@ obj-$(CONFIG_HID_ROCCAT_COMMON)	+= hid-roccat-common.o
 obj-$(CONFIG_HID_ROCCAT_ARVO)	+= hid-roccat-arvo.o
 obj-$(CONFIG_HID_ROCCAT_KONE)	+= hid-roccat-kone.o
 obj-$(CONFIG_HID_ROCCAT_KONEPLUS)	+= hid-roccat-koneplus.o
+obj-$(CONFIG_HID_ROCCAT_KOVAPLUS)	+= hid-roccat-kovaplus.o
 obj-$(CONFIG_HID_ROCCAT_PYRA)	+= hid-roccat-pyra.o
 obj-$(CONFIG_HID_SAMSUNG)	+= hid-samsung.o
 obj-$(CONFIG_HID_SMARTJOYPLUS)	+= hid-sjoy.o
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 6178025..0180f20 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1407,6 +1407,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_ARVO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONEPLUS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KOVAPLUS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_PYRA_WIRED) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_WIRELESS_KBD_MOUSE) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 92e0fa1..75f2e14 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -499,6 +499,7 @@
 #define USB_DEVICE_ID_ROCCAT_ARVO	0x30d4
 #define USB_DEVICE_ID_ROCCAT_KONE	0x2ced
 #define USB_DEVICE_ID_ROCCAT_KONEPLUS	0x2d51
+#define USB_DEVICE_ID_ROCCAT_KOVAPLUS	0x2d50
 #define USB_DEVICE_ID_ROCCAT_PYRA_WIRED	0x2c24
 #define USB_DEVICE_ID_ROCCAT_PYRA_WIRELESS	0x2cf6
 
diff --git a/drivers/hid/hid-roccat-kovaplus.c b/drivers/hid/hid-roccat-kovaplus.c
new file mode 100644
index 0000000..1f547a2
--- /dev/null
+++ b/drivers/hid/hid-roccat-kovaplus.c
@@ -0,0 +1,715 @@
+/*
+ * Roccat Kova[+] driver for Linux
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
+ * Roccat Kova[+] is a bigger version of the Pyra with two more side buttons.
+ */
+
+#include <linux/device.h>
+#include <linux/input.h>
+#include <linux/hid.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include "hid-ids.h"
+#include "hid-roccat.h"
+#include "hid-roccat-common.h"
+#include "hid-roccat-kovaplus.h"
+
+static uint profile_numbers[5] = {0, 1, 2, 3, 4};
+
+static struct class *kovaplus_class;
+
+static uint kovaplus_convert_event_cpi(uint value)
+{
+	return (value == 7 ? 4 : (value == 4 ? 3 : value));
+}
+
+static void kovaplus_profile_activated(struct kovaplus_device *kovaplus,
+		uint new_profile_index)
+{
+	kovaplus->actual_profile = new_profile_index;
+	kovaplus->actual_cpi = kovaplus->profile_settings[new_profile_index].cpi_startup_level;
+	kovaplus->actual_x_sensitivity = kovaplus->profile_settings[new_profile_index].sensitivity_x;
+	kovaplus->actual_y_sensitivity = kovaplus->profile_settings[new_profile_index].sensitivity_y;
+}
+
+static int kovaplus_send_control(struct usb_device *usb_dev, uint value,
+		enum kovaplus_control_requests request)
+{
+	int retval;
+	struct kovaplus_control control;
+
+	if ((request == KOVAPLUS_CONTROL_REQUEST_PROFILE_SETTINGS ||
+			request == KOVAPLUS_CONTROL_REQUEST_PROFILE_BUTTONS) &&
+			value > 4)
+		return -EINVAL;
+
+	control.command = KOVAPLUS_COMMAND_CONTROL;
+	control.value = value;
+	control.request = request;
+
+	retval = roccat_common_send(usb_dev, KOVAPLUS_USB_COMMAND_CONTROL,
+			&control, sizeof(struct kovaplus_control));
+
+	return retval;
+}
+
+static int kovaplus_receive_control_status(struct usb_device *usb_dev)
+{
+	int retval;
+	struct kovaplus_control control;
+
+	do {
+		retval = roccat_common_receive(usb_dev, KOVAPLUS_USB_COMMAND_CONTROL,
+				&control, sizeof(struct kovaplus_control));
+
+		/* check if we get a completely wrong answer */
+		if (retval)
+			return retval;
+
+		if (control.value == KOVAPLUS_CONTROL_REQUEST_STATUS_OK)
+			return 0;
+
+		/* indicates that hardware needs some more time to complete action */
+		if (control.value == KOVAPLUS_CONTROL_REQUEST_STATUS_WAIT) {
+			msleep(500); /* windows driver uses 1000 */
+			continue;
+		}
+
+		/* seems to be critical - replug necessary */
+		if (control.value == KOVAPLUS_CONTROL_REQUEST_STATUS_OVERLOAD)
+			return -EINVAL;
+
+		hid_err(usb_dev, "kovaplus_receive_control_status: "
+				"unknown response value 0x%x\n", control.value);
+		return -EINVAL;
+	} while (1);
+}
+
+static int kovaplus_send(struct usb_device *usb_dev, uint command,
+		void const *buf, uint size)
+{
+	int retval;
+
+	retval = roccat_common_send(usb_dev, command, buf, size);
+	if (retval)
+		return retval;
+
+	msleep(100);
+
+	return kovaplus_receive_control_status(usb_dev);
+}
+
+static int kovaplus_select_profile(struct usb_device *usb_dev, uint number,
+		enum kovaplus_control_requests request)
+{
+	return kovaplus_send_control(usb_dev, number, request);
+}
+
+static int kovaplus_get_info(struct usb_device *usb_dev,
+		struct kovaplus_info *buf)
+{
+	return roccat_common_receive(usb_dev, KOVAPLUS_USB_COMMAND_INFO,
+			buf, sizeof(struct kovaplus_info));
+}
+
+static int kovaplus_get_profile_settings(struct usb_device *usb_dev,
+		struct kovaplus_profile_settings *buf, uint number)
+{
+	int retval;
+
+	retval = kovaplus_select_profile(usb_dev, number,
+			KOVAPLUS_CONTROL_REQUEST_PROFILE_SETTINGS);
+	if (retval)
+		return retval;
+
+	return roccat_common_receive(usb_dev, KOVAPLUS_USB_COMMAND_PROFILE_SETTINGS,
+			buf, sizeof(struct kovaplus_profile_settings));
+}
+
+static int kovaplus_set_profile_settings(struct usb_device *usb_dev,
+		struct kovaplus_profile_settings const *settings)
+{
+	return kovaplus_send(usb_dev, KOVAPLUS_USB_COMMAND_PROFILE_SETTINGS,
+			settings, sizeof(struct kovaplus_profile_settings));
+}
+
+static int kovaplus_get_profile_buttons(struct usb_device *usb_dev,
+		struct kovaplus_profile_buttons *buf, int number)
+{
+	int retval;
+
+	retval = kovaplus_select_profile(usb_dev, number,
+			KOVAPLUS_CONTROL_REQUEST_PROFILE_BUTTONS);
+	if (retval)
+		return retval;
+
+	return roccat_common_receive(usb_dev, KOVAPLUS_USB_COMMAND_PROFILE_BUTTONS,
+			buf, sizeof(struct kovaplus_profile_buttons));
+}
+
+static int kovaplus_set_profile_buttons(struct usb_device *usb_dev,
+		struct kovaplus_profile_buttons const *buttons)
+{
+	return kovaplus_send(usb_dev, KOVAPLUS_USB_COMMAND_PROFILE_BUTTONS,
+			buttons, sizeof(struct kovaplus_profile_buttons));
+}
+
+/* retval is 0-4 on success, < 0 on error */
+static int kovaplus_get_actual_profile(struct usb_device *usb_dev)
+{
+	struct kovaplus_actual_profile buf;
+	int retval;
+
+	retval = roccat_common_receive(usb_dev, KOVAPLUS_USB_COMMAND_ACTUAL_PROFILE,
+			&buf, sizeof(struct kovaplus_actual_profile));
+
+	return retval ? retval : buf.actual_profile;
+}
+
+static int kovaplus_set_actual_profile(struct usb_device *usb_dev,
+		int new_profile)
+{
+	struct kovaplus_actual_profile buf;
+
+	buf.command = KOVAPLUS_COMMAND_ACTUAL_PROFILE;
+	buf.size = sizeof(struct kovaplus_actual_profile);
+	buf.actual_profile = new_profile;
+
+	return kovaplus_send(usb_dev, KOVAPLUS_USB_COMMAND_ACTUAL_PROFILE,
+			&buf, sizeof(struct kovaplus_actual_profile));
+}
+
+static ssize_t kovaplus_sysfs_read_profilex_settings(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	struct device *dev =
+			container_of(kobj, struct device, kobj)->parent->parent;
+	struct kovaplus_device *kovaplus = hid_get_drvdata(dev_get_drvdata(dev));
+
+	if (off >= sizeof(struct kovaplus_profile_settings))
+		return 0;
+
+	if (off + count > sizeof(struct kovaplus_profile_settings))
+		count = sizeof(struct kovaplus_profile_settings) - off;
+
+	mutex_lock(&kovaplus->kovaplus_lock);
+	memcpy(buf, ((char const *)&kovaplus->profile_settings[*(uint *)(attr->private)]) + off,
+			count);
+	mutex_unlock(&kovaplus->kovaplus_lock);
+
+	return count;
+}
+
+static ssize_t kovaplus_sysfs_write_profile_settings(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	struct device *dev =
+			container_of(kobj, struct device, kobj)->parent->parent;
+	struct kovaplus_device *kovaplus = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int retval = 0;
+	int difference;
+	int profile_index;
+	struct kovaplus_profile_settings *profile_settings;
+
+	if (off != 0 || count != sizeof(struct kovaplus_profile_settings))
+		return -EINVAL;
+
+	profile_index = ((struct kovaplus_profile_settings const *)buf)->profile_index;
+	profile_settings = &kovaplus->profile_settings[profile_index];
+
+	mutex_lock(&kovaplus->kovaplus_lock);
+	difference = memcmp(buf, profile_settings,
+			sizeof(struct kovaplus_profile_settings));
+	if (difference) {
+		retval = kovaplus_set_profile_settings(usb_dev,
+				(struct kovaplus_profile_settings const *)buf);
+		if (!retval)
+			memcpy(profile_settings, buf,
+					sizeof(struct kovaplus_profile_settings));
+	}
+	mutex_unlock(&kovaplus->kovaplus_lock);
+
+	if (retval)
+		return retval;
+
+	return sizeof(struct kovaplus_profile_settings);
+}
+
+static ssize_t kovaplus_sysfs_read_profilex_buttons(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	struct device *dev =
+			container_of(kobj, struct device, kobj)->parent->parent;
+	struct kovaplus_device *kovaplus = hid_get_drvdata(dev_get_drvdata(dev));
+
+	if (off >= sizeof(struct kovaplus_profile_buttons))
+		return 0;
+
+	if (off + count > sizeof(struct kovaplus_profile_buttons))
+		count = sizeof(struct kovaplus_profile_buttons) - off;
+
+	mutex_lock(&kovaplus->kovaplus_lock);
+	memcpy(buf, ((char const *)&kovaplus->profile_buttons[*(uint *)(attr->private)]) + off,
+			count);
+	mutex_unlock(&kovaplus->kovaplus_lock);
+
+	return count;
+}
+
+static ssize_t kovaplus_sysfs_write_profile_buttons(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	struct device *dev =
+			container_of(kobj, struct device, kobj)->parent->parent;
+	struct kovaplus_device *kovaplus = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int retval = 0;
+	int difference;
+	uint profile_index;
+	struct kovaplus_profile_buttons *profile_buttons;
+
+	if (off != 0 || count != sizeof(struct kovaplus_profile_buttons))
+		return -EINVAL;
+
+	profile_index = ((struct kovaplus_profile_buttons const *)buf)->profile_index;
+	profile_buttons = &kovaplus->profile_buttons[profile_index];
+
+	mutex_lock(&kovaplus->kovaplus_lock);
+	difference = memcmp(buf, profile_buttons,
+			sizeof(struct kovaplus_profile_buttons));
+	if (difference) {
+		retval = kovaplus_set_profile_buttons(usb_dev,
+				(struct kovaplus_profile_buttons const *)buf);
+		if (!retval)
+			memcpy(profile_buttons, buf,
+					sizeof(struct kovaplus_profile_buttons));
+	}
+	mutex_unlock(&kovaplus->kovaplus_lock);
+
+	if (retval)
+		return retval;
+
+	return sizeof(struct kovaplus_profile_buttons);
+}
+
+static ssize_t kovaplus_sysfs_show_actual_profile(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct kovaplus_device *kovaplus =
+			hid_get_drvdata(dev_get_drvdata(dev->parent->parent));
+	return snprintf(buf, PAGE_SIZE, "%d\n", kovaplus->actual_profile);
+}
+
+static ssize_t kovaplus_sysfs_set_actual_profile(struct device *dev,
+		struct device_attribute *attr, char const *buf, size_t size)
+{
+	struct kovaplus_device *kovaplus;
+	struct usb_device *usb_dev;
+	unsigned long profile;
+	int retval;
+
+	dev = dev->parent->parent;
+	kovaplus = hid_get_drvdata(dev_get_drvdata(dev));
+	usb_dev = interface_to_usbdev(to_usb_interface(dev));
+
+	retval = strict_strtoul(buf, 10, &profile);
+	if (retval)
+		return retval;
+
+	if (profile >= 5)
+		return -EINVAL;
+
+	mutex_lock(&kovaplus->kovaplus_lock);
+	retval = kovaplus_set_actual_profile(usb_dev, profile);
+	kovaplus->actual_profile = profile;
+	mutex_unlock(&kovaplus->kovaplus_lock);
+	if (retval)
+		return retval;
+
+	return size;
+}
+
+static ssize_t kovaplus_sysfs_show_actual_cpi(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct kovaplus_device *kovaplus =
+			hid_get_drvdata(dev_get_drvdata(dev->parent->parent));
+	return snprintf(buf, PAGE_SIZE, "%d\n", kovaplus->actual_cpi);
+}
+
+static ssize_t kovaplus_sysfs_show_actual_sensitivity_x(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct kovaplus_device *kovaplus =
+			hid_get_drvdata(dev_get_drvdata(dev->parent->parent));
+	return snprintf(buf, PAGE_SIZE, "%d\n", kovaplus->actual_x_sensitivity);
+}
+
+static ssize_t kovaplus_sysfs_show_actual_sensitivity_y(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct kovaplus_device *kovaplus =
+			hid_get_drvdata(dev_get_drvdata(dev->parent->parent));
+	return snprintf(buf, PAGE_SIZE, "%d\n", kovaplus->actual_y_sensitivity);
+}
+
+static ssize_t kovaplus_sysfs_show_firmware_version(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct kovaplus_device *kovaplus =
+			hid_get_drvdata(dev_get_drvdata(dev->parent->parent));
+	return snprintf(buf, PAGE_SIZE, "%d\n", kovaplus->info.firmware_version);
+}
+
+static struct device_attribute kovaplus_attributes[] = {
+	__ATTR(actual_cpi, 0440,
+		kovaplus_sysfs_show_actual_cpi, NULL),
+	__ATTR(firmware_version, 0440,
+		kovaplus_sysfs_show_firmware_version, NULL),
+	__ATTR(actual_profile, 0660,
+		kovaplus_sysfs_show_actual_profile,
+		kovaplus_sysfs_set_actual_profile),
+	__ATTR(actual_sensitivity_x, 0440,
+		kovaplus_sysfs_show_actual_sensitivity_x, NULL),
+	__ATTR(actual_sensitivity_y, 0440,
+		kovaplus_sysfs_show_actual_sensitivity_y, NULL),
+	__ATTR_NULL
+};
+
+static struct bin_attribute kovaplus_bin_attributes[] = {
+	{
+		.attr = { .name = "profile_settings", .mode = 0220 },
+		.size = sizeof(struct kovaplus_profile_settings),
+		.write = kovaplus_sysfs_write_profile_settings
+	},
+	{
+		.attr = { .name = "profile1_settings", .mode = 0440 },
+		.size = sizeof(struct kovaplus_profile_settings),
+		.read = kovaplus_sysfs_read_profilex_settings,
+		.private = &profile_numbers[0]
+	},
+	{
+		.attr = { .name = "profile2_settings", .mode = 0440 },
+		.size = sizeof(struct kovaplus_profile_settings),
+		.read = kovaplus_sysfs_read_profilex_settings,
+		.private = &profile_numbers[1]
+	},
+	{
+		.attr = { .name = "profile3_settings", .mode = 0440 },
+		.size = sizeof(struct kovaplus_profile_settings),
+		.read = kovaplus_sysfs_read_profilex_settings,
+		.private = &profile_numbers[2]
+	},
+	{
+		.attr = { .name = "profile4_settings", .mode = 0440 },
+		.size = sizeof(struct kovaplus_profile_settings),
+		.read = kovaplus_sysfs_read_profilex_settings,
+		.private = &profile_numbers[3]
+	},
+	{
+		.attr = { .name = "profile5_settings", .mode = 0440 },
+		.size = sizeof(struct kovaplus_profile_settings),
+		.read = kovaplus_sysfs_read_profilex_settings,
+		.private = &profile_numbers[4]
+	},
+	{
+		.attr = { .name = "profile_buttons", .mode = 0220 },
+		.size = sizeof(struct kovaplus_profile_buttons),
+		.write = kovaplus_sysfs_write_profile_buttons
+	},
+	{
+		.attr = { .name = "profile1_buttons", .mode = 0440 },
+		.size = sizeof(struct kovaplus_profile_buttons),
+		.read = kovaplus_sysfs_read_profilex_buttons,
+		.private = &profile_numbers[0]
+	},
+	{
+		.attr = { .name = "profile2_buttons", .mode = 0440 },
+		.size = sizeof(struct kovaplus_profile_buttons),
+		.read = kovaplus_sysfs_read_profilex_buttons,
+		.private = &profile_numbers[1]
+	},
+	{
+		.attr = { .name = "profile3_buttons", .mode = 0440 },
+		.size = sizeof(struct kovaplus_profile_buttons),
+		.read = kovaplus_sysfs_read_profilex_buttons,
+		.private = &profile_numbers[2]
+	},
+	{
+		.attr = { .name = "profile4_buttons", .mode = 0440 },
+		.size = sizeof(struct kovaplus_profile_buttons),
+		.read = kovaplus_sysfs_read_profilex_buttons,
+		.private = &profile_numbers[3]
+	},
+	{
+		.attr = { .name = "profile5_buttons", .mode = 0440 },
+		.size = sizeof(struct kovaplus_profile_buttons),
+		.read = kovaplus_sysfs_read_profilex_buttons,
+		.private = &profile_numbers[4]
+	},
+	__ATTR_NULL
+};
+
+static int kovaplus_init_kovaplus_device_struct(struct usb_device *usb_dev,
+		struct kovaplus_device *kovaplus)
+{
+	int retval, i;
+	static uint wait = 70; /* device will freeze with just 60 */
+
+	mutex_init(&kovaplus->kovaplus_lock);
+
+	retval = kovaplus_get_info(usb_dev, &kovaplus->info);
+	if (retval)
+		return retval;
+
+	for (i = 0; i < 5; ++i) {
+		msleep(wait);
+		retval = kovaplus_get_profile_settings(usb_dev,
+				&kovaplus->profile_settings[i], i);
+		if (retval)
+			return retval;
+
+		msleep(wait);
+		retval = kovaplus_get_profile_buttons(usb_dev,
+				&kovaplus->profile_buttons[i], i);
+		if (retval)
+			return retval;
+	}
+
+	msleep(wait);
+	retval = kovaplus_get_actual_profile(usb_dev);
+	if (retval < 0)
+		return retval;
+	kovaplus_profile_activated(kovaplus, retval);
+
+	return 0;
+}
+
+static int kovaplus_init_specials(struct hid_device *hdev)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct usb_device *usb_dev = interface_to_usbdev(intf);
+	struct kovaplus_device *kovaplus;
+	int retval;
+
+	if (intf->cur_altsetting->desc.bInterfaceProtocol
+			== USB_INTERFACE_PROTOCOL_MOUSE) {
+
+		kovaplus = kzalloc(sizeof(*kovaplus), GFP_KERNEL);
+		if (!kovaplus) {
+			hid_err(hdev, "can't alloc device descriptor\n");
+			return -ENOMEM;
+		}
+		hid_set_drvdata(hdev, kovaplus);
+
+		retval = kovaplus_init_kovaplus_device_struct(usb_dev, kovaplus);
+		if (retval) {
+			hid_err(hdev, "couldn't init struct kovaplus_device\n");
+			goto exit_free;
+		}
+
+		retval = roccat_connect(kovaplus_class, hdev);
+		if (retval < 0) {
+			hid_err(hdev, "couldn't init char dev\n");
+		} else {
+			kovaplus->chrdev_minor = retval;
+			kovaplus->roccat_claimed = 1;
+		}
+
+	} else {
+		hid_set_drvdata(hdev, NULL);
+	}
+
+	return 0;
+exit_free:
+	kfree(kovaplus);
+	return retval;
+}
+
+static void kovaplus_remove_specials(struct hid_device *hdev)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct kovaplus_device *kovaplus;
+
+	if (intf->cur_altsetting->desc.bInterfaceProtocol
+			== USB_INTERFACE_PROTOCOL_MOUSE) {
+		kovaplus = hid_get_drvdata(hdev);
+		if (kovaplus->roccat_claimed)
+			roccat_disconnect(kovaplus->chrdev_minor);
+		kfree(kovaplus);
+	}
+}
+
+static int kovaplus_probe(struct hid_device *hdev,
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
+	retval = kovaplus_init_specials(hdev);
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
+static void kovaplus_remove(struct hid_device *hdev)
+{
+	kovaplus_remove_specials(hdev);
+	hid_hw_stop(hdev);
+}
+
+static void kovaplus_keep_values_up_to_date(struct kovaplus_device *kovaplus,
+		u8 const *data)
+{
+	struct kovaplus_mouse_report_button const *button_report;
+
+	if (data[0] != KOVAPLUS_MOUSE_REPORT_NUMBER_BUTTON)
+		return;
+
+	button_report = (struct kovaplus_mouse_report_button const *)data;
+
+	switch (button_report->type) {
+	case KOVAPLUS_MOUSE_REPORT_BUTTON_TYPE_PROFILE_1:
+		kovaplus_profile_activated(kovaplus, button_report->data1 - 1);
+		break;
+	case KOVAPLUS_MOUSE_REPORT_BUTTON_TYPE_CPI:
+		kovaplus->actual_cpi = kovaplus_convert_event_cpi(button_report->data1);
+	case KOVAPLUS_MOUSE_REPORT_BUTTON_TYPE_SENSITIVITY:
+		kovaplus->actual_x_sensitivity = button_report->data1;
+		kovaplus->actual_y_sensitivity = button_report->data2;
+	}
+}
+
+static void kovaplus_report_to_chrdev(struct kovaplus_device const *kovaplus,
+		u8 const *data)
+{
+	struct kovaplus_roccat_report roccat_report;
+	struct kovaplus_mouse_report_button const *button_report;
+
+	if (data[0] != KOVAPLUS_MOUSE_REPORT_NUMBER_BUTTON)
+		return;
+
+	button_report = (struct kovaplus_mouse_report_button const *)data;
+
+	if (button_report->type == KOVAPLUS_MOUSE_REPORT_BUTTON_TYPE_PROFILE_2)
+		return;
+
+	roccat_report.type = button_report->type;
+	roccat_report.profile = kovaplus->actual_profile + 1;
+
+	if (roccat_report.type == KOVAPLUS_MOUSE_REPORT_BUTTON_TYPE_MACRO ||
+			roccat_report.type == KOVAPLUS_MOUSE_REPORT_BUTTON_TYPE_SHORTCUT ||
+			roccat_report.type == KOVAPLUS_MOUSE_REPORT_BUTTON_TYPE_QUICKLAUNCH ||
+			roccat_report.type == KOVAPLUS_MOUSE_REPORT_BUTTON_TYPE_TIMER)
+		roccat_report.button = button_report->data1;
+	else
+		roccat_report.button = 0;
+
+	if (roccat_report.type == KOVAPLUS_MOUSE_REPORT_BUTTON_TYPE_CPI)
+		roccat_report.data1 = kovaplus_convert_event_cpi(button_report->data1);
+	else
+		roccat_report.data1 = button_report->data1;
+
+	roccat_report.data2 = button_report->data2;
+
+	roccat_report_event(kovaplus->chrdev_minor,
+			(uint8_t const *)&roccat_report,
+			sizeof(struct kovaplus_roccat_report));
+}
+
+static int kovaplus_raw_event(struct hid_device *hdev,
+		struct hid_report *report, u8 *data, int size)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct kovaplus_device *kovaplus = hid_get_drvdata(hdev);
+
+	if (intf->cur_altsetting->desc.bInterfaceProtocol
+			!= USB_INTERFACE_PROTOCOL_MOUSE)
+		return 0;
+
+	kovaplus_keep_values_up_to_date(kovaplus, data);
+
+	if (kovaplus->roccat_claimed)
+		kovaplus_report_to_chrdev(kovaplus, data);
+
+	return 0;
+}
+
+static const struct hid_device_id kovaplus_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KOVAPLUS) },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(hid, kovaplus_devices);
+
+static struct hid_driver kovaplus_driver = {
+		.name = "kovaplus",
+		.id_table = kovaplus_devices,
+		.probe = kovaplus_probe,
+		.remove = kovaplus_remove,
+		.raw_event = kovaplus_raw_event
+};
+
+static int __init kovaplus_init(void)
+{
+	int retval;
+
+	kovaplus_class = class_create(THIS_MODULE, "kovaplus");
+	if (IS_ERR(kovaplus_class))
+		return PTR_ERR(kovaplus_class);
+	kovaplus_class->dev_attrs = kovaplus_attributes;
+	kovaplus_class->dev_bin_attrs = kovaplus_bin_attributes;
+
+	retval = hid_register_driver(&kovaplus_driver);
+	if (retval)
+		class_destroy(kovaplus_class);
+	return retval;
+}
+
+static void __exit kovaplus_exit(void)
+{
+	class_destroy(kovaplus_class);
+	hid_unregister_driver(&kovaplus_driver);
+}
+
+module_init(kovaplus_init);
+module_exit(kovaplus_exit);
+
+MODULE_AUTHOR("Stefan Achatz");
+MODULE_DESCRIPTION("USB Roccat Kova[+] driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/hid/hid-roccat-kovaplus.h b/drivers/hid/hid-roccat-kovaplus.h
new file mode 100644
index 0000000..ce40607
--- /dev/null
+++ b/drivers/hid/hid-roccat-kovaplus.h
@@ -0,0 +1,157 @@
+#ifndef __HID_ROCCAT_KOVAPLUS_H
+#define __HID_ROCCAT_KOVAPLUS_H
+
+/*
+ * Copyright (c) 2010 Stefan Achatz <erazor_de@users.sourceforge.net>
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
+struct kovaplus_control {
+	uint8_t command; /* KOVAPLUS_COMMAND_CONTROL */
+	uint8_t value;
+	uint8_t request;
+} __packed;
+
+enum kovaplus_control_requests {
+	/* read after write; value = 1 */
+	KOVAPLUS_CONTROL_REQUEST_STATUS = 0x0,
+	/* write; value = profile number range 0-4 */
+	KOVAPLUS_CONTROL_REQUEST_PROFILE_SETTINGS = 0x10,
+	/* write; value = profile number range 0-4 */
+	KOVAPLUS_CONTROL_REQUEST_PROFILE_BUTTONS = 0x20,
+};
+
+enum kovaplus_control_values {
+	KOVAPLUS_CONTROL_REQUEST_STATUS_OVERLOAD = 0, /* supposed */
+	KOVAPLUS_CONTROL_REQUEST_STATUS_OK = 1,
+	KOVAPLUS_CONTROL_REQUEST_STATUS_WAIT = 3, /* supposed */
+};
+
+struct kovaplus_actual_profile {
+	uint8_t command; /* KOVAPLUS_COMMAND_ACTUAL_PROFILE */
+	uint8_t size; /* always 3 */
+	uint8_t actual_profile; /* Range 0-4! */
+} __packed;
+
+struct kovaplus_profile_settings {
+	uint8_t command; /* KOVAPLUS_COMMAND_PROFILE_SETTINGS */
+	uint8_t size; /* 16 */
+	uint8_t profile_index; /* range 0-4 */
+	uint8_t unknown1;
+	uint8_t sensitivity_x; /* range 1-10 */
+	uint8_t sensitivity_y; /* range 1-10 */
+	uint8_t cpi_levels_enabled;
+	uint8_t cpi_startup_level; /* range 1-4 */
+	uint8_t data[8];
+} __packed;
+
+struct kovaplus_profile_buttons {
+	uint8_t command; /* KOVAPLUS_COMMAND_PROFILE_BUTTONS */
+	uint8_t size; /* 23 */
+	uint8_t profile_index; /* range 0-4 */
+	uint8_t data[20];
+} __packed;
+
+struct kovaplus_info {
+	uint8_t command; /* KOVAPLUS_COMMAND_INFO */
+	uint8_t size; /* 6 */
+	uint8_t firmware_version;
+	uint8_t unknown[3];
+} __packed;
+
+/* writes 1 on plugin */
+struct kovaplus_a {
+	uint8_t command; /* KOVAPLUS_COMMAND_A */
+	uint8_t size; /* 3 */
+	uint8_t unknown;
+} __packed;
+
+enum kovaplus_commands {
+	KOVAPLUS_COMMAND_CONTROL = 0x4,
+	KOVAPLUS_COMMAND_ACTUAL_PROFILE = 0x5,
+	KOVAPLUS_COMMAND_PROFILE_SETTINGS = 0x6,
+	KOVAPLUS_COMMAND_PROFILE_BUTTONS = 0x7,
+	KOVAPLUS_COMMAND_INFO = 0x9,
+	KOVAPLUS_COMMAND_A = 0xa,
+};
+
+enum kovaplus_usb_commands {
+	KOVAPLUS_USB_COMMAND_CONTROL = 0x304,
+	KOVAPLUS_USB_COMMAND_ACTUAL_PROFILE = 0x305,
+	KOVAPLUS_USB_COMMAND_PROFILE_SETTINGS = 0x306,
+	KOVAPLUS_USB_COMMAND_PROFILE_BUTTONS = 0x307,
+	KOVAPLUS_USB_COMMAND_INFO = 0x309,
+	KOVAPLUS_USB_COMMAND_A = 0x30a,
+};
+
+enum kovaplus_mouse_report_numbers {
+	KOVAPLUS_MOUSE_REPORT_NUMBER_MOUSE = 1,
+	KOVAPLUS_MOUSE_REPORT_NUMBER_AUDIO = 2,
+	KOVAPLUS_MOUSE_REPORT_NUMBER_BUTTON = 3,
+	KOVAPLUS_MOUSE_REPORT_NUMBER_KBD = 4,
+};
+
+struct kovaplus_mouse_report_button {
+	uint8_t report_number; /* KOVAPLUS_MOUSE_REPORT_NUMBER_BUTTON */
+	uint8_t unknown1;
+	uint8_t type;
+	uint8_t data1;
+	uint8_t data2;
+} __packed;
+
+enum kovaplus_mouse_report_button_types {
+	/* data1 = profile_number range 1-5; no release event */
+	KOVAPLUS_MOUSE_REPORT_BUTTON_TYPE_PROFILE_1 = 0x20,
+	/* data1 = profile_number range 1-5; no release event */
+	KOVAPLUS_MOUSE_REPORT_BUTTON_TYPE_PROFILE_2 = 0x30,
+	/* data1 = button_number range 1-18; data2 = action */
+	KOVAPLUS_MOUSE_REPORT_BUTTON_TYPE_MACRO = 0x40,
+	/* data1 = button_number range 1-18; data2 = action */
+	KOVAPLUS_MOUSE_REPORT_BUTTON_TYPE_SHORTCUT = 0x50,
+	/* data1 = button_number range 1-18; data2 = action */
+	KOVAPLUS_MOUSE_REPORT_BUTTON_TYPE_QUICKLAUNCH = 0x60,
+	/* data1 = button_number range 1-18; data2 = action */
+	KOVAPLUS_MOUSE_REPORT_BUTTON_TYPE_TIMER = 0x80,
+	/* data1 = 1 = 400, 2 = 800, 4 = 1600, 7 = 3200; no release event */
+	KOVAPLUS_MOUSE_REPORT_BUTTON_TYPE_CPI = 0xb0,
+	/* data1 + data2 = sense range 1-10; no release event */
+	KOVAPLUS_MOUSE_REPORT_BUTTON_TYPE_SENSITIVITY = 0xc0,
+	/* data1 = type as in profile_buttons; data2 = action */
+	KOVAPLUS_MOUSE_REPORT_BUTTON_TYPE_MULTIMEDIA = 0xf0,
+};
+
+enum kovaplus_mouse_report_button_actions {
+	KOVAPLUS_MOUSE_REPORT_BUTTON_ACTION_PRESS = 0,
+	KOVAPLUS_MOUSE_REPORT_BUTTON_ACTION_RELEASE = 1,
+};
+
+struct kovaplus_roccat_report {
+	uint8_t type;
+	uint8_t profile;
+	uint8_t button;
+	uint8_t data1;
+	uint8_t data2;
+} __packed;
+
+struct kovaplus_device {
+	int actual_profile;
+	int actual_cpi;
+	int actual_x_sensitivity;
+	int actual_y_sensitivity;
+	int roccat_claimed;
+	int chrdev_minor;
+	struct mutex kovaplus_lock;
+	struct kovaplus_info info;
+	struct kovaplus_profile_settings profile_settings[5];
+	struct kovaplus_profile_buttons profile_buttons[5];
+};
+
+#endif
-- 
1.7.3.4



