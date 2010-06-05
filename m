Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275Ab0FEKiH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 06:38:07 -0400
Received: from outbound-mail03.westnet.com.au ([203.10.1.244]:3094 "EHLO
	outbound-mail03.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933159Ab0FEKgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 06:36:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlJPAPbECUw6B9wNPGdsb2JhbACHb5ZlDAEBAQE1LbAkjUSCW4I8BINI
X-IronPort-AV: E=Sophos;i="4.53,366,1272816000"; 
   d="scan'208";a="77635037"
From: Mike Gilks <mike.kernel@gilksonline.com>
To: gregkh@suse.de, mchehab@redhat.com, julia@diku.dk, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Gilks <mike.kernel@gilksonline.com>
Subject: [PATCH 09/12] staging: rtl8192u: fix c99 issues in file r8192U_core.c to line 3000 This is a patch to r8192U_core.c file to begin to rid the file of c99 style comments
Date: Sat,  5 Jun 2010 18:36:24 +0800
Message-Id: <1275734187-26583-10-git-send-email-mike.kernel@gilksonline.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1275734187-26583-9-git-send-email-mike.kernel@gilksonline.com>
References: <1275734187-26583-1-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-2-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-3-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-4-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-5-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-6-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-7-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-8-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-9-git-send-email-mike.kernel@gilksonline.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Gilks <mike.kernel@gilksonline.com>
---
 drivers/staging/rtl8192u/r8192U_core.c |  583 ++++++++++++++++++--------------
 1 files changed, 335 insertions(+), 248 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 26f671f..a7b43a0 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -854,30 +854,34 @@ void rtl8192_update_msr(struct net_device *dev)
 void rtl8192_set_chan(struct net_device *dev,short ch)
 {
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
-//	u32 tx;
+	/* u32 tx; */
 	RT_TRACE(COMP_CH, "=====>%s()====ch:%d\n", __func__, ch);
 	priv->chan=ch;
 
-	/* this hack should avoid frame TX during channel setting*/
+	/* this hack should avoid frame TX during channel setting */
 
 
-//	tx = read_nic_dword(dev,TX_CONF);
-//	tx &= ~TX_LOOPBACK_MASK;
+	/* tx = read_nic_dword(dev,TX_CONF); */
+	/* tx &= ~TX_LOOPBACK_MASK; */
 
 #ifndef LOOP_TEST
-//	write_nic_dword(dev,TX_CONF, tx |( TX_LOOPBACK_MAC<<TX_LOOPBACK_SHIFT));
+	/* write_nic_dword(dev, TX_CONF, tx |
+	 *			( TX_LOOPBACK_MAC<<TX_LOOPBACK_SHIFT));
+	 */
 
-	//need to implement rf set channel here WB
+	/* need to implement rf set channel here WB */
 
 	if (priv->rf_set_chan)
-	priv->rf_set_chan(dev,priv->chan);
+	priv->rf_set_chan(dev, priv->chan);
 	mdelay(10);
-//	write_nic_dword(dev,TX_CONF,tx | (TX_LOOPBACK_NONE<<TX_LOOPBACK_SHIFT));
+	/* write_nic_dword(dev, TX_CONF, tx |
+	 *				(TX_LOOPBACK_NONE<<TX_LOOPBACK_SHIFT));
+	 */
 #endif
 }
 
 static void rtl8192_rx_isr(struct urb *urb);
-//static void rtl8192_rx_isr(struct urb *rx_urb);
+/* static void rtl8192_rx_isr(struct urb *rx_urb); */
 
 u32 get_rxpacket_shiftbytes_819xusb(struct ieee80211_rx_stats *pstats)
 {
@@ -909,21 +913,21 @@ static int rtl8192_rx_initiate(struct net_device*dev)
 			kfree_skb(skb);
 			break;
 		}
-//		printk("nomal packet IN request!\n");
+		/* printk("nomal packet IN request!\n"); */
 		usb_fill_bulk_urb(entry, priv->udev,
 				  usb_rcvbulkpipe(priv->udev, 3), skb_tail_pointer(skb),
 				  RX_URB_SIZE, rtl8192_rx_isr, skb);
 		info = (struct rtl8192_rx_info *) skb->cb;
 		info->urb = entry;
 		info->dev = dev;
-		info->out_pipe = 3; //denote rx normal packet queue
+		info->out_pipe = 3;	/* denote rx normal packet queue */
 		skb_queue_tail(&priv->rx_queue, skb);
 		usb_submit_urb(entry, GFP_KERNEL);
 	}
 
 	/* command packet rx procedure */
 	while (skb_queue_len(&priv->rx_queue) < MAX_RX_URB + 3) {
-//		printk("command packet IN request!\n");
+		/* printk("command packet IN request!\n"); */
 		skb = __dev_alloc_skb(RX_URB_SIZE ,GFP_KERNEL);
 		if (!skb)
 			break;
@@ -938,7 +942,7 @@ static int rtl8192_rx_initiate(struct net_device*dev)
 		info = (struct rtl8192_rx_info *) skb->cb;
 		info->urb = entry;
 		info->dev = dev;
-		   info->out_pipe = 9; //denote rx cmd packet queue
+		   info->out_pipe = 9;	/* denote rx cmd packet queue */
 		skb_queue_tail(&priv->rx_queue, skb);
 		usb_submit_urb(entry, GFP_KERNEL);
 	}
@@ -957,7 +961,7 @@ void rtl8192_set_rxconf(struct net_device *dev)
 	rxconf = rxconf | RCR_ADF;
 	rxconf = rxconf | RCR_AB;
 	rxconf = rxconf | RCR_AM;
-	//rxconf = rxconf | RCR_ACF;
+	/* rxconf = rxconf | RCR_ACF; */
 
 	if (dev->flags & IFF_PROMISC) {DMESG ("NIC in promisc mode");}
 
@@ -987,11 +991,11 @@ void rtl8192_set_rxconf(struct net_device *dev)
 	rxconf = rxconf &~ MAX_RX_DMA_MASK;
 	rxconf = rxconf | ((u32)7<<RCR_MXDMA_OFFSET);
 
-//	rxconf = rxconf | (1<<RX_AUTORESETPHY_SHIFT);
+	/* rxconf = rxconf | (1<<RX_AUTORESETPHY_SHIFT); */
 	rxconf = rxconf | RCR_ONLYERLPKT;
 
-//	rxconf = rxconf &~ RCR_CS_MASK;
-//	rxconf = rxconf | (1<<RCR_CS_SHIFT);
+	/* rxconf = rxconf &~ RCR_CS_MASK; */
+	/* rxconf = rxconf | (1<<RCR_CS_SHIFT); */
 
 	write_nic_dword(dev, RCR, rxconf);
 
@@ -999,16 +1003,19 @@ void rtl8192_set_rxconf(struct net_device *dev)
 	DMESG("rxconf: %x %x",rxconf ,read_nic_dword(dev,RCR));
 	#endif
 }
-//wait to be removed
+
+/* wait to be removed */
 void rtl8192_rx_enable(struct net_device *dev)
 {
-	//u8 cmd;
+	/* u8 cmd; */
 
-	//struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
+	/* struct r8192_priv *priv =
+	 *			(struct r8192_priv *)ieee80211_priv(dev);
+	 */
 
 	rtl8192_rx_initiate(dev);
 
-//	rtl8192_set_rxconf(dev);
+	/* rtl8192_set_rxconf(dev); */
 }
 
 
@@ -1110,7 +1117,7 @@ static void rtl8192_rx_isr(struct urb *urb)
 		priv->stats.rxstaterr++;
 		priv->ieee80211->stats.rx_errors++;
 		usb_free_urb(urb);
-	//	printk("%s():rx status err\n",__func__);
+		/* printk("%s():rx status err\n", __func__); */
 		return;
 	}
 	skb_unlink(skb, &priv->rx_queue);
@@ -1122,7 +1129,7 @@ static void rtl8192_rx_isr(struct urb *urb)
 	skb = dev_alloc_skb(RX_URB_SIZE);
 	if (unlikely(!skb)) {
 		usb_free_urb(urb);
-		printk("%s():can,t alloc skb\n",__func__);
+		printk("%s():can,t alloc skb\n", __func__);
 		/* TODO check rx queue length and refill *somewhere* */
 		return;
 	}
@@ -1152,7 +1159,9 @@ rtl819xusb_rx_command_packet(
 {
 	u32	status;
 
-	//RT_TRACE(COMP_RECV, DBG_TRACE, ("---> RxCommandPacketHandle819xUsb()\n"));
+	/* RT_TRACE(COMP_RECV, DBG_TRACE,
+	 *			("---> RxCommandPacketHandle819xUsb()\n"));
+	 */
 
 	status = cmpk_message_handle_rx(dev, pstats);
 	if (status)
@@ -1161,23 +1170,27 @@ rtl819xusb_rx_command_packet(
 	}
 	else
 	{
-		//RT_TRACE(COMP_RECV, DBG_TRACE, ("RxCommandPacketHandle819xUsb: It is not a command packet\n"));
+		/* RT_TRACE(COMP_RECV, DBG_TRACE,
+		 *			("RxCommandPacketHandle819xUsb:
+		 *			It is not a command packet\n"));
+		 */
 	}
 
-	//RT_TRACE(COMP_RECV, DBG_TRACE, ("<--- RxCommandPacketHandle819xUsb()\n"));
+	/* RT_TRACE(COMP_RECV, DBG_TRACE,
+	 *			("<--- RxCommandPacketHandle819xUsb()\n"));
+	 */
 	return status;
 }
 
-
 void rtl8192_data_hard_stop(struct net_device *dev)
 {
-	//FIXME !!
+	/* FIXME !! */
 }
 
 
 void rtl8192_data_hard_resume(struct net_device *dev)
 {
-	// FIXME !!
+	/* FIXME !! */
 }
 
 /* this function TX data frames when the ieee80211 stack requires this.
@@ -1197,19 +1210,21 @@ void rtl8192_hard_data_xmit(struct sk_buff *skb, struct net_device *dev, int rat
 	spin_lock_irqsave(&priv->tx_lock,flags);
 
 	memcpy((unsigned char *)(skb->cb),&dev,sizeof(dev));
-//	tcb_desc->RATRIndex = 7;
-//	tcb_desc->bTxDisableRateFallBack = 1;
-//	tcb_desc->bTxUseDriverAssingedRate = 1;
+	/* tcb_desc->RATRIndex = 7; */
+	/* tcb_desc->bTxDisableRateFallBack = 1; */
+	/* tcb_desc->bTxUseDriverAssingedRate = 1; */
 	tcb_desc->bTxEnableFwCalcDur = 1;
 	skb_push(skb, priv->ieee80211->tx_headroom);
 	ret = rtl8192_tx(dev, skb);
 
-	//priv->ieee80211->stats.tx_bytes+=(skb->len - priv->ieee80211->tx_headroom);
-	//priv->ieee80211->stats.tx_packets++;
+	/* priv->ieee80211->stats.tx_bytes +=
+	 *			(skb->len - priv->ieee80211->tx_headroom);
+	 */
+	/* priv->ieee80211->stats.tx_packets++; */
 
 	spin_unlock_irqrestore(&priv->tx_lock,flags);
 
-//	return ret;
+	/* return ret; */
 	return;
 }
 
@@ -1271,9 +1286,8 @@ struct sk_buff *DrvAggr_Aggregation(struct net_device *dev, struct ieee80211_drv
 	tx_desc_819x_usb_aggr_subframe *tx_agg_desc = NULL;
 	tx_fwinfo_819x_usb	       *tx_fwinfo = NULL;
 
-	//
-	// Local variable initialization.
-	//
+	/* Local variable initialization. */
+	
 	/* first skb initialization */
 	skb = pSendList->tx_agg_frames[0];
 	TotalLength = skb->len;
@@ -1292,17 +1306,19 @@ struct sk_buff *DrvAggr_Aggregation(struct net_device *dev, struct ieee80211_drv
 	memset(agg_skb->data, 0, agg_skb->len);
 	skb_reserve(agg_skb, ieee->tx_headroom);
 
-//	RT_DEBUG_DATA(COMP_SEND, skb->cb, sizeof(skb->cb));
-	/* reserve info for first subframe Tx descriptor to be set in the tx function */
+	/* RT_DEBUG_DATA(COMP_SEND, skb->cb, sizeof(skb->cb)); */
+	/* reserve info for first subframe Tx descriptor to be set
+	 *						in the tx function
+	 */
 	skb = pSendList->tx_agg_frames[0];
 	tcb_desc = (cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
 	tcb_desc->drv_agg_enable = 1;
 	tcb_desc->pkt_size = skb->len;
 	tcb_desc->DrvAggrNum = pSendList->nr_drv_agg_frames;
 	printk("DrvAggNum = %d\n", tcb_desc->DrvAggrNum);
-//	RT_DEBUG_DATA(COMP_SEND, skb->cb, sizeof(skb->cb));
-//	printk("========>skb->data ======> \n");
-//	RT_DEBUG_DATA(COMP_SEND, skb->data, skb->len);
+	/* RT_DEBUG_DATA(COMP_SEND, skb->cb, sizeof(skb->cb)); */
+	/* printk("========>skb->data ======> \n"); */
+	/* RT_DEBUG_DATA(COMP_SEND, skb->data, skb->len); */
 	memcpy(agg_skb->cb, skb->cb, sizeof(skb->cb));
 	memcpy(skb_put(agg_skb,skb->len),skb->data,skb->len);
 
@@ -1322,11 +1338,12 @@ struct sk_buff *DrvAggr_Aggregation(struct net_device *dev, struct ieee80211_drv
 		tx_fwinfo->TxRate = MRateToHwRate8190Pci(tcb_desc->data_rate);
 		tx_fwinfo->EnableCPUDur = tcb_desc->bTxEnableFwCalcDur;
 		tx_fwinfo->Short = QueryIsShort(tx_fwinfo->TxHT, tx_fwinfo->TxRate, tcb_desc);
-		if(tcb_desc->bAMPDUEnable) {//AMPDU enabled
+		if(tcb_desc->bAMPDUEnable) {		/* AMPDU enabled */
 			tx_fwinfo->AllowAggregation = 1;
 			/* DWORD 1 */
 			tx_fwinfo->RxMF = tcb_desc->ampdu_factor;
-			tx_fwinfo->RxAMD = tcb_desc->ampdu_density&0x07;//ampdudensity
+			tx_fwinfo->RxAMD = tcb_desc->ampdu_density&0x07;
+			/* ampdudensity */
 		} else {
 			tx_fwinfo->AllowAggregation = 0;
 			/* DWORD 1 */
@@ -1350,7 +1367,10 @@ struct sk_buff *DrvAggr_Aggregation(struct net_device *dev, struct ieee80211_drv
 		{
 			if(tcb_desc->bPacketBW) {
 				tx_fwinfo->TxBandwidth = 1;
-				tx_fwinfo->TxSubCarrier = 0;    //By SD3's Jerry suggestion, use duplicated mode
+				tx_fwinfo->TxSubCarrier = 0;
+				/* By SD3's Jerry suggestion,
+				 * use duplicated mode
+				 */
 			} else {
 				tx_fwinfo->TxBandwidth = 0;
 				tx_fwinfo->TxSubCarrier = priv->nCur40MhzPrimeSC;
@@ -1363,8 +1383,8 @@ struct sk_buff *DrvAggr_Aggregation(struct net_device *dev, struct ieee80211_drv
 		/* Fill Tx descriptor */
 		memset(tx_agg_desc, 0, sizeof(tx_desc_819x_usb_aggr_subframe));
 		/* DWORD 0 */
-		//tx_agg_desc->LINIP = 0;
-		//tx_agg_desc->CmdInit = 1;
+		/* tx_agg_desc->LINIP = 0; */
+		/* tx_agg_desc->CmdInit = 1; */
 		tx_agg_desc->Offset =  sizeof(tx_fwinfo_819x_usb) + 8;
 		/* already raw data, need not to substract header length */
 		tx_agg_desc->PktSize = skb->len & 0xffff;
@@ -1373,7 +1393,7 @@ struct sk_buff *DrvAggr_Aggregation(struct net_device *dev, struct ieee80211_drv
 		tx_agg_desc->SecCAMID= 0;
 		tx_agg_desc->RATid = tcb_desc->RATRIndex;
 		{
-			//MPDUOverhead = 0;
+			/* MPDUOverhead = 0; */
 			tx_agg_desc->NoEnc = 1;
 		}
 		tx_agg_desc->SecType = 0x0;
@@ -1409,9 +1429,13 @@ struct sk_buff *DrvAggr_Aggregation(struct net_device *dev, struct ieee80211_drv
 
 		tx_agg_desc->OWN = 1;
 
-		//DWORD 2
-		/* According windows driver, it seems that there no need to fill this field */
-		//tx_agg_desc->TxBufferSize= (u32)(skb->len - USB_HWDESC_HEADER_LEN);
+		/* DWORD 2 */
+		/* According windows driver,
+		 * it seems that there no need to fill this field
+		 */
+		/* tx_agg_desc->TxBufferSize= (u32)
+		 *			(skb->len - USB_HWDESC_HEADER_LEN);
+		 */
 
 		/* to fill next packet */
 		skb_put(agg_skb,TX_PACKET_DRVAGGR_SUBFRAME_SHIFT_BYTES);
@@ -1426,9 +1450,11 @@ struct sk_buff *DrvAggr_Aggregation(struct net_device *dev, struct ieee80211_drv
 }
 
 /* NOTE:
-	This function return a list of PTCB which is proper to be aggregate with the input TCB.
-	If no proper TCB is found to do aggregation, SendList will only contain the input TCB.
-*/
+ *	This function return a list of PTCB which is proper to be
+ *	 aggregate with the input TCB.
+ *	If no proper TCB is found to do aggregation,
+ *	 SendList will only contain the input TCB.
+ */
 u8 DrvAggr_GetAggregatibleList(struct net_device *dev, struct sk_buff *skb,
 		struct ieee80211_drv_agg_txb *pSendList)
 {
@@ -1458,8 +1484,8 @@ static void rtl8192_tx_isr(struct urb *tx_urb)
 	struct r8192_priv *priv = NULL;
 	cb_desc *tcb_desc = (cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
 	u8  queue_index = tcb_desc->queue_index;
-//	bool bToSend0Byte;
-//	u16 BufLen = skb->len;
+	/* bool bToSend0Byte; */
+	/* u16 BufLen = skb->len; */
 
 	memcpy(&dev,(struct net_device*)(skb->cb),sizeof(struct net_device*));
 	priv = ieee80211_priv(dev);
@@ -1467,15 +1493,20 @@ static void rtl8192_tx_isr(struct urb *tx_urb)
 	if(tcb_desc->queue_index != TXCMD_QUEUE) {
 		if(tx_urb->status == 0) {
 			dev->trans_start = jiffies;
-			// As act as station mode, destion shall be  unicast address.
-			//priv->ieee80211->stats.tx_bytes+=(skb->len - priv->ieee80211->tx_headroom);
-			//priv->ieee80211->stats.tx_packets++;
+			/* As act as station mode, destion shall be
+			 *				 unicast address.
+			 */
+			/* priv->ieee80211->stats.tx_bytes +=
+			 *	(skb->len - priv->ieee80211->tx_headroom);
+			 */
+			/* priv->ieee80211->stats.tx_packets++; */
 			priv->stats.txoktotal++;
 			priv->ieee80211->LinkDetectInfo.NumTxOkInPeriod++;
-			priv->stats.txbytesunicast += (skb->len - priv->ieee80211->tx_headroom);
+			priv->stats.txbytesunicast +=
+				(skb->len - priv->ieee80211->tx_headroom);
 		} else {
 			priv->ieee80211->stats.tx_errors++;
-			//priv->stats.txmanageerr++;
+			/* priv->stats.txmanageerr++; */
 			/* TODO */
 		}
 	}
@@ -1488,16 +1519,18 @@ static void rtl8192_tx_isr(struct urb *tx_urb)
 	}
 
 	{
-		//
-		// Handle HW Beacon:
-		// We had transfer our beacon frame to host controler at this moment.
-		//
-		//
-		// Caution:
-		// Handling the wait queue of command packets.
-		// For Tx command packets, we must not do TCB fragment because it is not handled right now.
-		// We must cut the packets to match the size of TX_CMD_PKT before we send it.
-		//
+		
+		/* Handle HW Beacon:
+		 * We had transfer our beacon frame to host controler
+		 * at this moment.
+		 *
+		 * Caution:
+		 * Handling the wait queue of command packets.
+		 * For Tx command packets, we must not do TCB fragment
+		 *			 because it is not handled right now.
+		 * We must cut the packets to match the size of TX_CMD_PKT
+		 * before we send it.
+		 */
 
 		/* Handle MPDU in wait queue. */
 		if(queue_index != BEACON_QUEUE) {
@@ -1507,12 +1540,13 @@ static void rtl8192_tx_isr(struct urb *tx_urb)
 				if(NULL != (skb = skb_dequeue(&(priv->ieee80211->skb_waitQ[queue_index]))))
 					priv->ieee80211->softmac_hard_start_xmit(skb, dev);
 
-				return; //modified by david to avoid further processing AMSDU
+				return;
+		/* modified by david to avoid further processing AMSDU */
 			}
 #ifdef USB_TX_DRIVER_AGGREGATION_ENABLE
 			else if ((skb_queue_len(&priv->ieee80211->skb_drv_aggQ[queue_index])!= 0)&&\
 				(!(priv->ieee80211->queue_stop))) {
-				// Tx Driver Aggregation process
+				/*  Tx Driver Aggregation process */
 				/* The driver will aggregation the packets according to the following stets
 				 * 1. check whether there's tx irq available, for it's a completion return
 				 *    function, it should contain enough tx irq;
@@ -1520,7 +1554,7 @@ static void rtl8192_tx_isr(struct urb *tx_urb)
 				 * 3. intialize sendlist, check whether the to-be send packet no greater than 1
 				 * 4. aggregation the packets, and fill firmware info and tx desc to it, etc.
 				 * 5. check whehter the packet could be sent, otherwise just insert to wait head
-				 * */
+				 */
 				skb = skb_dequeue(&priv->ieee80211->skb_drv_aggQ[queue_index]);
 				if(!check_nic_enough_desc(dev, queue_index)) {
 					skb_queue_head(&(priv->ieee80211->skb_drv_aggQ[queue_index]), skb);
@@ -1637,14 +1671,14 @@ void rtl8192_update_cap(struct net_device* dev, u16 cap)
 		tmp |= BRSR_AckShortPmb;
 	write_nic_dword(dev, RRSR, tmp);
 
-	if (net->mode & (IEEE_G|IEEE_N_24G))
-	{
+	if (net->mode & (IEEE_G|IEEE_N_24G)) {
 		u8 slot_time = 0;
-		if ((cap & WLAN_CAPABILITY_SHORT_SLOT)&&(!priv->ieee80211->pHTInfo->bCurrentRT2RTLongSlotTime))
-		{//short slot time
+		if ((cap & WLAN_CAPABILITY_SHORT_SLOT) && (!priv->ieee80211->pHTInfo->bCurrentRT2RTLongSlotTime)) {
+			/* short slot time */
 			slot_time = SHORT_SLOT_TIME;
 		}
-		else //long slot time
+		else
+			/* long slot time */
 			slot_time = NON_SHORT_SLOT_TIME;
 		priv->slot_time = slot_time;
 		write_nic_byte(dev, SLOT_TIME, slot_time);
@@ -1665,32 +1699,30 @@ void rtl8192_net_update(struct net_device *dev)
 
 	write_nic_dword(dev,BSSIDR,((u32*)net->bssid)[0]);
 	write_nic_word(dev,BSSIDR+4,((u16*)net->bssid)[2]);
-	//for(i=0;i<ETH_ALEN;i++)
-	//	write_nic_byte(dev,BSSID+i,net->bssid[i]);
+	/* for(i = 0; i < ETH_ALEN; i++)
+	 *	write_nic_byte(dev, BSSID + i, net->bssid[i]);
+	 */
 
 	rtl8192_update_msr(dev);
-//	rtl8192_update_cap(dev, net->capability);
-	if (priv->ieee80211->iw_mode == IW_MODE_ADHOC)
-	{
-	write_nic_word(dev, ATIMWND, 2);
-	write_nic_word(dev, BCN_DMATIME, 1023);
-	write_nic_word(dev, BCN_INTERVAL, net->beacon_interval);
-//	write_nic_word(dev, BcnIntTime, 100);
-	write_nic_word(dev, BCN_DRV_EARLY_INT, 1);
-	write_nic_byte(dev, BCN_ERR_THRESH, 100);
+	/* rtl8192_update_cap(dev, net->capability); */
+	if (priv->ieee80211->iw_mode == IW_MODE_ADHOC) {
+		write_nic_word(dev, ATIMWND, 2);
+		write_nic_word(dev, BCN_DMATIME, 1023);
+		write_nic_word(dev, BCN_INTERVAL, net->beacon_interval);
+		/* write_nic_word(dev, BcnIntTime, 100); */
+		write_nic_word(dev, BCN_DRV_EARLY_INT, 1);
+		write_nic_byte(dev, BCN_ERR_THRESH, 100);
 		BcnTimeCfg |= (BcnCW<<BCN_TCFG_CW_SHIFT);
-	// TODO: BcnIFS may required to be changed on ASIC
+		/* TODO: BcnIFS may required to be changed on ASIC */
 		BcnTimeCfg |= BcnIFS<<BCN_TCFG_IFS;
 
-	write_nic_word(dev, BCN_TCFG, BcnTimeCfg);
+		write_nic_word(dev, BCN_TCFG, BcnTimeCfg);
 	}
 
-
-
 }
 
-//temporary hw beacon is not used any more.
-//open it when necessary
+/* temporary hw beacon is not used any more. */
+/* open it when necessary */
 void rtl819xusb_beacon_tx(struct net_device *dev,u16  tx_rate)
 {
 
@@ -1715,23 +1747,22 @@ u16 ComputeTxTime(
 	u16	N_DBPS;
 	u16	Ceiling;
 
-	if( rtl8192_IsWirelessBMode(DataRate) )
+	if ( rtl8192_IsWirelessBMode(DataRate) )
 	{
-		if( bManagementFrame || !bShortPreamble || DataRate == 10 )
-		{	// long preamble
-			FrameTime = (u16)(144+48+(FrameLength*8/(DataRate/10)));
-		}
-		else
-		{	// Short preamble
-			FrameTime = (u16)(72+24+(FrameLength*8/(DataRate/10)));
+		if (bManagementFrame || !bShortPreamble || DataRate == 10 ) {
+			/* long preamble */
+			FrameTime = (u16)(144 + 48 + (FrameLength * 8 / (DataRate / 10)));
+		} else {
+			/* Short preamble */
+			FrameTime = (u16)(72 + 24 + (FrameLength * 8 / (DataRate / 10)));
 		}
-		if( ( FrameLength*8 % (DataRate/10) ) != 0 ) //Get the Ceilling
+		if ((FrameLength * 8 % (DataRate / 10)) != 0 )	/* Get the Ceilling */
 				FrameTime ++;
-	} else {	//802.11g DSSS-OFDM PLCP length field calculation.
+	} else {	/* 802.11g DSSS-OFDM PLCP length field calculation. */
 		N_DBPS = N_DBPSOfRate(DataRate);
-		Ceiling = (16 + 8*FrameLength + 6) / N_DBPS
-				+ (((16 + 8*FrameLength + 6) % N_DBPS) ? 1 : 0);
-		FrameTime = (u16)(16 + 4 + 4*Ceiling + 6);
+		Ceiling = (16 + 8 * FrameLength + 6) / N_DBPS
+				+ (((16 + 8 * FrameLength + 6) % N_DBPS) ? 1 : 0);
+		FrameTime = (u16)(16 + 4 + 4 * Ceiling + 6);
 	}
 	return FrameTime;
 }
@@ -1799,16 +1830,16 @@ unsigned int txqueue2outpipe(struct r8192_priv* priv,unsigned int tx_queue) {
 short rtl819xU_tx_cmd(struct net_device *dev, struct sk_buff *skb)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	//u8			*tx;
+	/* u8			*tx; */
 	int			status;
 	struct urb		*tx_urb;
-	//int			urb_buf_len;
+	/* int			urb_buf_len; */
 	unsigned int 		idx_pipe;
 	tx_desc_cmd_819x_usb *pdesc = (tx_desc_cmd_819x_usb *)skb->data;
 	cb_desc *tcb_desc = (cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
 	u8 queue_index = tcb_desc->queue_index;
 
-	//printk("\n %s::queue_index = %d\n",__func__, queue_index);
+	/* printk("\n %s::queue_index = %d\n", __func__, queue_index); */
 	atomic_inc(&priv->tx_pending[queue_index]);
 	tx_urb = usb_alloc_urb(0,GFP_ATOMIC);
 	if(!tx_urb){
@@ -1818,17 +1849,18 @@ short rtl819xU_tx_cmd(struct net_device *dev, struct sk_buff *skb)
 
 	memset(pdesc, 0, USB_HWDESC_HEADER_LEN);
 	/* Tx descriptor ought to be set according to the skb->cb */
-	pdesc->FirstSeg = 1;//bFirstSeg;
-	pdesc->LastSeg = 1;//bLastSeg;
+	pdesc->FirstSeg = 1;		/* bFirstSeg; */
+	pdesc->LastSeg = 1;		/* bLastSeg; */
 	pdesc->CmdInit = tcb_desc->bCmdOrInit;
 	pdesc->TxBufferSize = tcb_desc->txbuf_size;
 	pdesc->OWN = 1;
 	pdesc->LINIP = tcb_desc->bLastIniPkt;
 
-	//----------------------------------------------------------------------------
-	// Fill up USB_OUT_CONTEXT.
-	//----------------------------------------------------------------------------
-	// Get index to out pipe from specified QueueID.
+	/* ----------------------------------------------------------------------------
+	 *  Fill up USB_OUT_CONTEXT.
+	 * ----------------------------------------------------------------------------
+	 * Get index to out pipe from specified QueueID.
+	 */
 #ifndef USE_ONE_PIPE
 	idx_pipe = txqueue2outpipe(priv,queue_index);
 #else
@@ -1864,46 +1896,44 @@ short rtl819xU_tx_cmd(struct net_device *dev, struct sk_buff *skb)
 */
 u8 MapHwQueueToFirmwareQueue(u8 QueueID)
 {
-	u8 QueueSelect = 0x0;       //defualt set to
+	u8 QueueSelect = 0x0;		/* defualt set to */
 
 	switch(QueueID) {
-		case BE_QUEUE:
-			QueueSelect = QSLT_BE;  //or QSelect = pTcb->priority;
-			break;
-
-		case BK_QUEUE:
-			QueueSelect = QSLT_BK;  //or QSelect = pTcb->priority;
-			break;
-
-		case VO_QUEUE:
-			QueueSelect = QSLT_VO;  //or QSelect = pTcb->priority;
-			break;
-
-		case VI_QUEUE:
-			QueueSelect = QSLT_VI;  //or QSelect = pTcb->priority;
-			break;
-		case MGNT_QUEUE:
-			QueueSelect = QSLT_MGNT;
-			break;
-
+	case BE_QUEUE:
+		QueueSelect = QSLT_BE;	/* or QSelect = pTcb->priority; */
+		break;
+	case BK_QUEUE:
+		QueueSelect = QSLT_BK;	/*or QSelect = pTcb->priority; */
+		break;
+	case VO_QUEUE:
+		QueueSelect = QSLT_VO;	/* or QSelect = pTcb->priority; */
+		break;
+	case VI_QUEUE:
+		QueueSelect = QSLT_VI;	/* or QSelect = pTcb->priority; */
+		break;
+	case MGNT_QUEUE:
+		QueueSelect = QSLT_MGNT;
+		break;
 		case BEACON_QUEUE:
-			QueueSelect = QSLT_BEACON;
-			break;
-
-			// TODO: 2006.10.30 mark other queue selection until we verify it is OK
-			// TODO: Remove Assertions
-//#if (RTL819X_FPGA_VER & RTL819X_FPGA_GUANGAN_070502)
-		case TXCMD_QUEUE:
-			QueueSelect = QSLT_CMD;
-			break;
-//#endif
-		case HIGH_QUEUE:
-			QueueSelect = QSLT_HIGH;
-			break;
+		QueueSelect = QSLT_BEACON;
+		break;
 
-		default:
-			RT_TRACE(COMP_ERR, "TransmitTCB(): Impossible Queue Selection: %d \n", QueueID);
-			break;
+		/* TODO: 2006.10.30 mark other queue selection
+		 * until we verify it is OK
+		 */
+		/* TODO: Remove Assertions */
+/* #if (RTL819X_FPGA_VER & RTL819X_FPGA_GUANGAN_070502) */
+	case TXCMD_QUEUE:
+		QueueSelect = QSLT_CMD;
+		break;
+/* #endif */
+	case HIGH_QUEUE:
+		QueueSelect = QSLT_HIGH;
+		break;
+	default:
+		RT_TRACE(COMP_ERR, "TransmitTCB(): Impossible Queue Selection:"
+							" %d \n", QueueID);
+		break;
 	}
 	return QueueSelect;
 }
@@ -1926,7 +1956,7 @@ u8 MRateToHwRate8190Pci(u8 rate)
 		case MGN_48M:   ret = DESC90_RATE48M;   break;
 		case MGN_54M:   ret = DESC90_RATE54M;   break;
 
-		// HT rate since here
+		/* HT rate since here */
 		case MGN_MCS0:  ret = DESC90_RATEMCS0;  break;
 		case MGN_MCS1:  ret = DESC90_RATEMCS1;  break;
 		case MGN_MCS2:  ret = DESC90_RATEMCS2;  break;
@@ -1983,10 +2013,10 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff* skb)
 	int pend;
 	int status;
 	struct urb *tx_urb = NULL, *tx_urb_zero = NULL;
-	//int urb_len;
+	/* int urb_len; */
 	unsigned int idx_pipe;
-//	RT_DEBUG_DATA(COMP_SEND, tcb_desc, sizeof(cb_desc));
-//	printk("=============> %s\n", __func__);
+	/* RT_DEBUG_DATA(COMP_SEND, tcb_desc, sizeof(cb_desc)); */
+	/* printk("=============> %s\n", __func__); */
 	pend = atomic_read(&priv->tx_pending[tcb_desc->queue_index]);
 	/* we are locked here so the two atomic_read and inc are executed
 	 * without interleaves
@@ -2011,11 +2041,12 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff* skb)
 	tx_fwinfo->TxRate = MRateToHwRate8190Pci(tcb_desc->data_rate);
 	tx_fwinfo->EnableCPUDur = tcb_desc->bTxEnableFwCalcDur;
 	tx_fwinfo->Short = QueryIsShort(tx_fwinfo->TxHT, tx_fwinfo->TxRate, tcb_desc);
-	if(tcb_desc->bAMPDUEnable) {//AMPDU enabled
+	if(tcb_desc->bAMPDUEnable) {			/* AMPDU enabled */
 		tx_fwinfo->AllowAggregation = 1;
 		/* DWORD 1 */
 		tx_fwinfo->RxMF = tcb_desc->ampdu_factor;
-		tx_fwinfo->RxAMD = tcb_desc->ampdu_density&0x07;//ampdudensity
+		tx_fwinfo->RxAMD = tcb_desc->ampdu_density&0x07;
+			/* ampdudensity */
 	} else {
 		tx_fwinfo->AllowAggregation = 0;
 		/* DWORD 1 */
@@ -2039,7 +2070,8 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff* skb)
 	{
 		if(tcb_desc->bPacketBW) {
 			tx_fwinfo->TxBandwidth = 1;
-			tx_fwinfo->TxSubCarrier = 0;    //By SD3's Jerry suggestion, use duplicated mode
+			tx_fwinfo->TxSubCarrier = 0;    
+			/* By SD3's Jerry suggestion, use duplicated mode */
 		} else {
 			tx_fwinfo->TxBandwidth = 0;
 			tx_fwinfo->TxSubCarrier = priv->nCur40MhzPrimeSC;
@@ -2075,7 +2107,7 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff* skb)
 	tx_desc->SecCAMID= 0;
 	tx_desc->RATid = tcb_desc->RATRIndex;
 	{
-		//MPDUOverhead = 0;
+		/* MPDUOverhead = 0; */
 		tx_desc->NoEnc = 1;
 	}
 	tx_desc->SecType = 0x0;
@@ -2110,7 +2142,7 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff* skb)
 	tx_desc->USERATE = tcb_desc->bTxUseDriverAssingedRate;
 
 	/* Fill fields that are required to be initialized in all of the descriptors */
-	//DWORD 0
+	/* DWORD 0 */
 	tx_desc->FirstSeg = 1;
 	tx_desc->LastSeg = 1;
 	tx_desc->OWN = 1;
@@ -2121,7 +2153,7 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff* skb)
 	} else
 #endif
 	{
-		//DWORD 2
+		/* DWORD 2 */
 		tx_desc->TxBufferSize = (u32)(skb->len - USB_HWDESC_HEADER_LEN);
 	}
 	/* Get index to out pipe from specified QueueID */
@@ -2131,8 +2163,8 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff* skb)
 	idx_pipe = 0x5;
 #endif
 
-	//RT_DEBUG_DATA(COMP_SEND,tx_fwinfo,sizeof(tx_fwinfo_819x_usb));
-	//RT_DEBUG_DATA(COMP_SEND,tx_desc,sizeof(tx_desc_819x_usb));
+	/* RT_DEBUG_DATA(COMP_SEND, tx_fwinfo, sizeof(tx_fwinfo_819x_usb)); */
+	/* RT_DEBUG_DATA(COMP_SEND, tx_desc, sizeof(tx_desc_819x_usb)); */
 
 	/* To submit bulk urb */
 	usb_fill_bulk_urb(tx_urb,udev,
@@ -2141,7 +2173,10 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff* skb)
 
 	status = usb_submit_urb(tx_urb, GFP_ATOMIC);
 	if (!status){
-//we need to send 0 byte packet whenever 512N bytes/64N(HIGN SPEED/NORMAL SPEED) bytes packet has been transmitted. Otherwise, it will be halt to wait for another packet. WB. 2008.08.27
+/* we need to send 0 byte packet whenever 512N bytes/64N
+ * (HIGN SPEED/NORMAL SPEED) bytes packet has been transmitted.
+ * Otherwise, it will be halt to wait for another packet. WB. 2008.08.27
+ */
 		bool bSend0Byte = false;
 		u8 zero = 0;
 		if(udev->speed == USB_SPEED_HIGH)
@@ -2311,22 +2346,25 @@ void rtl8192_usb_deleteendpoints(struct net_device *dev)
 extern void rtl8192_update_ratr_table(struct net_device* dev);
 void rtl8192_link_change(struct net_device *dev)
 {
-//	int i;
+	/* int i; */
 
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	struct ieee80211_device* ieee = priv->ieee80211;
-	//write_nic_word(dev, BCN_INTR_ITV, net->beacon_interval);
+	/* write_nic_word(dev, BCN_INTR_ITV, net->beacon_interval); */
 	if (ieee->state == IEEE80211_LINKED)
 	{
 		rtl8192_net_update(dev);
 		rtl8192_update_ratr_table(dev);
-		//add this as in pure N mode, wep encryption will use software way, but there is no chance to set this as wep will not set group key in wext. WB.2008.07.08
+		/* add this as in pure N mode, wep encryption will use software
+		 * way, but there is no chance to set this as wep will not set
+		 * group key in wext. WB.2008.07.08
+		 */
 		if ((KEY_TYPE_WEP40 == ieee->pairwise_key_type) || (KEY_TYPE_WEP104 == ieee->pairwise_key_type))
 		EnableHWSecurityConfig8192(dev);
 	}
 	/*update timing params*/
-//	RT_TRACE(COMP_CH, "========>%s(), chan:%d\n", __func__, priv->chan);
-//	rtl8192_set_chan(dev, priv->chan);
+	/* RT_TRACE(COMP_CH, "========>%s(), chan:%d\n", __func__, priv->chan); */
+	/* rtl8192_set_chan(dev, priv->chan); */
 	 if (ieee->iw_mode == IW_MODE_INFRA || ieee->iw_mode == IW_MODE_ADHOC)
         {
                 u32 reg = 0;
@@ -2338,15 +2376,15 @@ void rtl8192_link_change(struct net_device *dev)
                 write_nic_dword(dev, RCR, reg);
         }
 
-//	rtl8192_set_rxconf(dev);
+	/* rtl8192_set_rxconf(dev); */
 }
 
 static struct ieee80211_qos_parameters def_qos_parameters = {
-        {3,3,3,3},/* cw_min */
-        {7,7,7,7},/* cw_max */
-        {2,2,2,2},/* aifs */
-        {0,0,0,0},/* flags */
-        {0,0,0,0} /* tx_op_limit */
+	{3, 3, 3, 3},		/* cw_min */
+	{7, 7, 7, 7},		/* cw_max */
+	{2, 2, 2, 2},		/* aifs */
+	{0, 0, 0, 0},		/* flags */
+	{0, 0, 0, 0}		/* tx_op_limit */
 };
 
 
@@ -2372,7 +2410,7 @@ void rtl8192_qos_activate(struct work_struct * work)
 	struct net_device *dev = priv->ieee80211->dev;
 	struct ieee80211_qos_parameters *qos_parameters = &priv->ieee80211->current_network.qos_data.parameters;
 	u8 mode = priv->ieee80211->current_network.mode;
-	//u32 size = sizeof(struct ieee80211_qos_parameters);
+	/* u32 size = sizeof(struct ieee80211_qos_parameters); */
 	u8  u1bAIFS;
 	u32 u4bAcParam;
 	int i;
@@ -2388,7 +2426,7 @@ void rtl8192_qos_activate(struct work_struct * work)
 	/* For we just support b/g mode at present, let the slot time at 9/20 selection */
 	/* update the ac parameter to related registers */
 	for(i = 0; i <  QOS_QUEUE_NUM; i++) {
-		//Mode G/A: slotTimeTimer = 9; Mode B: 20
+		/* Mode G/A: slotTimeTimer = 9; Mode B: 20 */
 		u1bAIFS = qos_parameters->aifs[i] * ((mode&(IEEE_G|IEEE_N_24G)) ?9:20) + aSifsTime;
 		u4bAcParam = ((((u32)(qos_parameters->tx_op_limit[i]))<< AC_PARAM_TXOP_LIMIT_OFFSET)|
 				(((u32)(qos_parameters->cw_max[i]))<< AC_PARAM_ECW_MAX_OFFSET)|
@@ -2396,7 +2434,7 @@ void rtl8192_qos_activate(struct work_struct * work)
 				((u32)u1bAIFS << AC_PARAM_AIFS_OFFSET));
 
 		write_nic_dword(dev, WDCAPARA_ADD[i], u4bAcParam);
-		//write_nic_dword(dev, WDCAPARA_ADD[i], 0x005e4332);
+		/* write_nic_dword(dev, WDCAPARA_ADD[i], 0x005e4332); */
 	}
 
 success:
@@ -2525,19 +2563,19 @@ static int rtl8192_handle_assoc_response(struct net_device *dev,
 
 
 void rtl8192_update_ratr_table(struct net_device* dev)
-	//	POCTET_STRING	posLegacyRate,
-	//	u8*			pMcsRate)
-	//	PRT_WLAN_STA	pEntry)
+		/* POCTET_STRING	posLegacyRate, */
+		/* u8*			pMcsRate) */
+		/* PRT_WLAN_STA	pEntry) */
 {
 	struct r8192_priv* priv = ieee80211_priv(dev);
 	struct ieee80211_device* ieee = priv->ieee80211;
 	u8* pMcsRate = ieee->dot11HTOperationalRateSet;
-	//struct ieee80211_network *net = &ieee->current_network;
+	/* struct ieee80211_network *net = &ieee->current_network; */
 	u32 ratr_value = 0;
 	u8 rate_index = 0;
 	rtl8192_config_rate(dev, (u16*)(&ratr_value));
 	ratr_value |= (*(u16*)(pMcsRate)) << 12;
-//	switch (net->mode)
+	/* switch (net->mode) */
 	switch (ieee->mode)
 	{
 		case IEEE_A:
@@ -2551,7 +2589,8 @@ void rtl8192_update_ratr_table(struct net_device* dev)
 			break;
 		case IEEE_N_24G:
 		case IEEE_N_5G:
-			if (ieee->pHTInfo->PeerMimoPs == 0) //MIMO_PS_STATIC
+			if (ieee->pHTInfo->PeerMimoPs == 0)
+				/* MIMO_PS_STATIC */
 				ratr_value &= 0x0007F007;
 			else{
 				if (priv->rf_type == RF_1T2R)
@@ -2585,17 +2624,23 @@ bool GetNmodeSupportBySecCfg8192(struct net_device*dev)
 	int encrypt;
 
 	crypt = ieee->crypt[ieee->tx_keyidx];
-	//we use connecting AP's capability instead of only security config on our driver to distinguish whether it should use N mode or G mode
+	/* we use connecting AP's capability instead of only security config
+	 * on our driver to distinguish whether it should use N mode or G mode
+	 */
 	encrypt = (network->capability & WLAN_CAPABILITY_PRIVACY) || (ieee->host_encrypt && crypt && crypt->ops && (0 == strcmp(crypt->ops->name,"WEP")));
 
 	/* simply judge  */
 	if(encrypt && (wpa_ie_len == 0)) {
 		/* wep encryption, no N mode setting */
 		return false;
-//	} else if((wpa_ie_len != 0)&&(memcmp(&(ieee->wpa_ie[14]),ccmp_ie,4))) {
+	/* } else if((wpa_ie_len != 0)&&(memcmp(&(ieee->wpa_ie[14]),
+	 *							ccmp_ie,4))) {
+	 */
 	} else if((wpa_ie_len != 0)) {
 		/* parse pairwise key type */
-		//if((pairwisekey = WEP40)||(pairwisekey = WEP104)||(pairwisekey = TKIP))
+		/* if((pairwisekey = WEP40) || (pairwisekey = WEP104) ||
+		 *					(pairwisekey = TKIP))
+		 */
 		if (((ieee->wpa_ie[0] == 0xdd) && (!memcmp(&(ieee->wpa_ie[14]),ccmp_ie,4))) || ((ieee->wpa_ie[0] == 0x30) && (!memcmp(&ieee->wpa_ie[10],ccmp_rsn_ie, 4))))
 			return true;
 		else
@@ -2624,12 +2669,16 @@ bool GetHalfNmodeSupportByAPs819xUsb(struct net_device* dev)
 void rtl8192_refresh_supportrate(struct r8192_priv* priv)
 {
 	struct ieee80211_device* ieee = priv->ieee80211;
-	//we donot consider set support rate for ABG mode, only HT MCS rate is set here.
+	/* we donot consider set support rate for ABG mode,
+	 * only HT MCS rate is set here.
+	 */
 	if (ieee->mode == WIRELESS_MODE_N_24G || ieee->mode == WIRELESS_MODE_N_5G)
 	{
 		memcpy(ieee->Regdot11HTOperationalRateSet, ieee->RegHTSuppRateSet, 16);
-		//RT_DEBUG_DATA(COMP_INIT, ieee->RegHTSuppRateSet, 16);
-		//RT_DEBUG_DATA(COMP_INIT, ieee->Regdot11HTOperationalRateSet, 16);
+		/* RT_DEBUG_DATA(COMP_INIT, ieee->RegHTSuppRateSet, 16); */
+		/* RT_DEBUG_DATA(COMP_INIT,
+		 *		 ieee->Regdot11HTOperationalRateSet, 16);
+		 */
 	}
 	else
 		memset(ieee->Regdot11HTOperationalRateSet, 0, 16);
@@ -2688,7 +2737,10 @@ void rtl8192_SetWirelessMode(struct net_device* dev, u8 wireless_mode)
 			wireless_mode = WIRELESS_MODE_B;
 		}
 	}
-#ifdef TO_DO_LIST //// TODO: this function doesn't work well at this time, we should wait for FPGA
+#ifdef TO_DO_LIST
+	/* TODO: this function doesn't work well at this time,
+	 * we should wait for FPGA
+	 */
 	ActUpdateChannelAccessSetting( pAdapter, pHalData->CurrentWirelessMode, &pAdapter->MgntInfo.Info8185.ChannelAccessSetting );
 #endif
 	priv->ieee80211->mode = wireless_mode;
@@ -2701,44 +2753,47 @@ void rtl8192_SetWirelessMode(struct net_device* dev, u8 wireless_mode)
 	rtl8192_refresh_supportrate(priv);
 
 }
-//init priv variables here. only non_zero value should be initialized here.
+/* init priv variables here. only non_zero value should be initialized here. */
 static void rtl8192_init_priv_variable(struct net_device* dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	u8 i;
 	priv->card_8192 = NIC_8192U;
-	priv->chan = 1; //set to channel 1
-	priv->ieee80211->mode = WIRELESS_MODE_AUTO; //SET AUTO
+	priv->chan = 1;					/* set to channel 1 */
+	priv->ieee80211->mode = WIRELESS_MODE_AUTO;	/* SET AUTO */
 	priv->ieee80211->iw_mode = IW_MODE_INFRA;
 	priv->ieee80211->ieee_up=0;
 	priv->retry_rts = DEFAULT_RETRY_RTS;
 	priv->retry_data = DEFAULT_RETRY_DATA;
 	priv->ieee80211->rts = DEFAULT_RTS_THRESHOLD;
-	priv->ieee80211->rate = 110; //11 mbps
+	priv->ieee80211->rate = 110;			/* 11 mbps */
 	priv->ieee80211->short_slot = 1;
 	priv->promisc = (dev->flags & IFF_PROMISC) ? 1:0;
 	priv->CckPwEnl = 6;
-	//for silent reset
+	/* for silent reset */
 	priv->IrpPendingCount = 1;
 	priv->ResetProgress = RESET_TYPE_NORESET;
 	priv->bForcedSilentReset = 0;
 	priv->bDisableNormalResetCheck = false;
 	priv->force_reset = false;
 
-	priv->ieee80211->FwRWRF = 0; 	//we don't use FW read/write RF until stable firmware is available.
+	priv->ieee80211->FwRWRF = 0;
+	/* we don't use FW read/write RF until stable firmware is available. */
 	priv->ieee80211->current_network.beacon_interval = DEFAULT_BEACONINTERVAL;
 	priv->ieee80211->iw_mode = IW_MODE_INFRA;
 	priv->ieee80211->softmac_features  = IEEE_SOFTMAC_SCAN |
 		IEEE_SOFTMAC_ASSOCIATE | IEEE_SOFTMAC_PROBERQ |
 		IEEE_SOFTMAC_PROBERS | IEEE_SOFTMAC_TX_QUEUE |
-		IEEE_SOFTMAC_BEACONS;//added by amy 080604 //|  //IEEE_SOFTMAC_SINGLE_QUEUE;
-
+		IEEE_SOFTMAC_BEACONS;
+		/* added by amy 080604 //|  //IEEE_SOFTMAC_SINGLE_QUEUE; */
 	priv->ieee80211->active_scan = 1;
 	priv->ieee80211->modulation = IEEE80211_CCK_MODULATION | IEEE80211_OFDM_MODULATION;
 	priv->ieee80211->host_encrypt = 1;
 	priv->ieee80211->host_decrypt = 1;
-	priv->ieee80211->start_send_beacons = NULL;//rtl819xusb_beacon_tx;//-by amy 080604
-	priv->ieee80211->stop_send_beacons = NULL;//rtl8192_beacon_stop;//-by amy 080604
+	priv->ieee80211->start_send_beacons = NULL;
+	/* rtl819xusb_beacon_tx;//-by amy 080604 */
+	priv->ieee80211->stop_send_beacons = NULL;
+	/* rtl8192_beacon_stop;//-by amy 080604 */
 	priv->ieee80211->softmac_hard_start_xmit = rtl8192_hard_start_xmit;
 	priv->ieee80211->set_chan = rtl8192_set_chan;
 	priv->ieee80211->link_change = rtl8192_link_change;
@@ -2751,16 +2806,16 @@ static void rtl8192_init_priv_variable(struct net_device* dev)
 	priv->ieee80211->tx_headroom = TX_PACKET_SHIFT_BYTES;
 	priv->ieee80211->qos_support = 1;
 
-	//added by WB
-//	priv->ieee80211->SwChnlByTimerHandler = rtl8192_phy_SwChnl;
+	/* added by WB */
+	/* priv->ieee80211->SwChnlByTimerHandler = rtl8192_phy_SwChnl; */
 	priv->ieee80211->SetBWModeHandler = rtl8192_SetBWMode;
 	priv->ieee80211->handle_assoc_response = rtl8192_handle_assoc_response;
 	priv->ieee80211->handle_beacon = rtl8192_handle_beacon;
-	//added by david
+	/* added by david */
 	priv->ieee80211->GetNmodeSupportBySecCfg = GetNmodeSupportBySecCfg8192;
 	priv->ieee80211->GetHalfNmodeSupportByAPsHandler = GetHalfNmodeSupportByAPs819xUsb;
 	priv->ieee80211->SetWirelessMode = rtl8192_SetWirelessMode;
-	//added by amy
+	/* added by amy */
 	priv->ieee80211->InitialGainHandler = InitialGain819xUsb;
 	priv->card_type = USB;
 #ifdef TO_DO_LIST
@@ -2777,33 +2832,61 @@ static void rtl8192_init_priv_variable(struct net_device* dev)
 	priv->EarlyRxThreshold = 7;
 	priv->enable_gpio0 = 0;
 	priv->TransmitConfig =
-	//	TCR_DurProcMode |	//for RTL8185B, duration setting by HW
-	//?	TCR_DISReqQsize |
-		(TCR_MXDMA_2048<<TCR_MXDMA_OFFSET)|  // Max DMA Burst Size per Tx DMA Burst, 7: reservied.
-		(priv->ShortRetryLimit<<TCR_SRL_OFFSET)|	// Short retry limit
-		(priv->LongRetryLimit<<TCR_LRL_OFFSET) |	// Long retry limit
-		(false ? TCR_SAT: 0);	// FALSE: HW provies PLCP length and LENGEXT, TURE: SW proiveds them
+	/* 	TCR_DurProcMode | */
+		/* for RTL8185B, duration setting by HW */
+	/* ?	TCR_DISReqQsize | */
+		(TCR_MXDMA_2048<<TCR_MXDMA_OFFSET)|
+		/* Max DMA Burst Size per Tx DMA Burst, 7: reservied. */
+		(priv->ShortRetryLimit<<TCR_SRL_OFFSET)|
+		/* Short retry limit */
+		(priv->LongRetryLimit<<TCR_LRL_OFFSET) |
+		/* Long retry limit */
+		(false ? TCR_SAT: 0);
+		/* FALSE: HW provies PLCP length and LENGEXT, TURE:
+		 * SW proiveds them
+		 */
 #ifdef TO_DO_LIST
 	if(Adapter->bInHctTest)
 		pHalData->ReceiveConfig	=	pHalData->CSMethod |
-						RCR_AMF | RCR_ADF |	//RCR_AAP | 	//accept management/data
-						//guangan200710
-						RCR_ACF |	//accept control frame for SW AP needs PS-poll, 2005.07.07, by rcnjko.
-						RCR_AB | RCR_AM | RCR_APM |		//accept BC/MC/UC
-						RCR_AICV | RCR_ACRC32 | 		//accept ICV/CRC error packet
-						((u32)7<<RCR_MXDMA_OFFSET) | // Max DMA Burst Size per Rx DMA Burst, 7: unlimited.
-						(pHalData->EarlyRxThreshold<<RCR_FIFO_OFFSET) | // Rx FIFO Threshold, 7: No Rx threshold.
+						RCR_AMF | RCR_ADF |
+						/* RCR_AAP | */
+						/* accept management/data */
+						/* guangan200710 */
+						RCR_ACF |
+						/* accept control frame for SW
+						 * AP needs PS-poll, 2005.07.07
+						 *, by rcnjko.
+						 */
+						RCR_AB | RCR_AM | RCR_APM |
+						/* accept BC/MC/UC */
+						RCR_AICV | RCR_ACRC32 |
+						/* accept ICV/CRC error
+						 * packet
+						 */
+						((u32)7<<RCR_MXDMA_OFFSET) |
+						/* Max DMA Burst Size per Rx
+						 * DMA Burst, 7: unlimited.
+						 */
+						(pHalData->EarlyRxThreshold<<RCR_FIFO_OFFSET) |
+						/* Rx FIFO Threshold, 7:
+						 * No Rx threshold.
+						 */
 						(pHalData->EarlyRxThreshold == 7 ? RCR_OnlyErlPkt:0);
 	else
 
 #endif
 	priv->ReceiveConfig	=
-		RCR_AMF | RCR_ADF |		//accept management/data
-		RCR_ACF |			//accept control frame for SW AP needs PS-poll, 2005.07.07, by rcnjko.
-		RCR_AB | RCR_AM | RCR_APM |	//accept BC/MC/UC
-		//RCR_AICV | RCR_ACRC32 | 	//accept ICV/CRC error packet
-		((u32)7<<RCR_MXDMA_OFFSET)| // Max DMA Burst Size per Rx DMA Burst, 7: unlimited.
-		(priv->EarlyRxThreshold<<RX_FIFO_THRESHOLD_SHIFT) | // Rx FIFO Threshold, 7: No Rx threshold.
+		RCR_AMF | RCR_ADF |		/* accept management/data */
+		RCR_ACF |			
+		/* accept control frame for SW AP needs PS-poll,
+		 * 2005.07.07, by rcnjko.
+		 */
+		RCR_AB | RCR_AM | RCR_APM |	/* accept BC/MC/UC */
+		/* RCR_AICV | RCR_ACRC32 | 	//accept ICV/CRC error packet */
+		((u32)7<<RCR_MXDMA_OFFSET)|
+		/* Max DMA Burst Size per Rx DMA Burst, 7: unlimited. */
+		(priv->EarlyRxThreshold<<RX_FIFO_THRESHOLD_SHIFT) |
+		/* Rx FIFO Threshold, 7: No Rx threshold. */
 		(priv->EarlyRxThreshold == 7 ? RCR_ONLYERLPKT:0);
 
 	priv->AcmControl = 0;
@@ -2828,12 +2911,12 @@ static void rtl8192_init_priv_variable(struct net_device* dev)
 	priv->rf_set_chan = rtl8192_phy_SwChnl;
 }
 
-//init lock here
+/* init lock here */
 static void rtl8192_init_priv_lock(struct r8192_priv* priv)
 {
 	spin_lock_init(&priv->tx_lock);
-	spin_lock_init(&priv->irq_lock);//added by thomas
-	//spin_lock_init(&priv->rf_lock);
+	spin_lock_init(&priv->irq_lock);		/* added by thomas */
+	/* spin_lock_init(&priv->rf_lock); */
 	sema_init(&priv->wx_sem,1);
 	sema_init(&priv->rf_sem,1);
 	mutex_init(&priv->mutex);
@@ -2842,7 +2925,7 @@ static void rtl8192_init_priv_lock(struct r8192_priv* priv)
 extern  void    rtl819x_watchdog_wqcallback(struct work_struct *work);
 
 void rtl8192_irq_rx_tasklet(struct r8192_priv *priv);
-//init tasklet and wait_queue here. only 2.6 above kernel is considered
+/* init tasklet and wait_queue here. only 2.6 above kernel is considered */
 #define DRV_NAME "wlan0"
 static void rtl8192_init_priv_task(struct net_device* dev)
 {
@@ -2856,15 +2939,17 @@ static void rtl8192_init_priv_task(struct net_device* dev)
 
 	INIT_WORK(&priv->reset_wq, rtl8192_restart);
 
-	//INIT_DELAYED_WORK(&priv->watch_dog_wq, hal_dm_watchdog);
+	/* INIT_DELAYED_WORK(&priv->watch_dog_wq, hal_dm_watchdog); */
 	INIT_DELAYED_WORK(&priv->watch_dog_wq, rtl819x_watchdog_wqcallback);
-	INIT_DELAYED_WORK(&priv->txpower_tracking_wq,  dm_txpower_trackingcallback);
-//	INIT_DELAYED_WORK(&priv->gpio_change_rf_wq,  dm_gpio_change_rf_callback);
+	INIT_DELAYED_WORK(&priv->txpower_tracking_wq, dm_txpower_trackingcallback);
+	/* INIT_DELAYED_WORK(&priv->gpio_change_rf_wq,
+	 * dm_gpio_change_rf_callback);
+	 */
 	INIT_DELAYED_WORK(&priv->rfpath_check_wq,  dm_rf_pathcheck_workitemcallback);
 	INIT_DELAYED_WORK(&priv->update_beacon_wq, rtl8192_update_beacon);
 	INIT_DELAYED_WORK(&priv->initialgain_operate_wq, InitialGainOperateWorkItemCallBack);
-	//INIT_WORK(&priv->SwChnlWorkItem,  rtl8192_SwChnl_WorkItem);
-	//INIT_WORK(&priv->SetBWModeWorkItem,  rtl8192_SetBWModeWorkItem);
+	/* INIT_WORK(&priv->SwChnlWorkItem,  rtl8192_SwChnl_WorkItem); */
+	/* INIT_WORK(&priv->SetBWModeWorkItem,  rtl8192_SetBWModeWorkItem); */
 	INIT_WORK(&priv->qos_activate, rtl8192_qos_activate);
 
 	tasklet_init(&priv->irq_rx_tasklet,
@@ -2879,12 +2964,14 @@ static void rtl8192_get_eeprom_size(struct net_device* dev)
 	RT_TRACE(COMP_EPROM, "===========>%s()\n", __func__);
 	curCR = read_nic_word_E(dev,EPROM_CMD);
 	RT_TRACE(COMP_EPROM, "read from Reg EPROM_CMD(%x):%x\n", EPROM_CMD, curCR);
-	//whether need I consider BIT5?
+	/* whether need I consider BIT5? */
 	priv->epromtype = (curCR & Cmd9346CR_9356SEL) ? EPROM_93c56 : EPROM_93c46;
 	RT_TRACE(COMP_EPROM, "<===========%s(), epromtype:%d\n", __func__, priv->epromtype);
 }
 
-//used to swap endian. as ntohl & htonl are not neccessary to swap endian, so use this instead.
+/* used to swap endian. as ntohl & htonl are not neccessary to swap endian,
+ * so use this instead.
+ */
 static inline u16 endian_swap(u16* data)
 {
 	u16 tmp = *data;
@@ -2899,7 +2986,7 @@ static void rtl8192_read_eeprom_info(struct net_device* dev)
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	u16 tmpValue = 0;
 	RT_TRACE(COMP_EPROM, "===========>%s()\n", __func__);
-	wEPROM_ID = eprom_read(dev, 0); //first read EEPROM ID out;
+	wEPROM_ID = eprom_read(dev, 0);		/* first read EEPROM ID out; */
 	RT_TRACE(COMP_EPROM, "EEPROM ID is 0x%x\n", wEPROM_ID);
 
 	if (wEPROM_ID != RTL8190_EEPROM_ID)
@@ -2928,7 +3015,7 @@ static void rtl8192_read_eeprom_info(struct net_device* dev)
 		priv->eeprom_CustomerID = 0;
 	}
 	RT_TRACE(COMP_EPROM, "vid:0x%4x, pid:0x%4x, CustomID:0x%2x, ChanPlan:0x%x\n", priv->eeprom_vid, priv->eeprom_pid, priv->eeprom_CustomerID, priv->eeprom_ChannelPlan);
-	//set channelplan from eeprom
+	/* set channelplan from eeprom */
 	priv->ChannelPlan = priv->eeprom_ChannelPlan;
 	if (bLoad_From_EEPOM)
 	{
@@ -2943,35 +3030,35 @@ static void rtl8192_read_eeprom_info(struct net_device* dev)
 	else
 	{
 		memcpy(dev->dev_addr, bMac_Tmp_Addr, 6);
-		//should I set IDR0 here?
+		/* should I set IDR0 here? */
 	}
 	RT_TRACE(COMP_EPROM, "MAC addr:%pM\n", dev->dev_addr);
-	priv->rf_type = RTL819X_DEFAULT_RF_TYPE; //default 1T2R
+	priv->rf_type = RTL819X_DEFAULT_RF_TYPE;	/* default 1T2R */
 	priv->rf_chip = RF_8256;
 
 	if (priv->card_8192_version == (u8)VERSION_819xU_A)
 	{
-		//read Tx power gain offset of legacy OFDM to HT rate
+		/* read Tx power gain offset of legacy OFDM to HT rate */
 		if (bLoad_From_EEPOM)
 			priv->EEPROMTxPowerDiff = (eprom_read(dev, (EEPROM_TxPowerDiff>>1))&0xff00) >> 8;
 		else
 			priv->EEPROMTxPowerDiff = EEPROM_Default_TxPower;
 		RT_TRACE(COMP_EPROM, "TxPowerDiff:%d\n", priv->EEPROMTxPowerDiff);
-		//read ThermalMeter from EEPROM
+		/* read ThermalMeter from EEPROM */
 		if (bLoad_From_EEPOM)
 			priv->EEPROMThermalMeter = (u8)(eprom_read(dev, (EEPROM_ThermalMeter>>1))&0x00ff);
 		else
 			priv->EEPROMThermalMeter = EEPROM_Default_ThermalMeter;
 		RT_TRACE(COMP_EPROM, "ThermalMeter:%d\n", priv->EEPROMThermalMeter);
-		//vivi, for tx power track
+		/* vivi, for tx power track */
 		priv->TSSI_13dBm = priv->EEPROMThermalMeter *100;
-		//read antenna tx power offset of B/C/D to A from EEPROM
+		/* read antenna tx power offset of B/C/D to A from EEPROM */
 		if (bLoad_From_EEPOM)
 			priv->EEPROMPwDiff = (eprom_read(dev, (EEPROM_PwDiff>>1))&0x0f00)>>8;
 		else
 			priv->EEPROMPwDiff = EEPROM_Default_PwDiff;
 		RT_TRACE(COMP_EPROM, "TxPwDiff:%d\n", priv->EEPROMPwDiff);
-		// Read CrystalCap from EEPROM
+		/* Read CrystalCap from EEPROM */
 		if (bLoad_From_EEPOM)
 			priv->EEPROMCrystalCap = (eprom_read(dev, (EEPROM_CrystalCap>>1))&0x0f);
 		else
-- 
1.6.3.3

