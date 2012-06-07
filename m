Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889Ab2FGEX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:23:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63657 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759873Ab2FGEXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:23:52 -0400
Message-Id: <20120607041401.204313562@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:14:19 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oliver Neukum <oliver@neukum.org>,
        Don Zickus <dzickus@redhat.com>, Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 21/47] Bluetooth: btusb: typo in Broadcom SoftSailing id
In-Reply-To: <20120607041504.GA13819@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/btusb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -61,7 +61,7 @@ static struct usb_device_id btusb_table[
 	{ USB_DEVICE_INFO(0xe0, 0x01, 0x01) },
 
 	/* Broadcom SoftSailing reporting vendor specific */
-	{ USB_DEVICE(0x05ac, 0x21e1) },
+	{ USB_DEVICE(0x0a5c, 0x21e1) },
 
 	/* Apple MacBookPro 7,1 */
 	{ USB_DEVICE(0x05ac, 0x8213) },


