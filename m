Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379Ab2FQSha (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:37:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50203 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758076Ab2FQSWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:37 -0400
Message-Id: <20120617175950.030711074@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:41 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Hans de Goede <hdegoede@redhat.com>,
        Simon Raffeiner <sturmflut@lieberbiber.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 60/69] usb-storage: Add 090c:1000 to unusal-devs
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit afff07e61a5243e14ee3f0a272a0380cd744a8a3 upstream.

This device gives a bogus answer to get_capacity(16):
[ 8628.278614] scsi 8:0:0:0: Direct-Access     USB 2.0  USB Flash Drive  1100 PQ: 0 ANSI: 4
[ 8628.279452] sd 8:0:0:0: Attached scsi generic sg4 type 0
[ 8628.280338] sd 8:0:0:0: [sdd] 35747322042253313 512-byte logical blocks: (18.3 EB/15.8 EiB)

So set the quirk flag to avoid using get_capacity(16) with it:
[11731.386014] usb-storage 2-1.6:1.0: Quirks match for vid 090c pid 1000: 80000
[11731.386075] scsi9 : usb-storage 2-1.6:1.0
[11731.386172] usbcore: registered new interface driver usb-storage
[11731.386175] USB Mass Storage support registered.
[11732.387394] scsi 9:0:0:0: Direct-Access     USB 2.0  USB Flash Drive  1100 PQ: 0 ANSI: 4
[11732.388462] sd 9:0:0:0: Attached scsi generic sg3 type 0
[11732.389432] sd 9:0:0:0: [sdc] 7975296 512-byte logical blocks: (4.08 GB/3.80 GiB)

Which makes the capacity look a lot more sane :)

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Simon Raffeiner <sturmflut@lieberbiber.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 1719886..caf22bf 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1107,6 +1107,13 @@ UNUSUAL_DEV( 0x090a, 0x1200, 0x0000, 0x9999,
 		USB_SC_RBC, USB_PR_BULK, NULL,
 		0 ),
 
+/* Feiya QDI U2 DISK, reported by Hans de Goede <hdegoede@redhat.com> */
+UNUSUAL_DEV( 0x090c, 0x1000, 0x0000, 0xffff,
+		"Feiya",
+		"QDI U2 DISK",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_READ_CAPACITY_16 ),
+
 /* aeb */
 UNUSUAL_DEV( 0x090c, 0x1132, 0x0000, 0xffff,
 		"Feiya",


