Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab2KKFVZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 00:21:25 -0500
Received: from mout.web.de ([212.227.17.12]:51685 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab2KKFVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 00:21:16 -0500
Subject: [PATCH 4/7] HID: roccat: Added bin sysfs attr "reset" for Isku
From: Stefan Achatz <stefan_achatz@web.de>
To: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Nov 2012 06:21:06 +0100
Message-ID: <1352611266.2463.224.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:kRUbHw6GP6RWqissanWDrCWg4G8Qke3zmIcyGSu3a8i
 8+lIeyoMrmnSL7XtPwqHeG3xX4KdEhsB1CubkXLOWnpoBULmPo
 tdkm0EmFqX1L4nslXex77oyQXpUWqz43Y8zGEInbJhkmD1i0wQ
 Rw8+zlES6vyReo7thWPnhyXgSsqq7hmG0lnJyk0KSHFwE7WKMY
 luSlrImL1sHPVbwc98tcw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isku needs an extra sysfs attr to support device reset.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 .../ABI/testing/sysfs-driver-hid-roccat-isku       |    8 ++++++++
 drivers/hid/hid-roccat-isku.c                      |    2 ++
 drivers/hid/hid-roccat-isku.h                      |    2 ++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-isku b/Documentation/ABI/testing/sysfs-driver-hid-roccat-isku
index 189dc43..9eca5a1 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-isku
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-isku
@@ -117,6 +117,14 @@ Description:	When written, this file lets one store macros with max 500
 		which profile and key to read.
 Users:		http://roccat.sourceforge.net
 
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/reset
+Date:		November 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one reset the device.
+		The data has to be 3 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/control
 Date:		June 2011
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
diff --git a/drivers/hid/hid-roccat-isku.c b/drivers/hid/hid-roccat-isku.c
index 020d6cd..1219998 100644
--- a/drivers/hid/hid-roccat-isku.c
+++ b/drivers/hid/hid-roccat-isku.c
@@ -218,6 +218,7 @@ ISKU_SYSFS_RW(last_set, LAST_SET)
 ISKU_SYSFS_W(talk, TALK)
 ISKU_SYSFS_R(info, INFO)
 ISKU_SYSFS_W(control, CONTROL)
+ISKU_SYSFS_W(reset, RESET)
 
 static struct bin_attribute isku_bin_attributes[] = {
 	ISKU_BIN_ATTR_RW(macro, MACRO),
@@ -233,6 +234,7 @@ static struct bin_attribute isku_bin_attributes[] = {
 	ISKU_BIN_ATTR_W(talk, TALK),
 	ISKU_BIN_ATTR_R(info, INFO),
 	ISKU_BIN_ATTR_W(control, CONTROL),
+	ISKU_BIN_ATTR_W(reset, RESET),
 	__ATTR_NULL
 };
 
diff --git a/drivers/hid/hid-roccat-isku.h b/drivers/hid/hid-roccat-isku.h
index 0062ab5..cf6896c 100644
--- a/drivers/hid/hid-roccat-isku.h
+++ b/drivers/hid/hid-roccat-isku.h
@@ -27,6 +27,7 @@ enum {
 	ISKU_SIZE_LAST_SET = 0x14,
 	ISKU_SIZE_LIGHT = 0x0a,
 	ISKU_SIZE_MACRO = 0x823,
+	ISKU_SIZE_RESET = 0x03,
 	ISKU_SIZE_TALK = 0x10,
 };
 
@@ -53,6 +54,7 @@ enum isku_commands {
 	ISKU_COMMAND_MACRO = 0xe,
 	ISKU_COMMAND_INFO = 0xf,
 	ISKU_COMMAND_LIGHT = 0x10,
+	ISKU_COMMAND_RESET = 0x11,
 	ISKU_COMMAND_KEYS_CAPSLOCK = 0x13,
 	ISKU_COMMAND_LAST_SET = 0x14,
 	ISKU_COMMAND_15 = 0x15,
-- 
1.7.3.4



