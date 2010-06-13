Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab0FMH0J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 03:26:09 -0400
Received: from outbound-mail01.westnet.com.au ([203.10.1.242]:31406 "EHLO
	outbound-mail01.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751922Ab0FMHZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 03:25:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsBBAMYUFEw6B0zXPGdsb2JhbACHbpcRDAEBAQE1LbBrjE6FGgSDSw
X-IronPort-AV: E=Sophos;i="4.53,410,1272816000"; 
   d="scan'208";a="84157947"
From: Mike Gilks <mike.kernel@gilksonline.com>
To: gregkh@suse.de, mchehab@redhat.com, julia@diku.dk, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Gilks <mike.kernel@gilksonline.com>
Subject: [PATCH 3/4] staging: rtl8192u: fix checkpatch.pl issues to line 5500 Fix most problems pointed out by checkpatch.pl in file r8192U_core.c up to line 5500
Date: Sun, 13 Jun 2010 14:16:50 +0800
Message-Id: <1276409811-16682-4-git-send-email-mike.kernel@gilksonline.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1276409811-16682-3-git-send-email-mike.kernel@gilksonline.com>
References: <1276409811-16682-1-git-send-email-mike.kernel@gilksonline.com>
 <1276409811-16682-2-git-send-email-mike.kernel@gilksonline.com>
 <1276409811-16682-3-git-send-email-mike.kernel@gilksonline.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Gilks <mike.kernel@gilksonline.com>
---
 drivers/staging/rtl8192u/r8192U_core.c |  265 +++++++++++++++-----------------
 1 files changed, 124 insertions(+), 141 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 1a89b20..8dcf542 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -5012,85 +5012,93 @@ void rtl8192_process_phyinfo(struct r8192_priv *priv, u8 *buffer,
 		 *			pPreviousRfd->Status.RxPWDBAll);
 		 */
 		slide_beacon_adc_pwdb_index++;
-		if(slide_beacon_adc_pwdb_index >= PHY_Beacon_RSSI_SLID_WIN_MAX)
+		if (slide_beacon_adc_pwdb_index >=
+					PHY_Beacon_RSSI_SLID_WIN_MAX)
 			slide_beacon_adc_pwdb_index = 0;
-		pprevious_stats->RxPWDBAll = priv->stats.Slide_Beacon_Total/slide_beacon_adc_pwdb_statistics;
-		if(pprevious_stats->RxPWDBAll >= 3)
+		pprevious_stats->RxPWDBAll = priv->stats.Slide_Beacon_Total /
+					slide_beacon_adc_pwdb_statistics;
+		if (pprevious_stats->RxPWDBAll >= 3)
 			pprevious_stats->RxPWDBAll -= 3;
 	}
 
 	RT_TRACE(COMP_RXDESC, "Smooth %s PWDB = %d\n",
-				pprevious_stats->bIsCCK? "CCK": "OFDM",
+				pprevious_stats->bIsCCK ? "CCK" : "OFDM",
 				pprevious_stats->RxPWDBAll);
 
 
-	if(pprevious_stats->bPacketToSelf || pprevious_stats->bPacketBeacon || pprevious_stats->bToSelfBA)
-	{
-		if(priv->undecorated_smoothed_pwdb < 0)	/* initialize */
-		{
-			priv->undecorated_smoothed_pwdb = pprevious_stats->RxPWDBAll;
-			/* DbgPrint("First pwdb initialize \n"); */
-		}
-		if(pprevious_stats->RxPWDBAll > (u32)priv->undecorated_smoothed_pwdb)
-		{
+	if (pprevious_stats->bPacketToSelf || pprevious_stats->bPacketBeacon ||
+					pprevious_stats->bToSelfBA) {
+		if (priv->undecorated_smoothed_pwdb < 0) /* initialize */ {
 			priv->undecorated_smoothed_pwdb =
-					( ((priv->undecorated_smoothed_pwdb)*(Rx_Smooth_Factor-1)) +
-					(pprevious_stats->RxPWDBAll)) /(Rx_Smooth_Factor);
-			priv->undecorated_smoothed_pwdb = priv->undecorated_smoothed_pwdb + 1;
+					pprevious_stats->RxPWDBAll;
+			/* DbgPrint("First pwdb initialize\n"); */
 		}
-		else
-		{
+		if (pprevious_stats->RxPWDBAll >
+					(u32)priv->undecorated_smoothed_pwdb) {
 			priv->undecorated_smoothed_pwdb =
-					( ((priv->undecorated_smoothed_pwdb)*(Rx_Smooth_Factor-1)) +
-					(pprevious_stats->RxPWDBAll)) /(Rx_Smooth_Factor);
+					(((priv->undecorated_smoothed_pwdb) *
+					(Rx_Smooth_Factor - 1)) +
+					(pprevious_stats->RxPWDBAll)) /
+					(Rx_Smooth_Factor);
+			priv->undecorated_smoothed_pwdb =
+					priv->undecorated_smoothed_pwdb + 1;
+		} else {
+			priv->undecorated_smoothed_pwdb =
+					(((priv->undecorated_smoothed_pwdb) *
+					(Rx_Smooth_Factor-1)) +
+					(pprevious_stats->RxPWDBAll)) /
+					(Rx_Smooth_Factor);
 		}
-
 	}
 
-
 	/* Check EVM */
 	/* record the general EVM to the sliding window. */
-	if(pprevious_stats->SignalQuality == 0)
-	{
-	}
-	else
-	{
-		if(pprevious_stats->bPacketToSelf || pprevious_stats->bPacketBeacon || pprevious_stats->bToSelfBA){
-			if(slide_evm_statistics++ >= PHY_RSSI_SLID_WIN_MAX){
+	if (pprevious_stats->SignalQuality == 0) {
+	} else {
+		if (pprevious_stats->bPacketToSelf ||
+				pprevious_stats->bPacketBeacon ||
+				pprevious_stats->bToSelfBA){
+			if (slide_evm_statistics++ >= PHY_RSSI_SLID_WIN_MAX) {
 				slide_evm_statistics = PHY_RSSI_SLID_WIN_MAX;
-				last_evm = priv->stats.slide_evm[slide_evm_index];
+				last_evm =
+				priv->stats.slide_evm[slide_evm_index];
 				priv->stats.slide_evm_total -= last_evm;
 			}
-
-			priv->stats.slide_evm_total += pprevious_stats->SignalQuality;
-
-			priv->stats.slide_evm[slide_evm_index++] = pprevious_stats->SignalQuality;
-			if(slide_evm_index >= PHY_RSSI_SLID_WIN_MAX)
+			priv->stats.slide_evm_total +=
+					pprevious_stats->SignalQuality;
+			priv->stats.slide_evm[slide_evm_index++] =
+					pprevious_stats->SignalQuality;
+			if (slide_evm_index >= PHY_RSSI_SLID_WIN_MAX)
 				slide_evm_index = 0;
 
 			/* <1> Showed on UI for user, in percentage. */
-			tmp_val = priv->stats.slide_evm_total/slide_evm_statistics;
+			tmp_val = priv->stats.slide_evm_total /
+						slide_evm_statistics;
 			priv->stats.signal_quality = tmp_val;
-			/* cosa add 10/11/2007, Showed on UI for user in Windows Vista, for Link quality. */
+			/* cosa add 10/11/2007, Showed on UI for user in
+			 * Windows Vista, for Link quality.
+			 */
 			priv->stats.last_signal_strength_inpercent = tmp_val;
 		}
 
 		/* <2> Showed on UI for engineering */
-		if(pprevious_stats->bPacketToSelf || pprevious_stats->bPacketBeacon || pprevious_stats->bToSelfBA)
-		{
-			for(nspatial_stream = 0; nspatial_stream<2 ; nspatial_stream++)
-				/* 2 spatial stream */
-			{
-				if(pprevious_stats->RxMIMOSignalQuality[nspatial_stream] != -1)
-				{
-					if(priv->stats.rx_evm_percentage[nspatial_stream] == 0)
-						/* initialize */
-					{
-						priv->stats.rx_evm_percentage[nspatial_stream] = pprevious_stats->RxMIMOSignalQuality[nspatial_stream];
+		if (pprevious_stats->bPacketToSelf ||
+				pprevious_stats->bPacketBeacon ||
+				pprevious_stats->bToSelfBA) {
+			for (nspatial_stream = 0; nspatial_stream < 2;
+						nspatial_stream++)
+						/* 2 spatial stream */{
+				if (pprevious_stats->RxMIMOSignalQuality[nspatial_stream] != -1) {
+					if (priv->stats.rx_evm_percentage[nspatial_stream] == 0)
+						/* initialize */{
+						priv->stats.rx_evm_percentage[nspatial_stream] =
+						pprevious_stats->RxMIMOSignalQuality[nspatial_stream];
 					}
 					priv->stats.rx_evm_percentage[nspatial_stream] =
-						( (priv->stats.rx_evm_percentage[nspatial_stream]* (Rx_Smooth_Factor-1)) +
-						(pprevious_stats->RxMIMOSignalQuality[nspatial_stream]* 1)) / (Rx_Smooth_Factor);
+						((priv->stats.rx_evm_percentage[nspatial_stream] *
+						(Rx_Smooth_Factor-1)) +
+						(pprevious_stats->RxMIMOSignalQuality[nspatial_stream] * 1)) /
+						(Rx_Smooth_Factor);
 				}
 			}
 		}
@@ -5112,7 +5120,8 @@ void rtl8192_process_phyinfo(struct r8192_priv *priv, u8 *buffer,
  *
  * Revised History:
  *	When		Who		Remark
- *	05/26/2008	amy		Create Version 0 porting from windows code.
+ *	05/26/2008	amy		Create Version 0 porting from
+ *					 windows code.
  *
  *---------------------------------------------------------------------------*/
 static u8 rtl819x_query_rxpwrpercentage(
@@ -5120,18 +5129,11 @@ static u8 rtl819x_query_rxpwrpercentage(
 	)
 {
 	if ((antpower <= -100) || (antpower >= 20))
-	{
 		return	0;
-	}
 	else if (antpower >= 0)
-	{
 		return	100;
-	}
 	else
-	{
-		return	(100+antpower);
-	}
-
+		return	100 + antpower;
 }	/* QueryRxPwrPercentage */
 
 static u8
@@ -5143,15 +5145,15 @@ rtl819x_evm_dbtopercentage(
 
     ret_val = value;
 
-    if(ret_val >= 0)
-        ret_val = 0;
-    if(ret_val <= -33)
-        ret_val = -33;
-    ret_val = 0 - ret_val;
-    ret_val*=3;
-	if(ret_val == 99)
+	if (ret_val >= 0)
+		ret_val = 0;
+	if (ret_val <= -33)
+		ret_val = -33;
+	ret_val = 0 - ret_val;
+	ret_val *= 3;
+	if (ret_val == 99)
 		ret_val = 100;
-    return(ret_val);
+	return ret_val;
 }
 
 	/* Description:
@@ -5166,55 +5168,35 @@ rtl819x_signal_scale_mapping(
 	long retsig;
 
 	/* Step 1. Scale mapping. */
-	if(currsig >= 61 && currsig <= 100)
-	{
+	if (currsig >= 61 && currsig <= 100)
 		retsig = 90 + ((currsig - 60) / 4);
-	}
-	else if(currsig >= 41 && currsig <= 60)
-	{
+	else if (currsig >= 41 && currsig <= 60)
 		retsig = 78 + ((currsig - 40) / 2);
-	}
-	else if(currsig >= 31 && currsig <= 40)
-	{
+	else if (currsig >= 31 && currsig <= 40)
 		retsig = 66 + (currsig - 30);
-	}
-	else if(currsig >= 21 && currsig <= 30)
-	{
+	else if (currsig >= 21 && currsig <= 30)
 		retsig = 54 + (currsig - 20);
-	}
-	else if(currsig >= 5 && currsig <= 20)
-	{
+	else if (currsig >= 5 && currsig <= 20)
 		retsig = 42 + (((currsig - 5) * 2) / 3);
-	}
-	else if(currsig == 4)
-	{
+	else if (currsig == 4)
 		retsig = 36;
-	}
-	else if(currsig == 3)
-	{
+	else if (currsig == 3)
 		retsig = 27;
-	}
-	else if(currsig == 2)
-	{
+	else if (currsig == 2)
 		retsig = 18;
-	}
-	else if(currsig == 1)
-	{
+	else if (currsig == 1)
 		retsig = 9;
-	}
 	else
-	{
 		retsig = currsig;
-	}
 
 	return retsig;
 }
 
 static void rtl8192_query_rxphystatus(
-	struct r8192_priv * priv,
-	struct ieee80211_rx_stats * pstats,
-	rx_drvinfo_819x_usb  * pdrvinfo,
-	struct ieee80211_rx_stats * precord_stats,
+	struct r8192_priv *priv,
+	struct ieee80211_rx_stats *pstats,
+	rx_drvinfo_819x_usb  *pdrvinfo,
+	struct ieee80211_rx_stats *precord_stats,
 	bool bpacket_match_bssid,
 	bool bpacket_toself,
 	bool bPacketBeacon,
@@ -5222,19 +5204,20 @@ static void rtl8192_query_rxphystatus(
 	)
 {
 	/* PRT_RFD_STATUS		pRtRfdStatus = &(pRfd->Status); */
-	phy_sts_ofdm_819xusb_t*	pofdm_buf;
-	phy_sts_cck_819xusb_t	*	pcck_buf;
-	phy_ofdm_rx_status_rxsc_sgien_exintfflag* prxsc;
+	phy_sts_ofdm_819xusb_t *pofdm_buf;
+	phy_sts_cck_819xusb_t *pcck_buf;
+	phy_ofdm_rx_status_rxsc_sgien_exintfflag *prxsc;
 	u8				*prxpkt;
-	u8				i, max_spatial_stream, tmp_rxsnr, tmp_rxevm, rxsc_sgien_exflg;
-	char				rx_pwr[4], rx_pwr_all=0;
+	u8				i, max_spatial_stream, tmp_rxsnr;
+	u8				tmp_rxevm, rxsc_sgien_exflg;
+	char				rx_pwr[4], rx_pwr_all = 0;
 	/* long				rx_avg_pwr = 0; */
 	char				rx_snrX, rx_evmX;
 	u8				evm, pwdb_all;
-	u32				RSSI, total_rssi=0;
-						/* , total_evm=0; */
+	u32				RSSI, total_rssi = 0;
+						/* , total_evm = 0; */
 	/* long				signal_strength_index = 0; */
-	u8				is_cck_rate=0;
+	u8				is_cck_rate = 0;
 	u8				rf_rx_num = 0;
 
 
@@ -5244,14 +5227,15 @@ static void rtl8192_query_rxphystatus(
 
 	/* Record it for next packet processing */
 	memset(precord_stats, 0, sizeof(struct ieee80211_rx_stats));
-	pstats->bPacketMatchBSSID = precord_stats->bPacketMatchBSSID = bpacket_match_bssid;
+	pstats->bPacketMatchBSSID = precord_stats->bPacketMatchBSSID =
+						bpacket_match_bssid;
 	pstats->bPacketToSelf = precord_stats->bPacketToSelf = bpacket_toself;
 	pstats->bIsCCK = precord_stats->bIsCCK = is_cck_rate;
 					/* RX_HAL_IS_CCK_RATE(pDrvInfo); */
 	pstats->bPacketBeacon = precord_stats->bPacketBeacon = bPacketBeacon;
 	pstats->bToSelfBA = precord_stats->bToSelfBA = bToSelfBA;
 
-	prxpkt = (u8*)pdrvinfo;
+	prxpkt = (u8 *)pdrvinfo;
 
 	/* Move pointer to the 16th bytes. Phy status start address. */
 	prxpkt += sizeof(rx_drvinfo_819x_usb);
@@ -5347,7 +5331,7 @@ static void rtl8192_query_rxphystatus(
 			}
 			pstats->SignalQuality =
 					precord_stats->SignalQuality = sq;
-			pstats->RxMIMOSignalQuality[0] = 
+			pstats->RxMIMOSignalQuality[0] =
 				precord_stats->RxMIMOSignalQuality[0] = sq;
 			pstats->RxMIMOSignalQuality[1] =
 				precord_stats->RxMIMOSignalQuality[1] = -1;
@@ -5355,7 +5339,7 @@ static void rtl8192_query_rxphystatus(
 	} else {
 		priv->stats.numqry_phystatusHT++;
 		/* (1)Get RSSI for HT rate */
-		for (i = RF90_PATH_A; i<priv->NumTotalRFPath; i++) {
+		for (i = RF90_PATH_A; i < priv->NumTotalRFPath; i++) {
 			/* 2008/01/30 MH we will judge RF RX path now. */
 			if (priv->brfpath_rxenable[i])
 				rf_rx_num++;
@@ -5384,8 +5368,8 @@ static void rtl8192_query_rxphystatus(
 			/* Record Signal Strength for next packet */
 			/* if(bpacket_match_bssid) */
 			{
-				pstats->RxMIMOSignalStrength[i] =(u8) RSSI;
-				precord_stats->RxMIMOSignalStrength[i] =(u8)
+				pstats->RxMIMOSignalStrength[i] = (u8) RSSI;
+				precord_stats->RxMIMOSignalStrength[i] = (u8)
 									RSSI;
 			}
 		}
@@ -5396,7 +5380,7 @@ static void rtl8192_query_rxphystatus(
 
 		/* Fixed by Jacken from Bryant 2008-03-20 */
 		/* Original value is 106 */
-		rx_pwr_all = (((pofdm_buf->pwdb_all ) >> 1 )& 0x7f) -106;
+		rx_pwr_all = (((pofdm_buf->pwdb_all) >> 1) & 0x7f) - 106;
 		pwdb_all = rtl819x_query_rxpwrpercentage(rx_pwr_all);
 
 		pstats->RxPWDBAll = precord_stats->RxPWDBAll = pwdb_all;
@@ -5431,7 +5415,7 @@ static void rtl8192_query_rxphystatus(
 				if (i == 0)
 					/*  Fill value in RFD,
 					 * Get the first spatial stream only */
-					pstats->SignalQuality = 
+					pstats->SignalQuality =
 						precord_stats->SignalQuality =
 							(u8)(evm & 0xff);
 				pstats->RxMIMOSignalQuality[i] =
@@ -5459,10 +5443,7 @@ static void rtl8192_query_rxphystatus(
 		pstats->SignalStrength = precord_stats->SignalStrength =
 			(u8)(rtl819x_signal_scale_mapping((long)pwdb_all));
 		/* PWDB_ALL; */
-
-	}
-	else
-	{
+	} else {
 		/* pRfd->Status.SignalStrength =
 		 * pRecordRfd->Status.SignalStrength =
 		 * (u8)(SignalScaleMapping(total_rssi/=RF90_PATH_MAX));
@@ -5472,14 +5453,14 @@ static void rtl8192_query_rxphystatus(
 		if (rf_rx_num != 0)
 			pstats->SignalStrength = precord_stats->SignalStrength
 				= (u8)(rtl819x_signal_scale_mapping(
-					(long)(total_rssi/=rf_rx_num)));
+					(long)(total_rssi /= rf_rx_num)));
 	}
 }	/* QueryRxPhyStatus8190Pci */
 
 void
 rtl8192_record_rxdesc_forlateruse(
-	struct ieee80211_rx_stats *	psrc_stats,
-	struct ieee80211_rx_stats *	ptarget_stats
+	struct ieee80211_rx_stats *psrc_stats,
+	struct ieee80211_rx_stats *ptarget_stats
 )
 {
 	ptarget_stats->bIsAMPDU = psrc_stats->bIsAMPDU;
@@ -5489,28 +5470,28 @@ rtl8192_record_rxdesc_forlateruse(
 
 
 void TranslateRxSignalStuff819xUsb(struct sk_buff *skb,
-				   struct ieee80211_rx_stats * pstats,
+				   struct ieee80211_rx_stats *pstats,
 				   rx_drvinfo_819x_usb  *pdrvinfo)
 {
 	/* TODO: We must only check packet for current MAC address.
 	 * Not finish */
 	rtl8192_rx_info *info = (struct rtl8192_rx_info *)skb->cb;
-	struct net_device *dev=info->dev;
+	struct net_device *dev = info->dev;
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
 	bool bpacket_match_bssid, bpacket_toself;
-	bool bPacketBeacon=FALSE, bToSelfBA=FALSE;
+	bool bPacketBeacon = FALSE, bToSelfBA = FALSE;
 	static struct ieee80211_rx_stats  previous_stats;
 	struct ieee80211_hdr_3addr *hdr;	/* by amy */
-	u16 fc,type;
+	u16 fc, type;
 
 	/* Get Signal Quality for only RX data queue (but not command queue) */
 
-	u8* tmp_buf;
+	u8 *tmp_buf;
 	/* u16 tmp_buf_len = 0; */
-	u8  *praddr;
+	u8 *praddr;
 
 	/* Get MAC frame start address. */
-	tmp_buf = (u8*)skb->data;
+	tmp_buf = (u8 *)skb->data;
 	/* + get_rxpacket_shiftbytes_819xusb(pstats); */
 
 	hdr = (struct ieee80211_hdr_3addr *)tmp_buf;
@@ -5520,19 +5501,21 @@ void TranslateRxSignalStuff819xUsb(struct sk_buff *skb,
 
 	/* Check if the received packet is acceptabe. */
 	bpacket_match_bssid = ((IEEE80211_FTYPE_CTL != type) &&
-							(eqMacAddr(priv->ieee80211->current_network.bssid,  (fc & IEEE80211_FCTL_TODS)? hdr->addr1 : (fc & IEEE80211_FCTL_FROMDS )? hdr->addr2 : hdr->addr3))
-								 && (!pstats->bHwError) && (!pstats->bCRC)&& (!pstats->bICV));
-	bpacket_toself =  bpacket_match_bssid & (eqMacAddr(praddr, priv->ieee80211->dev->dev_addr));
-
-		if(WLAN_FC_GET_FRAMETYPE(fc)== IEEE80211_STYPE_BEACON)
-		{
+			(eqMacAddr(priv->ieee80211->current_network.bssid,
+			(fc & IEEE80211_FCTL_TODS) ? hdr->addr1 :
+			(fc & IEEE80211_FCTL_FROMDS) ? hdr->addr2 :
+			hdr->addr3)) && (!pstats->bHwError) &&
+			(!pstats->bCRC) && (!pstats->bICV));
+	bpacket_toself =  bpacket_match_bssid & (eqMacAddr(praddr,
+					priv->ieee80211->dev->dev_addr));
+
+		if (WLAN_FC_GET_FRAMETYPE(fc)== IEEE80211_STYPE_BEACON)
 			bPacketBeacon = true;
 			/* DbgPrint("Beacon 2, MatchBSSID = %d, ToSelf = %d \n"
-			 *		, bPacketMatchBSSID, bPacketToSelf); */
-		}
-		if(WLAN_FC_GET_FRAMETYPE(fc) == IEEE80211_STYPE_BLOCKACK)
-		{
-			if((eqMacAddr(praddr,dev->dev_addr)))
+			 *		, bPacketMatchBSSID, bPacketToSelf);
+			 */
+		if (WLAN_FC_GET_FRAMETYPE(fc) == IEEE80211_STYPE_BLOCKACK) {
+			if ((eqMacAddr(praddr, dev->dev_addr)))
 				bToSelfBA = true;
 				/* DbgPrint("BlockAck, MatchBSSID = %d,
 				 *	 ToSelf = %d \n", bPacketMatchBSSID,
-- 
1.6.3.3

