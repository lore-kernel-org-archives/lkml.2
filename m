Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab1KJEi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:38:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43611 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935849Ab1KJDgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:36:02 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:43 2011
Message-Id: <20111109213142.942193162@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:30:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Bill Pemberton <wfp5p@virginia.edu>
Subject: [008/264] staging: serqt_usb2: remove ssu100 from supported devices
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bill Pemberton <wfp5p@virginia.edu>

commit 7cbf3c7cd59288fb5e9f31815c74773549668d43 upstream.

The serqt_usb2 driver will not work properly with the ssu100 device
even though it claims to support it.  The ssu100 is supported by the
ssu100 driver in mainline so there is no need to have it claimed by
serqt_usb2.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/serqt_usb2/serqt_usb2.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -24,7 +24,6 @@ static int debug;
 #define DRIVER_DESC "Quatech USB to Serial Driver"
 
 #define	USB_VENDOR_ID_QUATECH			0x061d	/* Quatech VID */
-#define QUATECH_SSU100	0xC020	/* SSU100 */
 #define QUATECH_SSU200	0xC030	/* SSU200 */
 #define QUATECH_DSU100	0xC040	/* DSU100 */
 #define QUATECH_DSU200	0xC050	/* DSU200 */
@@ -127,7 +126,6 @@ static int debug;
 #define RS232_MODE          0x00
 
 static const struct usb_device_id serqt_id_table[] = {
-	{USB_DEVICE(USB_VENDOR_ID_QUATECH, QUATECH_SSU100)},
 	{USB_DEVICE(USB_VENDOR_ID_QUATECH, QUATECH_SSU200)},
 	{USB_DEVICE(USB_VENDOR_ID_QUATECH, QUATECH_DSU100)},
 	{USB_DEVICE(USB_VENDOR_ID_QUATECH, QUATECH_DSU200)},
@@ -775,7 +773,6 @@ static int qt_startup(struct usb_serial
 	}
 
 	switch (serial->dev->descriptor.idProduct) {
-	case QUATECH_SSU100:
 	case QUATECH_DSU100:
 	case QUATECH_QSU100:
 	case QUATECH_ESU100A:


