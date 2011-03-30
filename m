Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964947Ab1C3Vln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:41:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:61735 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933562Ab1C3VIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621237532"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: stern@rowland.harvard.edu, nur.kholis.majid@gmail.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [141/275] USB: add quirks entry for Keytouch QWERTY Panel
Message-Id: <20110330210622.2B5473E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit 3c18e30f87ac5466bddbb05cf955605efd7db025 upstream.

This patch (as1448) adds a quirks entry for the Keytouch QWERTY Panel
firmware, used in the IEC 60945 keyboard.  This device crashes during
enumeration when the computer asks for its configuration string
descriptor.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: kholis <nur.kholis.majid@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/core/quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6.35.y/drivers/usb/core/quirks.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/core/quirks.c	2011-03-29 22:51:10.768447631 -0700
+++ linux-2.6.35.y/drivers/usb/core/quirks.c	2011-03-29 23:54:41.011953034 -0700
@@ -68,6 +68,10 @@
 	/* M-Systems Flash Disk Pioneers */
 	{ USB_DEVICE(0x08ec, 0x1000), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Keytouch QWERTY Panel keyboard */
+	{ USB_DEVICE(0x0926, 0x3333), .driver_info =
+			USB_QUIRK_CONFIG_INTF_STRINGS },
+
 	/* X-Rite/Gretag-Macbeth Eye-One Pro display colorimeter */
 	{ USB_DEVICE(0x0971, 0x2000), .driver_info = USB_QUIRK_NO_SET_INTF },
 
