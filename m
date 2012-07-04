Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab2GDQpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 12:45:08 -0400
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:56022 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754401Ab2GDQpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 12:45:05 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-17.arcor-online.net 9C12ACBD7C
Subject: [PATCH] HID: roccat: Added sensor bin-sysfs-attr for Savu
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jul 2012 18:45:03 +0200
Message-ID: <1341420303.3266.22.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sensor attr can be used to tweak the optical sensor of the Savu.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 .../ABI/testing/sysfs-driver-hid-roccat-savu       |    9 +++++++++
 drivers/hid/hid-roccat-savu.c                      |    2 ++
 drivers/hid/hid-roccat-savu.h                      |    2 ++
 3 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-savu b/Documentation/ABI/testing/sysfs-driver-hid-roccat-savu
index e233490..b42922c 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-savu
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-savu
@@ -66,3 +66,12 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		The data has to be 3 bytes long.
 		The mouse will reject invalid data.
 Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/savu/roccatsavu<minor>/sensor
+Date:		July 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse has a Avago ADNS-3090 sensor.
+		This file allows reading and writing of the mouse sensors registers.
+		The data has to be 4 bytes long.
+Users:		http://roccat.sourceforge.net
+
diff --git a/drivers/hid/hid-roccat-savu.c b/drivers/hid/hid-roccat-savu.c
index 29e87d7..014afba 100644
--- a/drivers/hid/hid-roccat-savu.c
+++ b/drivers/hid/hid-roccat-savu.c
@@ -121,6 +121,7 @@ SAVU_SYSFS_RW(general, GENERAL)
 SAVU_SYSFS_RW(buttons, BUTTONS)
 SAVU_SYSFS_RW(macro, MACRO)
 SAVU_SYSFS_R(info, INFO)
+SAVU_SYSFS_RW(sensor, SENSOR)
 
 static struct bin_attribute savu_bin_attributes[] = {
 	SAVU_BIN_ATTRIBUTE_W(control, CONTROL),
@@ -129,6 +130,7 @@ static struct bin_attribute savu_bin_attributes[] = {
 	SAVU_BIN_ATTRIBUTE_RW(buttons, BUTTONS),
 	SAVU_BIN_ATTRIBUTE_RW(macro, MACRO),
 	SAVU_BIN_ATTRIBUTE_R(info, INFO),
+	SAVU_BIN_ATTRIBUTE_RW(sensor, SENSOR),
 	__ATTR_NULL
 };
 
diff --git a/drivers/hid/hid-roccat-savu.h b/drivers/hid/hid-roccat-savu.h
index b15a1bb..9120ba7 100644
--- a/drivers/hid/hid-roccat-savu.h
+++ b/drivers/hid/hid-roccat-savu.h
@@ -21,6 +21,7 @@ enum {
 	SAVU_SIZE_BUTTONS = 0x2f,
 	SAVU_SIZE_MACRO = 0x0823,
 	SAVU_SIZE_INFO = 0x08,
+	SAVU_SIZE_SENSOR = 0x04,
 };
 
 enum savu_control_requests {
@@ -35,6 +36,7 @@ enum savu_commands {
 	SAVU_COMMAND_BUTTONS = 0x7,
 	SAVU_COMMAND_MACRO = 0x8,
 	SAVU_COMMAND_INFO = 0x9,
+	SAVU_COMMAND_SENSOR = 0xc,
 };
 
 struct savu_mouse_report_special {
-- 
1.7.3.4



