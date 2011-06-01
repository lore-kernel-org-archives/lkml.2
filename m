Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974Ab1FANy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 09:54:28 -0400
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:42912 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757677Ab1FANyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 09:54:20 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-15.arcor-online.net 91CE51AB647
Subject: [PATCH] HID: roccat: Correction and cleanup of hid feature reports
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 15:54:17 +0200
Message-ID: <1306936457.2486.7.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed analog feature report enums and modified code in roccat_common
to reflect this. Non standard conform Kone got its own copy of the old
code. That helps extracting more generalizations for newer devices.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-arvo.c     |   16 +++++-----
 drivers/hid/hid-roccat-arvo.h     |   13 ---------
 drivers/hid/hid-roccat-common.c   |   20 ++++++++++----
 drivers/hid/hid-roccat-common.h   |    4 +-
 drivers/hid/hid-roccat-kone.c     |   53 ++++++++++++++++++++++++++++++++----
 drivers/hid/hid-roccat-kone.h     |    2 +-
 drivers/hid/hid-roccat-koneplus.c |   30 ++++++++++----------
 drivers/hid/hid-roccat-koneplus.h |   16 +----------
 drivers/hid/hid-roccat-kovaplus.c |   20 +++++++-------
 drivers/hid/hid-roccat-kovaplus.h |    9 ------
 drivers/hid/hid-roccat-pyra.c     |   22 ++++++---------
 drivers/hid/hid-roccat-pyra.h     |    9 ------
 12 files changed, 107 insertions(+), 107 deletions(-)

diff --git a/drivers/hid/hid-roccat-arvo.c b/drivers/hid/hid-roccat-arvo.c
index 2307471..6105366 100644
--- a/drivers/hid/hid-roccat-arvo.c
+++ b/drivers/hid/hid-roccat-arvo.c
@@ -39,7 +39,7 @@ static ssize_t arvo_sysfs_show_mode_key(struct device *dev,
 	int retval;
 
 	mutex_lock(&arvo->arvo_lock);
-	retval = roccat_common_receive(usb_dev, ARVO_USB_COMMAND_MODE_KEY,
+	retval = roccat_common_receive(usb_dev, ARVO_COMMAND_MODE_KEY,
 			&temp_buf, sizeof(struct arvo_mode_key));
 	mutex_unlock(&arvo->arvo_lock);
 	if (retval)
@@ -67,7 +67,7 @@ static ssize_t arvo_sysfs_set_mode_key(struct device *dev,
 	temp_buf.state = state;
 
 	mutex_lock(&arvo->arvo_lock);
-	retval = roccat_common_send(usb_dev, ARVO_USB_COMMAND_MODE_KEY,
+	retval = roccat_common_send(usb_dev, ARVO_COMMAND_MODE_KEY,
 			&temp_buf, sizeof(struct arvo_mode_key));
 	mutex_unlock(&arvo->arvo_lock);
 	if (retval)
@@ -87,7 +87,7 @@ static ssize_t arvo_sysfs_show_key_mask(struct device *dev,
 	int retval;
 
 	mutex_lock(&arvo->arvo_lock);
-	retval = roccat_common_receive(usb_dev, ARVO_USB_COMMAND_KEY_MASK,
+	retval = roccat_common_receive(usb_dev, ARVO_COMMAND_KEY_MASK,
 			&temp_buf, sizeof(struct arvo_key_mask));
 	mutex_unlock(&arvo->arvo_lock);
 	if (retval)
@@ -115,7 +115,7 @@ static ssize_t arvo_sysfs_set_key_mask(struct device *dev,
 	temp_buf.key_mask = key_mask;
 
 	mutex_lock(&arvo->arvo_lock);
-	retval = roccat_common_send(usb_dev, ARVO_USB_COMMAND_KEY_MASK,
+	retval = roccat_common_send(usb_dev, ARVO_COMMAND_KEY_MASK,
 			&temp_buf, sizeof(struct arvo_key_mask));
 	mutex_unlock(&arvo->arvo_lock);
 	if (retval)
@@ -130,7 +130,7 @@ static int arvo_get_actual_profile(struct usb_device *usb_dev)
 	struct arvo_actual_profile temp_buf;
 	int retval;
 
-	retval = roccat_common_receive(usb_dev, ARVO_USB_COMMAND_ACTUAL_PROFILE,
+	retval = roccat_common_receive(usb_dev, ARVO_COMMAND_ACTUAL_PROFILE,
 			&temp_buf, sizeof(struct arvo_actual_profile));
 
 	if (retval)
@@ -167,7 +167,7 @@ static ssize_t arvo_sysfs_set_actual_profile(struct device *dev,
 	temp_buf.actual_profile = profile;
 
 	mutex_lock(&arvo->arvo_lock);
-	retval = roccat_common_send(usb_dev, ARVO_USB_COMMAND_ACTUAL_PROFILE,
+	retval = roccat_common_send(usb_dev, ARVO_COMMAND_ACTUAL_PROFILE,
 			&temp_buf, sizeof(struct arvo_actual_profile));
 	if (!retval) {
 		arvo->actual_profile = profile;
@@ -225,7 +225,7 @@ static ssize_t arvo_sysfs_write_button(struct file *fp,
 		loff_t off, size_t count)
 {
 	return arvo_sysfs_write(fp, kobj, buf, off, count,
-			sizeof(struct arvo_button), ARVO_USB_COMMAND_BUTTON);
+			sizeof(struct arvo_button), ARVO_COMMAND_BUTTON);
 }
 
 static ssize_t arvo_sysfs_read_info(struct file *fp,
@@ -233,7 +233,7 @@ static ssize_t arvo_sysfs_read_info(struct file *fp,
 		loff_t off, size_t count)
 {
 	return arvo_sysfs_read(fp, kobj, buf, off, count,
-			sizeof(struct arvo_info), ARVO_USB_COMMAND_INFO);
+			sizeof(struct arvo_info), ARVO_COMMAND_INFO);
 }
 
 
diff --git a/drivers/hid/hid-roccat-arvo.h b/drivers/hid/hid-roccat-arvo.h
index d284a78..ce8415e 100644
--- a/drivers/hid/hid-roccat-arvo.h
+++ b/drivers/hid/hid-roccat-arvo.h
@@ -46,19 +46,6 @@ enum arvo_commands {
 	ARVO_COMMAND_ACTUAL_PROFILE = 0x7,
 };
 
-enum arvo_usb_commands {
-	ARVO_USB_COMMAND_MODE_KEY = 0x303,
-	/*
-	 * read/write
-	 * Read uses both index bytes as profile/key indexes
-	 * Write has index 0, profile/key is determined by payload
-	 */
-	ARVO_USB_COMMAND_BUTTON = 0x304,
-	ARVO_USB_COMMAND_INFO = 0x305,
-	ARVO_USB_COMMAND_KEY_MASK = 0x306,
-	ARVO_USB_COMMAND_ACTUAL_PROFILE = 0x307,
-};
-
 struct arvo_special_report {
 	uint8_t unknown1; /* always 0x01 */
 	uint8_t event;
diff --git a/drivers/hid/hid-roccat-common.c b/drivers/hid/hid-roccat-common.c
index 13b1eb0..edf898d 100644
--- a/drivers/hid/hid-roccat-common.c
+++ b/drivers/hid/hid-roccat-common.c
@@ -11,10 +11,16 @@
  * any later version.
  */
 
+#include <linux/hid.h>
 #include <linux/slab.h>
 #include "hid-roccat-common.h"
 
-int roccat_common_receive(struct usb_device *usb_dev, uint usb_command,
+static inline uint16_t roccat_common_feature_report(uint8_t report_id)
+{
+	return 0x300 | report_id;
+}
+
+int roccat_common_receive(struct usb_device *usb_dev, uint report_id,
 		void *data, uint size)
 {
 	char *buf;
@@ -25,9 +31,10 @@ int roccat_common_receive(struct usb_device *usb_dev, uint usb_command,
 		return -ENOMEM;
 
 	len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
-			USB_REQ_CLEAR_FEATURE,
+			HID_REQ_GET_REPORT,
 			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
-			usb_command, 0, buf, size, USB_CTRL_SET_TIMEOUT);
+			roccat_common_feature_report(report_id),
+			0, buf, size, USB_CTRL_SET_TIMEOUT);
 
 	memcpy(data, buf, size);
 	kfree(buf);
@@ -35,7 +42,7 @@ int roccat_common_receive(struct usb_device *usb_dev, uint usb_command,
 }
 EXPORT_SYMBOL_GPL(roccat_common_receive);
 
-int roccat_common_send(struct usb_device *usb_dev, uint usb_command,
+int roccat_common_send(struct usb_device *usb_dev, uint report_id,
 		void const *data, uint size)
 {
 	char *buf;
@@ -48,9 +55,10 @@ int roccat_common_send(struct usb_device *usb_dev, uint usb_command,
 	memcpy(buf, data, size);
 
 	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
-			USB_REQ_SET_CONFIGURATION,
+			HID_REQ_SET_REPORT,
 			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
-			usb_command, 0, buf, size, USB_CTRL_SET_TIMEOUT);
+			roccat_common_feature_report(report_id),
+			0, buf, size, USB_CTRL_SET_TIMEOUT);
 
 	kfree(buf);
 	return ((len < 0) ? len : ((len != size) ? -EIO : 0));
diff --git a/drivers/hid/hid-roccat-common.h b/drivers/hid/hid-roccat-common.h
index fe45fae..9a5bc61 100644
--- a/drivers/hid/hid-roccat-common.h
+++ b/drivers/hid/hid-roccat-common.h
@@ -15,9 +15,9 @@
 #include <linux/usb.h>
 #include <linux/types.h>
 
-int roccat_common_receive(struct usb_device *usb_dev, uint usb_command,
+int roccat_common_receive(struct usb_device *usb_dev, uint report_id,
 		void *data, uint size);
-int roccat_common_send(struct usb_device *usb_dev, uint usb_command,
+int roccat_common_send(struct usb_device *usb_dev, uint report_id,
 		void const *data, uint size);
 
 #endif
diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
index a57838d..7e29778 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -37,6 +37,47 @@
 
 static uint profile_numbers[5] = {0, 1, 2, 3, 4};
 
+static int kone_receive(struct usb_device *usb_dev, uint usb_command,
+		void *data, uint size)
+{
+	char *buf;
+	int len;
+
+	buf = kmalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
+			HID_REQ_GET_REPORT,
+			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
+			usb_command, 0, buf, size, USB_CTRL_SET_TIMEOUT);
+
+	memcpy(data, buf, size);
+	kfree(buf);
+	return ((len < 0) ? len : ((len != size) ? -EIO : 0));
+}
+
+static int kone_send(struct usb_device *usb_dev, uint usb_command,
+		void const *data, uint size)
+{
+	char *buf;
+	int len;
+
+	buf = kmalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	memcpy(buf, data, size);
+
+	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
+			HID_REQ_SET_REPORT,
+			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
+			usb_command, 0, buf, size, USB_CTRL_SET_TIMEOUT);
+
+	kfree(buf);
+	return ((len < 0) ? len : ((len != size) ? -EIO : 0));
+}
+
 /* kone_class is used for creating sysfs attributes via roccat char device */
 static struct class *kone_class;
 
@@ -68,7 +109,7 @@ static int kone_check_write(struct usb_device *usb_dev)
 		 */
 		msleep(80);
 
-		retval = roccat_common_receive(usb_dev,
+		retval = kone_receive(usb_dev,
 				kone_command_confirm_write, &data, 1);
 		if (retval)
 			return retval;
@@ -96,7 +137,7 @@ static int kone_check_write(struct usb_device *usb_dev)
 static int kone_get_settings(struct usb_device *usb_dev,
 		struct kone_settings *buf)
 {
-	return roccat_common_receive(usb_dev, kone_command_settings, buf,
+	return kone_receive(usb_dev, kone_command_settings, buf,
 			sizeof(struct kone_settings));
 }
 
@@ -109,7 +150,7 @@ static int kone_set_settings(struct usb_device *usb_dev,
 		struct kone_settings const *settings)
 {
 	int retval;
-	retval = roccat_common_send(usb_dev, kone_command_settings,
+	retval = kone_send(usb_dev, kone_command_settings,
 			settings, sizeof(struct kone_settings));
 	if (retval)
 		return retval;
@@ -182,7 +223,7 @@ static int kone_get_weight(struct usb_device *usb_dev, int *result)
 	int retval;
 	uint8_t data;
 
-	retval = roccat_common_receive(usb_dev, kone_command_weight, &data, 1);
+	retval = kone_receive(usb_dev, kone_command_weight, &data, 1);
 
 	if (retval)
 		return retval;
@@ -201,7 +242,7 @@ static int kone_get_firmware_version(struct usb_device *usb_dev, int *result)
 	int retval;
 	uint16_t data;
 
-	retval = roccat_common_receive(usb_dev, kone_command_firmware_version,
+	retval = kone_receive(usb_dev, kone_command_firmware_version,
 			&data, 2);
 	if (retval)
 		return retval;
@@ -384,7 +425,7 @@ static int kone_tcu_command(struct usb_device *usb_dev, int number)
 {
 	unsigned char value;
 	value = number;
-	return roccat_common_send(usb_dev, kone_command_calibrate, &value, 1);
+	return kone_send(usb_dev, kone_command_calibrate, &value, 1);
 }
 
 /*
diff --git a/drivers/hid/hid-roccat-kone.h b/drivers/hid/hid-roccat-kone.h
index 4109a02..64abb5b 100644
--- a/drivers/hid/hid-roccat-kone.h
+++ b/drivers/hid/hid-roccat-kone.h
@@ -166,7 +166,7 @@ enum kone_mouse_events {
 	/* osd events are thought to be display on screen */
 	kone_mouse_event_osd_dpi = 0xa0,
 	kone_mouse_event_osd_profile = 0xb0,
-	/* TODO clarify meaning and occurrence of kone_mouse_event_calibration */
+	/* TODO clarify meaning and occurence of kone_mouse_event_calibration */
 	kone_mouse_event_calibration = 0xc0,
 	kone_mouse_event_call_overlong_macro = 0xe0,
 	/* switch events notify if user changed values with mousebutton click */
diff --git a/drivers/hid/hid-roccat-koneplus.c b/drivers/hid/hid-roccat-koneplus.c
index 23cdb44..33ecad5 100644
--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -50,7 +50,7 @@ static int koneplus_send_control(struct usb_device *usb_dev, uint value,
 	control.value = value;
 	control.request = request;
 
-	return roccat_common_send(usb_dev, KONEPLUS_USB_COMMAND_CONTROL,
+	return roccat_common_send(usb_dev, KONEPLUS_COMMAND_CONTROL,
 			&control, sizeof(struct koneplus_control));
 }
 
@@ -60,7 +60,7 @@ static int koneplus_receive_control_status(struct usb_device *usb_dev)
 	struct koneplus_control control;
 
 	do {
-		retval = roccat_common_receive(usb_dev, KONEPLUS_USB_COMMAND_CONTROL,
+		retval = roccat_common_receive(usb_dev, KONEPLUS_COMMAND_CONTROL,
 				&control, sizeof(struct koneplus_control));
 
 		/* check if we get a completely wrong answer */
@@ -120,7 +120,7 @@ static int koneplus_select_profile(struct usb_device *usb_dev, uint number,
 static int koneplus_get_info(struct usb_device *usb_dev,
 		struct koneplus_info *buf)
 {
-	return roccat_common_receive(usb_dev, KONEPLUS_USB_COMMAND_INFO,
+	return roccat_common_receive(usb_dev, KONEPLUS_COMMAND_INFO,
 			buf, sizeof(struct koneplus_info));
 }
 
@@ -134,14 +134,14 @@ static int koneplus_get_profile_settings(struct usb_device *usb_dev,
 	if (retval)
 		return retval;
 
-	return roccat_common_receive(usb_dev, KONEPLUS_USB_COMMAND_PROFILE_SETTINGS,
+	return roccat_common_receive(usb_dev, KONEPLUS_COMMAND_PROFILE_SETTINGS,
 			buf, sizeof(struct koneplus_profile_settings));
 }
 
 static int koneplus_set_profile_settings(struct usb_device *usb_dev,
 		struct koneplus_profile_settings const *settings)
 {
-	return koneplus_send(usb_dev, KONEPLUS_USB_COMMAND_PROFILE_SETTINGS,
+	return koneplus_send(usb_dev, KONEPLUS_COMMAND_PROFILE_SETTINGS,
 			settings, sizeof(struct koneplus_profile_settings));
 }
 
@@ -155,14 +155,14 @@ static int koneplus_get_profile_buttons(struct usb_device *usb_dev,
 	if (retval)
 		return retval;
 
-	return roccat_common_receive(usb_dev, KONEPLUS_USB_COMMAND_PROFILE_BUTTONS,
+	return roccat_common_receive(usb_dev, KONEPLUS_COMMAND_PROFILE_BUTTONS,
 			buf, sizeof(struct koneplus_profile_buttons));
 }
 
 static int koneplus_set_profile_buttons(struct usb_device *usb_dev,
 		struct koneplus_profile_buttons const *buttons)
 {
-	return koneplus_send(usb_dev, KONEPLUS_USB_COMMAND_PROFILE_BUTTONS,
+	return koneplus_send(usb_dev, KONEPLUS_COMMAND_PROFILE_BUTTONS,
 			buttons, sizeof(struct koneplus_profile_buttons));
 }
 
@@ -172,7 +172,7 @@ static int koneplus_get_actual_profile(struct usb_device *usb_dev)
 	struct koneplus_actual_profile buf;
 	int retval;
 
-	retval = roccat_common_receive(usb_dev, KONEPLUS_USB_COMMAND_ACTUAL_PROFILE,
+	retval = roccat_common_receive(usb_dev, KONEPLUS_COMMAND_ACTUAL_PROFILE,
 			&buf, sizeof(struct koneplus_actual_profile));
 
 	return retval ? retval : buf.actual_profile;
@@ -187,7 +187,7 @@ static int koneplus_set_actual_profile(struct usb_device *usb_dev,
 	buf.size = sizeof(struct koneplus_actual_profile);
 	buf.actual_profile = new_profile;
 
-	return koneplus_send(usb_dev, KONEPLUS_USB_COMMAND_ACTUAL_PROFILE,
+	return koneplus_send(usb_dev, KONEPLUS_COMMAND_ACTUAL_PROFILE,
 			&buf, sizeof(struct koneplus_actual_profile));
 }
 
@@ -245,7 +245,7 @@ static ssize_t koneplus_sysfs_write_talk(struct file *fp,
 		loff_t off, size_t count)
 {
 	return koneplus_sysfs_write(fp, kobj, buf, off, count,
-			sizeof(struct koneplus_talk), KONEPLUS_USB_COMMAND_TALK);
+			sizeof(struct koneplus_talk), KONEPLUS_COMMAND_TALK);
 }
 
 static ssize_t koneplus_sysfs_write_macro(struct file *fp,
@@ -253,7 +253,7 @@ static ssize_t koneplus_sysfs_write_macro(struct file *fp,
 		loff_t off, size_t count)
 {
 	return koneplus_sysfs_write(fp, kobj, buf, off, count,
-			sizeof(struct koneplus_macro), KONEPLUS_USB_COMMAND_MACRO);
+			sizeof(struct koneplus_macro), KONEPLUS_COMMAND_MACRO);
 }
 
 static ssize_t koneplus_sysfs_read_sensor(struct file *fp,
@@ -261,7 +261,7 @@ static ssize_t koneplus_sysfs_read_sensor(struct file *fp,
 		loff_t off, size_t count)
 {
 	return koneplus_sysfs_read(fp, kobj, buf, off, count,
-			sizeof(struct koneplus_sensor), KONEPLUS_USB_COMMAND_SENSOR);
+			sizeof(struct koneplus_sensor), KONEPLUS_COMMAND_SENSOR);
 }
 
 static ssize_t koneplus_sysfs_write_sensor(struct file *fp,
@@ -269,7 +269,7 @@ static ssize_t koneplus_sysfs_write_sensor(struct file *fp,
 		loff_t off, size_t count)
 {
 	return koneplus_sysfs_write(fp, kobj, buf, off, count,
-			sizeof(struct koneplus_sensor), KONEPLUS_USB_COMMAND_SENSOR);
+			sizeof(struct koneplus_sensor), KONEPLUS_COMMAND_SENSOR);
 }
 
 static ssize_t koneplus_sysfs_write_tcu(struct file *fp,
@@ -277,7 +277,7 @@ static ssize_t koneplus_sysfs_write_tcu(struct file *fp,
 		loff_t off, size_t count)
 {
 	return koneplus_sysfs_write(fp, kobj, buf, off, count,
-			sizeof(struct koneplus_tcu), KONEPLUS_USB_COMMAND_TCU);
+			sizeof(struct koneplus_tcu), KONEPLUS_COMMAND_TCU);
 }
 
 static ssize_t koneplus_sysfs_read_tcu_image(struct file *fp,
@@ -285,7 +285,7 @@ static ssize_t koneplus_sysfs_read_tcu_image(struct file *fp,
 		loff_t off, size_t count)
 {
 	return koneplus_sysfs_read(fp, kobj, buf, off, count,
-			sizeof(struct koneplus_tcu_image), KONEPLUS_USB_COMMAND_TCU);
+			sizeof(struct koneplus_tcu_image), KONEPLUS_COMMAND_TCU);
 }
 
 static ssize_t koneplus_sysfs_read_profilex_settings(struct file *fp,
diff --git a/drivers/hid/hid-roccat-koneplus.h b/drivers/hid/hid-roccat-koneplus.h
index 0bf2520..c03332a 100644
--- a/drivers/hid/hid-roccat-koneplus.h
+++ b/drivers/hid/hid-roccat-koneplus.h
@@ -143,6 +143,7 @@ enum koneplus_commands {
 	KONEPLUS_COMMAND_PROFILE_BUTTONS = 0x7,
 	KONEPLUS_COMMAND_MACRO = 0x8,
 	KONEPLUS_COMMAND_INFO = 0x9,
+	KONEPLUS_COMMAND_TCU = 0xc,
 	KONEPLUS_COMMAND_E = 0xe,
 	KONEPLUS_COMMAND_SENSOR = 0xf,
 	KONEPLUS_COMMAND_TALK = 0x10,
@@ -150,21 +151,6 @@ enum koneplus_commands {
 	KONEPLUS_COMMAND_FIRMWARE_WRITE_CONTROL = 0x1c,
 };
 
-enum koneplus_usb_commands {
-	KONEPLUS_USB_COMMAND_CONTROL = 0x304,
-	KONEPLUS_USB_COMMAND_ACTUAL_PROFILE = 0x305,
-	KONEPLUS_USB_COMMAND_PROFILE_SETTINGS = 0x306,
-	KONEPLUS_USB_COMMAND_PROFILE_BUTTONS = 0x307,
-	KONEPLUS_USB_COMMAND_MACRO = 0x308,
-	KONEPLUS_USB_COMMAND_INFO = 0x309,
-	KONEPLUS_USB_COMMAND_TCU = 0x30c,
-	KONEPLUS_USB_COMMAND_E = 0x30e,
-	KONEPLUS_USB_COMMAND_SENSOR = 0x30f,
-	KONEPLUS_USB_COMMAND_TALK = 0x310,
-	KONEPLUS_USB_COMMAND_FIRMWARE_WRITE = 0x31b,
-	KONEPLUS_USB_COMMAND_FIRMWARE_WRITE_CONTROL = 0x31c,
-};
-
 enum koneplus_mouse_report_numbers {
 	KONEPLUS_MOUSE_REPORT_NUMBER_HID = 1,
 	KONEPLUS_MOUSE_REPORT_NUMBER_AUDIO = 2,
diff --git a/drivers/hid/hid-roccat-kovaplus.c b/drivers/hid/hid-roccat-kovaplus.c
index 984be2f..212e792 100644
--- a/drivers/hid/hid-roccat-kovaplus.c
+++ b/drivers/hid/hid-roccat-kovaplus.c
@@ -58,7 +58,7 @@ static int kovaplus_send_control(struct usb_device *usb_dev, uint value,
 	control.value = value;
 	control.request = request;
 
-	retval = roccat_common_send(usb_dev, KOVAPLUS_USB_COMMAND_CONTROL,
+	retval = roccat_common_send(usb_dev, KOVAPLUS_COMMAND_CONTROL,
 			&control, sizeof(struct kovaplus_control));
 
 	return retval;
@@ -70,7 +70,7 @@ static int kovaplus_receive_control_status(struct usb_device *usb_dev)
 	struct kovaplus_control control;
 
 	do {
-		retval = roccat_common_receive(usb_dev, KOVAPLUS_USB_COMMAND_CONTROL,
+		retval = roccat_common_receive(usb_dev, KOVAPLUS_COMMAND_CONTROL,
 				&control, sizeof(struct kovaplus_control));
 
 		/* check if we get a completely wrong answer */
@@ -90,7 +90,7 @@ static int kovaplus_receive_control_status(struct usb_device *usb_dev)
 		if (control.value == KOVAPLUS_CONTROL_REQUEST_STATUS_OVERLOAD)
 			return -EINVAL;
 
-		hid_err(usb_dev, "kovaplus_receive_control_status: "
+		hid_err(usb_dev, "roccat_common_receive_control_status: "
 				"unknown response value 0x%x\n", control.value);
 		return -EINVAL;
 	} while (1);
@@ -119,7 +119,7 @@ static int kovaplus_select_profile(struct usb_device *usb_dev, uint number,
 static int kovaplus_get_info(struct usb_device *usb_dev,
 		struct kovaplus_info *buf)
 {
-	return roccat_common_receive(usb_dev, KOVAPLUS_USB_COMMAND_INFO,
+	return roccat_common_receive(usb_dev, KOVAPLUS_COMMAND_INFO,
 			buf, sizeof(struct kovaplus_info));
 }
 
@@ -133,14 +133,14 @@ static int kovaplus_get_profile_settings(struct usb_device *usb_dev,
 	if (retval)
 		return retval;
 
-	return roccat_common_receive(usb_dev, KOVAPLUS_USB_COMMAND_PROFILE_SETTINGS,
+	return roccat_common_receive(usb_dev, KOVAPLUS_COMMAND_PROFILE_SETTINGS,
 			buf, sizeof(struct kovaplus_profile_settings));
 }
 
 static int kovaplus_set_profile_settings(struct usb_device *usb_dev,
 		struct kovaplus_profile_settings const *settings)
 {
-	return kovaplus_send(usb_dev, KOVAPLUS_USB_COMMAND_PROFILE_SETTINGS,
+	return kovaplus_send(usb_dev, KOVAPLUS_COMMAND_PROFILE_SETTINGS,
 			settings, sizeof(struct kovaplus_profile_settings));
 }
 
@@ -154,14 +154,14 @@ static int kovaplus_get_profile_buttons(struct usb_device *usb_dev,
 	if (retval)
 		return retval;
 
-	return roccat_common_receive(usb_dev, KOVAPLUS_USB_COMMAND_PROFILE_BUTTONS,
+	return roccat_common_receive(usb_dev, KOVAPLUS_COMMAND_PROFILE_BUTTONS,
 			buf, sizeof(struct kovaplus_profile_buttons));
 }
 
 static int kovaplus_set_profile_buttons(struct usb_device *usb_dev,
 		struct kovaplus_profile_buttons const *buttons)
 {
-	return kovaplus_send(usb_dev, KOVAPLUS_USB_COMMAND_PROFILE_BUTTONS,
+	return kovaplus_send(usb_dev, KOVAPLUS_COMMAND_PROFILE_BUTTONS,
 			buttons, sizeof(struct kovaplus_profile_buttons));
 }
 
@@ -171,7 +171,7 @@ static int kovaplus_get_actual_profile(struct usb_device *usb_dev)
 	struct kovaplus_actual_profile buf;
 	int retval;
 
-	retval = roccat_common_receive(usb_dev, KOVAPLUS_USB_COMMAND_ACTUAL_PROFILE,
+	retval = roccat_common_receive(usb_dev, KOVAPLUS_COMMAND_ACTUAL_PROFILE,
 			&buf, sizeof(struct kovaplus_actual_profile));
 
 	return retval ? retval : buf.actual_profile;
@@ -186,7 +186,7 @@ static int kovaplus_set_actual_profile(struct usb_device *usb_dev,
 	buf.size = sizeof(struct kovaplus_actual_profile);
 	buf.actual_profile = new_profile;
 
-	return kovaplus_send(usb_dev, KOVAPLUS_USB_COMMAND_ACTUAL_PROFILE,
+	return kovaplus_send(usb_dev, KOVAPLUS_COMMAND_ACTUAL_PROFILE,
 			&buf, sizeof(struct kovaplus_actual_profile));
 }
 
diff --git a/drivers/hid/hid-roccat-kovaplus.h b/drivers/hid/hid-roccat-kovaplus.h
index ce40607..fb2aed4 100644
--- a/drivers/hid/hid-roccat-kovaplus.h
+++ b/drivers/hid/hid-roccat-kovaplus.h
@@ -83,15 +83,6 @@ enum kovaplus_commands {
 	KOVAPLUS_COMMAND_A = 0xa,
 };
 
-enum kovaplus_usb_commands {
-	KOVAPLUS_USB_COMMAND_CONTROL = 0x304,
-	KOVAPLUS_USB_COMMAND_ACTUAL_PROFILE = 0x305,
-	KOVAPLUS_USB_COMMAND_PROFILE_SETTINGS = 0x306,
-	KOVAPLUS_USB_COMMAND_PROFILE_BUTTONS = 0x307,
-	KOVAPLUS_USB_COMMAND_INFO = 0x309,
-	KOVAPLUS_USB_COMMAND_A = 0x30a,
-};
-
 enum kovaplus_mouse_report_numbers {
 	KOVAPLUS_MOUSE_REPORT_NUMBER_MOUSE = 1,
 	KOVAPLUS_MOUSE_REPORT_NUMBER_AUDIO = 2,
diff --git a/drivers/hid/hid-roccat-pyra.c b/drivers/hid/hid-roccat-pyra.c
index 38280c0..75a092e 100644
--- a/drivers/hid/hid-roccat-pyra.c
+++ b/drivers/hid/hid-roccat-pyra.c
@@ -53,7 +53,7 @@ static int pyra_send_control(struct usb_device *usb_dev, int value,
 	control.value = value;
 	control.request = request;
 
-	return roccat_common_send(usb_dev, PYRA_USB_COMMAND_CONTROL,
+	return roccat_common_send(usb_dev, PYRA_COMMAND_CONTROL,
 			&control, sizeof(struct pyra_control));
 }
 
@@ -64,7 +64,7 @@ static int pyra_receive_control_status(struct usb_device *usb_dev)
 
 	do {
 		msleep(10);
-		retval = roccat_common_receive(usb_dev, PYRA_USB_COMMAND_CONTROL,
+		retval = roccat_common_receive(usb_dev, PYRA_COMMAND_CONTROL,
 				&control, sizeof(struct pyra_control));
 
 		/* requested too early, try again */
@@ -89,7 +89,7 @@ static int pyra_get_profile_settings(struct usb_device *usb_dev,
 			PYRA_CONTROL_REQUEST_PROFILE_SETTINGS);
 	if (retval)
 		return retval;
-	return roccat_common_receive(usb_dev, PYRA_USB_COMMAND_PROFILE_SETTINGS,
+	return roccat_common_receive(usb_dev, PYRA_COMMAND_PROFILE_SETTINGS,
 			buf, sizeof(struct pyra_profile_settings));
 }
 
@@ -101,20 +101,20 @@ static int pyra_get_profile_buttons(struct usb_device *usb_dev,
 			PYRA_CONTROL_REQUEST_PROFILE_BUTTONS);
 	if (retval)
 		return retval;
-	return roccat_common_receive(usb_dev, PYRA_USB_COMMAND_PROFILE_BUTTONS,
+	return roccat_common_receive(usb_dev, PYRA_COMMAND_PROFILE_BUTTONS,
 			buf, sizeof(struct pyra_profile_buttons));
 }
 
 static int pyra_get_settings(struct usb_device *usb_dev,
 		struct pyra_settings *buf)
 {
-	return roccat_common_receive(usb_dev, PYRA_USB_COMMAND_SETTINGS,
+	return roccat_common_receive(usb_dev, PYRA_COMMAND_SETTINGS,
 			buf, sizeof(struct pyra_settings));
 }
 
 static int pyra_get_info(struct usb_device *usb_dev, struct pyra_info *buf)
 {
-	return roccat_common_receive(usb_dev, PYRA_USB_COMMAND_INFO,
+	return roccat_common_receive(usb_dev, PYRA_COMMAND_INFO,
 			buf, sizeof(struct pyra_info));
 }
 
@@ -131,26 +131,22 @@ static int pyra_send(struct usb_device *usb_dev, uint command,
 static int pyra_set_profile_settings(struct usb_device *usb_dev,
 		struct pyra_profile_settings const *settings)
 {
-	return pyra_send(usb_dev, PYRA_USB_COMMAND_PROFILE_SETTINGS, settings,
+	return pyra_send(usb_dev, PYRA_COMMAND_PROFILE_SETTINGS, settings,
 			sizeof(struct pyra_profile_settings));
 }
 
 static int pyra_set_profile_buttons(struct usb_device *usb_dev,
 		struct pyra_profile_buttons const *buttons)
 {
-	return pyra_send(usb_dev, PYRA_USB_COMMAND_PROFILE_BUTTONS, buttons,
+	return pyra_send(usb_dev, PYRA_COMMAND_PROFILE_BUTTONS, buttons,
 			sizeof(struct pyra_profile_buttons));
 }
 
 static int pyra_set_settings(struct usb_device *usb_dev,
 		struct pyra_settings const *settings)
 {
-	int retval;
-	retval = roccat_common_send(usb_dev, PYRA_USB_COMMAND_SETTINGS, settings,
+	return pyra_send(usb_dev, PYRA_COMMAND_SETTINGS, settings,
 			sizeof(struct pyra_settings));
-	if (retval)
-		return retval;
-	return pyra_receive_control_status(usb_dev);
 }
 
 static ssize_t pyra_sysfs_read_profilex_settings(struct file *fp,
diff --git a/drivers/hid/hid-roccat-pyra.h b/drivers/hid/hid-roccat-pyra.h
index 14cbbe1..0442d7f 100644
--- a/drivers/hid/hid-roccat-pyra.h
+++ b/drivers/hid/hid-roccat-pyra.h
@@ -83,15 +83,6 @@ enum pyra_commands {
 	PYRA_COMMAND_B = 0xb
 };
 
-enum pyra_usb_commands {
-	PYRA_USB_COMMAND_CONTROL = 0x304,
-	PYRA_USB_COMMAND_SETTINGS = 0x305,
-	PYRA_USB_COMMAND_PROFILE_SETTINGS = 0x306,
-	PYRA_USB_COMMAND_PROFILE_BUTTONS = 0x307,
-	PYRA_USB_COMMAND_INFO = 0x309,
-	PYRA_USB_COMMAND_B = 0x30b /* writes 3 bytes */
-};
-
 enum pyra_mouse_report_numbers {
 	PYRA_MOUSE_REPORT_NUMBER_HID = 1,
 	PYRA_MOUSE_REPORT_NUMBER_AUDIO = 2,
-- 
1.7.3.4



