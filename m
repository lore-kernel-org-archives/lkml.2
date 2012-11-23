Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab2KWPch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 10:32:37 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60142 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab2KWPcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 10:32:00 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/11] HID: hid-multitouch: fix protocol for 3 devices
Date: Fri, 23 Nov 2012 16:31:33 +0100
Message-Id: <1353684694-5723-11-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353684694-5723-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1353684694-5723-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cando 2087:0a02 was broken, this fixes it.
ActionStar and LG panels can be optimized by using the new default
class.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 5e0a4d7..b374a5a 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -997,7 +997,7 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_3M3266) },
 
 	/* ActionStar panels */
-	{ .driver_data = MT_CLS_NSMU,
+	{ .driver_data = MT_CLS_DEFAULT,
 		MT_USB_DEVICE(USB_VENDOR_ID_ACTIONSTAR,
 			USB_DEVICE_ID_ACTIONSTAR_1011) },
 
@@ -1017,7 +1017,7 @@ static const struct hid_device_id mt_devices[] = {
 	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
 		MT_USB_DEVICE(USB_VENDOR_ID_CANDO,
 			USB_DEVICE_ID_CANDO_MULTI_TOUCH) },
-	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
+	{ .driver_data = MT_CLS_DEFAULT,
 		MT_USB_DEVICE(USB_VENDOR_ID_CANDO,
 			USB_DEVICE_ID_CANDO_MULTI_TOUCH_10_1) },
 	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
@@ -1155,7 +1155,7 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_IRTOUCH_INFRARED_USB) },
 
 	/* LG Display panels */
-	{ .driver_data = MT_CLS_NSMU,
+	{ .driver_data = MT_CLS_DEFAULT,
 		MT_USB_DEVICE(USB_VENDOR_ID_LG,
 			USB_DEVICE_ID_LG_MULTITOUCH) },
 
-- 
1.8.0

