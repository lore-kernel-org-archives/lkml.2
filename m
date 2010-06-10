Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479Ab0FJBR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 21:17:57 -0400
Received: from outbound-mail04.westnet.com.au ([203.10.1.245]:16331 "EHLO
	outbound-mail04.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755999Ab0FJBRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 21:17:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvUxAGjaD0w6B9paPGdsb2JhbACHcJZrDAEBAQE1LbEyjWuFGASDRw
X-IronPort-AV: E=Sophos;i="4.53,395,1272816000"; 
   d="scan'208";a="44446489"
From: Mike Gilks <mike.kernel@gilksonline.com>
To: gregkh@suse.de, mchehab@redhat.com, julia@diku.dk, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Gilks <mike.kernel@gilksonline.com>
Subject: [PATCH 2/4] staging: rtl8192u: fix checkpatch.pl issues to line 3200 Fix most problems pointed out by checkpatch.pl in file r8192U_core.c up to line 3200
Date: Thu, 10 Jun 2010 09:18:03 +0800
Message-Id: <1276132685-26713-3-git-send-email-mike.kernel@gilksonline.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1276132685-26713-2-git-send-email-mike.kernel@gilksonline.com>
References: <1276132685-26713-1-git-send-email-mike.kernel@gilksonline.com>
 <1276132685-26713-2-git-send-email-mike.kernel@gilksonline.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Gilks <mike.kernel@gilksonline.com>
---
 drivers/staging/rtl8192u/r8192U_core.c |   81 +++++++++++++++++---------------
 1 files changed, 43 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 8b6aacb..f66d66e 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -3103,23 +3103,26 @@ static void rtl8192_get_eeprom_size(struct net_device *dev)
 	u16 curCR = 0;
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	RT_TRACE(COMP_EPROM, "===========>%s()\n", __func__);
-	curCR = read_nic_word_E(dev,EPROM_CMD);
-	RT_TRACE(COMP_EPROM, "read from Reg EPROM_CMD(%x):%x\n", EPROM_CMD, curCR);
+	curCR = read_nic_word_E(dev, EPROM_CMD);
+	RT_TRACE(COMP_EPROM, "read from Reg EPROM_CMD(%x):%x\n",
+			EPROM_CMD, curCR);
 	/* whether need I consider BIT5? */
-	priv->epromtype = (curCR & Cmd9346CR_9356SEL) ? EPROM_93c56 : EPROM_93c46;
-	RT_TRACE(COMP_EPROM, "<===========%s(), epromtype:%d\n", __func__, priv->epromtype);
+	priv->epromtype = (curCR & Cmd9346CR_9356SEL) ? EPROM_93c56 :
+				EPROM_93c46;
+	RT_TRACE(COMP_EPROM, "<===========%s(), epromtype:%d\n",
+			__func__, priv->epromtype);
 }
 
 /* used to swap endian. as ntohl & htonl are not neccessary to swap endian,
  * so use this instead.
  */
-static inline u16 endian_swap(u16* data)
+static inline u16 endian_swap(u16 *data)
 {
 	u16 tmp = *data;
 	*data = (tmp >> 8) | (tmp << 8);
 	return *data;
 }
-static void rtl8192_read_eeprom_info(struct net_device* dev)
+static void rtl8192_read_eeprom_info(struct net_device *dev)
 {
 	u16 wEPROM_ID = 0;
 	u8 bMac_Tmp_Addr[6] = {0x00, 0xe0, 0x4c, 0x00, 0x00, 0x02};
@@ -3130,46 +3133,42 @@ static void rtl8192_read_eeprom_info(struct net_device* dev)
 	wEPROM_ID = eprom_read(dev, 0);		/* first read EEPROM ID out; */
 	RT_TRACE(COMP_EPROM, "EEPROM ID is 0x%x\n", wEPROM_ID);
 
-	if (wEPROM_ID != RTL8190_EEPROM_ID)
-	{
-		RT_TRACE(COMP_ERR, "EEPROM ID is invalid(is 0x%x(should be 0x%x)\n", wEPROM_ID, RTL8190_EEPROM_ID);
-	}
-	else
+	if (wEPROM_ID != RTL8190_EEPROM_ID) {
+		RT_TRACE(COMP_ERR, "EEPROM ID is invalid(is 0x%x"
+			"(should be 0x%x)\n", wEPROM_ID, RTL8190_EEPROM_ID);
+	} else
 		bLoad_From_EEPOM = true;
 
-	if (bLoad_From_EEPOM)
-	{
+	if (bLoad_From_EEPOM) {
 		tmpValue = eprom_read(dev, (EEPROM_VID>>1));
 		priv->eeprom_vid = endian_swap(&tmpValue);
 		priv->eeprom_pid = eprom_read(dev, (EEPROM_PID>>1));
 		tmpValue = eprom_read(dev, (EEPROM_ChannelPlan>>1));
-		priv->eeprom_ChannelPlan =((tmpValue&0xff00)>>8);
+		priv->eeprom_ChannelPlan = ((tmpValue&0xff00)>>8);
 		priv->btxpowerdata_readfromEEPORM = true;
-		priv->eeprom_CustomerID = eprom_read(dev, (EEPROM_Customer_ID>>1)) >>8;
-	}
-	else
-	{
+		priv->eeprom_CustomerID = eprom_read(dev,
+						(EEPROM_Customer_ID>>1)) >> 8;
+	} else {
 		priv->eeprom_vid = 0;
 		priv->eeprom_pid = 0;
 		priv->card_8192_version = VERSION_819xU_B;
 		priv->eeprom_ChannelPlan = 0;
 		priv->eeprom_CustomerID = 0;
 	}
-	RT_TRACE(COMP_EPROM, "vid:0x%4x, pid:0x%4x, CustomID:0x%2x, ChanPlan:0x%x\n", priv->eeprom_vid, priv->eeprom_pid, priv->eeprom_CustomerID, priv->eeprom_ChannelPlan);
+	RT_TRACE(COMP_EPROM, "vid:0x%4x, pid:0x%4x, CustomID:0x%2x, "
+		"ChanPlan:0x%x\n", priv->eeprom_vid, priv->eeprom_pid,
+		priv->eeprom_CustomerID, priv->eeprom_ChannelPlan);
 	/* set channelplan from eeprom */
 	priv->ChannelPlan = priv->eeprom_ChannelPlan;
-	if (bLoad_From_EEPOM)
-	{
+	if (bLoad_From_EEPOM) {
 		int i;
-		for (i=0; i<6; i+=2)
-		{
+		for (i = 0; i < 6; i += 2) {
 			u16 tmp = 0;
-			tmp = eprom_read(dev, (u16)((EEPROM_NODE_ADDRESS_BYTE_0 + i)>>1));
-			*(u16*)(&dev->dev_addr[i]) = tmp;
+			tmp = eprom_read(dev, (u16)(
+					(EEPROM_NODE_ADDRESS_BYTE_0 + i)>>1));
+			*(u16 *)(&dev->dev_addr[i]) = tmp;
 		}
-	}
-	else
-	{
+	} else {
 		memcpy(dev->dev_addr, bMac_Tmp_Addr, 6);
 		/* should I set IDR0 here? */
 	}
@@ -3177,34 +3176,40 @@ static void rtl8192_read_eeprom_info(struct net_device* dev)
 	priv->rf_type = RTL819X_DEFAULT_RF_TYPE;	/* default 1T2R */
 	priv->rf_chip = RF_8256;
 
-	if (priv->card_8192_version == (u8)VERSION_819xU_A)
-	{
+	if (priv->card_8192_version == (u8)VERSION_819xU_A) {
 		/* read Tx power gain offset of legacy OFDM to HT rate */
 		if (bLoad_From_EEPOM)
-			priv->EEPROMTxPowerDiff = (eprom_read(dev, (EEPROM_TxPowerDiff>>1))&0xff00) >> 8;
+			priv->EEPROMTxPowerDiff = (eprom_read(dev,
+					(EEPROM_TxPowerDiff>>1))&0xff00) >> 8;
 		else
 			priv->EEPROMTxPowerDiff = EEPROM_Default_TxPower;
-		RT_TRACE(COMP_EPROM, "TxPowerDiff:%d\n", priv->EEPROMTxPowerDiff);
+		RT_TRACE(COMP_EPROM, "TxPowerDiff:%d\n",
+						priv->EEPROMTxPowerDiff);
 		/* read ThermalMeter from EEPROM */
 		if (bLoad_From_EEPOM)
-			priv->EEPROMThermalMeter = (u8)(eprom_read(dev, (EEPROM_ThermalMeter>>1))&0x00ff);
+			priv->EEPROMThermalMeter = (u8)(eprom_read(dev,
+					(EEPROM_ThermalMeter>>1))&0x00ff);
 		else
 			priv->EEPROMThermalMeter = EEPROM_Default_ThermalMeter;
-		RT_TRACE(COMP_EPROM, "ThermalMeter:%d\n", priv->EEPROMThermalMeter);
+		RT_TRACE(COMP_EPROM, "ThermalMeter:%d\n",
+			priv->EEPROMThermalMeter);
 		/* vivi, for tx power track */
-		priv->TSSI_13dBm = priv->EEPROMThermalMeter *100;
+		priv->TSSI_13dBm = priv->EEPROMThermalMeter * 100;
 		/* read antenna tx power offset of B/C/D to A from EEPROM */
 		if (bLoad_From_EEPOM)
-			priv->EEPROMPwDiff = (eprom_read(dev, (EEPROM_PwDiff>>1))&0x0f00)>>8;
+			priv->EEPROMPwDiff = (eprom_read(dev,
+					(EEPROM_PwDiff>>1))&0x0f00)>>8;
 		else
 			priv->EEPROMPwDiff = EEPROM_Default_PwDiff;
 		RT_TRACE(COMP_EPROM, "TxPwDiff:%d\n", priv->EEPROMPwDiff);
 		/* Read CrystalCap from EEPROM */
 		if (bLoad_From_EEPOM)
-			priv->EEPROMCrystalCap = (eprom_read(dev, (EEPROM_CrystalCap>>1))&0x0f);
+			priv->EEPROMCrystalCap = (eprom_read(dev,
+						(EEPROM_CrystalCap>>1))&0x0f);
 		else
 			priv->EEPROMCrystalCap = EEPROM_Default_CrystalCap;
-		RT_TRACE(COMP_EPROM, "CrystalCap = %d\n", priv->EEPROMCrystalCap);
+		RT_TRACE(COMP_EPROM, "CrystalCap = %d\n",
+						priv->EEPROMCrystalCap);
 		/* get per-channel Tx power level */
 		if (bLoad_From_EEPOM)
 			priv->EEPROM_Def_Ver = (eprom_read(dev, (EEPROM_TxPwIndex_Ver>>1))&0xff00)>>8;
-- 
1.6.3.3

