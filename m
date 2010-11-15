Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254Ab0KOUc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 15:32:56 -0500
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:40651 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758244Ab0KOUcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 15:32:55 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-02.arcor-online.net A24243049D
Subject: [PATCH 2/3] HID: roccat: using new sysfs_create_bin_group() in
 koneplus driver
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 21:32:52 +0100
Message-ID: <1289853172.2188.46.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hid-roccat-koneplus now uses new group functions for creating binary
sysfs attributes.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-koneplus.c |  148 +++++++------------------------------
 1 files changed, 26 insertions(+), 122 deletions(-)

diff --git a/drivers/hid/hid-roccat-koneplus.c b/drivers/hid/hid-roccat-koneplus.c
index 7327e1a..0953777 100644
--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -612,6 +612,30 @@ static struct bin_attribute koneplus_macro_attr = {
 		.write = koneplus_sysfs_write_macro
 };
 
+static struct attribute *koneplus_bin_attributes[] = {
+	&koneplus_sensor_attr.attr,
+	&koneplus_tcu_attr.attr,
+	&koneplus_tcu_image_attr.attr,
+	&koneplus_profile_settings_attr.attr,
+	&koneplus_profile1_settings_attr.attr,
+	&koneplus_profile2_settings_attr.attr,
+	&koneplus_profile3_settings_attr.attr,
+	&koneplus_profile4_settings_attr.attr,
+	&koneplus_profile5_settings_attr.attr,
+	&koneplus_profile_buttons_attr.attr,
+	&koneplus_profile1_buttons_attr.attr,
+	&koneplus_profile2_buttons_attr.attr,
+	&koneplus_profile3_buttons_attr.attr,
+	&koneplus_profile4_buttons_attr.attr,
+	&koneplus_profile5_buttons_attr.attr,
+	&koneplus_macro_attr.attr,
+	NULL
+};
+
+static struct attribute_group koneplus_bin_attribute_group = {
+	.attrs = koneplus_bin_attributes
+};
+
 static int koneplus_create_sysfs_attributes(struct usb_interface *intf)
 {
 	int retval;
@@ -620,118 +644,13 @@ static int koneplus_create_sysfs_attributes(struct usb_interface *intf)
 	if (retval)
 		goto exit_1;
 
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&koneplus_profile_settings_attr);
+	retval = sysfs_create_bin_group(&intf->dev.kobj, &koneplus_bin_attribute_group);
 	if (retval)
 		goto exit_2;
 
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&koneplus_profile1_settings_attr);
-	if (retval)
-		goto exit_3;
-
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&koneplus_profile2_settings_attr);
-	if (retval)
-		goto exit_4;
-
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&koneplus_profile3_settings_attr);
-	if (retval)
-		goto exit_5;
-
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&koneplus_profile4_settings_attr);
-	if (retval)
-		goto exit_6;
-
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&koneplus_profile5_settings_attr);
-	if (retval)
-		goto exit_7;
-
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&koneplus_profile_buttons_attr);
-	if (retval)
-		goto exit_8;
-
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&koneplus_profile1_buttons_attr);
-	if (retval)
-		goto exit_9;
-
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&koneplus_profile2_buttons_attr);
-	if (retval)
-		goto exit_10;
-
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&koneplus_profile3_buttons_attr);
-	if (retval)
-		goto exit_11;
-
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&koneplus_profile4_buttons_attr);
-	if (retval)
-		goto exit_12;
-
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&koneplus_profile5_buttons_attr);
-	if (retval)
-		goto exit_13;
-
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&koneplus_macro_attr);
-	if (retval)
-		goto exit_14;
-
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&koneplus_tcu_image_attr);
-	if (retval)
-		goto exit_15;
-
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&koneplus_tcu_attr);
-	if (retval)
-		goto exit_16;
-
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&koneplus_sensor_attr);
-	if (retval)
-		goto exit_17;
 
 	return 0;
 
-exit_17:
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_tcu_attr);
-exit_16:
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_tcu_image_attr);
-exit_15:
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_macro_attr);
-exit_14:
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile5_buttons_attr);
-exit_13:
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile4_buttons_attr);
-exit_12:
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile3_buttons_attr);
-exit_11:
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile2_buttons_attr);
-exit_10:
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile1_buttons_attr);
-exit_9:
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile_buttons_attr);
-exit_8:
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile5_settings_attr);
-exit_7:
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile4_settings_attr);
-exit_6:
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile3_settings_attr);
-exit_5:
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile2_settings_attr);
-exit_4:
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile1_settings_attr);
-exit_3:
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile_settings_attr);
 exit_2:
 	sysfs_remove_group(&intf->dev.kobj, &koneplus_attribute_group);
 exit_1:
@@ -740,22 +659,7 @@ exit_1:
 
 static void koneplus_remove_sysfs_attributes(struct usb_interface *intf)
 {
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_sensor_attr);
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_tcu_attr);
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_tcu_image_attr);
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_macro_attr);
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile5_buttons_attr);
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile4_buttons_attr);
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile3_buttons_attr);
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile2_buttons_attr);
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile1_buttons_attr);
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile_buttons_attr);
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile5_settings_attr);
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile4_settings_attr);
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile3_settings_attr);
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile2_settings_attr);
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile1_settings_attr);
-	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile_settings_attr);
+	sysfs_remove_bin_group(&intf->dev.kobj, &koneplus_bin_attribute_group);
 	sysfs_remove_group(&intf->dev.kobj, &koneplus_attribute_group);
 }
 
-- 
1.7.2.3



