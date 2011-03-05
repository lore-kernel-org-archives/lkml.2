Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760319Ab1CEBTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:19:48 -0500
Received: from kroah.org ([198.145.64.141]:50099 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760102Ab1CEA7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 19:59:50 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:35 2011
Message-Id: <20110305005635.004347765@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Maciej Szmigiero <mhej@o2.pl>
Subject: [04/73] USB: Add quirk for Samsung Android phone modem
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Maciej Szmigiero <mhej@o2.pl>

commit 72a012ce0a02c6c616676a24b40ff81d1aaeafda upstream.

My Galaxy Spica needs this quirk when in modem mode, otherwise
it causes endless USB bus resets and is unusable in this mode.

Unfortunately Samsung decided to reuse ID of its old CDMA phone SGH-I500
for the modem part.
That's why in addition to this patch the visor driver must be prevented
from binding to SPH-I500 ID, so ACM driver can do that.

Signed-off-by: Maciej Szmigiero <mhej@o2.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -48,6 +48,10 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x04b4, 0x0526), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
 
+	/* Samsung Android phone modem - ID conflict with SPH-I500 */
+	{ USB_DEVICE(0x04e8, 0x6601), .driver_info =
+			USB_QUIRK_CONFIG_INTF_STRINGS },
+
 	/* Roland SC-8820 */
 	{ USB_DEVICE(0x0582, 0x0007), .driver_info = USB_QUIRK_RESET_RESUME },
 


