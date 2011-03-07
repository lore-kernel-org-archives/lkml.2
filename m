Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab1CGIWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:22:14 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49168 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab1CGIV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:21:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=hgebeKScC+KFXudQKoa/0BqJPeC6fTzAqys2x3djN52yYMcCiyn3ZuwtDFC4AouNzE
         pXprueZP5zq7gFLfinPFXf/QkNVa480Q6FhA14pmRLdzaGoWWLWXo7B7sZ/S9gjA/m32
         fFnrQH0HgPGV7eqNhpaa0i6Y8c2buyvocpMQI=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 13/21] staging: ft1000: Fix coding style in ft1000_start_xmit function.
Date: Mon,  7 Mar 2011 09:21:18 +0100
Message-Id: <1299486086-7325-14-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
References: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   83 ++++++++++++-------------
 1 files changed, 39 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 0685070..8095dd2 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -1022,61 +1022,56 @@ static int ft1000_copy_down_pkt(struct net_device *netdev, u8 * packet, u16 len)
 static int ft1000_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ft1000_info *pInfo = netdev_priv(dev);
-    struct ft1000_device *pFt1000Dev= pInfo->pFt1000Dev;
-    u8 *pdata;
-    int maxlen, pipe;
-
-
-    //DEBUG(" ft1000_start_xmit() entered\n");
-
-    if ( skb == NULL )
-    {
-        DEBUG ("ft1000_hw: ft1000_start_xmit:skb == NULL!!!\n" );
-	return NETDEV_TX_OK;
-    }
-
-    if ( pFt1000Dev->status & FT1000_STATUS_CLOSING)
-    {
-        DEBUG("network driver is closed, return\n");
-	goto err;
-    }
-
-    //DEBUG("ft1000_start_xmit 1:length of packet = %d\n", skb->len);
-    pipe = usb_sndbulkpipe(pFt1000Dev->dev, pFt1000Dev->bulk_out_endpointAddr);
-    maxlen = usb_maxpacket(pFt1000Dev->dev, pipe, usb_pipeout(pipe));
-    //DEBUG("ft1000_start_xmit 2: pipe=%d dev->maxpacket  = %d\n", pipe, maxlen);
-
-    pdata = (u8 *)skb->data;
-    /*for (i=0; i<skb->len; i++)
-        DEBUG("skb->data[%d]=%x    ", i, *(skb->data+i));
+	struct ft1000_device *pFt1000Dev = pInfo->pFt1000Dev;
+	u8 *pdata;
+	int maxlen, pipe;
 
-    DEBUG("\n");*/
+	//DEBUG(" ft1000_start_xmit() entered\n");
 
+	if (skb == NULL) {
+		DEBUG("ft1000_hw: ft1000_start_xmit:skb == NULL!!!\n");
+		return NETDEV_TX_OK;
+	}
 
-    if (pInfo->mediastate == 0)
-    {
-        /* Drop packet is mediastate is down */
-        DEBUG("ft1000_hw:ft1000_start_xmit:mediastate is down\n");
-	goto err;
-    }
+	if (pFt1000Dev->status & FT1000_STATUS_CLOSING) {
+		DEBUG("network driver is closed, return\n");
+		goto err;
+	}
+	//DEBUG("ft1000_start_xmit 1:length of packet = %d\n", skb->len);
+	pipe =
+	    usb_sndbulkpipe(pFt1000Dev->dev, pFt1000Dev->bulk_out_endpointAddr);
+	maxlen = usb_maxpacket(pFt1000Dev->dev, pipe, usb_pipeout(pipe));
+	//DEBUG("ft1000_start_xmit 2: pipe=%d dev->maxpacket  = %d\n", pipe, maxlen);
+
+	pdata = (u8 *) skb->data;
+	/*for (i=0; i<skb->len; i++)
+	   DEBUG("skb->data[%d]=%x    ", i, *(skb->data+i));
+
+	   DEBUG("\n"); */
+
+	if (pInfo->mediastate == 0) {
+		/* Drop packet is mediastate is down */
+		DEBUG("ft1000_hw:ft1000_start_xmit:mediastate is down\n");
+		goto err;
+	}
 
-    if ( (skb->len < ENET_HEADER_SIZE) || (skb->len > ENET_MAX_SIZE) )
-    {
-        /* Drop packet which has invalid size */
-        DEBUG("ft1000_hw:ft1000_start_xmit:invalid ethernet length\n");
-	goto err;
-    }
+	if ((skb->len < ENET_HEADER_SIZE) || (skb->len > ENET_MAX_SIZE)) {
+		/* Drop packet which has invalid size */
+		DEBUG("ft1000_hw:ft1000_start_xmit:invalid ethernet length\n");
+		goto err;
+	}
 //mbelian
-	ft1000_copy_down_pkt(dev, (pdata+ENET_HEADER_SIZE-2),
-				skb->len - ENET_HEADER_SIZE + 2);
+	ft1000_copy_down_pkt(dev, (pdata + ENET_HEADER_SIZE - 2),
+			     skb->len - ENET_HEADER_SIZE + 2);
 
 err:
 	dev_kfree_skb(skb);
-    //DEBUG(" ft1000_start_xmit() exit\n");
+	//DEBUG(" ft1000_start_xmit() exit\n");
 
 	return NETDEV_TX_OK;
 }
 
+
 //---------------------------------------------------------------------------
 //
 // Function:   ft1000_copy_up_pkt
-- 
1.7.1

