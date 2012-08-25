Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab2HYRXC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 13:23:02 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:57164 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab2HYRXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 13:23:00 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhNMAGcJOVBV5qoUPGdsb2JhbABFhRqFI7AtGQEBAQEeGQ0ngn0TAQ8YgQIKGhOIEbtkFJIFA5tAjQ8
X-IronPort-AV: E=Sophos;i="4.77,826,1336341600"; 
   d="scan'208";a="180648374"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] Bluetooth: Add support for Apple vendor-specific devices
Date: Sat, 25 Aug 2012 19:28:06 +0200
Message-Id: <1345915686-3915-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pointed out by Gustavo and Marcel, all Apple-specific Broadcom
devices seen so far have the same interface class, subclass and
protocol numbers. This patch adds an entry which matches all of them,
using the new USB_VENDOR_AND_INTERFACE_INFO() macro.

In particular, this patch adds support for the MacBook Pro Retina
(05ac:8286), which is not in the present list.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Hi Gustavo,

here is a patch for the Apple devices, utilizing commit d81a5d19, for
3.6. Tested on the MacBookPro10,1 (Retina). If you want, I can
follow-up with a patch for 3.7 which removes the specific entries. I
have verified the lsusb output of all of them, except MacMini5,1.

Thanks,
Henrik

 drivers/bluetooth/btusb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 12075ad..1fae607 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -52,6 +52,9 @@ static struct usb_device_id btusb_table[] = {
 	/* Generic Bluetooth USB device */
 	{ USB_DEVICE_INFO(0xe0, 0x01, 0x01) },
 
+	/* Apple-specific (Broadcom) devices */
+	{ USB_VENDOR_AND_INTERFACE_INFO(0x05ac, 0xff, 0x01, 0x01) },
+
 	/* Broadcom SoftSailing reporting vendor specific */
 	{ USB_DEVICE(0x0a5c, 0x21e1) },
 
-- 
1.7.12

