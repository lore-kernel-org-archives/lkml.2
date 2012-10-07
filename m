Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab2JGXch (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:32:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38550 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754494Ab2JGXXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:23:00 -0400
Message-Id: <20121007225841.901967507@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:26 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        John Hommel <john.hommel@hp.com>
Subject: [ 052/108] Bluetooth: Use USB_VENDOR_AND_INTERFACE() for Broadcom devices
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo Padovan <gustavo.padovan@collabora.co.uk>

commit 92c385f46b30f4954e9dd2d2005c12d233b479ea upstream.

Many Broadcom devices has a vendor specific devices class, with this rule
we match all existent and future controllers with this behavior.

We also remove old rules to that matches product id for Broadcom devices.

Tested-by: John Hommel <john.hommel@hp.com>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/bluetooth/btusb.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 2fe7776..e791b20 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -94,16 +94,14 @@ static struct usb_device_id btusb_table[] = {
 
 	/* Broadcom BCM20702A0 */
 	{ USB_DEVICE(0x0489, 0xe042) },
-	{ USB_DEVICE(0x0a5c, 0x21e3) },
-	{ USB_DEVICE(0x0a5c, 0x21e6) },
-	{ USB_DEVICE(0x0a5c, 0x21e8) },
-	{ USB_DEVICE(0x0a5c, 0x21f3) },
-	{ USB_DEVICE(0x0a5c, 0x21f4) },
 	{ USB_DEVICE(0x413c, 0x8197) },
 
 	/* Foxconn - Hon Hai */
 	{ USB_DEVICE(0x0489, 0xe033) },
 
+	/*Broadcom devices with vendor specific id */
+	{ USB_VENDOR_AND_INTERFACE_INFO(0x0a5c, 0xff, 0x01, 0x01) },
+
 	{ }	/* Terminating entry */
 };
 


