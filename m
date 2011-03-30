Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147Ab1C3VGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:06:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:50110 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933098Ab1C3VFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:05:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411276627"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: stern@rowland.harvard.edu, ak@linux.intel.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [17/275] USB: usb-storage: unusual_devs entry for CamSport Evo
Message-Id: <20110330210411.93DC63E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit 12f68c480c7155a66bd2a76ab2fef28dd5f93fa2 upstream.

This patch (as1438) adds an unusual_devs entry for the MagicPixel
FW_Omega2 chip, used in the CamSport Evo camera.  The firmware
incorrectly reports a vendor-specific bDeviceClass.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reported-by: <ttkspam@free.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6.35.y/drivers/usb/storage/unusual_devs.h
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/storage/unusual_devs.h	2011-03-29 23:02:58.560337007 -0700
+++ linux-2.6.35.y/drivers/usb/storage/unusual_devs.h	2011-03-29 23:55:32.576633622 -0700
@@ -1043,6 +1043,15 @@
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_BULK32),
 
+/* Reported by <ttkspam@free.fr>
+ * The device reports a vendor-specific device class, requiring an
+ * explicit vendor/product match.
+ */
+UNUSUAL_DEV(  0x0851, 0x1542, 0x0002, 0x0002,
+		"MagicPixel",
+		"FW_Omega2",
+		US_SC_DEVICE, US_PR_DEVICE, NULL, 0),
+
 /* Andrew Lunn <andrew@lunn.ch>
  * PanDigital Digital Picture Frame. Does not like ALLOW_MEDIUM_REMOVAL
  * on LUN 4.
