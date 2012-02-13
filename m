Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab2BMKNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 05:13:10 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56535 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab2BMKNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 05:13:07 -0500
Subject: [PATCH v2] HID: use generic driver for Logitech Unifying receivers if
 CONFIG_HID_LOGITECH_DJ=n
To: Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        linux-input@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>
Date: Mon, 13 Feb 2012 14:13:03 +0400
Message-ID: <20120213101303.8665.76516.stgit@zurg>
In-Reply-To: <20120213080644.6105.54221.stgit@zurg>
References: <20120213080644.6105.54221.stgit@zurg>
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
 drivers/hid/Kconfig    |    4 +++-
 drivers/hid/hid-core.c |    2 ++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index a421abd..ca322ee 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -257,7 +257,9 @@ config HID_LOGITECH_DJ
 	---help---
 	Say Y if you want support for Logitech Unifying receivers and devices.
 	Unifying receivers are capable of pairing up to 6 Logitech compliant
-	devices to the same receiver.
+	devices to the same receiver. Without this driver it will be handled by
+	generic USB_HID driver and all incomming events will be multiplexed
+	into a single mouse and a single keyboard device.
 
 config LOGITECH_FF
 	bool "Logitech force feedback support"
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

