Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab1AFAlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:41:15 -0500
Received: from kroah.org ([198.145.64.141]:35954 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568Ab1AFAbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:00 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:07 2011
Message-Id: <20110106002307.002121912@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Robert Lukassen <Robert.Lukassen@tomtom.com>
Subject: [108/152] Revert "USB: gadget: Allow function access to device ID data during bind()"
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit dbb442b85a1d82f91cfe0524c4f9b3a5196a10ca upstream.

This reverts commit 1ab83238740ff1e1773d5c13ecac43c60cf4aec4.

Turns out this doesn't allow for the device ids to be overridden
properly, so we need to revert the thing.

Reported-by: Jef Driesen <jefdriesen@telenet.be>
Cc: Robert Lukassen <Robert.Lukassen@tomtom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/composite.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1083,14 +1083,6 @@ static int composite_bind(struct usb_gad
 	 */
 	usb_ep_autoconfig_reset(cdev->gadget);
 
-	/* standardized runtime overrides for device ID data */
-	if (idVendor)
-		cdev->desc.idVendor = cpu_to_le16(idVendor);
-	if (idProduct)
-		cdev->desc.idProduct = cpu_to_le16(idProduct);
-	if (bcdDevice)
-		cdev->desc.bcdDevice = cpu_to_le16(bcdDevice);
-
 	/* composite gadget needs to assign strings for whole device (like
 	 * serial number), register function drivers, potentially update
 	 * power state and consumption, etc
@@ -1102,6 +1094,14 @@ static int composite_bind(struct usb_gad
 	cdev->desc = *composite->dev;
 	cdev->desc.bMaxPacketSize0 = gadget->ep0->maxpacket;
 
+	/* standardized runtime overrides for device ID data */
+	if (idVendor)
+		cdev->desc.idVendor = cpu_to_le16(idVendor);
+	if (idProduct)
+		cdev->desc.idProduct = cpu_to_le16(idProduct);
+	if (bcdDevice)
+		cdev->desc.bcdDevice = cpu_to_le16(bcdDevice);
+
 	/* strings can't be assigned before bind() allocates the
 	 * releavnt identifiers
 	 */


