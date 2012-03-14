Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030889Ab2CNOoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 10:44:25 -0400
Received: from mail-fa0-f46.google.com ([209.85.161.46]:43846 "EHLO
	mail-fa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470Ab2CNOoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 10:44:21 -0400
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Mar 2012 10:44:21 EDT
From: Andrew Miller <amiller@amilx.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        amiller@amilx.com
Subject: [PATCH] Staging: rtl8187se: r8180_core.c: Cleaned up if statement
Date: Wed, 14 Mar 2012 10:36:51 -0400
Message-Id: <1331735811-11917-1-git-send-email-amiller@amilx.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clean up the if statement's conditions to make them more
readable

fix the if statement's body indention, one tab stop to many.

Signed-off-by: Andrew Miller <amiller@amilx.com>
---
 drivers/staging/rtl8187se/r8180_core.c |   50 +++++++++++++++++--------------
 1 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 04c2391..e6e39c8 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -1615,35 +1615,39 @@ void rtl8180_rx(struct net_device *dev)
 		    fc = le16_to_cpu(hdr->frame_ctl);
 		type = WLAN_FC_GET_TYPE(fc);
 
-			if ((IEEE80211_FTYPE_CTL != type) &&
-				(eqMacAddr(priv->ieee80211->current_network.bssid, (fc & IEEE80211_FCTL_TODS) ? hdr->addr1 : (fc & IEEE80211_FCTL_FROMDS) ? hdr->addr2 : hdr->addr3))
-				 && (!bHwError) && (!bCRC) && (!bICV)) {
-				/* Perform signal smoothing for dynamic
-				 * mechanism on demand. This is different
-				 * with PerformSignalSmoothing8185 in smoothing
-				 * fomula. No dramatic adjustion is apply
-				 * because dynamic mechanism need some degree
-				 * of correctness. */
-				PerformUndecoratedSignalSmoothing8185(priv, bCckRate);
-
-				/* For good-looking singal strength. */
-				SignalStrengthIndex = NetgearSignalStrengthTranslate(
-								priv->LastSignalStrengthInPercent,
-								priv->SignalStrength);
-
-				priv->LastSignalStrengthInPercent = SignalStrengthIndex;
-				priv->Stats_SignalStrength = TranslateToDbm8185((u8)SignalStrengthIndex);
+		if (IEEE80211_FTYPE_CTL != type &&
+		    !bHwError && !bCRC && !bICV &&
+		    eqMacAddr(priv->ieee80211->current_network.bssid,
+		    	fc & IEEE80211_FCTL_TODS ? hdr->addr1 :
+		    	fc & IEEE80211_FCTL_FROMDS ? hdr->addr2 : 
+		    	hdr->addr3)) {
+				 
+			/* Perform signal smoothing for dynamic
+			 * mechanism on demand. This is different
+			 * with PerformSignalSmoothing8185 in smoothing
+			 * fomula. No dramatic adjustion is apply
+			 * because dynamic mechanism need some degree
+			 * of correctness. */
+			PerformUndecoratedSignalSmoothing8185(priv, bCckRate);
+
+			/* For good-looking singal strength. */
+			SignalStrengthIndex = NetgearSignalStrengthTranslate(
+							priv->LastSignalStrengthInPercent,
+							priv->SignalStrength);
+
+			priv->LastSignalStrengthInPercent = SignalStrengthIndex;
+			priv->Stats_SignalStrength = TranslateToDbm8185((u8)SignalStrengthIndex);
 		/*
 		 * We need more correct power of received packets and the  "SignalStrength" of RxStats is beautified,
 		 * so we record the correct power here.
 		 */
-				priv->Stats_SignalQuality = (long)(priv->Stats_SignalQuality * 5 + (long)priv->SignalQuality + 5) / 6;
-				priv->Stats_RecvSignalPower = (long)(priv->Stats_RecvSignalPower * 5 + priv->RecvSignalPower - 1) / 6;
+			priv->Stats_SignalQuality = (long)(priv->Stats_SignalQuality * 5 + (long)priv->SignalQuality + 5) / 6;
+			priv->Stats_RecvSignalPower = (long)(priv->Stats_RecvSignalPower * 5 + priv->RecvSignalPower - 1) / 6;
 
 		/* Figure out which antenna that received the lasted packet. */
-				priv->LastRxPktAntenna = Antenna ? 1 : 0; /* 0: aux, 1: main. */
-				SwAntennaDiversityRxOk8185(dev, priv->SignalStrength);
-			}
+			priv->LastRxPktAntenna = Antenna ? 1 : 0; /* 0: aux, 1: main. */
+			SwAntennaDiversityRxOk8185(dev, priv->SignalStrength);
+		}
 
 		if (first) {
 			if (!priv->rx_skb_complete) {
-- 
1.7.7.6

