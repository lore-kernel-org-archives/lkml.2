Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab0FGIv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 04:51:28 -0400
Received: from outbound-mail04.westnet.com.au ([203.10.1.245]:54088 "EHLO
	outbound-mail04.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756589Ab0FGIvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 04:51:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Amw6AJdPDEw6B9wNPGdsb2JhbACHb5ZRDAEBAQE1LbBsjQ2FFwSDSA
X-IronPort-AV: E=Sophos;i="4.53,377,1272816000"; 
   d="scan'208";a="43896166"
From: Mike Gilks <mike.kernel@gilksonline.com>
To: gregkh@suse.de, mchehab@redhat.com, julia@diku.dk, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Gilks <mike.kernel@gilksonline.com>
Subject: [PATCH 2/3] staging: rtl8192u: fix checkpatch.pl issues to line 2800 Fix most problems pointed out by checkpatch.pl in file r8192U_core.c up to line 2800
Date: Mon,  7 Jun 2010 16:51:41 +0800
Message-Id: <1275900702-12417-2-git-send-email-mike.kernel@gilksonline.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1275900702-12417-1-git-send-email-mike.kernel@gilksonline.com>
References: <staging:rtl8192U.core-to line3000>
 <1275900702-12417-1-git-send-email-mike.kernel@gilksonline.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Gilks <mike.kernel@gilksonline.com>
---
 drivers/staging/rtl8192u/r8192U_core.c |   69 +++++++++++++++++---------------
 1 files changed, 37 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index ea9584b..b8ba05f 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -2622,13 +2622,13 @@ static int rtl8192_qos_handle_probe_response(struct r8192_priv *priv,
 }
 
 /* handle manage frame frame beacon and probe response */
-static int rtl8192_handle_beacon(struct net_device * dev,
-			      struct ieee80211_beacon * beacon,
-			      struct ieee80211_network * network)
+static int rtl8192_handle_beacon(struct net_device *dev,
+			      struct ieee80211_beacon *beacon,
+			      struct ieee80211_network *network)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 
-	rtl8192_qos_handle_probe_response(priv,1,network);
+	rtl8192_qos_handle_probe_response(priv, 1, network);
 	queue_delayed_work(priv->priv_wq, &priv->update_beacon_wq, 0);
 	return 0;
 
@@ -2650,29 +2650,30 @@ static int rtl8192_qos_association_resp(struct r8192_priv *priv,
 	if ((priv == NULL) || (network == NULL))
 		return ret;
 
-	if(priv->ieee80211->state !=IEEE80211_LINKED)
+	if (priv->ieee80211->state != IEEE80211_LINKED)
 		return ret;
 
 	if ((priv->ieee80211->iw_mode != IW_MODE_INFRA))
 		return ret;
 
 	spin_lock_irqsave(&priv->ieee80211->lock, flags);
-	if(network->flags & NETWORK_HAS_QOS_PARAMETERS) {
-		memcpy(&priv->ieee80211->current_network.qos_data.parameters,\
-			 &network->qos_data.parameters,\
+	if (network->flags & NETWORK_HAS_QOS_PARAMETERS) {
+		memcpy(&priv->ieee80211->current_network.qos_data.parameters,
+			&network->qos_data.parameters,
 			sizeof(struct ieee80211_qos_parameters));
 		priv->ieee80211->current_network.qos_data.active = 1;
 		 {
 			set_qos_param = 1;
 			/* update qos parameter for current network */
-			priv->ieee80211->current_network.qos_data.old_param_count = \
-				 priv->ieee80211->current_network.qos_data.param_count;
-			priv->ieee80211->current_network.qos_data.param_count = \
-				 network->qos_data.param_count;
+			priv->ieee80211->current_network.qos_data.
+					old_param_count = priv->ieee80211->
+					current_network.qos_data.param_count;
+			priv->ieee80211->current_network.qos_data.param_count =
+					network->qos_data.param_count;
 		}
 	} else {
-		memcpy(&priv->ieee80211->current_network.qos_data.parameters,\
-		       &def_qos_parameters, size);
+		memcpy(&priv->ieee80211->current_network.qos_data.parameters,
+			&def_qos_parameters, size);
 		priv->ieee80211->current_network.qos_data.active = 0;
 		priv->ieee80211->current_network.qos_data.supported = 0;
 		set_qos_param = 1;
@@ -2680,7 +2681,9 @@ static int rtl8192_qos_association_resp(struct r8192_priv *priv,
 
 	spin_unlock_irqrestore(&priv->ieee80211->lock, flags);
 
-	RT_TRACE(COMP_QOS, "%s: network->flags = %d,%d\n",__func__,network->flags ,priv->ieee80211->current_network.qos_data.active);
+	RT_TRACE(COMP_QOS, "%s: network->flags = %d,%d\n", __func__,
+		network->flags, priv->ieee80211->
+		current_network.qos_data.active);
 	if (set_qos_param == 1)
 		queue_work(priv->priv_wq, &priv->qos_activate);
 
@@ -2690,8 +2693,8 @@ static int rtl8192_qos_association_resp(struct r8192_priv *priv,
 
 
 static int rtl8192_handle_assoc_response(struct net_device *dev,
-				     struct ieee80211_assoc_response_frame *resp,
-				     struct ieee80211_network *network)
+			     struct ieee80211_assoc_response_frame *resp,
+			     struct ieee80211_network *network)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	rtl8192_qos_association_resp(priv, network);
@@ -2699,19 +2702,19 @@ static int rtl8192_handle_assoc_response(struct net_device *dev,
 }
 
 
-void rtl8192_update_ratr_table(struct net_device* dev)
+void rtl8192_update_ratr_table(struct net_device *dev)
 		/* POCTET_STRING	posLegacyRate, */
 		/* u8*			pMcsRate) */
 		/* PRT_WLAN_STA	pEntry) */
 {
-	struct r8192_priv* priv = ieee80211_priv(dev);
-	struct ieee80211_device* ieee = priv->ieee80211;
-	u8* pMcsRate = ieee->dot11HTOperationalRateSet;
+	struct r8192_priv *priv = ieee80211_priv(dev);
+	struct ieee80211_device *ieee = priv->ieee80211;
+	u8 *pMcsRate = ieee->dot11HTOperationalRateSet;
 	/* struct ieee80211_network *net = &ieee->current_network; */
 	u32 ratr_value = 0;
 	u8 rate_index = 0;
-	rtl8192_config_rate(dev, (u16*)(&ratr_value));
-	ratr_value |= (*(u16*)(pMcsRate)) << 12;
+	rtl8192_config_rate(dev, (u16 *)(&ratr_value));
+	ratr_value |= (*(u16 *)(pMcsRate)) << 12;
 	/* switch (net->mode) */
 	switch (ieee->mode) {
 	case IEEE_A:
@@ -2741,7 +2744,7 @@ void rtl8192_update_ratr_table(struct net_device* dev)
 	ratr_value &= 0x0FFFFFFF;
 	if (ieee->pHTInfo->bCurTxBW40MHz && ieee->pHTInfo->bCurShortGI40MHz) {
 		ratr_value |= 0x80000000;
-	}else if (!ieee->pHTInfo->bCurTxBW40MHz &&
+	} else if (!ieee->pHTInfo->bCurTxBW40MHz &&
 					ieee->pHTInfo->bCurShortGI20MHz){
 		ratr_value |= 0x80000000;
 	}
@@ -2769,18 +2772,20 @@ bool GetNmodeSupportBySecCfg8192(struct net_device *dev)
 				(0 == strcmp(crypt->ops->name, "WEP")));
 
 	/* simply judge  */
-	if(encrypt && (wpa_ie_len == 0)) {
+	if (encrypt && (wpa_ie_len == 0)) {
 		/* wep encryption, no N mode setting */
 		return false;
 	/* } else if((wpa_ie_len != 0)&&(memcmp(&(ieee->wpa_ie[14]),
 	 *							ccmp_ie,4))) {
 	 */
-	} else if((wpa_ie_len != 0)) {
+	} else if ((wpa_ie_len != 0)) {
 		/* parse pairwise key type */
 		/* if((pairwisekey = WEP40) || (pairwisekey = WEP104) ||
 		 *					(pairwisekey = TKIP))
 		 */
-		if (((ieee->wpa_ie[0] == 0xdd) && (!memcmp(&(ieee->wpa_ie[14]),ccmp_ie,4))) || ((ieee->wpa_ie[0] == 0x30) && (!memcmp(&ieee->wpa_ie[10],ccmp_rsn_ie, 4))))
+		if (((ieee->wpa_ie[0] == 0xdd) && (!memcmp(&(ieee->wpa_ie[14]),
+				ccmp_ie, 4))) || ((ieee->wpa_ie[0] == 0x30) &&
+				(!memcmp(&ieee->wpa_ie[10], ccmp_rsn_ie, 4))))
 			return true;
 		else
 			return false;
@@ -2791,13 +2796,13 @@ bool GetNmodeSupportBySecCfg8192(struct net_device *dev)
 	return true;
 }
 
-bool GetHalfNmodeSupportByAPs819xUsb(struct net_device* dev)
+bool GetHalfNmodeSupportByAPs819xUsb(struct net_device *dev)
 {
-	bool			Reval;
-	struct r8192_priv* priv = ieee80211_priv(dev);
-	struct ieee80211_device* ieee = priv->ieee80211;
+	bool	Reval;
+	struct	r8192_priv *priv = ieee80211_priv(dev);
+	struct	ieee80211_device *ieee = priv->ieee80211;
 
-	if(ieee->bHalfWirelessN24GMode == true)
+	if (ieee->bHalfWirelessN24GMode == true)
 		Reval = true;
 	else
 		Reval =  false;
-- 
1.6.3.3

