Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab2ETUpk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 16:45:40 -0400
Received: from mail-in-15.arcor-online.net ([151.189.21.55]:55509 "EHLO
	mail-in-15.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753562Ab2ETUpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 16:45:07 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-04.arcor-online.net 01413AA41E
Subject: [PATCH 3/4] HID: roccat: Renamed roccat_common functions to
 roccat_common2
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        linux-doc@vger.kernel.orglinux-doc, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 May 2012 22:45:04 +0200
Message-ID: <1337546704.19878.32.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Did this to illustrate my understanding of the firmware generations:
Valo and Kone were 1st generation
Arvo was externaly developed and lies in the middle
All others until now are considered 2nd generation

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-arvo.c     |   16 ++++++++--------
 drivers/hid/hid-roccat-common.c   |   34 +++++++++++++++++-----------------
 drivers/hid/hid-roccat-common.h   |   10 +++++-----
 drivers/hid/hid-roccat-isku.c     |    6 +++---
 drivers/hid/hid-roccat-koneplus.c |   24 ++++++++++++------------
 drivers/hid/hid-roccat-kovaplus.c |   20 ++++++++++----------
 drivers/hid/hid-roccat-pyra.c     |   20 ++++++++++----------
 drivers/hid/hid-roccat-savu.c     |    4 ++--
 8 files changed, 67 insertions(+), 67 deletions(-)

diff --git a/drivers/hid/hid-roccat-arvo.c b/drivers/hid/hid-roccat-arvo.c
index 093bfad..327f9b8 100644
--- a/drivers/hid/hid-roccat-arvo.c
+++ b/drivers/hid/hid-roccat-arvo.c
@@ -39,7 +39,7 @@ static ssize_t arvo_sysfs_show_mode_key(struct device *dev,
 	int retval;
 
 	mutex_lock(&arvo->arvo_lock);
-	retval = roccat_common_receive(usb_dev, ARVO_COMMAND_MODE_KEY,
+	retval = roccat_common2_receive(usb_dev, ARVO_COMMAND_MODE_KEY,
 			&temp_buf, sizeof(struct arvo_mode_key));
 	mutex_unlock(&arvo->arvo_lock);
 	if (retval)
@@ -67,7 +67,7 @@ static ssize_t arvo_sysfs_set_mode_key(struct device *dev,
 	temp_buf.state = state;
 
 	mutex_lock(&arvo->arvo_lock);
-	retval = roccat_common_send(usb_dev, ARVO_COMMAND_MODE_KEY,
+	retval = roccat_common2_send(usb_dev, ARVO_COMMAND_MODE_KEY,
 			&temp_buf, sizeof(struct arvo_mode_key));
 	mutex_unlock(&arvo->arvo_lock);
 	if (retval)
@@ -87,7 +87,7 @@ static ssize_t arvo_sysfs_show_key_mask(struct device *dev,
 	int retval;
 
 	mutex_lock(&arvo->arvo_lock);
-	retval = roccat_common_receive(usb_dev, ARVO_COMMAND_KEY_MASK,
+	retval = roccat_common2_receive(usb_dev, ARVO_COMMAND_KEY_MASK,
 			&temp_buf, sizeof(struct arvo_key_mask));
 	mutex_unlock(&arvo->arvo_lock);
 	if (retval)
@@ -115,7 +115,7 @@ static ssize_t arvo_sysfs_set_key_mask(struct device *dev,
 	temp_buf.key_mask = key_mask;
 
 	mutex_lock(&arvo->arvo_lock);
-	retval = roccat_common_send(usb_dev, ARVO_COMMAND_KEY_MASK,
+	retval = roccat_common2_send(usb_dev, ARVO_COMMAND_KEY_MASK,
 			&temp_buf, sizeof(struct arvo_key_mask));
 	mutex_unlock(&arvo->arvo_lock);
 	if (retval)
@@ -130,7 +130,7 @@ static int arvo_get_actual_profile(struct usb_device *usb_dev)
 	struct arvo_actual_profile temp_buf;
 	int retval;
 
-	retval = roccat_common_receive(usb_dev, ARVO_COMMAND_ACTUAL_PROFILE,
+	retval = roccat_common2_receive(usb_dev, ARVO_COMMAND_ACTUAL_PROFILE,
 			&temp_buf, sizeof(struct arvo_actual_profile));
 
 	if (retval)
@@ -170,7 +170,7 @@ static ssize_t arvo_sysfs_set_actual_profile(struct device *dev,
 	temp_buf.actual_profile = profile;
 
 	mutex_lock(&arvo->arvo_lock);
-	retval = roccat_common_send(usb_dev, ARVO_COMMAND_ACTUAL_PROFILE,
+	retval = roccat_common2_send(usb_dev, ARVO_COMMAND_ACTUAL_PROFILE,
 			&temp_buf, sizeof(struct arvo_actual_profile));
 	if (!retval) {
 		arvo->actual_profile = profile;
@@ -194,7 +194,7 @@ static ssize_t arvo_sysfs_write(struct file *fp,
 		return -EINVAL;
 
 	mutex_lock(&arvo->arvo_lock);
-	retval = roccat_common_send(usb_dev, command, buf, real_size);
+	retval = roccat_common2_send(usb_dev, command, buf, real_size);
 	mutex_unlock(&arvo->arvo_lock);
 
 	return (retval ? retval : real_size);
@@ -217,7 +217,7 @@ static ssize_t arvo_sysfs_read(struct file *fp,
 		return -EINVAL;
 
 	mutex_lock(&arvo->arvo_lock);
-	retval = roccat_common_receive(usb_dev, command, buf, real_size);
+	retval = roccat_common2_receive(usb_dev, command, buf, real_size);
 	mutex_unlock(&arvo->arvo_lock);
 
 	return (retval ? retval : real_size);
diff --git a/drivers/hid/hid-roccat-common.c b/drivers/hid/hid-roccat-common.c
index 291414e..74f7040 100644
--- a/drivers/hid/hid-roccat-common.c
+++ b/drivers/hid/hid-roccat-common.c
@@ -16,12 +16,12 @@
 #include <linux/module.h>
 #include "hid-roccat-common.h"
 
-static inline uint16_t roccat_common_feature_report(uint8_t report_id)
+static inline uint16_t roccat_common2_feature_report(uint8_t report_id)
 {
 	return 0x300 | report_id;
 }
 
-int roccat_common_receive(struct usb_device *usb_dev, uint report_id,
+int roccat_common2_receive(struct usb_device *usb_dev, uint report_id,
 		void *data, uint size)
 {
 	char *buf;
@@ -34,16 +34,16 @@ int roccat_common_receive(struct usb_device *usb_dev, uint report_id,
 	len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
 			HID_REQ_GET_REPORT,
 			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
-			roccat_common_feature_report(report_id),
+			roccat_common2_feature_report(report_id),
 			0, buf, size, USB_CTRL_SET_TIMEOUT);
 
 	memcpy(data, buf, size);
 	kfree(buf);
 	return ((len < 0) ? len : ((len != size) ? -EIO : 0));
 }
-EXPORT_SYMBOL_GPL(roccat_common_receive);
+EXPORT_SYMBOL_GPL(roccat_common2_receive);
 
-int roccat_common_send(struct usb_device *usb_dev, uint report_id,
+int roccat_common2_send(struct usb_device *usb_dev, uint report_id,
 		void const *data, uint size)
 {
 	char *buf;
@@ -56,31 +56,31 @@ int roccat_common_send(struct usb_device *usb_dev, uint report_id,
 	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
 			HID_REQ_SET_REPORT,
 			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
-			roccat_common_feature_report(report_id),
+			roccat_common2_feature_report(report_id),
 			0, buf, size, USB_CTRL_SET_TIMEOUT);
 
 	kfree(buf);
 	return ((len < 0) ? len : ((len != size) ? -EIO : 0));
 }
-EXPORT_SYMBOL_GPL(roccat_common_send);
+EXPORT_SYMBOL_GPL(roccat_common2_send);
 
-enum roccat_common_control_states {
+enum roccat_common2_control_states {
 	ROCCAT_COMMON_CONTROL_STATUS_OVERLOAD = 0,
 	ROCCAT_COMMON_CONTROL_STATUS_OK = 1,
 	ROCCAT_COMMON_CONTROL_STATUS_INVALID = 2,
 	ROCCAT_COMMON_CONTROL_STATUS_WAIT = 3,
 };
 
-static int roccat_common_receive_control_status(struct usb_device *usb_dev)
+static int roccat_common2_receive_control_status(struct usb_device *usb_dev)
 {
 	int retval;
-	struct roccat_common_control control;
+	struct roccat_common2_control control;
 
 	do {
 		msleep(50);
-		retval = roccat_common_receive(usb_dev,
+		retval = roccat_common2_receive(usb_dev,
 				ROCCAT_COMMON_COMMAND_CONTROL,
-				&control, sizeof(struct roccat_common_control));
+				&control, sizeof(struct roccat_common2_control));
 
 		if (retval)
 			return retval;
@@ -98,7 +98,7 @@ static int roccat_common_receive_control_status(struct usb_device *usb_dev)
 			return -EINVAL;
 		default:
 			dev_err(&usb_dev->dev,
-					"roccat_common_receive_control_status: "
+					"roccat_common2_receive_control_status: "
 					"unknown response value 0x%x\n",
 					control.value);
 			return -EINVAL;
@@ -107,20 +107,20 @@ static int roccat_common_receive_control_status(struct usb_device *usb_dev)
 	} while (1);
 }
 
-int roccat_common_send_with_status(struct usb_device *usb_dev,
+int roccat_common2_send_with_status(struct usb_device *usb_dev,
 		uint command, void const *buf, uint size)
 {
 	int retval;
 
-	retval = roccat_common_send(usb_dev, command, buf, size);
+	retval = roccat_common2_send(usb_dev, command, buf, size);
 	if (retval)
 		return retval;
 
 	msleep(100);
 
-	return roccat_common_receive_control_status(usb_dev);
+	return roccat_common2_receive_control_status(usb_dev);
 }
-EXPORT_SYMBOL_GPL(roccat_common_send_with_status);
+EXPORT_SYMBOL_GPL(roccat_common2_send_with_status);
 
 MODULE_AUTHOR("Stefan Achatz");
 MODULE_DESCRIPTION("USB Roccat common driver");
diff --git a/drivers/hid/hid-roccat-common.h b/drivers/hid/hid-roccat-common.h
index 86bce05..a97746a 100644
--- a/drivers/hid/hid-roccat-common.h
+++ b/drivers/hid/hid-roccat-common.h
@@ -15,21 +15,21 @@
 #include <linux/usb.h>
 #include <linux/types.h>
 
-enum roccat_common_commands {
+enum roccat_common2_commands {
 	ROCCAT_COMMON_COMMAND_CONTROL = 0x4,
 };
 
-struct roccat_common_control {
+struct roccat_common2_control {
 	uint8_t command;
 	uint8_t value;
 	uint8_t request; /* always 0 on requesting write check */
 } __packed;
 
-int roccat_common_receive(struct usb_device *usb_dev, uint report_id,
+int roccat_common2_receive(struct usb_device *usb_dev, uint report_id,
 		void *data, uint size);
-int roccat_common_send(struct usb_device *usb_dev, uint report_id,
+int roccat_common2_send(struct usb_device *usb_dev, uint report_id,
 		void const *data, uint size);
-int roccat_common_send_with_status(struct usb_device *usb_dev,
+int roccat_common2_send_with_status(struct usb_device *usb_dev,
 		uint command, void const *buf, uint size);
 
 #endif
diff --git a/drivers/hid/hid-roccat-isku.c b/drivers/hid/hid-roccat-isku.c
index 20e7f84..5669916 100644
--- a/drivers/hid/hid-roccat-isku.c
+++ b/drivers/hid/hid-roccat-isku.c
@@ -36,7 +36,7 @@ static void isku_profile_activated(struct isku_device *isku, uint new_profile)
 static int isku_receive(struct usb_device *usb_dev, uint command,
 		void *buf, uint size)
 {
-	return roccat_common_receive(usb_dev, command, buf, size);
+	return roccat_common2_receive(usb_dev, command, buf, size);
 }
 
 static int isku_get_actual_profile(struct usb_device *usb_dev)
@@ -56,7 +56,7 @@ static int isku_set_actual_profile(struct usb_device *usb_dev, int new_profile)
 	buf.command = ISKU_COMMAND_ACTUAL_PROFILE;
 	buf.size = sizeof(struct isku_actual_profile);
 	buf.actual_profile = new_profile;
-	return roccat_common_send_with_status(usb_dev,
+	return roccat_common2_send_with_status(usb_dev,
 			ISKU_COMMAND_ACTUAL_PROFILE, &buf,
 			sizeof(struct isku_actual_profile));
 }
@@ -154,7 +154,7 @@ static ssize_t isku_sysfs_write(struct file *fp, struct kobject *kobj,
 		return -EINVAL;
 
 	mutex_lock(&isku->isku_lock);
-	retval = roccat_common_send_with_status(usb_dev, command,
+	retval = roccat_common2_send_with_status(usb_dev, command,
 			(void *)buf, real_size);
 	mutex_unlock(&isku->isku_lock);
 
diff --git a/drivers/hid/hid-roccat-koneplus.c b/drivers/hid/hid-roccat-koneplus.c
index 01167a8..f5602fe 100644
--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -39,7 +39,7 @@ static void koneplus_profile_activated(struct koneplus_device *koneplus,
 static int koneplus_send_control(struct usb_device *usb_dev, uint value,
 		enum koneplus_control_requests request)
 {
-	struct roccat_common_control control;
+	struct roccat_common2_control control;
 
 	if ((request == KONEPLUS_CONTROL_REQUEST_PROFILE_SETTINGS ||
 			request == KONEPLUS_CONTROL_REQUEST_PROFILE_BUTTONS) &&
@@ -50,15 +50,15 @@ static int koneplus_send_control(struct usb_device *usb_dev, uint value,
 	control.value = value;
 	control.request = request;
 
-	return roccat_common_send_with_status(usb_dev,
+	return roccat_common2_send_with_status(usb_dev,
 			ROCCAT_COMMON_COMMAND_CONTROL,
-			&control, sizeof(struct roccat_common_control));
+			&control, sizeof(struct roccat_common2_control));
 }
 
 static int koneplus_get_info(struct usb_device *usb_dev,
 		struct koneplus_info *buf)
 {
-	return roccat_common_receive(usb_dev, KONEPLUS_COMMAND_INFO,
+	return roccat_common2_receive(usb_dev, KONEPLUS_COMMAND_INFO,
 			buf, sizeof(struct koneplus_info));
 }
 
@@ -72,14 +72,14 @@ static int koneplus_get_profile_settings(struct usb_device *usb_dev,
 	if (retval)
 		return retval;
 
-	return roccat_common_receive(usb_dev, KONEPLUS_COMMAND_PROFILE_SETTINGS,
+	return roccat_common2_receive(usb_dev, KONEPLUS_COMMAND_PROFILE_SETTINGS,
 			buf, sizeof(struct koneplus_profile_settings));
 }
 
 static int koneplus_set_profile_settings(struct usb_device *usb_dev,
 		struct koneplus_profile_settings const *settings)
 {
-	return roccat_common_send_with_status(usb_dev,
+	return roccat_common2_send_with_status(usb_dev,
 			KONEPLUS_COMMAND_PROFILE_SETTINGS,
 			settings, sizeof(struct koneplus_profile_settings));
 }
@@ -94,14 +94,14 @@ static int koneplus_get_profile_buttons(struct usb_device *usb_dev,
 	if (retval)
 		return retval;
 
-	return roccat_common_receive(usb_dev, KONEPLUS_COMMAND_PROFILE_BUTTONS,
+	return roccat_common2_receive(usb_dev, KONEPLUS_COMMAND_PROFILE_BUTTONS,
 			buf, sizeof(struct koneplus_profile_buttons));
 }
 
 static int koneplus_set_profile_buttons(struct usb_device *usb_dev,
 		struct koneplus_profile_buttons const *buttons)
 {
-	return roccat_common_send_with_status(usb_dev,
+	return roccat_common2_send_with_status(usb_dev,
 			KONEPLUS_COMMAND_PROFILE_BUTTONS,
 			buttons, sizeof(struct koneplus_profile_buttons));
 }
@@ -112,7 +112,7 @@ static int koneplus_get_actual_profile(struct usb_device *usb_dev)
 	struct koneplus_actual_profile buf;
 	int retval;
 
-	retval = roccat_common_receive(usb_dev, KONEPLUS_COMMAND_ACTUAL_PROFILE,
+	retval = roccat_common2_receive(usb_dev, KONEPLUS_COMMAND_ACTUAL_PROFILE,
 			&buf, sizeof(struct koneplus_actual_profile));
 
 	return retval ? retval : buf.actual_profile;
@@ -127,7 +127,7 @@ static int koneplus_set_actual_profile(struct usb_device *usb_dev,
 	buf.size = sizeof(struct koneplus_actual_profile);
 	buf.actual_profile = new_profile;
 
-	return roccat_common_send_with_status(usb_dev,
+	return roccat_common2_send_with_status(usb_dev,
 			KONEPLUS_COMMAND_ACTUAL_PROFILE,
 			&buf, sizeof(struct koneplus_actual_profile));
 }
@@ -149,7 +149,7 @@ static ssize_t koneplus_sysfs_read(struct file *fp, struct kobject *kobj,
 		return -EINVAL;
 
 	mutex_lock(&koneplus->koneplus_lock);
-	retval = roccat_common_receive(usb_dev, command, buf, real_size);
+	retval = roccat_common2_receive(usb_dev, command, buf, real_size);
 	mutex_unlock(&koneplus->koneplus_lock);
 
 	if (retval)
@@ -172,7 +172,7 @@ static ssize_t koneplus_sysfs_write(struct file *fp, struct kobject *kobj,
 		return -EINVAL;
 
 	mutex_lock(&koneplus->koneplus_lock);
-	retval = roccat_common_send_with_status(usb_dev, command,
+	retval = roccat_common2_send_with_status(usb_dev, command,
 			buf, real_size);
 	mutex_unlock(&koneplus->koneplus_lock);
 
diff --git a/drivers/hid/hid-roccat-kovaplus.c b/drivers/hid/hid-roccat-kovaplus.c
index c219cff..ca6527a 100644
--- a/drivers/hid/hid-roccat-kovaplus.c
+++ b/drivers/hid/hid-roccat-kovaplus.c
@@ -47,7 +47,7 @@ static int kovaplus_send_control(struct usb_device *usb_dev, uint value,
 		enum kovaplus_control_requests request)
 {
 	int retval;
-	struct roccat_common_control control;
+	struct roccat_common2_control control;
 
 	if ((request == KOVAPLUS_CONTROL_REQUEST_PROFILE_SETTINGS ||
 			request == KOVAPLUS_CONTROL_REQUEST_PROFILE_BUTTONS) &&
@@ -58,8 +58,8 @@ static int kovaplus_send_control(struct usb_device *usb_dev, uint value,
 	control.value = value;
 	control.request = request;
 
-	retval = roccat_common_send(usb_dev, ROCCAT_COMMON_COMMAND_CONTROL,
-			&control, sizeof(struct roccat_common_control));
+	retval = roccat_common2_send(usb_dev, ROCCAT_COMMON_COMMAND_CONTROL,
+			&control, sizeof(struct roccat_common2_control));
 
 	return retval;
 }
@@ -73,7 +73,7 @@ static int kovaplus_select_profile(struct usb_device *usb_dev, uint number,
 static int kovaplus_get_info(struct usb_device *usb_dev,
 		struct kovaplus_info *buf)
 {
-	return roccat_common_receive(usb_dev, KOVAPLUS_COMMAND_INFO,
+	return roccat_common2_receive(usb_dev, KOVAPLUS_COMMAND_INFO,
 			buf, sizeof(struct kovaplus_info));
 }
 
@@ -87,14 +87,14 @@ static int kovaplus_get_profile_settings(struct usb_device *usb_dev,
 	if (retval)
 		return retval;
 
-	return roccat_common_receive(usb_dev, KOVAPLUS_COMMAND_PROFILE_SETTINGS,
+	return roccat_common2_receive(usb_dev, KOVAPLUS_COMMAND_PROFILE_SETTINGS,
 			buf, sizeof(struct kovaplus_profile_settings));
 }
 
 static int kovaplus_set_profile_settings(struct usb_device *usb_dev,
 		struct kovaplus_profile_settings const *settings)
 {
-	return roccat_common_send_with_status(usb_dev,
+	return roccat_common2_send_with_status(usb_dev,
 			KOVAPLUS_COMMAND_PROFILE_SETTINGS,
 			settings, sizeof(struct kovaplus_profile_settings));
 }
@@ -109,14 +109,14 @@ static int kovaplus_get_profile_buttons(struct usb_device *usb_dev,
 	if (retval)
 		return retval;
 
-	return roccat_common_receive(usb_dev, KOVAPLUS_COMMAND_PROFILE_BUTTONS,
+	return roccat_common2_receive(usb_dev, KOVAPLUS_COMMAND_PROFILE_BUTTONS,
 			buf, sizeof(struct kovaplus_profile_buttons));
 }
 
 static int kovaplus_set_profile_buttons(struct usb_device *usb_dev,
 		struct kovaplus_profile_buttons const *buttons)
 {
-	return roccat_common_send_with_status(usb_dev,
+	return roccat_common2_send_with_status(usb_dev,
 			KOVAPLUS_COMMAND_PROFILE_BUTTONS,
 			buttons, sizeof(struct kovaplus_profile_buttons));
 }
@@ -127,7 +127,7 @@ static int kovaplus_get_actual_profile(struct usb_device *usb_dev)
 	struct kovaplus_actual_profile buf;
 	int retval;
 
-	retval = roccat_common_receive(usb_dev, KOVAPLUS_COMMAND_ACTUAL_PROFILE,
+	retval = roccat_common2_receive(usb_dev, KOVAPLUS_COMMAND_ACTUAL_PROFILE,
 			&buf, sizeof(struct kovaplus_actual_profile));
 
 	return retval ? retval : buf.actual_profile;
@@ -142,7 +142,7 @@ static int kovaplus_set_actual_profile(struct usb_device *usb_dev,
 	buf.size = sizeof(struct kovaplus_actual_profile);
 	buf.actual_profile = new_profile;
 
-	return roccat_common_send_with_status(usb_dev,
+	return roccat_common2_send_with_status(usb_dev,
 			KOVAPLUS_COMMAND_ACTUAL_PROFILE,
 			&buf, sizeof(struct kovaplus_actual_profile));
 }
diff --git a/drivers/hid/hid-roccat-pyra.c b/drivers/hid/hid-roccat-pyra.c
index 440cb1b..1317c17 100644
--- a/drivers/hid/hid-roccat-pyra.c
+++ b/drivers/hid/hid-roccat-pyra.c
@@ -42,7 +42,7 @@ static void profile_activated(struct pyra_device *pyra,
 static int pyra_send_control(struct usb_device *usb_dev, int value,
 		enum pyra_control_requests request)
 {
-	struct roccat_common_control control;
+	struct roccat_common2_control control;
 
 	if ((request == PYRA_CONTROL_REQUEST_PROFILE_SETTINGS ||
 			request == PYRA_CONTROL_REQUEST_PROFILE_BUTTONS) &&
@@ -53,8 +53,8 @@ static int pyra_send_control(struct usb_device *usb_dev, int value,
 	control.value = value;
 	control.request = request;
 
-	return roccat_common_send(usb_dev, ROCCAT_COMMON_COMMAND_CONTROL,
-			&control, sizeof(struct roccat_common_control));
+	return roccat_common2_send(usb_dev, ROCCAT_COMMON_COMMAND_CONTROL,
+			&control, sizeof(struct roccat_common2_control));
 }
 
 static int pyra_get_profile_settings(struct usb_device *usb_dev,
@@ -65,7 +65,7 @@ static int pyra_get_profile_settings(struct usb_device *usb_dev,
 			PYRA_CONTROL_REQUEST_PROFILE_SETTINGS);
 	if (retval)
 		return retval;
-	return roccat_common_receive(usb_dev, PYRA_COMMAND_PROFILE_SETTINGS,
+	return roccat_common2_receive(usb_dev, PYRA_COMMAND_PROFILE_SETTINGS,
 			buf, sizeof(struct pyra_profile_settings));
 }
 
@@ -77,27 +77,27 @@ static int pyra_get_profile_buttons(struct usb_device *usb_dev,
 			PYRA_CONTROL_REQUEST_PROFILE_BUTTONS);
 	if (retval)
 		return retval;
-	return roccat_common_receive(usb_dev, PYRA_COMMAND_PROFILE_BUTTONS,
+	return roccat_common2_receive(usb_dev, PYRA_COMMAND_PROFILE_BUTTONS,
 			buf, sizeof(struct pyra_profile_buttons));
 }
 
 static int pyra_get_settings(struct usb_device *usb_dev,
 		struct pyra_settings *buf)
 {
-	return roccat_common_receive(usb_dev, PYRA_COMMAND_SETTINGS,
+	return roccat_common2_receive(usb_dev, PYRA_COMMAND_SETTINGS,
 			buf, sizeof(struct pyra_settings));
 }
 
 static int pyra_get_info(struct usb_device *usb_dev, struct pyra_info *buf)
 {
-	return roccat_common_receive(usb_dev, PYRA_COMMAND_INFO,
+	return roccat_common2_receive(usb_dev, PYRA_COMMAND_INFO,
 			buf, sizeof(struct pyra_info));
 }
 
 static int pyra_set_profile_settings(struct usb_device *usb_dev,
 		struct pyra_profile_settings const *settings)
 {
-	return roccat_common_send_with_status(usb_dev,
+	return roccat_common2_send_with_status(usb_dev,
 			PYRA_COMMAND_PROFILE_SETTINGS, settings,
 			sizeof(struct pyra_profile_settings));
 }
@@ -105,7 +105,7 @@ static int pyra_set_profile_settings(struct usb_device *usb_dev,
 static int pyra_set_profile_buttons(struct usb_device *usb_dev,
 		struct pyra_profile_buttons const *buttons)
 {
-	return roccat_common_send_with_status(usb_dev,
+	return roccat_common2_send_with_status(usb_dev,
 			PYRA_COMMAND_PROFILE_BUTTONS, buttons,
 			sizeof(struct pyra_profile_buttons));
 }
@@ -113,7 +113,7 @@ static int pyra_set_profile_buttons(struct usb_device *usb_dev,
 static int pyra_set_settings(struct usb_device *usb_dev,
 		struct pyra_settings const *settings)
 {
-	return roccat_common_send_with_status(usb_dev,
+	return roccat_common2_send_with_status(usb_dev,
 			PYRA_COMMAND_SETTINGS, settings,
 			sizeof(struct pyra_settings));
 }
diff --git a/drivers/hid/hid-roccat-savu.c b/drivers/hid/hid-roccat-savu.c
index 19f9c47..29e87d7 100644
--- a/drivers/hid/hid-roccat-savu.c
+++ b/drivers/hid/hid-roccat-savu.c
@@ -44,7 +44,7 @@ static ssize_t savu_sysfs_read(struct file *fp, struct kobject *kobj,
 		return -EINVAL;
 
 	mutex_lock(&savu->savu_lock);
-	retval = roccat_common_receive(usb_dev, command, buf, real_size);
+	retval = roccat_common2_receive(usb_dev, command, buf, real_size);
 	mutex_unlock(&savu->savu_lock);
 
 	return retval ? retval : real_size;
@@ -64,7 +64,7 @@ static ssize_t savu_sysfs_write(struct file *fp, struct kobject *kobj,
 		return -EINVAL;
 
 	mutex_lock(&savu->savu_lock);
-	retval = roccat_common_send_with_status(usb_dev, command,
+	retval = roccat_common2_send_with_status(usb_dev, command,
 			(void *)buf, real_size);
 	mutex_unlock(&savu->savu_lock);
 
-- 
1.7.3.4



