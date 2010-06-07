Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab0FGIvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 04:51:22 -0400
Received: from outbound-mail04.westnet.com.au ([203.10.1.245]:54088 "EHLO
	outbound-mail04.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751979Ab0FGIvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 04:51:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Amw6AJdPDEw6B9wNPGdsb2JhbACHb5ZRDAEBAQE1LbBsjQ2FFwSDSA
X-IronPort-AV: E=Sophos;i="4.53,377,1272816000"; 
   d="scan'208";a="43896145"
From: Mike Gilks <mike.kernel@gilksonline.com>
To: gregkh@suse.de, mchehab@redhat.com, julia@diku.dk, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Gilks <mike.kernel@gilksonline.com>
Subject: [PATCH 1/3] staging: rtl8192u: fix checkpatch.pl issues to line 2600 staging: rtl8192u: Fix most problems pointed out by checkpatch.pl in file r8192U_core.c up to line 2500
Date: Mon,  7 Jun 2010 16:51:40 +0800
Message-Id: <1275900702-12417-1-git-send-email-mike.kernel@gilksonline.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <staging:rtl8192U.core-to line3000>
References: <staging:rtl8192U.core-to line3000>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Gilks <mike.kernel@gilksonline.com>
---
 drivers/staging/rtl8192u/r8192U_core.c |   57 +++++++++++++++++++-------------
 1 files changed, 34 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 66adac3..ea9584b 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -2514,27 +2514,31 @@ static struct ieee80211_qos_parameters def_qos_parameters = {
 };
 
 
-void rtl8192_update_beacon(struct work_struct * work)
+void rtl8192_update_beacon(struct work_struct *work)
 {
-        struct r8192_priv *priv = container_of(work, struct r8192_priv, update_beacon_wq.work);
-        struct net_device *dev = priv->ieee80211->dev;
- 	struct ieee80211_device* ieee = priv->ieee80211;
-	struct ieee80211_network* net = &ieee->current_network;
+	struct r8192_priv *priv = container_of(work, struct r8192_priv,
+						update_beacon_wq.work);
+	struct net_device *dev = priv->ieee80211->dev;
+	struct ieee80211_device *ieee = priv->ieee80211;
+	struct ieee80211_network *net = &ieee->current_network;
 
 	if (ieee->pHTInfo->bCurrentHTSupport)
 		HTUpdateSelfAndPeerSetting(ieee, net);
-	ieee->pHTInfo->bCurrentRT2RTLongSlotTime = net->bssht.bdRT2RTLongSlotTime;
+	ieee->pHTInfo->bCurrentRT2RTLongSlotTime =
+						net->bssht.bdRT2RTLongSlotTime;
 	rtl8192_update_cap(dev, net->capability);
 }
 /*
 * background support to run QoS activate functionality
 */
-int WDCAPARA_ADD[] = {EDCAPARA_BE,EDCAPARA_BK,EDCAPARA_VI,EDCAPARA_VO};
-void rtl8192_qos_activate(struct work_struct * work)
+int WDCAPARA_ADD[] = {EDCAPARA_BE, EDCAPARA_BK, EDCAPARA_VI, EDCAPARA_VO};
+void rtl8192_qos_activate(struct work_struct *work)
 {
-	struct r8192_priv *priv = container_of(work, struct r8192_priv, qos_activate);
+	struct r8192_priv *priv = container_of(work,
+					struct r8192_priv, qos_activate);
 	struct net_device *dev = priv->ieee80211->dev;
-	struct ieee80211_qos_parameters *qos_parameters = &priv->ieee80211->current_network.qos_data.parameters;
+	struct ieee80211_qos_parameters *qos_parameters =
+			&priv->ieee80211->current_network.qos_data.parameters;
 	u8 mode = priv->ieee80211->current_network.mode;
 	/* u32 size = sizeof(struct ieee80211_qos_parameters); */
 	u8  u1bAIFS;
@@ -2545,19 +2549,25 @@ void rtl8192_qos_activate(struct work_struct * work)
 		return;
 
        mutex_lock(&priv->mutex);
-	if(priv->ieee80211->state != IEEE80211_LINKED)
+	if (priv->ieee80211->state != IEEE80211_LINKED)
 		goto success;
-	RT_TRACE(COMP_QOS,"qos active process with associate response received\n");
+	RT_TRACE(COMP_QOS, "qos active process with associate response"
+								" received\n");
 	/* It better set slot time at first */
-	/* For we just support b/g mode at present, let the slot time at 9/20 selection */
+	/* For we just support b/g mode at present, let the slot time at 9/20
+	 * selection */
 	/* update the ac parameter to related registers */
-	for(i = 0; i <  QOS_QUEUE_NUM; i++) {
+	for (i = 0; i <  QOS_QUEUE_NUM; i++) {
 		/* Mode G/A: slotTimeTimer = 9; Mode B: 20 */
-		u1bAIFS = qos_parameters->aifs[i] * ((mode&(IEEE_G|IEEE_N_24G)) ?9:20) + aSifsTime;
-		u4bAcParam = ((((u32)(qos_parameters->tx_op_limit[i]))<< AC_PARAM_TXOP_LIMIT_OFFSET)|
-				(((u32)(qos_parameters->cw_max[i]))<< AC_PARAM_ECW_MAX_OFFSET)|
-				(((u32)(qos_parameters->cw_min[i]))<< AC_PARAM_ECW_MIN_OFFSET)|
-				((u32)u1bAIFS << AC_PARAM_AIFS_OFFSET));
+		u1bAIFS = qos_parameters->aifs[i] * ((mode&(IEEE_G|IEEE_N_24G))
+							? 9 : 20) + aSifsTime;
+		u4bAcParam = ((((u32)(qos_parameters->tx_op_limit[i])) <<
+				AC_PARAM_TXOP_LIMIT_OFFSET) | (((u32)
+				(qos_parameters->cw_max[i])) <<
+				AC_PARAM_ECW_MAX_OFFSET) | (((u32)
+				(qos_parameters->cw_min[i])) <<
+				AC_PARAM_ECW_MIN_OFFSET) | ((u32)u1bAIFS <<
+				AC_PARAM_AIFS_OFFSET));
 
 		write_nic_dword(dev, WDCAPARA_ADD[i], u4bAcParam);
 		/* write_nic_dword(dev, WDCAPARA_ADD[i], 0x005e4332); */
@@ -2574,7 +2584,7 @@ static int rtl8192_qos_handle_probe_response(struct r8192_priv *priv,
 	int ret = 0;
 	u32 size = sizeof(struct ieee80211_qos_parameters);
 
-	if(priv->ieee80211->state !=IEEE80211_LINKED)
+	if (priv->ieee80211->state != IEEE80211_LINKED)
 		return ret;
 
 	if ((priv->ieee80211->iw_mode != IW_MODE_INFRA))
@@ -2592,16 +2602,17 @@ static int rtl8192_qos_handle_probe_response(struct r8192_priv *priv,
 			network->qos_data.old_param_count =
 				network->qos_data.param_count;
 			queue_work(priv->priv_wq, &priv->qos_activate);
-			RT_TRACE (COMP_QOS, "QoS parameters change call "
+			RT_TRACE(COMP_QOS, "QoS parameters change call "
 					"qos_activate\n");
 		}
 	} else {
-		memcpy(&priv->ieee80211->current_network.qos_data.parameters,\
+		memcpy(&priv->ieee80211->current_network.qos_data.parameters,
 		       &def_qos_parameters, size);
 
 		if ((network->qos_data.active == 1) && (active_network == 1)) {
 			queue_work(priv->priv_wq, &priv->qos_activate);
-			RT_TRACE(COMP_QOS, "QoS was disabled call qos_activate \n");
+			RT_TRACE(COMP_QOS, "QoS was disabled call qos_activate"
+				"\n");
 		}
 		network->qos_data.active = 0;
 		network->qos_data.supported = 0;
-- 
1.6.3.3

