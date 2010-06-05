Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253Ab0FEKho (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 06:37:44 -0400
Received: from outbound-mail03.westnet.com.au ([203.10.1.244]:3129 "EHLO
	outbound-mail03.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933183Ab0FEKge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 06:36:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlJPAPbECUw6B9wNPGdsb2JhbACHb5ZlDAEBAQE1LbAkjUSFFwSDSA
X-IronPort-AV: E=Sophos;i="4.53,366,1272816000"; 
   d="scan'208";a="77635039"
From: Mike Gilks <mike.kernel@gilksonline.com>
To: gregkh@suse.de, mchehab@redhat.com, julia@diku.dk, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Gilks <mike.kernel@gilksonline.com>
Subject: [PATCH 11/12] staging: rtl8192u: remove C99 comments in file r8192U_core.c Patch to remove C99 style comments from file r8192U_core.c Completed until line 5072
Date: Sat,  5 Jun 2010 18:36:26 +0800
Message-Id: <1275734187-26583-12-git-send-email-mike.kernel@gilksonline.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1275734187-26583-11-git-send-email-mike.kernel@gilksonline.com>
References: <1275734187-26583-1-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-2-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-3-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-4-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-5-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-6-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-7-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-8-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-9-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-10-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-11-git-send-email-mike.kernel@gilksonline.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Gilks <mike.kernel@gilksonline.com>
---
 drivers/staging/rtl8192u/r8192U_core.c |  116 +++++++++++++++++--------------
 1 files changed, 64 insertions(+), 52 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index d4498fe..895f748 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -4683,13 +4683,13 @@ void UpdateRxPktTimeStamp8190 (struct net_device *dev, struct ieee80211_rx_stats
 	}
 }
 
-//by amy 080606
+/* by amy 080606 */
 
-long rtl819x_translate_todbm(u8 signal_strength_index	)// 0-100 index.
+long rtl819x_translate_todbm(u8 signal_strength_index	)/* 0-100 index. */
 {
 	long	signal_power; // in dBm.
 
-	// Translate to dBm (x=0.5y-95).
+	/* Translate to dBm (x=0.5y-95). */
 	signal_power = (long)((signal_strength_index + 1) >> 1);
 	signal_power -= 95;
 
@@ -4698,15 +4698,16 @@ long rtl819x_translate_todbm(u8 signal_strength_index	)// 0-100 index.
 
 
 /* 2008/01/22 MH We can not delcare RSSI/EVM total value of sliding window to
-    be a local static. Otherwise, it may increase when we return from S3/S4. The
-    value will be kept in memory or disk. We must delcare the value in adapter
-    and it will be reinitialized when return from S3/S4. */
+ * be a local static. Otherwise, it may increase when we return from S3/S4. The
+ * value will be kept in memory or disk. We must delcare the value in adapter
+ * and it will be reinitialized when return from S3/S4.
+ */
 void rtl8192_process_phyinfo(struct r8192_priv * priv,u8* buffer, struct ieee80211_rx_stats * pprevious_stats, struct ieee80211_rx_stats * pcurrent_stats)
 {
 	bool bcheck = false;
 	u8	rfpath;
 	u32	nspatial_stream, tmp_val;
-	//u8	i;
+	/* u8	i; */
 	static u32 slide_rssi_index=0, slide_rssi_statistics=0;
 	static u32 slide_evm_index=0, slide_evm_statistics=0;
 	static u32 last_rssi=0, last_evm=0;
@@ -4721,14 +4722,14 @@ void rtl8192_process_phyinfo(struct r8192_priv * priv,u8* buffer, struct ieee802
 	sc = le16_to_cpu(hdr->seq_ctl);
 	frag = WLAN_GET_SEQ_FRAG(sc);
 	seq = WLAN_GET_SEQ_SEQ(sc);
-	//cosa add 04292008 to record the sequence number
+	/* cosa add 04292008 to record the sequence number */
 	pcurrent_stats->Seq_Num = seq;
-	//
-	// Check whether we should take the previous packet into accounting
-	//
+
+	/* Check whether we should take the previous packet into accounting */
+
 	if(!pprevious_stats->bIsAMPDU)
 	{
-		// if previous packet is not aggregated packet
+		/* if previous packet is not aggregated packet */
 		bcheck = true;
 	}else
 	{
@@ -4747,13 +4748,13 @@ void rtl8192_process_phyinfo(struct r8192_priv * priv,u8* buffer, struct ieee802
 	if(slide_rssi_index >= PHY_RSSI_SLID_WIN_MAX)
 		slide_rssi_index = 0;
 
-	// <1> Showed on UI for user, in dbm
+	/* <1> Showed on UI for user, in dbm */
 	tmp_val = priv->stats.slide_rssi_total/slide_rssi_statistics;
 	priv->stats.signal_strength = rtl819x_translate_todbm((u8)tmp_val);
 	pcurrent_stats->rssi = priv->stats.signal_strength;
-	//
-	// If the previous packet does not match the criteria, neglect it
-	//
+
+	/* If the previous packet does not match the criteria, neglect it */
+
 	if(!pprevious_stats->bPacketMatchBSSID)
 	{
 		if(!pprevious_stats->bToSelfBA)
@@ -4764,18 +4765,21 @@ void rtl8192_process_phyinfo(struct r8192_priv * priv,u8* buffer, struct ieee802
 		return;
 
 
-	//rtl8190_process_cck_rxpathsel(priv,pprevious_stats);//only rtl8190 supported
+	/* rtl8190_process_cck_rxpathsel(priv,pprevious_stats); */
+	/* only rtl8190 supported */
+
+
+	/* Check RSSI */
 
-	//
-	// Check RSSI
-	//
 	priv->stats.num_process_phyinfo++;
 
 	/* record the general signal strength to the sliding window. */
 
 
-	// <2> Showed on UI for engineering
-	// hardware does not provide rssi information for each rf path in CCK
+	/* <2> Showed on UI for engineering */
+	/* hardware does not provide rssi information for each rf path
+	 *							 in CCK
+	 */
 	if(!pprevious_stats->bIsCCK && (pprevious_stats->bPacketToSelf || pprevious_stats->bToSelfBA))
 	{
 		for (rfpath = RF90_PATH_A; rfpath < priv->NumTotalRFPath; rfpath++)
@@ -4783,11 +4787,11 @@ void rtl8192_process_phyinfo(struct r8192_priv * priv,u8* buffer, struct ieee802
 		     if (!rtl8192_phy_CheckIsLegalRFPath(priv->ieee80211->dev, rfpath))
 				 continue;
 
-			//Fixed by Jacken 2008-03-20
+			/* Fixed by Jacken 2008-03-20 */
 			if(priv->stats.rx_rssi_percentage[rfpath] == 0)
 			{
 				priv->stats.rx_rssi_percentage[rfpath] = pprevious_stats->RxMIMOSignalStrength[rfpath];
-				//DbgPrint("MIMO RSSI initialize \n");
+				/* DbgPrint("MIMO RSSI initialize \n"); */
 			}
 			if(pprevious_stats->RxMIMOSignalStrength[rfpath]  > priv->stats.rx_rssi_percentage[rfpath])
 			{
@@ -4806,28 +4810,34 @@ void rtl8192_process_phyinfo(struct r8192_priv * priv,u8* buffer, struct ieee802
 		}
 	}
 
+	/*  Check PWDB. */
 
-	//
-	// Check PWDB.
-	//
 	RT_TRACE(COMP_RXDESC, "Smooth %s PWDB = %d\n",
 				pprevious_stats->bIsCCK? "CCK": "OFDM",
 				pprevious_stats->RxPWDBAll);
 
 	if(pprevious_stats->bPacketBeacon)
 	{
-/* record the beacon pwdb to the sliding window. */
+		/* record the beacon pwdb to the sliding window. */
 		if(slide_beacon_adc_pwdb_statistics++ >= PHY_Beacon_RSSI_SLID_WIN_MAX)
 		{
 			slide_beacon_adc_pwdb_statistics = PHY_Beacon_RSSI_SLID_WIN_MAX;
 			last_beacon_adc_pwdb = priv->stats.Slide_Beacon_pwdb[slide_beacon_adc_pwdb_index];
 			priv->stats.Slide_Beacon_Total -= last_beacon_adc_pwdb;
-			//DbgPrint("slide_beacon_adc_pwdb_index = %d, last_beacon_adc_pwdb = %d, Adapter->RxStats.Slide_Beacon_Total = %d\n",
-			//	slide_beacon_adc_pwdb_index, last_beacon_adc_pwdb, Adapter->RxStats.Slide_Beacon_Total);
+			/* DbgPrint("slide_beacon_adc_pwdb_index = %d, "
+			 *		"last_beacon_adc_pwdb = %d, Adapter->"
+			 *		"RxStats.Slide_Beacon_Total = %d\n",
+			 *		slide_beacon_adc_pwdb_index,
+			 *		last_beacon_adc_pwdb, Adapter->
+			 *		RxStats.Slide_Beacon_Total);
+			 */
 		}
 		priv->stats.Slide_Beacon_Total += pprevious_stats->RxPWDBAll;
 		priv->stats.Slide_Beacon_pwdb[slide_beacon_adc_pwdb_index] = pprevious_stats->RxPWDBAll;
-		//DbgPrint("slide_beacon_adc_pwdb_index = %d, pPreviousRfd->Status.RxPWDBAll = %d\n", slide_beacon_adc_pwdb_index, pPreviousRfd->Status.RxPWDBAll);
+		/* DbgPrint("slide_beacon_adc_pwdb_index = %d, pPreviousRfd->"
+		 *	"Status.RxPWDBAll = %d\n", slide_beacon_adc_pwdb_index,
+		 *			pPreviousRfd->Status.RxPWDBAll);
+		 */
 		slide_beacon_adc_pwdb_index++;
 		if(slide_beacon_adc_pwdb_index >= PHY_Beacon_RSSI_SLID_WIN_MAX)
 			slide_beacon_adc_pwdb_index = 0;
@@ -4843,10 +4853,10 @@ void rtl8192_process_phyinfo(struct r8192_priv * priv,u8* buffer, struct ieee802
 
 	if(pprevious_stats->bPacketToSelf || pprevious_stats->bPacketBeacon || pprevious_stats->bToSelfBA)
 	{
-		if(priv->undecorated_smoothed_pwdb < 0)	// initialize
+		if(priv->undecorated_smoothed_pwdb < 0)	/* initialize */
 		{
 			priv->undecorated_smoothed_pwdb = pprevious_stats->RxPWDBAll;
-			//DbgPrint("First pwdb initialize \n");
+			/* DbgPrint("First pwdb initialize \n"); */
 		}
 		if(pprevious_stats->RxPWDBAll > (u32)priv->undecorated_smoothed_pwdb)
 		{
@@ -4864,9 +4874,8 @@ void rtl8192_process_phyinfo(struct r8192_priv * priv,u8* buffer, struct ieee802
 
 	}
 
-	//
-	// Check EVM
-	//
+
+	/* Check EVM */
 	/* record the general EVM to the sliding window. */
 	if(pprevious_stats->SignalQuality == 0)
 	{
@@ -4886,21 +4895,23 @@ void rtl8192_process_phyinfo(struct r8192_priv * priv,u8* buffer, struct ieee802
 			if(slide_evm_index >= PHY_RSSI_SLID_WIN_MAX)
 				slide_evm_index = 0;
 
-			// <1> Showed on UI for user, in percentage.
+			/* <1> Showed on UI for user, in percentage. */
 			tmp_val = priv->stats.slide_evm_total/slide_evm_statistics;
 			priv->stats.signal_quality = tmp_val;
-			//cosa add 10/11/2007, Showed on UI for user in Windows Vista, for Link quality.
+			/* cosa add 10/11/2007, Showed on UI for user in Windows Vista, for Link quality. */
 			priv->stats.last_signal_strength_inpercent = tmp_val;
 		}
 
-		// <2> Showed on UI for engineering
+		/* <2> Showed on UI for engineering */
 		if(pprevious_stats->bPacketToSelf || pprevious_stats->bPacketBeacon || pprevious_stats->bToSelfBA)
 		{
-			for(nspatial_stream = 0; nspatial_stream<2 ; nspatial_stream++) // 2 spatial stream
+			for(nspatial_stream = 0; nspatial_stream<2 ; nspatial_stream++)
+				/* 2 spatial stream */
 			{
 				if(pprevious_stats->RxMIMOSignalQuality[nspatial_stream] != -1)
 				{
-					if(priv->stats.rx_evm_percentage[nspatial_stream] == 0)	// initialize
+					if(priv->stats.rx_evm_percentage[nspatial_stream] == 0)
+						/* initialize */
 					{
 						priv->stats.rx_evm_percentage[nspatial_stream] = pprevious_stats->RxMIMOSignalQuality[nspatial_stream];
 					}
@@ -4969,11 +4980,11 @@ rtl819x_evm_dbtopercentage(
 		ret_val = 100;
     return(ret_val);
 }
-//
-//	Description:
-// 	We want good-looking for signal strength/quality
-//	2007/7/19 01:09, by cosa.
-//
+
+	/* Description:
+	 *We want good-looking for signal strength/quality
+	 *2007/7/19 01:09, by cosa.
+	 */
 long
 rtl819x_signal_scale_mapping(
 	long currsig
@@ -4981,7 +4992,7 @@ rtl819x_signal_scale_mapping(
 {
 	long retsig;
 
-	// Step 1. Scale mapping.
+	/* Step 1. Scale mapping. */
 	if(currsig >= 61 && currsig <= 100)
 	{
 		retsig = 90 + ((currsig - 60) / 4);
@@ -5037,18 +5048,19 @@ static void rtl8192_query_rxphystatus(
 	bool bToSelfBA
 	)
 {
-	//PRT_RFD_STATUS		pRtRfdStatus = &(pRfd->Status);
+	/* PRT_RFD_STATUS		pRtRfdStatus = &(pRfd->Status); */
 	phy_sts_ofdm_819xusb_t*	pofdm_buf;
 	phy_sts_cck_819xusb_t	*	pcck_buf;
 	phy_ofdm_rx_status_rxsc_sgien_exintfflag* prxsc;
 	u8				*prxpkt;
 	u8				i, max_spatial_stream, tmp_rxsnr, tmp_rxevm, rxsc_sgien_exflg;
 	char				rx_pwr[4], rx_pwr_all=0;
-	//long				rx_avg_pwr = 0;
+	/* long				rx_avg_pwr = 0; */
 	char				rx_snrX, rx_evmX;
 	u8				evm, pwdb_all;
-	u32				RSSI, total_rssi=0;//, total_evm=0;
-//	long				signal_strength_index = 0;
+	u32				RSSI, total_rssi=0;
+						/* , total_evm=0; */
+	/* long				signal_strength_index = 0; */
 	u8				is_cck_rate=0;
 	u8				rf_rx_num = 0;
 
@@ -5057,7 +5069,7 @@ static void rtl8192_query_rxphystatus(
 
 	is_cck_rate = rx_hal_is_cck_rate(pdrvinfo);
 
-	// Record it for next packet processing
+	/* Record it for next packet processing */
 	memset(precord_stats, 0, sizeof(struct ieee80211_rx_stats));
 	pstats->bPacketMatchBSSID = precord_stats->bPacketMatchBSSID = bpacket_match_bssid;
 	pstats->bPacketToSelf = precord_stats->bPacketToSelf = bpacket_toself;
-- 
1.6.3.3

