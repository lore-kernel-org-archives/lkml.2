Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268Ab0KOUdC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 15:33:02 -0500
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:43589 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758244Ab0KOUc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 15:32:59 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-02.arcor-online.net 7D79830590
Subject: [PATCH 3/3] HID: roccat: using new sysfs_create_bin_group() in
 pyra driver
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 21:32:56 +0100
Message-ID: <1289853176.2188.48.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hid-roccat-pyra now uses new group functions for creating binary
sysfs attributes.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-pyra.c |  122 ++++++++---------------------------------
 1 files changed, 23 insertions(+), 99 deletions(-)

diff --git a/drivers/hid/hid-roccat-pyra.c b/drivers/hid/hid-roccat-pyra.c
index 0dad5c6..f19b8e7 100644
--- a/drivers/hid/hid-roccat-pyra.c
+++ b/drivers/hid/hid-roccat-pyra.c
@@ -527,6 +527,27 @@ static struct bin_attribute pyra_settings_attr = {
 		.write = pyra_sysfs_write_settings
 };
 
+static struct attribute *pyra_bin_attributes[] = {
+	&pyra_profile_settings_attr.attr,
+	&pyra_profile1_settings_attr.attr,
+	&pyra_profile2_settings_attr.attr,
+	&pyra_profile3_settings_attr.attr,
+	&pyra_profile4_settings_attr.attr,
+	&pyra_profile5_settings_attr.attr,
+	&pyra_profile_buttons_attr.attr,
+	&pyra_profile1_buttons_attr.attr,
+	&pyra_profile2_buttons_attr.attr,
+	&pyra_profile3_buttons_attr.attr,
+	&pyra_profile4_buttons_attr.attr,
+	&pyra_profile5_buttons_attr.attr,
+	&pyra_settings_attr.attr,
+	NULL
+};
+
+static struct attribute_group pyra_bin_attribute_group = {
+	.attrs = pyra_bin_attributes
+};
+
 static int pyra_create_sysfs_attributes(struct usb_interface *intf)
 {
 	int retval;
@@ -535,97 +556,12 @@ static int pyra_create_sysfs_attributes(struct usb_interface *intf)
 	if (retval)
 		goto exit_1;
 
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&pyra_profile_settings_attr);
+	retval = sysfs_create_bin_group(&intf->dev.kobj, &pyra_bin_attribute_group);
 	if (retval)
 		goto exit_2;
 
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&pyra_profile1_settings_attr);
-	if (retval)
-		goto exit_3;
-
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&pyra_profile2_settings_attr);
-	if (retval)
-		goto exit_4;
-
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&pyra_profile3_settings_attr);
-	if (retval)
-		goto exit_5;
-
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&pyra_profile4_settings_attr);
-	if (retval)
-		goto exit_6;
-
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&pyra_profile5_settings_attr);
-	if (retval)
-		goto exit_7;
-
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&pyra_profile_buttons_attr);
-	if (retval)
-		goto exit_8;
-
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&pyra_profile1_buttons_attr);
-	if (retval)
-		goto exit_9;
-
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&pyra_profile2_buttons_attr);
-	if (retval)
-		goto exit_10;
-
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&pyra_profile3_buttons_attr);
-	if (retval)
-		goto exit_11;
-
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&pyra_profile4_buttons_attr);
-	if (retval)
-		goto exit_12;
-
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&pyra_profile5_buttons_attr);
-	if (retval)
-		goto exit_13;
-
-	retval = sysfs_create_bin_file(&intf->dev.kobj,
-			&pyra_settings_attr);
-	if (retval)
-		goto exit_14;
-
 	return 0;
 
-exit_14:
-	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile5_buttons_attr);
-exit_13:
-	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile4_buttons_attr);
-exit_12:
-	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile3_buttons_attr);
-exit_11:
-	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile2_buttons_attr);
-exit_10:
-	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile1_buttons_attr);
-exit_9:
-	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile_buttons_attr);
-exit_8:
-	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile5_settings_attr);
-exit_7:
-	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile4_settings_attr);
-exit_6:
-	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile3_settings_attr);
-exit_5:
-	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile2_settings_attr);
-exit_4:
-	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile1_settings_attr);
-exit_3:
-	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile_settings_attr);
 exit_2:
 	sysfs_remove_group(&intf->dev.kobj, &pyra_attribute_group);
 exit_1:
@@ -634,19 +570,7 @@ exit_1:
 
 static void pyra_remove_sysfs_attributes(struct usb_interface *intf)
 {
-	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_settings_attr);
-	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile5_buttons_attr);
-	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile4_buttons_attr);
-	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile3_buttons_attr);
-	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile2_buttons_attr);
-	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile1_buttons_attr);
-	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile_buttons_attr);
-	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile5_settings_attr);
-	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile4_settings_attr);
-	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile3_settings_attr);
-	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile2_settings_attr);
-	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile1_settings_attr);
-	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile_settings_attr);
+	sysfs_remove_bin_group(&intf->dev.kobj, &pyra_bin_attribute_group);
 	sysfs_remove_group(&intf->dev.kobj, &pyra_attribute_group);
 }
 
-- 
1.7.2.3



