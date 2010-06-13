Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab0FMH0L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 03:26:11 -0400
Received: from outbound-mail01.westnet.com.au ([203.10.1.242]:60140 "EHLO
	outbound-mail01.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752548Ab0FMHZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 03:25:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsBBAMYUFEw6B0zXPGdsb2JhbACHbpcRDAEBAQE1LbBrjE6FGgSDSw
X-IronPort-AV: E=Sophos;i="4.53,410,1272816000"; 
   d="scan'208";a="84157948"
From: Mike Gilks <mike.kernel@gilksonline.com>
To: gregkh@suse.de, mchehab@redhat.com, julia@diku.dk, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Gilks <mike.kernel@gilksonline.com>
Subject: [PATCH 4/4] staging: rtl8192u: fix checkpatch.pl issues to end Fix most problems pointed out by checkpatch.pl in file r8192U_core.c to end of file. There are 2 errors and 93 warnings remaining, but they will need fixing by someone smarter than me.
Date: Sun, 13 Jun 2010 14:16:51 +0800
Message-Id: <1276409811-16682-5-git-send-email-mike.kernel@gilksonline.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1276409811-16682-4-git-send-email-mike.kernel@gilksonline.com>
References: <1276409811-16682-1-git-send-email-mike.kernel@gilksonline.com>
 <1276409811-16682-2-git-send-email-mike.kernel@gilksonline.com>
 <1276409811-16682-3-git-send-email-mike.kernel@gilksonline.com>
 <1276409811-16682-4-git-send-email-mike.kernel@gilksonline.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Gilks <mike.kernel@gilksonline.com>
---
 drivers/staging/rtl8192u/r8192U_core.c |  400 +++++++++++++++++++-------------
 1 files changed, 237 insertions(+), 163 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 8dcf542..7c66c63 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -5509,9 +5509,9 @@ void TranslateRxSignalStuff819xUsb(struct sk_buff *skb,
 	bpacket_toself =  bpacket_match_bssid & (eqMacAddr(praddr,
 					priv->ieee80211->dev->dev_addr));
 
-		if (WLAN_FC_GET_FRAMETYPE(fc)== IEEE80211_STYPE_BEACON)
+		if (WLAN_FC_GET_FRAMETYPE(fc) == IEEE80211_STYPE_BEACON)
 			bPacketBeacon = true;
-			/* DbgPrint("Beacon 2, MatchBSSID = %d, ToSelf = %d \n"
+			/* DbgPrint("Beacon 2, MatchBSSID = %d, ToSelf = %d\n"
 			 *		, bPacketMatchBSSID, bPacketToSelf);
 			 */
 		if (WLAN_FC_GET_FRAMETYPE(fc) == IEEE80211_STYPE_BLOCKACK) {
@@ -5523,18 +5523,19 @@ void TranslateRxSignalStuff819xUsb(struct sk_buff *skb,
 				 */
 		}
 
-	if(bpacket_match_bssid)
+	if (bpacket_match_bssid)
 		priv->stats.numpacket_matchbssid++;
-	if(bpacket_toself){
+	if (bpacket_toself)
 		priv->stats.numpacket_toself++;
-	}
+
 
 	/* Process PHY information for previous packet (RSSI/PWDB/EVM)
 	 * Because phy information is contained in the last packet of AMPDU
 	 * only, so driver should process phy information of previous packet
 	 */
 	rtl8192_process_phyinfo(priv, tmp_buf, &previous_stats, pstats);
-	rtl8192_query_rxphystatus(priv, pstats, pdrvinfo, &previous_stats, bpacket_match_bssid,bpacket_toself,bPacketBeacon,bToSelfBA);
+	rtl8192_query_rxphystatus(priv, pstats, pdrvinfo, &previous_stats,
+		bpacket_match_bssid, bpacket_toself, bPacketBeacon, bToSelfBA);
 	rtl8192_record_rxdesc_forlateruse(pstats, &previous_stats);
 
 }
@@ -5544,7 +5545,7 @@ void TranslateRxSignalStuff819xUsb(struct sk_buff *skb,
 * Overview:	Recored down the received data rate
 *
 * Input:
-* 	struct net_device *dev
+*	struct net_device *dev
 *	struct ieee80211_rx_stats *stats
 *
 * Output:
@@ -5560,67 +5561,124 @@ UpdateReceivedRateHistogramStatistics8190(
 	)
 {
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
-	u32 rcvType=1;   /* 0: Total, 1:OK, 2:CRC, 3:ICV */
+	u32 rcvType = 1;   /* 0: Total, 1:OK, 2:CRC, 3:ICV */
 	u32 rateIndex;
 	u32 preamble_guardinterval;
 	/* 1: short preamble/GI, 0: long preamble/GI */
 
 
-	if(stats->bCRC)
-	rcvType = 2;
-	else if(stats->bICV)
-	rcvType = 3;
+	if (stats->bCRC)
+		rcvType = 2;
+	else if (stats->bICV)
+		rcvType = 3;
 
-	if(stats->bShortPreamble)
-	preamble_guardinterval = 1;		/* short */
+	if (stats->bShortPreamble)
+		preamble_guardinterval = 1;		/* short */
 	else
-	preamble_guardinterval = 0;		/* long */
+		preamble_guardinterval = 0;		/* long */
 
 	switch (stats->rate) {
 	/* CCK rate */
-	case MGN_1M:    rateIndex = 0;  break;
-	case MGN_2M:    rateIndex = 1;  break;
-	case MGN_5_5M:  rateIndex = 2;  break;
-	case MGN_11M:   rateIndex = 3;  break;
+	case MGN_1M:
+		rateIndex = 0;
+		break;
+	case MGN_2M:
+		rateIndex = 1;
+		break;
+	case MGN_5_5M:
+		rateIndex = 2;
+		break;
+	case MGN_11M:
+		rateIndex = 3;
+		break;
 	/* Legacy OFDM rate */
-	case MGN_6M:    rateIndex = 4;  break;
-	case MGN_9M:    rateIndex = 5;  break;
-	case MGN_12M:   rateIndex = 6;  break;
-	case MGN_18M:   rateIndex = 7;  break;
-	case MGN_24M:   rateIndex = 8;  break;
-	case MGN_36M:   rateIndex = 9;  break;
-	case MGN_48M:   rateIndex = 10; break;
-	case MGN_54M:   rateIndex = 11; break;
+	case MGN_6M:
+		rateIndex = 4;
+		break;
+	case MGN_9M:
+		rateIndex = 5;
+		break;
+	case MGN_12M:
+		rateIndex = 6;
+		break;
+	case MGN_18M:
+		rateIndex = 7;
+		break;
+	case MGN_24M:
+		rateIndex = 8;
+		break;
+	case MGN_36M:
+		rateIndex = 9;
+		break;
+	case MGN_48M:
+		rateIndex = 10;
+		break;
+	case MGN_54M:
+		rateIndex = 11;
+		break;
 	/* 11n High throughput rate */
-	case MGN_MCS0:  rateIndex = 12; break;
-	case MGN_MCS1:  rateIndex = 13; break;
-	case MGN_MCS2:  rateIndex = 14; break;
-	case MGN_MCS3:  rateIndex = 15; break;
-	case MGN_MCS4:  rateIndex = 16; break;
-	case MGN_MCS5:  rateIndex = 17; break;
-	case MGN_MCS6:  rateIndex = 18; break;
-	case MGN_MCS7:  rateIndex = 19; break;
-	case MGN_MCS8:  rateIndex = 20; break;
-	case MGN_MCS9:  rateIndex = 21; break;
-	case MGN_MCS10: rateIndex = 22; break;
-	case MGN_MCS11: rateIndex = 23; break;
-	case MGN_MCS12: rateIndex = 24; break;
-	case MGN_MCS13: rateIndex = 25; break;
-	case MGN_MCS14: rateIndex = 26; break;
-	case MGN_MCS15: rateIndex = 27; break;
-	default:        rateIndex = 28; break;
+	case MGN_MCS0:
+		rateIndex = 12;
+		break;
+	case MGN_MCS1:
+		rateIndex = 13;
+		break;
+	case MGN_MCS2:
+		rateIndex = 14;
+		break;
+	case MGN_MCS3:
+		rateIndex = 15;
+		break;
+	case MGN_MCS4:
+		rateIndex = 16;
+		break;
+	case MGN_MCS5:
+		rateIndex = 17;
+		break;
+	case MGN_MCS6:
+		rateIndex = 18;
+		break;
+	case MGN_MCS7:
+		rateIndex = 19;
+		break;
+	case MGN_MCS8:
+		rateIndex = 20;
+		break;
+	case MGN_MCS9:
+		rateIndex = 21;
+		break;
+	case MGN_MCS10:
+		rateIndex = 22;
+		break;
+	case MGN_MCS11:
+		rateIndex = 23;
+		break;
+	case MGN_MCS12:
+		rateIndex = 24;
+		break;
+	case MGN_MCS13:
+		rateIndex = 25;
+		break;
+	case MGN_MCS14:
+		rateIndex = 26;
+		break;
+	case MGN_MCS15:
+		rateIndex = 27;
+		break;
+	default:
+		rateIndex = 28;
+		break;
 	}
 	priv->stats.received_preamble_GI[preamble_guardinterval][rateIndex]++;
 	priv->stats.received_rate_histogram[0][rateIndex]++;	/* total */
 	priv->stats.received_rate_histogram[rcvType][rateIndex]++;
 }
 
-
 void query_rxdesc_status(struct sk_buff *skb, struct ieee80211_rx_stats *stats,
 							bool bIsRxAggrSubframe)
 {
 	rtl8192_rx_info *info = (struct rtl8192_rx_info *)skb->cb;
-	struct net_device *dev=info->dev;
+	struct net_device *dev = info->dev;
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
 	/* rx_desc_819x_usb *desc = (rx_desc_819x_usb *)skb->data; */
 	rx_drvinfo_819x_usb  *driver_info = NULL;
@@ -5695,8 +5753,7 @@ void query_rxdesc_status(struct sk_buff *skb, struct ieee80211_rx_stats *stats,
 			} else {
 				stats->rate = ret_rate;
 			}
-		}
-		else
+		} else
 			stats->rate = 0x02;
 
 		stats->bShortPreamble = driver_info->SPLCP;
@@ -5709,9 +5766,9 @@ void query_rxdesc_status(struct sk_buff *skb, struct ieee80211_rx_stats *stats,
 		stats->TimeStampLow = driver_info->TSFL;
 		/* xiong mask it, 070514 */
 		/* pRfd->Status.TimeStampHigh =
-		 * 			PlatformEFIORead4Byte(Adapter, TSFR+4);
+		 * PlatformEFIORead4Byte(Adapter, TSFR+4);
 		 */
-		/* stats->TimeStampHigh = read_nic_dword(dev,  TSFR+4); */
+		/* stats->TimeStampHigh = read_nic_dword(dev, TSFR+4); */
 
 		UpdateRxPktTimeStamp8190(dev, stats);
 
@@ -5733,35 +5790,34 @@ void query_rxdesc_status(struct sk_buff *skb, struct ieee80211_rx_stats *stats,
 	/* for the rx aggregated sub frame, the redundant space truly
 	 * contained in the packet
 	 */
-	if(bIsRxAggrSubframe) {
+	if (bIsRxAggrSubframe)
 		skb_pull(skb, 8);
-	}
 #endif
 	/* for debug 2008.5.29 */
 
 	/* added by vivi, for MP, 20080108 */
 	stats->RxIs40MHzPacket = driver_info->BW;
-	if(stats->RxDrvInfoSize != 0)
+	if (stats->RxDrvInfoSize != 0)
 		TranslateRxSignalStuff819xUsb(skb, stats, driver_info);
-
 }
 
-u32 GetRxPacketShiftBytes819xUsb(struct ieee80211_rx_stats  *Status, bool bIsRxAggrSubframe)
+u32 GetRxPacketShiftBytes819xUsb(struct ieee80211_rx_stats  *Status,
+					bool bIsRxAggrSubframe)
 {
 #ifdef USB_RX_AGGREGATION_SUPPORT
 	if (bIsRxAggrSubframe)
-		return (sizeof(rx_desc_819x_usb) + Status->RxDrvInfoSize
-			+ Status->RxBufShift + 8);
+		return sizeof(rx_desc_819x_usb) + Status->RxDrvInfoSize
+			+ Status->RxBufShift + 8;
 	else
 #endif
-		return (sizeof(rx_desc_819x_usb) + Status->RxDrvInfoSize
-				+ Status->RxBufShift);
+		return sizeof(rx_desc_819x_usb) + Status->RxDrvInfoSize
+				+ Status->RxBufShift;
 }
 
-void rtl8192_rx_nomal(struct sk_buff* skb)
+void rtl8192_rx_nomal(struct sk_buff *skb)
 {
 	rtl8192_rx_info *info = (struct rtl8192_rx_info *)skb->cb;
-	struct net_device *dev=info->dev;
+	struct net_device *dev = info->dev;
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
 	struct ieee80211_rx_stats stats = {
 		.signal = 0,
@@ -5789,7 +5845,8 @@ void rtl8192_rx_nomal(struct sk_buff* skb)
 #endif
 
 	/* 20 is for ps-poll */
-	if((skb->len >=(20 + sizeof(rx_desc_819x_usb))) && (skb->len < RX_URB_SIZE)) {
+	if ((skb->len >= (20 + sizeof(rx_desc_819x_usb))) &&
+				(skb->len < RX_URB_SIZE)) {
 #ifdef USB_RX_AGGREGATION_SUPPORT
 		TempByte = *(skb->data + sizeof(rx_desc_819x_usb));
 #endif
@@ -5809,8 +5866,10 @@ void rtl8192_rx_nomal(struct sk_buff* skb)
 			TempDWord = *(u32 *)(agg_skb->data - 4);
 			PacketLength = (u16)(TempDWord & 0x3FFF); /*sCrcLng*/
 			skb = dev_alloc_skb(PacketLength);
-			memcpy(skb_put(skb,PacketLength),agg_skb->data,PacketLength);
-			PacketShiftBytes = GetRxPacketShiftBytes819xUsb(&stats, false);
+			memcpy(skb_put(skb, PacketLength), agg_skb->data,
+							PacketLength);
+			PacketShiftBytes = GetRxPacketShiftBytes819xUsb(&stats,
+							false);
 		}
 #endif
 		/* Process the MPDU recevied */
@@ -5819,50 +5878,56 @@ void rtl8192_rx_nomal(struct sk_buff* skb)
 		rx_pkt_len = skb->len;
 		ieee80211_hdr = (struct ieee80211_hdr_1addr *)skb->data;
 		unicast_packet = false;
-		if(is_broadcast_ether_addr(ieee80211_hdr->addr1)) {
+		if (is_broadcast_ether_addr(ieee80211_hdr->addr1)) {
 			/* TODO */
-		}else if(is_multicast_ether_addr(ieee80211_hdr->addr1)){
+		} else if (is_multicast_ether_addr(ieee80211_hdr->addr1)) {
 			/* TODO */
-		}else {
+		} else {
 			/* unicast packet */
 			unicast_packet = true;
 		}
 
-		if(!ieee80211_rx(priv->ieee80211,skb, &stats)) {
+		if (!ieee80211_rx(priv->ieee80211, skb, &stats)) {
 			dev_kfree_skb_any(skb);
 		} else {
 			priv->stats.rxoktotal++;
-			if(unicast_packet) {
+			if (unicast_packet)
 				priv->stats.rxbytesunicast += rx_pkt_len;
-			}
 		}
 #ifdef USB_RX_AGGREGATION_SUPPORT
 		testing = 1;
 		/* (PipeIndex == 0) && (TempByte & BIT0) => TotalLength > 0. */
 		if (TotalLength > 0) {
-			PacketOccupiedLendth = PacketLength + (PacketShiftBytes + 8);
+			PacketOccupiedLendth = PacketLength +
+						(PacketShiftBytes + 8);
 			if ((PacketOccupiedLendth & 0xFF) != 0)
-				PacketOccupiedLendth = (PacketOccupiedLendth & 0xFFFFFF00) + 256;
+				PacketOccupiedLendth =
+					(PacketOccupiedLendth & 0xFFFFFF00)
+					+ 256;
 			PacketOccupiedLendth -= 8;
-			TempDWord = PacketOccupiedLendth - PacketShiftBytes; /*- PacketLength */
+			TempDWord = PacketOccupiedLendth - PacketShiftBytes;
+				/*- PacketLength */
 			if (agg_skb->len > TempDWord)
 				skb_pull(agg_skb, TempDWord);
 			else
 				agg_skb->len = 0;
 
-			while (agg_skb->len>=GetRxPacketShiftBytes819xUsb(&stats, true)) {
+			while (agg_skb->len >= GetRxPacketShiftBytes819xUsb
+							(&stats, true)) {
 				u8 tmpCRC = 0, tmpICV = 0;
 				/* RT_TRACE(COMP_RECV,"%s:aggred pkt,total_len"
 				 *	" = %d\n",__func__,agg_skb->len);
 				 */
-				RxDescr = (rx_desc_819x_usb_aggr_subframe *)(agg_skb->data);
+				RxDescr = (rx_desc_819x_usb_aggr_subframe *)
+							(agg_skb->data);
 				tmpCRC = RxDescr->CRC32;
 				tmpICV = RxDescr->ICV;
 				memcpy(agg_skb->data, &agg_skb->data[44], 2);
 				RxDescr->CRC32 = tmpCRC;
 				RxDescr->ICV = tmpICV;
 
-				memset(&stats, 0, sizeof(struct ieee80211_rx_stats));
+				memset(&stats, 0,
+					sizeof(struct ieee80211_rx_stats));
 				stats.signal = 0;
 				stats.noise = -98;
 				stats.rate = 0;
@@ -5870,41 +5935,51 @@ void rtl8192_rx_nomal(struct sk_buff* skb)
 				query_rxdesc_status(agg_skb, &stats, true);
 				PacketLength = stats.Length;
 
-				if(PacketLength > agg_skb->len) {
+				if (PacketLength > agg_skb->len)
 					break;
-				}
 				/* Process the MPDU recevied */
 				skb = dev_alloc_skb(PacketLength);
-				memcpy(skb_put(skb,PacketLength),agg_skb->data, PacketLength);
+				memcpy(skb_put(skb, PacketLength),
+					agg_skb->data, PacketLength);
 				skb_trim(skb, skb->len - 4/*sCrcLng*/);
 
 				rx_pkt_len = skb->len;
-				ieee80211_hdr = (struct ieee80211_hdr_1addr *)skb->data;
+				ieee80211_hdr = (struct ieee80211_hdr_1addr *)
+								skb->data;
 				unicast_packet = false;
-				if(is_broadcast_ether_addr(ieee80211_hdr->addr1)) {
+				if (is_broadcast_ether_addr
+						(ieee80211_hdr->addr1)) {
 					/* TODO */
-				}else if(is_multicast_ether_addr(ieee80211_hdr->addr1)){
+				} else if (is_multicast_ether_addr
+						(ieee80211_hdr->addr1)) {
 					/* TODO */
-				}else {
+				} else
 					/* unicast packet */
 					unicast_packet = true;
-				}
-				if(!ieee80211_rx(priv->ieee80211,skb, &stats)) {
+				if (!ieee80211_rx(priv->ieee80211, skb,
+						&stats)) {
 					dev_kfree_skb_any(skb);
 				} else {
 					priv->stats.rxoktotal++;
-					if(unicast_packet) {
-						priv->stats.rxbytesunicast += rx_pkt_len;
+					if (unicast_packet) {
+						priv->stats.rxbytesunicast +=
+								rx_pkt_len;
 					}
 				}
-				/* should trim the packet which has been copied to target skb */
+				/* should trim the packet which has been
+				 * copied to target skb
+				 */
 				skb_pull(agg_skb, PacketLength);
-				PacketShiftBytes = GetRxPacketShiftBytes819xUsb(&stats, true);
-				PacketOccupiedLendth = PacketLength + PacketShiftBytes;
+				PacketShiftBytes = GetRxPacketShiftBytes819xUsb
+								(&stats, true);
+				PacketOccupiedLendth = PacketLength +
+							PacketShiftBytes;
 				if ((PacketOccupiedLendth & 0xFF) != 0) {
-					PaddingBytes = 256 - (PacketOccupiedLendth & 0xFF);
+					PaddingBytes = 256 -
+						(PacketOccupiedLendth & 0xFF);
 					if (agg_skb->len > PaddingBytes)
-						skb_pull(agg_skb, PaddingBytes);
+						skb_pull(agg_skb,
+								PaddingBytes);
 					else
 						agg_skb->len = 0;
 				}
@@ -5926,9 +6001,9 @@ rtl819xusb_process_received_packet(
 	struct ieee80211_rx_stats *pstats
 	)
 {
-	/* bool bfreerfd=false, bqueued=false; */
-	u8* 	frame;
-	u16     frame_len=0;
+	/* bool bfreerfd = false, bqueued = false; */
+	u8 *frame;
+	u16	frame_len = 0;
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	/* u8			index = 0; */
 	/* u8			TID = 0; */
@@ -5943,7 +6018,7 @@ rtl819xusb_process_received_packet(
 	frame = pstats->virtual_address;
 	frame_len = pstats->packetlength;
 #ifdef TODO	/* by amy about HCT */
-	if(!Adapter->bInHctTest)
+	if (!Adapter->bInHctTest)
 		CountRxErrStatistics(Adapter, pRfd);
 #endif
 	{
@@ -5955,11 +6030,10 @@ rtl819xusb_process_received_packet(
 		 * changed and hw switch is being changed.
 		 * 2006.12.04, by shien chang.
 		 */
-		Adapter->HalFunc.GetHwRegHandler(Adapter, HW_VAR_RF_STATE, (u8* )(&rtState));
+		Adapter->HalFunc.GetHwRegHandler(Adapter, HW_VAR_RF_STATE,
+							(u8 *)(&rtState));
 		if (rtState == eRfOff)
-		{
 			return;
-		}
 	#endif
 	priv->stats.rxframgment++;
 
@@ -5968,11 +6042,11 @@ rtl819xusb_process_received_packet(
 	RmMonitorSignalStrength(Adapter, pRfd);
 #endif
 	/* 2007/01/16 MH Add RX command packet handle here. */
-	/* 2007/03/01 MH We have to release RFD and return if rx pkt is cmd pkt. */
+	/* 2007/03/01 MH We have to release RFD and return if
+	 * rx pkt is cmd pkt.
+	 */
 	if (rtl819xusb_rx_command_packet(dev, pstats))
-	{
 		return;
-	}
 
 #ifdef SW_CRC_CHECK
 	SwCrcCheck();
@@ -5981,7 +6055,8 @@ rtl819xusb_process_received_packet(
 
 }
 
-void query_rx_cmdpkt_desc_status(struct sk_buff *skb, struct ieee80211_rx_stats *stats)
+void query_rx_cmdpkt_desc_status(struct sk_buff *skb,
+				struct ieee80211_rx_stats *stats)
 {
 	/* rtl8192_rx_info *info = (struct rtl8192_rx_info *)skb->cb; */
 	/* struct net_device *dev=info->dev; */
@@ -5992,7 +6067,7 @@ void query_rx_cmdpkt_desc_status(struct sk_buff *skb, struct ieee80211_rx_stats
 	/* rx_drvinfo_819x_usb  *driver_info; */
 
 	/* Get Rx Descriptor Information */
-	stats->virtual_address = (u8*)skb->data;
+	stats->virtual_address = (u8 *)skb->data;
 	stats->Length = desc->Length;
 	stats->RxDrvInfoSize = 0;
 	stats->RxBufShift = 0;
@@ -6018,17 +6093,15 @@ void rtl8192_rx_cmd(struct sk_buff *skb)
 		.freq = IEEE80211_24GHZ_BAND,
 	};
 
-	if((skb->len >=(20 + sizeof(rx_desc_819x_usb))) && (skb->len < RX_URB_SIZE))
-	{
-
-		query_rx_cmdpkt_desc_status(skb,&stats);
+	if ((skb->len >= (20 + sizeof(rx_desc_819x_usb))) &&
+				(skb->len < RX_URB_SIZE)) {
+		query_rx_cmdpkt_desc_status(skb, &stats);
 		/* this is to be done by amy 080508     prfd->queue_id = 1; */
 
 		/*  Process the command packet received. */
-		rtl819xusb_process_received_packet(dev,&stats);
+		rtl819xusb_process_received_packet(dev, &stats);
 		dev_kfree_skb_any(skb);
-	}
-	else
+	} else
 		;
 }
 
@@ -6087,7 +6160,7 @@ static int __devinit rtl8192_usb_probe(struct usb_interface *intf,
 {
 	/* unsigned long ioaddr = 0; */
 	struct net_device *dev = NULL;
-	struct r8192_priv *priv= NULL;
+	struct r8192_priv *priv = NULL;
 	struct usb_device *udev = interface_to_usbdev(intf);
 	RT_TRACE(COMP_INIT, "Oops: i'm coming\n");
 
@@ -6098,7 +6171,7 @@ static int __devinit rtl8192_usb_probe(struct usb_interface *intf,
 	SET_NETDEV_DEV(dev, &intf->dev);
 	priv = ieee80211_priv(dev);
 	priv->ieee80211 = netdev_priv(dev);
-	priv->udev=udev;
+	priv->udev = udev;
 
 	dev->netdev_ops = &rtl8192_netdev_ops;
 
@@ -6107,20 +6180,22 @@ static int __devinit rtl8192_usb_probe(struct usb_interface *intf,
 #if WIRELESS_EXT < 17
 	dev->get_wireless_stats = r8192_get_wireless_stats;
 #endif
-	dev->wireless_handlers = (struct iw_handler_def *) &r8192_wx_handlers_def;
+	dev->wireless_handlers = (struct iw_handler_def *)
+					&r8192_wx_handlers_def;
 #endif
-	dev->type=ARPHRD_ETHER;
+	dev->type = ARPHRD_ETHER;
 
-	dev->watchdog_timeo = HZ*3;	/* modified by john, 0805 */
+	dev->watchdog_timeo = HZ * 3;	/* modified by john, 0805 */
 
-	if (dev_alloc_name(dev, ifname) < 0){
-		RT_TRACE(COMP_INIT, "Oops: devname already taken! Trying wlan%%d...\n");
+	if (dev_alloc_name(dev, ifname) < 0) {
+		RT_TRACE(COMP_INIT, "Oops: devname already taken!"
+				" Trying wlan%%d...\n");
 		ifname = "wlan%d";
 		dev_alloc_name(dev, ifname);
 	}
 
 	RT_TRACE(COMP_INIT, "Driver probe completed1\n");
-	if(rtl8192_init(dev)!=0){
+	if (rtl8192_init(dev) != 0) {
 		RT_TRACE(COMP_ERR, "Initialization failed");
 		goto fail;
 	}
@@ -6128,7 +6203,7 @@ static int __devinit rtl8192_usb_probe(struct usb_interface *intf,
 	netif_stop_queue(dev);
 
 	register_netdev(dev);
-	RT_TRACE(COMP_INIT, "dev name=======> %s\n",dev->name);
+	RT_TRACE(COMP_INIT, "dev name=======> %s\n", dev->name);
 	rtl8192_proc_init_one(dev);
 
 
@@ -6147,7 +6222,7 @@ fail:
 /*detach all the work and timer structure declared or
  * inititialize in r8192U_init function.
  */
-void rtl8192_cancel_deferred_work(struct r8192_priv* priv)
+void rtl8192_cancel_deferred_work(struct r8192_priv *priv)
 {
 
 	cancel_work_sync(&priv->reset_wq);
@@ -6165,16 +6240,15 @@ static void __devexit rtl8192_usb_disconnect(struct usb_interface *intf)
 	struct net_device *dev = usb_get_intfdata(intf);
 
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	if(dev){
-
+	if (dev) {
 		unregister_netdev(dev);
 
-		RT_TRACE(COMP_DOWN, "=============>wlan driver to be removed\n");
+		RT_TRACE(COMP_DOWN, "=============>wlan driver to be"
+				" removed\n");
 		rtl8192_proc_remove_one(dev);
 
 			rtl8192_down(dev);
-		if (priv->pFirmware)
-		{
+		if (priv->pFirmware) {
 			kfree(priv->pFirmware);
 			priv->pFirmware = NULL;
 		}
@@ -6185,7 +6259,6 @@ static void __devexit rtl8192_usb_disconnect(struct usb_interface *intf)
 		/* rtl8192_irq_disable(dev); */
 		/* rtl8192_reset(dev); */
 		mdelay(10);
-
 	}
 	free_ieee80211(dev);
 	RT_TRACE(COMP_DOWN, "wlan driver removed\n");
@@ -6264,11 +6337,11 @@ void rtl8192_try_wake_queue(struct net_device *dev, int pri)
 	short enough_desc;
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
 
-	spin_lock_irqsave(&priv->tx_lock,flags);
-	enough_desc = check_nic_enough_desc(dev,pri);
-	spin_unlock_irqrestore(&priv->tx_lock,flags);
+	spin_lock_irqsave(&priv->tx_lock, flags);
+	enough_desc = check_nic_enough_desc(dev, pri);
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
 
-	if(enough_desc)
+	if (enough_desc)
 		ieee80211_wake_queue(priv->ieee80211);
 }
 
@@ -6276,15 +6349,15 @@ void EnableHWSecurityConfig8192(struct net_device *dev)
 {
 	u8 SECR_value = 0x0;
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
-	 struct ieee80211_device* ieee = priv->ieee80211;
+	 struct ieee80211_device *ieee = priv->ieee80211;
 	SECR_value = SCR_TxEncEnable | SCR_RxDecEnable;
-	if (((KEY_TYPE_WEP40 == ieee->pairwise_key_type) || (KEY_TYPE_WEP104 == ieee->pairwise_key_type)) && (priv->ieee80211->auth_mode != 2))
-	{
+	if (((KEY_TYPE_WEP40 == ieee->pairwise_key_type) ||
+			(KEY_TYPE_WEP104 == ieee->pairwise_key_type)) &&
+			(priv->ieee80211->auth_mode != 2)) {
 		SECR_value |= SCR_RxUseDK;
 		SECR_value |= SCR_TxUseDK;
-	}
-	else if ((ieee->iw_mode == IW_MODE_ADHOC) && (ieee->pairwise_key_type & (KEY_TYPE_CCMP | KEY_TYPE_TKIP)))
-	{
+	} else if ((ieee->iw_mode == IW_MODE_ADHOC) && (ieee->pairwise_key_type
+			& (KEY_TYPE_CCMP | KEY_TYPE_TKIP))) {
 		SECR_value |= SCR_RxUseDK;
 		SECR_value |= SCR_TxUseDK;
 	}
@@ -6298,28 +6371,28 @@ void EnableHWSecurityConfig8192(struct net_device *dev)
 	ieee->hwsec_active = 1;
 
 	if ((ieee->pHTInfo->IOTAction&HT_IOT_ACT_PURE_N_MODE) || !hwwep)
-	/* !ieee->hwsec_support) */
-	/*add hwsec_support flag to totol control hw_sec on/off */
+		/* !ieee->hwsec_support) */
+		/*add hwsec_support flag to totol control hw_sec on/off */
 	{
 		ieee->hwsec_active = 0;
 		SECR_value &= ~SCR_RxDecEnable;
 	}
-	RT_TRACE(COMP_SEC,"%s:, hwsec:%d, pairwise_key:%d, SECR_value:%x\n", __func__, \
-			ieee->hwsec_active, ieee->pairwise_key_type, SECR_value);
+	RT_TRACE(COMP_SEC, "%s:, hwsec:%d, pairwise_key:%d, SECR_value:%x\n",
+			__func__, ieee->hwsec_active, ieee->pairwise_key_type,
+			SECR_value);
 	{
 		write_nic_byte(dev, SECR,  SECR_value);
 					/* SECR_value |  SCR_UseDK ); */
 	}
 }
 
-
-void setKey(	struct net_device *dev,
+void setKey(struct net_device *dev,
 		u8 EntryNo,
 		u8 KeyIndex,
 		u16 KeyType,
 		u8 *MacAddr,
 		u8 DefaultKey,
-		u32 *KeyContent )
+		u32 *KeyContent)
 {
 	u32 TargetCommand = 0;
 	u32 TargetContent = 0;
@@ -6328,7 +6401,9 @@ void setKey(	struct net_device *dev,
 	if (EntryNo >= TOTAL_CAM_ENTRY)
 		RT_TRACE(COMP_ERR, "cam entry exceeds in setKey()\n");
 
-	RT_TRACE(COMP_SEC, "====>to setKey(), dev:%p, EntryNo:%d, KeyIndex:%d, KeyType:%d, MacAddr%pM\n", dev,EntryNo, KeyIndex, KeyType, MacAddr);
+	RT_TRACE(COMP_SEC, "====>to setKey(), dev:%p, EntryNo:%d, KeyIndex:%d,"
+			" KeyType:%d, MacAddr%pM\n", dev, EntryNo, KeyIndex,
+			KeyType, MacAddr);
 
 	if (DefaultKey)
 		usConfig |= BIT15 | (KeyType<<2);
@@ -6337,34 +6412,33 @@ void setKey(	struct net_device *dev,
 	/* usConfig |= BIT15 | (KeyType<<2) | (DefaultKey<<5) | KeyIndex; */
 
 
-	for(i=0 ; i<CAM_CONTENT_COUNT; i++){
-		TargetCommand  = i+CAM_CONTENT_COUNT*EntryNo;
+	for (i = 0; i < CAM_CONTENT_COUNT; i++) {
+		TargetCommand  = i + CAM_CONTENT_COUNT * EntryNo;
 		TargetCommand |= BIT31|BIT16;
 
-		if(i==0){		/* MAC|Config */
-			TargetContent = (u32)(*(MacAddr+0)) << 16|
-					(u32)(*(MacAddr+1)) << 24|
+		if (i == 0) {		/* MAC|Config */
+			TargetContent = (u32)(*(MacAddr + 0)) << 16|
+					(u32)(*(MacAddr + 1)) << 24|
 					(u32)usConfig;
 
 			write_nic_dword(dev, WCAMI, TargetContent);
 			write_nic_dword(dev, RWCAM, TargetCommand);
-			/* printk("setkey cam =%8x\n",
-			 *			 read_cam(dev, i+6*EntryNo));
+			/* printk("setkey cam =% 8x\n",
+			 *		read_cam(dev, i + 6 * EntryNo));
 			 */
-		}
-		else if(i==1){		/* MAC */
-			TargetContent = (u32)(*(MacAddr+2)) 	 |
-					(u32)(*(MacAddr+3)) <<  8|
-					(u32)(*(MacAddr+4)) << 16|
-					(u32)(*(MacAddr+5)) << 24;
+		} else if (i == 1) {		/* MAC */
+			TargetContent = (u32)(*(MacAddr + 2))|
+					(u32)(*(MacAddr + 3)) <<  8|
+					(u32)(*(MacAddr + 4)) << 16|
+					(u32)(*(MacAddr + 5)) << 24;
 			write_nic_dword(dev, WCAMI, TargetContent);
 			write_nic_dword(dev, RWCAM, TargetCommand);
-		}
-		else {
+		} else {
 			/* Key Material */
-			if(KeyContent !=NULL){
-			write_nic_dword(dev, WCAMI, (u32)(*(KeyContent+i-2)) );
-			write_nic_dword(dev, RWCAM, TargetCommand);
+			if (KeyContent != NULL) {
+				write_nic_dword(dev, WCAMI,
+					(u32)(*(KeyContent + i - 2)));
+				write_nic_dword(dev, RWCAM, TargetCommand);
 		}
 	}
 	}
-- 
1.6.3.3

