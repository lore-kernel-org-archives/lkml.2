Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162397Ab1FAIxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:53:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:44425 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162333Ab1FAITM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:19:12 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:16 2011
Message-Id: <20110601081116.434769724@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:16 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [046/165] usb-storage: fix up the unusual_realtek device list
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1573
Lines: 46

From: Alan Stern <stern@rowland.harvard.edu>

commit a8e62dd6d91f3bc3687abbb26227e5fc39c4829c upstream.

This patch (as1461) fixes the unusual_devs entries for the Realtek USB
card reader.  They should be ordered by PID, and they should not
override the Subclass and Protocol values provided by the device.
Otherwise a notification about unnecessary entries gets printed in the
kernel log during probing.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-By: Tony Vroon <tony@linx.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_realtek.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/usb/storage/unusual_realtek.h
+++ b/drivers/usb/storage/unusual_realtek.h
@@ -23,19 +23,19 @@
 #if defined(CONFIG_USB_STORAGE_REALTEK) || \
 		defined(CONFIG_USB_STORAGE_REALTEK_MODULE)
 
-UNUSUAL_DEV(0x0bda, 0x0159, 0x0000, 0x9999,
+UNUSUAL_DEV(0x0bda, 0x0138, 0x0000, 0x9999,
 		"Realtek",
 		"USB Card Reader",
-		USB_SC_SCSI, USB_PR_BULK, init_realtek_cr, 0),
+		USB_SC_DEVICE, USB_PR_DEVICE, init_realtek_cr, 0),
 
 UNUSUAL_DEV(0x0bda, 0x0158, 0x0000, 0x9999,
 		"Realtek",
 		"USB Card Reader",
-		USB_SC_SCSI, USB_PR_BULK, init_realtek_cr, 0),
+		USB_SC_DEVICE, USB_PR_DEVICE, init_realtek_cr, 0),
 
-UNUSUAL_DEV(0x0bda, 0x0138, 0x0000, 0x9999,
+UNUSUAL_DEV(0x0bda, 0x0159, 0x0000, 0x9999,
 		"Realtek",
 		"USB Card Reader",
-		USB_SC_SCSI, USB_PR_BULK, init_realtek_cr, 0),
+		USB_SC_DEVICE, USB_PR_DEVICE, init_realtek_cr, 0),
 
 #endif  /* defined(CONFIG_USB_STORAGE_REALTEK) || ... */


