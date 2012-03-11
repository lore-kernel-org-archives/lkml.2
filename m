Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab2CKEeQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 23:34:16 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39853 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab2CKEeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 23:34:14 -0500
From: Andrew Miller <amiller@amilx.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Andrew Miller <amiller@amilx.com>
Subject: [PATCH] Staging: rtl8187se: r8180_core.c: Fix coding style issue
Date: Sat, 10 Mar 2012 23:32:33 -0500
Message-Id: <1331440353-2829-1-git-send-email-amiller@amilx.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix long line coding style issue

Signed-off-by: Andrew Miller <amiller@amilx.com>
---
 drivers/staging/rtl8187se/r8180_core.c |  556 ++++++++++++++++++++++----------
 1 files changed, 386 insertions(+), 170 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 04c2391..05f25eb 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -79,8 +79,11 @@ module_param(hwwep, int, S_IRUGO|S_IWUSR);
 module_param(channels, int, S_IRUGO|S_IWUSR);
 
 MODULE_PARM_DESC(devname, " Net interface name, wlan%d=default");
-MODULE_PARM_DESC(hwseqnum, " Try to use hardware 802.11 header sequence numbers. Zero=default");
-MODULE_PARM_DESC(hwwep, " Try to use hardware WEP support. Still broken and not available on all cards");
+MODULE_PARM_DESC(hwseqnum, " Try to use hardware 802.11 header sequence "
+				"numbers. Zero=default");
+MODULE_PARM_DESC(hwwep, " Try to use hardware WEP support. "
+			"Still broken and not"
+			" available on all cards");
 MODULE_PARM_DESC(channels, " Channel bitmask for specific locales. NYI");
 
 
@@ -286,7 +289,8 @@ static int proc_get_stats_tx(char *page, char **start,
 	int len = 0;
 	unsigned long totalOK;
 
-	totalOK = priv->stats.txnpokint+priv->stats.txhpokint+priv->stats.txlpokint;
+	totalOK = priv->stats.txnpokint+
+			priv->stats.txhpokint+priv->stats.txlpokint;
 	len += snprintf(page + len, count - len,
 		"TX OK: %lu\n"
 		"TX Error: %lu\n"
@@ -415,7 +419,10 @@ short buffer_add(struct buffer **buffer, u32 *buf, dma_addr_t dma,
 	return 0;
 }
 
-void buffer_free(struct net_device *dev, struct buffer **buffer, int len, short consistent)
+void buffer_free(struct net_device *dev,
+		struct buffer **buffer,
+		int len,
+		short consistent)
 {
 
 	struct buffer *tmp, *next;
@@ -516,7 +523,8 @@ short check_nic_enought_desc(struct net_device *dev, int priority)
 	struct ieee80211_device *ieee = netdev_priv(dev);
 	int requiredbyte, required;
 
-	requiredbyte = priv->ieee80211->fts + sizeof(struct ieee80211_header_data);
+	requiredbyte = priv->ieee80211->fts +
+		sizeof(struct ieee80211_header_data);
 
 	if (ieee->current_network.QoS_Enable)
 		requiredbyte += 2;
@@ -982,49 +990,70 @@ short alloc_tx_desc_ring(struct net_device *dev, int bufsize, int count,
 
 		switch (addr) {
 		case TX_MANAGEPRIORITY_RING_ADDR:
-			if (-1 == buffer_add(&(priv->txmapbufs), buf, dma_tmp, NULL)) {
+			if (-1 == buffer_add(&(priv->txmapbufs),
+					buf,
+					dma_tmp,
+					NULL)) {
 				DMESGE("Unable to allocate mem for buffer NP");
 				return -ENOMEM;
 			}
 			break;
 		case TX_BKPRIORITY_RING_ADDR:
-			if (-1 == buffer_add(&(priv->txbkpbufs), buf, dma_tmp, NULL)) {
+			if (-1 == buffer_add(&(priv->txbkpbufs),
+					buf,
+					dma_tmp,
+					NULL)) {
 				DMESGE("Unable to allocate mem for buffer LP");
 				return -ENOMEM;
 			}
 			break;
 		case TX_BEPRIORITY_RING_ADDR:
-			if (-1 == buffer_add(&(priv->txbepbufs), buf, dma_tmp, NULL)) {
+			if (-1 == buffer_add(&(priv->txbepbufs),
+					buf,
+					dma_tmp,
+					NULL)) {
 				DMESGE("Unable to allocate mem for buffer NP");
 				return -ENOMEM;
 			}
 			break;
 		case TX_VIPRIORITY_RING_ADDR:
-			if (-1 == buffer_add(&(priv->txvipbufs), buf, dma_tmp, NULL)) {
+			if (-1 == buffer_add(&(priv->txvipbufs),
+					buf,
+					dma_tmp,
+					NULL)) {
 				DMESGE("Unable to allocate mem for buffer LP");
 				return -ENOMEM;
 			}
 			break;
 		case TX_VOPRIORITY_RING_ADDR:
-			if (-1 == buffer_add(&(priv->txvopbufs), buf, dma_tmp, NULL)) {
+			if (-1 == buffer_add(&(priv->txvopbufs),
+					buf,
+					dma_tmp,
+					NULL)) {
 				DMESGE("Unable to allocate mem for buffer NP");
 				return -ENOMEM;
 			}
 			break;
 		case TX_HIGHPRIORITY_RING_ADDR:
-			if (-1 == buffer_add(&(priv->txhpbufs), buf, dma_tmp, NULL)) {
+			if (-1 == buffer_add(&(priv->txhpbufs),
+					buf,
+					dma_tmp,
+					NULL)) {
 				DMESGE("Unable to allocate mem for buffer HP");
 				return -ENOMEM;
 			}
 			break;
 		case TX_BEACON_RING_ADDR:
-			if (-1 == buffer_add(&(priv->txbeaconbufs), buf, dma_tmp, NULL)) {
+			if (-1 == buffer_add(&(priv->txbeaconbufs),
+					buf,
+					dma_tmp, NULL)) {
 				DMESGE("Unable to allocate mem for buffer BP");
 				return -ENOMEM;
 			}
 			break;
 		}
-		*tmp = *tmp & ~(1<<31); /* descriptor empty, owned by the drv */
+		*tmp = *tmp & ~(1<<31); /* descriptor empty,
+					 * owned by the drv */
 		*(tmp+2) = (u32)dma_tmp;
 		*(tmp+3) = bufsize;
 
@@ -1137,8 +1166,9 @@ short alloc_rx_desc_ring(struct net_device *dev, u16 bufsize, int count)
 		return -1;
 	}
 
-	desc = (u32 *)pci_alloc_consistent(pdev, sizeof(u32)*rx_desc_size*count+256,
-					  &dma_desc);
+	desc = (u32 *)pci_alloc_consistent(pdev,
+					sizeof(u32)*rx_desc_size*count+256,
+					&dma_desc);
 
 	if (dma_desc & 0xff)
 		/*
@@ -1174,7 +1204,9 @@ short alloc_rx_desc_ring(struct net_device *dev, u16 bufsize, int count)
 		tmp = tmp+rx_desc_size;
 	}
 
-	*(tmp-rx_desc_size) = *(tmp-rx_desc_size) | (1<<30); /* this is the last descriptor */
+	*(tmp-rx_desc_size) = *(tmp-rx_desc_size) | (1<<30); /* this is the
+							      * last descriptor
+							      */
 
 	return 0;
 }
@@ -1248,7 +1280,8 @@ inline u16 ieeerate2rtlrate(int rate)
 	}
 }
 
-static u16 rtl_rate[] = {10, 20, 55, 110, 60, 90, 120, 180, 240, 360, 480, 540, 720};
+static u16 rtl_rate[] = {10, 20, 55, 110, 60, 90, 120,
+			180, 240, 360, 480, 540, 720};
 
 inline u16 rtl8180_rate2rate(short rate)
 {
@@ -1277,17 +1310,19 @@ u16 ComputeTxTime(u16 FrameLength, u16 DataRate, u8 bManagementFrame,
 	if (rtl8180_IsWirelessBMode(DataRate)) {
 		if (bManagementFrame || !bShortPreamble || DataRate == 10)
 			/* long preamble */
-			FrameTime = (u16)(144+48+(FrameLength*8/(DataRate/10)));
+			FrameTime = (u16)(144+48+(FrameLength*8/
+					(DataRate/10)));
 		else
 			/* short preamble */
 			FrameTime = (u16)(72+24+(FrameLength*8/(DataRate/10)));
 
-		if ((FrameLength*8 % (DataRate/10)) != 0) /* get the ceilling */
+		if ((FrameLength*8 % (DataRate/10)) != 0) /* get the
+							   * ceilling */
 			FrameTime++;
 	} else {	/* 802.11g DSSS-OFDM PLCP length field calculation. */
 		N_DBPS = N_DBPSOfRate(DataRate);
-		Ceiling = (16 + 8*FrameLength + 6) / N_DBPS
-				+ (((16 + 8*FrameLength + 6) % N_DBPS) ? 1 : 0);
+		Ceiling = (16 + 8*FrameLength + 6) / N_DBPS +
+			(((16 + 8*FrameLength + 6) % N_DBPS) ? 1 : 0);
 		FrameTime = (u16)(16 + 4 + 4*Ceiling + 6);
 	}
 	return FrameTime;
@@ -1392,11 +1427,13 @@ void PerformUndecoratedSignalSmoothing8185(struct r8180_priv *priv,
 	priv->bCurCCKPkt = bCckRate;
 
 	if (priv->UndecoratedSmoothedSS >= 0)
-		priv->UndecoratedSmoothedSS = ((priv->UndecoratedSmoothedSS * 5) + (priv->SignalStrength * 10)) / 6;
+		priv->UndecoratedSmoothedSS = ((priv->UndecoratedSmoothedSS *
+					5) + (priv->SignalStrength * 10)) / 6;
 	else
 		priv->UndecoratedSmoothedSS = priv->SignalStrength * 10;
 
-	priv->UndercorateSmoothedRxPower = ((priv->UndercorateSmoothedRxPower * 50) + (priv->RxPower * 11)) / 60;
+	priv->UndercorateSmoothedRxPower = ((priv->UndercorateSmoothedRxPower *
+					50) + (priv->RxPower * 11)) / 60;
 
 	if (bCckRate)
 		priv->CurCCKRSSI = priv->RSSI;
@@ -1453,7 +1490,8 @@ void rtl8180_rx(struct net_device *dev)
 		tmp = priv->rxringtail;
 		do {
 			if (tmp == priv->rxring)
-				tmp  = priv->rxring + (priv->rxringcount - 1)*rx_desc_size;
+				tmp  = priv->rxring + (priv->rxringcount - 1)*
+					rx_desc_size;
 			else
 				tmp -= rx_desc_size;
 
@@ -1474,7 +1512,9 @@ void rtl8180_rx(struct net_device *dev)
 
 		if (*(priv->rxringtail) & (1<<27)) {
 			priv->stats.rxdmafail++;
-			/* DMESG("EE: RX DMA FAILED at buffer pointed by descriptor %x",(u32)priv->rxringtail); */
+			/* DMESG("EE: RX DMA FAILED at buffer pointed by
+			 *descriptor %x",(u32)priv->rxringtail);
+			 */
 			goto drop;
 		}
 
@@ -1541,21 +1581,25 @@ void rtl8180_rx(struct net_device *dev)
 			priv->rx_skb_complete = 1;
 		}
 
-		signal = (unsigned char)(((*(priv->rxringtail+3)) & (0x00ff0000))>>16);
+		signal = (unsigned char)(((*(priv->rxringtail+3)) &
+				(0x00ff0000))>>16);
 		signal = (signal & 0xfe) >> 1;
 
 		quality = (unsigned char)((*(priv->rxringtail+3)) & (0xff));
 
 		stats.mac_time[0] = *(priv->rxringtail+1);
 		stats.mac_time[1] = *(priv->rxringtail+2);
-		rxpower = ((char)(((*(priv->rxringtail+4)) & (0x00ff0000))>>16))/2 - 42;
-		RSSI = ((u8)(((*(priv->rxringtail+3)) & (0x0000ff00))>>8)) & (0x7f);
+		rxpower = ((char)(((*(priv->rxringtail+4)) &
+			(0x00ff0000))>>16))/2 - 42;
+		RSSI = ((u8)(((*(priv->rxringtail+3)) &
+			(0x0000ff00))>>8)) & (0x7f);
 
 		rate = ((*(priv->rxringtail)) &
 			((1<<23)|(1<<22)|(1<<21)|(1<<20)))>>20;
 
 		stats.rate = rtl8180_rate2rate(rate);
-		Antenna = (((*(priv->rxringtail+3)) & (0x00008000)) == 0) ? 0 : 1;
+		Antenna = (((*(priv->rxringtail+3)) &
+			(0x00008000)) == 0) ? 0 : 1;
 		if (!rtl8180_IsWirelessBMode(stats.rate)) { /* OFDM rate. */
 			RxAGC_dBm = rxpower+1;	/* bias */
 		} else { /* CCK rate. */
@@ -1564,7 +1608,8 @@ void rtl8180_rx(struct net_device *dev)
 			LNA = (u8) (RxAGC_dBm & 0x60) >> 5; /* bit 6~ bit 5 */
 			BB  = (u8) (RxAGC_dBm & 0x1F); /* bit 4 ~ bit 0 */
 
-			RxAGC_dBm = -(LNA_gain[LNA] + (BB*2)); /* Pin_11b=-(LNA_gain+BB_gain) (dBm) */
+			RxAGC_dBm = -(LNA_gain[LNA] + (BB*2));
+					/* Pin_11b=-(LNA_gain+BB_gain) (dBm) */
 
 			RxAGC_dBm += 4; /* bias */
 		}
@@ -1592,23 +1637,36 @@ void rtl8180_rx(struct net_device *dev)
 		priv->RSSI = RSSI;
 		/* SQ translation formula is provided by SD3 DZ. 2006.06.27 */
 		if (quality >= 127)
-			quality = 1; /*0; */ /* 0 will cause epc to show signal zero , walk around now; */
+			quality = 1; /*0; */ /* 0 will cause epc to show signal
+				      * zero , walk around now;
+				      */
 		else if (quality < 27)
 			quality = 100;
 		else
 			quality = 127 - quality;
 		priv->SignalQuality = quality;
 
-		stats.signal = (u8)quality; /*priv->wstats.qual.level = priv->SignalStrength; */
+		stats.signal = (u8)quality; /*priv->wstats.qual.level =
+					     *priv->SignalStrength;
+					     */
 		stats.signalstrength = RXAGC;
 		if (stats.signalstrength > 100)
 			stats.signalstrength = 100;
 		stats.signalstrength = (stats.signalstrength * 70)/100 + 30;
-		/* printk("==========================>rx : RXAGC is %d,signalstrength is %d\n",RXAGC,stats.signalstrength); */
+		/* printk("==========================>rx :
+		 * RXAGC is %d,signalstrength is %d\n",
+		 * RXAGC,stats.signalstrength);
+		 */
 		stats.rssi = priv->wstats.qual.qual = priv->SignalQuality;
-		stats.noise = priv->wstats.qual.noise = 100 - priv->wstats.qual.qual;
-		bHwError = (((*(priv->rxringtail)) & (0x00000fff)) == 4080) | (((*(priv->rxringtail)) & (0x04000000)) != 0)
-			| (((*(priv->rxringtail)) & (0x08000000)) != 0) | (((~(*(priv->rxringtail))) & (0x10000000)) != 0) | (((~(*(priv->rxringtail))) & (0x20000000)) != 0);
+		stats.noise = priv->wstats.qual.noise = 100 -
+				priv->wstats.qual.qual;
+		bHwError = (((*(priv->rxringtail)) & (0x00000fff)) == 4080) |
+				(((*(priv->rxringtail)) & (0x04000000)) != 0) |
+				(((*(priv->rxringtail)) & (0x08000000)) != 0) |
+				(((~(*(priv->rxringtail))) &
+				(0x10000000)) != 0) |
+				(((~(*(priv->rxringtail))) &
+				(0x20000000)) != 0);
 		bCRC = ((*(priv->rxringtail)) & (0x00002000)) >> 13;
 		bICV = ((*(priv->rxringtail)) & (0x00001000)) >> 12;
 		hdr = (struct ieee80211_hdr_4addr *)priv->rxbuffer->buf;
@@ -1616,7 +1674,12 @@ void rtl8180_rx(struct net_device *dev)
 		type = WLAN_FC_GET_TYPE(fc);
 
 			if ((IEEE80211_FTYPE_CTL != type) &&
-				(eqMacAddr(priv->ieee80211->current_network.bssid, (fc & IEEE80211_FCTL_TODS) ? hdr->addr1 : (fc & IEEE80211_FCTL_FROMDS) ? hdr->addr2 : hdr->addr3))
+				(eqMacAddr(
+					priv->ieee80211->current_network.bssid,
+					(fc & IEEE80211_FCTL_TODS) ?
+					hdr->addr1 : (fc &
+					IEEE80211_FCTL_FROMDS) ?
+					hdr->addr2 : hdr->addr3))
 				 && (!bHwError) && (!bCRC) && (!bICV)) {
 				/* Perform signal smoothing for dynamic
 				 * mechanism on demand. This is different
@@ -1624,25 +1687,38 @@ void rtl8180_rx(struct net_device *dev)
 				 * fomula. No dramatic adjustion is apply
 				 * because dynamic mechanism need some degree
 				 * of correctness. */
-				PerformUndecoratedSignalSmoothing8185(priv, bCckRate);
+				PerformUndecoratedSignalSmoothing8185(priv,
+								bCckRate);
 
 				/* For good-looking singal strength. */
-				SignalStrengthIndex = NetgearSignalStrengthTranslate(
-								priv->LastSignalStrengthInPercent,
-								priv->SignalStrength);
-
-				priv->LastSignalStrengthInPercent = SignalStrengthIndex;
-				priv->Stats_SignalStrength = TranslateToDbm8185((u8)SignalStrengthIndex);
+				SignalStrengthIndex =
+					NetgearSignalStrengthTranslate(
+					priv->LastSignalStrengthInPercent,
+					priv->SignalStrength);
+
+				priv->LastSignalStrengthInPercent =
+					SignalStrengthIndex;
+				priv->Stats_SignalStrength =
+					TranslateToDbm8185(
+						(u8)SignalStrengthIndex);
 		/*
-		 * We need more correct power of received packets and the  "SignalStrength" of RxStats is beautified,
+		 * We need more correct power of received packets and the
+		 * "SignalStrength" of RxStats is beautified,
 		 * so we record the correct power here.
 		 */
-				priv->Stats_SignalQuality = (long)(priv->Stats_SignalQuality * 5 + (long)priv->SignalQuality + 5) / 6;
-				priv->Stats_RecvSignalPower = (long)(priv->Stats_RecvSignalPower * 5 + priv->RecvSignalPower - 1) / 6;
+				priv->Stats_SignalQuality =
+					(long)(priv->Stats_SignalQuality * 5 +
+					(long)priv->SignalQuality + 5) / 6;
+				priv->Stats_RecvSignalPower =
+					(long)(priv->Stats_RecvSignalPower *
+					5 +
+					priv->RecvSignalPower - 1) / 6;
 
 		/* Figure out which antenna that received the lasted packet. */
-				priv->LastRxPktAntenna = Antenna ? 1 : 0; /* 0: aux, 1: main. */
-				SwAntennaDiversityRxOk8185(dev, priv->SignalStrength);
+				/* 0:aux, 1: main. */
+				priv->LastRxPktAntenna = Antenna ? 1 : 0;
+				SwAntennaDiversityRxOk8185(dev,
+							priv->SignalStrength);
 			}
 
 		if (first) {
@@ -1652,8 +1728,10 @@ void rtl8180_rx(struct net_device *dev)
 				dev_kfree_skb_any(priv->rx_skb);
 				priv->stats.rxnolast++;
 			}
-			/* support for prism header has been originally added by Christian */
-			if (priv->prism_hdr && priv->ieee80211->iw_mode == IW_MODE_MONITOR) {
+			/* support for prism header has been originally
+			 * added by Christian */
+			if (priv->prism_hdr && priv->ieee80211->iw_mode ==
+				IW_MODE_MONITOR) {
 				
 			} else {
 				priv->rx_skb = dev_alloc_skb(len+2);
@@ -1672,7 +1750,8 @@ void rtl8180_rx(struct net_device *dev)
 			*/
 			if (!priv->rx_skb_complete) {
 
-				tmp_skb = dev_alloc_skb(priv->rx_skb->len+len+2);
+				tmp_skb = dev_alloc_skb(
+					priv->rx_skb->len+len+2);
 
 				if (!tmp_skb)
 					goto drop;
@@ -1692,7 +1771,8 @@ void rtl8180_rx(struct net_device *dev)
 		if (!priv->rx_skb_complete) {
 			if (padding) {
 				memcpy(skb_put(priv->rx_skb, len),
-					(((unsigned char *)priv->rxbuffer->buf) + 2), len);
+					(((unsigned char *)priv->rxbuffer->buf)
+					+ 2), len);
 			} else {
 				memcpy(skb_put(priv->rx_skb, len),
 					priv->rxbuffer->buf, len);
@@ -1766,7 +1846,7 @@ void rtl8180_data_hard_resume(struct net_device *dev)
 	rtl8180_set_mode(dev, EPROM_CMD_NORMAL);
 }
 
-/* 
+/*
  * This function TX data frames when the ieee80211 stack requires this.
  * It checks also if we need to stop the ieee tx queue, eventually do it
  */
@@ -1774,7 +1854,8 @@ void rtl8180_hard_data_xmit(struct sk_buff *skb, struct net_device *dev, int
 rate) {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	int mode;
-	struct ieee80211_hdr_3addr *h = (struct ieee80211_hdr_3addr *) skb->data;
+	struct ieee80211_hdr_3addr *h =
+		(struct ieee80211_hdr_3addr *) skb->data;
 	short morefrag = (h->frame_control) & IEEE80211_FCTL_MOREFRAGS;
 	unsigned long flags;
 	int priority;
@@ -1810,7 +1891,7 @@ rate) {
 	spin_unlock_irqrestore(&priv->tx_lock, flags);
 }
 
-/* 
+/*
  * This is a rough attempt to TX a frame
  * This is called by the ieee 80211 stack to TX management frames.
  * If the ring is full packet are dropped (for data frame the queue
@@ -1905,7 +1986,8 @@ void rtl8180_prepare_beacon(struct net_device *dev)
 
 	u16 word  = read_nic_word(dev, BcnItv);
 	word &= ~BcnItv_BcnItv; /* clear Bcn_Itv */
-	word |= cpu_to_le16(priv->ieee80211->current_network.beacon_interval); /* 0x64; */
+	word |= cpu_to_le16(
+		priv->ieee80211->current_network.beacon_interval); /* 0x64; */
 	write_nic_word(dev, BcnItv, word);
 
 	skb = ieee80211_get_beacon(priv->ieee80211);
@@ -1916,7 +1998,7 @@ void rtl8180_prepare_beacon(struct net_device *dev)
 	}
 }
 
-/* 
+/*
  * This function do the real dirty work: it enqueues a TX command
  * descriptor in the ring buffer, copyes the frame in a TX buffer
  * and kicks the NIC to ensure it does the DMA transfer.
@@ -1935,7 +2017,8 @@ short rtl8180_tx(struct net_device *dev, u8* txbuf, int len, int priority,
 	u16 duration;
 	short ext;
 	struct buffer *buflist;
-	struct ieee80211_hdr_3addr *frag_hdr = (struct ieee80211_hdr_3addr *)txbuf;
+	struct ieee80211_hdr_3addr *frag_hdr =
+		(struct ieee80211_hdr_3addr *)txbuf;
 	u8 dest[ETH_ALEN];
 	u8			bUseShortPreamble = 0;
 	u8			bCTSEnable = 0;
@@ -2002,7 +2085,8 @@ short rtl8180_tx(struct net_device *dev, u8* txbuf, int len, int priority,
 			bRTSEnable = 0;
 			bCTSEnable = 0;
 
-			ThisFrameTime = ComputeTxTime(len + sCrcLng, rtl8180_rate2rate(rate), 0, bUseShortPreamble);
+			ThisFrameTime = ComputeTxTime(len + sCrcLng,
+				rtl8180_rate2rate(rate), 0, bUseShortPreamble);
 			TxDescDuration = ThisFrameTime;
 		} else { /* Unicast packet */
 			u16 AckTime;
@@ -2012,27 +2096,34 @@ short rtl8180_tx(struct net_device *dev, u8* txbuf, int len, int priority,
 
 			/* Figure out ACK rate according to BSS basic rate
 			 * and Tx rate. */
-			AckTime = ComputeTxTime(14, 10, 0, 0);	/* AckCTSLng = 14 use 1M bps send */
+			AckTime = ComputeTxTime(14, 10, 0, 0);	/* AckCTSLng =
+								 * 14 use 1M
+								 * bps send */
 
-			if (((len + sCrcLng) > priv->rts) && priv->rts) { /* RTS/CTS. */
+			if (((len + sCrcLng) > priv->rts) && priv->rts) {
+				/* RTS/CTS. */
 				u16 RtsTime, CtsTime;
 				/* u16 CtsRate; */
 				bRTSEnable = 1;
 				bCTSEnable = 0;
 
 				/* Rate and time required for RTS. */
-				RtsTime = ComputeTxTime(sAckCtsLng/8, priv->ieee80211->basic_rate, 0, 0);
+				RtsTime = ComputeTxTime(sAckCtsLng/8,
+					priv->ieee80211->basic_rate, 0, 0);
 				/* Rate and time required for CTS. */
-				CtsTime = ComputeTxTime(14, 10, 0, 0);	/* AckCTSLng = 14 use 1M bps send */
+				CtsTime = ComputeTxTime(14, 10, 0, 0);
+					/* AckCTSLng = 14 use 1M bps send */
 
-				/* Figure out time required to transmit this frame. */
+				/* Figure out time required
+				 * to transmit this frame. */
 				ThisFrameTime = ComputeTxTime(len + sCrcLng,
 						rtl8180_rate2rate(rate),
 						0,
 						bUseShortPreamble);
 
 				/* RTS-CTS-ThisFrame-ACK. */
-				RtsDur = CtsTime + ThisFrameTime + AckTime + 3*aSifsTime;
+				RtsDur = CtsTime + ThisFrameTime +
+					AckTime + 3*aSifsTime;
 
 				TxDescDuration = RtsTime + RtsDur;
 			} else { /* Normal case. */
@@ -2040,22 +2131,30 @@ short rtl8180_tx(struct net_device *dev, u8* txbuf, int len, int priority,
 				bRTSEnable = 0;
 				RtsDur = 0;
 
-				ThisFrameTime = ComputeTxTime(len + sCrcLng, rtl8180_rate2rate(rate), 0, bUseShortPreamble);
-				TxDescDuration = ThisFrameTime + aSifsTime + AckTime;
+				ThisFrameTime = ComputeTxTime(len + sCrcLng,
+					rtl8180_rate2rate(rate),
+					0,
+					bUseShortPreamble);
+				TxDescDuration = ThisFrameTime +
+						aSifsTime + AckTime;
 			}
 
-			if (!(frag_hdr->frame_control & IEEE80211_FCTL_MOREFRAGS)) {
+			if (!(frag_hdr->frame_control &
+					IEEE80211_FCTL_MOREFRAGS)) {
 				/* ThisFrame-ACK. */
 				Duration = aSifsTime + AckTime;
 			} else { /* One or more fragments remained. */
 				u16 NextFragTime;
-				NextFragTime = ComputeTxTime(len + sCrcLng, /* pretend following packet length equal current packet */
+				NextFragTime = ComputeTxTime(len + sCrcLng,
+				/* pretend following packet
+				 * length equal current packet */
 						rtl8180_rate2rate(rate),
 						0,
 						bUseShortPreamble);
 
 				/* ThisFrag-ACk-NextFrag-ACK. */
-				Duration = NextFragTime + 3*aSifsTime + 2*AckTime;
+				Duration = NextFragTime +
+						3*aSifsTime + 2*AckTime;
 			}
 
 		} /* End of Unicast packet */
@@ -2069,7 +2168,8 @@ short rtl8180_tx(struct net_device *dev, u8* txbuf, int len, int priority,
 	while (remain != 0) {
 		mb();
 		if (!buflist) {
-			DMESGE("TX buffer error, cannot TX frames. pri %d.", priority);
+			DMESGE("TX buffer error, cannot TX frames. pri %d.",
+				priority);
 			return -1;
 		}
 		buf = buflist->buf;
@@ -2088,19 +2188,22 @@ short rtl8180_tx(struct net_device *dev, u8* txbuf, int len, int priority,
 		*(tail+6) = 0;
 		*(tail+7) = 0;
 
-		/* FIXME: this should be triggered by HW encryption parameters.*/
+		/* FIXME: this should be triggered by
+		 * HW encryption parameters.*/
 		*tail |= (1<<15); /* no encrypt */
 
 		if (remain == len && !descfrag) {
 			ownbit_flag = false;
-			*tail = *tail | (1<<29) ; /* fist segment of the packet */
+			*tail = *tail | (1<<29) ; /* fist segment of
+						   * the packet */
 			*tail = *tail | (len);
 		} else {
 			ownbit_flag = true;
 		}
 
 		for (i = 0; i < buflen && remain > 0; i++, remain--) {
-			((u8 *)buf)[i] = txbuf[i]; /* copy data into descriptor pointed DMAble buffer */
+			((u8 *)buf)[i] = txbuf[i]; /* copy data into descriptor
+						    * pointed DMAble buffer */
 			if (remain == 4 && i+4 >= buflen)
 				break;
 			/* ensure the last desc has at least 4 bytes payload */
@@ -2110,21 +2213,27 @@ short rtl8180_tx(struct net_device *dev, u8* txbuf, int len, int priority,
 		*(tail+3) = *(tail+3) & ~0xfff;
 		*(tail+3) = *(tail+3) | i; /* buffer length */
 		/* Use short preamble or not */
-		if (priv->ieee80211->current_network.capability&WLAN_CAPABILITY_SHORT_PREAMBLE)
-			if (priv->plcp_preamble_mode == 1 && rate != 0)	/*  short mode now, not long! */
-			; /* *tail |= (1<<16); */				/* enable short preamble mode. */
+		if (priv->ieee80211->current_network.capability &
+			WLAN_CAPABILITY_SHORT_PREAMBLE)
+			if (priv->plcp_preamble_mode == 1 && rate != 0)
+				/*  short mode now, not long! */
+			; /* *tail |= (1<<16); */
+			  /* enable short preamble mode. */
 
 		if (bCTSEnable)
 			*tail |= (1<<18);
 
 		if (bRTSEnable) { /* rts enable */
-			*tail |= ((ieeerate2rtlrate(priv->ieee80211->basic_rate))<<19); /* RTS RATE */
+			*tail |= ((ieeerate2rtlrate(
+					priv->ieee80211->basic_rate))<<19);
+					/* RTS RATE */
 			*tail |= (1<<23); /* rts enable */
 			*(tail+1) |= (RtsDur&0xffff); /* RTS Duration */
 		}
 		*(tail+3) |= ((TxDescDuration&0xffff)<<16); /* DURATION */
 		/* *(tail+3) |= (0xe6<<16); */
-		*(tail+5) |= (11<<8); /* (priv->retry_data<<8); */ /* retry lim; */
+		*(tail+5) |= (11<<8); /* (priv->retry_data<<8); */
+				      /* retry lim; */
 
 		*tail = *tail | ((rate&0xf) << 24);
 
@@ -2134,7 +2243,9 @@ short rtl8180_tx(struct net_device *dev, u8* txbuf, int len, int priority,
 			duration = rtl8180_len2duration(len, rate, &ext);
 			*(tail+1) = *(tail+1) | ((duration & 0x7fff)<<16);
 			if (ext)
-				*(tail+1) = *(tail+1) | (1<<31); /* plcp length extension */
+				*(tail+1) = *(tail+1) | (1<<31); /* plcp length
+								  * extension
+								  */
 		}
 
 		if (morefrag)
@@ -2147,7 +2258,8 @@ short rtl8180_tx(struct net_device *dev, u8* txbuf, int len, int priority,
 
 		wmb();
 		if (ownbit_flag)
-			*tail = *tail | (1<<31); /* descriptor ready to be txed */
+			*tail = *tail | (1<<31); /* descriptor ready
+						  * to be txed */
 
 		if ((tail - begin)/8 == count-1)
 			tail = begin;
@@ -2184,7 +2296,7 @@ short rtl8180_tx(struct net_device *dev, u8* txbuf, int len, int priority,
 			priv->txhpbufstail = buflist;
 			break;
 		case BEACON_PRIORITY:
-			/* 
+			/*
 			 * The HW seems to be happy with the 1st
 			 * descriptor filled and the 2nd empty...
 			 * So always update descriptor 1 and never
@@ -2229,7 +2341,8 @@ void rtl8180_rq_tx_ack(struct net_device *dev)
 
 	struct r8180_priv *priv = ieee80211_priv(dev);
 
-	write_nic_byte(dev, CONFIG4, read_nic_byte(dev, CONFIG4) | CONFIG4_PWRMGT);
+	write_nic_byte(dev, CONFIG4, read_nic_byte(dev,
+						CONFIG4) | CONFIG4_PWRMGT);
 	priv->ack_tx_to_ieee = 1;
 }
 
@@ -2279,7 +2392,8 @@ void rtl8180_hw_wakeup(struct net_device *dev)
 	struct r8180_priv *priv = ieee80211_priv(dev);
 
 	spin_lock_irqsave(&priv->ps_lock, flags);
-	write_nic_byte(dev, CONFIG4, read_nic_byte(dev, CONFIG4) & ~CONFIG4_PWRMGT);
+	write_nic_byte(dev, CONFIG4,
+			read_nic_byte(dev, CONFIG4) & ~CONFIG4_PWRMGT);
 	if (priv->rf_wakeup)
 		priv->rf_wakeup(dev);
 	spin_unlock_irqrestore(&priv->ps_lock, flags);
@@ -2304,13 +2418,13 @@ void rtl8180_hw_sleep(struct net_device *dev, u32 th, u32 tl)
 
 	spin_lock_irqsave(&priv->ps_lock, flags);
 
-	/* 
+	/*
 	 * Writing HW register with 0 equals to disable
 	 * the timer, that is not really what we want
 	 */
 	tl -= MSECS(4+16+7);
 
-	/* 
+	/*
 	 * If the interval in witch we are requested to sleep is too
 	 * short then give up and remain awake
 	 */
@@ -2326,9 +2440,11 @@ void rtl8180_hw_sleep(struct net_device *dev, u32 th, u32 tl)
 
 		priv->DozePeriodInPast2Sec += jiffies_to_msecs(tmp);
 
-		queue_delayed_work(priv->ieee80211->wq, &priv->ieee80211->hw_wakeup_wq, tmp); /* as tl may be less than rb */
+		queue_delayed_work(priv->ieee80211->wq,
+			&priv->ieee80211->hw_wakeup_wq, tmp);
+			/* as tl may be less than rb */
 	}
-	/* 
+	/*
 	 * If we suspect the TimerInt is gone beyond tl
 	 * while setting it, then give up
 	 */
@@ -2345,7 +2461,9 @@ void rtl8180_hw_sleep(struct net_device *dev, u32 th, u32 tl)
 
 void rtl8180_wmm_param_update(struct work_struct *work)
 {
-	struct ieee80211_device *ieee = container_of(work, struct ieee80211_device, wmm_param_update_wq);
+	struct ieee80211_device *ieee = container_of(work,
+						struct ieee80211_device,
+						wmm_param_update_wq);
 	struct net_device *dev = ieee->dev;
 	u8 *ac_param = (u8 *)(ieee->current_network.wmm_param);
 	u8 mode = ieee->current_network.mode;
@@ -2369,26 +2487,41 @@ void rtl8180_wmm_param_update(struct work_struct *work)
 				u32		u4bAcParam;
 				pAcParam = (PAC_PARAM)(&AcParam);
 				/* Retrive paramters to udpate. */
-				u1bAIFS = pAcParam->f.AciAifsn.f.AIFSN * (((mode&IEEE_G) == IEEE_G) ? 9 : 20) + aSifsTime;
-				u4bAcParam = ((((u32)(pAcParam->f.TXOPLimit))<<AC_PARAM_TXOP_LIMIT_OFFSET)|
-					      (((u32)(pAcParam->f.Ecw.f.ECWmax))<<AC_PARAM_ECW_MAX_OFFSET)|
-					      (((u32)(pAcParam->f.Ecw.f.ECWmin))<<AC_PARAM_ECW_MIN_OFFSET)|
-					       (((u32)u1bAIFS) << AC_PARAM_AIFS_OFFSET));
+				u1bAIFS = pAcParam->f.AciAifsn.f.AIFSN *
+					(((mode&IEEE_G) == IEEE_G) ? 9 : 20) +
+					aSifsTime;
+				u4bAcParam = ((((u32)(pAcParam->f.TXOPLimit))<<
+					AC_PARAM_TXOP_LIMIT_OFFSET)|
+					(((u32)(pAcParam->f.Ecw.f.ECWmax))<<
+					AC_PARAM_ECW_MAX_OFFSET)|
+					(((u32)(pAcParam->f.Ecw.f.ECWmin))<<
+					AC_PARAM_ECW_MIN_OFFSET)|
+					(((u32)u1bAIFS) <<
+					AC_PARAM_AIFS_OFFSET));
 				switch (eACI) {
 				case AC1_BK:
-					write_nic_dword(dev, AC_BK_PARAM, u4bAcParam);
+					write_nic_dword(dev,
+							AC_BK_PARAM,
+							u4bAcParam);
 					break;
 				case AC0_BE:
-					write_nic_dword(dev, AC_BE_PARAM, u4bAcParam);
+					write_nic_dword(dev,
+							AC_BE_PARAM,
+							u4bAcParam);
 					break;
 				case AC2_VI:
-					write_nic_dword(dev, AC_VI_PARAM, u4bAcParam);
+					write_nic_dword(dev,
+							AC_VI_PARAM,
+							u4bAcParam);
 					break;
 				case AC3_VO:
-					write_nic_dword(dev, AC_VO_PARAM, u4bAcParam);
+					write_nic_dword(dev,
+							AC_VO_PARAM,
+							u4bAcParam);
 					break;
 				default:
-					printk(KERN_WARNING "SetHwReg8185():invalid ACI: %d!\n", eACI);
+					printk(KERN_WARNING "SetHwReg8185()"
+						":invalid ACI: %d!\n", eACI);
 					break;
 				}
 			}
@@ -2407,11 +2540,17 @@ void rtl8180_wmm_param_update(struct work_struct *work)
 			/* Retrive paramters to udpate. */
 			eACI = pAcParam->f.AciAifsn.f.ACI;
 			/* Mode G/A: slotTimeTimer = 9; Mode B: 20 */
-			u1bAIFS = pAcParam->f.AciAifsn.f.AIFSN * (((mode&IEEE_G) == IEEE_G) ? 9 : 20) + aSifsTime;
-			u4bAcParam = ((((u32)(pAcParam->f.TXOPLimit)) << AC_PARAM_TXOP_LIMIT_OFFSET)	|
-					(((u32)(pAcParam->f.Ecw.f.ECWmax)) << AC_PARAM_ECW_MAX_OFFSET)	|
-					(((u32)(pAcParam->f.Ecw.f.ECWmin)) << AC_PARAM_ECW_MIN_OFFSET)	|
-					(((u32)u1bAIFS) << AC_PARAM_AIFS_OFFSET));
+			u1bAIFS = pAcParam->f.AciAifsn.f.AIFSN *
+					(((mode&IEEE_G) == IEEE_G) ? 9 : 20) +
+					aSifsTime;
+			u4bAcParam = ((((u32)(pAcParam->f.TXOPLimit)) <<
+					AC_PARAM_TXOP_LIMIT_OFFSET)	|
+					(((u32)(pAcParam->f.Ecw.f.ECWmax)) <<
+					AC_PARAM_ECW_MAX_OFFSET)	|
+					(((u32)(pAcParam->f.Ecw.f.ECWmin)) <<
+					AC_PARAM_ECW_MIN_OFFSET)	|
+					(((u32)u1bAIFS) <<
+					AC_PARAM_AIFS_OFFSET));
 
 			switch (eACI) {
 			case AC1_BK:
@@ -2427,7 +2566,8 @@ void rtl8180_wmm_param_update(struct work_struct *work)
 				write_nic_dword(dev, AC_VO_PARAM, u4bAcParam);
 				break;
 			default:
-				printk(KERN_WARNING "SetHwReg8185(): invalid ACI: %d !\n", eACI);
+				printk(KERN_WARNING "SetHwReg8185(): "
+					"invalid ACI: %d !\n", eACI);
 				break;
 			}
 		}
@@ -2455,7 +2595,8 @@ void watch_dog_adaptive(unsigned long data)
 
 	/* Tx High Power Mechanism. */
 	if (CheckHighPower((struct net_device *)data))
-		queue_work(priv->ieee80211->wq, (void *)&priv->ieee80211->tx_pw_wq);
+		queue_work(priv->ieee80211->wq,
+			(void *)&priv->ieee80211->tx_pw_wq);
 
 	/* Tx Power Tracking on 87SE. */
 	if (CheckTxPwrTracking((struct net_device *)data))
@@ -2463,30 +2604,45 @@ void watch_dog_adaptive(unsigned long data)
 
 	/* Perform DIG immediately. */
 	if (CheckDig((struct net_device *)data) == true)
-		queue_work(priv->ieee80211->wq, (void *)&priv->ieee80211->hw_dig_wq);
+		queue_work(priv->ieee80211->wq,
+			(void *)&priv->ieee80211->hw_dig_wq);
 	rtl8180_watch_dog((struct net_device *)data);
 
-	queue_work(priv->ieee80211->wq, (void *)&priv->ieee80211->GPIOChangeRFWorkItem);
+	queue_work(priv->ieee80211->wq,
+			(void *)&priv->ieee80211->GPIOChangeRFWorkItem);
 
-	priv->watch_dog_timer.expires = jiffies + MSECS(IEEE80211_WATCH_DOG_TIME);
+	priv->watch_dog_timer.expires = jiffies +
+					MSECS(IEEE80211_WATCH_DOG_TIME);
 	add_timer(&priv->watch_dog_timer);
 }
 
 static CHANNEL_LIST ChannelPlan[] = {
-	{{1,2,3,4,5,6,7,8,9,10,11,36,40,44,48,52,56,60,64},19},		/* FCC */
-	{{1,2,3,4,5,6,7,8,9,10,11},11},					/* IC */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,36,40,44,48,52,56,60,64},21},	/* ETSI */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,36,40,44,48,52,56,60,64},21},	/* Spain. Change to ETSI. */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,36,40,44,48,52,56,60,64},21},	/* France. Change to ETSI. */
-	{{14,36,40,44,48,52,56,60,64},9},				/* MKK */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,14, 36,40,44,48,52,56,60,64},22},/* MKK1 */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,36,40,44,48,52,56,60,64},21},	/* Israel. */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,34,38,42,46},17},		/* For 11a , TELEC */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,14},14},  /* For Global Domain. 1-11:active scan, 12-14 passive scan. //+YJ, 080626 */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13},13} /* world wide 13: ch1~ch11 active scan, ch12~13 passive //lzm add 080826 */
+	{{1,2,3,4,5,6,7,8,9,10,11,
+	36,40,44,48,52,56,60,64},19},		/* FCC */
+	{{1,2,3,4,5,6,7,8,9,10,11},11},		/* IC */
+	{{1,2,3,4,5,6,7,8,9,10,11,
+	12,13,36,40,44,48,52,56,60,64},21},	/* ETSI */
+	{{1,2,3,4,5,6,7,8,9,10,11,
+	12,13,36,40,44,48,52,56,60,64},21},	/* Spain. Change to ETSI. */
+	{{1,2,3,4,5,6,7,8,9,10,11,
+	12,13,36,40,44,48,52,56,60,64},21},	/* France. Change to ETSI. */
+	{{14,36,40,44,48,52,56,60,64},9},	/* MKK */
+	{{1,2,3,4,5,6,7,8,9,10,11,
+	12,13,14, 36,40,44,48,52,56,60,64},22}, /* MKK1 */
+	{{1,2,3,4,5,6,7,8,9,10,11,
+	12,13,36,40,44,48,52,56,60,64},21},	/* Israel. */
+	{{1,2,3,4,5,6,7,8,9,10,11,
+	12,13,34,38,42,46},17},			/* For 11a , TELEC */
+	{{1,2,3,4,5,6,7,8,9,10,11,
+	12,13,14},14},  /* For Global Domain. 1-11:active scan,
+			 * 12-14 passive scan. //+YJ, 080626 */
+	{{1,2,3,4,5,6,7,8,9,10,11,12,13},13} /* world wide 13: ch1~ch11 active
+					      * scan, ch12~13 passive //lzm
+					      * add 080826 */
 };
 
-static void rtl8180_set_channel_map(u8 channel_plan, struct ieee80211_device *ieee)
+static void rtl8180_set_channel_map(u8 channel_plan,
+				    struct ieee80211_device *ieee)
 {
 	int i;
 
@@ -2509,11 +2665,21 @@ static void rtl8180_set_channel_map(u8 channel_plan, struct ieee80211_device *ie
 			ieee->bGlobalDomain = false;
 			if (ChannelPlan[channel_plan].Len != 0) {
 				/* Clear old channel map */
-				memset(GET_DOT11D_INFO(ieee)->channel_map, 0, sizeof(GET_DOT11D_INFO(ieee)->channel_map));
+				memset(GET_DOT11D_INFO(ieee)->channel_map,
+					0,
+					sizeof(GET_DOT11D_INFO(
+						ieee)->channel_map));
 				/* Set new channel map */
-				for (i = 0; i < ChannelPlan[channel_plan].Len; i++) {
-					if (ChannelPlan[channel_plan].Channel[i] <= 14)
-						GET_DOT11D_INFO(ieee)->channel_map[ChannelPlan[channel_plan].Channel[i]] = 1;
+				for (i = 0; i < ChannelPlan[channel_plan].Len;
+						i++) {
+					if (ChannelPlan[channel_plan
+							].Channel[i]
+							<= 14)
+						GET_DOT11D_INFO(
+							ieee)->channel_map[
+							ChannelPlan[
+							channel_plan].Channel[
+							i]] = 1;
 				}
 			}
 			break;
@@ -2535,7 +2701,8 @@ static void rtl8180_set_channel_map(u8 channel_plan, struct ieee80211_device *ie
 		{
 			Dot11d_Init(ieee);
 			ieee->bGlobalDomain = false;
-			memset(GET_DOT11D_INFO(ieee)->channel_map, 0, sizeof(GET_DOT11D_INFO(ieee)->channel_map));
+			memset(GET_DOT11D_INFO(ieee)->channel_map, 0,
+				sizeof(GET_DOT11D_INFO(ieee)->channel_map));
 			for (i = 1; i <= 14; i++)
 				GET_DOT11D_INFO(ieee)->channel_map[i] = 1;
 			break;
@@ -2633,7 +2800,8 @@ short rtl8180_init(struct net_device *dev)
 	rtl8180_link_detect_init(&priv->link_detect);
 
 	priv->ack_tx_to_ieee = 0;
-	priv->ieee80211->current_network.beacon_interval = DEFAULT_BEACONINTERVAL;
+	priv->ieee80211->current_network.beacon_interval =
+				DEFAULT_BEACONINTERVAL;
 	priv->ieee80211->iw_mode = IW_MODE_INFRA;
 	priv->ieee80211->softmac_features  = IEEE_SOFTMAC_SCAN |
 		IEEE_SOFTMAC_ASSOCIATE | IEEE_SOFTMAC_PROBERQ |
@@ -2681,7 +2849,8 @@ short rtl8180_init(struct net_device *dev)
 	priv->AdRxSsBeforeSwitched = 0;
 	init_timer(&priv->SwAntennaDiversityTimer);
 	priv->SwAntennaDiversityTimer.data = (unsigned long)dev;
-	priv->SwAntennaDiversityTimer.function = (void *)SwAntennaDiversityTimerCallback;
+	priv->SwAntennaDiversityTimer.function =
+		(void *)SwAntennaDiversityTimerCallback;
 	priv->bDigMechanism = 1;
 	priv->InitialGain = 6;
 	priv->bXtalCalibration = false;
@@ -2690,7 +2859,8 @@ short rtl8180_init(struct net_device *dev)
 	priv->bTxPowerTrack = false;
 	priv->ThermalMeter = 0;
 	priv->FalseAlarmRegValue = 0;
-	priv->RegDigOfdmFaUpTh = 0xc; /* Upper threhold of OFDM false alarm, which is used in DIG. */
+	priv->RegDigOfdmFaUpTh = 0xc; /* Upper threhold of OFDM false alarm,
+				       * which is used in DIG. */
 	priv->DIG_NumberFallbackVote = 0;
 	priv->DIG_NumberUpgradeVote = 0;
 	priv->LastSignalStrengthInPercent = 0;
@@ -2853,14 +3023,16 @@ short rtl8180_init(struct net_device *dev)
 		priv->bSwAntennaDiverity = priv->EEPROMSwAntennaDiversity;
 	else
 		/* 1:disable antenna diversity, 2: enable antenna diversity. */
-		priv->bSwAntennaDiverity = ((priv->RegSwAntennaDiversityMechanism == 1) ? false : true);
+		priv->bSwAntennaDiverity =
+		((priv->RegSwAntennaDiversityMechanism == 1) ? false : true);
 
 	if (priv->RegDefaultAntenna == 0)
 		/* 0: default from EEPROM. */
 		priv->bDefaultAntenna1 = priv->EEPROMDefaultAntenna1;
 	else
 		/* 1: main, 2: aux. */
-		priv->bDefaultAntenna1 = ((priv->RegDefaultAntenna == 2) ? true : false);
+		priv->bDefaultAntenna1 = ((priv->RegDefaultAntenna == 2) ?
+						true : false);
 
 	/* rtl8185 can calc plcp len in HW. */
 	priv->hw_plcp_len = 1;
@@ -2921,7 +3093,8 @@ short rtl8180_init(struct net_device *dev)
 	priv->rf_set_chan = rtl8225z2_rf_set_chan;
 	priv->rf_set_sens = NULL;
 
-	if (0 != alloc_rx_desc_ring(dev, priv->rxbuffersize, priv->rxringcount))
+	if (0 != alloc_rx_desc_ring(dev, priv->rxbuffersize,
+			priv->rxringcount))
 		return -ENOMEM;
 
 	if (0 != alloc_tx_desc_ring(dev, priv->txbuffsize, priv->txringcount,
@@ -2952,7 +3125,8 @@ short rtl8180_init(struct net_device *dev)
 				  TX_BEACON_RING_ADDR))
 		return -ENOMEM;
 
-	if (request_irq(dev->irq, (void *)rtl8180_interrupt, IRQF_SHARED, dev->name, dev)) {
+	if (request_irq(dev->irq, (void *)rtl8180_interrupt,
+			IRQF_SHARED, dev->name, dev)) {
 		DMESGE("Error allocating IRQ %d", dev->irq);
 		return -1;
 	} else {
@@ -3051,16 +3225,20 @@ void rtl8185_write_phy(struct net_device *dev, u8 adr, u32 data)
 
 	phyw = ((data<<8) | adr);
 
-	/* Note that, we must write 0xff7c after 0x7d-0x7f to write BB register. */
+	/* Note that, we must write 0xff7c after
+	 * 0x7d-0x7f to write BB register. */
 	write_nic_byte(dev, 0x7f, ((phyw & 0xff000000) >> 24));
 	write_nic_byte(dev, 0x7e, ((phyw & 0x00ff0000) >> 16));
 	write_nic_byte(dev, 0x7d, ((phyw & 0x0000ff00) >> 8));
 	write_nic_byte(dev, 0x7c, ((phyw & 0x000000ff)));
 
-	/* this is ok to fail when we write AGC table. check for AGC table might be
+	/* this is ok to fail when we write AGC table.
+	 * check for AGC table might be
 	 * done by masking with 0x7f instead of 0xff
 	 */
-	/* if (phyr != (data&0xff)) DMESGW("Phy write timeout %x %x %x", phyr, data, adr); */
+	/* if (phyr != (data&0xff)) DMESGW("Phy write
+	 * timeout %x %x %x", phyr, data, adr);
+	 */
 }
 
 inline void write_phy_ofdm(struct net_device *dev, u8 adr, u32 data)
@@ -3086,7 +3264,8 @@ void rtl8185_set_rate(struct net_device *dev)
 	max_rr_rate = ieeerate2rtlrate(240);
 
 	write_nic_byte(dev, RESP_RATE,
-			max_rr_rate<<MAX_RESP_RATE_SHIFT | min_rr_rate<<MIN_RESP_RATE_SHIFT);
+			max_rr_rate<<MAX_RESP_RATE_SHIFT |
+			min_rr_rate<<MIN_RESP_RATE_SHIFT);
 
 	word  = read_nic_word(dev, BRSR);
 	word &= ~BRSR_MBR_8185;
@@ -3151,7 +3330,8 @@ void rtl8180_adapter_start(struct net_device *dev)
 	rtl8185_set_rate(dev);
 	write_nic_byte(dev, RATE_FALLBACK, 0x81);
 
-	write_nic_byte(dev, GP_ENABLE, read_nic_byte(dev, GP_ENABLE) & ~(1<<6));
+	write_nic_byte(dev, GP_ENABLE, read_nic_byte(dev,
+						     GP_ENABLE) & ~(1<<6));
 
 	/* FIXME cfg 3 ClkRun enable - isn't it ReadOnly ? */
 	rtl8180_set_mode(dev, EPROM_CMD_CONFIG);
@@ -3168,7 +3348,7 @@ void rtl8180_adapter_start(struct net_device *dev)
 	netif_start_queue(dev);
 }
 
-/* 
+/*
  * This configures registers for beacon tx and enables it via
  * rtl8180_beacon_tx_enable(). rtl8180_beacon_tx_disable() might
  * be used to stop beacon transmission
@@ -3227,7 +3407,9 @@ void LeisurePSEnter(struct r8180_priv *priv)
 {
 	if (priv->bLeisurePs) {
 		if (priv->ieee80211->ps == IEEE80211_PS_DISABLED)
-			MgntActSet_802_11_PowerSaveMode(priv, IEEE80211_PS_MBCAST|IEEE80211_PS_UNICAST); /* IEEE80211_PS_ENABLE */
+			MgntActSet_802_11_PowerSaveMode(priv,
+				IEEE80211_PS_MBCAST|IEEE80211_PS_UNICAST);
+				/* IEEE80211_PS_ENABLE */
 	}
 }
 
@@ -3235,14 +3417,17 @@ void LeisurePSLeave(struct r8180_priv *priv)
 {
 	if (priv->bLeisurePs) {
 		if (priv->ieee80211->ps != IEEE80211_PS_DISABLED)
-			MgntActSet_802_11_PowerSaveMode(priv, IEEE80211_PS_DISABLED);
+			MgntActSet_802_11_PowerSaveMode(priv,
+							IEEE80211_PS_DISABLED);
 	}
 }
 
 void rtl8180_hw_wakeup_wq(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
-	struct ieee80211_device *ieee = container_of(dwork, struct ieee80211_device, hw_wakeup_wq);
+	struct ieee80211_device *ieee = container_of(dwork,
+						struct ieee80211_device,
+						hw_wakeup_wq);
 	struct net_device *dev = ieee->dev;
 
 	rtl8180_hw_wakeup(dev);
@@ -3251,7 +3436,9 @@ void rtl8180_hw_wakeup_wq(struct work_struct *work)
 void rtl8180_hw_sleep_wq(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
-	struct ieee80211_device *ieee = container_of(dwork, struct ieee80211_device, hw_sleep_wq);
+	struct ieee80211_device *ieee = container_of(dwork,
+						struct ieee80211_device,
+						hw_sleep_wq);
 	struct net_device *dev = ieee->dev;
 
 	rtl8180_hw_sleep_down(dev);
@@ -3268,23 +3455,31 @@ static void MgntLinkKeepAlive(struct r8180_priv *priv)
 		 */
 
 		if ((priv->keepAliveLevel == 2) ||
-			(priv->link_detect.LastNumTxUnicast == priv->NumTxUnicast &&
-			priv->link_detect.LastNumRxUnicast == priv->ieee80211->NumRxUnicast)
+			(priv->link_detect.LastNumTxUnicast ==
+				priv->NumTxUnicast &&
+				priv->link_detect.LastNumRxUnicast ==
+				priv->ieee80211->NumRxUnicast)
 			) {
 			priv->link_detect.IdleCount++;
 
 			/*
-			 * Send a Keep-Alive packet packet to AP if we had been idle for a while.
+			 * Send a Keep-Alive packet packet to AP
+			 * if we had been idle for a while.
 			 */
-			if (priv->link_detect.IdleCount >= ((KEEP_ALIVE_INTERVAL / CHECK_FOR_HANG_PERIOD)-1)) {
+			if (priv->link_detect.IdleCount >=
+					((KEEP_ALIVE_INTERVAL /
+					CHECK_FOR_HANG_PERIOD)-
+					1)) {
 				priv->link_detect.IdleCount = 0;
-				ieee80211_sta_ps_send_null_frame(priv->ieee80211, false);
+				ieee80211_sta_ps_send_null_frame(
+					priv->ieee80211, false);
 			}
 		} else {
 			priv->link_detect.IdleCount = 0;
 		}
 		priv->link_detect.LastNumTxUnicast = priv->NumTxUnicast;
-		priv->link_detect.LastNumRxUnicast = priv->ieee80211->NumRxUnicast;
+		priv->link_detect.LastNumRxUnicast =
+			priv->ieee80211->NumRxUnicast;
 	}
 }
 
@@ -3299,19 +3494,27 @@ void rtl8180_watch_dog(struct net_device *dev)
 	u16 SlotIndex = 0;
 	u16 i = 0;
 	if (priv->ieee80211->actscanning == false) {
-		if ((priv->ieee80211->iw_mode != IW_MODE_ADHOC) && (priv->ieee80211->state == IEEE80211_NOLINK) && (priv->ieee80211->beinretry == false) && (priv->eRFPowerState == eRfOn))
+		if ((priv->ieee80211->iw_mode !=
+			IW_MODE_ADHOC) && (priv->ieee80211->state ==
+			IEEE80211_NOLINK) && (priv->ieee80211->beinretry ==
+			false) && (priv->eRFPowerState == eRfOn))
 			IPSEnter(dev);
 	}
 	/* YJ,add,080828,for link state check */
-	if ((priv->ieee80211->state == IEEE80211_LINKED) && (priv->ieee80211->iw_mode == IW_MODE_INFRA)) {
-		SlotIndex = (priv->link_detect.SlotIndex++) % priv->link_detect.SlotNum;
-		priv->link_detect.RxFrameNum[SlotIndex] = priv->ieee80211->NumRxDataInPeriod + priv->ieee80211->NumRxBcnInPeriod;
+	if ((priv->ieee80211->state == IEEE80211_LINKED) &&
+			(priv->ieee80211->iw_mode == IW_MODE_INFRA)) {
+		SlotIndex = (priv->link_detect.SlotIndex++) %
+			priv->link_detect.SlotNum;
+		priv->link_detect.RxFrameNum[SlotIndex] =
+			priv->ieee80211->NumRxDataInPeriod +
+			priv->ieee80211->NumRxBcnInPeriod;
 		for (i = 0; i < priv->link_detect.SlotNum; i++)
 			TotalRxNum += priv->link_detect.RxFrameNum[i];
 
 		if (TotalRxNum == 0) {
 			priv->ieee80211->state = IEEE80211_ASSOCIATING;
-			queue_work(priv->ieee80211->wq, &priv->ieee80211->associate_procedure_wq);
+			queue_work(priv->ieee80211->wq,
+				&priv->ieee80211->associate_procedure_wq);
 		}
 	}
 
@@ -3327,12 +3530,14 @@ void rtl8180_watch_dog(struct net_device *dev)
 	}
 
 	if (priv->ieee80211->state == IEEE80211_LINKED) {
-		priv->link_detect.NumRxOkInPeriod = priv->ieee80211->NumRxDataInPeriod;
+		priv->link_detect.NumRxOkInPeriod =
+			priv->ieee80211->NumRxDataInPeriod;
 		if (priv->link_detect.NumRxOkInPeriod > 666 ||
 			priv->link_detect.NumTxOkInPeriod > 666) {
 			bBusyTraffic = true;
 		}
-		if (((priv->link_detect.NumRxOkInPeriod + priv->link_detect.NumTxOkInPeriod) > 8)
+		if (((priv->link_detect.NumRxOkInPeriod +
+			priv->link_detect.NumTxOkInPeriod) > 8)
 			|| (priv->link_detect.NumRxOkInPeriod > 2)) {
 			bEnterPS = false;
 		} else
@@ -3430,14 +3635,16 @@ int rtl8180_down(struct net_device *dev)
 	cancel_delayed_work(&priv->ieee80211->tx_pw_wq);
 	del_timer_sync(&priv->SwAntennaDiversityTimer);
 	SetZebraRFPowerState8185(dev, eRfOff);
-	memset(&(priv->ieee80211->current_network), 0, sizeof(struct ieee80211_network));
+	memset(&(priv->ieee80211->current_network), 0,
+		sizeof(struct ieee80211_network));
 	priv->ieee80211->state = IEEE80211_NOLINK;
 	return 0;
 }
 
 void rtl8180_restart_wq(struct work_struct *work)
 {
-	struct r8180_priv *priv = container_of(work, struct r8180_priv, reset_wq);
+	struct r8180_priv *priv = container_of(work, struct r8180_priv,
+						reset_wq);
 	struct net_device *dev = priv->dev;
 
 	down(&priv->wx_sem);
@@ -3498,7 +3705,8 @@ int r8180_set_mac_adr(struct net_device *dev, void *mac)
 	memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
 
 	if (priv->ieee80211->iw_mode == IW_MODE_MASTER)
-		memcpy(priv->ieee80211->current_network.bssid, dev->dev_addr, ETH_ALEN);
+		memcpy(priv->ieee80211->current_network.bssid, dev->dev_addr,
+			ETH_ALEN);
 
 	if (priv->up) {
 		rtl8180_down(dev);
@@ -3519,7 +3727,8 @@ int rtl8180_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 
 	switch (cmd) {
 	case RTL_IOCTL_WPA_SUPPLICANT:
-		ret = ieee80211_wpa_supplicant_ioctl(priv->ieee80211, &wrq->u.data);
+		ret = ieee80211_wpa_supplicant_ioctl(priv->ieee80211,
+						     &wrq->u.data);
 		return ret;
 	default:
 		return -EOPNOTSUPP;
@@ -3712,21 +3921,25 @@ static int __init rtl8180_pci_module_init(void)
 	}
 	ret = ieee80211_crypto_tkip_init();
 	if (ret) {
-		printk(KERN_ERR "ieee80211_crypto_tkip_init() failed %d\n", ret);
+		printk(KERN_ERR "ieee80211_crypto_tkip_init() failed %d\n",
+			ret);
 		return ret;
 	}
 	ret = ieee80211_crypto_ccmp_init();
 	if (ret) {
-		printk(KERN_ERR "ieee80211_crypto_ccmp_init() failed %d\n", ret);
+		printk(KERN_ERR "ieee80211_crypto_ccmp_init() failed %d\n",
+			ret);
 		return ret;
 	}
 	ret = ieee80211_crypto_wep_init();
 	if (ret) {
-		printk(KERN_ERR "ieee80211_crypto_wep_init() failed %d\n", ret);
+		printk(KERN_ERR "ieee80211_crypto_wep_init() failed %d\n",
+			ret);
 		return ret;
 	}
 
-	printk(KERN_INFO "\nLinux kernel driver for RTL8180 / RTL8185 based WLAN cards\n");
+	printk(KERN_INFO "\nLinux kernel driver for RTL8180 / "
+		"RTL8185 based WLAN cards\n");
 	printk(KERN_INFO "Copyright (c) 2004-2005, Andrea Merello\n");
 	DMESG("Initializing module");
 	DMESG("Wireless extensions version %d", WIRELESS_EXT);
@@ -3839,7 +4052,7 @@ void rtl8180_tx_isr(struct net_device *dev, int pri, short error)
 			return;
 		}
 
-	/* 
+	/*
 	 * We check all the descriptors between the head and the nic,
 	 * but not the currently pointed by the nic (the next to be txed)
 	 * and the previous of the pointed (might be in process ??)
@@ -3877,7 +4090,7 @@ void rtl8180_tx_isr(struct net_device *dev, int pri, short error)
 			head += 8;
 	}
 
-	/* 
+	/*
 	 * The head has been moved to the last certainly TXed
 	 * (or at least processed by the nic) packet.
 	 * The driver take forcefully owning of all these packets
@@ -4088,7 +4301,8 @@ void rtl8180_irq_rx_tasklet(struct r8180_priv *priv)
 
 void GPIOChangeRFWorkItemCallBack(struct work_struct *work)
 {
-	struct ieee80211_device *ieee = container_of(work, struct ieee80211_device, GPIOChangeRFWorkItem.work);
+	struct ieee80211_device *ieee = container_of(work,
+		struct ieee80211_device, GPIOChangeRFWorkItem.work);
 	struct net_device *dev = ieee->dev;
 	struct r8180_priv *priv = ieee80211_priv(dev);
 	u8 btPSR;
@@ -4098,11 +4312,13 @@ void GPIOChangeRFWorkItemCallBack(struct work_struct *work)
 
 	char *argv[3];
 	static char *RadioPowerPath = "/etc/acpi/events/RadioPower.sh";
-	static char *envp[] = {"HOME=/", "TERM=linux", "PATH=/usr/bin:/bin", NULL};
+	static char *envp[] = {"HOME=/", "TERM=linux", "PATH=/usr/bin:/bin",
+				NULL};
 	static int readf_count = 0;
 
 	if (readf_count % 10 == 0)
-		priv->PowerProfile = read_acadapter_file("/proc/acpi/ac_adapter/AC0/state");
+		priv->PowerProfile = read_acadapter_file(
+					"/proc/acpi/ac_adapter/AC0/state");
 
 	readf_count = (readf_count+1)%0xffff;
 	/* We should turn off LED before polling FF51[4]. */
-- 
1.7.7.6

