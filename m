Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab0KSVpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:45:17 -0500
Received: from kroah.org ([198.145.64.141]:51662 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757161Ab0KSVpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:45:14 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:44:09 2010
Message-Id: <20101119214409.521139351@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:42:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Max Vozeler <mvz@vozeler.com>
Subject: [01/45] staging: usbip: Notify usb core of port status changes
In-Reply-To: <20101119214439.GA26350@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Max Vozeler <mvz@vozeler.com>

commit 0c9a32f0192e656daa2ff3c9149f6d71b4a1b873 upstream.

This patch changes vhci to behave like dummy and
other hcds when disconnecting a device.

Previously detaching a device from the root hub
did not notify the usb core of the disconnect and
left the device visible.

Signed-off-by: Max Vozeler <mvz@vozeler.com>
Reported-by: Marco Lancione <marco@optikam.com>
Tested-by: Luc Jalbert <ljalbert@optikam.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/usbip/vhci_hcd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -163,6 +163,8 @@ void rh_port_disconnect(int rhport)
 	 * spin_unlock(&vdev->ud.lock); */
 
 	spin_unlock_irqrestore(&the_controller->lock, flags);
+
+	usb_hcd_poll_rh_status(vhci_to_hcd(the_controller));
 }
 
 


