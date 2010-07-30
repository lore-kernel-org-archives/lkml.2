Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867Ab0G3R6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:58:07 -0400
Received: from kroah.org ([198.145.64.141]:58836 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760062Ab0G3R4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:56:54 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:46 2010
Message-Id: <20100730175146.404153584@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Mortier <mortier@btinternet.com>
Subject: [137/205] USB: adds Artisman USB dongle to list of quirky devices
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Mortier <mortier@btinternet.com>

commit 47f19c0eedb377ad1ee8114f464d001ec5f96a69 upstream.

When an attempt is made to read the interface strings of the Artisman
Watchdog USB dongle (idVendor:idProduct 04b4:0526) an error is written
to the dmesg log (uhci_result_common: failed with status 440000) and the
dongle resets itself, resulting in a disconnect/reconnect loop.

Adding the dongle to the list of devices in quirks.c, with the same
quirk Alan Stern's previous patch for the Saitek Cyborg Gold 3D
joystick, stops the device from resetting and allows it to be used with
no problems.

Signed-off-by: Paul Mortier <mortier@btinternet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -41,6 +41,10 @@ static const struct usb_device_id usb_qu
 	/* Philips PSC805 audio device */
 	{ USB_DEVICE(0x0471, 0x0155), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Artisman Watchdog Dongle */
+	{ USB_DEVICE(0x04b4, 0x0526), .driver_info =
+			USB_QUIRK_CONFIG_INTF_STRINGS },
+
 	/* Roland SC-8820 */
 	{ USB_DEVICE(0x0582, 0x0007), .driver_info = USB_QUIRK_RESET_RESUME },
 


