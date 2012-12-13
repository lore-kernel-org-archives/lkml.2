Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab2LMBne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 20:43:34 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42281 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155Ab2LMBnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 20:43:33 -0500
MIME-Version: 1.0
Date: Wed, 12 Dec 2012 20:43:32 -0500
Message-ID: <CAKPZWXc55MWN3ajpvf0vLXP9KebFo17bGAmD8X=mavxyWJui1w@mail.gmail.com>
Subject: [PATCH] USB: adds support for Novatek wireless mouse to usbhid
From: Benoit Touchette <draekko.dev@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, trivial@kernel.org, greg@kroah.com,
        marcobiscaro2112@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the Novatek wireless mouse (device id
0603:1602) to usbhid and fixes bug
https://bugzilla.kernel.org/show_bug.cgi?id=47031

Reported-by: Benoit Touchette <draekko.dev@gmail.com>
Signed-off-by: Benoit Touchette <draekko.dev@gmail.com>

---

--- linux-3.6.10/drivers/hid/hid-ids.h.orig    2012-12-10
14:13:27.000000000 -0500
+++ linux-3.6.10/drivers/hid/hid-ids.h    2012-12-12 20:06:41.000000000 -0500
@@ -833,4 +833,7 @@
 #define USB_VENDOR_ID_PRIMAX    0x0461
 #define USB_DEVICE_ID_PRIMAX_KEYBOARD    0x4e05

+#define USB_VENDOR_ID_NOVATEK    0x0603
+#define USB_DEVICE_ID_NOVATEK_MOUSE    0x1602
+
 #endif
--- linux-3.6.10/drivers/hid/usbhid/hid-quirks.c.orig    2012-12-10
14:13:27.000000000 -0500
+++ linux-3.6.10/drivers/hid/usbhid/hid-quirks.c    2012-12-12
20:06:41.000000000 -0500
@@ -98,6 +98,8 @@ static const struct hid_blacklist {

     { USB_VENDOR_ID_PI_ENGINEERING,
USB_DEVICE_ID_PI_ENGINEERING_VEC_USB_FOOTPEDAL,
HID_QUIRK_HIDINPUT_FORCE },

+    { USB_VENDOR_ID_NOVATEK, USB_DEVICE_ID_NOVATEK_MOUSE,
HID_QUIRK_NO_INIT_REPORTS },
+
     { USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_MULTI_TOUCH,
HID_QUIRK_MULTI_INPUT },
     { USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_WIRELESS,
HID_QUIRK_MULTI_INPUT },
     { USB_VENDOR_ID_SIGMA_MICRO, USB_DEVICE_ID_SIGMA_MICRO_KEYBOARD,
HID_QUIRK_NO_INIT_REPORTS },
