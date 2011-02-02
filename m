Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab1BBAyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:54:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:42502 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678Ab1BBAou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028563"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: vitty@altlinux.ru, stern@rowland.harvard.edu, ak@linux.intel.com,
        mdharm-usb@one-eyed-alien.net, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [100/139] USB: usb-storage: unusual_devs entry for the Samsung YP-CP3
Message-Id: <20110202004458.68F603E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>
CC: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6.35.y/drivers/usb/storage/unusual_devs.h
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/storage/unusual_devs.h
+++ linux-2.6.35.y/drivers/usb/storage/unusual_devs.h
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
