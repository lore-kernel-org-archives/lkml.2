Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab0LaFs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 00:48:57 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54214 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab0LaFsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 00:48:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wFuk2NvM1c6GerJFhfY+60LCStP+lL3YfcLoD6zwAkJWrSujAhFkDmhGdvhQDB4XTX
         y66FwQxteTAARxthiTIPkibxuCAf0Q6HrDWNHDSuGqPMKSkoDXCWhk5AdoB15EtDDZKH
         Fsq3pf0jfwd0s1P0WX2iYJcfAS+Jo9gcH/Wpc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 03/15]drivers:staging:rtl8187se:r8180_dm.c Fix some comments.
Date: Thu, 30 Dec 2010 21:48:39 -0800
Message-Id: <1293774531-5294-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
In-Reply-To: <1293774531-5294-3-git-send-email-justinmattock@gmail.com>
References: <1293774531-5294-1-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-2-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-3-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below are some patches that either fix a typo in a comment and/or fixes a
comment altogether to make more sense. If there is anything I missed let me know
and I'll resend.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/rtl8187se/r8180_dm.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_dm.c b/drivers/staging/rtl8187se/r8180_dm.c
index fc49078..a0619b8 100644
--- a/drivers/staging/rtl8187se/r8180_dm.c
+++ b/drivers/staging/rtl8187se/r8180_dm.c
@@ -6,7 +6,7 @@
 
 //
 //	Description:
-//		Return TRUE if we shall perform High Power Mecahnism, FALSE otherwise.
+//		Return TRUE if we shall perform High Power Mechanism, FALSE otherwise.
 //
 //+by amy 080312
 #define RATE_ADAPTIVE_TIMER_PERIOD      300
@@ -35,7 +35,7 @@ bool CheckHighPower(struct net_device *dev)
 //		See also DoRxHighPower() and SetTxPowerLevel8185() for reference.
 //
 //	Note:
-//		The reason why we udpate Tx power level here instead of DoRxHighPower()
+//		The reason why we update Tx power level here instead of DoRxHighPower()
 //		is the number of IO to change Tx power is much more than channel TR switch
 //		and they are related to OFDM and MAC registers.
 //		So, we don't want to update it so frequently in per-Rx packet base.
@@ -78,7 +78,7 @@ DoTxHighPower(
 		priv->bToUpdateTxPwr = true;
 		u1bTmp= read_nic_byte(dev, CCK_TXAGC);
 
-		// If it never enter High Power.
+		// If it never enters High Power.
 		if( CckTxPwrIdx == u1bTmp)
 		{
 		u1bTmp = (u1bTmp > 16) ? (u1bTmp -16): 0;  // 8dbm
@@ -145,7 +145,7 @@ void rtl8180_tx_pw_wq (struct work_struct *work)
 
 //
 //	Description:
-//		Return TRUE if we shall perform DIG Mecahnism, FALSE otherwise.
+//		Return TRUE if we shall perform DIG Mechanism, FALSE otherwise.
 //
 bool
 CheckDig(
@@ -650,7 +650,7 @@ StaRateAdaptive87SE(
 
 	//
 	// For Netgear case, I comment out the following signal strength estimation,
-	// which can results in lower rate to transmit when sample is NOT enough (e.g. PING request).
+	// which can result in lower rate to transmit when sample is NOT enough (e.g. PING request).
 	// 2007.04.09, by Roger.
 	//
 
@@ -687,7 +687,7 @@ StaRateAdaptive87SE(
 	{
 		//2 For Test Upgrading mechanism
 		// Note:
-		// 	Sometimes the throughput is upon on the capability bwtween the AP and NIC,
+		// 	Sometimes the throughput is upon on the capability between the AP and NIC,
 		// 	thus the low data rate does not improve the performance.
 		// 	We randomly upgrade the data rate and check if the retry rate is improved.
 
@@ -990,7 +990,7 @@ StaRateAdaptive87SE(
 				bUpdateInitialGain = true;
 
 			// The difference in throughput between 48Mbps and 36Mbps is 8M.
-			// So, we must be carefully in this rate scale. Isaiah 2008-02-15.
+			// So, we must be careful in this rate scale. Isaiah 2008-02-15.
 			//
 			if(  ((priv->CurrentOperaRate == 72) || (priv->CurrentOperaRate == 48) || (priv->CurrentOperaRate == 36)) &&
 				(priv->FailTxRateCount > 2) )
@@ -1498,11 +1498,11 @@ SwAntennaDiversity(
 		// didn't changed by HW evaluation.
 		// 2008.02.27.
 		//
-		// [TRC Dell Lab] SignalStrength is inaccuracy. Isaiah 2008-03-05
+		// [TRC Dell Lab] SignalStrength is inaccurate. Isaiah 2008-03-05
 		// For example, Throughput of aux is better than main antenna(about 10M v.s 2M),
 		// but AdRxSignalStrength is less than main.
-		// Our guess is that main antenna have lower throughput and get many change
-		// to receive more CCK packets(ex.Beacon) which have stronger SignalStrength.
+		// Our guess is that main antenna has lower throughput and gets many changes
+		// to receive more CCK packets(ex.Beacon) which has stronger SignalStrength.
 		//
 		if( (!priv->bHWAdSwitched) && (bSwCheckSS))
 		{
@@ -1526,7 +1526,7 @@ SwAntennaDiversity(
 			priv->bAdSwitchedChecking = false;
 			// Increase Rx signal strength threshold if necessary.
 			if(	(priv->AdRxSignalStrength > (priv->AdRxSsThreshold + 10)) && // Signal is much stronger than current threshold
-				priv->AdRxSsThreshold <= priv->AdMaxRxSsThreshold) // Current threhold is not yet reach upper limit.
+				priv->AdRxSsThreshold <= priv->AdMaxRxSsThreshold) // Current threshold is not yet reach upper limit.
 			{
 				priv->AdRxSsThreshold = (priv->AdRxSsThreshold + priv->AdRxSignalStrength) / 2;
 				priv->AdRxSsThreshold = (priv->AdRxSsThreshold > priv->AdMaxRxSsThreshold) ?
@@ -1555,7 +1555,7 @@ SwAntennaDiversity(
 
 //
 //	Description:
-//		Return TRUE if we shall perform Tx Power Tracking Mecahnism, FALSE otherwise.
+//		Return TRUE if we shall perform Tx Power Tracking Mechanism, FALSE otherwise.
 //
 bool
 CheckTxPwrTracking(	struct net_device *dev)
-- 
1.6.5.2.180.gc5b3e

