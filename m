Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab1BBAzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:55:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:18592 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660Ab1BBAot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="883418267"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: gregkh@suse.de, Robert.Lukassen@tomtom.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [101/139] Revert "USB: gadget: Allow function access to device ID data during bind()"
Message-Id: <20110202004459.738403E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Greg Kroah-Hartman <gregkh@suse.de>

commit dbb442b85a1d82f91cfe0524c4f9b3a5196a10ca upstream.

This reverts commit 1ab83238740ff1e1773d5c13ecac43c60cf4aec4.

Turns out this doesn't allow for the device ids to be overridden
properly, so we need to revert the thing.

Reported-by: Jef Driesen <jefdriesen@telenet.be>
Cc: Robert Lukassen <Robert.Lukassen@tomtom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/gadget/composite.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6.35.y/drivers/usb/gadget/composite.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/gadget/composite.c
+++ linux-2.6.35.y/drivers/usb/gadget/composite.c
@@ -1018,14 +1018,6 @@ static int composite_bind(struct usb_gad
 	 */
 	usb_ep_autoconfig_reset(cdev->gadget);
 
-	/* standardized runtime overrides for device ID data */
-	if (idVendor)
-		cdev->desc.idVendor = cpu_to_le16(idVendor);
-	if (idProduct)
-		cdev->desc.idProduct = cpu_to_le16(idProduct);
-	if (bcdDevice)
-		cdev->desc.bcdDevice = cpu_to_le16(bcdDevice);
-
 	/* composite gadget needs to assign strings for whole device (like
 	 * serial number), register function drivers, potentially update
 	 * power state and consumption, etc
@@ -1037,6 +1029,14 @@ static int composite_bind(struct usb_gad
 	cdev->desc = *composite->dev;
 	cdev->desc.bMaxPacketSize0 = gadget->ep0->maxpacket;
 
+	/* standardized runtime overrides for device ID data */
+	if (idVendor)
+		cdev->desc.idVendor = cpu_to_le16(idVendor);
+	if (idProduct)
+		cdev->desc.idProduct = cpu_to_le16(idProduct);
+	if (bcdDevice)
+		cdev->desc.bcdDevice = cpu_to_le16(bcdDevice);
+
 	/* strings can't be assigned before bind() allocates the
 	 * releavnt identifiers
 	 */
