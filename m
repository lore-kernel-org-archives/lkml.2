Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab2BMIG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 03:06:56 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52176 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab2BMIGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 03:06:53 -0500
Subject: [PATCH] HID: use generic driver for Logitech Unifying receivers if
 CONFIG_HID_LOGITECH_DJ=n
To: Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        linux-input@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>
Date: Mon, 13 Feb 2012 12:06:44 +0400
Message-ID: <20120213080644.6105.54221.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before commit 534a7b8e1 "HID: Add full support for Logitech Unifying receivers"
Logitech Unifying receiver can work as generic device without special driver,
after that commit these devices does not works without special driver.

After this patch they will use generic driver if special driver is disabled.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 drivers/hid/hid-core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index af08ce7..3d7a174 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1462,8 +1462,10 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_DFGT_WHEEL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_G25_WHEEL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_G27_WHEEL) },
+#if IS_ENABLED(CONFIG_HID_LOGITECH_DJ)
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_UNIFYING_RECEIVER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_UNIFYING_RECEIVER_2) },
+#endif
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_WII_WHEEL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_RUMBLEPAD2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_SPACETRAVELLER) },

