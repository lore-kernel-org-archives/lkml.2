Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab0FGHgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 03:36:25 -0400
Received: from outbound-mail03.westnet.com.au ([203.10.1.244]:25392 "EHLO
	outbound-mail03.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932274Ab0FGHgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 03:36:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Amw6AMY9DEw6B9wNPGdsb2JhbACHb5ZRDAEBAQE1LbBCjQWFFwSDSA
X-IronPort-AV: E=Sophos;i="4.53,376,1272816000"; 
   d="scan'208";a="77841134"
From: Mike Gilks <mike.kernel@gilksonline.com>
To: gregkh@suse.de, mchehab@redhat.com, julia@diku.dk, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Gilks <mike.kernel@gilksonline.com>
Subject: [PATCH] staging: rtl8192u: fix checkpatch.pl issues to line 2500 Fixed most problems pointed out by checkpatch.pl in file r8192U_core.c up to line 2500. Also changed indentation on all switch statements.
Date: Mon,  7 Jun 2010 15:36:35 +0800
Message-Id: <1275896195-11386-2-git-send-email-mike.kernel@gilksonline.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1275896195-11386-1-git-send-email-mike.kernel@gilksonline.com>
References: <1275896195-11386-1-git-send-email-mike.kernel@gilksonline.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Gilks <mike.kernel@gilksonline.com>
---
 drivers/staging/rtl8192u/r8192U_core.c | 1778 +++++++++++++++++---------------
 1 files changed, 952 insertions(+), 826 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index dc4d2b6..66adac3 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -811,14 +811,14 @@ void rtl8192_dump_reg(struct net_device *dev)
  ****************************************************************************
  */
 
-void rtl8192_set_mode(struct net_device *dev,int mode)
+void rtl8192_set_mode(struct net_device *dev, int mode)
 {
 	u8 ecmd;
-	ecmd=read_nic_byte(dev, EPROM_CMD);
-	ecmd=ecmd &~ EPROM_CMD_OPERATING_MODE_MASK;
-	ecmd=ecmd | (mode<<EPROM_CMD_OPERATING_MODE_SHIFT);
-	ecmd=ecmd &~ (1<<EPROM_CS_SHIFT);
-	ecmd=ecmd &~ (1<<EPROM_CK_SHIFT);
+	ecmd = read_nic_byte(dev, EPROM_CMD);
+	ecmd = ecmd & ~EPROM_CMD_OPERATING_MODE_MASK;
+	ecmd = ecmd | (mode<<EPROM_CMD_OPERATING_MODE_SHIFT);
+	ecmd = ecmd & ~(1<<EPROM_CS_SHIFT);
+	ecmd = ecmd & ~(1<<EPROM_CK_SHIFT);
 	write_nic_byte(dev, EPROM_CMD, ecmd);
 }
 
@@ -829,15 +829,14 @@ void rtl8192_update_msr(struct net_device *dev)
 	u8 msr;
 
 	msr  = read_nic_byte(dev, MSR);
-	msr &= ~ MSR_LINK_MASK;
+	msr &= ~MSR_LINK_MASK;
 
 	/* do not change in link_state != WLAN_LINK_ASSOCIATED.
 	 * msr must be updated if the state is ASSOCIATING.
 	 * this is intentional and make sense for ad-hoc and
 	 * master (see the create BSS/IBSS func)
 	 */
-	if (priv->ieee80211->state == IEEE80211_LINKED){
-
+	if (priv->ieee80211->state == IEEE80211_LINKED) {
 		if (priv->ieee80211->iw_mode == IW_MODE_INFRA)
 			msr |= (MSR_LINK_MANAGED<<MSR_LINK_SHIFT);
 		else if (priv->ieee80211->iw_mode == IW_MODE_ADHOC)
@@ -845,18 +844,18 @@ void rtl8192_update_msr(struct net_device *dev)
 		else if (priv->ieee80211->iw_mode == IW_MODE_MASTER)
 			msr |= (MSR_LINK_MASTER<<MSR_LINK_SHIFT);
 
-	}else
-		msr |= (MSR_LINK_NONE<<MSR_LINK_SHIFT);
+	} else
+		msr |= (MSR_LINK_NONE<<MSR_LINK_SHIFT) ;
 
 	write_nic_byte(dev, MSR, msr);
 }
 
-void rtl8192_set_chan(struct net_device *dev,short ch)
+void rtl8192_set_chan(struct net_device *dev, short ch)
 {
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
 	/* u32 tx; */
 	RT_TRACE(COMP_CH, "=====>%s()====ch:%d\n", __func__, ch);
-	priv->chan=ch;
+	priv->chan = ch;
 
 	/* this hack should avoid frame TX during channel setting */
 
@@ -872,11 +871,11 @@ void rtl8192_set_chan(struct net_device *dev,short ch)
 	/* need to implement rf set channel here WB */
 
 	if (priv->rf_set_chan)
-	priv->rf_set_chan(dev, priv->chan);
-	mdelay(10);
-	/* write_nic_dword(dev, TX_CONF, tx |
-	 *				(TX_LOOPBACK_NONE<<TX_LOOPBACK_SHIFT));
-	 */
+		priv->rf_set_chan(dev, priv->chan);
+		mdelay(10);
+		/* write_nic_dword(dev, TX_CONF, tx |
+		 *			(TX_LOOPBACK_NONE<<TX_LOOPBACK_SHIFT));
+		 */
 #endif
 }
 
@@ -888,15 +887,15 @@ u32 get_rxpacket_shiftbytes_819xusb(struct ieee80211_rx_stats *pstats)
 
 #ifdef USB_RX_AGGREGATION_SUPPORT
 	if (pstats->bisrxaggrsubframe)
-		return (sizeof(rx_desc_819x_usb) + pstats->RxDrvInfoSize
-			+ pstats->RxBufShift + 8);
+		return sizeof(rx_desc_819x_usb) + pstats->RxDrvInfoSize
+			+ pstats->RxBufShift + 8;
 	else
 #endif
-		return (sizeof(rx_desc_819x_usb) + pstats->RxDrvInfoSize
-				+ pstats->RxBufShift);
+		return sizeof(rx_desc_819x_usb) + pstats->RxDrvInfoSize
+				+ pstats->RxBufShift;
 
 }
-static int rtl8192_rx_initiate(struct net_device*dev)
+static int rtl8192_rx_initiate(struct net_device *dev)
 {
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
 	struct urb *entry;
@@ -915,8 +914,9 @@ static int rtl8192_rx_initiate(struct net_device*dev)
 		}
 		/* printk("nomal packet IN request!\n"); */
 		usb_fill_bulk_urb(entry, priv->udev,
-				  usb_rcvbulkpipe(priv->udev, 3), skb_tail_pointer(skb),
-				  RX_URB_SIZE, rtl8192_rx_isr, skb);
+				usb_rcvbulkpipe(priv->udev, 3),
+				skb_tail_pointer(skb), RX_URB_SIZE,
+						rtl8192_rx_isr, skb);
 		info = (struct rtl8192_rx_info *) skb->cb;
 		info->urb = entry;
 		info->dev = dev;
@@ -928,7 +928,7 @@ static int rtl8192_rx_initiate(struct net_device*dev)
 	/* command packet rx procedure */
 	while (skb_queue_len(&priv->rx_queue) < MAX_RX_URB + 3) {
 		/* printk("command packet IN request!\n"); */
-		skb = __dev_alloc_skb(RX_URB_SIZE ,GFP_KERNEL);
+		skb = __dev_alloc_skb(RX_URB_SIZE , GFP_KERNEL);
 		if (!skb)
 			break;
 		entry = usb_alloc_urb(0, GFP_KERNEL);
@@ -937,8 +937,9 @@ static int rtl8192_rx_initiate(struct net_device*dev)
 			break;
 		}
 		usb_fill_bulk_urb(entry, priv->udev,
-				  usb_rcvbulkpipe(priv->udev, 9), skb_tail_pointer(skb),
-				  RX_URB_SIZE, rtl8192_rx_isr, skb);
+				usb_rcvbulkpipe(priv->udev, 9),
+				skb_tail_pointer(skb), RX_URB_SIZE,
+						rtl8192_rx_isr, skb);
 		info = (struct rtl8192_rx_info *) skb->cb;
 		info->urb = entry;
 		info->dev = dev;
@@ -955,40 +956,41 @@ void rtl8192_set_rxconf(struct net_device *dev)
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
 	u32 rxconf;
 
-	rxconf=read_nic_dword(dev,RCR);
-	rxconf = rxconf &~ MAC_FILTER_MASK;
+	rxconf = read_nic_dword(dev, RCR);
+	rxconf = rxconf & ~MAC_FILTER_MASK;
 	rxconf = rxconf | RCR_AMF;
 	rxconf = rxconf | RCR_ADF;
 	rxconf = rxconf | RCR_AB;
 	rxconf = rxconf | RCR_AM;
 	/* rxconf = rxconf | RCR_ACF; */
 
-	if (dev->flags & IFF_PROMISC) {DMESG ("NIC in promisc mode");}
+	if (dev->flags & IFF_PROMISC)
+		DMESG("NIC in promisc mode");
 
-	if(priv->ieee80211->iw_mode == IW_MODE_MONITOR || \
+	if (priv->ieee80211->iw_mode == IW_MODE_MONITOR ||
 	   dev->flags & IFF_PROMISC){
 		rxconf = rxconf | RCR_AAP;
 	} /*else if(priv->ieee80211->iw_mode == IW_MODE_MASTER){
 		rxconf = rxconf | (1<<ACCEPT_ALLMAC_FRAME_SHIFT);
 		rxconf = rxconf | (1<<RX_CHECK_BSSID_SHIFT);
-	}*/else{
+	}*/else {
 		rxconf = rxconf | RCR_APM;
 		rxconf = rxconf | RCR_CBSSID;
 	}
 
 
-	if(priv->ieee80211->iw_mode == IW_MODE_MONITOR){
+	if (priv->ieee80211->iw_mode == IW_MODE_MONITOR) {
 		rxconf = rxconf | RCR_AICV;
 		rxconf = rxconf | RCR_APWRMGT;
 	}
 
-	if( priv->crcmon == 1 && priv->ieee80211->iw_mode == IW_MODE_MONITOR)
+	if (priv->crcmon == 1 && priv->ieee80211->iw_mode == IW_MODE_MONITOR)
 		rxconf = rxconf | RCR_ACRC32;
 
 
-	rxconf = rxconf &~ RX_FIFO_THRESHOLD_MASK;
+	rxconf = rxconf & ~RX_FIFO_THRESHOLD_MASK;
 	rxconf = rxconf | (RX_FIFO_THRESHOLD_NONE<<RX_FIFO_THRESHOLD_SHIFT);
-	rxconf = rxconf &~ MAX_RX_DMA_MASK;
+	rxconf = rxconf & ~MAX_RX_DMA_MASK;
 	rxconf = rxconf | ((u32)7<<RCR_MXDMA_OFFSET);
 
 	/* rxconf = rxconf | (1<<RX_AUTORESETPHY_SHIFT); */
@@ -1000,7 +1002,7 @@ void rtl8192_set_rxconf(struct net_device *dev)
 	write_nic_dword(dev, RCR, rxconf);
 
 	#ifdef DEBUG_RX
-	DMESG("rxconf: %x %x",rxconf ,read_nic_dword(dev,RCR));
+	DMESG("rxconf: %x %x", rxconf, read_nic_dword(dev, RCR));
 	#endif
 }
 
@@ -1032,9 +1034,8 @@ void rtl8192_rtx_disable(struct net_device *dev)
 	struct sk_buff *skb;
 	struct rtl8192_rx_info *info;
 
-	cmd=read_nic_byte(dev,CMDR);
-	write_nic_byte(dev, CMDR, cmd &~ \
-		(CR_TE|CR_RE));
+	cmd = read_nic_byte(dev, CMDR);
+	write_nic_byte(dev, CMDR, cmd & ~(CR_TE|CR_RE));
 	force_pci_posting(dev);
 	mdelay(10);
 
@@ -1047,9 +1048,8 @@ void rtl8192_rtx_disable(struct net_device *dev)
 		kfree_skb(skb);
 	}
 
-	if (skb_queue_len(&priv->skb_queue)) {
+	if (skb_queue_len(&priv->skb_queue))
 		printk(KERN_WARNING "skb_queue not empty\n");
-	}
 
 	skb_queue_purge(&priv->skb_queue);
 	return;
@@ -1063,7 +1063,7 @@ int alloc_tx_beacon_desc_ring(struct net_device *dev, int count)
 
 inline u16 ieeerate2rtlrate(int rate)
 {
-	switch(rate){
+	switch (rate) {
 	case 10:
 	return 0;
 	case 20:
@@ -1090,17 +1090,17 @@ inline u16 ieeerate2rtlrate(int rate)
 	return 11;
 	default:
 	return 3;
-
 	}
 }
-static u16 rtl_rate[] = {10,20,55,110,60,90,120,180,240,360,480,540};
+static u16 rtl_rate[] = {10, 20, 55, 110, 60, 90, 120, 180, 240,
+								360, 480, 540};
 inline u16 rtl8192_rate2rate(short rate)
 {
-	if (rate >11) return 0;
+	if (rate > 11)
+		return 0;
 	return rtl_rate[rate];
 }
 
-
 /* The protype of rx_isr has changed since one verion of Linux Kernel */
 static void rtl8192_rx_isr(struct urb *urb)
 {
@@ -1110,7 +1110,7 @@ static void rtl8192_rx_isr(struct urb *urb)
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	int out_pipe = info->out_pipe;
 	int err;
-	if(!priv->up)
+	if (!priv->up)
 		return;
 	if (unlikely(urb->status)) {
 		info->urb = NULL;
@@ -1135,8 +1135,9 @@ static void rtl8192_rx_isr(struct urb *urb)
 	}
 
 	usb_fill_bulk_urb(urb, priv->udev,
-			usb_rcvbulkpipe(priv->udev, out_pipe), skb_tail_pointer(skb),
-			RX_URB_SIZE, rtl8192_rx_isr, skb);
+			usb_rcvbulkpipe(priv->udev, out_pipe),
+			skb_tail_pointer(skb), RX_URB_SIZE,
+						rtl8192_rx_isr, skb);
 
 	info = (struct rtl8192_rx_info *) skb->cb;
 	info->urb = urb;
@@ -1147,8 +1148,9 @@ static void rtl8192_rx_isr(struct urb *urb)
 	urb->context = skb;
 	skb_queue_tail(&priv->rx_queue, skb);
 	err = usb_submit_urb(urb, GFP_ATOMIC);
-	if(err && err != EPERM)
-		printk("can not submit rxurb, err is %x,URB status is %x\n",err,urb->status);
+	if (err && err != EPERM)
+		printk("can not submit rxurb, err is %x,URB status is %x\n",
+							err, urb->status);
 }
 
 u32
@@ -1164,12 +1166,9 @@ rtl819xusb_rx_command_packet(
 	 */
 
 	status = cmpk_message_handle_rx(dev, pstats);
-	if (status)
-	{
+	if (status) {
 		DMESG("rxcommandpackethandle819xusb: It is a command packet\n");
-	}
-	else
-	{
+	} else {
 		/* RT_TRACE(COMP_RECV, DBG_TRACE,
 		 *			("RxCommandPacketHandle819xUsb:
 		 *			It is not a command packet\n"));
@@ -1196,7 +1195,8 @@ void rtl8192_data_hard_resume(struct net_device *dev)
 /* this function TX data frames when the ieee80211 stack requires this.
  * It checks also if we need to stop the ieee tx queue, eventually do it
  */
-void rtl8192_hard_data_xmit(struct sk_buff *skb, struct net_device *dev, int rate)
+void rtl8192_hard_data_xmit(struct sk_buff *skb, struct net_device *dev,
+								int rate)
 {
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
 	int ret;
@@ -1207,9 +1207,9 @@ void rtl8192_hard_data_xmit(struct sk_buff *skb, struct net_device *dev, int rat
 	/* shall not be referred by command packet */
 	assert(queue_index != TXCMD_QUEUE);
 
-	spin_lock_irqsave(&priv->tx_lock,flags);
+	spin_lock_irqsave(&priv->tx_lock, flags);
 
-	memcpy((unsigned char *)(skb->cb),&dev,sizeof(dev));
+	memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
 	/* tcb_desc->RATRIndex = 7; */
 	/* tcb_desc->bTxDisableRateFallBack = 1; */
 	/* tcb_desc->bTxUseDriverAssingedRate = 1; */
@@ -1222,7 +1222,7 @@ void rtl8192_hard_data_xmit(struct sk_buff *skb, struct net_device *dev, int rat
 	 */
 	/* priv->ieee80211->stats.tx_packets++; */
 
-	spin_unlock_irqrestore(&priv->tx_lock,flags);
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
 
 	/* return ret; */
 	return;
@@ -1233,7 +1233,7 @@ void rtl8192_hard_data_xmit(struct sk_buff *skb, struct net_device *dev, int rat
  * If the ring is full packet are dropped (for data frame the queue
  * is stopped before this can happen).
  */
-int rtl8192_hard_start_xmit(struct sk_buff *skb,struct net_device *dev)
+int rtl8192_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
 	int ret;
@@ -1242,21 +1242,21 @@ int rtl8192_hard_start_xmit(struct sk_buff *skb,struct net_device *dev)
 	u8 queue_index = tcb_desc->queue_index;
 
 
-	spin_lock_irqsave(&priv->tx_lock,flags);
+	spin_lock_irqsave(&priv->tx_lock, flags);
 
-	memcpy((unsigned char *)(skb->cb),&dev,sizeof(dev));
-	if(queue_index == TXCMD_QUEUE) {
+	memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
+	if (queue_index == TXCMD_QUEUE) {
 		skb_push(skb, USB_HWDESC_HEADER_LEN);
 		rtl819xU_tx_cmd(dev, skb);
 		ret = 1;
-		spin_unlock_irqrestore(&priv->tx_lock,flags);
+		spin_unlock_irqrestore(&priv->tx_lock, flags);
 		return ret;
 	} else {
 		skb_push(skb, priv->ieee80211->tx_headroom);
 		ret = rtl8192_tx(dev, skb);
 	}
 
-	spin_unlock_irqrestore(&priv->tx_lock,flags);
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
 
 	return ret;
 }
@@ -1267,27 +1267,29 @@ void rtl8192_try_wake_queue(struct net_device *dev, int pri);
 #ifdef USB_TX_DRIVER_AGGREGATION_ENABLE
 u16 DrvAggr_PaddingAdd(struct net_device *dev, struct sk_buff *skb)
 {
-	u16     PaddingNum =  256 - ((skb->len + TX_PACKET_DRVAGGR_SUBFRAME_SHIFT_BYTES) % 256);
-	return  (PaddingNum&0xff);
+	u16	PaddingNum =  256 - ((skb->len +
+				TX_PACKET_DRVAGGR_SUBFRAME_SHIFT_BYTES) % 256);
+	return PaddingNum&0xff;
 }
 
 u8 MRateToHwRate8190Pci(u8 rate);
 u8 QueryIsShort(u8 TxHT, u8 TxRate, cb_desc *tcb_desc);
 u8 MapHwQueueToFirmwareQueue(u8 QueueID);
-struct sk_buff *DrvAggr_Aggregation(struct net_device *dev, struct ieee80211_drv_agg_txb *pSendList)
+struct sk_buff *DrvAggr_Aggregation(struct net_device *dev,
+				struct ieee80211_drv_agg_txb *pSendList)
 {
 	struct ieee80211_device *ieee = netdev_priv(dev);
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	cb_desc 	*tcb_desc = NULL;
-	u8 		i;
+	cb_desc		*tcb_desc = NULL;
+	u8		i;
 	u32		TotalLength;
 	struct sk_buff	*skb;
-	struct sk_buff  *agg_skb;
+	struct sk_buff	*agg_skb;
 	tx_desc_819x_usb_aggr_subframe *tx_agg_desc = NULL;
 	tx_fwinfo_819x_usb	       *tx_fwinfo = NULL;
 
 	/* Local variable initialization. */
-	
+
 	/* first skb initialization */
 	skb = pSendList->tx_agg_frames[0];
 	TotalLength = skb->len;
@@ -1295,10 +1297,11 @@ struct sk_buff *DrvAggr_Aggregation(struct net_device *dev, struct ieee80211_drv
 	/* Get the total aggregation length including the padding space and
 	 * sub frame header.
 	 */
-	for(i = 1; i < pSendList->nr_drv_agg_frames; i++) {
+	for (i = 1; i < pSendList->nr_drv_agg_frames; i++) {
 		TotalLength += DrvAggr_PaddingAdd(dev, skb);
 		skb = pSendList->tx_agg_frames[i];
-		TotalLength += (skb->len + TX_PACKET_DRVAGGR_SUBFRAME_SHIFT_BYTES);
+		TotalLength += (skb->len +
+				TX_PACKET_DRVAGGR_SUBFRAME_SHIFT_BYTES);
 	}
 
 	/* allocate skb to contain the aggregated packets */
@@ -1317,28 +1320,31 @@ struct sk_buff *DrvAggr_Aggregation(struct net_device *dev, struct ieee80211_drv
 	tcb_desc->DrvAggrNum = pSendList->nr_drv_agg_frames;
 	printk("DrvAggNum = %d\n", tcb_desc->DrvAggrNum);
 	/* RT_DEBUG_DATA(COMP_SEND, skb->cb, sizeof(skb->cb)); */
-	/* printk("========>skb->data ======> \n"); */
+	/* printk("========>skb->data ======>\n"); */
 	/* RT_DEBUG_DATA(COMP_SEND, skb->data, skb->len); */
 	memcpy(agg_skb->cb, skb->cb, sizeof(skb->cb));
-	memcpy(skb_put(agg_skb,skb->len),skb->data,skb->len);
+	memcpy(skb_put(agg_skb, skb->len), skb->data, skb->len);
 
-	for(i = 1; i < pSendList->nr_drv_agg_frames; i++) {
+	for (i = 1; i < pSendList->nr_drv_agg_frames; i++) {
 		/* push the next sub frame to be 256 byte aline */
-		skb_put(agg_skb,DrvAggr_PaddingAdd(dev,skb));
+		skb_put(agg_skb, DrvAggr_PaddingAdd(dev, skb));
 
 		/* Subframe drv Tx descriptor and firmware info setting */
 		skb = pSendList->tx_agg_frames[i];
 		tcb_desc = (cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
 		tx_agg_desc = (tx_desc_819x_usb_aggr_subframe *)agg_skb->tail;
-		tx_fwinfo = (tx_fwinfo_819x_usb *)(agg_skb->tail + sizeof(tx_desc_819x_usb_aggr_subframe));
+		tx_fwinfo = (tx_fwinfo_819x_usb *)(agg_skb->tail +
+				sizeof(tx_desc_819x_usb_aggr_subframe));
 
-		memset(tx_fwinfo,0,sizeof(tx_fwinfo_819x_usb));
+		memset(tx_fwinfo, 0, sizeof(tx_fwinfo_819x_usb));
 		/* DWORD 0 */
-		tx_fwinfo->TxHT = (tcb_desc->data_rate&0x80)?1:0;
+		tx_fwinfo->TxHT = (tcb_desc->data_rate & 0x80) ? 1 : 0;
 		tx_fwinfo->TxRate = MRateToHwRate8190Pci(tcb_desc->data_rate);
 		tx_fwinfo->EnableCPUDur = tcb_desc->bTxEnableFwCalcDur;
-		tx_fwinfo->Short = QueryIsShort(tx_fwinfo->TxHT, tx_fwinfo->TxRate, tcb_desc);
-		if(tcb_desc->bAMPDUEnable) {		/* AMPDU enabled */
+		tx_fwinfo->Short = QueryIsShort(tx_fwinfo->TxHT,
+						tx_fwinfo->TxRate, tcb_desc);
+
+		if (tcb_desc->bAMPDUEnable) {		/* AMPDU enabled */
 			tx_fwinfo->AllowAggregation = 1;
 			/* DWORD 1 */
 			tx_fwinfo->RxMF = tcb_desc->ampdu_factor;
@@ -1352,20 +1358,24 @@ struct sk_buff *DrvAggr_Aggregation(struct net_device *dev, struct ieee80211_drv
 		}
 
 		/* Protection mode related */
-		tx_fwinfo->RtsEnable = (tcb_desc->bRTSEnable)?1:0;
-		tx_fwinfo->CtsEnable = (tcb_desc->bCTSEnable)?1:0;
-		tx_fwinfo->RtsSTBC = (tcb_desc->bRTSSTBC)?1:0;
-		tx_fwinfo->RtsHT = (tcb_desc->rts_rate&0x80)?1:0;
-		tx_fwinfo->RtsRate =  MRateToHwRate8190Pci((u8)tcb_desc->rts_rate);
-		tx_fwinfo->RtsSubcarrier = (tx_fwinfo->RtsHT==0)?(tcb_desc->RTSSC):0;
-		tx_fwinfo->RtsBandwidth = (tx_fwinfo->RtsHT==1)?((tcb_desc->bRTSBW)?1:0):0;
-		tx_fwinfo->RtsShort = (tx_fwinfo->RtsHT==0)?(tcb_desc->bRTSUseShortPreamble?1:0):\
-				      (tcb_desc->bRTSUseShortGI?1:0);
+		tx_fwinfo->RtsEnable = (tcb_desc->bRTSEnable) ? 1 : 0;
+		tx_fwinfo->CtsEnable = (tcb_desc->bCTSEnable) ? 1 : 0;
+		tx_fwinfo->RtsSTBC = (tcb_desc->bRTSSTBC) ? 1 : 0;
+		tx_fwinfo->RtsHT = (tcb_desc->rts_rate&0x80) ? 1 : 0;
+		tx_fwinfo->RtsRate =  MRateToHwRate8190Pci((u8)
+							tcb_desc->rts_rate);
+		tx_fwinfo->RtsSubcarrier = (tx_fwinfo->RtsHT == 0) ?
+							(tcb_desc->RTSSC) : 0;
+		tx_fwinfo->RtsBandwidth = (tx_fwinfo->RtsHT == 1) ?
+					((tcb_desc->bRTSBW) ? 1 : 0) : 0;
+		tx_fwinfo->RtsShort = (tx_fwinfo->RtsHT == 0) ?
+					(tcb_desc->bRTSUseShortPreamble ?
+					1 : 0) : (tcb_desc->bRTSUseShortGI ?
+								 1 : 0);
 
 		/* Set Bandwidth and sub-channel settings. */
-		if(priv->CurrentChannelBW == HT_CHANNEL_WIDTH_20_40)
-		{
-			if(tcb_desc->bPacketBW) {
+		if (priv->CurrentChannelBW == HT_CHANNEL_WIDTH_20_40) {
+			if (tcb_desc->bPacketBW) {
 				tx_fwinfo->TxBandwidth = 1;
 				tx_fwinfo->TxSubCarrier = 0;
 				/* By SD3's Jerry suggestion,
@@ -1373,7 +1383,8 @@ struct sk_buff *DrvAggr_Aggregation(struct net_device *dev, struct ieee80211_drv
 				 */
 			} else {
 				tx_fwinfo->TxBandwidth = 0;
-				tx_fwinfo->TxSubCarrier = priv->nCur40MhzPrimeSC;
+				tx_fwinfo->TxSubCarrier =
+							priv->nCur40MhzPrimeSC;
 			}
 		} else {
 			tx_fwinfo->TxBandwidth = 0;
@@ -1390,7 +1401,7 @@ struct sk_buff *DrvAggr_Aggregation(struct net_device *dev, struct ieee80211_drv
 		tx_agg_desc->PktSize = skb->len & 0xffff;
 
 		/*DWORD 1*/
-		tx_agg_desc->SecCAMID= 0;
+		tx_agg_desc->SecCAMID = 0;
 		tx_agg_desc->RATid = tcb_desc->RATRIndex;
 		{
 			/* MPDUOverhead = 0; */
@@ -1399,29 +1410,29 @@ struct sk_buff *DrvAggr_Aggregation(struct net_device *dev, struct ieee80211_drv
 		tx_agg_desc->SecType = 0x0;
 
 		if (tcb_desc->bHwSec) {
-			switch (priv->ieee80211->pairwise_key_type)
-			{
-				case KEY_TYPE_WEP40:
-				case KEY_TYPE_WEP104:
-					tx_agg_desc->SecType = 0x1;
-					tx_agg_desc->NoEnc = 0;
-					break;
-				case KEY_TYPE_TKIP:
-					tx_agg_desc->SecType = 0x2;
-					tx_agg_desc->NoEnc = 0;
-					break;
-				case KEY_TYPE_CCMP:
-					tx_agg_desc->SecType = 0x3;
-					tx_agg_desc->NoEnc = 0;
-					break;
-				case KEY_TYPE_NA:
-					tx_agg_desc->SecType = 0x0;
-					tx_agg_desc->NoEnc = 1;
-					break;
+			switch (priv->ieee80211->pairwise_key_type) {
+			case KEY_TYPE_WEP40:
+			case KEY_TYPE_WEP104:
+				tx_agg_desc->SecType = 0x1;
+				tx_agg_desc->NoEnc = 0;
+				break;
+			case KEY_TYPE_TKIP:
+				tx_agg_desc->SecType = 0x2;
+				tx_agg_desc->NoEnc = 0;
+				break;
+			case KEY_TYPE_CCMP:
+				tx_agg_desc->SecType = 0x3;
+				tx_agg_desc->NoEnc = 0;
+				break;
+			case KEY_TYPE_NA:
+				tx_agg_desc->SecType = 0x0;
+				tx_agg_desc->NoEnc = 1;
+				break;
 			}
 		}
 
-		tx_agg_desc->QueueSelect = MapHwQueueToFirmwareQueue(tcb_desc->queue_index);
+		tx_agg_desc->QueueSelect = MapHwQueueToFirmwareQueue
+						(tcb_desc->queue_index);
 		tx_agg_desc->TxFWInfoSize =  sizeof(tx_fwinfo_819x_usb);
 
 		tx_agg_desc->DISFB = tcb_desc->bTxDisableRateFallBack;
@@ -1438,13 +1449,12 @@ struct sk_buff *DrvAggr_Aggregation(struct net_device *dev, struct ieee80211_drv
 		 */
 
 		/* to fill next packet */
-		skb_put(agg_skb,TX_PACKET_DRVAGGR_SUBFRAME_SHIFT_BYTES);
-		memcpy(skb_put(agg_skb,skb->len),skb->data,skb->len);
+		skb_put(agg_skb, TX_PACKET_DRVAGGR_SUBFRAME_SHIFT_BYTES);
+		memcpy(skb_put(agg_skb, skb->len), skb->data, skb->len);
 	}
 
-	for(i = 0; i < pSendList->nr_drv_agg_frames; i++) {
+	for (i = 0; i < pSendList->nr_drv_agg_frames; i++)
 		dev_kfree_skb_any(pSendList->tx_agg_frames[i]);
-	}
 
 	return agg_skb;
 }
@@ -1461,25 +1471,25 @@ u8 DrvAggr_GetAggregatibleList(struct net_device *dev, struct sk_buff *skb,
 	struct ieee80211_device *ieee = netdev_priv(dev);
 	PRT_HIGH_THROUGHPUT	pHTInfo = ieee->pHTInfo;
 	u16		nMaxAggrNum = pHTInfo->UsbTxAggrNum;
-	cb_desc 	*tcb_desc = (cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
+	cb_desc		*tcb_desc = (cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
 	u8		QueueID = tcb_desc->queue_index;
 
 	do {
 		pSendList->tx_agg_frames[pSendList->nr_drv_agg_frames++] = skb;
-		if(pSendList->nr_drv_agg_frames >= nMaxAggrNum) {
+		if (pSendList->nr_drv_agg_frames >= nMaxAggrNum)
 			break;
-		}
 
-	} while((skb = skb_dequeue(&ieee->skb_drv_aggQ[QueueID])));
+	} while ((skb = skb_dequeue(&ieee->skb_drv_aggQ[QueueID])));
 
-	RT_TRACE(COMP_AMSDU, "DrvAggr_GetAggregatibleList, nAggrTcbNum = %d \n", pSendList->nr_drv_agg_frames);
+	RT_TRACE(COMP_AMSDU, "DrvAggr_GetAggregatibleList, nAggrTcbNum = %d\n",
+						pSendList->nr_drv_agg_frames);
 	return pSendList->nr_drv_agg_frames;
 }
 #endif
 
 static void rtl8192_tx_isr(struct urb *tx_urb)
 {
-	struct sk_buff *skb = (struct sk_buff*)tx_urb->context;
+	struct sk_buff *skb = (struct sk_buff *)tx_urb->context;
 	struct net_device *dev = NULL;
 	struct r8192_priv *priv = NULL;
 	cb_desc *tcb_desc = (cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
@@ -1487,11 +1497,12 @@ static void rtl8192_tx_isr(struct urb *tx_urb)
 	/* bool bToSend0Byte; */
 	/* u16 BufLen = skb->len; */
 
-	memcpy(&dev,(struct net_device*)(skb->cb),sizeof(struct net_device*));
+	memcpy(&dev, (struct net_device *)(skb->cb),
+		sizeof(struct net_device *));
 	priv = ieee80211_priv(dev);
 
-	if(tcb_desc->queue_index != TXCMD_QUEUE) {
-		if(tx_urb->status == 0) {
+	if (tcb_desc->queue_index != TXCMD_QUEUE) {
+		if (tx_urb->status == 0) {
 			dev->trans_start = jiffies;
 			/* As act as station mode, destion shall be
 			 *				 unicast address.
@@ -1512,14 +1523,13 @@ static void rtl8192_tx_isr(struct urb *tx_urb)
 	}
 
 	/* free skb and tx_urb */
-	if(skb != NULL) {
+	if (skb != NULL) {
 		dev_kfree_skb_any(skb);
 		usb_free_urb(tx_urb);
 		atomic_dec(&priv->tx_pending[queue_index]);
 	}
 
 	{
-		
 		/* Handle HW Beacon:
 		 * We had transfer our beacon frame to host controler
 		 * at this moment.
@@ -1533,31 +1543,44 @@ static void rtl8192_tx_isr(struct urb *tx_urb)
 		 */
 
 		/* Handle MPDU in wait queue. */
-		if(queue_index != BEACON_QUEUE) {
+		if (queue_index != BEACON_QUEUE) {
 			/* Don't send data frame during scanning.*/
-			if((skb_queue_len(&priv->ieee80211->skb_waitQ[queue_index]) != 0)&&\
-					(!(priv->ieee80211->queue_stop))) {
-				if(NULL != (skb = skb_dequeue(&(priv->ieee80211->skb_waitQ[queue_index]))))
-					priv->ieee80211->softmac_hard_start_xmit(skb, dev);
-
+			if ((skb_queue_len(&priv->ieee80211->skb_waitQ
+					[queue_index]) != 0) && (
+					!(priv->ieee80211->queue_stop))) {
+				if (NULL != (skb = skb_dequeue(&
+						(priv->ieee80211->
+						skb_waitQ[queue_index]))))
+						priv->ieee80211->
+						softmac_hard_start_xmit
+						(skb, dev);
 				return;
 		/* modified by david to avoid further processing AMSDU */
 			}
 #ifdef USB_TX_DRIVER_AGGREGATION_ENABLE
-			else if ((skb_queue_len(&priv->ieee80211->skb_drv_aggQ[queue_index])!= 0)&&\
-				(!(priv->ieee80211->queue_stop))) {
+			else if ((skb_queue_len(&priv->ieee80211->
+					skb_drv_aggQ[queue_index]) != 0) &&
+					(!(priv->ieee80211->queue_stop))) {
 				/*  Tx Driver Aggregation process */
-				/* The driver will aggregation the packets according to the following stets
-				 * 1. check whether there's tx irq available, for it's a completion return
-				 *    function, it should contain enough tx irq;
+				/* The driver will aggregation the packets
+				 * according to the following stets
+				 * 1. check whether there's tx irq available,
+				 * for it's a completion return function,
+				 * it should contain enough tx irq;
 				 * 2. check pakcet type;
-				 * 3. intialize sendlist, check whether the to-be send packet no greater than 1
-				 * 4. aggregation the packets, and fill firmware info and tx desc to it, etc.
-				 * 5. check whehter the packet could be sent, otherwise just insert to wait head
+				 * 3. intialize sendlist, check whether the
+				 * to-be send packet no greater than 1
+				 * 4. aggregation the packets, and fill
+				 * firmware info and tx desc to it, etc.
+				 * 5. check whehter the packet could be sent,
+				 * otherwise just insert to wait head
 				 */
-				skb = skb_dequeue(&priv->ieee80211->skb_drv_aggQ[queue_index]);
-				if(!check_nic_enough_desc(dev, queue_index)) {
-					skb_queue_head(&(priv->ieee80211->skb_drv_aggQ[queue_index]), skb);
+				skb = skb_dequeue(&priv->ieee80211->
+						skb_drv_aggQ[queue_index]);
+				if (!check_nic_enough_desc(dev, queue_index)) {
+					skb_queue_head(&(priv->ieee80211->
+							skb_drv_aggQ
+							[queue_index]), skb);
 					return;
 				}
 
@@ -1573,15 +1596,24 @@ static void rtl8192_tx_isr(struct urb *tx_urb)
 					  )
 					*/
 					{
-						struct ieee80211_drv_agg_txb SendList;
-
-						memset(&SendList, 0, sizeof(struct ieee80211_drv_agg_txb));
-						if(DrvAggr_GetAggregatibleList(dev, skb, &SendList) > 1) {
-							skb = DrvAggr_Aggregation(dev, &SendList);
-
+						struct ieee80211_drv_agg_txb
+								SendList;
+
+						memset(&SendList, 0,
+							sizeof(struct
+							ieee80211_drv_agg_txb));
+						if (DrvAggr_GetAggregatibleList
+							(dev, skb, &SendList)
+							> 1) {
+								skb =
+								DrvAggr_
+								Aggregation
+								(dev,
+								&SendList);
 						}
 					}
-					priv->ieee80211->softmac_hard_start_xmit(skb, dev);
+					priv->ieee80211->softmac_hard_start_
+								xmit(skb, dev);
 				}
 			}
 #endif
@@ -1599,68 +1631,111 @@ void rtl8192_beacon_stop(struct net_device *dev)
 	msrm = msr & MSR_LINK_MASK;
 	msr2 = msr & ~MSR_LINK_MASK;
 
-	if(NIC_8192U == priv->card_8192) {
+	if (NIC_8192U == priv->card_8192)
 		usb_kill_urb(priv->rx_urb[MAX_RX_URB]);
-	}
 	if ((msrm == (MSR_LINK_ADHOC<<MSR_LINK_SHIFT) ||
-		(msrm == (MSR_LINK_MASTER<<MSR_LINK_SHIFT)))){
+			(msrm == (MSR_LINK_MASTER<<MSR_LINK_SHIFT))))
 		write_nic_byte(dev, MSR, msr2 | MSR_LINK_NONE);
 		write_nic_byte(dev, MSR, msr);
-	}
 }
 
-void rtl8192_config_rate(struct net_device* dev, u16* rate_config)
+void rtl8192_config_rate(struct net_device *dev, u16 *rate_config)
 {
-	 struct r8192_priv *priv = ieee80211_priv(dev);
-	 struct ieee80211_network *net;
-	 u8 i=0, basic_rate = 0;
-	 net = & priv->ieee80211->current_network;
-
-	 for (i=0; i<net->rates_len; i++)
-	 {
-		 basic_rate = net->rates[i]&0x7f;
-		 switch(basic_rate)
-		 {
-			 case MGN_1M:	*rate_config |= RRSR_1M;	break;
-			 case MGN_2M:	*rate_config |= RRSR_2M;	break;
-			 case MGN_5_5M:	*rate_config |= RRSR_5_5M;	break;
-			 case MGN_11M:	*rate_config |= RRSR_11M;	break;
-			 case MGN_6M:	*rate_config |= RRSR_6M;	break;
-			 case MGN_9M:	*rate_config |= RRSR_9M;	break;
-			 case MGN_12M:	*rate_config |= RRSR_12M;	break;
-			 case MGN_18M:	*rate_config |= RRSR_18M;	break;
-			 case MGN_24M:	*rate_config |= RRSR_24M;	break;
-			 case MGN_36M:	*rate_config |= RRSR_36M;	break;
-			 case MGN_48M:	*rate_config |= RRSR_48M;	break;
-			 case MGN_54M:	*rate_config |= RRSR_54M;	break;
-		 }
-	 }
-	 for (i=0; i<net->rates_ex_len; i++)
-	 {
-		 basic_rate = net->rates_ex[i]&0x7f;
-		 switch(basic_rate)
-		 {
-			 case MGN_1M:	*rate_config |= RRSR_1M;	break;
-			 case MGN_2M:	*rate_config |= RRSR_2M;	break;
-			 case MGN_5_5M:	*rate_config |= RRSR_5_5M;	break;
-			 case MGN_11M:	*rate_config |= RRSR_11M;	break;
-			 case MGN_6M:	*rate_config |= RRSR_6M;	break;
-			 case MGN_9M:	*rate_config |= RRSR_9M;	break;
-			 case MGN_12M:	*rate_config |= RRSR_12M;	break;
-			 case MGN_18M:	*rate_config |= RRSR_18M;	break;
-			 case MGN_24M:	*rate_config |= RRSR_24M;	break;
-			 case MGN_36M:	*rate_config |= RRSR_36M;	break;
-			 case MGN_48M:	*rate_config |= RRSR_48M;	break;
-			 case MGN_54M:	*rate_config |= RRSR_54M;	break;
-		 }
-	 }
+	struct r8192_priv *priv = ieee80211_priv(dev);
+	struct ieee80211_network *net;
+	u8 i = 0;
+	u8 basic_rate = 0;
+	net = &priv->ieee80211->current_network;
+
+	for (i = 0; i < net->rates_len; i++) {
+		basic_rate = net->rates[i]&0x7f;
+		switch (basic_rate) {
+		case MGN_1M:
+			*rate_config |= RRSR_1M;
+			break;
+		case MGN_2M:
+			*rate_config |= RRSR_2M;
+			break;
+		case MGN_5_5M:
+			*rate_config |= RRSR_5_5M;
+			break;
+		case MGN_11M:
+			*rate_config |= RRSR_11M;
+			break;
+		case MGN_6M:
+			*rate_config |= RRSR_6M;
+			break;
+		case MGN_9M:
+			*rate_config |= RRSR_9M;
+			break;
+		case MGN_12M:
+			*rate_config |= RRSR_12M;
+			break;
+		case MGN_18M:
+			*rate_config |= RRSR_18M;
+			break;
+		case MGN_24M:
+			*rate_config |= RRSR_24M;
+			break;
+		case MGN_36M:
+			*rate_config |= RRSR_36M;
+			break;
+		case MGN_48M:
+			*rate_config |= RRSR_48M;
+			break;
+		case MGN_54M:
+			*rate_config |= RRSR_54M;
+			break;
+		}
+	}
+	for (i = 0; i < net->rates_ex_len; i++) {
+		basic_rate = net->rates_ex[i]&0x7f;
+		switch (basic_rate) {
+		case MGN_1M:
+			*rate_config |= RRSR_1M;
+			break;
+		case MGN_2M:
+			*rate_config |= RRSR_2M;
+			break;
+		case MGN_5_5M:
+			*rate_config |= RRSR_5_5M;
+			break;
+		case MGN_11M:
+			*rate_config |= RRSR_11M;
+			break;
+		case MGN_6M:
+			*rate_config |= RRSR_6M;
+			break;
+		case MGN_9M:
+			*rate_config |= RRSR_9M;
+			break;
+		case MGN_12M:
+			*rate_config |= RRSR_12M;
+			break;
+		case MGN_18M:
+			*rate_config |= RRSR_18M;
+			break;
+		case MGN_24M:
+			*rate_config |= RRSR_24M;
+			break;
+		case MGN_36M:
+			*rate_config |= RRSR_36M;
+			break;
+		case MGN_48M:
+			*rate_config |= RRSR_48M;
+			break;
+		case MGN_54M:
+			*rate_config |= RRSR_54M;
+			break;
+		}
+	}
 }
 
 
 #define SHORT_SLOT_TIME 9
 #define NON_SHORT_SLOT_TIME 20
 
-void rtl8192_update_cap(struct net_device* dev, u16 cap)
+void rtl8192_update_cap(struct net_device *dev, u16 cap)
 {
 	u32 tmp = 0;
 	struct r8192_priv *priv = ieee80211_priv(dev);
@@ -1673,11 +1748,11 @@ void rtl8192_update_cap(struct net_device* dev, u16 cap)
 
 	if (net->mode & (IEEE_G|IEEE_N_24G)) {
 		u8 slot_time = 0;
-		if ((cap & WLAN_CAPABILITY_SHORT_SLOT) && (!priv->ieee80211->pHTInfo->bCurrentRT2RTLongSlotTime)) {
+		if ((cap & WLAN_CAPABILITY_SHORT_SLOT) && (!priv->ieee80211->
+					pHTInfo->bCurrentRT2RTLongSlotTime)) {
 			/* short slot time */
 			slot_time = SHORT_SLOT_TIME;
-		}
-		else
+		} else
 			/* long slot time */
 			slot_time = NON_SHORT_SLOT_TIME;
 		priv->slot_time = slot_time;
@@ -1692,13 +1767,13 @@ void rtl8192_net_update(struct net_device *dev)
 	struct ieee80211_network *net;
 	u16 BcnTimeCfg = 0, BcnCW = 6, BcnIFS = 0xf;
 	u16 rate_config = 0;
-	net = & priv->ieee80211->current_network;
+	net = &priv->ieee80211->current_network;
 
 	rtl8192_config_rate(dev, &rate_config);
 	priv->basic_rate = rate_config &= 0x15f;
 
-	write_nic_dword(dev,BSSIDR,((u32*)net->bssid)[0]);
-	write_nic_word(dev,BSSIDR+4,((u16*)net->bssid)[2]);
+	write_nic_dword(dev, BSSIDR, ((u32 *)net->bssid)[0]);
+	write_nic_word(dev, BSSIDR + 4, ((u16 *)net->bssid)[2]);
 	/* for(i = 0; i < ETH_ALEN; i++)
 	 *	write_nic_byte(dev, BSSID + i, net->bssid[i]);
 	 */
@@ -1723,15 +1798,16 @@ void rtl8192_net_update(struct net_device *dev)
 
 /* temporary hw beacon is not used any more. */
 /* open it when necessary */
-void rtl819xusb_beacon_tx(struct net_device *dev,u16  tx_rate)
+void rtl819xusb_beacon_tx(struct net_device *dev, u16  tx_rate)
 {
 
 }
 inline u8 rtl8192_IsWirelessBMode(u16 rate)
 {
-	if( ((rate <= 110) && (rate != 60) && (rate != 90)) || (rate == 220) )
+	if (((rate <= 110) && (rate != 60) && (rate != 90)) || (rate == 220))
 		return 1;
-	else return 0;
+	else
+		return 0;
 }
 
 u16 N_DBPSOfRate(u16 DataRate);
@@ -1747,21 +1823,23 @@ u16 ComputeTxTime(
 	u16	N_DBPS;
 	u16	Ceiling;
 
-	if ( rtl8192_IsWirelessBMode(DataRate) )
-	{
-		if (bManagementFrame || !bShortPreamble || DataRate == 10 ) {
+	if (rtl8192_IsWirelessBMode(DataRate)) {
+		if (bManagementFrame || !bShortPreamble || DataRate == 10) {
 			/* long preamble */
-			FrameTime = (u16)(144 + 48 + (FrameLength * 8 / (DataRate / 10)));
+			FrameTime = (u16)(144 + 48 + (FrameLength * 8 /
+							(DataRate / 10)));
 		} else {
 			/* Short preamble */
-			FrameTime = (u16)(72 + 24 + (FrameLength * 8 / (DataRate / 10)));
+			FrameTime = (u16)(72 + 24 + (FrameLength * 8 /
+							(DataRate / 10)));
 		}
-		if ((FrameLength * 8 % (DataRate / 10)) != 0 )	/* Get the Ceilling */
-				FrameTime ++;
+		if ((FrameLength * 8 % (DataRate / 10)) != 0)
+				/* Get the Ceilling */
+				FrameTime++;
 	} else {	/* 802.11g DSSS-OFDM PLCP length field calculation. */
 		N_DBPS = N_DBPSOfRate(DataRate);
 		Ceiling = (16 + 8 * FrameLength + 6) / N_DBPS
-				+ (((16 + 8 * FrameLength + 6) % N_DBPS) ? 1 : 0);
+			+ (((16 + 8 * FrameLength + 6) % N_DBPS) ? 1 : 0);
 		FrameTime = (u16)(16 + 4 + 4 * Ceiling + 6);
 	}
 	return FrameTime;
@@ -1769,47 +1847,38 @@ u16 ComputeTxTime(
 
 u16 N_DBPSOfRate(u16 DataRate)
 {
-	 u16 N_DBPS = 24;
-
-	 switch(DataRate)
-	 {
-	 case 60:
-	  N_DBPS = 24;
-	  break;
-
-	 case 90:
-	  N_DBPS = 36;
-	  break;
-
-	 case 120:
-	  N_DBPS = 48;
-	  break;
-
-	 case 180:
-	  N_DBPS = 72;
-	  break;
-
-	 case 240:
-	  N_DBPS = 96;
-	  break;
-
-	 case 360:
-	  N_DBPS = 144;
-	  break;
-
-	 case 480:
-	  N_DBPS = 192;
-	  break;
-
-	 case 540:
-	  N_DBPS = 216;
-	  break;
+	u16 N_DBPS = 24;
 
-	 default:
-	  break;
-	 }
+	switch (DataRate) {
+	case 60:
+		N_DBPS = 24;
+		break;
+	case 90:
+		N_DBPS = 36;
+		break;
+	case 120:
+		N_DBPS = 48;
+		break;
+	case 180:
+		N_DBPS = 72;
+		break;
+	case 240:
+		N_DBPS = 96;
+		break;
+	case 360:
+		N_DBPS = 144;
+		break;
+	case 480:
+		N_DBPS = 192;
+		break;
+	case 540:
+		N_DBPS = 216;
+		break;
+	default:
+		break;
+	}
 
-	 return N_DBPS;
+	return N_DBPS;
 }
 
 void rtl819xU_cmd_isr(struct urb *tx_cmd_urb, struct pt_regs *regs)
@@ -1817,11 +1886,10 @@ void rtl819xU_cmd_isr(struct urb *tx_cmd_urb, struct pt_regs *regs)
 	usb_free_urb(tx_cmd_urb);
 }
 
-unsigned int txqueue2outpipe(struct r8192_priv* priv,unsigned int tx_queue) {
-
-	if(tx_queue >= 9)
-	{
-		RT_TRACE(COMP_ERR,"%s():Unknown queue ID!!!\n",__func__);
+unsigned int txqueue2outpipe(struct r8192_priv *priv, unsigned int tx_queue)
+{
+	if (tx_queue >= 9) {
+		RT_TRACE(COMP_ERR, "%s():Unknown queue ID!!!\n", __func__);
 		return 0x04;
 	}
 	return priv->txqueue_to_outpipemap[tx_queue];
@@ -1834,15 +1902,15 @@ short rtl819xU_tx_cmd(struct net_device *dev, struct sk_buff *skb)
 	int			status;
 	struct urb		*tx_urb;
 	/* int			urb_buf_len; */
-	unsigned int 		idx_pipe;
+	unsigned int		idx_pipe;
 	tx_desc_cmd_819x_usb *pdesc = (tx_desc_cmd_819x_usb *)skb->data;
 	cb_desc *tcb_desc = (cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
 	u8 queue_index = tcb_desc->queue_index;
 
 	/* printk("\n %s::queue_index = %d\n", __func__, queue_index); */
 	atomic_inc(&priv->tx_pending[queue_index]);
-	tx_urb = usb_alloc_urb(0,GFP_ATOMIC);
-	if(!tx_urb){
+	tx_urb = usb_alloc_urb(0, GFP_ATOMIC);
+	if (!tx_urb) {
 		dev_kfree_skb(skb);
 		return -ENOMEM;
 	}
@@ -1856,33 +1924,32 @@ short rtl819xU_tx_cmd(struct net_device *dev, struct sk_buff *skb)
 	pdesc->OWN = 1;
 	pdesc->LINIP = tcb_desc->bLastIniPkt;
 
-	/* ----------------------------------------------------------------------------
+	/* --------------------------------------------------------------------
 	 *  Fill up USB_OUT_CONTEXT.
-	 * ----------------------------------------------------------------------------
+	 * --------------------------------------------------------------------
 	 * Get index to out pipe from specified QueueID.
 	 */
 #ifndef USE_ONE_PIPE
-	idx_pipe = txqueue2outpipe(priv,queue_index);
+	idx_pipe = txqueue2outpipe(priv, queue_index);
 #else
 	idx_pipe = 0x04;
 #endif
 #ifdef JOHN_DUMP_TXDESC
 	int i;
-	printk("<Tx descriptor>--rate %x---",rate);
+	printk("<Tx descriptor>--rate %x---", rate);
 	for (i = 0; i < 8; i++)
 		printk("%8x ", tx[i]);
 	printk("\n");
 #endif
-	usb_fill_bulk_urb(tx_urb,priv->udev, usb_sndbulkpipe(priv->udev,idx_pipe), \
-			skb->data, skb->len, rtl8192_tx_isr, skb);
+	usb_fill_bulk_urb(tx_urb, priv->udev, usb_sndbulkpipe(priv->udev,
+			idx_pipe), skb->data, skb->len, rtl8192_tx_isr, skb);
 
 	status = usb_submit_urb(tx_urb, GFP_ATOMIC);
 
-	if (!status){
+	if (!status) {
 		return 0;
-	}else{
-		DMESGE("Error TX CMD URB, error %d",
-				status);
+	} else {
+		DMESGE("Error TX CMD URB, error %d", status);
 		return -1;
 	}
 }
@@ -1898,7 +1965,7 @@ u8 MapHwQueueToFirmwareQueue(u8 QueueID)
 {
 	u8 QueueSelect = 0x0;		/* defualt set to */
 
-	switch(QueueID) {
+	switch (QueueID) {
 	case BE_QUEUE:
 		QueueSelect = QSLT_BE;	/* or QSelect = pTcb->priority; */
 		break;
@@ -1914,7 +1981,7 @@ u8 MapHwQueueToFirmwareQueue(u8 QueueID)
 	case MGNT_QUEUE:
 		QueueSelect = QSLT_MGNT;
 		break;
-		case BEACON_QUEUE:
+	case BEACON_QUEUE:
 		QueueSelect = QSLT_BEACON;
 		break;
 
@@ -1932,7 +1999,7 @@ u8 MapHwQueueToFirmwareQueue(u8 QueueID)
 		break;
 	default:
 		RT_TRACE(COMP_ERR, "TransmitTCB(): Impossible Queue Selection:"
-							" %d \n", QueueID);
+							" %d\n", QueueID);
 		break;
 	}
 	return QueueSelect;
@@ -1942,52 +2009,109 @@ u8 MRateToHwRate8190Pci(u8 rate)
 {
 	u8  ret = DESC90_RATE1M;
 
-	switch(rate) {
-		case MGN_1M:    ret = DESC90_RATE1M;    break;
-		case MGN_2M:    ret = DESC90_RATE2M;    break;
-		case MGN_5_5M:  ret = DESC90_RATE5_5M;  break;
-		case MGN_11M:   ret = DESC90_RATE11M;   break;
-		case MGN_6M:    ret = DESC90_RATE6M;    break;
-		case MGN_9M:    ret = DESC90_RATE9M;    break;
-		case MGN_12M:   ret = DESC90_RATE12M;   break;
-		case MGN_18M:   ret = DESC90_RATE18M;   break;
-		case MGN_24M:   ret = DESC90_RATE24M;   break;
-		case MGN_36M:   ret = DESC90_RATE36M;   break;
-		case MGN_48M:   ret = DESC90_RATE48M;   break;
-		case MGN_54M:   ret = DESC90_RATE54M;   break;
-
-		/* HT rate since here */
-		case MGN_MCS0:  ret = DESC90_RATEMCS0;  break;
-		case MGN_MCS1:  ret = DESC90_RATEMCS1;  break;
-		case MGN_MCS2:  ret = DESC90_RATEMCS2;  break;
-		case MGN_MCS3:  ret = DESC90_RATEMCS3;  break;
-		case MGN_MCS4:  ret = DESC90_RATEMCS4;  break;
-		case MGN_MCS5:  ret = DESC90_RATEMCS5;  break;
-		case MGN_MCS6:  ret = DESC90_RATEMCS6;  break;
-		case MGN_MCS7:  ret = DESC90_RATEMCS7;  break;
-		case MGN_MCS8:  ret = DESC90_RATEMCS8;  break;
-		case MGN_MCS9:  ret = DESC90_RATEMCS9;  break;
-		case MGN_MCS10: ret = DESC90_RATEMCS10; break;
-		case MGN_MCS11: ret = DESC90_RATEMCS11; break;
-		case MGN_MCS12: ret = DESC90_RATEMCS12; break;
-		case MGN_MCS13: ret = DESC90_RATEMCS13; break;
-		case MGN_MCS14: ret = DESC90_RATEMCS14; break;
-		case MGN_MCS15: ret = DESC90_RATEMCS15; break;
-		case (0x80|0x20): ret = DESC90_RATEMCS32; break;
-
-		default:       break;
+	switch (rate) {
+	case MGN_1M:
+		ret = DESC90_RATE1M;
+		break;
+	case MGN_2M:
+		ret = DESC90_RATE2M;
+		break;
+	case MGN_5_5M:
+		ret = DESC90_RATE5_5M;
+		break;
+	case MGN_11M:
+		ret = DESC90_RATE11M;
+		break;
+	case MGN_6M:
+		ret = DESC90_RATE6M;
+		break;
+	case MGN_9M:
+		ret = DESC90_RATE9M;
+		break;
+	case MGN_12M:
+		ret = DESC90_RATE12M;
+		break;
+	case MGN_18M:
+		ret = DESC90_RATE18M;
+		break;
+	case MGN_24M:
+		ret = DESC90_RATE24M;
+		break;
+	case MGN_36M:
+		ret = DESC90_RATE36M;
+		break;
+	case MGN_48M:
+		ret = DESC90_RATE48M;
+		break;
+	case MGN_54M:
+		ret = DESC90_RATE54M;
+		break;
+	/* HT rate since here */
+	case MGN_MCS0:
+		ret = DESC90_RATEMCS0;
+		break;
+	case MGN_MCS1:
+		ret = DESC90_RATEMCS1;
+		break;
+	case MGN_MCS2:
+		ret = DESC90_RATEMCS2;
+		break;
+	case MGN_MCS3:
+		ret = DESC90_RATEMCS3;
+		break;
+	case MGN_MCS4:
+		ret = DESC90_RATEMCS4;
+		break;
+	case MGN_MCS5:
+		ret = DESC90_RATEMCS5;
+		break;
+	case MGN_MCS6:
+		ret = DESC90_RATEMCS6;
+		break;
+	case MGN_MCS7:
+		ret = DESC90_RATEMCS7;
+		break;
+	case MGN_MCS8:
+		ret = DESC90_RATEMCS8;
+		break;
+	case MGN_MCS9:
+		ret = DESC90_RATEMCS9;
+		break;
+	case MGN_MCS10:
+		ret = DESC90_RATEMCS10;
+		break;
+	case MGN_MCS11:
+		ret = DESC90_RATEMCS11;
+		break;
+	case MGN_MCS12:
+		ret = DESC90_RATEMCS12;
+		break;
+	case MGN_MCS13:
+		ret = DESC90_RATEMCS13;
+		break;
+	case MGN_MCS14:
+		ret = DESC90_RATEMCS14;
+		break;
+	case MGN_MCS15:
+		ret = DESC90_RATEMCS15;
+		break;
+	case (0x80|0x20):
+		ret = DESC90_RATEMCS32;
+		break;
+	default:
+		break;
 	}
 	return ret;
 }
 
-
 u8 QueryIsShort(u8 TxHT, u8 TxRate, cb_desc *tcb_desc)
 {
 	u8   tmp_Short;
 
-	tmp_Short = (TxHT==1)?((tcb_desc->bUseShortGI)?1:0):((tcb_desc->bUseShortPreamble)?1:0);
+	tmp_Short = (TxHT == 1) ? ((tcb_desc->bUseShortGI) ? 1 : 0) :
+				((tcb_desc->bUseShortPreamble) ? 1 : 0);
 
-	if(TxHT==1 && TxRate != DESC90_RATEMCS15)
+	if (TxHT == 1 && TxRate != DESC90_RATEMCS15)
 		tmp_Short = 0;
 
 	return tmp_Short;
@@ -2008,7 +2132,8 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff* skb)
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	cb_desc *tcb_desc = (cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
 	tx_desc_819x_usb *tx_desc = (tx_desc_819x_usb *)skb->data;
-	tx_fwinfo_819x_usb *tx_fwinfo = (tx_fwinfo_819x_usb *)(skb->data + USB_HWDESC_HEADER_LEN);
+	tx_fwinfo_819x_usb *tx_fwinfo = (tx_fwinfo_819x_usb *)
+					(skb->data + USB_HWDESC_HEADER_LEN);
 	struct usb_device *udev = priv->udev;
 	int pend;
 	int status;
@@ -2022,26 +2147,27 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff* skb)
 	 * without interleaves
 	 * !!! For debug purpose
 	 */
-	if( pend > MAX_TX_URB){
+	if (pend > MAX_TX_URB) {
 		printk("To discard skb packet!\n");
 		dev_kfree_skb_any(skb);
 		return -1;
 	}
 
-	tx_urb = usb_alloc_urb(0,GFP_ATOMIC);
-	if(!tx_urb){
+	tx_urb = usb_alloc_urb(0, GFP_ATOMIC);
+	if (!tx_urb) {
 		dev_kfree_skb_any(skb);
 		return -ENOMEM;
 	}
 
 	/* Fill Tx firmware info */
-	memset(tx_fwinfo,0,sizeof(tx_fwinfo_819x_usb));
+	memset(tx_fwinfo, 0, sizeof(tx_fwinfo_819x_usb));
 	/* DWORD 0 */
-	tx_fwinfo->TxHT = (tcb_desc->data_rate&0x80)?1:0;
+	tx_fwinfo->TxHT = (tcb_desc->data_rate&0x80) ? 1 : 0;
 	tx_fwinfo->TxRate = MRateToHwRate8190Pci(tcb_desc->data_rate);
 	tx_fwinfo->EnableCPUDur = tcb_desc->bTxEnableFwCalcDur;
-	tx_fwinfo->Short = QueryIsShort(tx_fwinfo->TxHT, tx_fwinfo->TxRate, tcb_desc);
-	if(tcb_desc->bAMPDUEnable) {			/* AMPDU enabled */
+	tx_fwinfo->Short = QueryIsShort(tx_fwinfo->TxHT,
+					tx_fwinfo->TxRate, tcb_desc);
+	if (tcb_desc->bAMPDUEnable) {			/* AMPDU enabled */
 		tx_fwinfo->AllowAggregation = 1;
 		/* DWORD 1 */
 		tx_fwinfo->RxMF = tcb_desc->ampdu_factor;
@@ -2055,22 +2181,24 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff* skb)
 	}
 
 	/* Protection mode related */
-	tx_fwinfo->RtsEnable = (tcb_desc->bRTSEnable)?1:0;
-	tx_fwinfo->CtsEnable = (tcb_desc->bCTSEnable)?1:0;
-	tx_fwinfo->RtsSTBC = (tcb_desc->bRTSSTBC)?1:0;
-	tx_fwinfo->RtsHT = (tcb_desc->rts_rate&0x80)?1:0;
+	tx_fwinfo->RtsEnable = (tcb_desc->bRTSEnable) ? 1 : 0;
+	tx_fwinfo->CtsEnable = (tcb_desc->bCTSEnable) ? 1 : 0;
+	tx_fwinfo->RtsSTBC = (tcb_desc->bRTSSTBC) ? 1 : 0;
+	tx_fwinfo->RtsHT = (tcb_desc->rts_rate&0x80) ? 1 : 0;
 	tx_fwinfo->RtsRate =  MRateToHwRate8190Pci((u8)tcb_desc->rts_rate);
-	tx_fwinfo->RtsSubcarrier = (tx_fwinfo->RtsHT==0)?(tcb_desc->RTSSC):0;
-	tx_fwinfo->RtsBandwidth = (tx_fwinfo->RtsHT==1)?((tcb_desc->bRTSBW)?1:0):0;
-	tx_fwinfo->RtsShort = (tx_fwinfo->RtsHT==0)?(tcb_desc->bRTSUseShortPreamble?1:0):\
-				(tcb_desc->bRTSUseShortGI?1:0);
+	tx_fwinfo->RtsSubcarrier = (tx_fwinfo->RtsHT == 0) ?
+					(tcb_desc->RTSSC) : 0;
+	tx_fwinfo->RtsBandwidth = (tx_fwinfo->RtsHT == 1) ?
+					((tcb_desc->bRTSBW) ? 1 : 0) : 0;
+	tx_fwinfo->RtsShort = (tx_fwinfo->RtsHT == 0) ?
+				(tcb_desc->bRTSUseShortPreamble ? 1 : 0) :
+				(tcb_desc->bRTSUseShortGI ? 1 : 0);
 
 	/* Set Bandwidth and sub-channel settings. */
-	if(priv->CurrentChannelBW == HT_CHANNEL_WIDTH_20_40)
-	{
-		if(tcb_desc->bPacketBW) {
+	if (priv->CurrentChannelBW == HT_CHANNEL_WIDTH_20_40) {
+		if (tcb_desc->bPacketBW) {
 			tx_fwinfo->TxBandwidth = 1;
-			tx_fwinfo->TxSubCarrier = 0;    
+			tx_fwinfo->TxSubCarrier = 0;
 			/* By SD3's Jerry suggestion, use duplicated mode */
 		} else {
 			tx_fwinfo->TxBandwidth = 0;
@@ -2083,9 +2211,7 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff* skb)
 
 #ifdef USB_TX_DRIVER_AGGREGATION_ENABLE
 	if (tcb_desc->drv_agg_enable)
-	{
 		tx_fwinfo->Tx_INFO_RSVD = (tcb_desc->DrvAggrNum & 0x1f) << 1;
-	}
 #endif
 	/* Fill Tx descriptor */
 	memset(tx_desc, 0, sizeof(tx_desc_819x_usb));
@@ -2104,44 +2230,44 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff* skb)
 	}
 
 	/*DWORD 1*/
-	tx_desc->SecCAMID= 0;
+	tx_desc->SecCAMID = 0;
 	tx_desc->RATid = tcb_desc->RATRIndex;
 	{
 		/* MPDUOverhead = 0; */
 		tx_desc->NoEnc = 1;
 	}
 	tx_desc->SecType = 0x0;
-		if (tcb_desc->bHwSec)
-			{
-				switch (priv->ieee80211->pairwise_key_type)
-				{
-					case KEY_TYPE_WEP40:
-					case KEY_TYPE_WEP104:
-						 tx_desc->SecType = 0x1;
-						 tx_desc->NoEnc = 0;
-						 break;
-					case KEY_TYPE_TKIP:
-						 tx_desc->SecType = 0x2;
-						 tx_desc->NoEnc = 0;
-						 break;
-					case KEY_TYPE_CCMP:
-						 tx_desc->SecType = 0x3;
-						 tx_desc->NoEnc = 0;
-						 break;
-					case KEY_TYPE_NA:
-						 tx_desc->SecType = 0x0;
-						 tx_desc->NoEnc = 1;
-						 break;
-				}
+		if (tcb_desc->bHwSec) {
+			switch (priv->ieee80211->pairwise_key_type) {
+			case KEY_TYPE_WEP40:
+			case KEY_TYPE_WEP104:
+				 tx_desc->SecType = 0x1;
+				 tx_desc->NoEnc = 0;
+				 break;
+			case KEY_TYPE_TKIP:
+				 tx_desc->SecType = 0x2;
+				 tx_desc->NoEnc = 0;
+				 break;
+			case KEY_TYPE_CCMP:
+				 tx_desc->SecType = 0x3;
+				 tx_desc->NoEnc = 0;
+				 break;
+			case KEY_TYPE_NA:
+				 tx_desc->SecType = 0x0;
+				 tx_desc->NoEnc = 1;
+				 break;
 			}
+		}
 
-	tx_desc->QueueSelect = MapHwQueueToFirmwareQueue(tcb_desc->queue_index);
+	tx_desc->QueueSelect = MapHwQueueToFirmwareQueue
+						(tcb_desc->queue_index);
 	tx_desc->TxFWInfoSize =  sizeof(tx_fwinfo_819x_usb);
 
 	tx_desc->DISFB = tcb_desc->bTxDisableRateFallBack;
 	tx_desc->USERATE = tcb_desc->bTxUseDriverAssingedRate;
 
-	/* Fill fields that are required to be initialized in all of the descriptors */
+	/* Fill fields that are required to be initialized
+	 * in all of the descriptors */
 	/* DWORD 0 */
 	tx_desc->FirstSeg = 1;
 	tx_desc->LastSeg = 1;
@@ -2149,7 +2275,8 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff* skb)
 
 #ifdef USB_TX_DRIVER_AGGREGATION_ENABLE
 	if (tcb_desc->drv_agg_enable) {
-		tx_desc->TxBufferSize = tcb_desc->pkt_size + sizeof(tx_fwinfo_819x_usb);
+		tx_desc->TxBufferSize = tcb_desc->pkt_size +
+					sizeof(tx_fwinfo_819x_usb);
 	} else
 #endif
 	{
@@ -2158,7 +2285,7 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff* skb)
 	}
 	/* Get index to out pipe from specified QueueID */
 #ifndef USE_ONE_PIPE
-	idx_pipe = txqueue2outpipe(priv,tcb_desc->queue_index);
+	idx_pipe = txqueue2outpipe(priv, tcb_desc->queue_index);
 #else
 	idx_pipe = 0x5;
 #endif
@@ -2167,50 +2294,52 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff* skb)
 	/* RT_DEBUG_DATA(COMP_SEND, tx_desc, sizeof(tx_desc_819x_usb)); */
 
 	/* To submit bulk urb */
-	usb_fill_bulk_urb(tx_urb,udev,
-			usb_sndbulkpipe(udev,idx_pipe), skb->data,
+	usb_fill_bulk_urb(tx_urb, udev,
+			usb_sndbulkpipe(udev, idx_pipe), skb->data,
 			skb->len, rtl8192_tx_isr, skb);
 
 	status = usb_submit_urb(tx_urb, GFP_ATOMIC);
-	if (!status){
-/* we need to send 0 byte packet whenever 512N bytes/64N
- * (HIGN SPEED/NORMAL SPEED) bytes packet has been transmitted.
- * Otherwise, it will be halt to wait for another packet. WB. 2008.08.27
- */
+	if (!status) {
+		/* we need to send 0 byte packet whenever 512N bytes/64N
+		 * (HIGN SPEED/NORMAL SPEED) bytes packet has been transmitted.
+		 * Otherwise, it will be halt to wait for another packet.
+		 * WB. 2008.08.27
+		 */
 		bool bSend0Byte = false;
 		u8 zero = 0;
-		if(udev->speed == USB_SPEED_HIGH)
-		{
+		if (udev->speed == USB_SPEED_HIGH) {
 			if (skb->len > 0 && skb->len % 512 == 0)
 				bSend0Byte = true;
-		}
-		else
-		{
+		} else {
 			if (skb->len > 0 && skb->len % 64 == 0)
 				bSend0Byte = true;
 		}
-		if (bSend0Byte)
-		{
-			tx_urb_zero = usb_alloc_urb(0,GFP_ATOMIC);
-			if(!tx_urb_zero){
-				RT_TRACE(COMP_ERR, "can't alloc urb for zero byte\n");
+		if (bSend0Byte) {
+			tx_urb_zero = usb_alloc_urb(0, GFP_ATOMIC);
+			if (!tx_urb_zero) {
+				RT_TRACE(COMP_ERR,
+					"can't alloc urb for zero byte\n");
 				return -ENOMEM;
 			}
-			usb_fill_bulk_urb(tx_urb_zero,udev,
-					usb_sndbulkpipe(udev,idx_pipe), &zero,
+			usb_fill_bulk_urb(tx_urb_zero, udev,
+					usb_sndbulkpipe(udev, idx_pipe), &zero,
 					0, tx_zero_isr, dev);
 			status = usb_submit_urb(tx_urb_zero, GFP_ATOMIC);
-			if (status){
-			RT_TRACE(COMP_ERR, "Error TX URB for zero byte %d, error %d", atomic_read(&priv->tx_pending[tcb_desc->queue_index]), status);
-			return -1;
+			if (status) {
+				RT_TRACE(COMP_ERR, "Error TX URB for zero byte"
+					" %d, error %d", atomic_read
+					(&priv->tx_pending[tcb_desc->
+					queue_index]), status);
+				return -1;
 			}
 		}
 		dev->trans_start = jiffies;
 		atomic_inc(&priv->tx_pending[tcb_desc->queue_index]);
 		return 0;
-	}else{
-		RT_TRACE(COMP_ERR, "Error TX URB %d, error %d", atomic_read(&priv->tx_pending[tcb_desc->queue_index]),
-				status);
+	} else {
+		RT_TRACE(COMP_ERR, "Error TX URB %d, error %d",
+			atomic_read(&priv->tx_pending[tcb_desc->queue_index]),
+			status);
 		return -1;
 	}
 }
@@ -2219,16 +2348,14 @@ short rtl8192_usb_initendpoints(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 
-	priv->rx_urb = kmalloc(sizeof(struct urb *) * (MAX_RX_URB+1),
+	priv->rx_urb = kmalloc(sizeof(struct urb *) * (MAX_RX_URB + 1),
 				GFP_KERNEL);
 
 #ifndef JACKSON_NEW_RX
-	for(i=0;i<(MAX_RX_URB+1);i++){
-
-		priv->rx_urb[i] = usb_alloc_urb(0,GFP_KERNEL);
-
-		priv->rx_urb[i]->transfer_buffer = kmalloc(RX_URB_SIZE, GFP_KERNEL);
-
+	for (i = 0; i < (MAX_RX_URB + 1); i++) {
+		priv->rx_urb[i] = usb_alloc_urb(0, GFP_KERNEL);
+		priv->rx_urb[i]->transfer_buffer =
+					kmalloc(RX_URB_SIZE, GFP_KERNEL);
 		priv->rx_urb[i]->transfer_buffer_length = RX_URB_SIZE;
 	}
 #endif
@@ -2253,7 +2380,7 @@ short rtl8192_usb_initendpoints(struct net_device *dev)
 }
 #endif
 
-	memset(priv->rx_urb, 0, sizeof(struct urb*) * MAX_RX_URB);
+	memset(priv->rx_urb, 0, sizeof(struct urb *) * MAX_RX_URB);
 	priv->pp_rxskb = kcalloc(MAX_RX_URB, sizeof(struct sk_buff *),
 				 GFP_KERNEL);
 	if (priv->pp_rxskb == NULL)
@@ -2263,12 +2390,11 @@ short rtl8192_usb_initendpoints(struct net_device *dev)
 
 
 destroy:
-	if (priv->pp_rxskb) {
+	if (priv->pp_rxskb)
 		kfree(priv->pp_rxskb);
-	}
-	if (priv->rx_urb) {
+
+	if (priv->rx_urb)
 		kfree(priv->rx_urb);
-	}
 
 	priv->pp_rxskb = NULL;
 	priv->rx_urb = NULL;
@@ -2289,15 +2415,15 @@ void rtl8192_usb_deleteendpoints(struct net_device *dev)
 	int i;
 	struct r8192_priv *priv = ieee80211_priv(dev);
 
-	if(priv->rx_urb){
-		for(i=0;i<(MAX_RX_URB+1);i++){
+	if (priv->rx_urb) {
+		for (i = 0; i < (MAX_RX_URB + 1); i++) {
 			usb_kill_urb(priv->rx_urb[i]);
 			usb_free_urb(priv->rx_urb[i]);
 		}
 		kfree(priv->rx_urb);
 		priv->rx_urb = NULL;
 	}
-	if(priv->oldaddr){
+	if (priv->oldaddr) {
 		kfree(priv->oldaddr);
 		priv->oldaddr = NULL;
 	}
@@ -2314,8 +2440,8 @@ void rtl8192_usb_deleteendpoints(struct net_device *dev)
 
 #ifndef JACKSON_NEW_RX
 
-	if(priv->rx_urb){
-		for(i=0;i<(MAX_RX_URB+1);i++){
+	if (priv->rx_urb) {
+		for (i = 0; i < (MAX_RX_URB+1); i++) {
 			usb_kill_urb(priv->rx_urb[i]);
 			kfree(priv->rx_urb[i]->transfer_buffer);
 			usb_free_urb(priv->rx_urb[i]);
@@ -2325,11 +2451,11 @@ void rtl8192_usb_deleteendpoints(struct net_device *dev)
 
 	}
 #else
-	if(priv->rx_urb){
+	if (priv->rx_urb) {
 		kfree(priv->rx_urb);
 		priv->rx_urb = NULL;
 	}
-	if(priv->oldaddr){
+	if (priv->oldaddr) {
 		kfree(priv->oldaddr);
 		priv->oldaddr = NULL;
 	}
@@ -2343,38 +2469,38 @@ void rtl8192_usb_deleteendpoints(struct net_device *dev)
 }
 #endif
 
-extern void rtl8192_update_ratr_table(struct net_device* dev);
+extern void rtl8192_update_ratr_table(struct net_device *dev);
 void rtl8192_link_change(struct net_device *dev)
 {
 	/* int i; */
 
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	struct ieee80211_device* ieee = priv->ieee80211;
+	struct ieee80211_device *ieee = priv->ieee80211;
 	/* write_nic_word(dev, BCN_INTR_ITV, net->beacon_interval); */
-	if (ieee->state == IEEE80211_LINKED)
-	{
+	if (ieee->state == IEEE80211_LINKED) {
 		rtl8192_net_update(dev);
 		rtl8192_update_ratr_table(dev);
 		/* add this as in pure N mode, wep encryption will use software
 		 * way, but there is no chance to set this as wep will not set
 		 * group key in wext. WB.2008.07.08
 		 */
-		if ((KEY_TYPE_WEP40 == ieee->pairwise_key_type) || (KEY_TYPE_WEP104 == ieee->pairwise_key_type))
-		EnableHWSecurityConfig8192(dev);
+		if ((KEY_TYPE_WEP40 == ieee->pairwise_key_type) ||
+				(KEY_TYPE_WEP104 == ieee->pairwise_key_type))
+			EnableHWSecurityConfig8192(dev);
 	}
 	/*update timing params*/
-	/* RT_TRACE(COMP_CH, "========>%s(), chan:%d\n", __func__, priv->chan); */
+	/* RT_TRACE(COMP_CH, "========>%s(), chan:%d\n",
+	 * __func__, priv->chan); */
 	/* rtl8192_set_chan(dev, priv->chan); */
-	 if (ieee->iw_mode == IW_MODE_INFRA || ieee->iw_mode == IW_MODE_ADHOC)
-        {
-                u32 reg = 0;
-                reg = read_nic_dword(dev, RCR);
-                if (priv->ieee80211->state == IEEE80211_LINKED)
-                        priv->ReceiveConfig = reg |= RCR_CBSSID;
-                else
-                        priv->ReceiveConfig = reg &= ~RCR_CBSSID;
-                write_nic_dword(dev, RCR, reg);
-        }
+	if (ieee->iw_mode == IW_MODE_INFRA || ieee->iw_mode == IW_MODE_ADHOC) {
+		u32 reg = 0;
+		reg = read_nic_dword(dev, RCR);
+		if (priv->ieee80211->state == IEEE80211_LINKED)
+				priv->ReceiveConfig = reg |= RCR_CBSSID;
+		else
+			priv->ReceiveConfig = reg &= ~RCR_CBSSID;
+		write_nic_dword(dev, RCR, reg);
+	}
 
 	/* rtl8192_set_rxconf(dev); */
 }
@@ -2576,58 +2702,60 @@ void rtl8192_update_ratr_table(struct net_device* dev)
 	rtl8192_config_rate(dev, (u16*)(&ratr_value));
 	ratr_value |= (*(u16*)(pMcsRate)) << 12;
 	/* switch (net->mode) */
-	switch (ieee->mode)
-	{
-		case IEEE_A:
-			ratr_value &= 0x00000FF0;
-			break;
-		case IEEE_B:
-			ratr_value &= 0x0000000F;
-			break;
-		case IEEE_G:
-			ratr_value &= 0x00000FF7;
-			break;
-		case IEEE_N_24G:
-		case IEEE_N_5G:
-			if (ieee->pHTInfo->PeerMimoPs == 0)
-				/* MIMO_PS_STATIC */
-				ratr_value &= 0x0007F007;
-			else{
-				if (priv->rf_type == RF_1T2R)
-					ratr_value &= 0x000FF007;
-				else
-					ratr_value &= 0x0F81F007;
-			}
-			break;
-		default:
-			break;
+	switch (ieee->mode) {
+	case IEEE_A:
+		ratr_value &= 0x00000FF0;
+		break;
+	case IEEE_B:
+		ratr_value &= 0x0000000F;
+		break;
+	case IEEE_G:
+		ratr_value &= 0x00000FF7;
+		break;
+	case IEEE_N_24G:
+	case IEEE_N_5G:
+		if (ieee->pHTInfo->PeerMimoPs == 0)
+			/* MIMO_PS_STATIC */
+			ratr_value &= 0x0007F007;
+		else{
+			if (priv->rf_type == RF_1T2R)
+				ratr_value &= 0x000FF007;
+			else
+				ratr_value &= 0x0F81F007;
+		}
+		break;
+	default:
+		break;
 	}
 	ratr_value &= 0x0FFFFFFF;
-	if(ieee->pHTInfo->bCurTxBW40MHz && ieee->pHTInfo->bCurShortGI40MHz){
+	if (ieee->pHTInfo->bCurTxBW40MHz && ieee->pHTInfo->bCurShortGI40MHz) {
 		ratr_value |= 0x80000000;
-	}else if(!ieee->pHTInfo->bCurTxBW40MHz && ieee->pHTInfo->bCurShortGI20MHz){
+	}else if (!ieee->pHTInfo->bCurTxBW40MHz &&
+					ieee->pHTInfo->bCurShortGI20MHz){
 		ratr_value |= 0x80000000;
 	}
-	write_nic_dword(dev, RATR0+rate_index*4, ratr_value);
+	write_nic_dword(dev, RATR0 + rate_index * 4, ratr_value);
 	write_nic_byte(dev, UFWP, 1);
 }
 
-static u8 ccmp_ie[4] = {0x00,0x50,0xf2,0x04};
+static u8 ccmp_ie[4] = {0x00, 0x50, 0xf2, 0x04};
 static u8 ccmp_rsn_ie[4] = {0x00, 0x0f, 0xac, 0x04};
-bool GetNmodeSupportBySecCfg8192(struct net_device*dev)
+bool GetNmodeSupportBySecCfg8192(struct net_device *dev)
 {
-	struct r8192_priv* priv = ieee80211_priv(dev);
-	struct ieee80211_device* ieee = priv->ieee80211;
-	struct ieee80211_network * network = &ieee->current_network;
-	int wpa_ie_len= ieee->wpa_ie_len;
-	struct ieee80211_crypt_data* crypt;
+	struct r8192_priv *priv = ieee80211_priv(dev);
+	struct ieee80211_device *ieee = priv->ieee80211;
+	struct ieee80211_network *network = &ieee->current_network;
+	int wpa_ie_len = ieee->wpa_ie_len;
+	struct ieee80211_crypt_data *crypt;
 	int encrypt;
 
 	crypt = ieee->crypt[ieee->tx_keyidx];
 	/* we use connecting AP's capability instead of only security config
 	 * on our driver to distinguish whether it should use N mode or G mode
 	 */
-	encrypt = (network->capability & WLAN_CAPABILITY_PRIVACY) || (ieee->host_encrypt && crypt && crypt->ops && (0 == strcmp(crypt->ops->name,"WEP")));
+	encrypt = (network->capability & WLAN_CAPABILITY_PRIVACY) ||
+				(ieee->host_encrypt && crypt && crypt->ops &&
+				(0 == strcmp(crypt->ops->name, "WEP")));
 
 	/* simply judge  */
 	if(encrypt && (wpa_ie_len == 0)) {
@@ -2689,51 +2817,42 @@ u8 rtl8192_getSupportedWireleeMode(struct net_device*dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	u8 ret = 0;
-	switch(priv->rf_chip)
-	{
-		case RF_8225:
-		case RF_8256:
-		case RF_PSEUDO_11N:
-			ret = (WIRELESS_MODE_N_24G|WIRELESS_MODE_G|WIRELESS_MODE_B);
-			break;
-		case RF_8258:
-			ret = (WIRELESS_MODE_A|WIRELESS_MODE_N_5G);
-			break;
-		default:
-			ret = WIRELESS_MODE_B;
-			break;
+	switch (priv->rf_chip) {
+	case RF_8225:
+	case RF_8256:
+	case RF_PSEUDO_11N:
+		ret = (WIRELESS_MODE_N_24G|WIRELESS_MODE_G|WIRELESS_MODE_B);
+		break;
+	case RF_8258:
+		ret = (WIRELESS_MODE_A|WIRELESS_MODE_N_5G);
+		break;
+	default:
+		ret = WIRELESS_MODE_B;
+		break;
 	}
 	return ret;
 }
-void rtl8192_SetWirelessMode(struct net_device* dev, u8 wireless_mode)
+void rtl8192_SetWirelessMode(struct net_device *dev, u8 wireless_mode)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	u8 bSupportMode = rtl8192_getSupportedWireleeMode(dev);
 
-	if ((wireless_mode == WIRELESS_MODE_AUTO) || ((wireless_mode&bSupportMode)==0))
-	{
-		if(bSupportMode & WIRELESS_MODE_N_24G)
-		{
+	if ((wireless_mode == WIRELESS_MODE_AUTO) ||
+					((wireless_mode&bSupportMode) == 0)) {
+		if (bSupportMode & WIRELESS_MODE_N_24G) {
 			wireless_mode = WIRELESS_MODE_N_24G;
-		}
-		else if(bSupportMode & WIRELESS_MODE_N_5G)
-		{
+		} else if (bSupportMode & WIRELESS_MODE_N_5G) {
 			wireless_mode = WIRELESS_MODE_N_5G;
-		}
-		else if((bSupportMode & WIRELESS_MODE_A))
-		{
+		} else if ((bSupportMode & WIRELESS_MODE_A)) {
 			wireless_mode = WIRELESS_MODE_A;
-		}
-		else if((bSupportMode & WIRELESS_MODE_G))
-		{
+		} else if ((bSupportMode & WIRELESS_MODE_G)) {
 			wireless_mode = WIRELESS_MODE_G;
-		}
-		else if((bSupportMode & WIRELESS_MODE_B))
-		{
+		} else if ((bSupportMode & WIRELESS_MODE_B)) {
 			wireless_mode = WIRELESS_MODE_B;
-		}
-		else{
-			RT_TRACE(COMP_ERR, "%s(), No valid wireless mode supported, SupportedWirelessMode(%x)!!!\n", __func__,bSupportMode);
+		} else {
+			RT_TRACE(COMP_ERR, "%s(), No valid wireless mode"
+					" supported, SupportedWirelessMode(%x)"
+					"!!!\n", __func__, bSupportMode);
 			wireless_mode = WIRELESS_MODE_B;
 		}
 	}
@@ -3157,7 +3276,8 @@ static void rtl8192_read_eeprom_info(struct net_device* dev)
 		/* Antenna B gain offset to antenna A, bit0~3 */
 		priv->AntennaTxPwDiff[0] = (priv->EEPROMTxPowerDiff & 0xf);
 		/* Antenna C gain offset to antenna A, bit4~7 */
-		priv->AntennaTxPwDiff[1] = ((priv->EEPROMTxPowerDiff & 0xf0)>>4);
+		priv->AntennaTxPwDiff[1] =
+					((priv->EEPROMTxPowerDiff & 0xf0)>>4);
 		/* CrystalCap, bit12~15 */
 		priv->CrystalCap = priv->EEPROMCrystalCap;
 		/* ThermalMeter, bit0~3 for RFIC1, bit4~7 for RFIC2 */
@@ -3166,45 +3286,33 @@ static void rtl8192_read_eeprom_info(struct net_device* dev)
 	}	/* end if VersionID == VERSION_819xU_A */
 
 	/* added by vivi, for dlink led, 20080416 */
-	switch(priv->eeprom_CustomerID)
-	{
-		case EEPROM_CID_RUNTOP:
-			priv->CustomerID = RT_CID_819x_RUNTOP;
-			break;
-
-		case EEPROM_CID_DLINK:
-			priv->CustomerID = RT_CID_DLINK;
-			break;
-
-		default:
-			priv->CustomerID = RT_CID_DEFAULT;
-			break;
-
+	switch(priv->eeprom_CustomerID)	{
+	case EEPROM_CID_RUNTOP:
+		priv->CustomerID = RT_CID_819x_RUNTOP;
+		break;
+	case EEPROM_CID_DLINK:
+		priv->CustomerID = RT_CID_DLINK;
+		break;
+	default:
+		priv->CustomerID = RT_CID_DEFAULT;
+		break;
 	}
 
-	switch(priv->CustomerID)
-	{
-		case RT_CID_819x_RUNTOP:
-			priv->LedStrategy = SW_LED_MODE2;
-			break;
-
-		case RT_CID_DLINK:
-			priv->LedStrategy = SW_LED_MODE4;
-			break;
-
-		default:
-			priv->LedStrategy = SW_LED_MODE0;
-			break;
-
+	switch(priv->CustomerID) {
+	case RT_CID_819x_RUNTOP:
+		priv->LedStrategy = SW_LED_MODE2;
+		break;
+	case RT_CID_DLINK:
+		priv->LedStrategy = SW_LED_MODE4;
+		break;
+	default:
+		priv->LedStrategy = SW_LED_MODE0;
+		break;
 	}
 
-
-	if(priv->rf_type == RF_1T2R)
-	{
+	if (priv->rf_type == RF_1T2R) {
 		RT_TRACE(COMP_EPROM, "\n1T2R config\n");
-	}
-	else
-	{
+	} else {
 		RT_TRACE(COMP_EPROM, "\n2T4R config\n");
 	}
 
@@ -3303,7 +3411,8 @@ short rtl8192_init(struct net_device *dev)
  *  output:  none
  *  return:  none
  *  notice:  This part need to modified according to the rate set we filtered
- * ****************************************************************************/
+ * ****************************************************************************
+ */
 void rtl8192_hwconfig(struct net_device* dev)
 {
 	u32 regRATR = 0, regRRSR = 0;
@@ -3311,8 +3420,7 @@ void rtl8192_hwconfig(struct net_device* dev)
 	struct r8192_priv *priv = ieee80211_priv(dev);
 
 /* Set RRSR, RATR, and BW_OPMODE registers */
-	switch(priv->ieee80211->mode)
-	{
+	switch (priv->ieee80211->mode) {
 	case WIRELESS_MODE_B:
 		regBwOpMode = BW_OPMODE_20MHZ;
 		regRATR = RATE_ALL_CCK;
@@ -3330,30 +3438,33 @@ void rtl8192_hwconfig(struct net_device* dev)
 		break;
 	case WIRELESS_MODE_AUTO:
 #ifdef TO_DO_LIST
-		if (Adapter->bInHctTest)
-		{
-		    regBwOpMode = BW_OPMODE_20MHZ;
-		    regRATR = RATE_ALL_CCK | RATE_ALL_OFDM_AG;
-		    regRRSR = RATE_ALL_CCK | RATE_ALL_OFDM_AG;
-		}
-		else
+		if (Adapter->bInHctTest) {
+			regBwOpMode = BW_OPMODE_20MHZ;
+			regRATR = RATE_ALL_CCK | RATE_ALL_OFDM_AG;
+			regRRSR = RATE_ALL_CCK | RATE_ALL_OFDM_AG;
+		} else
 #endif
 		{
-		    regBwOpMode = BW_OPMODE_20MHZ;
-		    regRATR = RATE_ALL_CCK | RATE_ALL_OFDM_AG | RATE_ALL_OFDM_1SS | RATE_ALL_OFDM_2SS;
-		    regRRSR = RATE_ALL_CCK | RATE_ALL_OFDM_AG;
+			regBwOpMode = BW_OPMODE_20MHZ;
+			regRATR = RATE_ALL_CCK | RATE_ALL_OFDM_AG |
+					RATE_ALL_OFDM_1SS | RATE_ALL_OFDM_2SS;
+			regRRSR = RATE_ALL_CCK | RATE_ALL_OFDM_AG;
 		}
 		break;
 	case WIRELESS_MODE_N_24G:
 		/* It support CCK rate by default. */
-		/* CCK rate will be filtered out only when associated AP does not support it. */
+		/* CCK rate will be filtered out only when associated AP does
+		 * not support it.
+		 */
 		regBwOpMode = BW_OPMODE_20MHZ;
-			regRATR = RATE_ALL_CCK | RATE_ALL_OFDM_AG | RATE_ALL_OFDM_1SS | RATE_ALL_OFDM_2SS;
-			regRRSR = RATE_ALL_CCK | RATE_ALL_OFDM_AG;
+		regRATR = RATE_ALL_CCK | RATE_ALL_OFDM_AG | RATE_ALL_OFDM_1SS |
+							RATE_ALL_OFDM_2SS;
+		regRRSR = RATE_ALL_CCK | RATE_ALL_OFDM_AG;
 		break;
 	case WIRELESS_MODE_N_5G:
 		regBwOpMode = BW_OPMODE_5G;
-		regRATR = RATE_ALL_OFDM_AG | RATE_ALL_OFDM_1SS | RATE_ALL_OFDM_2SS;
+		regRATR = RATE_ALL_OFDM_AG | RATE_ALL_OFDM_1SS |
+							RATE_ALL_OFDM_2SS;
 		regRRSR = RATE_ALL_OFDM_AG;
 		break;
 	}
@@ -3375,7 +3486,7 @@ void rtl8192_hwconfig(struct net_device* dev)
 
 	/* Set Retry Limit here */
 	write_nic_word(dev, RETRY_LIMIT,
-			priv->ShortRetryLimit << RETRY_LIMIT_SHORT_SHIFT | \
+			priv->ShortRetryLimit << RETRY_LIMIT_SHORT_SHIFT |
 			priv->LongRetryLimit << RETRY_LIMIT_LONG_SHIFT);
 	/* Set Contention Window here */
 	/* Set Tx AGC */
@@ -4488,48 +4599,50 @@ int rtl8192_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 
 	down(&priv->wx_sem);
 
-
-     if (p->length < sizeof(struct ieee_param) || !p->pointer){
-	     ret = -EINVAL;
-	     goto out;
+	if (p->length < sizeof(struct ieee_param) || !p->pointer) {
+		ret = -EINVAL;
+		goto out;
 	}
 
-     ipw = kmalloc(p->length, GFP_KERNEL);
-     if (ipw == NULL){
-	     ret = -ENOMEM;
-	     goto out;
-     }
-     if (copy_from_user(ipw, p->pointer, p->length)) {
+	ipw = kmalloc(p->length, GFP_KERNEL);
+	if (ipw == NULL){
+		ret = -ENOMEM;
+		goto out;
+	}
+	if (copy_from_user(ipw, p->pointer, p->length)) {
 		kfree(ipw);
-	    ret = -EFAULT;
-	    goto out;
+		ret = -EFAULT;
+		goto out;
 	}
 
 	switch (cmd) {
-	    case RTL_IOCTL_WPA_SUPPLICANT:
+	case RTL_IOCTL_WPA_SUPPLICANT:
 	/* parse here for HW security */
-			if (ipw->cmd == IEEE_CMD_SET_ENCRYPTION)
+		if (ipw->cmd == IEEE_CMD_SET_ENCRYPTION) {
+			if (ipw->u.crypt.set_tx)
 			{
-				if (ipw->u.crypt.set_tx)
-				{
-					if (strcmp(ipw->u.crypt.alg, "CCMP") == 0)
-						ieee->pairwise_key_type = KEY_TYPE_CCMP;
-					else if (strcmp(ipw->u.crypt.alg, "TKIP") == 0)
-						ieee->pairwise_key_type = KEY_TYPE_TKIP;
-					else if (strcmp(ipw->u.crypt.alg, "WEP") == 0)
+				if (strcmp(ipw->u.crypt.alg, "CCMP") == 0)
+						ieee->pairwise_key_type =
+								KEY_TYPE_CCMP;
+				else if (strcmp(ipw->u.crypt.alg, "TKIP") == 0)
+					ieee->pairwise_key_type =
+								KEY_TYPE_TKIP;
+				else if (strcmp(ipw->u.crypt.alg, "WEP") == 0)
 					{
-						if (ipw->u.crypt.key_len == 13)
-							ieee->pairwise_key_type = KEY_TYPE_WEP104;
-						else if (ipw->u.crypt.key_len == 5)
-							ieee->pairwise_key_type = KEY_TYPE_WEP40;
-					}
-					else
-						ieee->pairwise_key_type = KEY_TYPE_NA;
-
-					if (ieee->pairwise_key_type)
-					{
-						memcpy((u8*)key, ipw->u.crypt.key, 16);
-						EnableHWSecurityConfig8192(dev);
+					if (ipw->u.crypt.key_len == 13)
+						ieee->pairwise_key_type =
+							KEY_TYPE_WEP104;
+					else if (ipw->u.crypt.key_len == 5)
+						ieee->pairwise_key_type =
+								KEY_TYPE_WEP40;
+				}
+				else
+				ieee->pairwise_key_type = KEY_TYPE_NA;
+					if (ieee->pairwise_key_type) {
+						memcpy((u8*)key, ipw->
+							u.crypt.key, 16);
+						EnableHWSecurityConfig8192
+									(dev);
 					/* we fill both index entry and 4th
 					 * entry for pairwise key as in IPW
 					 * interface, adhoc will only get here,
@@ -4537,56 +4650,68 @@ int rtl8192_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 					 * default key serching!
 					 */
 					/* added by WB. */
-						setKey(dev, 4, ipw->u.crypt.idx, ieee->pairwise_key_type, (u8*)ieee->ap_mac_addr, 0, key);
+						setKey(dev, 4,
+							ipw->u.crypt.idx,
+							ieee->pairwise_key_type
+							, (u8*)ieee->
+							ap_mac_addr, 0, key);
 						if (ieee->auth_mode != 2)
-						setKey(dev, ipw->u.crypt.idx, ipw->u.crypt.idx, ieee->pairwise_key_type, (u8*)ieee->ap_mac_addr, 0, key);
+							setKey(dev, ipw->
+							u.crypt.idx, ipw->
+							u.crypt.idx, ieee->
+							pairwise_key_type,
+							(u8 *)ieee->ap_mac_addr
+								, 0, key);
 					}
-				}
-				else {
+				} else {
 					/* if (ipw->u.crypt.idx) */
 					/* group key use idx > 0 */
 					memcpy((u8*)key, ipw->u.crypt.key, 16);
-					if (strcmp(ipw->u.crypt.alg, "CCMP") == 0)
-						ieee->group_key_type= KEY_TYPE_CCMP;
-					else if (strcmp(ipw->u.crypt.alg, "TKIP") == 0)
-						ieee->group_key_type = KEY_TYPE_TKIP;
-					else if (strcmp(ipw->u.crypt.alg, "WEP") == 0)
-					{
+					if (strcmp(ipw->u.crypt.alg, "CCMP")
+									== 0)
+						ieee->group_key_type=
+								KEY_TYPE_CCMP;
+					else if (strcmp(ipw->u.crypt.alg,
+								"TKIP") == 0)
+						ieee->group_key_type =
+								KEY_TYPE_TKIP;
+					else if (strcmp(ipw->u.crypt.alg,
+								"WEP") == 0) {
 						if (ipw->u.crypt.key_len == 13)
-							ieee->group_key_type = KEY_TYPE_WEP104;
-						else if (ipw->u.crypt.key_len == 5)
-							ieee->group_key_type = KEY_TYPE_WEP40;
-					}
-					else
-						ieee->group_key_type = KEY_TYPE_NA;
-
-					if (ieee->group_key_type)
-					{
-							setKey(	dev,
-								ipw->u.crypt.idx,
-								ipw->u.crypt.idx,
-								/* KeyIndex */
-						     		ieee->group_key_type,
-								/* KeyType */
-						            	broadcast_addr,
-								/* MacAddr */
-								0,
-								/* DefaultKey */
-							      	key);
-								/* KeyContent */
+							ieee->group_key_type =
+							KEY_TYPE_WEP104;
+						else if (ipw->u.crypt.key_len
+									== 5)
+							ieee->group_key_type =
+								KEY_TYPE_WEP40;
+					} else
+						ieee->group_key_type =
+								KEY_TYPE_NA;
+					if (ieee->group_key_type) {
+						setKey(dev, ipw->u.crypt.idx,
+							ipw->u.crypt.idx,
+							/* KeyIndex */
+							ieee->group_key_type,
+							/* KeyType */
+							broadcast_addr,
+							/* MacAddr */ 0,
+							/* DefaultKey */
+							key); /* KeyContent */
 					}
 				}
 			}
 #ifdef JOHN_HWSEC_DEBUG
 		/* john's test 0711 */
 		printk("@@ wrq->u pointer = ");
-		for(i=0;i<wrq->u.data.length;i++){
-			if(i%10==0) printk("\n");
-			printk( "%8x|", ((u32*)wrq->u.data.pointer)[i] );
+		for (i = 0; i < wrq->u.data.length; i++) {
+			if (i % 10 == 0)
+				printk("\n");
+			printk("%8x|", ((u32 *)wrq->u.data.pointer)[i]);
 		}
 		printk("\n");
 #endif /* JOHN_HWSEC_DEBUG */
-		ret = ieee80211_wpa_supplicant_ioctl(priv->ieee80211, &wrq->u.data);
+		ret = ieee80211_wpa_supplicant_ioctl(priv->ieee80211,
+								&wrq->u.data);
 		break;
 
 	    default:
@@ -4604,51 +4729,50 @@ u8 HwRateToMRate90(bool bIsHT, u8 rate)
 {
 	u8  ret_rate = 0xff;
 
-	if(!bIsHT) {
+	if (!bIsHT) {
 		switch(rate) {
-			case DESC90_RATE1M:   ret_rate = MGN_1M;         break;
-			case DESC90_RATE2M:   ret_rate = MGN_2M;         break;
-			case DESC90_RATE5_5M: ret_rate = MGN_5_5M;       break;
-			case DESC90_RATE11M:  ret_rate = MGN_11M;        break;
-			case DESC90_RATE6M:   ret_rate = MGN_6M;         break;
-			case DESC90_RATE9M:   ret_rate = MGN_9M;         break;
-			case DESC90_RATE12M:  ret_rate = MGN_12M;        break;
-			case DESC90_RATE18M:  ret_rate = MGN_18M;        break;
-			case DESC90_RATE24M:  ret_rate = MGN_24M;        break;
-			case DESC90_RATE36M:  ret_rate = MGN_36M;        break;
-			case DESC90_RATE48M:  ret_rate = MGN_48M;        break;
-			case DESC90_RATE54M:  ret_rate = MGN_54M;        break;
-
-			default:
-				ret_rate = 0xff;
-				RT_TRACE(COMP_RECV, "HwRateToMRate90(): Non supported Rate [%x], bIsHT = %d!!!\n", rate, bIsHT);
-				break;
+		case DESC90_RATE1M:   ret_rate = MGN_1M;         break;
+		case DESC90_RATE2M:   ret_rate = MGN_2M;         break;
+		case DESC90_RATE5_5M: ret_rate = MGN_5_5M;       break;
+		case DESC90_RATE11M:  ret_rate = MGN_11M;        break;
+		case DESC90_RATE6M:   ret_rate = MGN_6M;         break;
+		case DESC90_RATE9M:   ret_rate = MGN_9M;         break;
+		case DESC90_RATE12M:  ret_rate = MGN_12M;        break;
+		case DESC90_RATE18M:  ret_rate = MGN_18M;        break;
+		case DESC90_RATE24M:  ret_rate = MGN_24M;        break;
+		case DESC90_RATE36M:  ret_rate = MGN_36M;        break;
+		case DESC90_RATE48M:  ret_rate = MGN_48M;        break;
+		case DESC90_RATE54M:  ret_rate = MGN_54M;        break;
+		default:
+			ret_rate = 0xff;
+			RT_TRACE(COMP_RECV, "HwRateToMRate90(): Non supported"
+				" Rate [%x], bIsHT = %d!!!\n", rate, bIsHT);
+			break;
 		}
-
 	} else {
 		switch(rate) {
-			case DESC90_RATEMCS0:   ret_rate = MGN_MCS0;    break;
-			case DESC90_RATEMCS1:   ret_rate = MGN_MCS1;    break;
-			case DESC90_RATEMCS2:   ret_rate = MGN_MCS2;    break;
-			case DESC90_RATEMCS3:   ret_rate = MGN_MCS3;    break;
-			case DESC90_RATEMCS4:   ret_rate = MGN_MCS4;    break;
-			case DESC90_RATEMCS5:   ret_rate = MGN_MCS5;    break;
-			case DESC90_RATEMCS6:   ret_rate = MGN_MCS6;    break;
-			case DESC90_RATEMCS7:   ret_rate = MGN_MCS7;    break;
-			case DESC90_RATEMCS8:   ret_rate = MGN_MCS8;    break;
-			case DESC90_RATEMCS9:   ret_rate = MGN_MCS9;    break;
-			case DESC90_RATEMCS10:  ret_rate = MGN_MCS10;   break;
-			case DESC90_RATEMCS11:  ret_rate = MGN_MCS11;   break;
-			case DESC90_RATEMCS12:  ret_rate = MGN_MCS12;   break;
-			case DESC90_RATEMCS13:  ret_rate = MGN_MCS13;   break;
-			case DESC90_RATEMCS14:  ret_rate = MGN_MCS14;   break;
-			case DESC90_RATEMCS15:  ret_rate = MGN_MCS15;   break;
-			case DESC90_RATEMCS32:  ret_rate = (0x80|0x20); break;
-
-			default:
-				ret_rate = 0xff;
-				RT_TRACE(COMP_RECV, "HwRateToMRate90(): Non supported Rate [%x], bIsHT = %d!!!\n",rate, bIsHT);
-				break;
+		case DESC90_RATEMCS0:   ret_rate = MGN_MCS0;    break;
+		case DESC90_RATEMCS1:   ret_rate = MGN_MCS1;    break;
+		case DESC90_RATEMCS2:   ret_rate = MGN_MCS2;    break;
+		case DESC90_RATEMCS3:   ret_rate = MGN_MCS3;    break;
+		case DESC90_RATEMCS4:   ret_rate = MGN_MCS4;    break;
+		case DESC90_RATEMCS5:   ret_rate = MGN_MCS5;    break;
+		case DESC90_RATEMCS6:   ret_rate = MGN_MCS6;    break;
+		case DESC90_RATEMCS7:   ret_rate = MGN_MCS7;    break;
+		case DESC90_RATEMCS8:   ret_rate = MGN_MCS8;    break;
+		case DESC90_RATEMCS9:   ret_rate = MGN_MCS9;    break;
+		case DESC90_RATEMCS10:  ret_rate = MGN_MCS10;   break;
+		case DESC90_RATEMCS11:  ret_rate = MGN_MCS11;   break;
+		case DESC90_RATEMCS12:  ret_rate = MGN_MCS12;   break;
+		case DESC90_RATEMCS13:  ret_rate = MGN_MCS13;   break;
+		case DESC90_RATEMCS14:  ret_rate = MGN_MCS14;   break;
+		case DESC90_RATEMCS15:  ret_rate = MGN_MCS15;   break;
+		case DESC90_RATEMCS32:  ret_rate = (0x80|0x20); break;
+		default:
+			ret_rate = 0xff;
+			RT_TRACE(COMP_RECV, "HwRateToMRate90(): Non supported"
+				" Rate [%x], bIsHT = %d!!!\n",rate, bIsHT);
+			break;
 		}
 	}
 
@@ -5092,58 +5216,61 @@ static void rtl8192_query_rxphystatus(
 	precord_stats->RxMIMOSignalQuality[0] = -1;
 	precord_stats->RxMIMOSignalQuality[1] = -1;
 
-	if(is_cck_rate)
-	{
+	if (is_cck_rate) {
 		/* (1)Hardware does not provide RSSI for CCK */
-
-		/* (2)PWDB, Average PWDB cacluated by hardware (for rate adaptive) */
+		/* (2)PWDB, Average PWDB cacluated by hardware
+		 * (for rate adaptive)
+		 */
 
 		u8 report;		/* , cck_agc_rpt; */
 
 		priv->stats.numqry_phystatusCCK++;
 
-		if(!priv->bCckHighPower)
-		{
+		if (!priv->bCckHighPower) {
 			report = pcck_buf->cck_agc_rpt & 0xc0;
 			report = report>>6;
-			switch(report)
-			{
-				/* Fixed by Jacken from Bryant 2008-03-20
-				 * Original value is -38 , -26 , -14 , -2
-				 * Fixed value is -35 , -23 , -11 , 6
-				 */
-				case 0x3:
-					rx_pwr_all = -35 - (pcck_buf->cck_agc_rpt & 0x3e);
-					break;
-				case 0x2:
-					rx_pwr_all = -23 - (pcck_buf->cck_agc_rpt & 0x3e);
-					break;
-				case 0x1:
-					rx_pwr_all = -11 - (pcck_buf->cck_agc_rpt & 0x3e);
-					break;
-				case 0x0:
-					rx_pwr_all = 6 - (pcck_buf->cck_agc_rpt & 0x3e);
-					break;
+			switch (report) {
+			/* Fixed by Jacken from Bryant 2008-03-20
+			 * Original value is -38 , -26 , -14 , -2
+			 * Fixed value is -35 , -23 , -11 , 6
+			 */
+			case 0x3:
+				rx_pwr_all = -35 - (pcck_buf->cck_agc_rpt &
+									0x3e);
+				break;
+			case 0x2:
+				rx_pwr_all = -23 - (pcck_buf->cck_agc_rpt &
+									0x3e);
+				break;
+			case 0x1:
+				rx_pwr_all = -11 - (pcck_buf->cck_agc_rpt &
+									0x3e);
+				break;
+			case 0x0:
+				rx_pwr_all = 6 - (pcck_buf->cck_agc_rpt &
+									0x3e);
+				break;
 			}
-		}
-		else
-		{
+		} else {
 			report = pcck_buf->cck_agc_rpt & 0x60;
 			report = report>>5;
-			switch(report)
-			{
-				case 0x3:
-					rx_pwr_all = -35 - ((pcck_buf->cck_agc_rpt & 0x1f)<<1) ;
-					break;
-				case 0x2:
-					rx_pwr_all = -23 - ((pcck_buf->cck_agc_rpt & 0x1f)<<1);
-					break;
-				case 0x1:
-					rx_pwr_all = -11 - ((pcck_buf->cck_agc_rpt & 0x1f)<<1) ;
-					break;
-				case 0x0:
-					rx_pwr_all = 6 - ((pcck_buf->cck_agc_rpt & 0x1f)<<1) ;
-					break;
+			switch (report) {
+			case 0x3:
+				rx_pwr_all = -35 - ((pcck_buf->cck_agc_rpt &
+								0x1f)<<1) ;
+				break;
+			case 0x2:
+				rx_pwr_all = -23 - ((pcck_buf->cck_agc_rpt &
+								0x1f)<<1);
+				break;
+			case 0x1:
+				rx_pwr_all = -11 - ((pcck_buf->cck_agc_rpt &
+								0x1f)<<1) ;
+				break;
+			case 0x0:
+				rx_pwr_all = 6 - ((pcck_buf->cck_agc_rpt &
+								0x1f)<<1) ;
+				break;
 			}
 		}
 
@@ -5157,33 +5284,29 @@ static void rtl8192_query_rxphystatus(
 		{
 			u8	sq;
 
-			if(pstats->RxPWDBAll > 40)
-			{
+			if (pstats->RxPWDBAll > 40) {
 				sq = 100;
-			}else
-			{
+			} else {
 				sq = pcck_buf->sq_rpt;
 
-				if(pcck_buf->sq_rpt > 64)
+				if (pcck_buf->sq_rpt > 64)
 					sq = 0;
 				else if (pcck_buf->sq_rpt < 20)
 					sq = 100;
 				else
 					sq = ((64-sq) * 100) / 44;
 			}
-			pstats->SignalQuality = precord_stats->SignalQuality = sq;
-			pstats->RxMIMOSignalQuality[0] = precord_stats->RxMIMOSignalQuality[0] = sq;
-			pstats->RxMIMOSignalQuality[1] = precord_stats->RxMIMOSignalQuality[1] = -1;
+			pstats->SignalQuality =
+					precord_stats->SignalQuality = sq;
+			pstats->RxMIMOSignalQuality[0] = 
+				precord_stats->RxMIMOSignalQuality[0] = sq;
+			pstats->RxMIMOSignalQuality[1] =
+				precord_stats->RxMIMOSignalQuality[1] = -1;
 		}
-	}
-	else
-	{
+	} else {
 		priv->stats.numqry_phystatusHT++;
-
 		/* (1)Get RSSI for HT rate */
-
-		for(i=RF90_PATH_A; i<priv->NumTotalRFPath; i++)
-		{
+		for (i = RF90_PATH_A; i<priv->NumTotalRFPath; i++) {
 			/* 2008/01/30 MH we will judge RF RX path now. */
 			if (priv->brfpath_rxenable[i])
 				rf_rx_num++;
@@ -5195,7 +5318,8 @@ static void rtl8192_query_rxphystatus(
 
 			/* Fixed by Jacken from Bryant 2008-03-20 */
 			/* Original value is 106 */
-			rx_pwr[i] = ((pofdm_buf->trsw_gain_X[i]&0x3F)*2) - 106;
+			rx_pwr[i] = ((pofdm_buf->trsw_gain_X[i]&0x3F) * 2)
+									- 106;
 
 			/* Get Rx snr value in DB */
 			tmp_rxsnr =	pofdm_buf->rxsnr_X[i];
@@ -5212,11 +5336,14 @@ static void rtl8192_query_rxphystatus(
 			/* if(bpacket_match_bssid) */
 			{
 				pstats->RxMIMOSignalStrength[i] =(u8) RSSI;
-				precord_stats->RxMIMOSignalStrength[i] =(u8) RSSI;
+				precord_stats->RxMIMOSignalStrength[i] =(u8)
+									RSSI;
 			}
 		}
 
-		/* (2)PWDB, Average PWDB cacluated by hardware (for rate adaptive) */
+		/* (2)PWDB, Average PWDB cacluated by hardware (for rate
+		 * adaptive)
+		 */
 
 		/* Fixed by Jacken from Bryant 2008-03-20 */
 		/* Original value is 106 */
@@ -5228,8 +5355,8 @@ static void rtl8192_query_rxphystatus(
 
 		/* (3)EVM of HT rate */
 
-		if(pdrvinfo->RxHT && pdrvinfo->RxRate>=DESC90_RATEMCS8 &&
-			pdrvinfo->RxRate<=DESC90_RATEMCS15)
+		if (pdrvinfo->RxHT && pdrvinfo->RxRate >= DESC90_RATEMCS8 &&
+			pdrvinfo->RxRate <= DESC90_RATEMCS15)
 			max_spatial_stream = 2;
 			/* both spatial stream make sense */
 		else
@@ -5237,7 +5364,7 @@ static void rtl8192_query_rxphystatus(
 			/* only spatial stream 1 makes sense */
 
 		for (i = 0; i < max_spatial_stream; i++) {
-			tmp_rxevm =	pofdm_buf->rxevm_X[i];
+			tmp_rxevm = pofdm_buf->rxevm_X[i];
 			rx_evmX = (char)(tmp_rxevm);
 
 			/* Do not use shift operation like "rx_evmX >>= 1"
@@ -5252,20 +5379,25 @@ static void rtl8192_query_rxphystatus(
 			evm = rtl819x_evm_dbtopercentage(rx_evmX);
 			/* if(bpacket_match_bssid) */
 			{
-				if(i==0)
+				if (i == 0)
 					/*  Fill value in RFD,
 					 * Get the first spatial stream only */
-					pstats->SignalQuality = precord_stats->SignalQuality = (u8)(evm & 0xff);
-				pstats->RxMIMOSignalQuality[i] = precord_stats->RxMIMOSignalQuality[i] = (u8)(evm & 0xff);
+					pstats->SignalQuality = 
+						precord_stats->SignalQuality =
+							(u8)(evm & 0xff);
+				pstats->RxMIMOSignalQuality[i] =
+					precord_stats->RxMIMOSignalQuality[i] =
+							(u8)(evm & 0xff);
 			}
 		}
 
 
 		/* record rx statistics for debug */
 		rxsc_sgien_exflg = pofdm_buf->rxsc_sgien_exflg;
-		prxsc =	(phy_ofdm_rx_status_rxsc_sgien_exintfflag *)&rxsc_sgien_exflg;
-		if(pdrvinfo->BW)		/* 40M channel */
-			priv->stats.received_bwtype[1+prxsc->rxsc]++;
+		prxsc =	(phy_ofdm_rx_status_rxsc_sgien_exintfflag *)
+							&rxsc_sgien_exflg;
+		if (pdrvinfo->BW)		/* 40M channel */
+			priv->stats.received_bwtype[1 + prxsc->rxsc]++;
 		else				/* 20M channel */
 			priv->stats.received_bwtype[0]++;
 	}
@@ -5274,9 +5406,9 @@ static void rtl8192_query_rxphystatus(
 	 * from 0~100. It is assigned to the BSS List in
 	 * GetValueFromBeaconOrProbeRsp().
 	 */
-	if(is_cck_rate)
-	{
-		pstats->SignalStrength = precord_stats->SignalStrength = (u8)(rtl819x_signal_scale_mapping((long)pwdb_all));
+	if (is_cck_rate) {
+		pstats->SignalStrength = precord_stats->SignalStrength =
+			(u8)(rtl819x_signal_scale_mapping((long)pwdb_all));
 		/* PWDB_ALL; */
 
 	}
@@ -5289,7 +5421,9 @@ static void rtl8192_query_rxphystatus(
 		 * We can judge RX path number now.
 		 */
 		if (rf_rx_num != 0)
-			pstats->SignalStrength = precord_stats->SignalStrength = (u8)(rtl819x_signal_scale_mapping((long)(total_rssi/=rf_rx_num)));
+			pstats->SignalStrength = precord_stats->SignalStrength
+				= (u8)(rtl819x_signal_scale_mapping(
+					(long)(total_rssi/=rf_rx_num)));
 	}
 }	/* QueryRxPhyStatus8190Pci */
 
@@ -5410,48 +5544,48 @@ UpdateReceivedRateHistogramStatistics8190(
 	else
 	preamble_guardinterval = 0;		/* long */
 
-	switch(stats->rate)
-	{
-		/* CCK rate */
-		case MGN_1M:    rateIndex = 0;  break;
-		case MGN_2M:    rateIndex = 1;  break;
-		case MGN_5_5M:  rateIndex = 2;  break;
-		case MGN_11M:   rateIndex = 3;  break;
-		/* Legacy OFDM rate */
-		case MGN_6M:    rateIndex = 4;  break;
-		case MGN_9M:    rateIndex = 5;  break;
-		case MGN_12M:   rateIndex = 6;  break;
-		case MGN_18M:   rateIndex = 7;  break;
-		case MGN_24M:   rateIndex = 8;  break;
-		case MGN_36M:   rateIndex = 9;  break;
-		case MGN_48M:   rateIndex = 10; break;
-		case MGN_54M:   rateIndex = 11; break;
-		/* 11n High throughput rate */
-		case MGN_MCS0:  rateIndex = 12; break;
-		case MGN_MCS1:  rateIndex = 13; break;
-		case MGN_MCS2:  rateIndex = 14; break;
-		case MGN_MCS3:  rateIndex = 15; break;
-		case MGN_MCS4:  rateIndex = 16; break;
-		case MGN_MCS5:  rateIndex = 17; break;
-		case MGN_MCS6:  rateIndex = 18; break;
-		case MGN_MCS7:  rateIndex = 19; break;
-		case MGN_MCS8:  rateIndex = 20; break;
-		case MGN_MCS9:  rateIndex = 21; break;
-		case MGN_MCS10: rateIndex = 22; break;
-		case MGN_MCS11: rateIndex = 23; break;
-		case MGN_MCS12: rateIndex = 24; break;
-		case MGN_MCS13: rateIndex = 25; break;
-		case MGN_MCS14: rateIndex = 26; break;
-		case MGN_MCS15: rateIndex = 27; break;
-		default:        rateIndex = 28; break;
-	}
-    priv->stats.received_preamble_GI[preamble_guardinterval][rateIndex]++;
-    priv->stats.received_rate_histogram[0][rateIndex]++;	/* total */
-    priv->stats.received_rate_histogram[rcvType][rateIndex]++;
-}
-
-
-void query_rxdesc_status(struct sk_buff *skb, struct ieee80211_rx_stats *stats, bool bIsRxAggrSubframe)
+	switch (stats->rate) {
+	/* CCK rate */
+	case MGN_1M:    rateIndex = 0;  break;
+	case MGN_2M:    rateIndex = 1;  break;
+	case MGN_5_5M:  rateIndex = 2;  break;
+	case MGN_11M:   rateIndex = 3;  break;
+	/* Legacy OFDM rate */
+	case MGN_6M:    rateIndex = 4;  break;
+	case MGN_9M:    rateIndex = 5;  break;
+	case MGN_12M:   rateIndex = 6;  break;
+	case MGN_18M:   rateIndex = 7;  break;
+	case MGN_24M:   rateIndex = 8;  break;
+	case MGN_36M:   rateIndex = 9;  break;
+	case MGN_48M:   rateIndex = 10; break;
+	case MGN_54M:   rateIndex = 11; break;
+	/* 11n High throughput rate */
+	case MGN_MCS0:  rateIndex = 12; break;
+	case MGN_MCS1:  rateIndex = 13; break;
+	case MGN_MCS2:  rateIndex = 14; break;
+	case MGN_MCS3:  rateIndex = 15; break;
+	case MGN_MCS4:  rateIndex = 16; break;
+	case MGN_MCS5:  rateIndex = 17; break;
+	case MGN_MCS6:  rateIndex = 18; break;
+	case MGN_MCS7:  rateIndex = 19; break;
+	case MGN_MCS8:  rateIndex = 20; break;
+	case MGN_MCS9:  rateIndex = 21; break;
+	case MGN_MCS10: rateIndex = 22; break;
+	case MGN_MCS11: rateIndex = 23; break;
+	case MGN_MCS12: rateIndex = 24; break;
+	case MGN_MCS13: rateIndex = 25; break;
+	case MGN_MCS14: rateIndex = 26; break;
+	case MGN_MCS15: rateIndex = 27; break;
+	default:        rateIndex = 28; break;
+	}
+	priv->stats.received_preamble_GI[preamble_guardinterval][rateIndex]++;
+	priv->stats.received_rate_histogram[0][rateIndex]++;	/* total */
+	priv->stats.received_rate_histogram[rcvType][rateIndex]++;
+}
+
+
+void query_rxdesc_status(struct sk_buff *skb, struct ieee80211_rx_stats *stats,
+							bool bIsRxAggrSubframe)
 {
 	rtl8192_rx_info *info = (struct rtl8192_rx_info *)skb->cb;
 	struct net_device *dev=info->dev;
@@ -5461,9 +5595,9 @@ void query_rxdesc_status(struct sk_buff *skb, struct ieee80211_rx_stats *stats,
 
 	/* Get Rx Descriptor Information */
 #ifdef USB_RX_AGGREGATION_SUPPORT
-	if (bIsRxAggrSubframe)
-	{
-		rx_desc_819x_usb_aggr_subframe *desc = (rx_desc_819x_usb_aggr_subframe *)skb->data;
+	if (bIsRxAggrSubframe) {
+		rx_desc_819x_usb_aggr_subframe *desc =
+				(rx_desc_819x_usb_aggr_subframe *)skb->data;
 		stats->Length = desc->Length ;
 		stats->RxDrvInfoSize = desc->RxDrvInfoSize;
 		stats->RxBufShift = 0;
@@ -5494,31 +5628,28 @@ void query_rxdesc_status(struct sk_buff *skb, struct ieee80211_rx_stats *stats,
 		stats->Decrypted = !desc->SWDec;
 	}
 
-	if((priv->ieee80211->pHTInfo->bCurrentHTSupport == true) && (priv->ieee80211->pairwise_key_type == KEY_TYPE_CCMP))
-	{
+	if ((priv->ieee80211->pHTInfo->bCurrentHTSupport == true) &&
+			(priv->ieee80211->pairwise_key_type == KEY_TYPE_CCMP))
 		stats->bHwError = false;
-	}
 	else
-	{
 		stats->bHwError = stats->bCRC|stats->bICV;
-	}
 
-	if(stats->Length < 24 || stats->Length > MAX_8192U_RX_SIZE)
+	if (stats->Length < 24 || stats->Length > MAX_8192U_RX_SIZE)
 		stats->bHwError |= 1;
 
 	/* Get Driver Info */
 	/* TODO: Need to verify it on FGPA platform */
 	/* Driver info are written to the RxBuffer following rx desc */
 	if (stats->RxDrvInfoSize != 0) {
-		driver_info = (rx_drvinfo_819x_usb *)(skb->data + sizeof(rx_desc_819x_usb) + \
-				stats->RxBufShift);
+		driver_info = (rx_drvinfo_819x_usb *)(skb->data +
+				sizeof(rx_desc_819x_usb) + stats->RxBufShift);
 		/* unit: 0.5M */
 		/* TODO */
-		if(!stats->bHwError){
+		if (!stats->bHwError) {
 			u8	ret_rate;
-			ret_rate = HwRateToMRate90(driver_info->RxHT, driver_info->RxRate);
-			if(ret_rate == 0xff)
-			{
+			ret_rate = HwRateToMRate90(driver_info->RxHT,
+							driver_info->RxRate);
+			if (ret_rate == 0xff) {
 				/* Abnormal Case: Receive CRC OK packet with Rx
 				 * descriptor indicating non supported rate.
 				 */
@@ -5529,8 +5660,7 @@ void query_rxdesc_status(struct sk_buff *skb, struct ieee80211_rx_stats *stats,
 				stats->bHwError = 1;
 				stats->rate = MGN_1M;
 				/* Set 1M rate by default */
-			}else
-			{
+			} else {
 				stats->rate = ret_rate;
 			}
 		}
@@ -5539,11 +5669,11 @@ void query_rxdesc_status(struct sk_buff *skb, struct ieee80211_rx_stats *stats,
 
 		stats->bShortPreamble = driver_info->SPLCP;
 
-
 		UpdateReceivedRateHistogramStatistics8190(dev, stats);
 
-		stats->bIsAMPDU = (driver_info->PartAggr==1);
-		stats->bFirstMPDU = (driver_info->PartAggr==1) && (driver_info->FirstAGGR==1);
+		stats->bIsAMPDU = (driver_info->PartAggr == 1);
+		stats->bFirstMPDU = (driver_info->PartAggr == 1) &&
+						(driver_info->FirstAGGR == 1);
 		stats->TimeStampLow = driver_info->TSFL;
 		/* xiong mask it, 070514 */
 		/* pRfd->Status.TimeStampHigh =
@@ -5554,17 +5684,17 @@ void query_rxdesc_status(struct sk_buff *skb, struct ieee80211_rx_stats *stats,
 		UpdateRxPktTimeStamp8190(dev, stats);
 
 		/* Rx A-MPDU */
-		if(driver_info->FirstAGGR==1 || driver_info->PartAggr == 1)
-			RT_TRACE(COMP_RXDESC, "driver_info->FirstAGGR = %d, driver_info->PartAggr = %d\n",
-					driver_info->FirstAGGR, driver_info->PartAggr);
-
+		if (driver_info->FirstAGGR == 1 || driver_info->PartAggr == 1)
+			RT_TRACE(COMP_RXDESC, "driver_info->FirstAGGR = %d,"
+				" driver_info->PartAggr = %d\n",
+				driver_info->FirstAGGR, driver_info->PartAggr);
 	}
 
-	skb_pull(skb,sizeof(rx_desc_819x_usb));
+	skb_pull(skb, sizeof(rx_desc_819x_usb));
 	/* Get Total offset of MPDU Frame Body */
-	if((stats->RxBufShift + stats->RxDrvInfoSize) > 0) {
+	if ((stats->RxBufShift + stats->RxDrvInfoSize) > 0) {
 		stats->bShift = 1;
-		skb_pull(skb,stats->RxBufShift + stats->RxDrvInfoSize);
+		skb_pull(skb, stats->RxBufShift + stats->RxDrvInfoSize);
 	}
 
 #ifdef USB_RX_AGGREGATION_SUPPORT
@@ -5879,28 +6009,24 @@ void rtl8192_irq_rx_tasklet(struct r8192_priv *priv)
 		info = (struct rtl8192_rx_info *)skb->cb;
 		switch (info->out_pipe) {
 		/* Nomal packet pipe */
-			case 3:
-				/* RT_TRACE(COMP_RECV, "normal in-pipe"
-				 *	" index(%d)\n", info->out_pipe);
-				 */
-				priv->IrpPendingCount--;
-				rtl8192_rx_nomal(skb);
-				break;
-
-				/* Command packet pipe */
-			case 9:
-				RT_TRACE(COMP_RECV, "command in-pipe index(%d)\n",\
-						info->out_pipe);
-
-				rtl8192_rx_cmd(skb);
-				break;
-
-			default: /* should never get here! */
-				RT_TRACE(COMP_ERR, "Unknown in-pipe index(%d)\n",\
-						info->out_pipe);
-				dev_kfree_skb(skb);
-				break;
-
+		case 3:
+		/* RT_TRACE(COMP_RECV, "normal in-pipe"
+		 *	" index(%d)\n", info->out_pipe);
+		 */
+		priv->IrpPendingCount--;
+		rtl8192_rx_nomal(skb);
+		break;
+		/* Command packet pipe */
+		case 9:
+		RT_TRACE(COMP_RECV, "command in-pipe index(%d)\n",
+							info->out_pipe);
+		rtl8192_rx_cmd(skb);
+		break;
+		default: /* should never get here! */
+		RT_TRACE(COMP_ERR, "Unknown in-pipe index(%d)\n",
+							info->out_pipe);
+		dev_kfree_skb(skb);
+		break;
 		}
 	}
 }
-- 
1.6.3.3

