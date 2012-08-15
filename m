Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab2HOTw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:52:28 -0400
Received: from mail.windriver.com ([147.11.1.11]:37141 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757019Ab2HOTwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:25 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: wangyanqing <udknight@gmail.com>, Wang YanQing <Udknight@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 136/165] USB: serial: pl2303: rm duplicate id
Date: Wed, 15 Aug 2012 15:48:00 -0400
Message-ID: <1345060109-9187-137-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wangyanqing <udknight@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 0c16595539b612fe948559433dda08ff96a8bdc7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/pl2303.c | 1 -
 drivers/usb/serial/pl2303.h | 4 ----
 2 files changed, 5 deletions(-)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index e42ee9b..95ca261 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -101,7 +101,6 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(SONY_VENDOR_ID, SONY_QN3USB_PRODUCT_ID) },
 	{ USB_DEVICE(SANWA_VENDOR_ID, SANWA_PRODUCT_ID) },
 	{ USB_DEVICE(ADLINK_VENDOR_ID, ADLINK_ND6530_PRODUCT_ID) },
-	{ USB_DEVICE(WINCHIPHEAD_VENDOR_ID, WINCHIPHEAD_USBSER_PRODUCT_ID) },
 	{ USB_DEVICE(SMART_VENDOR_ID, SMART_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
diff --git a/drivers/usb/serial/pl2303.h b/drivers/usb/serial/pl2303.h
index 450a4a7..8dbdb46 100644
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
1.7.12.rc2

