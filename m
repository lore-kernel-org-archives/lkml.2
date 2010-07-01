Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177Ab0GAVOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:14:33 -0400
Received: from kroah.org ([198.145.64.141]:33845 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758822Ab0GAVNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:17 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:49 2010
Message-Id: <20100701174249.878177518@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:42:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Nils Radtke <lkml@Think-Future.de>
Subject: [041/200] USB: option.c: OLIVETTI OLICARD100 support
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nils Radtke <lkml@Think-Future.de>

commit 86234d4975ce084d14711283a3bfc69305f97602 upstream.

This patch adds support for an olivetti olicard100 HЅDPA usb-stick.

This device is a zeroCD one with ID 0b3c:c700 that needs switching via
eject or usb-modeswitch with
MessageContent="5553424312345678000000000000061b000000030000000000000000000000".
After switching it has ID 0b3c:c000 and provides 5 serial ports ttyUSB[0-4].
Port 0 (modem) and 4 are interrupt ports.

Signed-off-by: Nils Radtke <lkml@Think-Future.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -380,6 +380,10 @@ static int  option_resume(struct usb_ser
 
 #define CINTERION_VENDOR_ID			0x0681
 
+/* Olivetti products */
+#define OLIVETTI_VENDOR_ID			0x0b3c
+#define OLIVETTI_PRODUCT_OLICARD100		0xc000
+
 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE = 0,
@@ -900,6 +904,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_1012)},
 
 	{ USB_DEVICE(CINTERION_VENDOR_ID, 0x0047) },
+
+	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD100) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);


