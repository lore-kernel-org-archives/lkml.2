Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab1DYVCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 17:02:33 -0400
Received: from 1wt.eu ([62.212.114.60]:33703 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755061Ab1DYUXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:23:08 -0400
Message-Id: <20110425200233.171946848@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:02:36 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 004/173] USB: usb-storage: unusual_devs entry for CamSport Evo
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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


