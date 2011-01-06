Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab1AFAbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:31:00 -0500
Received: from kroah.org ([198.145.64.141]:35949 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545Ab1AFAa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:30:58 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:06 2011
Message-Id: <20110106002306.914677134@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vitaly Kuznetsov <vitty@altlinux.ru>,
        Alan Stern <stern@rowland.harvard.edu>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Subject: [107/152] USB: usb-storage: unusual_devs entry for the Samsung YP-CP3
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vitaly Kuznetsov <vitty@altlinux.ru>

commit d73a9b3001f29271c2e9f2a806b05a431c5d9591 upstream.

Add an unusual_devs entry for the Samsung YP-CP3 MP4 player.

User was getting the following errors in dmesg:
 usb 2-6: reset high speed USB device using ehci_hcd and address 2
 usb 2-6: reset high speed USB device using ehci_hcd and address 2
 usb 2-6: reset high speed USB device using ehci_hcd and address 2
 usb 2-6: USB disconnect, address 2
 sd 3:0:0:0: [sdb] Assuming drive cache: write through
 sdb:<2>ldm_validate_partition_table(): Disk read failed.
 Dev sdb: unable to read RDB block 0
  unable to read partition table

Signed-off-by: Vitaly Kuznetsov <vitty@altlinux.ru>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
CC: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -481,6 +481,13 @@ UNUSUAL_DEV(  0x04e8, 0x507c, 0x0220, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_MAX_SECTORS_64),
 
+/* Reported by Vitaly Kuznetsov <vitty@altlinux.ru> */
+UNUSUAL_DEV(  0x04e8, 0x5122, 0x0000, 0x9999,
+		"Samsung",
+		"YP-CP3",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_MAX_SECTORS_64 | US_FL_BULK_IGNORE_TAG),
+
 /* Entry and supporting patch by Theodore Kilgore <kilgota@auburn.edu>.
  * Device uses standards-violating 32-byte Bulk Command Block Wrappers and
  * reports itself as "Proprietary SCSI Bulk." Cf. device entry 0x084d:0x0011.


