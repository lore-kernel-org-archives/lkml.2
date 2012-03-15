Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761595Ab2COWa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 18:30:27 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45729 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208Ab2COWaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 18:30:24 -0400
From: Andrew Miller <amiller@amilx.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        amiller@amilx.com
Subject: [PATCH 6/6] Staging: rtl8187se: r8180_dm.c: Removed old comments
Date: Thu, 15 Mar 2012 18:28:39 -0400
Message-Id: <1331850519-20726-1-git-send-email-amiller@amilx.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed some old comments

Signed-off-by: Andrew Miller <amiller@amilx.com>
---
 drivers/staging/rtl8187se/r8180_dm.c |  307 +++-------------------------------
 1 files changed, 21 insertions(+), 286 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_dm.c b/drivers/staging/rtl8187se/r8180_dm.c
index 54b676f..4d7a595 100644
--- a/drivers/staging/rtl8187se/r8180_dm.c
+++ b/drivers/staging/rtl8187se/r8180_dm.c
@@ -1,15 +1,8 @@
-/*#include "r8180.h" */
 #include "r8180_dm.h"
 #include "r8180_hw.h"
 #include "r8180_93cx6.h"
-/*{by amy 080312 */
 
-/*
- *	Description:
- *		Return TRUE if we shall perform High Power Mecahnism, FALSE otherwise.
- *
- *+by amy 080312
- */
+ /*	Return TRUE if we shall perform High Power Mecahnism, FALSE otherwise. */
 #define RATE_ADAPTIVE_TIMER_PERIOD      300
 
 bool CheckHighPower(struct net_device *dev)
@@ -47,8 +40,6 @@ void DoTxHighPower(struct net_device *dev)
 	u8			u1bTmp;
 	char			OfdmTxPwrIdx, CckTxPwrIdx;
 
-	/* printk("----> DoTxHighPower()\n"); */
-
 	HiPwrUpperTh = priv->RegHiPwrUpperTh;
 	HiPwrLowerTh = priv->RegHiPwrLowerTh;
 
@@ -61,16 +52,10 @@ void DoTxHighPower(struct net_device *dev)
 	OfdmTxPwrIdx  = priv->chtxpwr_ofdm[priv->ieee80211->current_network.channel];
 	CckTxPwrIdx  = priv->chtxpwr[priv->ieee80211->current_network.channel];
 
-		 /* 
-		  * printk("DoTxHighPower() - UndecoratedSmoothedSS:%d, CurCCKRSSI = %d , bCurCCKPkt= %d \n", 
- 		  * priv->UndecoratedSmoothedSS, priv->CurCCKRSSI, priv->bCurCCKPkt ); 
- 		  */
-
 	if ((priv->UndecoratedSmoothedSS > HiPwrUpperTh) ||
 		(priv->bCurCCKPkt && (priv->CurCCKRSSI > RSSIHiPwrUpperTh))) {
 		/* Stevenl suggested that degrade 8dbm in high power sate. 2007-12-04 Isaiah */
 
-	/*	printk("=====>DoTxHighPower() - High Power - UndecoratedSmoothedSS:%d,  HiPwrUpperTh = %d \n", priv->UndecoratedSmoothedSS, HiPwrUpperTh ); */
 		priv->bToUpdateTxPwr = true;
 		u1bTmp= read_nic_byte(dev, CCK_TXAGC);
 
@@ -86,27 +71,20 @@ void DoTxHighPower(struct net_device *dev)
 
 	} else if ((priv->UndecoratedSmoothedSS < HiPwrLowerTh) &&
 		(!priv->bCurCCKPkt || priv->CurCCKRSSI < RSSIHiPwrLowerTh)) {
-	/*	 printk("DoTxHighPower() - lower Power - UndecoratedSmoothedSS:%d,  HiPwrUpperTh = %d \n", priv->UndecoratedSmoothedSS, HiPwrLowerTh ); */
 		if (priv->bToUpdateTxPwr) {
 			priv->bToUpdateTxPwr = false;
 			/* SD3 required. */
 			u1bTmp= read_nic_byte(dev, CCK_TXAGC);
 			if (u1bTmp < CckTxPwrIdx) {
-				/* u1bTmp = ((u1bTmp+16) > 35) ? 35: (u1bTmp+16);   8dbm  */
-				/* write_nic_byte(dev, CCK_TXAGC, u1bTmp); */
 				write_nic_byte(dev, CCK_TXAGC, CckTxPwrIdx);
 			}
 
 			u1bTmp= read_nic_byte(dev, OFDM_TXAGC);
 			if (u1bTmp < OfdmTxPwrIdx) {
-				/* u1bTmp = ((u1bTmp+16) > 35) ? 35: (u1bTmp+16);   8dbm  */
-				/* write_nic_byte(dev, OFDM_TXAGC, u1bTmp); */
 				write_nic_byte(dev, OFDM_TXAGC, OfdmTxPwrIdx);
 			}
 		}
 	}
-
-	/* printk("<---- DoTxHighPower()\n"); */
 }
 
 
@@ -118,25 +96,16 @@ void DoTxHighPower(struct net_device *dev)
  */
 void rtl8180_tx_pw_wq(struct work_struct *work)
 {
-/*      struct r8180_priv *priv = container_of(work, struct r8180_priv, watch_dog_wq);
- *      struct ieee80211_device * ieee = (struct ieee80211_device*)
- *      container_of(work, struct ieee80211_device, watch_dog_wq);
- */
 	struct delayed_work *dwork = to_delayed_work(work);
 	struct ieee80211_device *ieee = container_of(dwork,struct ieee80211_device,tx_pw_wq);
 	struct net_device *dev = ieee->dev;
 
-/*	printk("----> UpdateTxPowerWorkItemCallback()\n"); */
-
 	DoTxHighPower(dev);
-
-/*	printk("<---- UpdateTxPowerWorkItemCallback()\n"); */
 }
 
 
 /*
- *	Description:
- *		Return TRUE if we shall perform DIG Mecahnism, FALSE otherwise.
+ *	Return TRUE if we shall perform DIG Mecahnism, FALSE otherwise.
  */
 bool CheckDig(struct net_device *dev)
 {
@@ -149,14 +118,12 @@ bool CheckDig(struct net_device *dev)
 	if (ieee->state != IEEE80211_LINKED)
 		return false;
 
-	/* if(priv->CurrentOperaRate < 36) // Schedule Dig under all OFDM rates. By Bruce, 2007-06-01. */
 	if ((priv->ieee80211->rate / 5) < 36) /* Schedule Dig under all OFDM rates. By Bruce, 2007-06-01. */
 		return false;
 	return true;
 }
 /*
- *	Description:
- *		Implementation of DIG for Zebra and Zebra2.
+ *	Implementation of DIG for Zebra and Zebra2.
  */
 void DIG_Zebra(struct net_device *dev)
 {
@@ -167,16 +134,11 @@ void DIG_Zebra(struct net_device *dev)
 	int			LowestGainStage = 4; /* The capable lowest stage of performing dig workitem. */
 	u32			AwakePeriodIn2Sec = 0;
 
-	/* printk("---------> DIG_Zebra()\n"); */
-
 	CCKFalseAlarm = (u16)(priv->FalseAlarmRegValue & 0x0000ffff);
 	OFDMFalseAlarm = (u16)((priv->FalseAlarmRegValue >> 16) & 0x0000ffff);
 	OfdmFA1 =  0x15;
 	OfdmFA2 = ((u16)(priv->RegDigOfdmFaUpTh)) << 8;
 
-/*	printk("DIG**********CCK False Alarm: %#X \n",CCKFalseAlarm); */
-/*	printk("DIG**********OFDM False Alarm: %#X \n",OFDMFalseAlarm); */
-
 	/* The number of initial gain steps is different, by Bruce, 2007-04-13. */
 	if (priv->InitialGain == 0) { /* autoDIG */
 		/* Advised from SD3 DZ */
@@ -187,17 +149,13 @@ void DIG_Zebra(struct net_device *dev)
 
 #if 1 /* lzm reserved 080826 */
 	AwakePeriodIn2Sec = (2000 - priv->DozePeriodInPast2Sec);
-	/* printk("&&& DozePeriod=%d AwakePeriod=%d\n", priv->DozePeriodInPast2Sec, AwakePeriodIn2Sec); */
 	priv ->DozePeriodInPast2Sec = 0;
 
 	if (AwakePeriodIn2Sec) {
-		/* RT_TRACE(COMP_DIG, DBG_TRACE, ("DIG: AwakePeriodIn2Sec(%d) - FATh(0x%X , 0x%X) ->",AwakePeriodIn2Sec, OfdmFA1, OfdmFA2)); */
-		/* adjuest DIG threshold. */
 		OfdmFA1 = (u16)((OfdmFA1 * AwakePeriodIn2Sec) / 2000) ;
 		OfdmFA2 = (u16)((OfdmFA2 * AwakePeriodIn2Sec) / 2000) ;
-		/* RT_TRACE(COMP_DIG, DBG_TRACE, ("( 0x%X , 0x%X)\n", OfdmFA1, OfdmFA2)); */
 	} else {
-		;/* RT_TRACE(COMP_DIG, DBG_WARNING, ("ERROR!!  AwakePeriodIn2Sec should not be ZERO!!\n")); */
+		;
 	}
 #endif
 
@@ -213,8 +171,6 @@ void DIG_Zebra(struct net_device *dev)
 					priv->InitialGainBackUp = priv->InitialGain;
 
 					priv->InitialGain = (priv->InitialGain + 1);
-/*					printk("DIG**********OFDM False Alarm: %#X,  OfdmFA1: %#X, OfdmFA2: %#X\n", OFDMFalseAlarm, OfdmFA1, OfdmFA2); */
-/*					printk("DIG+++++++ fallback OFDM:%d \n", priv->InitialGain); */
 					UpdateInitialGain(dev);
 				}
 				priv->DIG_NumberFallbackVote = 0;
@@ -235,22 +191,16 @@ void DIG_Zebra(struct net_device *dev)
 				priv->InitialGainBackUp = priv->InitialGain;
 
 				priv->InitialGain = (priv->InitialGain - 1);
-/*				printk("DIG**********OFDM False Alarm: %#X,  OfdmFA1: %#X, OfdmFA2: %#X\n", OFDMFalseAlarm, OfdmFA1, OfdmFA2); */
-/*				printk("DIG--------- Upgrade OFDM:%d \n", priv->InitialGain); */
 				UpdateInitialGain(dev);
 			}
 			priv->DIG_NumberFallbackVote = 0;
 			priv->DIG_NumberUpgradeVote = 0;
 		}
 	}
-
-/*	printk("DIG+++++++ OFDM:%d\n", priv->InitialGain); */
-/* 	printk("<--------- DIG_Zebra()\n"); */
 }
 
 /*
- *	Description:
- *		Dispatch DIG implementation according to RF.
+ *	Dispatch DIG implementation according to RF.
  */
 void DynamicInitGain(struct net_device *dev)
 {
@@ -302,10 +252,8 @@ int IncludedInSupportedRates(struct r8180_priv *priv, u8 TxRate)
 }
 
 /*
- *      Description:
- *              Get the Tx rate one degree up form the input rate in the supported rates.
- *              Return the upgrade rate if it is successed, otherwise return the input rate.
- *      By Bruce, 2007-06-05.
+ *	Get the Tx rate one degree up form the input rate in the supported rates.
+ *	Return the upgrade rate if it is successed, otherwise return the input rate.
  */
 u8 GetUpgradeTxRate(struct net_device *dev, u8 rate)
 {
@@ -356,19 +304,15 @@ u8 GetUpgradeTxRate(struct net_device *dev, u8 rate)
 	}
 	/* Check if the rate is valid. */
 	if (IncludedInSupportedRates(priv, UpRate)) {
-/*              printk("GetUpgradeTxRate(): GetUpgrade Tx rate(%d) from %d !\n", UpRate, priv->CurrentOperaRate); */
 		return UpRate;
 	} else {
-		/* printk("GetUpgradeTxRate(): Tx rate (%d) is not in supported rates\n", UpRate); */
 		return rate;
 	}
 	return rate;
 }
 /*
- *      Description:
- *              Get the Tx rate one degree down form the input rate in the supported rates.
- *              Return the degrade rate if it is successed, otherwise return the input rate.
- *      By Bruce, 2007-06-05.
+ *	Get the Tx rate one degree down form the input rate in the supported rates.
+ *	Return the degrade rate if it is successed, otherwise return the input rate.
  */
 
 u8 GetDegradeTxRate(struct net_device *dev, u8 rate)
@@ -420,10 +364,8 @@ u8 GetDegradeTxRate(struct net_device *dev, u8 rate)
 	}
 	/* Check if the rate is valid. */
 	if (IncludedInSupportedRates(priv, DownRate)) {
-/*              printk("GetDegradeTxRate(): GetDegrade Tx rate(%d) from %d!\n", DownRate, priv->CurrentOperaRate); */
 		return DownRate;
 	} else {
-		/* printk("GetDegradeTxRate(): Tx rate (%d) is not in supported rates\n", DownRate); */
 		return rate;
 	}
 	return rate;
@@ -431,7 +373,6 @@ u8 GetDegradeTxRate(struct net_device *dev, u8 rate)
 /*
  *      Helper function to determine if specified data rate is
  *      CCK rate.
- *      2005.01.25, by rcnjko.
  */
 
 bool MgntIsCckRate(u16 rate)
@@ -447,24 +388,18 @@ bool MgntIsCckRate(u16 rate)
 /*
  *	Description:
  *		Tx Power tracking mechanism routine on 87SE.
- *	Created by Roger, 2007.12.11.
  */
 void TxPwrTracking87SE(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	u8	tmpu1Byte, CurrentThermal, Idx;
 	char	CckTxPwrIdx, OfdmTxPwrIdx;
-	/* u32 u4bRfReg; */
 
 	tmpu1Byte = read_nic_byte(dev, EN_LPF_CAL);
 	CurrentThermal = (tmpu1Byte & 0xf0) >> 4; /*[ 7:4]: thermal meter indication. */
 	CurrentThermal = (CurrentThermal > 0x0c) ? 0x0c:CurrentThermal;/* lzm add 080826 */
 
-	/* printk("TxPwrTracking87SE(): CurrentThermal(%d)\n", CurrentThermal); */
-
 	if (CurrentThermal != priv->ThermalMeter) {
-/*		printk("TxPwrTracking87SE(): Thermal meter changed!!!\n"); */
-
 		/* Update Tx Power level on each channel. */
 		for (Idx = 1; Idx < 15; Idx++) {
 			CckTxPwrIdx = priv->chtxpwr[Idx];
@@ -506,7 +441,6 @@ void StaRateAdaptive87SE(struct net_device *dev)
 	unsigned long	CurrTxokCnt;
 	u16		CurrRetryCnt;
 	u16		CurrRetryRate;
-	/*u16		i,idx; */
 	unsigned long	CurrRxokCnt;
 	bool		bTryUp = false;
 	bool		bTryDown = false;
@@ -528,7 +462,6 @@ void StaRateAdaptive87SE(struct net_device *dev)
 	TxThroughput = (u32)(priv->NumTxOkBytesTotal - priv->LastTxOKBytes);
 	priv->LastTxOKBytes = priv->NumTxOkBytesTotal;
 	priv->CurrentOperaRate = priv->ieee80211->rate / 5;
-	/* printk("priv->CurrentOperaRate is %d\n",priv->CurrentOperaRate); */
 	/* 2 Compute retry ratio. */
 	if (CurrTxokCnt > 0) {
 		CurrRetryRate = (u16)(CurrRetryCnt * 100 / CurrTxokCnt);
@@ -537,20 +470,6 @@ void StaRateAdaptive87SE(struct net_device *dev)
 		CurrRetryRate = (u16)(CurrRetryCnt * 100 / 1);
 	}
 
-
-	/*
-	 * Added by Roger, 2007.01.02.
-	 * For debug information.
-	 *
-	 * printk("\n(1) pHalData->LastRetryRate: %d \n",priv->LastRetryRate);
-	 * printk("(2) RetryCnt = %d  \n", CurrRetryCnt);
-	 * printk("(3) TxokCnt = %d \n", CurrTxokCnt);
-	 * printk("(4) CurrRetryRate = %d \n", CurrRetryRate);
-	 * printk("(5) CurrSignalStrength = %d \n",CurrSignalStrength);
-	 * printk("(6) TxThroughput is %d\n",TxThroughput);
-	 * printk("priv->NumTxOkBytesTotal is %d\n",priv->NumTxOkBytesTotal);
-	 */
-
 	priv->LastRetryCnt = priv->CurrRetryCnt;
 	priv->LastTxokCnt = priv->NumTxOkTotal;
 	priv->LastRxokCnt = priv->ieee80211->NumRxOkTotal;
@@ -563,7 +482,6 @@ void StaRateAdaptive87SE(struct net_device *dev)
 		 */
 		priv->TryupingCountNoData++;
 
-/*		printk("No Tx packets, TryupingCountNoData(%d)\n", priv->TryupingCountNoData); */
 		/* [TRC Dell Lab] Extend raised period from 4.5sec to 9sec, Isaiah 2008-02-15 18:00 */
 		if (priv->TryupingCountNoData > 30) {
 			priv->TryupingCountNoData = 0;
@@ -582,9 +500,6 @@ void StaRateAdaptive87SE(struct net_device *dev)
 	/*
 	 * For Netgear case, I comment out the following signal strength estimation,
 	 * which can results in lower rate to transmit when sample is NOT enough (e.g. PING request).
-	 * 2007.04.09, by Roger.
-	 *
-	 *
 	 *
 	 * Restructure rate adaptive as the following main stages:
 	 * (1) Add retry threshold in 54M upgrading condition with signal strength.
@@ -594,7 +509,6 @@ void StaRateAdaptive87SE(struct net_device *dev)
 	 *		situation, Initial Gain Update is upon on DIG mechanism except CCK rate.
 	 * (4) Add the mehanism of trying to upgrade tx rate.
 	 * (5) Record the information of upping tx rate to avoid trying upping tx rate constantly.
-	 * By Bruce, 2007-06-05.
 	 *
 	 */
 
@@ -623,9 +537,6 @@ void StaRateAdaptive87SE(struct net_device *dev)
 		if ((CurrRetryRate > 25) && TxThroughput < priv->LastTxThroughput) {
 			/*Not necessary raising rate, fall back rate. */
 			bTryDown = true;
-			/* printk("case1-1: Not necessary raising rate, fall back rate....\n"); */
-			/* printk("case1-1: pMgntInfo->CurrentOperaRate =%d, TxThroughput = %d, LastThroughput = %d\n", */
-			/*		priv->CurrentOperaRate, TxThroughput, priv->LastTxThroughput); */
 		} else {
 			priv->bTryuping = false;
 		}
@@ -633,7 +544,6 @@ void StaRateAdaptive87SE(struct net_device *dev)
 		/*
  		 * 2For High Power
 		 *
-		 * Added by Roger, 2007.04.09.
 		 * Return to highest data rate, if signal strength is good enough.
 		 * SignalStrength threshold(-50dbm) is for RTL8186.
 		 * Revise SignalStrength threshold to -51dbm.
@@ -644,7 +554,6 @@ void StaRateAdaptive87SE(struct net_device *dev)
 			/* Upgrade Tx Rate directly. */
 			priv->TryupingCount += TryUpTh;
 		}
-/*		printk("case2: StaRateAdaptive87SE: Power(%d) is high enough!!. \n", CurrSignalStrength); */
 
 	} else if (CurrTxokCnt > 9 && CurrTxokCnt < 100 && CurrRetryRate >= 600) {
 		/*
@@ -655,152 +564,106 @@ void StaRateAdaptive87SE(struct net_device *dev)
 		bTryDown = true;
 		/* Let Rate Mechanism to degrade tx rate directly. */
 		priv->TryDownCountLowData += TryDownTh;
-/*		printk("case3: RA: Tx Retry is serious. Degrade Tx Rate to %d directly...\n", priv->CurrentOperaRate); */
 	} else if (priv->CurrentOperaRate == 108) {
 		/* 2For 54Mbps */
 		/* Air Link */
 		if ((CurrRetryRate > 26) && (priv->LastRetryRate > 25)) {
-/*		if ((CurrRetryRate>40)&&(priv->LastRetryRate>39)) */
-			/*Down to rate 48Mbps. */
 			bTryDown = true;
 		}
 		/* Cable Link */
 		else if ((CurrRetryRate > 17) && (priv->LastRetryRate > 16) && (CurrSignalStrength > -72)) {
-/*		else if ((CurrRetryRate>17)&&(priv->LastRetryRate>16) && (CurrSignalStrength > -72)) */
-			/*Down to rate 48Mbps. */
 			bTryDown = true;
 		}
 
 		if (bTryDown && (CurrSignalStrength < -75)) /* cable link */
 			priv->TryDownCountLowData += TryDownTh;
-		/*printk("case4---54M \n"); */
-
 	}
 	else if (priv->CurrentOperaRate == 96) {
 		/* 2For 48Mbps */
 		/* Air Link */
 		if (((CurrRetryRate > 48) && (priv->LastRetryRate > 47))) {
-/*		if ( ((CurrRetryRate>65) && (priv->LastRetryRate>64))) */
-			/* Down to rate 36Mbps. */
 			bTryDown = true;
 		} else if (((CurrRetryRate > 21) && (priv->LastRetryRate > 20)) && (CurrSignalStrength > -74)) { /* Cable Link */
 			/* Down to rate 36Mbps. */
 			bTryDown = true;
 		} else if ((CurrRetryRate > (priv->LastRetryRate + 50)) && (priv->FailTxRateCount > 2)) {
-/*		else if((CurrRetryRate>  (priv->LastRetryRate + 70 )) && (priv->FailTxRateCount >2 )) */
 			bTryDown = true;
 			priv->TryDownCountLowData += TryDownTh;
 		} else if ((CurrRetryRate < 8) && (priv->LastRetryRate < 8)) { /* TO DO: need to consider (RSSI) */
-/*		else if ( (CurrRetryRate<28) && (priv->LastRetryRate<8) ) */
 			bTryUp = true;
 		}
 
 		if (bTryDown && (CurrSignalStrength < -75)){
 			priv->TryDownCountLowData += TryDownTh;
 		}
-		/* printk("case5---48M \n"); */
 	} else if (priv->CurrentOperaRate == 72) {
 		/* 2For 36Mbps */
 		if ((CurrRetryRate > 43) && (priv->LastRetryRate > 41)) {
-/*		if ( (CurrRetryRate>60) && (priv->LastRetryRate>59)) */
 			/* Down to rate 24Mbps. */
 			bTryDown = true;
 		} else if ((CurrRetryRate > (priv->LastRetryRate + 50)) && (priv->FailTxRateCount > 2)) {
-/*		else if((CurrRetryRate>  (priv->LastRetryRate + 70 )) && (priv->FailTxRateCount >2 )) */
 			bTryDown = true;
 			priv->TryDownCountLowData += TryDownTh;
 		} else if ((CurrRetryRate < 15) &&  (priv->LastRetryRate < 16)) { /* TO DO: need to consider (RSSI) */
-/*		else if ( (CurrRetryRate<35) &&  (priv->LastRetryRate<36)) */
 			bTryUp = true;
 		}
 
 		if (bTryDown && (CurrSignalStrength < -80))
 			priv->TryDownCountLowData += TryDownTh;
 
-		/* printk("case6---36M \n"); */
 	} else if (priv->CurrentOperaRate == 48) {
 		/* 2For 24Mbps */
 		/* Air Link */
 		if (((CurrRetryRate > 63) && (priv->LastRetryRate > 62))) {
-/*		if ( ((CurrRetryRate>83) && (priv->LastRetryRate>82))) */
-			/* Down to rate 18Mbps. */
 			bTryDown = true;
 		} else if (((CurrRetryRate > 33) && (priv->LastRetryRate > 32)) && (CurrSignalStrength > -82)) { /* Cable Link */
-/*		 else if ( ((CurrRetryRate>50) && (priv->LastRetryRate>49)) && (CurrSignalStrength > -82) ) */
-			/* Down to rate 18Mbps. */
 			bTryDown = true;
 		} else if ((CurrRetryRate > (priv->LastRetryRate + 50)) && (priv->FailTxRateCount > 2 )) {
-/*		else if((CurrRetryRate>  (priv->LastRetryRate + 70 )) && (priv->FailTxRateCount >2 )) */
 			bTryDown = true;
 			priv->TryDownCountLowData += TryDownTh;
 		} else if ((CurrRetryRate < 20) && (priv->LastRetryRate < 21)) { /* TO DO: need to consider (RSSI) */
-/*		else if ( (CurrRetryRate<40) && (priv->LastRetryRate<41)) */
 			bTryUp = true;
 		}
 
 		if (bTryDown && (CurrSignalStrength < -82))
 			priv->TryDownCountLowData += TryDownTh;
 
-		/* printk("case7---24M \n"); */
 	} else if (priv->CurrentOperaRate == 36) {
-		/* 2For 18Mbps
-		 * original (109, 109)
-		 * [TRC Dell Lab] (90, 91), Isaiah 2008-02-18 23:24
-		 *			     (85, 86), Isaiah 2008-02-18 24:00
-		 */
 		if (((CurrRetryRate > 85) && (priv->LastRetryRate > 86))) {
-/*		if ( ((CurrRetryRate>115) && (priv->LastRetryRate>116))) */
-			/* Down to rate 11Mbps. */
 			bTryDown = true;
-
-		  /* [TRC Dell Lab]  Isaiah 2008-02-18 23:24 */
 		} else if ((CurrRetryRate > (priv->LastRetryRate + 50)) && (priv->FailTxRateCount > 2)) {
-/*		else if((CurrRetryRate>  (priv->LastRetryRate + 70 )) && (priv->FailTxRateCount >2 )) */
 			bTryDown = true;
 			priv->TryDownCountLowData += TryDownTh;
 		} else if ((CurrRetryRate < 22) && (priv->LastRetryRate < 23)) { /* TO DO: need to consider (RSSI) */
-/*		else if ( (CurrRetryRate<42) && (priv->LastRetryRate<43)) */
 			bTryUp = true;
 		}
-		/* printk("case8---18M \n"); */
 	} else if (priv->CurrentOperaRate == 22) {
 		/* 2For 11Mbps */
 		if (CurrRetryRate > 95) {
-/*		if (CurrRetryRate>155) */
 			bTryDown = true;
 		}
 		else if ((CurrRetryRate < 29) && (priv->LastRetryRate < 30)) { /*TO DO: need to consider (RSSI) */
-/*		else if ( (CurrRetryRate<49) && (priv->LastRetryRate <50) ) */
 			bTryUp = true;
 		}
-		/* printk("case9---11M \n"); */
 	} else if (priv->CurrentOperaRate == 11) {
 		/* 2For 5.5Mbps */
 		if (CurrRetryRate > 149) {
-/*		if (CurrRetryRate>189) */
 			bTryDown = true;
 		} else if ((CurrRetryRate < 60) && (priv->LastRetryRate < 65)) {
-/*		else if ( (CurrRetryRate<80) && (priv->LastRetryRate < 85)) */
 			bTryUp = true;
 		}
-		/* printk("case10---5.5M \n"); */
 	} else if (priv->CurrentOperaRate == 4) {
 		/* 2For 2 Mbps */
 		if ((CurrRetryRate > 99) && (priv->LastRetryRate > 99)) {
-/*		if((CurrRetryRate>199) && (priv->LastRetryRate>199)) */
 			bTryDown = true;
 		} else if ((CurrRetryRate < 65) && (priv->LastRetryRate < 70)) {
-/*		else if ( (CurrRetryRate < 85) && (priv->LastRetryRate < 90)) */
 			bTryUp = true;
 		}
-		/* printk("case11---2M \n"); */
 	} else if (priv->CurrentOperaRate == 2) {
 		/* 2For 1 Mbps */
 		if ((CurrRetryRate < 70) && (priv->LastRetryRate < 75)) {
-/*		if( (CurrRetryRate<90) && (priv->LastRetryRate<95)) */
 			bTryUp = true;
 		}
-		/* printk("case12---1M \n"); */
 	}
 
 	if (bTryUp && bTryDown)
@@ -815,7 +678,6 @@ void StaRateAdaptive87SE(struct net_device *dev)
 		if (jiffies % (CurrRetryRate + 101) == 0) {
 			bTryUp = true;
 			priv->bTryuping = true;
-			/* printk("StaRateAdaptive87SE(): Randomly try upgrading...\n"); */
 		}
 	}
 
@@ -824,11 +686,6 @@ void StaRateAdaptive87SE(struct net_device *dev)
 		priv->TryupingCount++;
 		priv->TryDownCountLowData = 0;
 
-/*			printk("UP: pHalData->TryupingCount = %d\n", priv->TryupingCount); */
-/*			printk("UP: TryUpTh(%d)+ (FailTxRateCount(%d))^2 =%d\n", */
-/*				TryUpTh, priv->FailTxRateCount, (TryUpTh + priv->FailTxRateCount * priv->FailTxRateCount) ); */
-/*			printk("UP: pHalData->bTryuping=%d\n",  priv->bTryuping);} */
-
 		/*
 		 * Check more times if we need to upgrade indeed.
 		 * Because the largest value of pHalData->TryupingCount is 0xFFFF and
@@ -857,17 +714,13 @@ void StaRateAdaptive87SE(struct net_device *dev)
 			/* (2)If the signal strength is increased, it may be able to upgrade. */
 
 			priv->CurrentOperaRate = GetUpgradeTxRate(dev, priv->CurrentOperaRate);
-/*			printk("StaRateAdaptive87SE(): Upgrade Tx Rate to %d\n", priv->CurrentOperaRate); */
 
-			/* [TRC Dell Lab] Bypass 12/9/6, Isaiah 2008-02-18 20:00 */
 			if (priv->CurrentOperaRate == 36) {
 				priv->bUpdateARFR = true;
 				write_nic_word(dev, ARFR, 0x0F8F); /* bypass 12/9/6 */
-/*				printk("UP: ARFR=0xF8F\n"); */
 			} else if(priv->bUpdateARFR) {
 				priv->bUpdateARFR = false;
 				write_nic_word(dev, ARFR, 0x0FFF); /* set 1M ~ 54Mbps. */
-/*				printk("UP: ARFR=0xFFF\n"); */
 			}
 
 			/* Update Fail Tx rate and count. */
@@ -886,11 +739,6 @@ void StaRateAdaptive87SE(struct net_device *dev)
 		priv->TryDownCountLowData++;
 		priv->TryupingCount = 0;
 
-/*			printk("DN: pHalData->TryDownCountLowData = %d\n",priv->TryDownCountLowData); */
-/*			printk("DN: TryDownTh =%d\n", TryDownTh); */
-/*			printk("DN: pHalData->bTryuping=%d\n",  priv->bTryuping); */
-
-
 		/* Check if Tx rate can be degraded or Test trying upgrading should fallback. */
 		if (priv->TryDownCountLowData > TryDownTh || priv->bTryuping) {
 			priv->TryDownCountLowData = 0;
@@ -909,21 +757,16 @@ void StaRateAdaptive87SE(struct net_device *dev)
 			priv->CurrentOperaRate = GetDegradeTxRate(dev, priv->CurrentOperaRate);
 
 			/* Reduce chariot training time at weak signal strength situation. SD3 ED demand. */
-			/* [TRC Dell Lab] Revise Signal Threshold from -75 to -80 , Isaiah 2008-02-18 20:00 */
 			if ((CurrSignalStrength < -80) && (priv->CurrentOperaRate > 72 )) {
 				priv->CurrentOperaRate = 72;
-/*				printk("DN: weak signal strength (%d), degrade to 36Mbps\n", CurrSignalStrength); */
 			}
 
-			/* [TRC Dell Lab] Bypass 12/9/6, Isaiah 2008-02-18 20:00 */
 			if (priv->CurrentOperaRate == 36) {
 				priv->bUpdateARFR = true;
 				write_nic_word(dev, ARFR, 0x0F8F); /* bypass 12/9/6 */
-/*				printk("DN: ARFR=0xF8F\n"); */
 			} else if (priv->bUpdateARFR) {
 				priv->bUpdateARFR = false;
 				write_nic_word(dev, ARFR, 0x0FFF); /* set 1M ~ 54Mbps. */
-/*				printk("DN: ARFR=0xFFF\n"); */
 			}
 
 			/*
@@ -932,7 +775,6 @@ void StaRateAdaptive87SE(struct net_device *dev)
 			if (MgntIsCckRate(priv->CurrentOperaRate)) {
 				bUpdateInitialGain = true;
 			}
-/*			printk("StaRateAdaptive87SE(): Degrade Tx Rate to %d\n", priv->CurrentOperaRate); */
 		}
 	} else {
 		if (priv->TryDownCountLowData > 0)
@@ -952,7 +794,7 @@ void StaRateAdaptive87SE(struct net_device *dev)
 	OfdmTxPwrIdx  = priv->chtxpwr_ofdm[priv->ieee80211->current_network.channel];
 	CckTxPwrIdx  = priv->chtxpwr[priv->ieee80211->current_network.channel];
 
-	/* [TRC Dell Lab] Mac0x9e increase 2 level in 36M~18M situation, Isaiah 2008-02-18 24:00 */
+	/* Mac0x9e increase 2 level in 36M~18M situation */
 	if ((priv->CurrentOperaRate < 96) && (priv->CurrentOperaRate > 22)) {
 		u1bCck = read_nic_byte(dev, CCK_TXAGC);
 		u1bOfdm = read_nic_byte(dev, OFDM_TXAGC);
@@ -963,7 +805,6 @@ void StaRateAdaptive87SE(struct net_device *dev)
 			priv->bEnhanceTxPwr = true;
 			u1bOfdm = ((u1bOfdm + 2) > 35) ? 35: (u1bOfdm + 2);
 			write_nic_byte(dev, OFDM_TXAGC, u1bOfdm);
-/*			printk("Enhance OFDM_TXAGC : +++++ u1bOfdm= 0x%x\n", u1bOfdm); */
 			}
 		} else if (u1bCck < CckTxPwrIdx) {
 		/* case 2: enter high power */
@@ -971,7 +812,6 @@ void StaRateAdaptive87SE(struct net_device *dev)
 				priv->bEnhanceTxPwr = true;
 				u1bOfdm = ((u1bOfdm + 2) > 35) ? 35: (u1bOfdm + 2);
 				write_nic_byte(dev, OFDM_TXAGC, u1bOfdm);
-				/* RT_TRACE(COMP_RATE, DBG_TRACE, ("Enhance OFDM_TXAGC(2) : +++++ u1bOfdm= 0x%x\n", u1bOfdm)); */
 			}
 		}
 	} else if (priv->bEnhanceTxPwr) {  /* 54/48/11/5.5/2/1 */
@@ -982,15 +822,12 @@ void StaRateAdaptive87SE(struct net_device *dev)
 		if (u1bCck == CckTxPwrIdx) {
 			priv->bEnhanceTxPwr = false;
 			write_nic_byte(dev, OFDM_TXAGC, OfdmTxPwrIdx);
-			/*printk("Recover OFDM_TXAGC : ===== u1bOfdm= 0x%x\n", OfdmTxPwrIdx); */
 		}
 		/* case 2: enter high power */
 		else if (u1bCck < CckTxPwrIdx) {
 			priv->bEnhanceTxPwr = false;
 			u1bOfdm = ((u1bOfdm - 2) > 0) ? (u1bOfdm - 2): 0;
 			write_nic_byte(dev, OFDM_TXAGC, u1bOfdm);
-			/* RT_TRACE(COMP_RATE, DBG_TRACE, ("Recover OFDM_TXAGC(2): ===== u1bOfdm= 0x%x\n", u1bOfdm)); */
-
 		}
 	}
 
@@ -1039,37 +876,27 @@ void rtl8180_rate_adapter(struct work_struct *work)
 	struct delayed_work *dwork = to_delayed_work(work);
 	struct ieee80211_device *ieee = container_of(dwork, struct ieee80211_device, rate_adapter_wq);
 	struct net_device *dev = ieee->dev;
-	/* struct r8180_priv *priv = ieee80211_priv(dev); */
-/*    DMESG("---->rtl8180_rate_adapter"); */
 	StaRateAdaptive87SE(dev);
-/*   DMESG("<----rtl8180_rate_adapter"); */
 }
 void timer_rate_adaptive(unsigned long data)
 {
 	struct r8180_priv *priv = ieee80211_priv((struct net_device *)data);
-	/* DMESG("---->timer_rate_adaptive()\n"); */
 	if (!priv->up) {
-/*		DMESG("<----timer_rate_adaptive():driver is not up!\n"); */
 		return;
 	}
 	if ((priv->ieee80211->iw_mode != IW_MODE_MASTER)
 			&& (priv->ieee80211->state == IEEE80211_LINKED) &&
 			(priv->ForcedDataRate == 0)) {
-/*	DMESG("timer_rate_adaptive():schedule rate_adapter_wq\n"); */
 		queue_work(priv->ieee80211->wq, (void *)&priv->ieee80211->rate_adapter_wq);
-/*		StaRateAdaptive87SE((struct net_device *)data); */
 	}
 	priv->rateadapter_timer.expires = jiffies + MSECS(priv->RateAdaptivePeriod);
 	add_timer(&priv->rateadapter_timer);
-	/* DMESG("<----timer_rate_adaptive()\n"); */
 }
-/* by amy 080312} */
+
 void SwAntennaDiversityRxOk8185(struct net_device *dev, u8 SignalStrength)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 
-/*	printk("+SwAntennaDiversityRxOk8185: RxSs: %d\n", SignalStrength); */
-
 	priv->AdRxOkCnt++;
 
 	if (priv->AdRxSignalStrength != -1) {
@@ -1077,25 +904,18 @@ void SwAntennaDiversityRxOk8185(struct net_device *dev, u8 SignalStrength)
 	} else { /* Initialization case. */
 		priv->AdRxSignalStrength = SignalStrength;
 	}
-/* {+by amy 080312 */
+	
 	if (priv->LastRxPktAntenna) /* Main antenna. */
 		priv->AdMainAntennaRxOkCnt++;
 	else	 /* Aux antenna. */
 		priv->AdAuxAntennaRxOkCnt++;
-/* +by amy 080312 */
-/*	printk("-SwAntennaDiversityRxOk8185: AdRxOkCnt: %d AdRxSignalStrength: %d\n", priv->AdRxOkCnt, priv->AdRxSignalStrength); */
 }
-/*
- *	Description:
- *		Change Antenna Switch.
- */
+ /*	Change Antenna Switch. */
 bool SetAntenna8185(struct net_device *dev, u8 u1bAntennaIndex)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	bool bAntennaSwitched = false;
 
-/*	printk("+SetAntenna8185(): Antenna is switching to: %d \n", u1bAntennaIndex); */
-
 	switch (u1bAntennaIndex) {
 	case 0:
 		/* Mac register, main antenna */
@@ -1126,14 +946,9 @@ bool SetAntenna8185(struct net_device *dev, u8 u1bAntennaIndex)
 	if(bAntennaSwitched)
 		priv->CurrAntennaIndex = u1bAntennaIndex;
 
-/*	printk("-SetAntenna8185(): return (%#X)\n", bAntennaSwitched); */
-
 	return bAntennaSwitched;
 }
-/*
- *	Description:
- *		Toggle Antenna switch.
- */
+ /*	Toggle Antenna switch. */
 bool SwitchAntenna(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
@@ -1142,37 +957,21 @@ bool SwitchAntenna(struct net_device *dev)
 
 	if (priv->CurrAntennaIndex == 0) {
 		bResult = SetAntenna8185(dev, 1);
-/* 
- * by amy 080312
- *		printk("SwitchAntenna(): switching to antenna 1 ......\n");
- *		bResult = SetAntenna8185(dev, 1);//-by amy 080312
- */
 	} else {
 		bResult = SetAntenna8185(dev, 0);
-/*
- * by amy 080312
- *		printk("SwitchAntenna(): switching to antenna 0 ......\n");
- *		bResult = SetAntenna8185(dev, 0);//-by amy 080312
- */
 	}
 
 	return bResult;
 }
 /*
- *	Description:
- *		Engine of SW Antenna Diversity mechanism.
- *		Since 8187 has no Tx part information,
- *		this implementation is only dependend on Rx part information.
- *
- *	2006.04.17, by rcnjko.
+ * Engine of SW Antenna Diversity mechanism.
+ * Since 8187 has no Tx part information,
+ * this implementation is only dependend on Rx part information.
  */
 void SwAntennaDiversity(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	bool   bSwCheckSS = false;
-/*	printk("+SwAntennaDiversity(): CurrAntennaIndex: %d\n", priv->CurrAntennaIndex); */
-/*	printk("AdTickCount is %d\n",priv->AdTickCount); */
-/* by amy 080312 */
 	if (bSwCheckSS) {
 		priv->AdTickCount++;
 
@@ -1181,27 +980,20 @@ void SwAntennaDiversity(struct net_device *dev)
 		printk("(2) AdRxSignalStrength: %ld, AdRxSsThreshold: %ld\n",
 			priv->AdRxSignalStrength, priv->AdRxSsThreshold);
 	}
-/*	priv->AdTickCount++;//-by amy 080312 */
 
 	/* Case 1. No Link. */
 	if (priv->ieee80211->state != IEEE80211_LINKED) {
-	/*	printk("SwAntennaDiversity(): Case 1. No Link.\n"); */
-
 		priv->bAdSwitchedChecking = false;
 		/* I switch antenna here to prevent any one of antenna is broken before link established, 2006.04.18, by rcnjko.. */
 		SwitchAntenna(dev);
 
 	  /* Case 2. Linked but no packet receive.d */
 	} else if (priv->AdRxOkCnt == 0) {
-	/*	printk("SwAntennaDiversity(): Case 2. Linked but no packet received.\n"); */
-
 		priv->bAdSwitchedChecking = false;
 		SwitchAntenna(dev);
 
 	  /* Case 3. Evaluate last antenna switch action and undo it if necessary. */
 	} else if (priv->bAdSwitchedChecking == true) {
-	/*	printk("SwAntennaDiversity(): Case 3. Evaluate last antenna switch action.\n"); */
-
 		priv->bAdSwitchedChecking = false;
 
 		/* Adjust Rx signal strength threshold. */
@@ -1211,12 +1003,8 @@ void SwAntennaDiversity(struct net_device *dev)
 					priv->AdMaxRxSsThreshold: priv->AdRxSsThreshold;
 		if(priv->AdRxSignalStrength < priv->AdRxSsBeforeSwitched) {
 		/* Rx signal strength is not improved after we swtiched antenna. => Swich back. */
-/*			printk("SwAntennaDiversity(): Rx Signal Strength is not improved, CurrRxSs: %d, LastRxSs: %d\n", */
-/*				priv->AdRxSignalStrength, priv->AdRxSsBeforeSwitched); */
-/* by amy 080312 */
 			/* Increase Antenna Diversity checking period due to bad decision. */
 			priv->AdCheckPeriod *= 2;
-/* by amy 080312 */
 			/* Increase Antenna Diversity checking period. */
 			if (priv->AdCheckPeriod > priv->AdMaxCheckPeriod)
 				priv->AdCheckPeriod = priv->AdMaxCheckPeriod;
@@ -1225,21 +1013,15 @@ void SwAntennaDiversity(struct net_device *dev)
 			SwitchAntenna(dev);
 		} else {
 		/* Rx Signal Strength is improved. */
-/*			printk("SwAntennaDiversity(): Rx Signal Strength is improved, CurrRxSs: %d, LastRxSs: %d\n", */
-/*				priv->AdRxSignalStrength, priv->AdRxSsBeforeSwitched); */
 
 			/* Reset Antenna Diversity checking period to its min value. */
 			priv->AdCheckPeriod = priv->AdMinCheckPeriod;
 		}
 
-/*		printk("SwAntennaDiversity(): AdRxSsThreshold: %d, AdCheckPeriod: %d\n", */
-/*			priv->AdRxSsThreshold, priv->AdCheckPeriod); */
 	}
 	/* Case 4. Evaluate if we shall switch antenna now. */
 	/* Cause Table Speed is very fast in TRC Dell Lab, we check it every time. */
-	else { /* if(priv->AdTickCount >= priv->AdCheckPeriod)//-by amy 080312 */
-/*		printk("SwAntennaDiversity(): Case 4. Evaluate if we shall switch antenna now.\n"); */
-
+	else {
 		priv->AdTickCount = 0;
 
 		/*
@@ -1252,16 +1034,11 @@ void SwAntennaDiversity(struct net_device *dev)
 
 		/*
 		 * Evaluate RxOk count from each antenna if we shall switch default antenna now.
-		 * Added by Roger, 2008.02.21.
 		 */
-/* {by amy 080312 */
 		if ((priv->AdMainAntennaRxOkCnt < priv->AdAuxAntennaRxOkCnt)
 			&& (priv->CurrAntennaIndex == 0)) {
 		/* We set Main antenna as default but RxOk count was less than Aux ones. */
 
-	/*		printk("SwAntennaDiversity(): Main antenna RxOK is poor, AdMainAntennaRxOkCnt: %d, AdAuxAntennaRxOkCnt: %d\n", */
-	/*			priv->AdMainAntennaRxOkCnt, priv->AdAuxAntennaRxOkCnt); */
-
 			/* Switch to Aux antenna. */
 			SwitchAntenna(dev);
 			priv->bHWAdSwitched = true;
@@ -1269,18 +1046,12 @@ void SwAntennaDiversity(struct net_device *dev)
 			&& (priv->CurrAntennaIndex == 1)) {
 		/* We set Aux antenna as default but RxOk count was less than Main ones. */
 
-	/*		printk("SwAntennaDiversity(): Aux antenna RxOK is poor, AdMainAntennaRxOkCnt: %d, AdAuxAntennaRxOkCnt: %d\n", */
-	/*			priv->AdMainAntennaRxOkCnt, priv->AdAuxAntennaRxOkCnt); */
-
 			/* Switch to Main antenna. */
 			SwitchAntenna(dev);
 			priv->bHWAdSwitched = true;
 		} else {
 		/* Default antenna is better. */
 
-	/*		printk("SwAntennaDiversity(): Default antenna is better., AdMainAntennaRxOkCnt: %d, AdAuxAntennaRxOkCnt: %d\n", */
-	/*			priv->AdMainAntennaRxOkCnt, priv->AdAuxAntennaRxOkCnt); */
-
 			/* Still need to check current signal strength. */
 			priv->bHWAdSwitched = false;
 		}
@@ -1296,22 +1067,15 @@ void SwAntennaDiversity(struct net_device *dev)
 		 * to receive more CCK packets(ex.Beacon) which have stronger SignalStrength.
 		 */
 		if ((!priv->bHWAdSwitched) && (bSwCheckSS)) {
-/* by amy 080312} */
 			/* Evaluate Rx signal strength if we shall switch antenna now. */
 			if (priv->AdRxSignalStrength < priv->AdRxSsThreshold) {
 			/* Rx signal strength is weak => Switch Antenna. */
-/*				printk("SwAntennaDiversity(): Rx Signal Strength is weak, CurrRxSs: %d, RxSsThreshold: %d\n", */
-/*				priv->AdRxSignalStrength, priv->AdRxSsThreshold); */
-
 				priv->AdRxSsBeforeSwitched = priv->AdRxSignalStrength;
 				priv->bAdSwitchedChecking = true;
 
 				SwitchAntenna(dev);
 			} else {
 			/* Rx signal strength is OK. */
-/*				printk("SwAntennaDiversity(): Rx Signal Strength is OK, CurrRxSs: %d, RxSsThreshold: %d\n", */
-/*				priv->AdRxSignalStrength, priv->AdRxSsThreshold); */
-
 				priv->bAdSwitchedChecking = false;
 				/* Increase Rx signal strength threshold if necessary. */
 				if ((priv->AdRxSignalStrength > (priv->AdRxSsThreshold + 10)) && /* Signal is much stronger than current threshold */
@@ -1328,22 +1092,13 @@ void SwAntennaDiversity(struct net_device *dev)
 			}
 		}
 	}
-/* by amy 080312 */
 	/* Reset antenna diversity Rx related statistics. */
 	priv->AdRxOkCnt = 0;
 	priv->AdMainAntennaRxOkCnt = 0;
 	priv->AdAuxAntennaRxOkCnt = 0;
-/* by amy 080312 */
-
-/*	priv->AdRxOkCnt = 0;//-by amy 080312 */
-
-/*	printk("-SwAntennaDiversity()\n"); */
 }
 
-/*
- *	Description:
- *		Return TRUE if we shall perform Tx Power Tracking Mecahnism, FALSE otherwise.
- */
+ /*	Return TRUE if we shall perform Tx Power Tracking Mecahnism, FALSE otherwise. */
 bool CheckTxPwrTracking(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
@@ -1351,14 +1106,6 @@ bool CheckTxPwrTracking(struct net_device *dev)
 	if (!priv->bTxPowerTrack)
 		return false;
 
-/* lzm reserved 080826 */
-	/* 
-	 * if(priv->bScanInProgress)
-	 * {
-	 * 	return false;
-	 * }
-	 */
-
 	/* if 87SE is in High Power , don't do Tx Power Tracking. asked by SD3 ED. 2008-08-08 Isaiah */
 	if (priv->bToUpdateTxPwr)
 		return false;
@@ -1367,29 +1114,19 @@ bool CheckTxPwrTracking(struct net_device *dev)
 }
 
 
-/*
- *	Description:
- *		Timer callback function of SW Antenna Diversity.
- */
+ /*	Timer callback function of SW Antenna Diversity. */
 void SwAntennaDiversityTimerCallback(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	RT_RF_POWER_STATE rtState;
 
-	/* printk("+SwAntennaDiversityTimerCallback()\n"); */
-
-	/*
-	 * We do NOT need to switch antenna while RF is off.
-	 * 2007.05.09, added by Roger.
-	 */
+	 /* We do NOT need to switch antenna while RF is off. */
 	rtState = priv->eRFPowerState;
 	do {
 		if (rtState == eRfOff) {
-/*			printk("SwAntennaDiversityTimer - RF is OFF.\n"); */
 			break;
 		} else if (rtState == eRfSleep) {
 			/* Don't access BB/RF under Disable PLL situation. */
-			/* RT_TRACE((COMP_RF|COMP_ANTENNA), DBG_LOUD, ("SwAntennaDiversityTimerCallback(): RF is Sleep => skip it\n")); */
 			break;
 		}
 		SwAntennaDiversity(dev);
@@ -1400,7 +1137,5 @@ void SwAntennaDiversityTimerCallback(struct net_device *dev)
 		priv->SwAntennaDiversityTimer.expires = jiffies + MSECS(ANTENNA_DIVERSITY_TIMER_PERIOD);
 		add_timer(&priv->SwAntennaDiversityTimer);
 	}
-
-	/* printk("-SwAntennaDiversityTimerCallback()\n"); */
 }
 
-- 
1.7.7.6

