Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab1CJKyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 05:54:47 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46557 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab1CJKwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 05:52:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=kAyleQWvNSFrqIsLo4HgkAdc1x4O+9eGOCHCFdJAadWMQnNl9gaxCN6ImWXbJK64AT
         ypAl4wlnsqEPfTxNj9JR5sAtZ3Rp14LguhrEtzt1pBsuttueKv2qOyEMJXlMU7eGxgzX
         q2vhFTkFsFVRoEfce6s90XKWwaoL793L0w9s8=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 12/21] staging: ft1000: Fix coding style in ft1000_copy_down_pkt function.
Date: Thu, 10 Mar 2011 11:51:26 +0100
Message-Id: <1299754295-8493-13-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
References: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   75 +++++++++++-------------
 1 files changed, 34 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 958292e..bb1e9d6 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -929,37 +929,31 @@ static void ft1000_usb_transmit_complete(struct urb *urb)
 //              SUCCESS
 //
 //---------------------------------------------------------------------------
-static int ft1000_copy_down_pkt (struct net_device *netdev, u8 *packet, u16 len)
+static int ft1000_copy_down_pkt(struct net_device *netdev, u8 * packet, u16 len)
 {
 	struct ft1000_info *pInfo = netdev_priv(netdev);
-    struct ft1000_device *pFt1000Dev = pInfo->pFt1000Dev;
-
+	struct ft1000_device *pFt1000Dev = pInfo->pFt1000Dev;
 
 	int count, ret;
-    u8 *t;
+	u8 *t;
 	struct pseudo_hdr hdr;
 
-    if (!pInfo->CardReady)
-    {
-
-        DEBUG("ft1000_copy_down_pkt::Card Not Ready\n");
-	return -ENODEV;
-
-    }
-
+	if (!pInfo->CardReady) {
+		DEBUG("ft1000_copy_down_pkt::Card Not Ready\n");
+		return -ENODEV;
+	}
 
-    //DEBUG("ft1000_copy_down_pkt() entered, len = %d\n", len);
+	//DEBUG("ft1000_copy_down_pkt() entered, len = %d\n", len);
 
 	count = sizeof(struct pseudo_hdr) + len;
-    if(count > MAX_BUF_SIZE)
-    {
-        DEBUG("Error:ft1000_copy_down_pkt:Message Size Overflow!\n");
-    	DEBUG("size = %d\n", count);
-	return -EINVAL;
-    }
+	if (count > MAX_BUF_SIZE) {
+		DEBUG("Error:ft1000_copy_down_pkt:Message Size Overflow!\n");
+		DEBUG("size = %d\n", count);
+		return -EINVAL;
+	}
 
-    if ( count % 4)
-        count = count + (4- (count %4) );
+	if (count % 4)
+		count = count + (4 - (count % 4));
 
 	memset(&hdr, 0, sizeof(struct pseudo_hdr));
 
@@ -972,46 +966,45 @@ static int ft1000_copy_down_pkt (struct net_device *netdev, u8 *packet, u16 len)
 	hdr.control = 0x00;
 
 	hdr.checksum = hdr.length ^ hdr.source ^ hdr.destination ^
-			hdr.portdest ^ hdr.portsrc ^ hdr.sh_str_id ^
-			hdr.control;
+	    hdr.portdest ^ hdr.portsrc ^ hdr.sh_str_id ^ hdr.control;
 
 	memcpy(&pFt1000Dev->tx_buf[0], &hdr, sizeof(hdr));
 	memcpy(&(pFt1000Dev->tx_buf[sizeof(struct pseudo_hdr)]), packet, len);
 
-    netif_stop_queue(netdev);
-
-    //DEBUG ("ft1000_copy_down_pkt: count = %d\n", count);
+	netif_stop_queue(netdev);
 
-    usb_fill_bulk_urb(pFt1000Dev->tx_urb,
-                      pFt1000Dev->dev,
-                      usb_sndbulkpipe(pFt1000Dev->dev, pFt1000Dev->bulk_out_endpointAddr),
-                      pFt1000Dev->tx_buf,
-                      count,
-                      ft1000_usb_transmit_complete,
-                      (void*)pFt1000Dev);
+	//DEBUG ("ft1000_copy_down_pkt: count = %d\n", count);
 
-    t = (u8 *)pFt1000Dev->tx_urb->transfer_buffer;
-    //DEBUG("transfer_length=%d\n", pFt1000Dev->tx_urb->transfer_buffer_length);
-    /*for (i=0; i<count; i++ )
-    {
-       DEBUG("%x    ", *t++ );
-    }*/
+	usb_fill_bulk_urb(pFt1000Dev->tx_urb,
+			  pFt1000Dev->dev,
+			  usb_sndbulkpipe(pFt1000Dev->dev,
+					  pFt1000Dev->bulk_out_endpointAddr),
+			  pFt1000Dev->tx_buf, count,
+			  ft1000_usb_transmit_complete, (void *)pFt1000Dev);
 
+	t = (u8 *) pFt1000Dev->tx_urb->transfer_buffer;
+	//DEBUG("transfer_length=%d\n", pFt1000Dev->tx_urb->transfer_buffer_length);
+	/*for (i=0; i<count; i++ )
+	   {
+	   DEBUG("%x    ", *t++ );
+	   } */
 
 	ret = usb_submit_urb(pFt1000Dev->tx_urb, GFP_ATOMIC);
+
 	if (ret) {
 		DEBUG("ft1000 failed tx_urb %d\n", ret);
 		return ret;
 	} else {
 		pInfo->stats.tx_packets++;
-		pInfo->stats.tx_bytes += (len+14);
+		pInfo->stats.tx_bytes += (len + 14);
 	}
 
-    //DEBUG("ft1000_copy_down_pkt() exit\n");
+	//DEBUG("ft1000_copy_down_pkt() exit\n");
 
 	return 0;
 }
 
+
 //---------------------------------------------------------------------------
 // Function:    ft1000_start_xmit
 //
-- 
1.7.1

