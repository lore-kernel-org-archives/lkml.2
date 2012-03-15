Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161274Ab2COTHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 15:07:13 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64243 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161223Ab2COTHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 15:07:07 -0400
From: Andrew Miller <amiller@amilx.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        amiller@amilx.com
Subject: [PATCH 4/5] Staging: rtl8187se: r8180_dm.c: Fix spacing issues
Date: Thu, 15 Mar 2012 15:05:20 -0400
Message-Id: <1331838321-18453-5-git-send-email-amiller@amilx.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331838321-18453-1-git-send-email-amiller@amilx.com>
References: <1331838321-18453-1-git-send-email-amiller@amilx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix spacing around keywords, '*', binary and ternary
operators, and fix the format of statments and function
declaration.

Signed-off-by: Andrew Miller <amiller@amilx.com>
---
 drivers/staging/rtl8187se/r8180_dm.c |  442 +++++++++++++++-------------------
 1 files changed, 197 insertions(+), 245 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_dm.c b/drivers/staging/rtl8187se/r8180_dm.c
index bd2cf4a..02bffa9 100644
--- a/drivers/staging/rtl8187se/r8180_dm.c
+++ b/drivers/staging/rtl8187se/r8180_dm.c
@@ -36,10 +36,7 @@ bool CheckHighPower(struct net_device *dev)
 //		and they are related to OFDM and MAC registers.
 //		So, we don't want to update it so frequently in per-Rx packet base.
 //
-void
-DoTxHighPower(
-	struct net_device *dev
-	)
+void DoTxHighPower(struct net_device *dev)
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
 	u16			HiPwrUpperTh = 0;
@@ -65,7 +62,7 @@ DoTxHighPower(
 
 	//	printk("DoTxHighPower() - UndecoratedSmoothedSS:%d, CurCCKRSSI = %d , bCurCCKPkt= %d \n", priv->UndecoratedSmoothedSS, priv->CurCCKRSSI, priv->bCurCCKPkt );
 
-	if((priv->UndecoratedSmoothedSS > HiPwrUpperTh) ||
+	if ((priv->UndecoratedSmoothedSS > HiPwrUpperTh) ||
 		(priv->bCurCCKPkt && (priv->CurCCKRSSI > RSSIHiPwrUpperTh))) {
 		// Stevenl suggested that degrade 8dbm in high power sate. 2007-12-04 Isaiah
 
@@ -74,7 +71,7 @@ DoTxHighPower(
 		u1bTmp= read_nic_byte(dev, CCK_TXAGC);
 
 		// If it never enter High Power.
-		if( CckTxPwrIdx == u1bTmp) {
+		if (CckTxPwrIdx == u1bTmp) {
 			u1bTmp = (u1bTmp > 16) ? (u1bTmp -16): 0;  // 8dbm
 			write_nic_byte(dev, CCK_TXAGC, u1bTmp);
 
@@ -83,21 +80,21 @@ DoTxHighPower(
 			write_nic_byte(dev, OFDM_TXAGC, u1bTmp);
 		}
 
-	} else if((priv->UndecoratedSmoothedSS < HiPwrLowerTh) &&
+	} else if ((priv->UndecoratedSmoothedSS < HiPwrLowerTh) &&
 		(!priv->bCurCCKPkt || priv->CurCCKRSSI < RSSIHiPwrLowerTh)) {
 	//	 printk("DoTxHighPower() - lower Power - UndecoratedSmoothedSS:%d,  HiPwrUpperTh = %d \n", priv->UndecoratedSmoothedSS, HiPwrLowerTh );
-		if(priv->bToUpdateTxPwr) {
+		if (priv->bToUpdateTxPwr) {
 			priv->bToUpdateTxPwr = false;
 			//SD3 required.
 			u1bTmp= read_nic_byte(dev, CCK_TXAGC);
-			if(u1bTmp < CckTxPwrIdx) {
+			if (u1bTmp < CckTxPwrIdx) {
 				//u1bTmp = ((u1bTmp+16) > 35) ? 35: (u1bTmp+16);  // 8dbm
 				//write_nic_byte(dev, CCK_TXAGC, u1bTmp);
 				write_nic_byte(dev, CCK_TXAGC, CckTxPwrIdx);
 			}
 
 			u1bTmp= read_nic_byte(dev, OFDM_TXAGC);
-			if(u1bTmp < OfdmTxPwrIdx) {
+			if (u1bTmp < OfdmTxPwrIdx) {
 				//u1bTmp = ((u1bTmp+16) > 35) ? 35: (u1bTmp+16);  // 8dbm
 				//write_nic_byte(dev, OFDM_TXAGC, u1bTmp);
 				write_nic_byte(dev, OFDM_TXAGC, OfdmTxPwrIdx);
@@ -115,7 +112,7 @@ DoTxHighPower(
 //		Because of some event happened, e.g. CCX TPC, High Power Mechanism,
 //		We update Tx power of current channel again.
 //
-void rtl8180_tx_pw_wq (struct work_struct *work)
+void rtl8180_tx_pw_wq(struct work_struct *work)
 {
 //      struct r8180_priv *priv = container_of(work, struct r8180_priv, watch_dog_wq);
 //      struct ieee80211_device * ieee = (struct ieee80211_device*)
@@ -136,22 +133,19 @@ void rtl8180_tx_pw_wq (struct work_struct *work)
 //	Description:
 //		Return TRUE if we shall perform DIG Mecahnism, FALSE otherwise.
 //
-bool
-CheckDig(
-	struct net_device *dev
-	)
+bool CheckDig(struct net_device *dev)
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
 	struct ieee80211_device *ieee = priv->ieee80211;
 
-	if(!priv->bDigMechanism)
+	if (!priv->bDigMechanism)
 		return false;
 
-	if(ieee->state != IEEE80211_LINKED)
+	if (ieee->state != IEEE80211_LINKED)
 		return false;
 
 	//if(priv->CurrentOperaRate < 36) // Schedule Dig under all OFDM rates. By Bruce, 2007-06-01.
-	if((priv->ieee80211->rate/5) < 36) // Schedule Dig under all OFDM rates. By Bruce, 2007-06-01.
+	if ((priv->ieee80211->rate / 5) < 36) // Schedule Dig under all OFDM rates. By Bruce, 2007-06-01.
 		return false;
 	return true;
 }
@@ -159,17 +153,14 @@ CheckDig(
 //	Description:
 //		Implementation of DIG for Zebra and Zebra2.
 //
-void
-DIG_Zebra(
-	struct net_device *dev
-	)
+void DIG_Zebra(struct net_device *dev)
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
 	u16			CCKFalseAlarm, OFDMFalseAlarm;
 	u16			OfdmFA1, OfdmFA2;
 	int			InitialGainStep = 7; // The number of initial gain stages.
 	int			LowestGainStage = 4; // The capable lowest stage of performing dig workitem.
-	u32			AwakePeriodIn2Sec=0;
+	u32			AwakePeriodIn2Sec = 0;
 
 	//printk("---------> DIG_Zebra()\n");
 
@@ -182,23 +173,23 @@ DIG_Zebra(
 //	printk("DIG**********OFDM False Alarm: %#X \n",OFDMFalseAlarm);
 
 	// The number of initial gain steps is different, by Bruce, 2007-04-13.
-	if (priv->InitialGain == 0 ) { //autoDIG
+	if (priv->InitialGain == 0) { //autoDIG
 		// Advised from SD3 DZ
 		priv->InitialGain = 4; // In 87B, m74dBm means State 4 (m82dBm)
 	}
 	// Advised from SD3 DZ
-	OfdmFA1 =  0x20;
+	OfdmFA1 = 0x20;
 
 #if 1 //lzm reserved 080826
-	AwakePeriodIn2Sec = (2000-priv ->DozePeriodInPast2Sec);
+	AwakePeriodIn2Sec = (2000 - priv->DozePeriodInPast2Sec);
 	//printk("&&& DozePeriod=%d AwakePeriod=%d\n", priv->DozePeriodInPast2Sec, AwakePeriodIn2Sec);
-	priv ->DozePeriodInPast2Sec=0;
+	priv ->DozePeriodInPast2Sec = 0;
 
-	if(AwakePeriodIn2Sec) {
+	if (AwakePeriodIn2Sec) {
 		//RT_TRACE(COMP_DIG, DBG_TRACE, ("DIG: AwakePeriodIn2Sec(%d) - FATh(0x%X , 0x%X) ->",AwakePeriodIn2Sec, OfdmFA1, OfdmFA2));
 		// adjuest DIG threshold.
-		OfdmFA1 =  (u16)((OfdmFA1*AwakePeriodIn2Sec)  / 2000) ;
-		OfdmFA2 =  (u16)((OfdmFA2*AwakePeriodIn2Sec)  / 2000) ;
+		OfdmFA1 = (u16)((OfdmFA1 * AwakePeriodIn2Sec) / 2000) ;
+		OfdmFA2 = (u16)((OfdmFA2 * AwakePeriodIn2Sec) / 2000) ;
 		//RT_TRACE(COMP_DIG, DBG_TRACE, ("( 0x%X , 0x%X)\n", OfdmFA1, OfdmFA2));
 	} else {
 		;//RT_TRACE(COMP_DIG, DBG_WARNING, ("ERROR!!  AwakePeriodIn2Sec should not be ZERO!!\n"));
@@ -211,10 +202,10 @@ DIG_Zebra(
 	if (OFDMFalseAlarm > OfdmFA1) {
 		if (OFDMFalseAlarm > OfdmFA2) {
 			priv->DIG_NumberFallbackVote++;
-			if (priv->DIG_NumberFallbackVote >1) {
+			if (priv->DIG_NumberFallbackVote > 1) {
 				//serious OFDM  False Alarm, need fallback
 				if (priv->InitialGain < InitialGainStep) {
-					priv->InitialGainBackUp= priv->InitialGain;
+					priv->InitialGainBackUp = priv->InitialGain;
 
 					priv->InitialGain = (priv->InitialGain + 1);
 //					printk("DIG**********OFDM False Alarm: %#X,  OfdmFA1: %#X, OfdmFA2: %#X\n", OFDMFalseAlarm, OfdmFA1, OfdmFA2);
@@ -222,21 +213,21 @@ DIG_Zebra(
 					UpdateInitialGain(dev);
 				}
 				priv->DIG_NumberFallbackVote = 0;
-				priv->DIG_NumberUpgradeVote=0;
+				priv->DIG_NumberUpgradeVote = 0;
 			}
 		} else {
 			if (priv->DIG_NumberFallbackVote)
 				priv->DIG_NumberFallbackVote--;
 		}
-		priv->DIG_NumberUpgradeVote=0;
+		priv->DIG_NumberUpgradeVote = 0;
 	} else {
 		if (priv->DIG_NumberFallbackVote)
 			priv->DIG_NumberFallbackVote--;
 		priv->DIG_NumberUpgradeVote++;
 
-		if (priv->DIG_NumberUpgradeVote>9) {
+		if (priv->DIG_NumberUpgradeVote > 9) {
 			if (priv->InitialGain > LowestGainStage) { // In 87B, m78dBm means State 4 (m864dBm)
-				priv->InitialGainBackUp= priv->InitialGain;
+				priv->InitialGainBackUp = priv->InitialGain;
 
 				priv->InitialGain = (priv->InitialGain - 1);
 //				printk("DIG**********OFDM False Alarm: %#X,  OfdmFA1: %#X, OfdmFA2: %#X\n", OFDMFalseAlarm, OfdmFA1, OfdmFA2);
@@ -244,7 +235,7 @@ DIG_Zebra(
 				UpdateInitialGain(dev);
 			}
 			priv->DIG_NumberFallbackVote = 0;
-			priv->DIG_NumberUpgradeVote=0;
+			priv->DIG_NumberUpgradeVote = 0;
 		}
 	}
 
@@ -256,13 +247,12 @@ DIG_Zebra(
 //	Description:
 //		Dispatch DIG implementation according to RF.
 //
-void
-DynamicInitGain(struct net_device *dev)
+void DynamicInitGain(struct net_device *dev)
 {
 	DIG_Zebra(dev);
 }
 
-void rtl8180_hw_dig_wq (struct work_struct *work)
+void rtl8180_hw_dig_wq(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
 	struct ieee80211_device *ieee = container_of(dwork,struct ieee80211_device,hw_dig_wq);
@@ -278,10 +268,7 @@ void rtl8180_hw_dig_wq (struct work_struct *work)
 
 }
 
-int
-IncludedInSupportedRates(
-	struct r8180_priv       *priv,
-	u8              TxRate  )
+int IncludedInSupportedRates(struct r8180_priv *priv, u8 TxRate)
 {
 	u8 rate_len;
 	u8 rate_ex_len;
@@ -292,14 +279,14 @@ IncludedInSupportedRates(
 
 	rate_len = priv->ieee80211->current_network.rates_len;
 	rate_ex_len = priv->ieee80211->current_network.rates_ex_len;
-	for( idx=0; idx< rate_len; idx++ ) {
-		if( (priv->ieee80211->current_network.rates[idx] & RateMask) == NaiveTxRate ) {
+	for (idx=0; idx < rate_len; idx++) {
+		if ((priv->ieee80211->current_network.rates[idx] & RateMask) == NaiveTxRate) {
 			Found = 1;
 			goto found_rate;
 		}
 	}
-	for( idx=0; idx< rate_ex_len; idx++ ) {
-		if( (priv->ieee80211->current_network.rates_ex[idx] & RateMask) == NaiveTxRate ) {
+	for (idx = 0; idx < rate_ex_len; idx++) {
+		if ((priv->ieee80211->current_network.rates_ex[idx] & RateMask) == NaiveTxRate) {
 			Found = 1;
 			goto found_rate;
 		}
@@ -315,17 +302,13 @@ IncludedInSupportedRates(
 //              Return the upgrade rate if it is successed, otherwise return the input rate.
 //      By Bruce, 2007-06-05.
 //
-u8
-GetUpgradeTxRate(
-	struct net_device *dev,
-	u8                              rate
-	)
+u8 GetUpgradeTxRate(struct net_device *dev, u8 rate)
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
 	u8                      UpRate;
 
 	// Upgrade 1 degree.
-	switch(rate) {
+	switch (rate) {
 	case 108: // Up to 54Mbps.
 		UpRate = 108;
 		break;
@@ -367,7 +350,7 @@ GetUpgradeTxRate(
 		return rate;
 	}
 	// Check if the rate is valid.
-	if(IncludedInSupportedRates(priv, UpRate)) {
+	if (IncludedInSupportedRates(priv, UpRate)) {
 //              printk("GetUpgradeTxRate(): GetUpgrade Tx rate(%d) from %d !\n", UpRate, priv->CurrentOperaRate);
 		return UpRate;
 	} else {
@@ -382,17 +365,13 @@ GetUpgradeTxRate(
 //              Return the degrade rate if it is successed, otherwise return the input rate.
 //      By Bruce, 2007-06-05.
 //
-u8
-GetDegradeTxRate(
-	struct net_device *dev,
-	u8         rate
-	)
+u8 GetDegradeTxRate(struct net_device *dev, u8 rate)
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
 	u8                      DownRate;
 
 	// Upgrade 1 degree.
-	switch(rate) {
+	switch (rate) {
 	case 108: // Down to 48Mbps.
 		DownRate = 96;
 		break;
@@ -434,7 +413,7 @@ GetDegradeTxRate(
 		return rate;
 	}
 	// Check if the rate is valid.
-	if(IncludedInSupportedRates(priv, DownRate)) {
+	if (IncludedInSupportedRates(priv, DownRate)) {
 //              printk("GetDegradeTxRate(): GetDegrade Tx rate(%d) from %d!\n", DownRate, priv->CurrentOperaRate);
 		return DownRate;
 	} else {
@@ -448,14 +427,11 @@ GetDegradeTxRate(
 //      CCK rate.
 //      2005.01.25, by rcnjko.
 //
-bool
-MgntIsCckRate(
-	u16     rate
-	)
+bool MgntIsCckRate(u16 rate)
 {
 	bool bReturn = false;
 
-	if((rate <= 22) && (rate != 12) && (rate != 18)) {
+	if ((rate <= 22) && (rate != 12) && (rate != 18)) {
 		bReturn = true;
 	}
 
@@ -466,10 +442,7 @@ MgntIsCckRate(
 //		Tx Power tracking mechanism routine on 87SE.
 //	Created by Roger, 2007.12.11.
 //
-void
-TxPwrTracking87SE(
-	struct net_device *dev
-)
+void TxPwrTracking87SE(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	u8	tmpu1Byte, CurrentThermal, Idx;
@@ -477,36 +450,36 @@ TxPwrTracking87SE(
 	//u32	u4bRfReg;
 
 	tmpu1Byte = read_nic_byte(dev, EN_LPF_CAL);
-	CurrentThermal = (tmpu1Byte & 0xf0)>>4; //[ 7:4]: thermal meter indication.
-	CurrentThermal = (CurrentThermal>0x0c)? 0x0c:CurrentThermal;//lzm add 080826
+	CurrentThermal = (tmpu1Byte & 0xf0) >> 4; //[ 7:4]: thermal meter indication.
+	CurrentThermal = (CurrentThermal > 0x0c) ? 0x0c:CurrentThermal;//lzm add 080826
 
 	//printk("TxPwrTracking87SE(): CurrentThermal(%d)\n", CurrentThermal);
 
-	if( CurrentThermal != priv->ThermalMeter) {
+	if (CurrentThermal != priv->ThermalMeter) {
 //		printk("TxPwrTracking87SE(): Thermal meter changed!!!\n");
 
 		// Update Tx Power level on each channel.
-		for(Idx = 1; Idx<15; Idx++) {
+		for (Idx = 1; Idx < 15; Idx++) {
 			CckTxPwrIdx = priv->chtxpwr[Idx];
 			OfdmTxPwrIdx = priv->chtxpwr_ofdm[Idx];
 
-			if( CurrentThermal > priv->ThermalMeter ) {
+			if (CurrentThermal > priv->ThermalMeter) {
 				// higher thermal meter.
-				CckTxPwrIdx += (CurrentThermal - priv->ThermalMeter)*2;
-				OfdmTxPwrIdx += (CurrentThermal - priv->ThermalMeter)*2;
+				CckTxPwrIdx += (CurrentThermal - priv->ThermalMeter) * 2;
+				OfdmTxPwrIdx += (CurrentThermal - priv->ThermalMeter) * 2;
 
-				if(CckTxPwrIdx >35)
+				if (CckTxPwrIdx > 35)
 					CckTxPwrIdx = 35; // Force TxPower to maximal index.
-				if(OfdmTxPwrIdx >35)
+				if (OfdmTxPwrIdx > 35)
 					OfdmTxPwrIdx = 35;
 			} else {
 				// lower thermal meter.
-				CckTxPwrIdx -= (priv->ThermalMeter - CurrentThermal)*2;
-				OfdmTxPwrIdx -= (priv->ThermalMeter - CurrentThermal)*2;
+				CckTxPwrIdx -= (priv->ThermalMeter - CurrentThermal) * 2;
+				OfdmTxPwrIdx -= (priv->ThermalMeter - CurrentThermal) * 2;
 
-				if(CckTxPwrIdx <0)
+				if (CckTxPwrIdx < 0)
 					CckTxPwrIdx = 0;
-				if(OfdmTxPwrIdx <0)
+				if (OfdmTxPwrIdx < 0)
 					OfdmTxPwrIdx = 0;
 			}
 
@@ -520,10 +493,7 @@ TxPwrTracking87SE(
 	}
 	priv->ThermalMeter = CurrentThermal;
 }
-void
-StaRateAdaptive87SE(
-	struct net_device *dev
-	)
+void StaRateAdaptive87SE(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	unsigned long	CurrTxokCnt;
@@ -538,10 +508,10 @@ StaRateAdaptive87SE(
 	u32		TxThroughput;
 	long		CurrSignalStrength;
 	bool		bUpdateInitialGain = false;
-	u8		u1bOfdm=0, u1bCck = 0;
+	u8		u1bOfdm = 0, u1bCck = 0;
 	char		OfdmTxPwrIdx, CckTxPwrIdx;
 
-	priv->RateAdaptivePeriod= RATE_ADAPTIVE_TIMER_PERIOD;
+	priv->RateAdaptivePeriod = RATE_ADAPTIVE_TIMER_PERIOD;
 
 
 	CurrRetryCnt	= priv->CurrRetryCnt;
@@ -550,14 +520,14 @@ StaRateAdaptive87SE(
 	CurrSignalStrength = priv->Stats_RecvSignalPower;
 	TxThroughput = (u32)(priv->NumTxOkBytesTotal - priv->LastTxOKBytes);
 	priv->LastTxOKBytes = priv->NumTxOkBytesTotal;
-	priv->CurrentOperaRate = priv->ieee80211->rate/5;
+	priv->CurrentOperaRate = priv->ieee80211->rate / 5;
 	//printk("priv->CurrentOperaRate is %d\n",priv->CurrentOperaRate);
 	//2 Compute retry ratio.
-	if (CurrTxokCnt>0) {
-		CurrRetryRate = (u16)(CurrRetryCnt*100/CurrTxokCnt);
+	if (CurrTxokCnt > 0) {
+		CurrRetryRate = (u16)(CurrRetryCnt * 100 / CurrTxokCnt);
 	} else {
 	// It may be serious retry. To distinguish serious retry or no packets modified by Bruce
-		CurrRetryRate = (u16)(CurrRetryCnt*100/1);
+		CurrRetryRate = (u16)(CurrRetryCnt * 100 / 1);
 	}
 
 
@@ -579,7 +549,7 @@ StaRateAdaptive87SE(
 	priv->CurrRetryCnt = 0;
 
 	//2No Tx packets, return to init_rate or not?
-	if (CurrRetryRate==0 && CurrTxokCnt == 0) {
+	if (CurrRetryRate == 0 && CurrTxokCnt == 0) {
 		//
 		//After 9 (30*300ms) seconds in this condition, we try to raise rate.
 		//
@@ -587,7 +557,7 @@ StaRateAdaptive87SE(
 
 //		printk("No Tx packets, TryupingCountNoData(%d)\n", priv->TryupingCountNoData);
 		//[TRC Dell Lab] Extend raised period from 4.5sec to 9sec, Isaiah 2008-02-15 18:00
-		if (priv->TryupingCountNoData>30) {
+		if (priv->TryupingCountNoData > 30) {
 			priv->TryupingCountNoData = 0;
 			priv->CurrentOperaRate = GetUpgradeTxRate(dev, priv->CurrentOperaRate);
 			// Reset Fail Record
@@ -597,7 +567,7 @@ StaRateAdaptive87SE(
 		}
 		goto SetInitialGain;
 	} else {
-		priv->TryupingCountNoData=0; //Reset trying up times.
+		priv->TryupingCountNoData = 0; //Reset trying up times.
 	}
 
 
@@ -623,12 +593,12 @@ StaRateAdaptive87SE(
 	// 11Mbps or 36Mbps
 	// Check more times in these rate(key rates).
 	//
-	if(priv->CurrentOperaRate == 22 || priv->CurrentOperaRate == 72)
+	if (priv->CurrentOperaRate == 22 || priv->CurrentOperaRate == 72)
 		TryUpTh += 9;
 	//
 	// Let these rates down more difficult.
 	//
-	if(MgntIsCckRate(priv->CurrentOperaRate) || priv->CurrentOperaRate == 36)
+	if (MgntIsCckRate(priv->CurrentOperaRate) || priv->CurrentOperaRate == 36)
 		TryDownTh += 1;
 
 	//1 Adjust Rate.
@@ -640,7 +610,7 @@ StaRateAdaptive87SE(
 		//	We randomly upgrade the data rate and check if the retry rate is improved.
 
 		// Upgrading rate did not improve the retry rate, fallback to the original rate.
-		if ( (CurrRetryRate > 25) && TxThroughput < priv->LastTxThroughput) {
+		if ((CurrRetryRate > 25) && TxThroughput < priv->LastTxThroughput) {
 			//Not necessary raising rate, fall back rate.
 			bTryDown = true;
 			//printk("case1-1: Not necessary raising rate, fall back rate....\n");
@@ -658,14 +628,14 @@ StaRateAdaptive87SE(
 		// Revise SignalStrength threshold to -51dbm.
 		//
 		// Also need to check retry rate for safety, by Bruce, 2007-06-05.
-		if(priv->CurrentOperaRate != priv->ieee80211->current_network.HighestOperaRate ) {
+		if (priv->CurrentOperaRate != priv->ieee80211->current_network.HighestOperaRate) {
 			bTryUp = true;
 			// Upgrade Tx Rate directly.
 			priv->TryupingCount += TryUpTh;
 		}
 //		printk("case2: StaRateAdaptive87SE: Power(%d) is high enough!!. \n", CurrSignalStrength);
 
-	} else if(CurrTxokCnt > 9 && CurrTxokCnt< 100 && CurrRetryRate >= 600) {
+	} else if (CurrTxokCnt > 9 && CurrTxokCnt < 100 && CurrRetryRate >= 600) {
 		//2 For Serious Retry
 		//
 		// Traffic is not busy but our Tx retry is serious.
@@ -674,161 +644,161 @@ StaRateAdaptive87SE(
 		// Let Rate Mechanism to degrade tx rate directly.
 		priv->TryDownCountLowData += TryDownTh;
 //		printk("case3: RA: Tx Retry is serious. Degrade Tx Rate to %d directly...\n", priv->CurrentOperaRate);
-	} else if ( priv->CurrentOperaRate == 108 ) {
+	} else if (priv->CurrentOperaRate == 108) {
 		//2For 54Mbps
 		// Air Link
-		if ( (CurrRetryRate>26)&&(priv->LastRetryRate>25)) {
-//		if ( (CurrRetryRate>40)&&(priv->LastRetryRate>39))
+		if ((CurrRetryRate > 26) && (priv->LastRetryRate > 25)) {
+//		if ((CurrRetryRate>40)&&(priv->LastRetryRate>39))
 			//Down to rate 48Mbps.
 			bTryDown = true;
 		}
 		// Cable Link
-		else if ( (CurrRetryRate>17)&&(priv->LastRetryRate>16) && (CurrSignalStrength > -72)) {
-//		else if ( (CurrRetryRate>17)&&(priv->LastRetryRate>16) && (CurrSignalStrength > -72))
+		else if ((CurrRetryRate > 17) && (priv->LastRetryRate > 16) && (CurrSignalStrength > -72)) {
+//		else if ((CurrRetryRate>17)&&(priv->LastRetryRate>16) && (CurrSignalStrength > -72))
 			//Down to rate 48Mbps.
 			bTryDown = true;
 		}
 
-		if(bTryDown && (CurrSignalStrength < -75)) //cable link
+		if (bTryDown && (CurrSignalStrength < -75)) //cable link
 			priv->TryDownCountLowData += TryDownTh;
 		//printk("case4---54M \n");
 
 	}
-	else if ( priv->CurrentOperaRate == 96 ) {
+	else if (priv->CurrentOperaRate == 96) {
 		//2For 48Mbps
 		//Air Link
-		if ( ((CurrRetryRate>48) && (priv->LastRetryRate>47))) {
+		if (((CurrRetryRate > 48) && (priv->LastRetryRate > 47))) {
 //		if ( ((CurrRetryRate>65) && (priv->LastRetryRate>64)))
 			//Down to rate 36Mbps.
 			bTryDown = true;
-		} else if ( ((CurrRetryRate>21) && (priv->LastRetryRate>20)) && (CurrSignalStrength > -74)) { //Cable Link
+		} else if (((CurrRetryRate > 21) && (priv->LastRetryRate > 20)) && (CurrSignalStrength > -74)) { //Cable Link
 			//Down to rate 36Mbps.
 			bTryDown = true;
-		} else if((CurrRetryRate>  (priv->LastRetryRate + 50 )) && (priv->FailTxRateCount >2 )) {
+		} else if ((CurrRetryRate > (priv->LastRetryRate + 50)) && (priv->FailTxRateCount > 2)) {
 //		else if((CurrRetryRate>  (priv->LastRetryRate + 70 )) && (priv->FailTxRateCount >2 ))
 			bTryDown = true;
 			priv->TryDownCountLowData += TryDownTh;
-		} else if ( (CurrRetryRate<8) && (priv->LastRetryRate<8) ) { //TO DO: need to consider (RSSI)
+		} else if ((CurrRetryRate < 8) && (priv->LastRetryRate < 8)) { //TO DO: need to consider (RSSI)
 //		else if ( (CurrRetryRate<28) && (priv->LastRetryRate<8) )
 			bTryUp = true;
 		}
 
-		if(bTryDown && (CurrSignalStrength < -75)){
+		if (bTryDown && (CurrSignalStrength < -75)){
 			priv->TryDownCountLowData += TryDownTh;
 		}
 		//printk("case5---48M \n");
-	} else if ( priv->CurrentOperaRate == 72 ) {
+	} else if (priv->CurrentOperaRate == 72) {
 		//2For 36Mbps
-		if ( (CurrRetryRate>43) && (priv->LastRetryRate>41)) {
+		if ((CurrRetryRate > 43) && (priv->LastRetryRate > 41)) {
 //		if ( (CurrRetryRate>60) && (priv->LastRetryRate>59))
 			//Down to rate 24Mbps.
 			bTryDown = true;
-		} else if((CurrRetryRate>  (priv->LastRetryRate + 50 )) && (priv->FailTxRateCount >2 )) {
+		} else if ((CurrRetryRate > (priv->LastRetryRate + 50)) && (priv->FailTxRateCount > 2)) {
 //		else if((CurrRetryRate>  (priv->LastRetryRate + 70 )) && (priv->FailTxRateCount >2 ))
 			bTryDown = true;
 			priv->TryDownCountLowData += TryDownTh;
-		} else if ( (CurrRetryRate<15) &&  (priv->LastRetryRate<16)) { //TO DO: need to consider (RSSI)
+		} else if ((CurrRetryRate < 15) &&  (priv->LastRetryRate < 16)) { //TO DO: need to consider (RSSI)
 //		else if ( (CurrRetryRate<35) &&  (priv->LastRetryRate<36))
 			bTryUp = true;
 		}
 
-		if(bTryDown && (CurrSignalStrength < -80))
+		if (bTryDown && (CurrSignalStrength < -80))
 			priv->TryDownCountLowData += TryDownTh;
 
 		//printk("case6---36M \n");
-	} else if ( priv->CurrentOperaRate == 48 ) {
+	} else if (priv->CurrentOperaRate == 48) {
 		//2For 24Mbps
 		// Air Link
-		if ( ((CurrRetryRate>63) && (priv->LastRetryRate>62))) {
+		if (((CurrRetryRate > 63) && (priv->LastRetryRate > 62))) {
 //		if ( ((CurrRetryRate>83) && (priv->LastRetryRate>82)))
 			//Down to rate 18Mbps.
 			bTryDown = true;
-		} else if ( ((CurrRetryRate>33) && (priv->LastRetryRate>32)) && (CurrSignalStrength > -82) ) { //Cable Link
+		} else if (((CurrRetryRate > 33) && (priv->LastRetryRate > 32)) && (CurrSignalStrength > -82)) { //Cable Link
 //		 else if ( ((CurrRetryRate>50) && (priv->LastRetryRate>49)) && (CurrSignalStrength > -82) )
 			//Down to rate 18Mbps.
 			bTryDown = true;
-		} else if((CurrRetryRate>  (priv->LastRetryRate + 50 )) && (priv->FailTxRateCount >2 )) {
+		} else if ((CurrRetryRate > (priv->LastRetryRate + 50)) && (priv->FailTxRateCount > 2 )) {
 //		else if((CurrRetryRate>  (priv->LastRetryRate + 70 )) && (priv->FailTxRateCount >2 ))
 			bTryDown = true;
 			priv->TryDownCountLowData += TryDownTh;
-		} else if ( (CurrRetryRate<20) && (priv->LastRetryRate<21)) { //TO DO: need to consider (RSSI)
+		} else if ((CurrRetryRate < 20) && (priv->LastRetryRate < 21)) { //TO DO: need to consider (RSSI)
 //		else if ( (CurrRetryRate<40) && (priv->LastRetryRate<41))
 			bTryUp = true;
 		}
 
-		if(bTryDown && (CurrSignalStrength < -82))
+		if (bTryDown && (CurrSignalStrength < -82))
 			priv->TryDownCountLowData += TryDownTh;
 
 		//printk("case7---24M \n");
-	} else if ( priv->CurrentOperaRate == 36 ) {
+	} else if (priv->CurrentOperaRate == 36) {
 		//2For 18Mbps
 		// original (109, 109)
 		//[TRC Dell Lab] (90, 91), Isaiah 2008-02-18 23:24
 		//			     (85, 86), Isaiah 2008-02-18 24:00
-		if ( ((CurrRetryRate>85) && (priv->LastRetryRate>86))) {
+		if (((CurrRetryRate > 85) && (priv->LastRetryRate > 86))) {
 //		if ( ((CurrRetryRate>115) && (priv->LastRetryRate>116)))
 			//Down to rate 11Mbps.
 			bTryDown = true;
 
 		  //[TRC Dell Lab]  Isaiah 2008-02-18 23:24
-		} else if((CurrRetryRate>  (priv->LastRetryRate + 50 )) && (priv->FailTxRateCount >2 )) {
+		} else if ((CurrRetryRate > (priv->LastRetryRate + 50)) && (priv->FailTxRateCount > 2)) {
 //		else if((CurrRetryRate>  (priv->LastRetryRate + 70 )) && (priv->FailTxRateCount >2 ))
 			bTryDown = true;
 			priv->TryDownCountLowData += TryDownTh;
-		} else if ( (CurrRetryRate<22) && (priv->LastRetryRate<23)) { //TO DO: need to consider (RSSI)
+		} else if ((CurrRetryRate < 22) && (priv->LastRetryRate < 23)) { //TO DO: need to consider (RSSI)
 //		else if ( (CurrRetryRate<42) && (priv->LastRetryRate<43))
 			bTryUp = true;
 		}
 		//printk("case8---18M \n");
-	} else if ( priv->CurrentOperaRate == 22 ) {
+	} else if (priv->CurrentOperaRate == 22) {
 		//2For 11Mbps
-		if (CurrRetryRate>95) {
+		if (CurrRetryRate > 95) {
 //		if (CurrRetryRate>155)
 			bTryDown = true;
 		}
-		else if ( (CurrRetryRate<29) && (priv->LastRetryRate <30) ) { //TO DO: need to consider (RSSI)
+		else if ((CurrRetryRate < 29) && (priv->LastRetryRate < 30)) { //TO DO: need to consider (RSSI)
 //		else if ( (CurrRetryRate<49) && (priv->LastRetryRate <50) )
 			bTryUp = true;
 		}
 		//printk("case9---11M \n");
-	} else if ( priv->CurrentOperaRate == 11 ) {
+	} else if (priv->CurrentOperaRate == 11) {
 		//2For 5.5Mbps
-		if (CurrRetryRate>149) {
+		if (CurrRetryRate > 149) {
 //		if (CurrRetryRate>189)
 			bTryDown = true;
-		} else if ( (CurrRetryRate<60) && (priv->LastRetryRate < 65)) {
+		} else if ((CurrRetryRate < 60) && (priv->LastRetryRate < 65)) {
 //		else if ( (CurrRetryRate<80) && (priv->LastRetryRate < 85))
 			bTryUp = true;
 		}
 		//printk("case10---5.5M \n");
-	} else if ( priv->CurrentOperaRate == 4 ) {
+	} else if (priv->CurrentOperaRate == 4) {
 		//2For 2 Mbps
-		if((CurrRetryRate>99) && (priv->LastRetryRate>99)) {
+		if ((CurrRetryRate > 99) && (priv->LastRetryRate > 99)) {
 //		if((CurrRetryRate>199) && (priv->LastRetryRate>199))
 			bTryDown = true;
-		} else if ( (CurrRetryRate < 65) && (priv->LastRetryRate < 70)) {
+		} else if ((CurrRetryRate < 65) && (priv->LastRetryRate < 70)) {
 //		else if ( (CurrRetryRate < 85) && (priv->LastRetryRate < 90))
 			bTryUp = true;
 		}
 		//printk("case11---2M \n");
-	} else if ( priv->CurrentOperaRate == 2 ) {
+	} else if (priv->CurrentOperaRate == 2) {
 		//2For 1 Mbps
-		if( (CurrRetryRate<70) && (priv->LastRetryRate<75)) {
+		if ((CurrRetryRate < 70) && (priv->LastRetryRate < 75)) {
 //		if( (CurrRetryRate<90) && (priv->LastRetryRate<95))
 			bTryUp = true;
 		}
 		//printk("case12---1M \n");
 	}
 
-	if(bTryUp && bTryDown)
+	if (bTryUp && bTryDown)
 	printk("StaRateAdaptive87B(): Tx Rate tried upping and downing simultaneously!\n");
 
 	//1 Test Upgrading Tx Rate
 	// Sometimes the cause of the low throughput (high retry rate) is the compatibility between the AP and NIC.
 	// To test if the upper rate may cause lower retry rate, this mechanism randomly occurs to test upgrading tx rate.
-	if(!bTryUp && !bTryDown && (priv->TryupingCount == 0) && (priv->TryDownCountLowData == 0)
+	if (!bTryUp && !bTryDown && (priv->TryupingCount == 0) && (priv->TryDownCountLowData == 0)
 		&& priv->CurrentOperaRate != priv->ieee80211->current_network.HighestOperaRate && priv->FailTxRateCount < 2) {
-		if(jiffies% (CurrRetryRate + 101) == 0) {
+		if (jiffies % (CurrRetryRate + 101) == 0) {
 			bTryUp = true;
 			priv->bTryuping = true;
 			//printk("StaRateAdaptive87SE(): Randomly try upgrading...\n");
@@ -836,7 +806,7 @@ StaRateAdaptive87SE(
 	}
 
 	//1 Rate Mechanism
-	if(bTryUp) {
+	if (bTryUp) {
 		priv->TryupingCount++;
 		priv->TryDownCountLowData = 0;
 
@@ -852,21 +822,21 @@ StaRateAdaptive87SE(
 		// this condition will be satisfied at most every 2 min.
 		//
 
-		if((priv->TryupingCount > (TryUpTh + priv->FailTxRateCount * priv->FailTxRateCount)) ||
+		if ((priv->TryupingCount > (TryUpTh + priv->FailTxRateCount * priv->FailTxRateCount)) ||
 			(CurrSignalStrength > priv->LastFailTxRateSS) || priv->bTryuping) {
 			priv->TryupingCount = 0;
 			//
 			// When transferring from CCK to OFDM, DIG is an important issue.
 			//
-			if(priv->CurrentOperaRate == 22)
+			if (priv->CurrentOperaRate == 22)
 				bUpdateInitialGain = true;
 
 			// The difference in throughput between 48Mbps and 36Mbps is 8M.
 			// So, we must be carefully in this rate scale. Isaiah 2008-02-15.
 			//
-			if(  ((priv->CurrentOperaRate == 72) || (priv->CurrentOperaRate == 48) || (priv->CurrentOperaRate == 36)) &&
-				(priv->FailTxRateCount > 2) )
-				priv->RateAdaptivePeriod= (RATE_ADAPTIVE_TIMER_PERIOD/2);
+			if (((priv->CurrentOperaRate == 72) || (priv->CurrentOperaRate == 48) || (priv->CurrentOperaRate == 36)) &&
+				(priv->FailTxRateCount > 2))
+				priv->RateAdaptivePeriod = (RATE_ADAPTIVE_TIMER_PERIOD / 2);
 
 			// (1)To avoid upgrade frequently to the fail tx rate, add the FailTxRateCount into the threshold.
 			// (2)If the signal strength is increased, it may be able to upgrade.
@@ -875,29 +845,29 @@ StaRateAdaptive87SE(
 //			printk("StaRateAdaptive87SE(): Upgrade Tx Rate to %d\n", priv->CurrentOperaRate);
 
 			//[TRC Dell Lab] Bypass 12/9/6, Isaiah 2008-02-18 20:00
-			if(priv->CurrentOperaRate ==36) {
-				priv->bUpdateARFR=true;
+			if (priv->CurrentOperaRate == 36) {
+				priv->bUpdateARFR = true;
 				write_nic_word(dev, ARFR, 0x0F8F); //bypass 12/9/6
 //				printk("UP: ARFR=0xF8F\n");
 			} else if(priv->bUpdateARFR) {
-				priv->bUpdateARFR=false;
+				priv->bUpdateARFR = false;
 				write_nic_word(dev, ARFR, 0x0FFF); //set 1M ~ 54Mbps.
 //				printk("UP: ARFR=0xFFF\n");
 			}
 
 			// Update Fail Tx rate and count.
-			if(priv->LastFailTxRate != priv->CurrentOperaRate) {
+			if (priv->LastFailTxRate != priv->CurrentOperaRate) {
 				priv->LastFailTxRate = priv->CurrentOperaRate;
 				priv->FailTxRateCount = 0;
 				priv->LastFailTxRateSS = -200; // Set lowest power.
 			}
 		}
 	} else {
-		if(priv->TryupingCount > 0)
+		if (priv->TryupingCount > 0)
 			priv->TryupingCount --;
 	}
 
-	if(bTryDown) {
+	if (bTryDown) {
 		priv->TryDownCountLowData++;
 		priv->TryupingCount = 0;
 
@@ -907,14 +877,14 @@ StaRateAdaptive87SE(
 
 
 		//Check if Tx rate can be degraded or Test trying upgrading should fallback.
-		if(priv->TryDownCountLowData > TryDownTh || priv->bTryuping) {
+		if (priv->TryDownCountLowData > TryDownTh || priv->bTryuping) {
 			priv->TryDownCountLowData = 0;
 			priv->bTryuping = false;
 			// Update fail information.
-			if(priv->LastFailTxRate == priv->CurrentOperaRate) {
-				priv->FailTxRateCount ++;
+			if (priv->LastFailTxRate == priv->CurrentOperaRate) {
+				priv->FailTxRateCount++;
 				// Record the Tx fail rate signal strength.
-				if(CurrSignalStrength > priv->LastFailTxRateSS)
+				if (CurrSignalStrength > priv->LastFailTxRateSS)
 					priv->LastFailTxRateSS = CurrSignalStrength;
 			} else {
 				priv->LastFailTxRate = priv->CurrentOperaRate;
@@ -925,18 +895,18 @@ StaRateAdaptive87SE(
 
 			// Reduce chariot training time at weak signal strength situation. SD3 ED demand.
 			//[TRC Dell Lab] Revise Signal Threshold from -75 to -80 , Isaiah 2008-02-18 20:00
-			if( (CurrSignalStrength < -80) && (priv->CurrentOperaRate > 72 )) {
+			if ((CurrSignalStrength < -80) && (priv->CurrentOperaRate > 72 )) {
 				priv->CurrentOperaRate = 72;
 //				printk("DN: weak signal strength (%d), degrade to 36Mbps\n", CurrSignalStrength);
 			}
 
 			//[TRC Dell Lab] Bypass 12/9/6, Isaiah 2008-02-18 20:00
-			if(priv->CurrentOperaRate ==36) {
-				priv->bUpdateARFR=true;
+			if (priv->CurrentOperaRate == 36) {
+				priv->bUpdateARFR = true;
 				write_nic_word(dev, ARFR, 0x0F8F); //bypass 12/9/6
 //				printk("DN: ARFR=0xF8F\n");
-			} else if(priv->bUpdateARFR) {
-				priv->bUpdateARFR=false;
+			} else if (priv->bUpdateARFR) {
+				priv->bUpdateARFR = false;
 				write_nic_word(dev, ARFR, 0x0FFF); //set 1M ~ 54Mbps.
 //				printk("DN: ARFR=0xFFF\n");
 			}
@@ -944,21 +914,21 @@ StaRateAdaptive87SE(
 			//
 			// When it is CCK rate, it may need to update initial gain to receive lower power packets.
 			//
-			if(MgntIsCckRate(priv->CurrentOperaRate)) {
+			if (MgntIsCckRate(priv->CurrentOperaRate)) {
 				bUpdateInitialGain = true;
 			}
 //			printk("StaRateAdaptive87SE(): Degrade Tx Rate to %d\n", priv->CurrentOperaRate);
 		}
 	} else {
-		if(priv->TryDownCountLowData > 0)
-			priv->TryDownCountLowData --;
+		if (priv->TryDownCountLowData > 0)
+			priv->TryDownCountLowData--;
 	}
 
 	// Keep the Tx fail rate count to equal to 0x15 at most.
 	// Reduce the fail count at least to 10 sec if tx rate is tending stable.
-	if(priv->FailTxRateCount >= 0x15 ||
+	if (priv->FailTxRateCount >= 0x15 ||
 		(!bTryUp && !bTryDown && priv->TryDownCountLowData == 0 && priv->TryupingCount && priv->FailTxRateCount > 0x6)) {
-		priv->FailTxRateCount --;
+		priv->FailTxRateCount--;
 	}
 
 
@@ -966,41 +936,41 @@ StaRateAdaptive87SE(
 	CckTxPwrIdx  = priv->chtxpwr[priv->ieee80211->current_network.channel];
 
 	//[TRC Dell Lab] Mac0x9e increase 2 level in 36M~18M situation, Isaiah 2008-02-18 24:00
-	if((priv->CurrentOperaRate < 96) &&(priv->CurrentOperaRate > 22)) {
+	if ((priv->CurrentOperaRate < 96) && (priv->CurrentOperaRate > 22)) {
 		u1bCck = read_nic_byte(dev, CCK_TXAGC);
 		u1bOfdm = read_nic_byte(dev, OFDM_TXAGC);
 
 		// case 1: Never enter High power
-		if(u1bCck == CckTxPwrIdx ) {
-			if(u1bOfdm != (OfdmTxPwrIdx+2) ) {
-			priv->bEnhanceTxPwr= true;
-			u1bOfdm = ((u1bOfdm+2) > 35) ? 35: (u1bOfdm+2);
+		if (u1bCck == CckTxPwrIdx) {
+			if (u1bOfdm != (OfdmTxPwrIdx + 2)) {
+			priv->bEnhanceTxPwr = true;
+			u1bOfdm = ((u1bOfdm + 2) > 35) ? 35: (u1bOfdm + 2);
 			write_nic_byte(dev, OFDM_TXAGC, u1bOfdm);
 //			printk("Enhance OFDM_TXAGC : +++++ u1bOfdm= 0x%x\n", u1bOfdm);
 			}
-		} else if(u1bCck < CckTxPwrIdx) {
+		} else if (u1bCck < CckTxPwrIdx) {
 		// case 2: enter high power
-			if(!priv->bEnhanceTxPwr) {
-				priv->bEnhanceTxPwr= true;
-				u1bOfdm = ((u1bOfdm+2) > 35) ? 35: (u1bOfdm+2);
+			if (!priv->bEnhanceTxPwr) {
+				priv->bEnhanceTxPwr = true;
+				u1bOfdm = ((u1bOfdm + 2) > 35) ? 35: (u1bOfdm + 2);
 				write_nic_byte(dev, OFDM_TXAGC, u1bOfdm);
 				//RT_TRACE(COMP_RATE, DBG_TRACE, ("Enhance OFDM_TXAGC(2) : +++++ u1bOfdm= 0x%x\n", u1bOfdm));
 			}
 		}
-	} else if(priv->bEnhanceTxPwr) {  //54/48/11/5.5/2/1
+	} else if (priv->bEnhanceTxPwr) {  //54/48/11/5.5/2/1
 		u1bCck = read_nic_byte(dev, CCK_TXAGC);
 		u1bOfdm = read_nic_byte(dev, OFDM_TXAGC);
 
 		// case 1: Never enter High power
-		if(u1bCck == CckTxPwrIdx ) {
-			priv->bEnhanceTxPwr= false;
+		if (u1bCck == CckTxPwrIdx) {
+			priv->bEnhanceTxPwr = false;
 			write_nic_byte(dev, OFDM_TXAGC, OfdmTxPwrIdx);
 			//printk("Recover OFDM_TXAGC : ===== u1bOfdm= 0x%x\n", OfdmTxPwrIdx);
 		}
 		// case 2: enter high power
-		else if(u1bCck < CckTxPwrIdx) {
-			priv->bEnhanceTxPwr= false;
-			u1bOfdm = ((u1bOfdm-2) > 0) ? (u1bOfdm-2): 0;
+		else if (u1bCck < CckTxPwrIdx) {
+			priv->bEnhanceTxPwr = false;
+			u1bOfdm = ((u1bOfdm - 2) > 0) ? (u1bOfdm - 2): 0;
 			write_nic_byte(dev, OFDM_TXAGC, u1bOfdm);
 			//RT_TRACE(COMP_RATE, DBG_TRACE, ("Recover OFDM_TXAGC(2): ===== u1bOfdm= 0x%x\n", u1bOfdm));
 
@@ -1012,29 +982,29 @@ StaRateAdaptive87SE(
 	// "from CCK to OFDM".
 	//
 SetInitialGain:
-	if(bUpdateInitialGain) {
-		if(MgntIsCckRate(priv->CurrentOperaRate)) { // CCK
-			if(priv->InitialGain > priv->RegBModeGainStage) {
-				priv->InitialGainBackUp= priv->InitialGain;
+	if (bUpdateInitialGain) {
+		if (MgntIsCckRate(priv->CurrentOperaRate)) { // CCK
+			if (priv->InitialGain > priv->RegBModeGainStage) {
+				priv->InitialGainBackUp = priv->InitialGain;
 
-				if(CurrSignalStrength < -85) // Low power, OFDM [0x17] = 26.
+				if (CurrSignalStrength < -85) // Low power, OFDM [0x17] = 26.
 					//SD3 SYs suggest that CurrSignalStrength < -65, ofdm 0x17=26.
 					priv->InitialGain = priv->RegBModeGainStage;
 
-				else if(priv->InitialGain > priv->RegBModeGainStage + 1)
+				else if (priv->InitialGain > priv->RegBModeGainStage + 1)
 					priv->InitialGain -= 2;
 
 				else
-					priv->InitialGain --;
+					priv->InitialGain--;
 
 				printk("StaRateAdaptive87SE(): update init_gain to index %d for date rate %d\n",priv->InitialGain, priv->CurrentOperaRate);
 				UpdateInitialGain(dev);
 			}
 		} else { // OFDM
-			if(priv->InitialGain < 4) {
-				priv->InitialGainBackUp= priv->InitialGain;
+			if (priv->InitialGain < 4) {
+				priv->InitialGainBackUp = priv->InitialGain;
 
-				priv->InitialGain ++;
+				priv->InitialGain++;
 				printk("StaRateAdaptive87SE(): update init_gain to index %d for date rate %d\n",priv->InitialGain, priv->CurrentOperaRate);
 				UpdateInitialGain(dev);
 			}
@@ -1047,10 +1017,10 @@ SetInitialGain:
 	priv->ieee80211->rate = priv->CurrentOperaRate * 5;
 }
 
-void rtl8180_rate_adapter(struct work_struct * work)
+void rtl8180_rate_adapter(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
-	struct ieee80211_device *ieee = container_of(dwork,struct ieee80211_device,rate_adapter_wq);
+	struct ieee80211_device *ieee = container_of(dwork, struct ieee80211_device, rate_adapter_wq);
 	struct net_device *dev = ieee->dev;
 	//struct r8180_priv *priv = ieee80211_priv(dev);
 //    DMESG("---->rtl8180_rate_adapter");
@@ -1059,15 +1029,15 @@ void rtl8180_rate_adapter(struct work_struct * work)
 }
 void timer_rate_adaptive(unsigned long data)
 {
-	struct r8180_priv* priv = ieee80211_priv((struct net_device *)data);
+	struct r8180_priv *priv = ieee80211_priv((struct net_device *)data);
 	//DMESG("---->timer_rate_adaptive()\n");
-	if(!priv->up) {
+	if (!priv->up) {
 //		DMESG("<----timer_rate_adaptive():driver is not up!\n");
 		return;
 	}
-	if((priv->ieee80211->iw_mode != IW_MODE_MASTER)
+	if ((priv->ieee80211->iw_mode != IW_MODE_MASTER)
 			&& (priv->ieee80211->state == IEEE80211_LINKED) &&
-			(priv->ForcedDataRate == 0) ) {
+			(priv->ForcedDataRate == 0)) {
 //	DMESG("timer_rate_adaptive():schedule rate_adapter_wq\n");
 		queue_work(priv->ieee80211->wq, (void *)&priv->ieee80211->rate_adapter_wq);
 //		StaRateAdaptive87SE((struct net_device *)data);
@@ -1077,11 +1047,7 @@ void timer_rate_adaptive(unsigned long data)
 	//DMESG("<----timer_rate_adaptive()\n");
 }
 //by amy 080312}
-void
-SwAntennaDiversityRxOk8185(
-	struct net_device *dev,
-	u8 SignalStrength
-	)
+void SwAntennaDiversityRxOk8185(struct net_device *dev, u8 SignalStrength)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 
@@ -1089,13 +1055,13 @@ SwAntennaDiversityRxOk8185(
 
 	priv->AdRxOkCnt++;
 
-	if( priv->AdRxSignalStrength != -1) {
-		priv->AdRxSignalStrength = ((priv->AdRxSignalStrength*7) + (SignalStrength*3)) / 10;
+	if (priv->AdRxSignalStrength != -1) {
+		priv->AdRxSignalStrength = ((priv->AdRxSignalStrength * 7) + (SignalStrength * 3)) / 10;
 	} else { // Initialization case.
 		priv->AdRxSignalStrength = SignalStrength;
 	}
 //{+by amy 080312
-	if( priv->LastRxPktAntenna ) //Main antenna.
+	if (priv->LastRxPktAntenna) //Main antenna.
 		priv->AdMainAntennaRxOkCnt++;
 	else	 // Aux antenna.
 		priv->AdAuxAntennaRxOkCnt++;
@@ -1106,18 +1072,14 @@ SwAntennaDiversityRxOk8185(
 //	Description:
 //		Change Antenna Switch.
 //
-bool
-SetAntenna8185(
-	struct net_device *dev,
-	u8		u1bAntennaIndex
-	)
+bool SetAntenna8185(struct net_device *dev, u8 u1bAntennaIndex)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	bool bAntennaSwitched = false;
 
 //	printk("+SetAntenna8185(): Antenna is switching to: %d \n", u1bAntennaIndex);
 
-	switch(u1bAntennaIndex) {
+	switch (u1bAntennaIndex) {
 	case 0:
 		/* Mac register, main antenna */
 		write_nic_byte(dev, ANTSEL, 0x03);
@@ -1155,16 +1117,13 @@ SetAntenna8185(
 //	Description:
 //		Toggle Antenna switch.
 //
-bool
-SwitchAntenna(
-	struct net_device *dev
-	)
+bool SwitchAntenna(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 
 	bool		bResult;
 
-	if(priv->CurrAntennaIndex == 0) {
+	if (priv->CurrAntennaIndex == 0) {
 		bResult = SetAntenna8185(dev, 1);
 //by amy 080312
 //		printk("SwitchAntenna(): switching to antenna 1 ......\n");
@@ -1186,17 +1145,14 @@ SwitchAntenna(
 //
 //	2006.04.17, by rcnjko.
 //
-void
-SwAntennaDiversity(
-	struct net_device *dev
-	)
+void SwAntennaDiversity(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
-	bool   bSwCheckSS=false;
+	bool   bSwCheckSS = false;
 //	printk("+SwAntennaDiversity(): CurrAntennaIndex: %d\n", priv->CurrAntennaIndex);
 //	printk("AdTickCount is %d\n",priv->AdTickCount);
 //by amy 080312
-	if(bSwCheckSS) {
+	if (bSwCheckSS) {
 		priv->AdTickCount++;
 
 		printk("(1) AdTickCount: %d, AdCheckPeriod: %d\n",
@@ -1207,7 +1163,7 @@ SwAntennaDiversity(
 //	priv->AdTickCount++;//-by amy 080312
 
 	// Case 1. No Link.
-	if(priv->ieee80211->state != IEEE80211_LINKED) {
+	if (priv->ieee80211->state != IEEE80211_LINKED) {
 	//	printk("SwAntennaDiversity(): Case 1. No Link.\n");
 
 		priv->bAdSwitchedChecking = false;
@@ -1215,14 +1171,14 @@ SwAntennaDiversity(
 		SwitchAntenna(dev);
 
 	  // Case 2. Linked but no packet receive.d
-	} else if(priv->AdRxOkCnt == 0) {
+	} else if (priv->AdRxOkCnt == 0) {
 	//	printk("SwAntennaDiversity(): Case 2. Linked but no packet received.\n");
 
 		priv->bAdSwitchedChecking = false;
 		SwitchAntenna(dev);
 
 	  // Case 3. Evaluate last antenna switch action and undo it if necessary.
-	} else if(priv->bAdSwitchedChecking == true) {
+	} else if (priv->bAdSwitchedChecking == true) {
 	//	printk("SwAntennaDiversity(): Case 3. Evaluate last antenna switch action.\n");
 
 		priv->bAdSwitchedChecking = false;
@@ -1241,7 +1197,7 @@ SwAntennaDiversity(
 			priv->AdCheckPeriod *= 2;
 //by amy 080312
 			// Increase Antenna Diversity checking period.
-			if(priv->AdCheckPeriod > priv->AdMaxCheckPeriod)
+			if (priv->AdCheckPeriod > priv->AdMaxCheckPeriod)
 				priv->AdCheckPeriod = priv->AdMaxCheckPeriod;
 
 			// Wrong deceision => switch back.
@@ -1277,7 +1233,7 @@ SwAntennaDiversity(
 		// Evaluate RxOk count from each antenna if we shall switch default antenna now.
 		// Added by Roger, 2008.02.21.
 //{by amy 080312
-		if((priv->AdMainAntennaRxOkCnt < priv->AdAuxAntennaRxOkCnt)
+		if ((priv->AdMainAntennaRxOkCnt < priv->AdAuxAntennaRxOkCnt)
 			&& (priv->CurrAntennaIndex == 0)) {
 		// We set Main antenna as default but RxOk count was less than Aux ones.
 
@@ -1287,7 +1243,7 @@ SwAntennaDiversity(
 			// Switch to Aux antenna.
 			SwitchAntenna(dev);
 			priv->bHWAdSwitched = true;
-		} else if((priv->AdAuxAntennaRxOkCnt < priv->AdMainAntennaRxOkCnt)
+		} else if ((priv->AdAuxAntennaRxOkCnt < priv->AdMainAntennaRxOkCnt)
 			&& (priv->CurrAntennaIndex == 1)) {
 		// We set Aux antenna as default but RxOk count was less than Main ones.
 
@@ -1317,10 +1273,10 @@ SwAntennaDiversity(
 		// Our guess is that main antenna have lower throughput and get many change
 		// to receive more CCK packets(ex.Beacon) which have stronger SignalStrength.
 		//
-		if( (!priv->bHWAdSwitched) && (bSwCheckSS)) {
+		if ((!priv->bHWAdSwitched) && (bSwCheckSS)) {
 //by amy 080312}
 			// Evaluate Rx signal strength if we shall switch antenna now.
-			if(priv->AdRxSignalStrength < priv->AdRxSsThreshold) {
+			if (priv->AdRxSignalStrength < priv->AdRxSsThreshold) {
 			// Rx signal strength is weak => Switch Antenna.
 //				printk("SwAntennaDiversity(): Rx Signal Strength is weak, CurrRxSs: %d, RxSsThreshold: %d\n",
 //				priv->AdRxSignalStrength, priv->AdRxSsThreshold);
@@ -1336,7 +1292,7 @@ SwAntennaDiversity(
 
 				priv->bAdSwitchedChecking = false;
 				// Increase Rx signal strength threshold if necessary.
-				if(	(priv->AdRxSignalStrength > (priv->AdRxSsThreshold + 10)) && // Signal is much stronger than current threshold
+				if ((priv->AdRxSignalStrength > (priv->AdRxSsThreshold + 10)) && // Signal is much stronger than current threshold
 					priv->AdRxSsThreshold <= priv->AdMaxRxSsThreshold) { // Current threhold is not yet reach upper limit.
 
 					priv->AdRxSsThreshold = (priv->AdRxSsThreshold + priv->AdRxSignalStrength) / 2;
@@ -1345,7 +1301,7 @@ SwAntennaDiversity(
 				}
 
 				// Reduce Antenna Diversity checking period if possible.
-				if( priv->AdCheckPeriod > priv->AdMinCheckPeriod )
+				if (priv->AdCheckPeriod > priv->AdMinCheckPeriod)
 					priv->AdCheckPeriod /= 2;
 			}
 		}
@@ -1366,12 +1322,11 @@ SwAntennaDiversity(
 //	Description:
 //		Return TRUE if we shall perform Tx Power Tracking Mecahnism, FALSE otherwise.
 //
-bool
-CheckTxPwrTracking(	struct net_device *dev)
+bool CheckTxPwrTracking(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 
-	if(!priv->bTxPowerTrack)
+	if (!priv->bTxPowerTrack)
 		return false;
 
 //lzm reserved 080826
@@ -1381,7 +1336,7 @@ CheckTxPwrTracking(	struct net_device *dev)
 	//}
 
 	//if 87SE is in High Power , don't do Tx Power Tracking. asked by SD3 ED. 2008-08-08 Isaiah
-	if(priv->bToUpdateTxPwr)
+	if (priv->bToUpdateTxPwr)
 		return false;
 
 	return true;
@@ -1392,10 +1347,7 @@ CheckTxPwrTracking(	struct net_device *dev)
 //	Description:
 //		Timer callback function of SW Antenna Diversity.
 //
-void
-SwAntennaDiversityTimerCallback(
-	struct net_device *dev
-	)
+void SwAntennaDiversityTimerCallback(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	RT_RF_POWER_STATE rtState;
@@ -1418,9 +1370,9 @@ SwAntennaDiversityTimerCallback(
 		}
 		SwAntennaDiversity(dev);
 
-	} while(false);
+	} while (false);
 
-	if(priv->up) {
+	if (priv->up) {
 		priv->SwAntennaDiversityTimer.expires = jiffies + MSECS(ANTENNA_DIVERSITY_TIMER_PERIOD);
 		add_timer(&priv->SwAntennaDiversityTimer);
 	}
-- 
1.7.7.6

