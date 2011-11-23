Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab1KWAdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:33:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42117 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932182Ab1KWAdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:33:35 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:22:08 2011
Message-Id: <20111123002208.775607941@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:21:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Wang YanQing <Udknight@gmail.com>
Subject: [19/25] USB: serial: pl2303: rm duplicate id
In-Reply-To: <20111123002222.GA2376@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1792
Lines: 54

From: wangyanqing <udknight@gmail.com>

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

---
 drivers/usb/serial/pl2303.c |    1 -
 drivers/usb/serial/pl2303.h |    4 ----
 2 files changed, 5 deletions(-)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -101,7 +101,6 @@ static struct usb_device_id id_table []
 	{ USB_DEVICE(SONY_VENDOR_ID, SONY_QN3USB_PRODUCT_ID) },
 	{ USB_DEVICE(SANWA_VENDOR_ID, SANWA_PRODUCT_ID) },
 	{ USB_DEVICE(ADLINK_VENDOR_ID, ADLINK_ND6530_PRODUCT_ID) },
-	{ USB_DEVICE(WINCHIPHEAD_VENDOR_ID, WINCHIPHEAD_USBSER_PRODUCT_ID) },
 	{ USB_DEVICE(SMART_VENDOR_ID, SMART_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
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


