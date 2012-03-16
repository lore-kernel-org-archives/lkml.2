Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945961Ab2CPWu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 18:50:28 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44067 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032124Ab2CPWtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 18:49:23 -0400
From: Andrew Miller <amiller@amilx.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        amiller@amilx.com
Subject: [PATCH 3/5] Staging: rtl8187se: r8185b_init.c: Fix some spacing issues
Date: Fri, 16 Mar 2012 18:47:38 -0400
Message-Id: <1331938060-10207-4-git-send-email-amiller@amilx.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331938060-10207-1-git-send-email-amiller@amilx.com>
References: <1331938060-10207-1-git-send-email-amiller@amilx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some more spacing issues I missed before

Signed-off-by: Andrew Miller <amiller@amilx.com>
---
 drivers/staging/rtl8187se/r8185b_init.c |   44 ++++++++++++++----------------
 1 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index 5650ef1..3f9be9b 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -71,10 +71,10 @@ static u8 MAC_REG_TABLE[][2] =	{
 
 	/* PAGA 0: */
 	{0x5e, 0x00}, {0x9f, 0x03}
-			};
+	};
 
 
-static u8  ZEBRA_AGC[]	=	{
+static u8  ZEBRA_AGC[] = {
 	0,
 	0x7E, 0x7E, 0x7E, 0x7E, 0x7D, 0x7C, 0x7B, 0x7A, 0x79, 0x78, 0x77, 0x76, 0x75, 0x74, 0x73, 0x72,
 	0x71, 0x70, 0x6F, 0x6E, 0x6D, 0x6C, 0x6B, 0x6A, 0x69, 0x68, 0x67, 0x66, 0x65, 0x64, 0x63, 0x62,
@@ -94,7 +94,7 @@ static u32 ZEBRA_RF_RX_GAIN_TABLE[] = {
 	0x0183, 0x0163, 0x0143, 0x0123, 0x0103
 	};
 
-static u8 OFDM_CONFIG[]	=	{
+static u8 OFDM_CONFIG[]	= {
 	/* OFDM reg0x06[7:0]=0xFF: Enable power saving mode in RX */
 	/* OFDM reg0x3C[4]=1'b1: Enable RX power saving mode */
 	/* ofdm 0x3a = 0x7b ,(original : 0xfb) For ECS shielding room TP test */
@@ -121,22 +121,20 @@ void PlatformIOWrite1Byte(struct net_device *dev, u32 offset, u8 data)
 {
 	write_nic_byte(dev, offset, data);
 	read_nic_byte(dev, offset); /* To make sure write operation is completed, 2005.11.09, by rcnjko. */
-
 }
 
 void PlatformIOWrite2Byte(struct net_device *dev, u32 offset, u16 data)
 {
 	write_nic_word(dev, offset, data);
 	read_nic_word(dev, offset); /* To make sure write operation is completed, 2005.11.09, by rcnjko. */
-
-
 }
+
 u8 PlatformIORead1Byte(struct net_device *dev, u32 offset);
 
 void PlatformIOWrite4Byte(struct net_device *dev, u32 offset, u32 data)
 {
 /* {by amy 080312 */
-	if (offset == PhyAddr)	{
+	if (offset == PhyAddr) {
 	/* For Base Band configuration. */
 		unsigned char	cmdByte;
 		unsigned long	dataBytes;
@@ -156,7 +154,7 @@ void PlatformIOWrite4Byte(struct net_device *dev, u32 offset, u32 data)
 		*/
 		/* NdisAcquireSpinLock( &(pDevice->IoSpinLock) ); */
 
-		for (idx = 0; idx < 30; idx++)	{ 
+		for (idx = 0; idx < 30; idx++) {
 		/* Make sure command bit is clear before access it. */
 			u1bTmp = PlatformIORead1Byte(dev, PhyAddr);
 			if ((u1bTmp & BIT7) == 0)
@@ -224,9 +222,9 @@ static int HwHSSIThreeWire(struct net_device *dev,
 	u8	TryCnt;
 	u8	u1bTmp;
 
-	do	{
+	do {
 		/* Check if WE and RE are cleared. */
-		for (TryCnt = 0; TryCnt < TC_3W_POLL_MAX_TRY_CNT; TryCnt++)	{
+		for (TryCnt = 0; TryCnt < TC_3W_POLL_MAX_TRY_CNT; TryCnt++) {
 			u1bTmp = read_nic_byte(dev, SW_3W_CMD1);
 			if ((u1bTmp & (SW_3W_CMD1_RE|SW_3W_CMD1_WE)) == 0)
 				break;
@@ -252,7 +250,7 @@ static int HwHSSIThreeWire(struct net_device *dev,
 
 		write_nic_byte(dev, RF_SW_CONFIG, u1bTmp);
 
-		if (bSI)	{
+		if (bSI) {
 			/* jong: HW SI read must set reg84[3]=0. */
 			u1bTmp = read_nic_byte(dev, RFPinsSelect);
 			u1bTmp &= ~BIT3;
@@ -260,14 +258,14 @@ static int HwHSSIThreeWire(struct net_device *dev,
 		}
 		/*  Fill up data buffer for write operation. */
 
-		if (bWrite)	{
-			if (nDataBufBitCnt == 16)	{
+		if (bWrite) {
+			if (nDataBufBitCnt == 16) {
 				write_nic_word(dev, SW_3W_DB0, *((u16 *)pDataBuf));
-			}	else if (nDataBufBitCnt == 64)	{
+			} else if (nDataBufBitCnt == 64) {
 			/* RTL8187S shouldn't enter this case */
 				write_nic_dword(dev, SW_3W_DB0, *((u32 *)pDataBuf));
 				write_nic_dword(dev, SW_3W_DB1, *((u32 *)(pDataBuf + 4)));
-			}	else	{
+			} else {
 				int idx;
 				int ByteCnt = nDataBufBitCnt / 8;
 								/* printk("%d\n",nDataBufBitCnt); */
@@ -293,11 +291,11 @@ static int HwHSSIThreeWire(struct net_device *dev,
 					write_nic_byte(dev, (SW_3W_DB0+idx), *(pDataBuf+idx));
 
 			}
-		}	else	{	/* read */
-			if (bSI)	{
+		} else {	/* read */
+			if (bSI) {
 				/* SI - reg274[3:0] : RF register's Address */
 				write_nic_word(dev, SW_3W_DB0, *((u16 *)pDataBuf));
-			}	else	{
+			} else {
 				/*  PI - reg274[15:12] : RF register's Address */
 				write_nic_word(dev, SW_3W_DB0, (*((u16 *)pDataBuf)) << 12);
 			}
@@ -323,11 +321,11 @@ static int HwHSSIThreeWire(struct net_device *dev,
 		write_nic_byte(dev, SW_3W_CMD1, 0);
 
 		/* Read back data for read operation. */
-		if (bWrite == 0)	{
-			if (bSI)		{
+		if (bWrite == 0) {
+			if (bSI) {
 				/* Serial Interface : reg363_362[11:0] */
 				*((u16 *)pDataBuf) = read_nic_word(dev, SI_DATA_READ) ;
-			}	else	{
+			} else {
 				/* Parallel Interface : reg361_360[11:0] */
 				*((u16 *)pDataBuf) = read_nic_word(dev, PI_DATA_READ);
 			}
@@ -335,7 +333,7 @@ static int HwHSSIThreeWire(struct net_device *dev,
 			*((u16 *)pDataBuf) &= 0x0FFF;
 		}
 
-	}	while (0);
+	} while (0);
 
 	return bResult;
 }
@@ -1296,7 +1294,7 @@ bool MgntActSet_RF_State(struct net_device *dev, RT_RF_POWER_STATE StateToSet, u
 		Prevent the race condition of RF state change. By Bruce, 2007-11-28.
 		Only one thread can change the RF state at one time, and others should wait to be executed.
 	*/
-	while (true)	{
+	while (true) {
 		spin_lock_irqsave(&priv->rf_ps_lock, flag);
 		if (priv->RFChangeInProgress) {
 			spin_unlock_irqrestore(&priv->rf_ps_lock, flag);
-- 
1.7.7.6

