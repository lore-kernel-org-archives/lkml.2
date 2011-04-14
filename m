Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813Ab1DNSEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:04:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:42277 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965047Ab1DNR7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:59:00 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Vitaly Kuznetsov <vitty@altlinux.ru>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 187/209] USB: usb-storage: unusual_devs entry for the Samsung YP-CP3
Date: Thu, 14 Apr 2011 13:55:45 -0400
Message-Id: <1302803767-9715-74-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaly Kuznetsov <vitty@altlinux.ru>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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

[PG: change USB_ --> US_ to match 2.6.34.x naming conventions]

Signed-off-by: Vitaly Kuznetsov <vitty@altlinux.ru>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
CC: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 55b3cd1..0fa56ea 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -490,6 +490,13 @@ UNUSUAL_DEV(  0x04e8, 0x507c, 0x0220, 0x0220,
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
-- 
1.7.4.4

