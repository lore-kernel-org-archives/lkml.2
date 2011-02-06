Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab1BFXqP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:46:15 -0500
Received: from 1wt.eu ([62.212.114.60]:60318 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540Ab1BFXqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:46:14 -0500
Message-Id: <20110206232252.702170293@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 07 Feb 2011 00:22:56 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Vitaly Kuznetsov <vitty@altlinux.ru>,
        Alan Stern <stern@rowland.harvard.edu>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [PATCH 04/23] USB: usb-storage: unusual_devs entry for the Samsung YP-CP3
In-Reply-To: <4beed4da27f06efb2c13d6ed48850634@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.58-stable review patch.  If anyone has any objections, please let us know.

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
Signed-off-by: Willy Tarreau <w@1wt.eu>

---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

Index: longterm-2.6.27/drivers/usb/storage/unusual_devs.h
===================================================================
--- longterm-2.6.27.orig/drivers/usb/storage/unusual_devs.h	2011-01-29 11:19:14.704065119 +0100
+++ longterm-2.6.27/drivers/usb/storage/unusual_devs.h	2011-01-29 11:27:24.078067832 +0100
@@ -608,6 +608,13 @@
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


