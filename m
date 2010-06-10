Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509Ab0FJBR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 21:17:59 -0400
Received: from outbound-mail04.westnet.com.au ([203.10.1.245]:16331 "EHLO
	outbound-mail04.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758405Ab0FJBR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 21:17:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvUxAGjaD0w6B9paPGdsb2JhbACHcJZrDAEBAQE1LbEyjWuFGASDRw
X-IronPort-AV: E=Sophos;i="4.53,395,1272816000"; 
   d="scan'208";a="44446490"
From: Mike Gilks <mike.kernel@gilksonline.com>
To: gregkh@suse.de, mchehab@redhat.com, julia@diku.dk, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Gilks <mike.kernel@gilksonline.com>
Subject: [PATCH 3/4] staging: rtl8192u: fix checkpatch.pl issues to line 3400 Fix most problems pointed out by checkpatch.pl in file r8192U_core.c up to line 3400 Starting at line 3299 there are some long lines I cannot get rid of. An actual developer may be reuired.
Date: Thu, 10 Jun 2010 09:18:04 +0800
Message-Id: <1276132685-26713-4-git-send-email-mike.kernel@gilksonline.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1276132685-26713-3-git-send-email-mike.kernel@gilksonline.com>
References: <1276132685-26713-1-git-send-email-mike.kernel@gilksonline.com>
 <1276132685-26713-2-git-send-email-mike.kernel@gilksonline.com>
 <1276132685-26713-3-git-send-email-mike.kernel@gilksonline.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Gilks <mike.kernel@gilksonline.com>
---
 drivers/staging/rtl8192u/r8192U_core.c |  137 +++++++++++++++++++-------------
 1 files changed, 80 insertions(+), 57 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index f66d66e..14ef649 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -3212,57 +3212,67 @@ static void rtl8192_read_eeprom_info(struct net_device *dev)
 						priv->EEPROMCrystalCap);
 		/* get per-channel Tx power level */
 		if (bLoad_From_EEPOM)
-			priv->EEPROM_Def_Ver = (eprom_read(dev, (EEPROM_TxPwIndex_Ver>>1))&0xff00)>>8;
+			priv->EEPROM_Def_Ver = (eprom_read(dev,
+					(EEPROM_TxPwIndex_Ver>>1))&0xff00)>>8;
 		else
 			priv->EEPROM_Def_Ver = 1;
-		RT_TRACE(COMP_EPROM, "EEPROM_DEF_VER:%d\n", priv->EEPROM_Def_Ver);
-		if (priv->EEPROM_Def_Ver == 0)	/* old eeprom definition */
-		{
+		RT_TRACE(COMP_EPROM, "EEPROM_DEF_VER:%d\n",
+				priv->EEPROM_Def_Ver);
+		if (priv->EEPROM_Def_Ver == 0)	/* old eeprom definition */ {
 			int i;
 			if (bLoad_From_EEPOM)
-				priv->EEPROMTxPowerLevelCCK = (eprom_read(dev, (EEPROM_TxPwIndex_CCK>>1))&0xff) >> 8;
+				priv->EEPROMTxPowerLevelCCK = (eprom_read(dev,
+					(EEPROM_TxPwIndex_CCK>>1))&0xff) >> 8;
 			else
 				priv->EEPROMTxPowerLevelCCK = 0x10;
-			RT_TRACE(COMP_EPROM, "CCK Tx Power Levl: 0x%02x\n", priv->EEPROMTxPowerLevelCCK);
-			for (i=0; i<3; i++)
-			{
-				if (bLoad_From_EEPOM)
-				{
-					tmpValue = eprom_read(dev, (EEPROM_TxPwIndex_OFDM_24G+i)>>1);
-					if (((EEPROM_TxPwIndex_OFDM_24G+i) % 2) == 0)
+			RT_TRACE(COMP_EPROM, "CCK Tx Power Levl: 0x%02x\n",
+						priv->EEPROMTxPowerLevelCCK);
+			for (i = 0; i < 3; i++) {
+				if (bLoad_From_EEPOM) {
+					tmpValue = eprom_read(dev,
+						(EEPROM_TxPwIndex_OFDM_24G+i)
+						>>1);
+					if (((EEPROM_TxPwIndex_OFDM_24G+i) % 2)
+									== 0)
 						tmpValue = tmpValue & 0x00ff;
 					else
-						tmpValue = (tmpValue & 0xff00) >> 8;
-				}
-				else
+						tmpValue = (tmpValue & 0xff00)
+								 >> 8;
+				} else
 					tmpValue = 0x10;
-				priv->EEPROMTxPowerLevelOFDM24G[i] = (u8) tmpValue;
-				RT_TRACE(COMP_EPROM, "OFDM 2.4G Tx Power Level, Index %d = 0x%02x\n", i, priv->EEPROMTxPowerLevelCCK);
+				priv->EEPROMTxPowerLevelOFDM24G[i] =
+								(u8) tmpValue;
+				RT_TRACE(COMP_EPROM, "OFDM 2.4G Tx Power Level"
+					", Index %d = 0x%02x\n", i,
+					priv->EEPROMTxPowerLevelCCK);
 			}
-		}	/* end if EEPROM_DEF_VER == 0 */
-		else if (priv->EEPROM_Def_Ver == 1)
-		{
-			if (bLoad_From_EEPOM)
-			{
-				tmpValue = eprom_read(dev, (EEPROM_TxPwIndex_CCK_V1>>1));
+			/* end if EEPROM_DEF_VER == 0 */
+		} else if (priv->EEPROM_Def_Ver == 1) {
+			if (bLoad_From_EEPOM) {
+				tmpValue = eprom_read(dev,
+						(EEPROM_TxPwIndex_CCK_V1>>1));
 				tmpValue = (tmpValue & 0xff00) >> 8;
-			}
-			else
+			} else
 				tmpValue = 0x10;
 			priv->EEPROMTxPowerLevelCCK_V1[0] = (u8)tmpValue;
 
 			if (bLoad_From_EEPOM)
-				tmpValue = eprom_read(dev, (EEPROM_TxPwIndex_CCK_V1 + 2)>>1);
+				tmpValue = eprom_read(dev,
+					(EEPROM_TxPwIndex_CCK_V1 + 2)>>1);
 			else
 				tmpValue = 0x1010;
-			*((u16*)(&priv->EEPROMTxPowerLevelCCK_V1[1])) = tmpValue;
+			*((u16 *)(&priv->EEPROMTxPowerLevelCCK_V1[1])) =
+								tmpValue;
 			if (bLoad_From_EEPOM)
-				tmpValue = eprom_read(dev, (EEPROM_TxPwIndex_OFDM_24G_V1>>1));
+				tmpValue = eprom_read(dev,
+					(EEPROM_TxPwIndex_OFDM_24G_V1>>1));
 			else
 				tmpValue = 0x1010;
-			*((u16*)(&priv->EEPROMTxPowerLevelOFDM24G[0])) = tmpValue;
+			*((u16 *)(&priv->EEPROMTxPowerLevelOFDM24G[0])) =
+								tmpValue;
 			if (bLoad_From_EEPOM)
-				tmpValue = eprom_read(dev, (EEPROM_TxPwIndex_OFDM_24G_V1+2)>>1);
+				tmpValue = eprom_read(dev,
+					(EEPROM_TxPwIndex_OFDM_24G_V1+2)>>1);
 			else
 				tmpValue = 0x10;
 			priv->EEPROMTxPowerLevelOFDM24G[2] = (u8)tmpValue;
@@ -3273,29 +3283,43 @@ static void rtl8192_read_eeprom_info(struct net_device *dev)
 			int i;
 			for (i = 0; i < 14; i++) {
 				if (i <= 3)
-					priv->TxPowerLevelOFDM24G[i] = priv->EEPROMTxPowerLevelOFDM24G[0];
+					priv->TxPowerLevelOFDM24G[i] = priv->
+						EEPROMTxPowerLevelOFDM24G[0];
 				else if (i >= 4 && i <= 9)
-					priv->TxPowerLevelOFDM24G[i] = priv->EEPROMTxPowerLevelOFDM24G[1];
+					priv->TxPowerLevelOFDM24G[i] = priv->
+						EEPROMTxPowerLevelOFDM24G[1];
 				else
-					priv->TxPowerLevelOFDM24G[i] = priv->EEPROMTxPowerLevelOFDM24G[2];
+					priv->TxPowerLevelOFDM24G[i] = priv->
+						EEPROMTxPowerLevelOFDM24G[2];
 			}
 			for (i = 0; i < 14; i++) {
 				if (priv->EEPROM_Def_Ver == 0) {
 					if (i <= 3)
-						priv->TxPowerLevelCCK[i] = priv->EEPROMTxPowerLevelOFDM24G[0] + (priv->EEPROMTxPowerLevelCCK - priv->EEPROMTxPowerLevelOFDM24G[1]);
+						priv->TxPowerLevelCCK[i] =
+							priv->EEPROMTxPowerLevelOFDM24G[0] +
+							(priv->EEPROMTxPowerLevelCCK - priv->
+							EEPROMTxPowerLevelOFDM24G[1]);
 					else if (i >= 4 && i <= 9)
-						priv->TxPowerLevelCCK[i] = priv->EEPROMTxPowerLevelCCK;
+						priv->TxPowerLevelCCK[i] =
+							priv->EEPROMTxPowerLevelCCK;
 					else
-						priv->TxPowerLevelCCK[i] = priv->EEPROMTxPowerLevelOFDM24G[2] + (priv->EEPROMTxPowerLevelCCK - priv->EEPROMTxPowerLevelOFDM24G[1]);
-				}
-				else if (priv->EEPROM_Def_Ver == 1)
-				{
-					if (i<=3)
-						priv->TxPowerLevelCCK[i] = priv->EEPROMTxPowerLevelCCK_V1[0];
-					else if (i>=4 && i<=9)
-						priv->TxPowerLevelCCK[i] = priv->EEPROMTxPowerLevelCCK_V1[1];
+						priv->TxPowerLevelCCK[i] =
+							priv->EEPROMTxPowerLevelOFDM24G[2] +
+							(priv->EEPROMTxPowerLevelCCK -
+							priv->EEPROMTxPowerLevelOFDM24G[1]);
+				} else if (priv->EEPROM_Def_Ver == 1) {
+					if (i <= 3)
+						priv->TxPowerLevelCCK[i] =
+						priv->EEPROMTxPowerLevelCCK_V1
+						[0];
+					else if (i >= 4 && i <= 9)
+						priv->TxPowerLevelCCK[i] =
+						priv->EEPROMTxPowerLevelCCK_V1
+						[1];
 					else
-						priv->TxPowerLevelCCK[i] = priv->EEPROMTxPowerLevelCCK_V1[2];
+						priv->TxPowerLevelCCK[i] =
+						priv->EEPROMTxPowerLevelCCK_V1
+						[2];
 				}
 			}
 		}	/* end update HAL variables */
@@ -3313,7 +3337,7 @@ static void rtl8192_read_eeprom_info(struct net_device *dev)
 	}	/* end if VersionID == VERSION_819xU_A */
 
 	/* added by vivi, for dlink led, 20080416 */
-	switch(priv->eeprom_CustomerID)	{
+	switch (priv->eeprom_CustomerID) {
 	case EEPROM_CID_RUNTOP:
 		priv->CustomerID = RT_CID_819x_RUNTOP;
 		break;
@@ -3325,7 +3349,7 @@ static void rtl8192_read_eeprom_info(struct net_device *dev)
 		break;
 	}
 
-	switch(priv->CustomerID) {
+	switch (priv->CustomerID) {
 	case RT_CID_819x_RUNTOP:
 		priv->LedStrategy = SW_LED_MODE2;
 		break;
@@ -3339,9 +3363,8 @@ static void rtl8192_read_eeprom_info(struct net_device *dev)
 
 	if (priv->rf_type == RF_1T2R) {
 		RT_TRACE(COMP_EPROM, "\n1T2R config\n");
-	} else {
+	} else
 		RT_TRACE(COMP_EPROM, "\n2T4R config\n");
-	}
 
 	/* 2008/01/16 MH We can only know RF type in the function.
 	 * So we have to init DIG RATR table again.
@@ -3353,28 +3376,28 @@ static void rtl8192_read_eeprom_info(struct net_device *dev)
 	return;
 }
 
-short rtl8192_get_channel_map(struct net_device * dev)
+short rtl8192_get_channel_map(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 #ifdef ENABLE_DOT11D
-	if(priv->ChannelPlan > COUNTRY_CODE_GLOBAL_DOMAIN){
+	if (priv->ChannelPlan > COUNTRY_CODE_GLOBAL_DOMAIN) {
 		printk("rtl8180_init:Error channel plan! Set to default.\n");
-		priv->ChannelPlan= 0;
+		priv->ChannelPlan = 0;
 	}
-	RT_TRACE(COMP_INIT, "Channel plan is %d\n",priv->ChannelPlan);
+	RT_TRACE(COMP_INIT, "Channel plan is %d\n", priv->ChannelPlan);
 
 	rtl819x_set_channel_map(priv->ChannelPlan, priv);
 #else
-	int ch,i;
+	int ch, i;
 	/* Set Default Channel Plan */
-	if(!channels){
+	if (!channels) {
 		DMESG("No channels, aborting");
 		return -1;
 	}
-	ch=channels;
-	priv->ChannelPlan= 0;		/* hikaru */
+	ch = channels;
+	priv->ChannelPlan = 0;		/* hikaru */
 	/* set channels 1..14 allowed in given locale */
-	for (i=1; i<=14; i++) {
+	for (i = 1; i <= 14; i++) {
 		(priv->ieee80211->channel_map)[i] = (u8)(ch & 0x01);
 		ch >>= 1;
 	}
-- 
1.6.3.3

