Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503Ab0FEOOg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 10:14:36 -0400
Received: from outbound-mail02.westnet.com.au ([203.10.1.243]:9509 "EHLO
	outbound-mail02.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933457Ab0FEOMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 10:12:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlJPAA74CUw6B9wNPGdsb2JhbACHb5ZlDAEBAQE1LbAXjTGFFwSDSA
X-IronPort-AV: E=Sophos;i="4.53,366,1272816000"; 
   d="scan'208";a="82293883"
From: Mike Gilks <mike.kernel@gilksonline.com>
To: gregkh@suse.de, mchehab@redhat.com, julia@diku.dk, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Gilks <kernel.online@gilksonline.com>
Subject: [PATCH 05/13] checkpatch.pl issues removed to line 296
Date: Sat,  5 Jun 2010 22:12:29 +0800
Message-Id: <1275747158-31375-6-git-send-email-mike.kernel@gilksonline.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1275747158-31375-5-git-send-email-mike.kernel@gilksonline.com>
References: <1275747158-31375-1-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-2-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-3-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-4-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-5-git-send-email-mike.kernel@gilksonline.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Gilks <kernel.online@gilksonline.com>

---
 drivers/staging/rtl8192u/r8192U_core.c |   47 ++++++++++++++++++-------------
 1 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index ba9df82..7bfbbfe 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -202,7 +202,7 @@ static CHANNEL_LIST ChannelPlan[] = {
 
 static void rtl819x_set_channel_map(u8 channel_plan, struct r8192_priv *priv)
 {
-	int i, max_chan =- 1, min_chan = -1;
+	int i, max_chan = -1, min_chan = -1;
 	struct ieee80211_device *ieee = priv->ieee80211;
 	switch (channel_plan) {
 	case COUNTRY_CODE_FCC:
@@ -232,12 +232,12 @@ static void rtl819x_set_channel_map(u8 channel_plan, struct r8192_priv *priv)
 			memset(GET_DOT11D_INFO(ieee)->channel_map, 0,
 				sizeof(GET_DOT11D_INFO(ieee)->channel_map));
 			/* Set new channel map */
-			for (i = 0;i<ChannelPlan[channel_plan].Len; i++) {
+			for (i = 0; i < ChannelPlan[channel_plan].Len; i++) {
 				if (ChannelPlan[channel_plan].Channel[i] <
 					min_chan || ChannelPlan[channel_plan].
 							Channel[i] > max_chan)
 				break;
-				GET_DOT11D_INFO(ieee)->channel_map[ChannelPlan
+			GET_DOT11D_INFO(ieee)->channel_map[ChannelPlan
 						[channel_plan].Channel[i]] = 1;
 			}
 		}
@@ -259,34 +259,41 @@ static void rtl819x_set_channel_map(u8 channel_plan, struct r8192_priv *priv)
 }
 #endif
 
-#define eqMacAddr(a,b) ( ((a)[0]==(b)[0] && (a)[1]==(b)[1] && (a)[2]==(b)[2] && (a)[3]==(b)[3] && (a)[4]==(b)[4] && (a)[5]==(b)[5]) ? 1:0 )
+#define eqMacAddr(a, b)(((a)[0] == (b)[0] && (a)[1] == (b)[1] && (a)[2] ==\
+	(b)[2] && (a)[3] == (b)[3] && (a)[4] == (b)[4] && (a)[5] == (b)[5])\
+								 ? 1 : 0)
 
-#define 	rx_hal_is_cck_rate(_pdrvinfo)\
-			(_pdrvinfo->RxRate == DESC90_RATE1M ||\
-			_pdrvinfo->RxRate == DESC90_RATE2M ||\
-			_pdrvinfo->RxRate == DESC90_RATE5_5M ||\
-			_pdrvinfo->RxRate == DESC90_RATE11M) &&\
-			!_pdrvinfo->RxHT\
+#define	rx_hal_is_cck_rate(_pdrvinfo)\
+		(_pdrvinfo->RxRate == DESC90_RATE1M ||\
+		_pdrvinfo->RxRate == DESC90_RATE2M ||\
+		_pdrvinfo->RxRate == DESC90_RATE5_5M ||\
+		_pdrvinfo->RxRate == DESC90_RATE11M) &&\
+		!_pdrvinfo->RxHT\
 
 
 void CamResetAllEntry(struct net_device *dev)
 {
 	u32 ulcommand = 0;
-	//2004/02/11  In static WEP, OID_ADD_KEY or OID_ADD_WEP are set before STA associate to AP.
-	// However, ResetKey is called on OID_802_11_INFRASTRUCTURE_MODE and MlmeAssociateRequest
-	// In this condition, Cam can not be reset because upper layer will not set this static key again.
-	//if(Adapter->EncAlgorithm == WEP_Encryption)
-	//      return;
-//debug
-	//DbgPrint("========================================\n");
-	//DbgPrint("                            Call ResetAllEntry                                              \n");
-	//DbgPrint("========================================\n\n");
+	/* 2004/02/11  In static WEP, OID_ADD_KEY or OID_ADD_WEP are set before
+	 * STA associate to AP.
+	 * However, ResetKey is called on OID_802_11_INFRASTRUCTURE_MODE and
+	 * MlmeAssociateRequest
+	 * In this condition, Cam can not be reset because upper layer will not
+	 * set this static key again.
+	 *if(Adapter->EncAlgorithm == WEP_Encryption)
+	 *	return;
+	 */
+	/* debug
+	 *DbgPrint("========================================\n");
+	 *DbgPrint("                            Call ResetAllEntry"
+	 *		"                                              \n");
+	 *DbgPrint("========================================\n\n");
+	 */
 	ulcommand |= BIT31|BIT30;
 	write_nic_dword(dev, RWCAM, ulcommand);
 
 }
 
-
 void write_cam(struct net_device *dev, u8 addr, u32 data)
 {
 	write_nic_dword(dev, WCAMI, data);
-- 
1.6.3.3

