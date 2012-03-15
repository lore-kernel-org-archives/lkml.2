Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161257Ab2COTHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 15:07:07 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44580 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031606Ab2COTHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 15:07:01 -0400
From: Andrew Miller <amiller@amilx.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        amiller@amilx.com
Subject: [PATCH 2/5] Staging: rtl8187se: r8180_dm.c: Fix brackets
Date: Thu, 15 Mar 2012 15:05:18 -0400
Message-Id: <1331838321-18453-3-git-send-email-amiller@amilx.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331838321-18453-1-git-send-email-amiller@amilx.com>
References: <1331838321-18453-1-git-send-email-amiller@amilx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix brackets that where out of place and removed
brackets that were not needed

Signed-off-by: Andrew Miller <amiller@amilx.com>
---
 drivers/staging/rtl8187se/r8180_dm.c |  531 +++++++++++-----------------------
 1 files changed, 166 insertions(+), 365 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_dm.c b/drivers/staging/rtl8187se/r8180_dm.c
index 80fd71c..97e4fef 100644
--- a/drivers/staging/rtl8187se/r8180_dm.c
+++ b/drivers/staging/rtl8187se/r8180_dm.c
@@ -17,14 +17,10 @@ bool CheckHighPower(struct net_device *dev)
 	struct ieee80211_device *ieee = priv->ieee80211;
 
 	if(!priv->bRegHighPowerMechanism)
-	{
 		return false;
-	}
 
 	if(ieee->state == IEEE80211_LINKED_SCANNING)
-	{
 		return false;
-	}
 
 	return true;
 }
@@ -70,8 +66,7 @@ DoTxHighPower(
 	//	printk("DoTxHighPower() - UndecoratedSmoothedSS:%d, CurCCKRSSI = %d , bCurCCKPkt= %d \n", priv->UndecoratedSmoothedSS, priv->CurCCKRSSI, priv->bCurCCKPkt );
 
 	if((priv->UndecoratedSmoothedSS > HiPwrUpperTh) ||
-		(priv->bCurCCKPkt && (priv->CurCCKRSSI > RSSIHiPwrUpperTh)))
-	{
+		(priv->bCurCCKPkt && (priv->CurCCKRSSI > RSSIHiPwrUpperTh))) {
 		// Stevenl suggested that degrade 8dbm in high power sate. 2007-12-04 Isaiah
 
 	//	printk("=====>DoTxHighPower() - High Power - UndecoratedSmoothedSS:%d,  HiPwrUpperTh = %d \n", priv->UndecoratedSmoothedSS, HiPwrUpperTh );
@@ -79,8 +74,7 @@ DoTxHighPower(
 		u1bTmp= read_nic_byte(dev, CCK_TXAGC);
 
 		// If it never enter High Power.
-		if( CckTxPwrIdx == u1bTmp)
-		{
+		if( CckTxPwrIdx == u1bTmp) {
 		u1bTmp = (u1bTmp > 16) ? (u1bTmp -16): 0;  // 8dbm
 		write_nic_byte(dev, CCK_TXAGC, u1bTmp);
 
@@ -89,26 +83,21 @@ DoTxHighPower(
 		write_nic_byte(dev, OFDM_TXAGC, u1bTmp);
 		}
 
-	}
-	else if((priv->UndecoratedSmoothedSS < HiPwrLowerTh) &&
-		(!priv->bCurCCKPkt || priv->CurCCKRSSI < RSSIHiPwrLowerTh))
-	{
+	} else if((priv->UndecoratedSmoothedSS < HiPwrLowerTh) &&
+		(!priv->bCurCCKPkt || priv->CurCCKRSSI < RSSIHiPwrLowerTh)) {
 	//	 printk("DoTxHighPower() - lower Power - UndecoratedSmoothedSS:%d,  HiPwrUpperTh = %d \n", priv->UndecoratedSmoothedSS, HiPwrLowerTh );
-		if(priv->bToUpdateTxPwr)
-		{
+		if(priv->bToUpdateTxPwr) {
 			priv->bToUpdateTxPwr = false;
 			//SD3 required.
 			u1bTmp= read_nic_byte(dev, CCK_TXAGC);
-			if(u1bTmp < CckTxPwrIdx)
-			{
+			if(u1bTmp < CckTxPwrIdx) {
 			//u1bTmp = ((u1bTmp+16) > 35) ? 35: (u1bTmp+16);  // 8dbm
 			//write_nic_byte(dev, CCK_TXAGC, u1bTmp);
 			write_nic_byte(dev, CCK_TXAGC, CckTxPwrIdx);
 			}
 
 			u1bTmp= read_nic_byte(dev, OFDM_TXAGC);
-			if(u1bTmp < OfdmTxPwrIdx)
-			{
+			if(u1bTmp < OfdmTxPwrIdx) {
 			//u1bTmp = ((u1bTmp+16) > 35) ? 35: (u1bTmp+16);  // 8dbm
 			//write_nic_byte(dev, OFDM_TXAGC, u1bTmp);
 			write_nic_byte(dev, OFDM_TXAGC, OfdmTxPwrIdx);
@@ -193,29 +182,25 @@ DIG_Zebra(
 //	printk("DIG**********OFDM False Alarm: %#X \n",OFDMFalseAlarm);
 
         // The number of initial gain steps is different, by Bruce, 2007-04-13.
-	if (priv->InitialGain == 0 ) //autoDIG
-	{ // Advised from SD3 DZ
+	if (priv->InitialGain == 0 ) { //autoDIG
+		// Advised from SD3 DZ
 		priv->InitialGain = 4; // In 87B, m74dBm means State 4 (m82dBm)
 	}
-	{ // Advised from SD3 DZ
-		OfdmFA1 =  0x20;
-	}
+	// Advised from SD3 DZ
+	OfdmFA1 =  0x20;
 
 #if 1 //lzm reserved 080826
 	AwakePeriodIn2Sec = (2000-priv ->DozePeriodInPast2Sec);
 	//printk("&&& DozePeriod=%d AwakePeriod=%d\n", priv->DozePeriodInPast2Sec, AwakePeriodIn2Sec);
 	priv ->DozePeriodInPast2Sec=0;
 
-	if(AwakePeriodIn2Sec)
-	{
+	if(AwakePeriodIn2Sec) {
 		//RT_TRACE(COMP_DIG, DBG_TRACE, ("DIG: AwakePeriodIn2Sec(%d) - FATh(0x%X , 0x%X) ->",AwakePeriodIn2Sec, OfdmFA1, OfdmFA2));
 		// adjuest DIG threshold.
 		OfdmFA1 =  (u16)((OfdmFA1*AwakePeriodIn2Sec)  / 2000) ;
 		OfdmFA2 =  (u16)((OfdmFA2*AwakePeriodIn2Sec)  / 2000) ;
 		//RT_TRACE(COMP_DIG, DBG_TRACE, ("( 0x%X , 0x%X)\n", OfdmFA1, OfdmFA2));
-	}
-	else
-	{
+	} else {
 		;//RT_TRACE(COMP_DIG, DBG_WARNING, ("ERROR!!  AwakePeriodIn2Sec should not be ZERO!!\n"));
 	}
 #endif
@@ -223,16 +208,12 @@ DIG_Zebra(
 	InitialGainStep = 8;
 	LowestGainStage = priv->RegBModeGainStage; // Lowest gain stage.
 
-	if (OFDMFalseAlarm > OfdmFA1)
-	{
-		if (OFDMFalseAlarm > OfdmFA2)
-		{
+	if (OFDMFalseAlarm > OfdmFA1) {
+		if (OFDMFalseAlarm > OfdmFA2) {
 			priv->DIG_NumberFallbackVote++;
-			if (priv->DIG_NumberFallbackVote >1)
-			{
+			if (priv->DIG_NumberFallbackVote >1) {
 				//serious OFDM  False Alarm, need fallback
-				if (priv->InitialGain < InitialGainStep)
-				{
+				if (priv->InitialGain < InitialGainStep) {
 					priv->InitialGainBackUp= priv->InitialGain;
 
 					priv->InitialGain = (priv->InitialGain + 1);
@@ -243,24 +224,18 @@ DIG_Zebra(
 				priv->DIG_NumberFallbackVote = 0;
 				priv->DIG_NumberUpgradeVote=0;
 			}
-		}
-		else
-		{
+		} else {
 			if (priv->DIG_NumberFallbackVote)
 				priv->DIG_NumberFallbackVote--;
 		}
 		priv->DIG_NumberUpgradeVote=0;
-	}
-	else
-	{
+	} else {
 		if (priv->DIG_NumberFallbackVote)
 			priv->DIG_NumberFallbackVote--;
 		priv->DIG_NumberUpgradeVote++;
 
-		if (priv->DIG_NumberUpgradeVote>9)
-		{
-			if (priv->InitialGain > LowestGainStage) // In 87B, m78dBm means State 4 (m864dBm)
-			{
+		if (priv->DIG_NumberUpgradeVote>9) {
+			if (priv->InitialGain > LowestGainStage) { // In 87B, m78dBm means State 4 (m864dBm)
 				priv->InitialGainBackUp= priv->InitialGain;
 
 				priv->InitialGain = (priv->InitialGain - 1);
@@ -317,18 +292,14 @@ IncludedInSupportedRates(
 
     rate_len = priv->ieee80211->current_network.rates_len;
         rate_ex_len = priv->ieee80211->current_network.rates_ex_len;
-        for( idx=0; idx< rate_len; idx++ )
-        {
-                if( (priv->ieee80211->current_network.rates[idx] & RateMask) == NaiveTxRate )
-                {
+        for( idx=0; idx< rate_len; idx++ ) {
+                if( (priv->ieee80211->current_network.rates[idx] & RateMask) == NaiveTxRate ) {
                         Found = 1;
                         goto found_rate;
                 }
         }
-    for( idx=0; idx< rate_ex_len; idx++ )
-        {
-                if( (priv->ieee80211->current_network.rates_ex[idx] & RateMask) == NaiveTxRate )
-                {
+    for( idx=0; idx< rate_ex_len; idx++ ) {
+                if( (priv->ieee80211->current_network.rates_ex[idx] & RateMask) == NaiveTxRate ) {
                         Found = 1;
                         goto found_rate;
                 }
@@ -354,8 +325,7 @@ GetUpgradeTxRate(
         u8                      UpRate;
 
         // Upgrade 1 degree.
-        switch(rate)
-        {
+        switch(rate) {
         case 108: // Up to 54Mbps.
                 UpRate = 108;
                 break;
@@ -397,13 +367,10 @@ GetUpgradeTxRate(
                 return rate;
         }
         // Check if the rate is valid.
-        if(IncludedInSupportedRates(priv, UpRate))
-        {
+        if(IncludedInSupportedRates(priv, UpRate)) {
 //              printk("GetUpgradeTxRate(): GetUpgrade Tx rate(%d) from %d !\n", UpRate, priv->CurrentOperaRate);
                 return UpRate;
-        }
-        else
-        {
+        } else {
                 //printk("GetUpgradeTxRate(): Tx rate (%d) is not in supported rates\n", UpRate);
                 return rate;
         }
@@ -425,8 +392,7 @@ GetDegradeTxRate(
         u8                      DownRate;
 
         // Upgrade 1 degree.
-        switch(rate)
-        {
+        switch(rate) {
         case 108: // Down to 48Mbps.
                 DownRate = 96;
                 break;
@@ -468,13 +434,10 @@ GetDegradeTxRate(
                 return rate;
         }
         // Check if the rate is valid.
-        if(IncludedInSupportedRates(priv, DownRate))
-        {
+        if(IncludedInSupportedRates(priv, DownRate)) {
 //              printk("GetDegradeTxRate(): GetDegrade Tx rate(%d) from %d!\n", DownRate, priv->CurrentOperaRate);
                 return DownRate;
-        }
-        else
-        {
+        } else {
                 //printk("GetDegradeTxRate(): Tx rate (%d) is not in supported rates\n", DownRate);
                 return rate;
         }
@@ -492,8 +455,7 @@ MgntIsCckRate(
 {
         bool bReturn = false;
 
-        if((rate <= 22) && (rate != 12) && (rate != 18))
-        {
+        if((rate <= 22) && (rate != 12) && (rate != 18)) {
                 bReturn = true;
         }
 
@@ -520,18 +482,16 @@ TxPwrTracking87SE(
 
 	//printk("TxPwrTracking87SE(): CurrentThermal(%d)\n", CurrentThermal);
 
-	if( CurrentThermal != priv->ThermalMeter)
-	{
+	if( CurrentThermal != priv->ThermalMeter) {
 //		printk("TxPwrTracking87SE(): Thermal meter changed!!!\n");
 
 		// Update Tx Power level on each channel.
-		for(Idx = 1; Idx<15; Idx++)
-		{
+		for(Idx = 1; Idx<15; Idx++) {
 			CckTxPwrIdx = priv->chtxpwr[Idx];
 			OfdmTxPwrIdx = priv->chtxpwr_ofdm[Idx];
 
-			if( CurrentThermal > priv->ThermalMeter )
-			{ // higher thermal meter.
+			if( CurrentThermal > priv->ThermalMeter ) { 
+				// higher thermal meter.
 				CckTxPwrIdx += (CurrentThermal - priv->ThermalMeter)*2;
 				OfdmTxPwrIdx += (CurrentThermal - priv->ThermalMeter)*2;
 
@@ -539,9 +499,8 @@ TxPwrTracking87SE(
 					CckTxPwrIdx = 35; // Force TxPower to maximal index.
 				if(OfdmTxPwrIdx >35)
 					OfdmTxPwrIdx = 35;
-			}
-			else
-			{ // lower thermal meter.
+			} else {
+				// lower thermal meter.
 				CckTxPwrIdx -= (priv->ThermalMeter - CurrentThermal)*2;
 				OfdmTxPwrIdx -= (priv->ThermalMeter - CurrentThermal)*2;
 
@@ -594,12 +553,10 @@ StaRateAdaptive87SE(
 	priv->CurrentOperaRate = priv->ieee80211->rate/5;
 	//printk("priv->CurrentOperaRate is %d\n",priv->CurrentOperaRate);
 	//2 Compute retry ratio.
-	if (CurrTxokCnt>0)
-	{
+	if (CurrTxokCnt>0) {
 		CurrRetryRate = (u16)(CurrRetryCnt*100/CurrTxokCnt);
-	}
-	else
-	{ // It may be serious retry. To distinguish serious retry or no packets modified by Bruce
+	} else {
+	// It may be serious retry. To distinguish serious retry or no packets modified by Bruce
 		CurrRetryRate = (u16)(CurrRetryCnt*100/1);
 	}
 
@@ -622,8 +579,7 @@ StaRateAdaptive87SE(
 	priv->CurrRetryCnt = 0;
 
 	//2No Tx packets, return to init_rate or not?
-	if (CurrRetryRate==0 && CurrTxokCnt == 0)
-	{
+	if (CurrRetryRate==0 && CurrTxokCnt == 0) {
 		//
 		//After 9 (30*300ms) seconds in this condition, we try to raise rate.
 		//
@@ -631,8 +587,7 @@ StaRateAdaptive87SE(
 
 //		printk("No Tx packets, TryupingCountNoData(%d)\n", priv->TryupingCountNoData);
 		//[TRC Dell Lab] Extend raised period from 4.5sec to 9sec, Isaiah 2008-02-15 18:00
-		if (priv->TryupingCountNoData>30)
-		{
+		if (priv->TryupingCountNoData>30) {
 			priv->TryupingCountNoData = 0;
 			priv->CurrentOperaRate = GetUpgradeTxRate(dev, priv->CurrentOperaRate);
 			// Reset Fail Record
@@ -641,9 +596,7 @@ StaRateAdaptive87SE(
 			priv->FailTxRateCount = 0;
 		}
 		goto SetInitialGain;
-	}
-        else
-	{
+	} else {
 		priv->TryupingCountNoData=0; //Reset trying up times.
 	}
 
@@ -671,20 +624,15 @@ StaRateAdaptive87SE(
 	// Check more times in these rate(key rates).
 	//
 	if(priv->CurrentOperaRate == 22 || priv->CurrentOperaRate == 72)
-	{
 		TryUpTh += 9;
-	}
 	//
 	// Let these rates down more difficult.
 	//
 	if(MgntIsCckRate(priv->CurrentOperaRate) || priv->CurrentOperaRate == 36)
-	{
 			TryDownTh += 1;
-	}
 
 	//1 Adjust Rate.
-	if (priv->bTryuping == true)
-	{
+	if (priv->bTryuping == true) {
 		//2 For Test Upgrading mechanism
 		// Note:
 		//	Sometimes the throughput is upon on the capability bwtween the AP and NIC,
@@ -692,21 +640,16 @@ StaRateAdaptive87SE(
 		//	We randomly upgrade the data rate and check if the retry rate is improved.
 
 		// Upgrading rate did not improve the retry rate, fallback to the original rate.
-		if ( (CurrRetryRate > 25) && TxThroughput < priv->LastTxThroughput)
-		{
+		if ( (CurrRetryRate > 25) && TxThroughput < priv->LastTxThroughput) {
 			//Not necessary raising rate, fall back rate.
 			bTryDown = true;
 			//printk("case1-1: Not necessary raising rate, fall back rate....\n");
 			//printk("case1-1: pMgntInfo->CurrentOperaRate =%d, TxThroughput = %d, LastThroughput = %d\n",
 			//		priv->CurrentOperaRate, TxThroughput, priv->LastTxThroughput);
-		}
-		else
-		{
+		} else {
 			priv->bTryuping = false;
 		}
-	}
-	else if (CurrSignalStrength > -47 && (CurrRetryRate < 50))
-	{
+	} else if (CurrSignalStrength > -47 && (CurrRetryRate < 50)) {
 		//2For High Power
 		//
 		// Added by Roger, 2007.04.09.
@@ -715,17 +658,14 @@ StaRateAdaptive87SE(
 		// Revise SignalStrength threshold to -51dbm.
 		//
 		// Also need to check retry rate for safety, by Bruce, 2007-06-05.
-		if(priv->CurrentOperaRate != priv->ieee80211->current_network.HighestOperaRate )
-		{
+		if(priv->CurrentOperaRate != priv->ieee80211->current_network.HighestOperaRate ) {
 			bTryUp = true;
 			// Upgrade Tx Rate directly.
 			priv->TryupingCount += TryUpTh;
 		}
 //		printk("case2: StaRateAdaptive87SE: Power(%d) is high enough!!. \n", CurrSignalStrength);
 
-	}
-	else if(CurrTxokCnt > 9 && CurrTxokCnt< 100 && CurrRetryRate >= 600)
-	{
+	} else if(CurrTxokCnt > 9 && CurrTxokCnt< 100 && CurrRetryRate >= 600) {
 		//2 For Serious Retry
 		//
 		// Traffic is not busy but our Tx retry is serious.
@@ -734,208 +674,147 @@ StaRateAdaptive87SE(
 		// Let Rate Mechanism to degrade tx rate directly.
 		priv->TryDownCountLowData += TryDownTh;
 //		printk("case3: RA: Tx Retry is serious. Degrade Tx Rate to %d directly...\n", priv->CurrentOperaRate);
-	}
-	else if ( priv->CurrentOperaRate == 108 )
-	{
+	} else if ( priv->CurrentOperaRate == 108 ) {
 		//2For 54Mbps
 		// Air Link
-		if ( (CurrRetryRate>26)&&(priv->LastRetryRate>25))
+		if ( (CurrRetryRate>26)&&(priv->LastRetryRate>25)) {
 //		if ( (CurrRetryRate>40)&&(priv->LastRetryRate>39))
-		{
 			//Down to rate 48Mbps.
 			bTryDown = true;
 		}
 		// Cable Link
-		else if ( (CurrRetryRate>17)&&(priv->LastRetryRate>16) && (CurrSignalStrength > -72))
+		else if ( (CurrRetryRate>17)&&(priv->LastRetryRate>16) && (CurrSignalStrength > -72)) {
 //		else if ( (CurrRetryRate>17)&&(priv->LastRetryRate>16) && (CurrSignalStrength > -72))
-		{
 			//Down to rate 48Mbps.
 			bTryDown = true;
 		}
 
 		if(bTryDown && (CurrSignalStrength < -75)) //cable link
-		{
 			priv->TryDownCountLowData += TryDownTh;
-		}
 		//printk("case4---54M \n");
 
 	}
-	else if ( priv->CurrentOperaRate == 96 )
-	{
+	else if ( priv->CurrentOperaRate == 96 ) {
 		//2For 48Mbps
 		//Air Link
-		if ( ((CurrRetryRate>48) && (priv->LastRetryRate>47)))
+		if ( ((CurrRetryRate>48) && (priv->LastRetryRate>47))) {
 //		if ( ((CurrRetryRate>65) && (priv->LastRetryRate>64)))
-
-		{
 			//Down to rate 36Mbps.
 			bTryDown = true;
-		}
-		//Cable Link
-		else if ( ((CurrRetryRate>21) && (priv->LastRetryRate>20)) && (CurrSignalStrength > -74))
-		{
+		} else if ( ((CurrRetryRate>21) && (priv->LastRetryRate>20)) && (CurrSignalStrength > -74)) { //Cable Link	
 			//Down to rate 36Mbps.
 			bTryDown = true;
-		}
-		else if((CurrRetryRate>  (priv->LastRetryRate + 50 )) && (priv->FailTxRateCount >2 ))
+		} else if((CurrRetryRate>  (priv->LastRetryRate + 50 )) && (priv->FailTxRateCount >2 )) {
 //		else if((CurrRetryRate>  (priv->LastRetryRate + 70 )) && (priv->FailTxRateCount >2 ))
-		{
 			bTryDown = true;
 			priv->TryDownCountLowData += TryDownTh;
-		}
-		else if ( (CurrRetryRate<8) && (priv->LastRetryRate<8) ) //TO DO: need to consider (RSSI)
+		} else if ( (CurrRetryRate<8) && (priv->LastRetryRate<8) ) { //TO DO: need to consider (RSSI)
 //		else if ( (CurrRetryRate<28) && (priv->LastRetryRate<8) )
-		{
 			bTryUp = true;
 		}
 
-		if(bTryDown && (CurrSignalStrength < -75))
-		{
+		if(bTryDown && (CurrSignalStrength < -75)){
 			priv->TryDownCountLowData += TryDownTh;
 		}
 		//printk("case5---48M \n");
-	}
-	else if ( priv->CurrentOperaRate == 72 )
-	{
+	} else if ( priv->CurrentOperaRate == 72 ) {
 		//2For 36Mbps
-		if ( (CurrRetryRate>43) && (priv->LastRetryRate>41))
+		if ( (CurrRetryRate>43) && (priv->LastRetryRate>41)) {
 //		if ( (CurrRetryRate>60) && (priv->LastRetryRate>59))
-		{
 			//Down to rate 24Mbps.
 			bTryDown = true;
-		}
-		else if((CurrRetryRate>  (priv->LastRetryRate + 50 )) && (priv->FailTxRateCount >2 ))
+		} else if((CurrRetryRate>  (priv->LastRetryRate + 50 )) && (priv->FailTxRateCount >2 )) {
 //		else if((CurrRetryRate>  (priv->LastRetryRate + 70 )) && (priv->FailTxRateCount >2 ))
-		{
 			bTryDown = true;
 			priv->TryDownCountLowData += TryDownTh;
-		}
-		else if ( (CurrRetryRate<15) &&  (priv->LastRetryRate<16)) //TO DO: need to consider (RSSI)
+		} else if ( (CurrRetryRate<15) &&  (priv->LastRetryRate<16)) { //TO DO: need to consider (RSSI)
 //		else if ( (CurrRetryRate<35) &&  (priv->LastRetryRate<36))
-		{
 			bTryUp = true;
 		}
 
 		if(bTryDown && (CurrSignalStrength < -80))
-		{
 			priv->TryDownCountLowData += TryDownTh;
-		}
+
 		//printk("case6---36M \n");
-	}
-	else if ( priv->CurrentOperaRate == 48 )
-	{
+	} else if ( priv->CurrentOperaRate == 48 ) {
 		//2For 24Mbps
 		// Air Link
-		if ( ((CurrRetryRate>63) && (priv->LastRetryRate>62)))
+		if ( ((CurrRetryRate>63) && (priv->LastRetryRate>62))) {
 //		if ( ((CurrRetryRate>83) && (priv->LastRetryRate>82)))
-		{
 			//Down to rate 18Mbps.
 			bTryDown = true;
-		}
-		//Cable Link
-		else if ( ((CurrRetryRate>33) && (priv->LastRetryRate>32)) && (CurrSignalStrength > -82) )
+		} else if ( ((CurrRetryRate>33) && (priv->LastRetryRate>32)) && (CurrSignalStrength > -82) ) { //Cable Link
 //		 else if ( ((CurrRetryRate>50) && (priv->LastRetryRate>49)) && (CurrSignalStrength > -82) )
-		{
 			//Down to rate 18Mbps.
 			bTryDown = true;
-		}
-		else if((CurrRetryRate>  (priv->LastRetryRate + 50 )) && (priv->FailTxRateCount >2 ))
+		} else if((CurrRetryRate>  (priv->LastRetryRate + 50 )) && (priv->FailTxRateCount >2 )) {
 //		else if((CurrRetryRate>  (priv->LastRetryRate + 70 )) && (priv->FailTxRateCount >2 ))
-
-		{
 			bTryDown = true;
 			priv->TryDownCountLowData += TryDownTh;
-		}
-		else if ( (CurrRetryRate<20) && (priv->LastRetryRate<21)) //TO DO: need to consider (RSSI)
+		} else if ( (CurrRetryRate<20) && (priv->LastRetryRate<21)) { //TO DO: need to consider (RSSI)
 //		else if ( (CurrRetryRate<40) && (priv->LastRetryRate<41))
-		{
 			bTryUp = true;
 		}
 
 		if(bTryDown && (CurrSignalStrength < -82))
-		{
 			priv->TryDownCountLowData += TryDownTh;
-		}
+
 		//printk("case7---24M \n");
-	}
-	else if ( priv->CurrentOperaRate == 36 )
-	{
+	} else if ( priv->CurrentOperaRate == 36 ) {
 		//2For 18Mbps
 		// original (109, 109)
 		//[TRC Dell Lab] (90, 91), Isaiah 2008-02-18 23:24
 		//			     (85, 86), Isaiah 2008-02-18 24:00
-		if ( ((CurrRetryRate>85) && (priv->LastRetryRate>86)))
+		if ( ((CurrRetryRate>85) && (priv->LastRetryRate>86))) {
 //		if ( ((CurrRetryRate>115) && (priv->LastRetryRate>116)))
-		{
 			//Down to rate 11Mbps.
 			bTryDown = true;
-		}
-		//[TRC Dell Lab]  Isaiah 2008-02-18 23:24
-		else if((CurrRetryRate>  (priv->LastRetryRate + 50 )) && (priv->FailTxRateCount >2 ))
+
+		  //[TRC Dell Lab]  Isaiah 2008-02-18 23:24
+		} else if((CurrRetryRate>  (priv->LastRetryRate + 50 )) && (priv->FailTxRateCount >2 )) { 
 //		else if((CurrRetryRate>  (priv->LastRetryRate + 70 )) && (priv->FailTxRateCount >2 ))
-		{
 			bTryDown = true;
 			priv->TryDownCountLowData += TryDownTh;
-		}
-		else if ( (CurrRetryRate<22) && (priv->LastRetryRate<23)) //TO DO: need to consider (RSSI)
+		} else if ( (CurrRetryRate<22) && (priv->LastRetryRate<23)) { //TO DO: need to consider (RSSI)
 //		else if ( (CurrRetryRate<42) && (priv->LastRetryRate<43))
-		{
 			bTryUp = true;
 		}
 		//printk("case8---18M \n");
-	}
-	else if ( priv->CurrentOperaRate == 22 )
-	{
+	} else if ( priv->CurrentOperaRate == 22 ) {
 		//2For 11Mbps
-		if (CurrRetryRate>95)
+		if (CurrRetryRate>95) {
 //		if (CurrRetryRate>155)
-		{
 			bTryDown = true;
 		}
-		else if ( (CurrRetryRate<29) && (priv->LastRetryRate <30) )//TO DO: need to consider (RSSI)
+		else if ( (CurrRetryRate<29) && (priv->LastRetryRate <30) ) { //TO DO: need to consider (RSSI)
 //		else if ( (CurrRetryRate<49) && (priv->LastRetryRate <50) )
-			{
 			bTryUp = true;
-			}
-		//printk("case9---11M \n");
 		}
-	else if ( priv->CurrentOperaRate == 11 )
-	{
+		//printk("case9---11M \n");
+	} else if ( priv->CurrentOperaRate == 11 ) {
 		//2For 5.5Mbps
-		if (CurrRetryRate>149)
+		if (CurrRetryRate>149) {
 //		if (CurrRetryRate>189)
-		{
 			bTryDown = true;
-		}
-		else if ( (CurrRetryRate<60) && (priv->LastRetryRate < 65))
+		} else if ( (CurrRetryRate<60) && (priv->LastRetryRate < 65)) {
 //		else if ( (CurrRetryRate<80) && (priv->LastRetryRate < 85))
-
-			{
 			bTryUp = true;
-			}
-		//printk("case10---5.5M \n");
 		}
-	else if ( priv->CurrentOperaRate == 4 )
-	{
+		//printk("case10---5.5M \n");
+	} else if ( priv->CurrentOperaRate == 4 ) {
 		//2For 2 Mbps
-		if((CurrRetryRate>99) && (priv->LastRetryRate>99))
+		if((CurrRetryRate>99) && (priv->LastRetryRate>99)) {
 //		if((CurrRetryRate>199) && (priv->LastRetryRate>199))
-		{
 			bTryDown = true;
-		}
-		else if ( (CurrRetryRate < 65) && (priv->LastRetryRate < 70))
+		} else if ( (CurrRetryRate < 65) && (priv->LastRetryRate < 70)) {
 //		else if ( (CurrRetryRate < 85) && (priv->LastRetryRate < 90))
-		{
 			bTryUp = true;
 		}
 		//printk("case11---2M \n");
-	}
-	else if ( priv->CurrentOperaRate == 2 )
-	{
+	} else if ( priv->CurrentOperaRate == 2 ) {
 		//2For 1 Mbps
-		if( (CurrRetryRate<70) && (priv->LastRetryRate<75))
+		if( (CurrRetryRate<70) && (priv->LastRetryRate<75)) {
 //		if( (CurrRetryRate<90) && (priv->LastRetryRate<95))
-		{
 			bTryUp = true;
 		}
 		//printk("case12---1M \n");
@@ -948,10 +827,8 @@ StaRateAdaptive87SE(
 	// Sometimes the cause of the low throughput (high retry rate) is the compatibility between the AP and NIC.
 	// To test if the upper rate may cause lower retry rate, this mechanism randomly occurs to test upgrading tx rate.
 	if(!bTryUp && !bTryDown && (priv->TryupingCount == 0) && (priv->TryDownCountLowData == 0)
-		&& priv->CurrentOperaRate != priv->ieee80211->current_network.HighestOperaRate && priv->FailTxRateCount < 2)
-	{
-		if(jiffies% (CurrRetryRate + 101) == 0)
-		{
+		&& priv->CurrentOperaRate != priv->ieee80211->current_network.HighestOperaRate && priv->FailTxRateCount < 2) {
+		if(jiffies% (CurrRetryRate + 101) == 0) {
 			bTryUp = true;
 			priv->bTryuping = true;
 			//printk("StaRateAdaptive87SE(): Randomly try upgrading...\n");
@@ -959,18 +836,14 @@ StaRateAdaptive87SE(
 	}
 
 	//1 Rate Mechanism
-	if(bTryUp)
-	{
+	if(bTryUp) {
 		priv->TryupingCount++;
 		priv->TryDownCountLowData = 0;
 
-		{
 //			printk("UP: pHalData->TryupingCount = %d\n", priv->TryupingCount);
 //			printk("UP: TryUpTh(%d)+ (FailTxRateCount(%d))^2 =%d\n",
 //				TryUpTh, priv->FailTxRateCount, (TryUpTh + priv->FailTxRateCount * priv->FailTxRateCount) );
-//			printk("UP: pHalData->bTryuping=%d\n",  priv->bTryuping);
-
-		}
+//			printk("UP: pHalData->bTryuping=%d\n",  priv->bTryuping);}
 
 		//
 		// Check more times if we need to upgrade indeed.
@@ -980,8 +853,7 @@ StaRateAdaptive87SE(
 		//
 
 		if((priv->TryupingCount > (TryUpTh + priv->FailTxRateCount * priv->FailTxRateCount)) ||
-			(CurrSignalStrength > priv->LastFailTxRateSS) || priv->bTryuping)
-		{
+			(CurrSignalStrength > priv->LastFailTxRateSS) || priv->bTryuping) {
 			priv->TryupingCount = 0;
 			//
 			// When transferring from CCK to OFDM, DIG is an important issue.
@@ -1003,61 +875,48 @@ StaRateAdaptive87SE(
 //			printk("StaRateAdaptive87SE(): Upgrade Tx Rate to %d\n", priv->CurrentOperaRate);
 
 			//[TRC Dell Lab] Bypass 12/9/6, Isaiah 2008-02-18 20:00
-			if(priv->CurrentOperaRate ==36)
-			{
+			if(priv->CurrentOperaRate ==36) {
 				priv->bUpdateARFR=true;
 				write_nic_word(dev, ARFR, 0x0F8F); //bypass 12/9/6
 //				printk("UP: ARFR=0xF8F\n");
-			}
-			else if(priv->bUpdateARFR)
-			{
+			} else if(priv->bUpdateARFR) {
 				priv->bUpdateARFR=false;
 				write_nic_word(dev, ARFR, 0x0FFF); //set 1M ~ 54Mbps.
 //				printk("UP: ARFR=0xFFF\n");
 			}
 
 			// Update Fail Tx rate and count.
-			if(priv->LastFailTxRate != priv->CurrentOperaRate)
-			{
+			if(priv->LastFailTxRate != priv->CurrentOperaRate) {
 				priv->LastFailTxRate = priv->CurrentOperaRate;
 				priv->FailTxRateCount = 0;
 				priv->LastFailTxRateSS = -200; // Set lowest power.
 			}
 		}
-	}
-	else
-	{
+	} else {
 		if(priv->TryupingCount > 0)
 			priv->TryupingCount --;
 	}
 
-	if(bTryDown)
-	{
+	if(bTryDown) {
 		priv->TryDownCountLowData++;
 		priv->TryupingCount = 0;
-		{
+
 //			printk("DN: pHalData->TryDownCountLowData = %d\n",priv->TryDownCountLowData);
 //			printk("DN: TryDownTh =%d\n", TryDownTh);
 //			printk("DN: pHalData->bTryuping=%d\n",  priv->bTryuping);
-		}
+
 
 		//Check if Tx rate can be degraded or Test trying upgrading should fallback.
-		if(priv->TryDownCountLowData > TryDownTh || priv->bTryuping)
-		{
+		if(priv->TryDownCountLowData > TryDownTh || priv->bTryuping) {
 			priv->TryDownCountLowData = 0;
 			priv->bTryuping = false;
 			// Update fail information.
-			if(priv->LastFailTxRate == priv->CurrentOperaRate)
-			{
+			if(priv->LastFailTxRate == priv->CurrentOperaRate) {
 				priv->FailTxRateCount ++;
 				// Record the Tx fail rate signal strength.
 				if(CurrSignalStrength > priv->LastFailTxRateSS)
-				{
 					priv->LastFailTxRateSS = CurrSignalStrength;
-				}
-			}
-			else
-			{
+			} else {
 				priv->LastFailTxRate = priv->CurrentOperaRate;
 				priv->FailTxRateCount = 1;
 				priv->LastFailTxRateSS = CurrSignalStrength;
@@ -1066,21 +925,17 @@ StaRateAdaptive87SE(
 
 			// Reduce chariot training time at weak signal strength situation. SD3 ED demand.
 			//[TRC Dell Lab] Revise Signal Threshold from -75 to -80 , Isaiah 2008-02-18 20:00
-			if( (CurrSignalStrength < -80) && (priv->CurrentOperaRate > 72 ))
-			{
+			if( (CurrSignalStrength < -80) && (priv->CurrentOperaRate > 72 )) {
 				priv->CurrentOperaRate = 72;
 //				printk("DN: weak signal strength (%d), degrade to 36Mbps\n", CurrSignalStrength);
 			}
 
 			//[TRC Dell Lab] Bypass 12/9/6, Isaiah 2008-02-18 20:00
-			if(priv->CurrentOperaRate ==36)
-			{
+			if(priv->CurrentOperaRate ==36) {
 				priv->bUpdateARFR=true;
 				write_nic_word(dev, ARFR, 0x0F8F); //bypass 12/9/6
 //				printk("DN: ARFR=0xF8F\n");
-			}
-			else if(priv->bUpdateARFR)
-			{
+			} else if(priv->bUpdateARFR) {
 				priv->bUpdateARFR=false;
 				write_nic_word(dev, ARFR, 0x0FFF); //set 1M ~ 54Mbps.
 //				printk("DN: ARFR=0xFFF\n");
@@ -1089,15 +944,12 @@ StaRateAdaptive87SE(
 			//
 			// When it is CCK rate, it may need to update initial gain to receive lower power packets.
 			//
-			if(MgntIsCckRate(priv->CurrentOperaRate))
-			{
+			if(MgntIsCckRate(priv->CurrentOperaRate)) {
 				bUpdateInitialGain = true;
 			}
 //			printk("StaRateAdaptive87SE(): Degrade Tx Rate to %d\n", priv->CurrentOperaRate);
 		}
-	}
-	else
-	{
+	} else {
 		if(priv->TryDownCountLowData > 0)
 			priv->TryDownCountLowData --;
 	}
@@ -1105,8 +957,7 @@ StaRateAdaptive87SE(
 	// Keep the Tx fail rate count to equal to 0x15 at most.
 	// Reduce the fail count at least to 10 sec if tx rate is tending stable.
 	if(priv->FailTxRateCount >= 0x15 ||
-		(!bTryUp && !bTryDown && priv->TryDownCountLowData == 0 && priv->TryupingCount && priv->FailTxRateCount > 0x6))
-	{
+		(!bTryUp && !bTryDown && priv->TryDownCountLowData == 0 && priv->TryupingCount && priv->FailTxRateCount > 0x6)) {
 		priv->FailTxRateCount --;
 	}
 
@@ -1115,49 +966,39 @@ StaRateAdaptive87SE(
 	CckTxPwrIdx  = priv->chtxpwr[priv->ieee80211->current_network.channel];
 
 	//[TRC Dell Lab] Mac0x9e increase 2 level in 36M~18M situation, Isaiah 2008-02-18 24:00
-	if((priv->CurrentOperaRate < 96) &&(priv->CurrentOperaRate > 22))
-	{
+	if((priv->CurrentOperaRate < 96) &&(priv->CurrentOperaRate > 22)) {
 		u1bCck = read_nic_byte(dev, CCK_TXAGC);
 		u1bOfdm = read_nic_byte(dev, OFDM_TXAGC);
 
 		// case 1: Never enter High power
-		if(u1bCck == CckTxPwrIdx )
-		{
-			if(u1bOfdm != (OfdmTxPwrIdx+2) )
-			{
+		if(u1bCck == CckTxPwrIdx ) {
+			if(u1bOfdm != (OfdmTxPwrIdx+2) ) {
 			priv->bEnhanceTxPwr= true;
 			u1bOfdm = ((u1bOfdm+2) > 35) ? 35: (u1bOfdm+2);
 			write_nic_byte(dev, OFDM_TXAGC, u1bOfdm);
 //			printk("Enhance OFDM_TXAGC : +++++ u1bOfdm= 0x%x\n", u1bOfdm);
 			}
-		}
+		} else if(u1bCck < CckTxPwrIdx) {
 		// case 2: enter high power
-		else if(u1bCck < CckTxPwrIdx)
-		{
-			if(!priv->bEnhanceTxPwr)
-			{
+			if(!priv->bEnhanceTxPwr) {
 				priv->bEnhanceTxPwr= true;
 				u1bOfdm = ((u1bOfdm+2) > 35) ? 35: (u1bOfdm+2);
 				write_nic_byte(dev, OFDM_TXAGC, u1bOfdm);
 				//RT_TRACE(COMP_RATE, DBG_TRACE, ("Enhance OFDM_TXAGC(2) : +++++ u1bOfdm= 0x%x\n", u1bOfdm));
 			}
 		}
-	}
-	else if(priv->bEnhanceTxPwr)  //54/48/11/5.5/2/1
-	{
+	} else if(priv->bEnhanceTxPwr) {  //54/48/11/5.5/2/1
 		u1bCck = read_nic_byte(dev, CCK_TXAGC);
 		u1bOfdm = read_nic_byte(dev, OFDM_TXAGC);
 
 		// case 1: Never enter High power
-		if(u1bCck == CckTxPwrIdx )
-		{
+		if(u1bCck == CckTxPwrIdx ) {
 		priv->bEnhanceTxPwr= false;
 		write_nic_byte(dev, OFDM_TXAGC, OfdmTxPwrIdx);
 		//printk("Recover OFDM_TXAGC : ===== u1bOfdm= 0x%x\n", OfdmTxPwrIdx);
 		}
 		// case 2: enter high power
-		else if(u1bCck < CckTxPwrIdx)
-		{
+		else if(u1bCck < CckTxPwrIdx) {
 			priv->bEnhanceTxPwr= false;
 			u1bOfdm = ((u1bOfdm-2) > 0) ? (u1bOfdm-2): 0;
 			write_nic_byte(dev, OFDM_TXAGC, u1bOfdm);
@@ -1171,35 +1012,26 @@ StaRateAdaptive87SE(
 	// "from CCK to OFDM".
 	//
 SetInitialGain:
-	if(bUpdateInitialGain)
-	{
-		if(MgntIsCckRate(priv->CurrentOperaRate)) // CCK
-		{
-			if(priv->InitialGain > priv->RegBModeGainStage)
-			{
+	if(bUpdateInitialGain) {
+		if(MgntIsCckRate(priv->CurrentOperaRate)) { // CCK
+			if(priv->InitialGain > priv->RegBModeGainStage) {
 				priv->InitialGainBackUp= priv->InitialGain;
 
 				if(CurrSignalStrength < -85) // Low power, OFDM [0x17] = 26.
-				{
 					//SD3 SYs suggest that CurrSignalStrength < -65, ofdm 0x17=26.
 					priv->InitialGain = priv->RegBModeGainStage;
-				}
+
 				else if(priv->InitialGain > priv->RegBModeGainStage + 1)
-				{
 					priv->InitialGain -= 2;
-				}
-				else
-				{
+
+				else 
 					priv->InitialGain --;
-				}
+
 				printk("StaRateAdaptive87SE(): update init_gain to index %d for date rate %d\n",priv->InitialGain, priv->CurrentOperaRate);
 				UpdateInitialGain(dev);
 			}
-		}
-		else // OFDM
-		{
-			if(priv->InitialGain < 4)
-			{
+		} else { // OFDM
+			if(priv->InitialGain < 4) {
 				priv->InitialGainBackUp= priv->InitialGain;
 
 				priv->InitialGain ++;
@@ -1229,15 +1061,13 @@ void timer_rate_adaptive(unsigned long data)
 {
 	struct r8180_priv* priv = ieee80211_priv((struct net_device *)data);
 	//DMESG("---->timer_rate_adaptive()\n");
-	if(!priv->up)
-	{
+	if(!priv->up) {
 //		DMESG("<----timer_rate_adaptive():driver is not up!\n");
 		return;
 	}
 	if((priv->ieee80211->iw_mode != IW_MODE_MASTER)
 			&& (priv->ieee80211->state == IEEE80211_LINKED) &&
-			(priv->ForcedDataRate == 0) )
-	{
+			(priv->ForcedDataRate == 0) ) {
 //	DMESG("timer_rate_adaptive():schedule rate_adapter_wq\n");
 		queue_work(priv->ieee80211->wq, (void *)&priv->ieee80211->rate_adapter_wq);
 //		StaRateAdaptive87SE((struct net_device *)data);
@@ -1259,12 +1089,9 @@ SwAntennaDiversityRxOk8185(
 
 	priv->AdRxOkCnt++;
 
-	if( priv->AdRxSignalStrength != -1)
-	{
+	if( priv->AdRxSignalStrength != -1) {
 		priv->AdRxSignalStrength = ((priv->AdRxSignalStrength*7) + (SignalStrength*3)) / 10;
-	}
-	else
-	{ // Initialization case.
+	} else { // Initialization case.
 		priv->AdRxSignalStrength = SignalStrength;
 	}
 //{+by amy 080312
@@ -1290,8 +1117,7 @@ SetAntenna8185(
 
 //	printk("+SetAntenna8185(): Antenna is switching to: %d \n", u1bAntennaIndex);
 
-	switch(u1bAntennaIndex)
-	{
+	switch(u1bAntennaIndex) {
 	case 0:
 		/* Mac register, main antenna */
 		write_nic_byte(dev, ANTSEL, 0x03);
@@ -1319,9 +1145,7 @@ SetAntenna8185(
 	}
 
 	if(bAntennaSwitched)
-	{
 		priv->CurrAntennaIndex = u1bAntennaIndex;
-	}
 
 //	printk("-SetAntenna8185(): return (%#X)\n", bAntennaSwitched);
 
@@ -1340,15 +1164,12 @@ SwitchAntenna(
 
 	bool		bResult;
 
-	if(priv->CurrAntennaIndex == 0)
-	{
+	if(priv->CurrAntennaIndex == 0) {
 			bResult = SetAntenna8185(dev, 1);
 //by amy 080312
 //		printk("SwitchAntenna(): switching to antenna 1 ......\n");
 //		bResult = SetAntenna8185(dev, 1);//-by amy 080312
-	}
-	else
-	{
+	} else {
 			bResult = SetAntenna8185(dev, 0);
 //by amy 080312
 //		printk("SwitchAntenna(): switching to antenna 0 ......\n");
@@ -1375,8 +1196,7 @@ SwAntennaDiversity(
 //	printk("+SwAntennaDiversity(): CurrAntennaIndex: %d\n", priv->CurrAntennaIndex);
 //	printk("AdTickCount is %d\n",priv->AdTickCount);
 //by amy 080312
-	if(bSwCheckSS)
-	{
+	if(bSwCheckSS) {
 		priv->AdTickCount++;
 
 		printk("(1) AdTickCount: %d, AdCheckPeriod: %d\n",
@@ -1387,25 +1207,22 @@ SwAntennaDiversity(
 //	priv->AdTickCount++;//-by amy 080312
 
 	// Case 1. No Link.
-	if(priv->ieee80211->state != IEEE80211_LINKED)
-	{
+	if(priv->ieee80211->state != IEEE80211_LINKED) {
 	//	printk("SwAntennaDiversity(): Case 1. No Link.\n");
 
 		priv->bAdSwitchedChecking = false;
 		// I switch antenna here to prevent any one of antenna is broken before link established, 2006.04.18, by rcnjko..
 		SwitchAntenna(dev);
-	}
-	// Case 2. Linked but no packet received.
-	else if(priv->AdRxOkCnt == 0)
-	{
+
+	  // Case 2. Linked but no packet receive.d
+	} else if(priv->AdRxOkCnt == 0) {
 	//	printk("SwAntennaDiversity(): Case 2. Linked but no packet received.\n");
 
 		priv->bAdSwitchedChecking = false;
 		SwitchAntenna(dev);
-	}
-	// Case 3. Evaluate last antenna switch action and undo it if necessary.
-	else if(priv->bAdSwitchedChecking == true)
-	{
+
+	  // Case 3. Evaluate last antenna switch action and undo it if necessary.
+	} else if(priv->bAdSwitchedChecking == true) {
 	//	printk("SwAntennaDiversity(): Case 3. Evaluate last antenna switch action.\n");
 
 		priv->bAdSwitchedChecking = false;
@@ -1415,8 +1232,8 @@ SwAntennaDiversity(
 
 		priv->AdRxSsThreshold = (priv->AdRxSsThreshold > priv->AdMaxRxSsThreshold) ?
 					priv->AdMaxRxSsThreshold: priv->AdRxSsThreshold;
-		if(priv->AdRxSignalStrength < priv->AdRxSsBeforeSwitched)
-		{ // Rx signal strength is not improved after we swtiched antenna. => Swich back.
+		if(priv->AdRxSignalStrength < priv->AdRxSsBeforeSwitched) {
+		// Rx signal strength is not improved after we swtiched antenna. => Swich back.
 //			printk("SwAntennaDiversity(): Rx Signal Strength is not improved, CurrRxSs: %d, LastRxSs: %d\n",
 //				priv->AdRxSignalStrength, priv->AdRxSsBeforeSwitched);
 //by amy 080312
@@ -1429,9 +1246,8 @@ SwAntennaDiversity(
 
 			// Wrong deceision => switch back.
 			SwitchAntenna(dev);
-		}
-		else
-		{ // Rx Signal Strength is improved.
+		} else { 
+		// Rx Signal Strength is improved.
 //			printk("SwAntennaDiversity(): Rx Signal Strength is improved, CurrRxSs: %d, LastRxSs: %d\n",
 //				priv->AdRxSignalStrength, priv->AdRxSsBeforeSwitched);
 
@@ -1444,8 +1260,7 @@ SwAntennaDiversity(
 	}
 	// Case 4. Evaluate if we shall switch antenna now.
 	// Cause Table Speed is very fast in TRC Dell Lab, we check it every time.
-	else// if(priv->AdTickCount >= priv->AdCheckPeriod)//-by amy 080312
-	{
+	else { // if(priv->AdTickCount >= priv->AdCheckPeriod)//-by amy 080312
 //		printk("SwAntennaDiversity(): Case 4. Evaluate if we shall switch antenna now.\n");
 
 		priv->AdTickCount = 0;
@@ -1463,8 +1278,8 @@ SwAntennaDiversity(
 		// Added by Roger, 2008.02.21.
 //{by amy 080312
 		if((priv->AdMainAntennaRxOkCnt < priv->AdAuxAntennaRxOkCnt)
-			&& (priv->CurrAntennaIndex == 0))
-		{ // We set Main antenna as default but RxOk count was less than Aux ones.
+			&& (priv->CurrAntennaIndex == 0)) {
+		// We set Main antenna as default but RxOk count was less than Aux ones.
 
 	//		printk("SwAntennaDiversity(): Main antenna RxOK is poor, AdMainAntennaRxOkCnt: %d, AdAuxAntennaRxOkCnt: %d\n",
 	//			priv->AdMainAntennaRxOkCnt, priv->AdAuxAntennaRxOkCnt);
@@ -1472,10 +1287,9 @@ SwAntennaDiversity(
 			// Switch to Aux antenna.
 			SwitchAntenna(dev);
 			priv->bHWAdSwitched = true;
-		}
-		else if((priv->AdAuxAntennaRxOkCnt < priv->AdMainAntennaRxOkCnt)
-			&& (priv->CurrAntennaIndex == 1))
-		{ // We set Aux antenna as default but RxOk count was less than Main ones.
+		} else if((priv->AdAuxAntennaRxOkCnt < priv->AdMainAntennaRxOkCnt)
+			&& (priv->CurrAntennaIndex == 1)) {
+		// We set Aux antenna as default but RxOk count was less than Main ones.
 
 	//		printk("SwAntennaDiversity(): Aux antenna RxOK is poor, AdMainAntennaRxOkCnt: %d, AdAuxAntennaRxOkCnt: %d\n",
 	//			priv->AdMainAntennaRxOkCnt, priv->AdAuxAntennaRxOkCnt);
@@ -1483,9 +1297,8 @@ SwAntennaDiversity(
 			// Switch to Main antenna.
 			SwitchAntenna(dev);
 			priv->bHWAdSwitched = true;
-		}
-		else
-		{// Default antenna is better.
+		} else {
+		// Default antenna is better.
 
 	//		printk("SwAntennaDiversity(): Default antenna is better., AdMainAntennaRxOkCnt: %d, AdAuxAntennaRxOkCnt: %d\n",
 	//			priv->AdMainAntennaRxOkCnt, priv->AdAuxAntennaRxOkCnt);
@@ -1504,12 +1317,11 @@ SwAntennaDiversity(
 		// Our guess is that main antenna have lower throughput and get many change
 		// to receive more CCK packets(ex.Beacon) which have stronger SignalStrength.
 		//
-		if( (!priv->bHWAdSwitched) && (bSwCheckSS))
-		{
+		if( (!priv->bHWAdSwitched) && (bSwCheckSS)) {
 //by amy 080312}
 		// Evaluate Rx signal strength if we shall switch antenna now.
-		if(priv->AdRxSignalStrength < priv->AdRxSsThreshold)
-		{ // Rx signal strength is weak => Switch Antenna.
+		if(priv->AdRxSignalStrength < priv->AdRxSsThreshold) {
+		// Rx signal strength is weak => Switch Antenna.
 //			printk("SwAntennaDiversity(): Rx Signal Strength is weak, CurrRxSs: %d, RxSsThreshold: %d\n",
 //				priv->AdRxSignalStrength, priv->AdRxSsThreshold);
 
@@ -1517,17 +1329,16 @@ SwAntennaDiversity(
 			priv->bAdSwitchedChecking = true;
 
 			SwitchAntenna(dev);
-		}
-		else
-		{ // Rx signal strength is OK.
+		} else {
+		// Rx signal strength is OK.
 //			printk("SwAntennaDiversity(): Rx Signal Strength is OK, CurrRxSs: %d, RxSsThreshold: %d\n",
 //				priv->AdRxSignalStrength, priv->AdRxSsThreshold);
 
 			priv->bAdSwitchedChecking = false;
 			// Increase Rx signal strength threshold if necessary.
 			if(	(priv->AdRxSignalStrength > (priv->AdRxSsThreshold + 10)) && // Signal is much stronger than current threshold
-				priv->AdRxSsThreshold <= priv->AdMaxRxSsThreshold) // Current threhold is not yet reach upper limit.
-			{
+				priv->AdRxSsThreshold <= priv->AdMaxRxSsThreshold) { // Current threhold is not yet reach upper limit.
+
 				priv->AdRxSsThreshold = (priv->AdRxSsThreshold + priv->AdRxSignalStrength) / 2;
 				priv->AdRxSsThreshold = (priv->AdRxSsThreshold > priv->AdMaxRxSsThreshold) ?
 												priv->AdMaxRxSsThreshold: priv->AdRxSsThreshold;//+by amy 080312
@@ -1535,9 +1346,7 @@ SwAntennaDiversity(
 
 			// Reduce Antenna Diversity checking period if possible.
 			if( priv->AdCheckPeriod > priv->AdMinCheckPeriod )
-			{
 				priv->AdCheckPeriod /= 2;
-			}
 		}
 		}
 	}
@@ -1563,9 +1372,7 @@ CheckTxPwrTracking(	struct net_device *dev)
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 
 	if(!priv->bTxPowerTrack)
-	{
 		return false;
-	}
 
 //lzm reserved 080826
 	//if(priv->bScanInProgress)
@@ -1575,9 +1382,7 @@ CheckTxPwrTracking(	struct net_device *dev)
 
 	//if 87SE is in High Power , don't do Tx Power Tracking. asked by SD3 ED. 2008-08-08 Isaiah
 	if(priv->bToUpdateTxPwr)
-	{
 		return false;
-	}
 
 	return true;
 }
@@ -1602,24 +1407,20 @@ SwAntennaDiversityTimerCallback(
 	// 2007.05.09, added by Roger.
 	//
 	rtState = priv->eRFPowerState;
-	do{
-		if (rtState == eRfOff)
-		{
+	do {
+		if (rtState == eRfOff) {
 //			printk("SwAntennaDiversityTimer - RF is OFF.\n");
 			break;
-		}
-		else if (rtState == eRfSleep)
-		{
+		} else if (rtState == eRfSleep) {
 			// Don't access BB/RF under Disable PLL situation.
 			//RT_TRACE((COMP_RF|COMP_ANTENNA), DBG_LOUD, ("SwAntennaDiversityTimerCallback(): RF is Sleep => skip it\n"));
 			break;
 		}
 		SwAntennaDiversity(dev);
 
-	}while(false);
+	} while(false);
 
-	if(priv->up)
-	{
+	if(priv->up) {
 		priv->SwAntennaDiversityTimer.expires = jiffies + MSECS(ANTENNA_DIVERSITY_TIMER_PERIOD);
 		add_timer(&priv->SwAntennaDiversityTimer);
 	}
-- 
1.7.7.6

