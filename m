Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab1CJKxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 05:53:49 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:50672 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab1CJKwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 05:52:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=b5wHK5yjz6qGqrx50HBcjAxdceFNUscOLUbC8SyALwETkTLxVdpit8WCMbJU9LI+4y
         sNfHfLkI3oJf/4FK3sSybc1/wVfc+YE9mjQzulbNajWmyLC5GpNyuixde1M1Apcxz2lh
         x7xxzsxhdUoLfNFnQwA1B4d1gWxicgsyoX0Jk=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 15/21] staging: ft1000: Fix coding style in ft1000_copy_up_pkt function.
Date: Thu, 10 Mar 2011 11:51:29 +0100
Message-Id: <1299754295-8493-16-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
References: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |  167 ++++++++++++-------------
 1 files changed, 79 insertions(+), 88 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index f07b3ed..6a9e5fa 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -1085,109 +1085,100 @@ err:
 //              SUCCESS
 //
 //---------------------------------------------------------------------------
-static int ft1000_copy_up_pkt (struct urb *urb)
+static int ft1000_copy_up_pkt(struct urb *urb)
 {
 	struct ft1000_info *info = urb->context;
-    struct ft1000_device *ft1000dev = info->pFt1000Dev;
-    struct net_device *net = ft1000dev->net;
-
-    u16 tempword;
-    u16 len;
-    u16 lena; //mbelian
-    struct sk_buff *skb;
-    u16 i;
-    u8 *pbuffer=NULL;
-    u8 *ptemp=NULL;
-    u16 *chksum;
-
-
-    //DEBUG("ft1000_copy_up_pkt entered\n");
-
-    if ( ft1000dev->status & FT1000_STATUS_CLOSING)
-    {
-        DEBUG("network driver is closed, return\n");
-        return STATUS_SUCCESS;
-    }
-
-    // Read length
-    len = urb->transfer_buffer_length;
-    lena = urb->actual_length; //mbelian
-    //DEBUG("ft1000_copy_up_pkt: transfer_buffer_length=%d, actual_buffer_len=%d\n",
-      //       urb->transfer_buffer_length, urb->actual_length);
-
-    chksum = (u16 *)ft1000dev->rx_buf;
-
-    tempword = *chksum++;
-    for (i=1; i<7; i++)
-    {
-        tempword ^= *chksum++;
-    }
-
-    if  (tempword != *chksum)
-    {
-        info->stats.rx_errors ++;
-        ft1000_submit_rx_urb(info);
-        return STATUS_FAILURE;
-    }
-
-
-    //DEBUG("ft1000_copy_up_pkt: checksum is correct %x\n", *chksum);
-
-    skb = dev_alloc_skb(len+12+2);
-
-    if (skb == NULL)
-    {
-        DEBUG("ft1000_copy_up_pkt: No Network buffers available\n");
-        info->stats.rx_errors++;
-        ft1000_submit_rx_urb(info);
-        return STATUS_FAILURE;
-    }
-
-    pbuffer = (u8 *)skb_put(skb, len+12);
+	struct ft1000_device *ft1000dev = info->pFt1000Dev;
+	struct net_device *net = ft1000dev->net;
 
-    //subtract the number of bytes read already
-    ptemp = pbuffer;
+	u16 tempword;
+	u16 len;
+	u16 lena;		//mbelian
+	struct sk_buff *skb;
+	u16 i;
+	u8 *pbuffer = NULL;
+	u8 *ptemp = NULL;
+	u16 *chksum;
 
-    // fake MAC address
-    *pbuffer++ = net->dev_addr[0];
-    *pbuffer++ = net->dev_addr[1];
-    *pbuffer++ = net->dev_addr[2];
-    *pbuffer++ = net->dev_addr[3];
-    *pbuffer++ = net->dev_addr[4];
-    *pbuffer++ = net->dev_addr[5];
-    *pbuffer++ = 0x00;
-    *pbuffer++ = 0x07;
-    *pbuffer++ = 0x35;
-    *pbuffer++ = 0xff;
-    *pbuffer++ = 0xff;
-    *pbuffer++ = 0xfe;
+	//DEBUG("ft1000_copy_up_pkt entered\n");
 
+	if (ft1000dev->status & FT1000_STATUS_CLOSING) {
+		DEBUG("network driver is closed, return\n");
+		return STATUS_SUCCESS;
+	}
+	// Read length
+	len = urb->transfer_buffer_length;
+	lena = urb->actual_length;	//mbelian
+	//DEBUG("ft1000_copy_up_pkt: transfer_buffer_length=%d, actual_buffer_len=%d\n",
+	//       urb->transfer_buffer_length, urb->actual_length);
+
+	chksum = (u16 *) ft1000dev->rx_buf;
+
+	tempword = *chksum++;
+	for (i = 1; i < 7; i++)
+		tempword ^= *chksum++;
+
+	if (tempword != *chksum) {
+		info->stats.rx_errors++;
+		ft1000_submit_rx_urb(info);
+		return STATUS_FAILURE;
+	}
 
+	//DEBUG("ft1000_copy_up_pkt: checksum is correct %x\n", *chksum);
 
+	skb = dev_alloc_skb(len + 12 + 2);
 
-	memcpy(pbuffer, ft1000dev->rx_buf+sizeof(struct pseudo_hdr), len-sizeof(struct pseudo_hdr));
+	if (skb == NULL) {
+		DEBUG("ft1000_copy_up_pkt: No Network buffers available\n");
+		info->stats.rx_errors++;
+		ft1000_submit_rx_urb(info);
+		return STATUS_FAILURE;
+	}
 
-    //DEBUG("ft1000_copy_up_pkt: Data passed to Protocol layer\n");
-    /*for (i=0; i<len+12; i++)
-    {
-        DEBUG("ft1000_copy_up_pkt: Protocol Data: 0x%x\n ", *ptemp++);
-    }*/
+	pbuffer = (u8 *) skb_put(skb, len + 12);
+
+	/* subtract the number of bytes read already */
+	ptemp = pbuffer;
+
+	/* fake MAC address */
+	*pbuffer++ = net->dev_addr[0];
+	*pbuffer++ = net->dev_addr[1];
+	*pbuffer++ = net->dev_addr[2];
+	*pbuffer++ = net->dev_addr[3];
+	*pbuffer++ = net->dev_addr[4];
+	*pbuffer++ = net->dev_addr[5];
+	*pbuffer++ = 0x00;
+	*pbuffer++ = 0x07;
+	*pbuffer++ = 0x35;
+	*pbuffer++ = 0xff;
+	*pbuffer++ = 0xff;
+	*pbuffer++ = 0xfe;
+
+	memcpy(pbuffer, ft1000dev->rx_buf + sizeof(struct pseudo_hdr),
+	       len - sizeof(struct pseudo_hdr));
+
+	//DEBUG("ft1000_copy_up_pkt: Data passed to Protocol layer\n");
+	/*for (i=0; i<len+12; i++)
+	   {
+	   DEBUG("ft1000_copy_up_pkt: Protocol Data: 0x%x\n ", *ptemp++);
+	   } */
 
-    skb->dev = net;
+	skb->dev = net;
 
-    skb->protocol = eth_type_trans(skb, net);
-    skb->ip_summed = CHECKSUM_UNNECESSARY;
-    netif_rx(skb);
+	skb->protocol = eth_type_trans(skb, net);
+	skb->ip_summed = CHECKSUM_UNNECESSARY;
+	netif_rx(skb);
 
-    info->stats.rx_packets++;
-    // Add on 12 bytes for MAC address which was removed
-    info->stats.rx_bytes += (lena+12); //mbelian
+	info->stats.rx_packets++;
+	/* Add on 12 bytes for MAC address which was removed */
+	info->stats.rx_bytes += (lena + 12);	//mbelian
 
-    ft1000_submit_rx_urb(info);
-    //DEBUG("ft1000_copy_up_pkt exited\n");
-    return SUCCESS;
+	ft1000_submit_rx_urb(info);
+	//DEBUG("ft1000_copy_up_pkt exited\n");
+	return SUCCESS;
 }
 
+
 //---------------------------------------------------------------------------
 //
 // Function:   ft1000_submit_rx_urb
-- 
1.7.1

