Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab1CJKwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 05:52:12 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46557 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab1CJKwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 05:52:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=FM+dQXR6Jm+R6u2ESXj4KVlvd7MD5X4LyH8W/g8LROH0GWhmBxnyiBREx9p+AjW7Y2
         ZtnNPQucEfdzXhNy8qPXfsQSTCZFFInCf/s2pXpvcSLt0ydwrl6a0wd3ojBAYqN+q4OC
         cSodckhwMz5mI5NJK1d3llj6urJ0/dxWVV4o0=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 14/21] staging: ft1000: Fix coding style in ft1000_submit_rx_urb function.
Date: Thu, 10 Mar 2011 11:51:28 +0100
Message-Id: <1299754295-8493-15-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
References: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style and also replace printk with proper pr_err
function.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   46 ++++++++++++-------------
 1 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 63ee38c..f07b3ed 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -1203,38 +1203,36 @@ static int ft1000_copy_up_pkt (struct urb *urb)
 //---------------------------------------------------------------------------
 static int ft1000_submit_rx_urb(struct ft1000_info *info)
 {
-    int result;
-    struct ft1000_device *pFt1000Dev = info->pFt1000Dev;
+	int result;
+	struct ft1000_device *pFt1000Dev = info->pFt1000Dev;
 
+	//DEBUG ("ft1000_submit_rx_urb entered: sizeof rx_urb is %d\n", sizeof(*pFt1000Dev->rx_urb));
+	if (pFt1000Dev->status & FT1000_STATUS_CLOSING) {
+		DEBUG("network driver is closed, return\n");
+		//usb_kill_urb(pFt1000Dev->rx_urb); //mbelian
+		return -ENODEV;
+	}
 
-    //DEBUG ("ft1000_submit_rx_urb entered: sizeof rx_urb is %d\n", sizeof(*pFt1000Dev->rx_urb));
-    if ( pFt1000Dev->status & FT1000_STATUS_CLOSING)
-    {
-        DEBUG("network driver is closed, return\n");
-        //usb_kill_urb(pFt1000Dev->rx_urb); //mbelian
-	return -ENODEV;
-    }
-
-    usb_fill_bulk_urb(pFt1000Dev->rx_urb,
-            pFt1000Dev->dev,
-            usb_rcvbulkpipe(pFt1000Dev->dev, pFt1000Dev->bulk_in_endpointAddr),
-            pFt1000Dev->rx_buf,
-            MAX_BUF_SIZE,
-            (usb_complete_t)ft1000_copy_up_pkt,
-            info);
-
+	usb_fill_bulk_urb(pFt1000Dev->rx_urb,
+			  pFt1000Dev->dev,
+			  usb_rcvbulkpipe(pFt1000Dev->dev,
+					  pFt1000Dev->bulk_in_endpointAddr),
+			  pFt1000Dev->rx_buf, MAX_BUF_SIZE,
+			  (usb_complete_t) ft1000_copy_up_pkt, info);
 
-    if((result = usb_submit_urb(pFt1000Dev->rx_urb, GFP_ATOMIC)))
-    {
-        printk("ft1000_submit_rx_urb: submitting rx_urb %d failed\n", result);
-	return result;
-    }
+	result = usb_submit_urb(pFt1000Dev->rx_urb, GFP_ATOMIC);
 
-    //DEBUG("ft1000_submit_rx_urb exit: result=%d\n", result);
+	if (result) {
+		pr_err("ft1000_submit_rx_urb: submitting rx_urb %d failed\n",
+		       result);
+		return result;
+	}
+	//DEBUG("ft1000_submit_rx_urb exit: result=%d\n", result);
 
 	return 0;
 }
 
+
 //---------------------------------------------------------------------------
 // Function:    ft1000_open
 //
-- 
1.7.1

