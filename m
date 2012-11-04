Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab2KDIjG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 03:39:06 -0500
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:59696 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751065Ab2KDIjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 03:39:00 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-16.arcor-online.net 2FF588576
Subject: [PATCH 2/4] HID: roccat: Enabling Savu device reset
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 04 Nov 2012 09:38:58 +0100
Message-ID: <1352018338.2673.132.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device can be reset to factory state by sending a command via info sysfs attr.
Changed from ro to rw to enable this feature.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 .../ABI/testing/sysfs-driver-hid-roccat-savu       |    3 +--
 drivers/hid/hid-roccat-savu.c                      |    4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-savu b/Documentation/ABI/testing/sysfs-driver-hid-roccat-savu
index b42922c..f1e02a9 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-savu
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-savu
@@ -40,8 +40,8 @@ What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-
 Date:		Mai 2012
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	When read, this file returns general data like firmware version.
+		When written, the device can be reset.
 		The data is 8 bytes long.
-		This file is readonly.
 Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/savu/roccatsavu<minor>/macro
@@ -74,4 +74,3 @@ Description:	The mouse has a Avago ADNS-3090 sensor.
 		This file allows reading and writing of the mouse sensors registers.
 		The data has to be 4 bytes long.
 Users:		http://roccat.sourceforge.net
-
diff --git a/drivers/hid/hid-roccat-savu.c b/drivers/hid/hid-roccat-savu.c
index 014afba..31747a2 100644
--- a/drivers/hid/hid-roccat-savu.c
+++ b/drivers/hid/hid-roccat-savu.c
@@ -120,7 +120,7 @@ SAVU_SYSFS_RW(profile, PROFILE)
 SAVU_SYSFS_RW(general, GENERAL)
 SAVU_SYSFS_RW(buttons, BUTTONS)
 SAVU_SYSFS_RW(macro, MACRO)
-SAVU_SYSFS_R(info, INFO)
+SAVU_SYSFS_RW(info, INFO)
 SAVU_SYSFS_RW(sensor, SENSOR)
 
 static struct bin_attribute savu_bin_attributes[] = {
@@ -129,7 +129,7 @@ static struct bin_attribute savu_bin_attributes[] = {
 	SAVU_BIN_ATTRIBUTE_RW(general, GENERAL),
 	SAVU_BIN_ATTRIBUTE_RW(buttons, BUTTONS),
 	SAVU_BIN_ATTRIBUTE_RW(macro, MACRO),
-	SAVU_BIN_ATTRIBUTE_R(info, INFO),
+	SAVU_BIN_ATTRIBUTE_RW(info, INFO),
 	SAVU_BIN_ATTRIBUTE_RW(sensor, SENSOR),
 	__ATTR_NULL
 };
-- 
1.7.3.4



