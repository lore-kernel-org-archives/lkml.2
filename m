Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933269Ab1FWSVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:21:31 -0400
Received: from mail.windriver.com ([147.11.1.11]:34193 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933197Ab1FWRfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:35:51 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dario Lombardo <dario.lombardo@liberoo.it>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 060/247] drivers: update to pl2303 usb-serial to support Motorola cables
Date: Thu, 23 Jun 2011 13:32:08 -0400
Message-Id: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dario Lombardo <dario.lombardo@liberoo.it>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 96a3e79edff6f41b0f115a82f1a39d66218077a7 upstream.

Added 0x0307 device id to support Motorola cables to the pl2303 usb
serial driver. This cable has a modified chip that is a pl2303, but
declares itself as 0307. Fixed by adding the right device id to the
supported devices list, assigning it the code labeled
PL2303_PRODUCT_ID_MOTOROLA.

Signed-off-by: Dario Lombardo <dario.lombardo@liberoo.it>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/pl2303.c |    1 +
 drivers/usb/serial/pl2303.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index f6e4703..eb7d1ce 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -60,6 +60,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_MMX) },
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_GPRS) },
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_HCR331) },
+	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_MOTOROLA) },
 	{ USB_DEVICE(IODATA_VENDOR_ID, IODATA_PRODUCT_ID) },
 	{ USB_DEVICE(IODATA_VENDOR_ID, IODATA_PRODUCT_ID_RSAQ5) },
 	{ USB_DEVICE(ATEN_VENDOR_ID, ATEN_PRODUCT_ID) },
diff --git a/drivers/usb/serial/pl2303.h b/drivers/usb/serial/pl2303.h
index e8b7c5b..d67b480 100644
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -21,6 +21,7 @@
 #define PL2303_PRODUCT_ID_MMX		0x0612
 #define PL2303_PRODUCT_ID_GPRS		0x0609
 #define PL2303_PRODUCT_ID_HCR331	0x331a
+#define PL2303_PRODUCT_ID_MOTOROLA	0x0307
 
 #define ATEN_VENDOR_ID		0x0557
 #define ATEN_VENDOR_ID2		0x0547
-- 
1.7.4.4

