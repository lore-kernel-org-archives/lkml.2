Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab1KJGFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 01:05:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64939 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757280Ab1KJGFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 01:05:18 -0500
Date: Thu, 10 Nov 2011 14:04:08 +0800
From: wangyanqing <udknight@gmail.com>
To: gregkh@suse.de
Cc: wd@denx.de, stable@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH]usb: serial: pl2303: rm id
Message-ID: <20111110060408.GA25028@udknight.homenetwork>
Mail-Followup-To: wangyanqing <Udknight@gmail.com>, gregkh@suse.de,
	wd@denx.de, stable@kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get report from customer that his usb-serial
converter doesn't work well,it sometimes work,
but sometimes it doesn't.

The usb-serial converter's id:
vendor_id product_id
0x4348    0x5523

Then I search the usb-serial codes, and there are
two drivers announce support this device, pl2303
and ch341, commit 026dfaf1 cause it. Through many
times to test, ch341 works well with this device,
and pl2303 doesn't work quite often(it just work quite little).

ch341 works well with this device, so we doesn't
need pl2303 to support.I try to revert 026dfaf1 first,
but it failed. So I prepare this patch by hand to revert it.

Signed-off-by: Wang YanQing <Udknight@gmail.com>
---
 drivers/usb/serial/pl2303.c |    1 -
 drivers/usb/serial/pl2303.h |    4 ----
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 9083d1e..fc2d66f 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -91,7 +91,6 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(SONY_VENDOR_ID, SONY_QN3USB_PRODUCT_ID) },
 	{ USB_DEVICE(SANWA_VENDOR_ID, SANWA_PRODUCT_ID) },
 	{ USB_DEVICE(ADLINK_VENDOR_ID, ADLINK_ND6530_PRODUCT_ID) },
-	{ USB_DEVICE(WINCHIPHEAD_VENDOR_ID, WINCHIPHEAD_USBSER_PRODUCT_ID) },
 	{ USB_DEVICE(SMART_VENDOR_ID, SMART_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
diff --git a/drivers/usb/serial/pl2303.h b/drivers/usb/serial/pl2303.h
index 3d10d7f..c38b8c0 100644
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -145,10 +145,6 @@
 #define ADLINK_VENDOR_ID		0x0b63
 #define ADLINK_ND6530_PRODUCT_ID	0x6530
 
-/* WinChipHead USB->RS 232 adapter */
-#define WINCHIPHEAD_VENDOR_ID		0x4348
-#define WINCHIPHEAD_USBSER_PRODUCT_ID	0x5523
-
 /* SMART USB Serial Adapter */
 #define SMART_VENDOR_ID	0x0b8c
 #define SMART_PRODUCT_ID	0x2303
-- 
1.7.3.4

