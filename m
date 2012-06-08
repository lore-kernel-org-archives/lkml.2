Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761673Ab2FHFIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:08:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43305 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759790Ab2FHFHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:37 -0400
Message-Id: <20120608041848.331055810@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:36 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Don Zickus <dzickus@redhat.com>,
        Oliver Neukum <oliver@neukum.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>
Subject: [ 56/82] Bluetooth: btusb: typo in Broadcom SoftSailing id
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Don Zickus <dzickus@redhat.com>

commit 2e8b506310f6433d5558387fd568d4bfb1d6a799 upstream.

I was trying to backport the following commit to RHEL-6

    From 0cea73465cd22373c5cd43a3edd25fbd4bb532ef Mon Sep 17 00:00:00 2001
    From: Oliver Neukum <oliver@neukum.org>
    Date: Wed, 21 Sep 2011 11:37:15 +0200
    Subject: [PATCH] btusb: add device entry for Broadcom SoftSailing

and noticed it wasn't working on an HP Elitebook.  Looking into the patch I
noticed a very subtle typo in the ids.  The patch has '0x05ac' instead of
'0x0a5c'.  A snippet of the lsusb -v output also shows this:

Bus 002 Device 003: ID 0a5c:21e1 Broadcom Corp.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass         1
  bDeviceProtocol         1
  bMaxPacketSize0        64
  idVendor           0x0a5c Broadcom Corp.
  idProduct          0x21e1
  bcdDevice            1.12
  iManufacturer           1 Broadcom Corp
  iProduct                2 BCM20702A0
  iSerial                 3 60D819F0338C
  bNumConfigurations      1

Looking at other Broadcom ids, the fix matches them whereas the original patch
matches Apple's ids.

Tested on an HP Elitebook 8760w.  The btusb binds and the userspace stuff loads
correctly.

Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/bluetooth/btusb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index ba89cd0..3311b81 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -61,7 +61,7 @@ static struct usb_device_id btusb_table[] = {
 	{ USB_DEVICE_INFO(0xe0, 0x01, 0x01) },
 
 	/* Broadcom SoftSailing reporting vendor specific */
-	{ USB_DEVICE(0x05ac, 0x21e1) },
+	{ USB_DEVICE(0x0a5c, 0x21e1) },
 
 	/* Apple MacBookPro 7,1 */
 	{ USB_DEVICE(0x05ac, 0x8213) },


