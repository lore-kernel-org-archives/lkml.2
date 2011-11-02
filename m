Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233Ab1KCBfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:35:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50580 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215Ab1KCBfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:35:24 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:55 2011
Message-Id: <20111102221455.871933939@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oliver Neukum <oneukum@suse.de>
Subject: [063/107] USB: add RESET_RESUME for webcams shown to be quirky
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit 2394d67e446bf616a0885167d5f0d397bdacfdfc upstream.

The new runtime PM code has shown that many webcams suffer
from a race condition that may crash them upon resume.
Runtime PM is especially prone to show the problem because
it retains power to the cameras at all times. However
system suspension may also crash the devices and retain
power to the devices.
The only way to solve this problem without races is in
usbcore with the RESET_RESUME quirk.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/quirks.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -38,6 +38,24 @@ static const struct usb_device_id usb_qu
 	/* Creative SB Audigy 2 NX */
 	{ USB_DEVICE(0x041e, 0x3020), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Logitech Webcam C200 */
+	{ USB_DEVICE(0x046d, 0x0802), .driver_info = USB_QUIRK_RESET_RESUME },
+
+	/* Logitech Webcam C250 */
+	{ USB_DEVICE(0x046d, 0x0804), .driver_info = USB_QUIRK_RESET_RESUME },
+
+	/* Logitech Webcam B/C500 */
+	{ USB_DEVICE(0x046d, 0x0807), .driver_info = USB_QUIRK_RESET_RESUME },
+
+	/* Logitech Webcam Pro 9000 */
+	{ USB_DEVICE(0x046d, 0x0809), .driver_info = USB_QUIRK_RESET_RESUME },
+
+	/* Logitech Webcam C310 */
+	{ USB_DEVICE(0x046d, 0x081b), .driver_info = USB_QUIRK_RESET_RESUME },
+
+	/* Logitech Webcam C270 */
+	{ USB_DEVICE(0x046d, 0x0825), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* Logitech Harmony 700-series */
 	{ USB_DEVICE(0x046d, 0xc122), .driver_info = USB_QUIRK_DELAY_INIT },
 
@@ -69,6 +87,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x06a3, 0x0006), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
 
+	/* Guillemot Webcam Hercules Dualpix Exchange*/
+	{ USB_DEVICE(0x06f8, 0x0804), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* M-Systems Flash Disk Pioneers */
 	{ USB_DEVICE(0x08ec, 0x1000), .driver_info = USB_QUIRK_RESET_RESUME },
 


