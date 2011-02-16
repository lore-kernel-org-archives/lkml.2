Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab1BPCNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:13:37 -0500
Received: from kroah.org ([198.145.64.141]:48725 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932105Ab1BPBtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:49:10 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:46:55 2011
Message-Id: <20110216014655.414312542@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:44:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [011/115] USB: usb-storage: unusual_devs entry for CamSport Evo
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 12f68c480c7155a66bd2a76ab2fef28dd5f93fa2 upstream.

This patch (as1438) adds an unusual_devs entry for the MagicPixel
FW_Omega2 chip, used in the CamSport Evo camera.  The firmware
incorrectly reports a vendor-specific bDeviceClass.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: <ttkspam@free.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1043,6 +1043,15 @@ UNUSUAL_DEV(  0x084d, 0x0011, 0x0110, 0x
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


