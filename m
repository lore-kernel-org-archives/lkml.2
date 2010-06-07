Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab0FGIvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 04:51:31 -0400
Received: from outbound-mail04.westnet.com.au ([203.10.1.245]:54088 "EHLO
	outbound-mail04.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756637Ab0FGIv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 04:51:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Amw6AJdPDEw6B9wNPGdsb2JhbACHb5ZRDAEBAQE1LbBsjQ2FFwSDSA
X-IronPort-AV: E=Sophos;i="4.53,377,1272816000"; 
   d="scan'208";a="43896176"
From: Mike Gilks <mike.kernel@gilksonline.com>
To: gregkh@suse.de, mchehab@redhat.com, julia@diku.dk, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Gilks <mike.kernel@gilksonline.com>
Subject: [PATCH 3/3] staging: rtl8192u: fix checkpatch.pl issues to line 3000 Fix most problems pointed out by checkpatch.pl in file r8192U_core.c up to line 3000
Date: Mon,  7 Jun 2010 16:51:42 +0800
Message-Id: <1275900702-12417-3-git-send-email-mike.kernel@gilksonline.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1275900702-12417-2-git-send-email-mike.kernel@gilksonline.com>
References: <staging:rtl8192U.core-to line3000>
 <1275900702-12417-1-git-send-email-mike.kernel@gilksonline.com>
 <1275900702-12417-2-git-send-email-mike.kernel@gilksonline.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Gilks <mike.kernel@gilksonline.com>
---
 drivers/staging/rtl8192u/r8192U_core.c |   54 +++++++++++++++++--------------
 1 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index b8ba05f..0f852ad 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -2810,26 +2810,26 @@ bool GetHalfNmodeSupportByAPs819xUsb(struct net_device *dev)
 	return Reval;
 }
 
-void rtl8192_refresh_supportrate(struct r8192_priv* priv)
+void rtl8192_refresh_supportrate(struct r8192_priv *priv)
 {
-	struct ieee80211_device* ieee = priv->ieee80211;
+	struct ieee80211_device *ieee = priv->ieee80211;
 	/* we donot consider set support rate for ABG mode,
 	 * only HT MCS rate is set here.
 	 */
-	if (ieee->mode == WIRELESS_MODE_N_24G || ieee->mode == WIRELESS_MODE_N_5G)
-	{
-		memcpy(ieee->Regdot11HTOperationalRateSet, ieee->RegHTSuppRateSet, 16);
+	if (ieee->mode == WIRELESS_MODE_N_24G ||
+		ieee->mode == WIRELESS_MODE_N_5G) {
+		memcpy(ieee->Regdot11HTOperationalRateSet,
+			ieee->RegHTSuppRateSet, 16);
 		/* RT_DEBUG_DATA(COMP_INIT, ieee->RegHTSuppRateSet, 16); */
 		/* RT_DEBUG_DATA(COMP_INIT,
 		 *		 ieee->Regdot11HTOperationalRateSet, 16);
 		 */
-	}
-	else
+	} else
 		memset(ieee->Regdot11HTOperationalRateSet, 0, 16);
 	return;
 }
 
-u8 rtl8192_getSupportedWireleeMode(struct net_device*dev)
+u8 rtl8192_getSupportedWireleeMode(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	u8 ret = 0;
@@ -2876,11 +2876,13 @@ void rtl8192_SetWirelessMode(struct net_device *dev, u8 wireless_mode)
 	/* TODO: this function doesn't work well at this time,
 	 * we should wait for FPGA
 	 */
-	ActUpdateChannelAccessSetting( pAdapter, pHalData->CurrentWirelessMode, &pAdapter->MgntInfo.Info8185.ChannelAccessSetting );
+	ActUpdateChannelAccessSetting(pAdapter, pHalData->CurrentWirelessMode,
+			&pAdapter->MgntInfo.Info8185.ChannelAccessSetting);
 #endif
 	priv->ieee80211->mode = wireless_mode;
 
-	if ((wireless_mode == WIRELESS_MODE_N_24G) ||  (wireless_mode == WIRELESS_MODE_N_5G))
+	if ((wireless_mode == WIRELESS_MODE_N_24G) ||
+				(wireless_mode == WIRELESS_MODE_N_5G))
 		priv->ieee80211->pHTInfo->bEnableHT = 1;
 	else
 		priv->ieee80211->pHTInfo->bEnableHT = 0;
@@ -2889,7 +2891,7 @@ void rtl8192_SetWirelessMode(struct net_device *dev, u8 wireless_mode)
 
 }
 /* init priv variables here. only non_zero value should be initialized here. */
-static void rtl8192_init_priv_variable(struct net_device* dev)
+static void rtl8192_init_priv_variable(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	u8 i;
@@ -2897,13 +2899,13 @@ static void rtl8192_init_priv_variable(struct net_device* dev)
 	priv->chan = 1;					/* set to channel 1 */
 	priv->ieee80211->mode = WIRELESS_MODE_AUTO;	/* SET AUTO */
 	priv->ieee80211->iw_mode = IW_MODE_INFRA;
-	priv->ieee80211->ieee_up=0;
+	priv->ieee80211->ieee_up = 0;
 	priv->retry_rts = DEFAULT_RETRY_RTS;
 	priv->retry_data = DEFAULT_RETRY_DATA;
 	priv->ieee80211->rts = DEFAULT_RTS_THRESHOLD;
 	priv->ieee80211->rate = 110;			/* 11 mbps */
 	priv->ieee80211->short_slot = 1;
-	priv->promisc = (dev->flags & IFF_PROMISC) ? 1:0;
+	priv->promisc = (dev->flags & IFF_PROMISC) ? 1 : 0;
 	priv->CckPwEnl = 6;
 	/* for silent reset */
 	priv->IrpPendingCount = 1;
@@ -2914,7 +2916,8 @@ static void rtl8192_init_priv_variable(struct net_device* dev)
 
 	priv->ieee80211->FwRWRF = 0;
 	/* we don't use FW read/write RF until stable firmware is available. */
-	priv->ieee80211->current_network.beacon_interval = DEFAULT_BEACONINTERVAL;
+	priv->ieee80211->current_network.beacon_interval =
+						DEFAULT_BEACONINTERVAL;
 	priv->ieee80211->iw_mode = IW_MODE_INFRA;
 	priv->ieee80211->softmac_features  = IEEE_SOFTMAC_SCAN |
 		IEEE_SOFTMAC_ASSOCIATE | IEEE_SOFTMAC_PROBERQ |
@@ -2922,7 +2925,8 @@ static void rtl8192_init_priv_variable(struct net_device* dev)
 		IEEE_SOFTMAC_BEACONS;
 		/* added by amy 080604 | IEEE_SOFTMAC_SINGLE_QUEUE; */
 	priv->ieee80211->active_scan = 1;
-	priv->ieee80211->modulation = IEEE80211_CCK_MODULATION | IEEE80211_OFDM_MODULATION;
+	priv->ieee80211->modulation = IEEE80211_CCK_MODULATION |
+					IEEE80211_OFDM_MODULATION;
 	priv->ieee80211->host_encrypt = 1;
 	priv->ieee80211->host_decrypt = 1;
 	priv->ieee80211->start_send_beacons = NULL;
@@ -2948,14 +2952,14 @@ static void rtl8192_init_priv_variable(struct net_device* dev)
 	priv->ieee80211->handle_beacon = rtl8192_handle_beacon;
 	/* added by david */
 	priv->ieee80211->GetNmodeSupportBySecCfg = GetNmodeSupportBySecCfg8192;
-	priv->ieee80211->GetHalfNmodeSupportByAPsHandler = GetHalfNmodeSupportByAPs819xUsb;
+	priv->ieee80211->GetHalfNmodeSupportByAPsHandler =
+					GetHalfNmodeSupportByAPs819xUsb;
 	priv->ieee80211->SetWirelessMode = rtl8192_SetWirelessMode;
 	/* added by amy */
 	priv->ieee80211->InitialGainHandler = InitialGain819xUsb;
 	priv->card_type = USB;
 #ifdef TO_DO_LIST
-	if(Adapter->bInHctTest)
-	{
+	if (Adapter->bInHctTest) {
 		pHalData->ShortRetryLimit = 7;
 		pHalData->LongRetryLimit = 7;
 	}
@@ -2967,7 +2971,7 @@ static void rtl8192_init_priv_variable(struct net_device* dev)
 	priv->EarlyRxThreshold = 7;
 	priv->enable_gpio0 = 0;
 	priv->TransmitConfig =
-	/* 	TCR_DurProcMode | */
+	/*	TCR_DurProcMode | */
 		/* for RTL8185B, duration setting by HW */
 	/* ?	TCR_DISReqQsize | */
 		(TCR_MXDMA_2048<<TCR_MXDMA_OFFSET)|
@@ -2976,12 +2980,12 @@ static void rtl8192_init_priv_variable(struct net_device* dev)
 		/* Short retry limit */
 		(priv->LongRetryLimit<<TCR_LRL_OFFSET) |
 		/* Long retry limit */
-		(false ? TCR_SAT: 0);
+		(false ? TCR_SAT : 0);
 		/* FALSE: HW provies PLCP length and LENGEXT, TURE:
 		 * SW proiveds them
 		 */
 #ifdef TO_DO_LIST
-	if(Adapter->bInHctTest)
+	if (Adapter->bInHctTest)
 		pHalData->ReceiveConfig	=	pHalData->CSMethod |
 						RCR_AMF | RCR_ADF |
 						/* RCR_AAP | */
@@ -3002,17 +3006,19 @@ static void rtl8192_init_priv_variable(struct net_device* dev)
 						/* Max DMA Burst Size per Rx
 						 * DMA Burst, 7: unlimited.
 						 */
-						(pHalData->EarlyRxThreshold<<RCR_FIFO_OFFSET) |
+						(pHalData->EarlyRxThreshold <<
+							RCR_FIFO_OFFSET) |
 						/* Rx FIFO Threshold, 7:
 						 * No Rx threshold.
 						 */
-						(pHalData->EarlyRxThreshold == 7 ? RCR_OnlyErlPkt:0);
+						(pHalData->EarlyRxThreshold ==
+						7 ? RCR_OnlyErlPkt : 0);
 	else
 
 #endif
 	priv->ReceiveConfig	=
 		RCR_AMF | RCR_ADF |		/* accept management/data */
-		RCR_ACF |			
+		RCR_ACF |
 		/* accept control frame for SW AP needs PS-poll,
 		 * 2005.07.07, by rcnjko.
 		 */
-- 
1.6.3.3

