Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab1FPHfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:35:19 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:57759 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755731Ab1FPHBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:01:08 -0400
X-Sasl-enc: nxtopAUy/7O+89lS6h2HwyCQ2Tx6bcbNRUuD/s9sG8Mx 1308207668
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:34 2011
Message-Id: <20110616000234.398012664@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Pawe=C5=82=20Drobek?= <pawel.drobek@gmail.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [55/89] Revert "USB: option: add ID for ZTE MF 330"
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit 3095ec895fd5ec19a7cb60b5cbfa766d68a74a24 upstream.

This reverts commit a559d2c8c1bf652ea2d0ecd6ab4a250fcdb37db8.

Turns out that device id 0x1d6b:0x0002 is a USB hub, which causes havoc
when the option driver tries to bind to it.

So revert this as it doesn't seem to be needed at all.

Thanks to Michael Tokarev and Paweł Drobek for working on resolving this
issue.

Cc: Paweł Drobek <pawel.drobek@gmail.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -311,10 +311,6 @@ static void option_instat_callback(struc
 #define ZTE_PRODUCT_AC2726			0xfff5
 #define ZTE_PRODUCT_AC8710T			0xffff
 
-/* ZTE PRODUCTS -- alternate vendor ID */
-#define ZTE_VENDOR_ID2				0x1d6b
-#define ZTE_PRODUCT_MF_330			0x0002
-
 #define BENQ_VENDOR_ID				0x04a5
 #define BENQ_PRODUCT_H10			0x4068
 
@@ -941,7 +937,6 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AC8710, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AC2726, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AC8710T, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE(ZTE_VENDOR_ID2, ZTE_PRODUCT_MF_330) },
 	{ USB_DEVICE(BENQ_VENDOR_ID, BENQ_PRODUCT_H10) },
 	{ USB_DEVICE(DLINK_VENDOR_ID, DLINK_PRODUCT_DWM_652) },
 	{ USB_DEVICE(ALINK_VENDOR_ID, DLINK_PRODUCT_DWM_652_U5) }, /* Yes, ALINK_VENDOR_ID */


