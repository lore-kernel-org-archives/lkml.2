Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032220Ab2CPWt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 18:49:26 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:53346 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758392Ab2CPWtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 18:49:15 -0400
From: Andrew Miller <amiller@amilx.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        amiller@amilx.com
Subject: [PATCH 1/5] Staging: rtl8187se: r8185b_init.c: Fixed spacing
Date: Fri, 16 Mar 2012 18:47:36 -0400
Message-Id: <1331938060-10207-2-git-send-email-amiller@amilx.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331938060-10207-1-git-send-email-amiller@amilx.com>
References: <1331938060-10207-1-git-send-email-amiller@amilx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed unnecessary tabs, spaces, and blank lines.

Signed-off-by: Andrew Miller <amiller@amilx.com>
---
 drivers/staging/rtl8187se/r8185b_init.c |  721 +++++++++++++++----------------
 1 files changed, 351 insertions(+), 370 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index 4b0b830..3c1ca69 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -10,7 +10,7 @@ Abstract:
 Major Change History:
 	When		Who				What
 	----------	---------------		-------------------------------
-	2006-11-15    Xiong		Created
+	2006-11-15	Xiong			Created
 
 Notes:
 	This file is ported from RTL8185B Windows driver.
@@ -33,87 +33,86 @@ Notes:
 
 #define TC_3W_POLL_MAX_TRY_CNT 5
 static u8 MAC_REG_TABLE[][2] =	{
-                        /*PAGA 0:	*/
-						/* 0x34(BRSR), 0xBE(RATE_FALLBACK_CTL), 0x1E0(ARFR) would set in HwConfigureRTL8185()	*/
-						/* 0x272(RFSW_CTRL), 0x1CE(AESMSK_QC) set in InitializeAdapter8185().					*/
-						/* 0x1F0~0x1F8  set in MacConfig_85BASIC()												*/
-						{0x08, 0xae}, {0x0a, 0x72}, {0x5b, 0x42},
-						{0x84, 0x88}, {0x85, 0x24}, {0x88, 0x54}, {0x8b, 0xb8}, {0x8c, 0x03},
-						{0x8d, 0x40}, {0x8e, 0x00}, {0x8f, 0x00}, {0x5b, 0x18}, {0x91, 0x03},
-						{0x94, 0x0F}, {0x95, 0x32},
-						{0x96, 0x00}, {0x97, 0x07}, {0xb4, 0x22}, {0xdb, 0x00},
-						{0xf0, 0x32}, {0xf1, 0x32}, {0xf2, 0x00}, {0xf3, 0x00}, {0xf4, 0x32},
-						{0xf5, 0x43}, {0xf6, 0x00}, {0xf7, 0x00}, {0xf8, 0x46}, {0xf9, 0xa4},
-						{0xfa, 0x00}, {0xfb, 0x00}, {0xfc, 0x96}, {0xfd, 0xa4}, {0xfe, 0x00},
-						{0xff, 0x00},
-
-						/*PAGE 1:	*/
-						/* For Flextronics system Logo PCIHCT failure:	*/
-				/* 0x1C4~0x1CD set no-zero value to avoid PCI configuration space 0x45[7]=1	*/
-						{0x5e, 0x01},
-						{0x58, 0x00}, {0x59, 0x00}, {0x5a, 0x04}, {0x5b, 0x00}, {0x60, 0x24},
-						{0x61, 0x97}, {0x62, 0xF0}, {0x63, 0x09}, {0x80, 0x0F}, {0x81, 0xFF},
-						{0x82, 0xFF}, {0x83, 0x03},
-						{0xC4, 0x22}, {0xC5, 0x22}, {0xC6, 0x22}, {0xC7, 0x22}, {0xC8, 0x22}, /* lzm add 080826 */
-						{0xC9, 0x22}, {0xCA, 0x22}, {0xCB, 0x22}, {0xCC, 0x22}, {0xCD, 0x22},/* lzm add 080826 */
-						{0xe2, 0x00},
-
-
-						/* PAGE 2: */
-						{0x5e, 0x02},
-						{0x0c, 0x04}, {0x4c, 0x30}, {0x4d, 0x08}, {0x50, 0x05}, {0x51, 0xf5},
-						{0x52, 0x04}, {0x53, 0xa0}, {0x54, 0xff}, {0x55, 0xff}, {0x56, 0xff},
-						{0x57, 0xff}, {0x58, 0x08}, {0x59, 0x08}, {0x5a, 0x08}, {0x5b, 0x08},
-						{0x60, 0x08}, {0x61, 0x08}, {0x62, 0x08}, {0x63, 0x08}, {0x64, 0x2f},
-						{0x8c, 0x3f}, {0x8d, 0x3f}, {0x8e, 0x3f},
-						{0x8f, 0x3f}, {0xc4, 0xff}, {0xc5, 0xff}, {0xc6, 0xff}, {0xc7, 0xff},
-						{0xc8, 0x00}, {0xc9, 0x00}, {0xca, 0x80}, {0xcb, 0x00},
-
-						/* PAGA 0: */
-						{0x5e, 0x00}, {0x9f, 0x03}
+	/*PAGA 0:	*/
+	/* 0x34(BRSR), 0xBE(RATE_FALLBACK_CTL), 0x1E0(ARFR) would set in HwConfigureRTL8185() */
+	/* 0x272(RFSW_CTRL), 0x1CE(AESMSK_QC) set in InitializeAdapter8185(). */
+	/* 0x1F0~0x1F8  set in MacConfig_85BASIC() */
+	{0x08, 0xae}, {0x0a, 0x72}, {0x5b, 0x42},
+	{0x84, 0x88}, {0x85, 0x24}, {0x88, 0x54}, {0x8b, 0xb8}, {0x8c, 0x03},
+	{0x8d, 0x40}, {0x8e, 0x00}, {0x8f, 0x00}, {0x5b, 0x18}, {0x91, 0x03},
+	{0x94, 0x0F}, {0x95, 0x32},
+	{0x96, 0x00}, {0x97, 0x07}, {0xb4, 0x22}, {0xdb, 0x00},
+	{0xf0, 0x32}, {0xf1, 0x32}, {0xf2, 0x00}, {0xf3, 0x00}, {0xf4, 0x32},
+	{0xf5, 0x43}, {0xf6, 0x00}, {0xf7, 0x00}, {0xf8, 0x46}, {0xf9, 0xa4},
+	{0xfa, 0x00}, {0xfb, 0x00}, {0xfc, 0x96}, {0xfd, 0xa4}, {0xfe, 0x00},
+	{0xff, 0x00},
+
+	/*PAGE 1: */
+	/* For Flextronics system Logo PCIHCT failure: */
+	/* 0x1C4~0x1CD set no-zero value to avoid PCI configuration space 0x45[7]=1 */
+	{0x5e, 0x01},
+	{0x58, 0x00}, {0x59, 0x00}, {0x5a, 0x04}, {0x5b, 0x00}, {0x60, 0x24},
+	{0x61, 0x97}, {0x62, 0xF0}, {0x63, 0x09}, {0x80, 0x0F}, {0x81, 0xFF},
+	{0x82, 0xFF}, {0x83, 0x03},
+	{0xC4, 0x22}, {0xC5, 0x22}, {0xC6, 0x22}, {0xC7, 0x22}, {0xC8, 0x22}, /* lzm add 080826 */
+	{0xC9, 0x22}, {0xCA, 0x22}, {0xCB, 0x22}, {0xCC, 0x22}, {0xCD, 0x22}, /* lzm add 080826 */
+	{0xe2, 0x00},
+
+
+	/* PAGE 2: */
+	{0x5e, 0x02},
+	{0x0c, 0x04}, {0x4c, 0x30}, {0x4d, 0x08}, {0x50, 0x05}, {0x51, 0xf5},
+	{0x52, 0x04}, {0x53, 0xa0}, {0x54, 0xff}, {0x55, 0xff}, {0x56, 0xff},
+	{0x57, 0xff}, {0x58, 0x08}, {0x59, 0x08}, {0x5a, 0x08}, {0x5b, 0x08},
+	{0x60, 0x08}, {0x61, 0x08}, {0x62, 0x08}, {0x63, 0x08}, {0x64, 0x2f},
+	{0x8c, 0x3f}, {0x8d, 0x3f}, {0x8e, 0x3f},
+	{0x8f, 0x3f}, {0xc4, 0xff}, {0xc5, 0xff}, {0xc6, 0xff}, {0xc7, 0xff},
+	{0xc8, 0x00}, {0xc9, 0x00}, {0xca, 0x80}, {0xcb, 0x00},
+
+	/* PAGA 0: */
+	{0x5e, 0x00}, {0x9f, 0x03}
 			};
 
 
 static u8  ZEBRA_AGC[]	=	{
-			0,
-			0x7E, 0x7E, 0x7E, 0x7E, 0x7D, 0x7C, 0x7B, 0x7A, 0x79, 0x78, 0x77, 0x76, 0x75, 0x74, 0x73, 0x72,
-			0x71, 0x70, 0x6F, 0x6E, 0x6D, 0x6C, 0x6B, 0x6A, 0x69, 0x68, 0x67, 0x66, 0x65, 0x64, 0x63, 0x62,
-			0x48, 0x47, 0x46, 0x45, 0x44, 0x29, 0x28, 0x27, 0x26, 0x25, 0x24, 0x23, 0x22, 0x21, 0x08, 0x07,
-			0x06, 0x05, 0x04, 0x03, 0x02, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-			0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x10, 0x11, 0x12, 0x13, 0x15, 0x16,
-			0x17, 0x17, 0x18, 0x18, 0x19, 0x1a, 0x1a, 0x1b, 0x1b, 0x1c, 0x1c, 0x1d, 0x1d, 0x1d, 0x1e, 0x1e,
-			0x1f, 0x1f, 0x1f, 0x20, 0x20, 0x20, 0x20, 0x21, 0x21, 0x21, 0x22, 0x22, 0x22, 0x23, 0x23, 0x24,
-			0x24, 0x25, 0x25, 0x25, 0x26, 0x26, 0x27, 0x27, 0x2F, 0x2F, 0x2F, 0x2F, 0x2F, 0x2F, 0x2F, 0x2F
-			};
+	0,
+	0x7E, 0x7E, 0x7E, 0x7E, 0x7D, 0x7C, 0x7B, 0x7A, 0x79, 0x78, 0x77, 0x76, 0x75, 0x74, 0x73, 0x72,
+	0x71, 0x70, 0x6F, 0x6E, 0x6D, 0x6C, 0x6B, 0x6A, 0x69, 0x68, 0x67, 0x66, 0x65, 0x64, 0x63, 0x62,
+	0x48, 0x47, 0x46, 0x45, 0x44, 0x29, 0x28, 0x27, 0x26, 0x25, 0x24, 0x23, 0x22, 0x21, 0x08, 0x07,
+	0x06, 0x05, 0x04, 0x03, 0x02, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x10, 0x11, 0x12, 0x13, 0x15, 0x16,
+	0x17, 0x17, 0x18, 0x18, 0x19, 0x1a, 0x1a, 0x1b, 0x1b, 0x1c, 0x1c, 0x1d, 0x1d, 0x1d, 0x1e, 0x1e,
+	0x1f, 0x1f, 0x1f, 0x20, 0x20, 0x20, 0x20, 0x21, 0x21, 0x21, 0x22, 0x22, 0x22, 0x23, 0x23, 0x24,
+	0x24, 0x25, 0x25, 0x25, 0x26, 0x26, 0x27, 0x27, 0x2F, 0x2F, 0x2F, 0x2F, 0x2F, 0x2F, 0x2F, 0x2F
+	};
 
-static u32 ZEBRA_RF_RX_GAIN_TABLE[]	=	{
-			0x0096, 0x0076, 0x0056, 0x0036, 0x0016, 0x01f6, 0x01d6, 0x01b6,
-			0x0196, 0x0176, 0x00F7, 0x00D7, 0x00B7, 0x0097, 0x0077, 0x0057,
-			0x0037, 0x00FB, 0x00DB, 0x00BB, 0x00FF, 0x00E3, 0x00C3, 0x00A3,
-			0x0083, 0x0063, 0x0043, 0x0023, 0x0003, 0x01E3, 0x01C3, 0x01A3,
-			0x0183, 0x0163, 0x0143, 0x0123, 0x0103
+static u32 ZEBRA_RF_RX_GAIN_TABLE[] = {
+	0x0096, 0x0076, 0x0056, 0x0036, 0x0016, 0x01f6, 0x01d6, 0x01b6,
+	0x0196, 0x0176, 0x00F7, 0x00D7, 0x00B7, 0x0097, 0x0077, 0x0057,
+	0x0037, 0x00FB, 0x00DB, 0x00BB, 0x00FF, 0x00E3, 0x00C3, 0x00A3,
+	0x0083, 0x0063, 0x0043, 0x0023, 0x0003, 0x01E3, 0x01C3, 0x01A3,
+	0x0183, 0x0163, 0x0143, 0x0123, 0x0103
 	};
 
 static u8 OFDM_CONFIG[]	=	{
-			/* OFDM reg0x06[7:0]=0xFF: Enable power saving mode in RX				*/
-			/* OFDM reg0x3C[4]=1'b1: Enable RX power saving mode					*/
-			/* ofdm 0x3a = 0x7b ,(original : 0xfb) For ECS shielding room TP test	*/
-
-			/* 0x00	*/
-			0x10, 0x0F, 0x0A, 0x0C, 0x14, 0xFA, 0xFF, 0x50,
-			0x00, 0x50, 0x00, 0x00, 0x00, 0x5C, 0x00, 0x00,
-			/* 0x10	*/
-			0x40, 0x00, 0x40, 0x00, 0x00, 0x00, 0xA8, 0x26,
-			0x32, 0x33, 0x06, 0xA5, 0x6F, 0x55, 0xC8, 0xBB,
-			/* 0x20	*/
-			0x0A, 0xE1, 0x2C, 0x4A, 0x86, 0x83, 0x34, 0x00,
-			0x4F, 0x24, 0x6F, 0xC2, 0x03, 0x40, 0x80, 0x00,
-			/* 0x30	*/
-			0xC0, 0xC1, 0x58, 0xF1, 0x00, 0xC4, 0x90, 0x3e,
-			0xD8, 0x3C, 0x7B, 0x10, 0x10
-		};
-
-/*	---------------------------------------------------------------
+	/* OFDM reg0x06[7:0]=0xFF: Enable power saving mode in RX */
+	/* OFDM reg0x3C[4]=1'b1: Enable RX power saving mode */
+	/* ofdm 0x3a = 0x7b ,(original : 0xfb) For ECS shielding room TP test */
+	/* 0x00	*/
+	0x10, 0x0F, 0x0A, 0x0C, 0x14, 0xFA, 0xFF, 0x50,
+	0x00, 0x50, 0x00, 0x00, 0x00, 0x5C, 0x00, 0x00,
+	/* 0x10	*/
+	0x40, 0x00, 0x40, 0x00, 0x00, 0x00, 0xA8, 0x26,
+	0x32, 0x33, 0x06, 0xA5, 0x6F, 0x55, 0xC8, 0xBB,
+	/* 0x20	*/
+	0x0A, 0xE1, 0x2C, 0x4A, 0x86, 0x83, 0x34, 0x00,
+	0x4F, 0x24, 0x6F, 0xC2, 0x03, 0x40, 0x80, 0x00,
+	/* 0x30	*/
+	0xC0, 0xC1, 0x58, 0xF1, 0x00, 0xC4, 0x90, 0x3e,
+	0xD8, 0x3C, 0x7B, 0x10, 0x10
+	};
+
+	/*---------------------------------------------------------------
 	*	Hardware IO
 	*	the code is ported from Windows source code
 	----------------------------------------------------------------*/
@@ -126,7 +125,7 @@ PlatformIOWrite1Byte(
 	)
 {
 	write_nic_byte(dev, offset, data);
-	read_nic_byte(dev, offset); /* To make sure write operation is completed, 2005.11.09, by rcnjko.	*/
+	read_nic_byte(dev, offset); /* To make sure write operation is completed, 2005.11.09, by rcnjko. */
 
 }
 
@@ -152,12 +151,12 @@ PlatformIOWrite4Byte(
 	)
 {
 /* {by amy 080312 */
-if (offset == PhyAddr)	{
-/* For Base Band configuration. */
+	if (offset == PhyAddr)	{
+	/* For Base Band configuration. */
 		unsigned char	cmdByte;
 		unsigned long	dataBytes;
 		unsigned char	idx;
-		u8	u1bTmp;
+		u8		u1bTmp;
 
 		cmdByte = (u8)(data & 0x000000ff);
 		dataBytes = data>>8;
@@ -170,10 +169,10 @@ if (offset == PhyAddr)	{
 			acquiring the spinlock in such context.
 			2. PlatformIOWrite4Byte() MUST NOT be recursive.
 		*/
-/*		NdisAcquireSpinLock( &(pDevice->IoSpinLock) );	*/
+		/* NdisAcquireSpinLock( &(pDevice->IoSpinLock) ); */
 
 		for (idx = 0; idx < 30; idx++)	{ 
-		/* Make sure command bit is clear before access it.	*/
+		/* Make sure command bit is clear before access it. */
 			u1bTmp = PlatformIORead1Byte(dev, PhyAddr);
 			if ((u1bTmp & BIT7) == 0)
 				break;
@@ -186,7 +185,7 @@ if (offset == PhyAddr)	{
 
 		write_nic_byte(dev, offset, cmdByte);
 
-/*		NdisReleaseSpinLock( &(pDevice->IoSpinLock) ); */
+		/* NdisReleaseSpinLock( &(pDevice->IoSpinLock) ); */
 	}
 /* by amy 080312} */
 	else	{
@@ -275,10 +274,10 @@ HwHSSIThreeWire(
 		u1bTmp = read_nic_byte(dev, RF_SW_CONFIG);
 
 		if (bSI)
-			u1bTmp |=   RF_SW_CFG_SI;   /* reg08[1]=1 Serial Interface(SI)	*/
+			u1bTmp |=   RF_SW_CFG_SI; /* reg08[1]=1 Serial Interface(SI) */
 
 		else
-			u1bTmp &= ~RF_SW_CFG_SI;  /* reg08[1]=0 Parallel Interface(PI)	*/
+			u1bTmp &= ~RF_SW_CFG_SI; /* reg08[1]=0 Parallel Interface(PI) */
 
 
 		write_nic_byte(dev, RF_SW_CONFIG, u1bTmp);
@@ -326,7 +325,7 @@ HwHSSIThreeWire(
 			}
 		}	else	{	/* read */
 			if (bSI)	{
-				/* SI - reg274[3:0] : RF register's Address	*/
+				/* SI - reg274[3:0] : RF register's Address */
 				write_nic_word(dev, SW_3W_DB0, *((u16 *)pDataBuf));
 			}	else	{
 				/*  PI - reg274[15:12] : RF register's Address */
@@ -343,7 +342,7 @@ HwHSSIThreeWire(
 
 
 		/* Check if DONE is set. */
-		for (TryCnt = 0; TryCnt < TC_3W_POLL_MAX_TRY_CNT; TryCnt++)	{
+		for (TryCnt = 0; TryCnt < TC_3W_POLL_MAX_TRY_CNT; TryCnt++) {
 			u1bTmp = read_nic_byte(dev, SW_3W_CMD1);
 			if ((u1bTmp & SW_3W_CMD1_DONE) != 0)
 				break;
@@ -353,7 +352,7 @@ HwHSSIThreeWire(
 
 		write_nic_byte(dev, SW_3W_CMD1, 0);
 
-		/* Read back data for read operation.	*/
+		/* Read back data for read operation. */
 		if (bWrite == 0)	{
 			if (bSI)		{
 				/* Serial Interface : reg363_362[11:0] */
@@ -443,9 +442,9 @@ ReadBBPortUchar(
 */
 bool
 SetAntennaConfig87SE(
-	struct net_device *dev,
-	u8			DefaultAnt,		/* 0: Main, 1: Aux.			*/
-	bool		bAntDiversity	/* 1:Enable, 0: Disable.	*/
+	struct	net_device *dev,
+	u8	DefaultAnt, /* 0: Main, 1: Aux. */
+	bool	bAntDiversity /* 1:Enable, 0: Disable. */
 )
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
@@ -453,48 +452,48 @@ SetAntennaConfig87SE(
 
 	/* printk("SetAntennaConfig87SE(): DefaultAnt(%d), bAntDiversity(%d)\n", DefaultAnt, bAntDiversity); */
 
-	/* Threshold for antenna diversity.	*/
+	/* Threshold for antenna diversity. */
 	write_phy_cck(dev, 0x0c, 0x09); /* Reg0c : 09 */
 
-	if (bAntDiversity)	{	/*	Enable Antenna Diversity.	*/
-		if (DefaultAnt == 1)	{	/* aux antenna			*/
+	if (bAntDiversity) {	/*	Enable Antenna Diversity. */
+		if (DefaultAnt == 1) {	/* aux antenna */
 
-			/* Mac register, aux antenna	*/
+			/* Mac register, aux antenna */
 			write_nic_byte(dev, ANTSEL, 0x00);
 
-			/* Config CCK RX antenna.		*/
+			/* Config CCK RX antenna. */
 			write_phy_cck(dev, 0x11, 0xbb); /* Reg11 : bb */
 			write_phy_cck(dev, 0x01, 0xc7); /* Reg01 : c7 */
 
-			/* Config OFDM RX antenna.	*/
-			write_phy_ofdm(dev, 0x0D, 0x54);	/* Reg0d : 54	*/
-			write_phy_ofdm(dev, 0x18, 0xb2);	/* Reg18 : b2		*/
-		}	else	{	/*  use main antenna	*/
-			/* Mac register, main antenna		*/
+			/* Config OFDM RX antenna. */
+			write_phy_ofdm(dev, 0x0D, 0x54);	/* Reg0d : 54 */
+			write_phy_ofdm(dev, 0x18, 0xb2);	/* Reg18 : b2 */
+		} else { /*  use main antenna */
+			/* Mac register, main antenna */
 			write_nic_byte(dev, ANTSEL, 0x03);
-			/* base band				*/
-			/*  Config CCK RX antenna.	*/
-			write_phy_cck(dev, 0x11, 0x9b); /* Reg11 : 9b	*/
-			write_phy_cck(dev, 0x01, 0xc7); /* Reg01 : c7	*/
+			/* base band */
+			/*  Config CCK RX antenna. */
+			write_phy_cck(dev, 0x11, 0x9b); /* Reg11 : 9b */
+			write_phy_cck(dev, 0x01, 0xc7); /* Reg01 : c7 */
 
 			/* Config OFDM RX antenna. */
 			write_phy_ofdm(dev, 0x0d, 0x5c);  /* Reg0d : 5c	*/
 			write_phy_ofdm(dev, 0x18, 0xb2);  /* Reg18 : b2	*/
 		}
-	}	else	{
+	} else {
 		/* Disable Antenna Diversity. */
-		if (DefaultAnt == 1)	{	/* aux Antenna */
+		if (DefaultAnt == 1) { /* aux Antenna */
 			/* Mac register, aux antenna */
 			write_nic_byte(dev, ANTSEL, 0x00);
 
 			/* Config CCK RX antenna. */
-			write_phy_cck(dev, 0x11, 0xbb); /* Reg11 : bb	*/
-			write_phy_cck(dev, 0x01, 0x47); /* Reg01 : 47	*/
+			write_phy_cck(dev, 0x11, 0xbb); /* Reg11 : bb */
+			write_phy_cck(dev, 0x01, 0x47); /* Reg01 : 47 */
 
 			/* Config OFDM RX antenna. */
-			write_phy_ofdm(dev, 0x0D, 0x54);	/* Reg0d : 54	*/
-			write_phy_ofdm(dev, 0x18, 0x32);	/* Reg18 : 32	*/
-		}	else	{	/* main Antenna */
+			write_phy_ofdm(dev, 0x0D, 0x54);	/* Reg0d : 54 */
+			write_phy_ofdm(dev, 0x18, 0x32);	/* Reg18 : 32 */
+		} else { /* main Antenna */
 			/* Mac register, main antenna */
 			write_nic_byte(dev, ANTSEL, 0x03);
 
@@ -502,9 +501,9 @@ SetAntennaConfig87SE(
 			write_phy_cck(dev, 0x11, 0x9b); /* Reg11 : 9b */
 			write_phy_cck(dev, 0x01, 0x47); /* Reg01 : 47 */
 
-			/* Config OFDM RX antenna.		*/
-			write_phy_ofdm(dev, 0x0D, 0x5c);	/* Reg0d : 5c	*/
-			write_phy_ofdm(dev, 0x18, 0x32);	/*Reg18 : 32	*/
+			/* Config OFDM RX antenna. */
+			write_phy_ofdm(dev, 0x0D, 0x5c); /* Reg0d : 5c */
+			write_phy_ofdm(dev, 0x18, 0x32); /*Reg18 : 32 */
 		}
 	}
 	priv->CurrAntennaIndex = DefaultAnt; /* Update default settings. */
@@ -539,140 +538,128 @@ ZEBRA_Config_85BASIC_HardCode(
 
 
 	/* Page1 : reg16-reg30 */
-	RF_WriteReg(dev, 0x00, 0x013f);			mdelay(1); /* switch to page1 */
-	u4bRF23 = RF_ReadReg(dev, 0x08);			mdelay(1);
-	u4bRF24 = RF_ReadReg(dev, 0x09);			mdelay(1);
+	RF_WriteReg(dev, 0x00, 0x013f);		mdelay(1); /* switch to page1 */
+	u4bRF23 = RF_ReadReg(dev, 0x08);	mdelay(1);
+	u4bRF24 = RF_ReadReg(dev, 0x09);	mdelay(1);
 
 	if (u4bRF23 == 0x818 && u4bRF24 == 0x70C) {
 		d_cut = 1;
 		printk(KERN_INFO "rtl8187se: card type changed from C- to D-cut\n");
 	}
 
-	/* Page0 : reg0-reg15	*/
-
-	RF_WriteReg(dev, 0x00, 0x009f);			mdelay(1);/* 1	*/
-
-	RF_WriteReg(dev, 0x01, 0x06e0);			mdelay(1);
-
-	RF_WriteReg(dev, 0x02, 0x004d);			mdelay(1);/* 2	*/
-
-	RF_WriteReg(dev, 0x03, 0x07f1);			mdelay(1);/* 3	*/
-
-	RF_WriteReg(dev, 0x04, 0x0975);			mdelay(1);
-	RF_WriteReg(dev, 0x05, 0x0c72);			mdelay(1);
-	RF_WriteReg(dev, 0x06, 0x0ae6);			mdelay(1);
-	RF_WriteReg(dev, 0x07, 0x00ca);			mdelay(1);
-	RF_WriteReg(dev, 0x08, 0x0e1c);			mdelay(1);
-	RF_WriteReg(dev, 0x09, 0x02f0);			mdelay(1);
-	RF_WriteReg(dev, 0x0a, 0x09d0);			mdelay(1);
-	RF_WriteReg(dev, 0x0b, 0x01ba);			mdelay(1);
-	RF_WriteReg(dev, 0x0c, 0x0640);			mdelay(1);
-	RF_WriteReg(dev, 0x0d, 0x08df);			mdelay(1);
-	RF_WriteReg(dev, 0x0e, 0x0020);			mdelay(1);
-	RF_WriteReg(dev, 0x0f, 0x0990);			mdelay(1);
-
+	/* Page0 : reg0-reg15 */
+
+	RF_WriteReg(dev, 0x00, 0x009f);		mdelay(1);/* 1	*/
+	RF_WriteReg(dev, 0x01, 0x06e0);		mdelay(1);
+	RF_WriteReg(dev, 0x02, 0x004d);		mdelay(1);/* 2	*/
+	RF_WriteReg(dev, 0x03, 0x07f1);		mdelay(1);/* 3	*/
+	RF_WriteReg(dev, 0x04, 0x0975);		mdelay(1);
+	RF_WriteReg(dev, 0x05, 0x0c72);		mdelay(1);
+	RF_WriteReg(dev, 0x06, 0x0ae6);		mdelay(1);
+	RF_WriteReg(dev, 0x07, 0x00ca);		mdelay(1);
+	RF_WriteReg(dev, 0x08, 0x0e1c);		mdelay(1);
+	RF_WriteReg(dev, 0x09, 0x02f0);		mdelay(1);
+	RF_WriteReg(dev, 0x0a, 0x09d0);		mdelay(1);
+	RF_WriteReg(dev, 0x0b, 0x01ba);		mdelay(1);
+	RF_WriteReg(dev, 0x0c, 0x0640);		mdelay(1);
+	RF_WriteReg(dev, 0x0d, 0x08df);		mdelay(1);
+	RF_WriteReg(dev, 0x0e, 0x0020);		mdelay(1);
+	RF_WriteReg(dev, 0x0f, 0x0990);		mdelay(1);
 
 	/*  Page1 : reg16-reg30 */
-	RF_WriteReg(dev, 0x00, 0x013f);			mdelay(1);
-
-	RF_WriteReg(dev, 0x03, 0x0806);			mdelay(1);
-
-	RF_WriteReg(dev, 0x04, 0x03a7);			mdelay(1);
-	RF_WriteReg(dev, 0x05, 0x059b);			mdelay(1);
-	RF_WriteReg(dev, 0x06, 0x0081);			mdelay(1);
-
-
-	RF_WriteReg(dev, 0x07, 0x01A0);			mdelay(1);
+	RF_WriteReg(dev, 0x00, 0x013f);		mdelay(1);
+	RF_WriteReg(dev, 0x03, 0x0806);		mdelay(1);
+	RF_WriteReg(dev, 0x04, 0x03a7);		mdelay(1);
+	RF_WriteReg(dev, 0x05, 0x059b);		mdelay(1);
+	RF_WriteReg(dev, 0x06, 0x0081);		mdelay(1);
+	RF_WriteReg(dev, 0x07, 0x01A0);		mdelay(1);
 /* Don't write RF23/RF24 to make a difference between 87S C cut and D cut. asked by SD3 stevenl. */
-	RF_WriteReg(dev, 0x0a, 0x0001);			mdelay(1);
-	RF_WriteReg(dev, 0x0b, 0x0418);			mdelay(1);
+	RF_WriteReg(dev, 0x0a, 0x0001);		mdelay(1);
+	RF_WriteReg(dev, 0x0b, 0x0418);		mdelay(1);
 
 	if (d_cut) {
-		RF_WriteReg(dev, 0x0c, 0x0fbe);			mdelay(1);
-		RF_WriteReg(dev, 0x0d, 0x0008);			mdelay(1);
-		RF_WriteReg(dev, 0x0e, 0x0807);			mdelay(1); /* RX LO buffer */
-	}	else	{
-		RF_WriteReg(dev, 0x0c, 0x0fbe);			mdelay(1);
-		RF_WriteReg(dev, 0x0d, 0x0008);			mdelay(1);
-		RF_WriteReg(dev, 0x0e, 0x0806);			mdelay(1); /* RX LO buffer */
+		RF_WriteReg(dev, 0x0c, 0x0fbe);		mdelay(1);
+		RF_WriteReg(dev, 0x0d, 0x0008);		mdelay(1);
+		RF_WriteReg(dev, 0x0e, 0x0807);		mdelay(1); /* RX LO buffer */
+	} else {
+		RF_WriteReg(dev, 0x0c, 0x0fbe);		mdelay(1);
+		RF_WriteReg(dev, 0x0d, 0x0008);		mdelay(1);
+		RF_WriteReg(dev, 0x0e, 0x0806);		mdelay(1); /* RX LO buffer */
 	}
 
-	RF_WriteReg(dev, 0x0f, 0x0acc);			mdelay(1);
-
-	RF_WriteReg(dev, 0x00, 0x01d7);			mdelay(1); /* 6 */
+	RF_WriteReg(dev, 0x0f, 0x0acc);		mdelay(1);
+	RF_WriteReg(dev, 0x00, 0x01d7);		mdelay(1); /* 6 */
+	RF_WriteReg(dev, 0x03, 0x0e00);		mdelay(1);
+	RF_WriteReg(dev, 0x04, 0x0e50);		mdelay(1);
 
-	RF_WriteReg(dev, 0x03, 0x0e00);			mdelay(1);
-	RF_WriteReg(dev, 0x04, 0x0e50);			mdelay(1);
-	for (i = 0; i <= 36; i++)	{
-		RF_WriteReg(dev, 0x01, i);                     mdelay(1);
+	for (i = 0; i <= 36; i++) {
+		RF_WriteReg(dev, 0x01, i);		mdelay(1);
 		RF_WriteReg(dev, 0x02, ZEBRA_RF_RX_GAIN_TABLE[i]); mdelay(1);
 	}
 
-	RF_WriteReg(dev, 0x05, 0x0203);			mdelay(1);	/* 203, 343	*/
-	RF_WriteReg(dev, 0x06, 0x0200);			mdelay(1);	/* 400		*/
+	RF_WriteReg(dev, 0x05, 0x0203);		mdelay(1); /* 203, 343 */
+	RF_WriteReg(dev, 0x06, 0x0200);		mdelay(1); /* 400 */
+	RF_WriteReg(dev, 0x00, 0x0137);		mdelay(1); /* switch to reg16-reg30, and HSSI disable 137 */
+	mdelay(10); /* Deay 10 ms. */		/* 0xfd */
 
-	RF_WriteReg(dev, 0x00, 0x0137);			mdelay(1);	/* switch to reg16-reg30, and HSSI disable 137	*/
-	mdelay(10);		/* Deay 10 ms.	*/	/* 0xfd */
+	RF_WriteReg(dev, 0x0d, 0x0008);		mdelay(1); /* Z4 synthesizer loop filter setting, 392 */
+	mdelay(10); /* Deay 10 ms. */		/* 0xfd */
 
-	RF_WriteReg(dev, 0x0d, 0x0008);			mdelay(1);	/* Z4 synthesizer loop filter setting, 392		*/
-	mdelay(10);		/* Deay 10 ms.	*/	/* 0xfd */
+	RF_WriteReg(dev, 0x00, 0x0037);		mdelay(1); /* switch to reg0-reg15, and HSSI disable */
+	mdelay(10); /* Deay 10 ms. */		/* 0xfd	*/
 
-	RF_WriteReg(dev, 0x00, 0x0037);			mdelay(1);	/* switch to reg0-reg15, and HSSI disable		*/
-	mdelay(10);		/* Deay 10 ms.	*/	/* 0xfd	*/
+	RF_WriteReg(dev, 0x04, 0x0160);		mdelay(1); /* CBC on, Tx Rx disable, High gain */
+	mdelay(10); /* Deay 10 ms. */		/* 0xfd	*/
 
-	RF_WriteReg(dev, 0x04, 0x0160);			mdelay(1);	/* CBC on, Tx Rx disable, High gain				*/
-	mdelay(10);		/* Deay 10 ms.	*/	/* 0xfd	*/
+	RF_WriteReg(dev, 0x07, 0x0080);		mdelay(1); /* Z4 setted channel 1 */
+	mdelay(10); /* Deay 10 ms. */		/* 0xfd	*/
 
-	RF_WriteReg(dev, 0x07, 0x0080);			mdelay(1);	/* Z4 setted channel 1							*/
-	mdelay(10);		/* Deay 10 ms.	*/	/* 0xfd	*/
+	RF_WriteReg(dev, 0x02, 0x088D);		mdelay(1); /* LC calibration */
+	mdelay(200); /* Deay 200 ms. */		/* 0xfd	*/
+	mdelay(10);  /* Deay 10 ms. */		/* 0xfd	*/
+	mdelay(10);  /* Deay 10 ms. */		/* 0xfd	*/
 
-	RF_WriteReg(dev, 0x02, 0x088D);			mdelay(1);	/* LC calibration								*/
-	mdelay(200);	/* Deay 200 ms.	*/	/* 0xfd	*/
-	mdelay(10);		/* Deay 10 ms.	*/	/* 0xfd	*/
-	mdelay(10);		/* Deay 10 ms.	*/	/* 0xfd	*/
+	RF_WriteReg(dev, 0x00, 0x0137);		mdelay(1); /* switch to reg16-reg30 137, and HSSI disable 137 */
+	mdelay(10); /* Deay 10 ms. */		/* 0xfd	*/
 
-	RF_WriteReg(dev, 0x00, 0x0137);			mdelay(1);	/* switch to reg16-reg30 137, and HSSI disable 137	*/
-	mdelay(10);		/* Deay 10 ms.	*/	/* 0xfd	*/
-
-	RF_WriteReg(dev, 0x07, 0x0000);			mdelay(1);
-	RF_WriteReg(dev, 0x07, 0x0180);			mdelay(1);
-	RF_WriteReg(dev, 0x07, 0x0220);			mdelay(1);
-	RF_WriteReg(dev, 0x07, 0x03E0);			mdelay(1);
+	RF_WriteReg(dev, 0x07, 0x0000);		mdelay(1);
+	RF_WriteReg(dev, 0x07, 0x0180);		mdelay(1);
+	RF_WriteReg(dev, 0x07, 0x0220);		mdelay(1);
+	RF_WriteReg(dev, 0x07, 0x03E0);		mdelay(1);
 
 	/* DAC calibration off 20070702	*/
-	RF_WriteReg(dev, 0x06, 0x00c1);			mdelay(1);
-	RF_WriteReg(dev, 0x0a, 0x0001);			mdelay(1);
+	RF_WriteReg(dev, 0x06, 0x00c1);		mdelay(1);
+	RF_WriteReg(dev, 0x0a, 0x0001);		mdelay(1);
 /* {by amy 080312 */
 	/* For crystal calibration, added by Roger, 2007.12.11. */
-	if (priv->bXtalCalibration)	{	/* reg 30.	*/
+	if (priv->bXtalCalibration) { /* reg 30.	*/
 	 /* enable crystal calibration.
 			RF Reg[30], (1)Xin:[12:9], Xout:[8:5],  addr[4:0].
 			(2)PA Pwr delay timer[15:14], default: 2.4us, set BIT15=0
 			(3)RF signal on/off when calibration[13], default: on, set BIT13=0.
-			So we should minus 4 BITs offset.		*/
-		RF_WriteReg(dev, 0x0f, (priv->XtalCal_Xin<<5) | (priv->XtalCal_Xout<<1) | BIT11 | BIT9);			mdelay(1);
+			So we should minus 4 BITs offset. */
+		RF_WriteReg(dev, 0x0f, (priv->XtalCal_Xin<<5) | (priv->XtalCal_Xout<<1) | BIT11 | BIT9); mdelay(1);
 		printk("ZEBRA_Config_85BASIC_HardCode(): (%02x)\n",
-				(priv->XtalCal_Xin<<5) | (priv->XtalCal_Xout<<1) | BIT11 | BIT9);
-	}	else	{
+		      (priv->XtalCal_Xin<<5) | (priv->XtalCal_Xout<<1) | BIT11 | BIT9);
+	} else {
 		/* using default value. Xin=6, Xout=6.	*/
-		RF_WriteReg(dev, 0x0f, 0x0acc);			mdelay(1);
+		RF_WriteReg(dev, 0x0f, 0x0acc);		mdelay(1);
 	}
 /* by amy 080312 */
 
-	RF_WriteReg(dev, 0x00, 0x00bf);			mdelay(1); /* switch to reg0-reg15, and HSSI enable	*/
-	RF_WriteReg(dev, 0x0d, 0x08df);			mdelay(1); /* Rx BB start calibration, 00c//+edward	*/
-	RF_WriteReg(dev, 0x02, 0x004d);			mdelay(1); /* temperature meter off					*/
-	RF_WriteReg(dev, 0x04, 0x0975);			mdelay(1); /* Rx mode								*/
+	RF_WriteReg(dev, 0x00, 0x00bf);		mdelay(1); /* switch to reg0-reg15, and HSSI enable */
+	RF_WriteReg(dev, 0x0d, 0x08df);		mdelay(1); /* Rx BB start calibration, 00c//+edward */
+	RF_WriteReg(dev, 0x02, 0x004d);		mdelay(1); /* temperature meter off */
+	RF_WriteReg(dev, 0x04, 0x0975);		mdelay(1); /* Rx mode */
 	mdelay(10);	/* Deay 10 ms.*/	/* 0xfe	*/
 	mdelay(10);	/* Deay 10 ms.*/	/* 0xfe	*/
 	mdelay(10);	/* Deay 10 ms.*/	/* 0xfe	*/
-	RF_WriteReg(dev, 0x00, 0x0197);			mdelay(1); /* Rx mode*/	/*+edward	*/
-	RF_WriteReg(dev, 0x05, 0x05ab);			mdelay(1); /* Rx mode*/	/*+edward	*/
-	RF_WriteReg(dev, 0x00, 0x009f);			mdelay(1); /* Rx mode*/	/*+edward	*/
-
-	RF_WriteReg(dev, 0x01, 0x0000);			mdelay(1); /* Rx mode*/	/*+edward	*/
-	RF_WriteReg(dev, 0x02, 0x0000);			mdelay(1); /* Rx mode*/	/*+edward	*/
-	/* power save parameters.	*/
+	RF_WriteReg(dev, 0x00, 0x0197);		mdelay(1); /* Rx mode*/	/*+edward */
+	RF_WriteReg(dev, 0x05, 0x05ab);		mdelay(1); /* Rx mode*/	/*+edward */
+	RF_WriteReg(dev, 0x00, 0x009f);		mdelay(1); /* Rx mode*/	/*+edward */
+	RF_WriteReg(dev, 0x01, 0x0000);		mdelay(1); /* Rx mode*/	/*+edward */
+	RF_WriteReg(dev, 0x02, 0x0000);		mdelay(1); /* Rx mode*/	/*+edward */
+	/* power save parameters. */
 	u1b24E = read_nic_byte(dev, 0x24E);
 	write_nic_byte(dev, 0x24E, (u1b24E & (~(BIT5|BIT6))));
 
@@ -697,7 +684,7 @@ ZEBRA_Config_85BASIC_HardCode(
 	write_phy_cck(dev, 0x2f, 0x06);
 	write_phy_cck(dev, 0x01, 0x46);
 
-	/* power control	*/
+	/* power control */
 	write_nic_byte(dev, CCK_TXAGC, 0x10);
 	write_nic_byte(dev, OFDM_TXAGC, 0x1B);
 	write_nic_byte(dev, ANTSEL, 0x03);
@@ -712,7 +699,7 @@ ZEBRA_Config_85BASIC_HardCode(
 
 	write_phy_ofdm(dev, 0x00, 0x12);
 
-	for (i = 0; i < 128; i++)	{
+	for (i = 0; i < 128; i++) {
 
 		data = ZEBRA_AGC[i+1];
 		data = data << 8;
@@ -737,14 +724,14 @@ ZEBRA_Config_85BASIC_HardCode(
 	=============================================================================
 	*/
 
-	for (i = 0; i < 60; i++)	{
+	for (i = 0; i < 60; i++) {
 		u4bRegOffset = i;
 		u4bRegValue = OFDM_CONFIG[i];
 
 		WriteBBPortUchar(dev,
-						(0x00000080 |
-						(u4bRegOffset & 0x7f) |
-						((u4bRegValue & 0xff) << 8)));
+				(0x00000080 |
+				(u4bRegOffset & 0x7f) |
+				((u4bRegValue & 0xff) << 8)));
 	}
 
 	/*
@@ -768,7 +755,7 @@ UpdateInitialGain(
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 
 	/* lzm add 080826 */
-	if (priv->eRFPowerState != eRfOn)	{
+	if (priv->eRFPowerState != eRfOn) {
 		/*	Don't access BB/RF under disable PLL situation.
 			RT_TRACE(COMP_DIG, DBG_LOUD, ("UpdateInitialGain - pHalData->eRFPowerState!=eRfOn\n"));
 			Back to the original state
@@ -826,7 +813,7 @@ UpdateInitialGain(
 		write_phy_ofdm(dev, 0x05, 0xfc);	mdelay(1);
 		break;
 
-	default:	/* MP */
+	default: /* MP */
 		write_phy_ofdm(dev, 0x17, 0x26);	mdelay(1);
 		write_phy_ofdm(dev, 0x24, 0x86);	mdelay(1);
 		write_phy_ofdm(dev, 0x05, 0xfa);	mdelay(1);
@@ -863,7 +850,7 @@ PhyConfig8185(
 	ZEBRA_Config_85BASIC_HardCode(dev);
 /* {by amy 080312 */
 	/* Set default initial gain state to 4, approved by SD3 DZ, by Bruce, 2007-06-06. */
-	if (priv->bDigMechanism)	{
+	if (priv->bDigMechanism) {
 		if (priv->InitialGain == 0)
 			priv->InitialGain = 4;
 	}
@@ -889,11 +876,11 @@ HwConfigureRTL8185(
 		)
 {
 	/* RTL8185_TODO: Determine Retrylimit, TxAGC, AutoRateFallback control. */
-	u8		bUNIVERSAL_CONTROL_RL = 0;
-	u8		bUNIVERSAL_CONTROL_AGC = 1;
-	u8		bUNIVERSAL_CONTROL_ANT = 1;
-	u8		bAUTO_RATE_FALLBACK_CTL = 1;
-	u8		val8;
+	u8 bUNIVERSAL_CONTROL_RL = 0;
+	u8 bUNIVERSAL_CONTROL_AGC = 1;
+	u8 bUNIVERSAL_CONTROL_ANT = 1;
+	u8 bAUTO_RATE_FALLBACK_CTL = 1;
+	u8 val8;
 	write_nic_word(dev, BRSR, 0x0fff);
 	/* Retry limit */
 	val8 = read_nic_byte(dev, CW_CONF);
@@ -907,24 +894,24 @@ HwConfigureRTL8185(
 
 	/* Tx AGC */
 	val8 = read_nic_byte(dev, TXAGC_CTL);
-	if (bUNIVERSAL_CONTROL_AGC)	{
+	if (bUNIVERSAL_CONTROL_AGC) {
 		write_nic_byte(dev, CCK_TXAGC, 128);
 		write_nic_byte(dev, OFDM_TXAGC, 128);
 		val8 = val8 & 0xfe;
-	}	else	{
+	} else {
 		val8 = val8 | 0x01 ;
 	}
 
 
 	write_nic_byte(dev, TXAGC_CTL, val8);
 
-	/* Tx Antenna including Feedback control	*/
+	/* Tx Antenna including Feedback control */
 	val8 = read_nic_byte(dev, TXAGC_CTL);
 
-	if (bUNIVERSAL_CONTROL_ANT)	{
+	if (bUNIVERSAL_CONTROL_ANT) {
 		write_nic_byte(dev, ANTSEL, 0x00);
 		val8 = val8 & 0xfd;
-	}	else	{
+	} else {
 		val8 = val8 & (val8|0x02); /* xiong-2006-11-15 */
 	}
 
@@ -933,7 +920,7 @@ HwConfigureRTL8185(
 	/* Auto Rate fallback control	*/
 	val8 = read_nic_byte(dev, RATE_FALLBACK);
 	val8 &= 0x7c;
-	if (bAUTO_RATE_FALLBACK_CTL)	{
+	if (bAUTO_RATE_FALLBACK_CTL) {
 		val8 |= RATE_FALLBACK_CTL_ENABLE | RATE_FALLBACK_CTL_AUTO_STEP1;
 
 		/* <RJ_TODO_8185B> We shall set up the ARFR according to user's setting. */
@@ -951,22 +938,20 @@ MacConfig_85BASIC_HardCode(
 	MACREG.TXT
 	============================================================================
 	*/
-	int			nLinesRead = 0;
-
-	u32	u4bRegOffset, u4bRegValue, u4bPageIndex = 0;
-	int	i;
+	int nLinesRead = 0;
+	u32 u4bRegOffset, u4bRegValue, u4bPageIndex = 0;
+	int i;
 
 	nLinesRead = sizeof(MAC_REG_TABLE)/2;
 
-	for (i = 0; i < nLinesRead; i++)	{	/* nLinesRead=101 */
+	for (i = 0; i < nLinesRead; i++) { /* nLinesRead=101 */
 		u4bRegOffset = MAC_REG_TABLE[i][0];
 		u4bRegValue = MAC_REG_TABLE[i][1];
 
 				if (u4bRegOffset == 0x5e)
 					u4bPageIndex = u4bRegValue;
-
 				else
-						u4bRegOffset |= (u4bPageIndex << 8);
+					u4bRegOffset |= (u4bPageIndex << 8);
 
 		write_nic_byte(dev, u4bRegOffset, (u8)u4bRegValue);
 	}
@@ -994,18 +979,18 @@ MacConfig_85BASIC(
 	PlatformIOWrite4Byte(dev, 0x1F4, 0x00000000);
 	PlatformIOWrite1Byte(dev, 0x1F8, 0x00);
 
-	/* Asked for by SD3 CM Lin, 2006.06.27, by rcnjko.	*/
-	/* power save parameter based on "87SE power save parameters 20071127.doc", as follow.	*/
+	/* Asked for by SD3 CM Lin, 2006.06.27, by rcnjko. */
+	/* power save parameter based on "87SE power save parameters 20071127.doc", as follow. */
 
 	/* Enable DA10 TX power saving */
 	u1DA = read_nic_byte(dev, PHYPR);
 	write_nic_byte(dev, PHYPR, (u1DA | BIT2));
 
-	/* POWER:	*/
+	/* POWER: */
 	write_nic_word(dev, 0x360, 0x1000);
 	write_nic_word(dev, 0x362, 0x1000);
 
-	/* AFE.		*/
+	/* AFE. */
 	write_nic_word(dev, 0x370, 0x0560);
 	write_nic_word(dev, 0x372, 0x0560);
 	write_nic_word(dev, 0x374, 0x0DA4);
@@ -1013,7 +998,7 @@ MacConfig_85BASIC(
 	write_nic_word(dev, 0x378, 0x0560);
 	write_nic_word(dev, 0x37A, 0x0560);
 	write_nic_word(dev, 0x37C, 0x00EC);
-	write_nic_word(dev, 0x37E, 0x00EC);	/*+edward	*/
+	write_nic_word(dev, 0x37E, 0x00EC); /* +edward */
 	write_nic_byte(dev, 0x24E, 0x01);
 }
 
@@ -1022,7 +1007,7 @@ GetSupportedWirelessMode8185(
 	struct net_device *dev
 )
 {
-	u8			btSupportedWirelessMode = 0;
+	u8 btSupportedWirelessMode = 0;
 
 	btSupportedWirelessMode = (WIRELESS_MODE_B | WIRELESS_MODE_G);
 	return btSupportedWirelessMode;
@@ -1035,12 +1020,12 @@ ActUpdateChannelAccessSetting(
 	PCHANNEL_ACCESS_SETTING	ChnlAccessSetting
 	)
 {
-	struct r8180_priv *priv = ieee80211_priv(dev);
-	struct ieee80211_device *ieee = priv->ieee80211;
+	struct		r8180_priv *priv = ieee80211_priv(dev);
+	struct		ieee80211_device *ieee = priv->ieee80211;
 	AC_CODING	eACI;
 	AC_PARAM	AcParam;
-	u8	bFollowLegacySetting = 0;
-	u8   u1bAIFS;
+	u8		bFollowLegacySetting = 0;
+	u8		u1bAIFS;
 
 	/*
 		<RJ_TODO_8185B>
@@ -1053,14 +1038,14 @@ ActUpdateChannelAccessSetting(
 		even in nQBss.
 	*/
 	ChnlAccessSetting->SIFS_Timer = 0x22; /* Suggested by Jong, 2005.12.08. */
-	ChnlAccessSetting->DIFS_Timer = 0x1C; /* 2006.06.02, by rcnjko.			*/
-	ChnlAccessSetting->SlotTimeTimer = 9; /* 2006.06.02, by rcnjko.			*/
-	ChnlAccessSetting->EIFS_Timer = 0x5B; /* Suggested by wcchu, it is the default value of EIFS register, 2005.12.08.	*/
-	ChnlAccessSetting->CWminIndex = 3; /* 2006.06.02, by rcnjko.			*/
-	ChnlAccessSetting->CWmaxIndex = 7; /* 2006.06.02, by rcnjko.			*/
+	ChnlAccessSetting->DIFS_Timer = 0x1C; /* 2006.06.02, by rcnjko. */
+	ChnlAccessSetting->SlotTimeTimer = 9; /* 2006.06.02, by rcnjko. */
+	ChnlAccessSetting->EIFS_Timer = 0x5B; /* Suggested by wcchu, it is the default value of EIFS register, 2005.12.08. */
+	ChnlAccessSetting->CWminIndex = 3; /* 2006.06.02, by rcnjko. */
+	ChnlAccessSetting->CWmaxIndex = 7; /* 2006.06.02, by rcnjko. */
 
 	write_nic_byte(dev, SIFS, ChnlAccessSetting->SIFS_Timer);
-	write_nic_byte(dev, SLOT, ChnlAccessSetting->SlotTimeTimer);	/* Rewrited from directly use PlatformEFIOWrite1Byte(), by Annie, 2006-03-29. */
+	write_nic_byte(dev, SLOT, ChnlAccessSetting->SlotTimeTimer); /* Rewrited from directly use PlatformEFIOWrite1Byte(), by Annie, 2006-03-29. */
 
 	u1bAIFS = aSifsTime + (2 * ChnlAccessSetting->SlotTimeTimer);
 
@@ -1074,7 +1059,7 @@ ActUpdateChannelAccessSetting(
 	}
 
 	/* this setting is copied from rtl8187B.  xiong-2006-11-13 */
-	if (bFollowLegacySetting)	{
+	if (bFollowLegacySetting) {
 
 		/*
 			Follow 802.11 seeting to AC parameter, all AC shall use the same parameter.
@@ -1083,8 +1068,8 @@ ActUpdateChannelAccessSetting(
 		AcParam.longData = 0;
 		AcParam.f.AciAifsn.f.AIFSN = 2; /* Follow 802.11 DIFS.	*/
 		AcParam.f.AciAifsn.f.ACM = 0;
-		AcParam.f.Ecw.f.ECWmin = ChnlAccessSetting->CWminIndex; /*	Follow 802.11 CWmin.	*/
-		AcParam.f.Ecw.f.ECWmax = ChnlAccessSetting->CWmaxIndex; /*	Follow 802.11 CWmax.	*/
+		AcParam.f.Ecw.f.ECWmin = ChnlAccessSetting->CWminIndex; /* Follow 802.11 CWmin. */
+		AcParam.f.Ecw.f.ECWmax = ChnlAccessSetting->CWmaxIndex; /* Follow 802.11 CWmax. */
 		AcParam.f.TXOPLimit = 0;
 
 		/* lzm reserved 080826 */
@@ -1095,7 +1080,7 @@ ActUpdateChannelAccessSetting(
 		if (ieee->iw_mode == IW_MODE_ADHOC)
 			AcParam.f.TXOPLimit = 0x0020;
 
-		for (eACI = 0; eACI < AC_MAX; eACI++)	{
+		for (eACI = 0; eACI < AC_MAX; eACI++) {
 			AcParam.f.AciAifsn.f.ACI = (u8)eACI;
 			{
 				PAC_PARAM	pAcParam = (PAC_PARAM)(&AcParam);
@@ -1111,7 +1096,7 @@ ActUpdateChannelAccessSetting(
 						(((u32)(pAcParam->f.Ecw.f.ECWmin)) << AC_PARAM_ECW_MIN_OFFSET)	|
 						(((u32)u1bAIFS) << AC_PARAM_AIFS_OFFSET));
 
-				switch (eACI)	{
+				switch (eACI) {
 				case AC1_BK:
 					/* write_nic_dword(dev, AC_BK_PARAM, u4bAcParam); */
 					break;
@@ -1133,47 +1118,47 @@ ActUpdateChannelAccessSetting(
 					break;
 				}
 
-				/* Cehck ACM bit.	*/
+				/* Cehck ACM bit. */
 				/* If it is set, immediately set ACM control bit to downgrading AC for passing WMM testplan. Annie, 2005-12-13.	*/
 				{
 					PACI_AIFSN	pAciAifsn = (PACI_AIFSN)(&pAcParam->f.AciAifsn);
 					AC_CODING	eACI = pAciAifsn->f.ACI;
 
-					/*modified Joseph				*/
-					/*for 8187B AsynIORead issue	*/
+					/*modified Joseph */
+					/*for 8187B AsynIORead issue */
 					u8	AcmCtrl = 0;
-					if (pAciAifsn->f.ACM)	{
+					if (pAciAifsn->f.ACM) {
 						/* ACM bit is 1. */
-						switch (eACI)	{
+						switch (eACI) {
 						case AC0_BE:
-							AcmCtrl |= (BEQ_ACM_EN|BEQ_ACM_CTL|ACM_HW_EN);	/* or 0x21 */
+							AcmCtrl |= (BEQ_ACM_EN|BEQ_ACM_CTL|ACM_HW_EN); /* or 0x21 */
 							break;
 
 						case AC2_VI:
-							AcmCtrl |= (VIQ_ACM_EN|VIQ_ACM_CTL|ACM_HW_EN);	/* or 0x42	*/
+							AcmCtrl |= (VIQ_ACM_EN|VIQ_ACM_CTL|ACM_HW_EN); /* or 0x42 */
 							break;
 
 						case AC3_VO:
-							AcmCtrl |= (VOQ_ACM_EN|VOQ_ACM_CTL|ACM_HW_EN);	/* or 0x84 */
+							AcmCtrl |= (VOQ_ACM_EN|VOQ_ACM_CTL|ACM_HW_EN); /* or 0x84 */
 							break;
 
 						default:
 							DMESGW("SetHwReg8185(): [HW_VAR_ACM_CTRL] ACM set failed: eACI is %d\n", eACI);
 							break;
 						}
-					}	else	{
+					} else {
 						/* ACM bit is 0. */
-						switch (eACI)	{
+						switch (eACI) {
 						case AC0_BE:
-							AcmCtrl &= ((~BEQ_ACM_EN) & (~BEQ_ACM_CTL) & (~ACM_HW_EN));	/* and 0xDE */
+							AcmCtrl &= ((~BEQ_ACM_EN) & (~BEQ_ACM_CTL) & (~ACM_HW_EN)); /* and 0xDE */
 							break;
 
 						case AC2_VI:
-							AcmCtrl &= ((~VIQ_ACM_EN) & (~VIQ_ACM_CTL) & (~ACM_HW_EN));	/* and 0xBD */
+							AcmCtrl &= ((~VIQ_ACM_EN) & (~VIQ_ACM_CTL) & (~ACM_HW_EN)); /* and 0xBD */
 							break;
 
 						case AC3_VO:
-							AcmCtrl &= ((~VOQ_ACM_EN) & (~VOQ_ACM_CTL) & (~ACM_HW_EN));	/* and 0x7B */
+							AcmCtrl &= ((~VOQ_ACM_EN) & (~VOQ_ACM_CTL) & (~ACM_HW_EN)); /* and 0x7B */
 							break;
 
 						default:
@@ -1193,30 +1178,30 @@ ActSetWirelessMode8185(
 	u8				btWirelessMode
 	)
 {
-	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
-	struct ieee80211_device *ieee = priv->ieee80211;
+	struct  r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
+	struct  ieee80211_device *ieee = priv->ieee80211;
 	u8	btSupportedWirelessMode = GetSupportedWirelessMode8185(dev);
 
 	if ((btWirelessMode & btSupportedWirelessMode) == 0)	{
-		/* Don't switch to unsupported wireless mode, 2006.02.15, by rcnjko.	*/
+		/* Don't switch to unsupported wireless mode, 2006.02.15, by rcnjko. */
 		DMESGW("ActSetWirelessMode8185(): WirelessMode(%d) is not supported (%d)!\n",
 			btWirelessMode, btSupportedWirelessMode);
 		return;
 	}
 
-	/* 1. Assign wireless mode to swtich if necessary.	*/
-	if (btWirelessMode == WIRELESS_MODE_AUTO)	{
-		if ((btSupportedWirelessMode & WIRELESS_MODE_A))	{
+	/* 1. Assign wireless mode to swtich if necessary. */
+	if (btWirelessMode == WIRELESS_MODE_AUTO) {
+		if ((btSupportedWirelessMode & WIRELESS_MODE_A)) {
 			btWirelessMode = WIRELESS_MODE_A;
-		}	else if (btSupportedWirelessMode & WIRELESS_MODE_G)	{
+		} else if (btSupportedWirelessMode & WIRELESS_MODE_G) {
 				btWirelessMode = WIRELESS_MODE_G;
 
-		}	else if ((btSupportedWirelessMode & WIRELESS_MODE_B))	{
-				btWirelessMode = WIRELESS_MODE_B;
-		}	else	{
-				DMESGW("ActSetWirelessMode8185(): No valid wireless mode supported, btSupportedWirelessMode(%x)!!!\n",
-						btSupportedWirelessMode);
+		} else if ((btSupportedWirelessMode & WIRELESS_MODE_B))	{
 				btWirelessMode = WIRELESS_MODE_B;
+		} else {
+			DMESGW("ActSetWirelessMode8185(): No valid wireless mode supported, btSupportedWirelessMode(%x)!!!\n",
+			       btSupportedWirelessMode);
+			btWirelessMode = WIRELESS_MODE_B;
 		}
 	}
 
@@ -1227,13 +1212,13 @@ ActSetWirelessMode8185(
 
 	ieee->mode = (WIRELESS_MODE)btWirelessMode;
 
-	/* 3. Change related setting.	*/
-	if( ieee->mode == WIRELESS_MODE_A )	{
+	/* 3. Change related setting. */
+	if( ieee->mode == WIRELESS_MODE_A ) {
 		DMESG("WIRELESS_MODE_A\n");
-	}	else if( ieee->mode == WIRELESS_MODE_B )	{
-			DMESG("WIRELESS_MODE_B\n");
-	}	else if( ieee->mode == WIRELESS_MODE_G )	{
-			DMESG("WIRELESS_MODE_G\n");
+	} else if( ieee->mode == WIRELESS_MODE_B ) {
+		DMESG("WIRELESS_MODE_B\n");
+	} else if( ieee->mode == WIRELESS_MODE_G ) {
+		DMESG("WIRELESS_MODE_G\n");
 	}
 	ActUpdateChannelAccessSetting( dev, ieee->mode, &priv->ChannelAccessSetting);
 }
@@ -1260,7 +1245,7 @@ MgntDisconnectIBSS(
 )
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
-	u8			i;
+	u8 i;
 
 	DrvIFIndicateDisassociation(dev, unspec_reason);
 
@@ -1295,19 +1280,16 @@ MlmeDisassociateRequest(
 
 	SendDisassociation(priv->ieee80211, asSta, asRsn);
 
-	if (memcmp(priv->ieee80211->current_network.bssid, asSta, 6) == 0)	{
-		/*ShuChen TODO: change media status.			*/
-		/*ShuChen TODO: What to do when disassociate.	*/
+	if (memcmp(priv->ieee80211->current_network.bssid, asSta, 6) == 0) {
+		/* ShuChen TODO: change media status. */
+		/* ShuChen TODO: What to do when disassociate. */
 		DrvIFIndicateDisassociation(dev, unspec_reason);
 
-
-
 		for (i = 0; i < 6; i++)
 			priv->ieee80211->current_network.bssid[i] = 0x22;
 
 		ieee80211_disassociate(priv->ieee80211);
 	}
-
 }
 
 void
@@ -1343,17 +1325,17 @@ MgntDisconnect(
 
 	if (IS_DOT11D_ENABLE(priv->ieee80211))
 		Dot11d_Reset(priv->ieee80211);
-	/* In adhoc mode, update beacon frame.	*/
+	/* In adhoc mode, update beacon frame. */
 	if (priv->ieee80211->state == IEEE80211_LINKED)	{
 		if (priv->ieee80211->iw_mode == IW_MODE_ADHOC)
 			MgntDisconnectIBSS(dev);
 
-		if (priv->ieee80211->iw_mode == IW_MODE_INFRA)	{
+		if (priv->ieee80211->iw_mode == IW_MODE_INFRA) {
 			/*	We clear key here instead of MgntDisconnectAP() because that
 				MgntActSet_802_11_DISASSOCIATE() is an interface called by OS,
 				e.g. OID_802_11_DISASSOCIATE in Windows while as MgntDisconnectAP() is
 				used to handle disassociation related things to AP, e.g. send Disassoc
-				frame to AP.  2005.01.27, by rcnjko.	*/
+				frame to AP.  2005.01.27, by rcnjko. */
 			MgntDisconnectAP(dev, asRsn);
 		}
 		/* Inidicate Disconnect, 2005.02.23, by rcnjko.	*/
@@ -1374,13 +1356,13 @@ SetRFPowerState(
 	RT_RF_POWER_STATE	eRFPowerState
 	)
 {
-	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
-	bool			bResult = false;
+	struct	r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
+	bool	bResult = false;
 
 	if (eRFPowerState == priv->eRFPowerState)
 		return bResult;
 
-	 bResult = SetZebraRFPowerState8185(dev, eRFPowerState);
+	bResult = SetZebraRFPowerState8185(dev, eRFPowerState);
 
 	return bResult;
 }
@@ -1404,11 +1386,11 @@ MgntActSet_RF_State(
 	u32	ChangeSource
 	)
 {
-	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
-	bool				bActionAllowed = false;
-	bool				bConnectBySSID = false;
-	RT_RF_POWER_STATE	rtState;
-	u16				RFWaitCounter = 0;
+	struct	r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
+	bool	bActionAllowed = false;
+	bool	bConnectBySSID = false;
+	RT_RF_POWER_STATE rtState;
+	u16	RFWaitCounter = 0;
 	unsigned long flag;
 	/*
 		Prevent the race condition of RF state change. By Bruce, 2007-11-28.
@@ -1416,21 +1398,21 @@ MgntActSet_RF_State(
 	*/
 	while (true)	{
 		spin_lock_irqsave(&priv->rf_ps_lock, flag);
-		if (priv->RFChangeInProgress)	{
+		if (priv->RFChangeInProgress) {
 			spin_unlock_irqrestore(&priv->rf_ps_lock, flag);
 			/*  Set RF after the previous action is done.	*/
-			while (priv->RFChangeInProgress)	{
+			while (priv->RFChangeInProgress) {
 				RFWaitCounter++;
 				udelay(1000); /* 1 ms	*/
 
-				/* Wait too long, return FALSE to avoid to be stuck here.	*/
-				if (RFWaitCounter > 1000)	{	/* 1sec	*/
+				/* Wait too long, return FALSE to avoid to be stuck here. */
+				if (RFWaitCounter > 1000) { /* 1sec */
 					printk("MgntActSet_RF_State(): Wait too long to set RF\n");
-					/* TODO: Reset RF state?	*/
+					/* TODO: Reset RF state? */
 					return false;
 				}
 			}
-		}	else	{
+		} else {
 			priv->RFChangeInProgress = true;
 			spin_unlock_irqrestore(&priv->rf_ps_lock, flag);
 			break;
@@ -1438,7 +1420,7 @@ MgntActSet_RF_State(
 	}
 	rtState = priv->eRFPowerState;
 
-	switch (StateToSet)	{
+	switch (StateToSet) {
 	case eRfOn:
 		/*
 			Turn On RF no matter the IPS setting because we need to update the RF state to Ndis under Vista, or
@@ -1453,25 +1435,24 @@ MgntActSet_RF_State(
 			if (rtState == eRfOff && ChangeSource >= RF_CHANGE_BY_HW && !priv->bInHctTest)
 				bConnectBySSID = true;
 
-		}	else
-				;
+		} else
+			;
 		break;
 
 	case eRfOff:
-		 /* 070125, rcnjko: we always keep connected in AP mode.	*/
-
-			if (priv->RfOffReason > RF_CHANGE_BY_IPS)	{
-				/*
-					060808, Annie:
-					Disconnect to current BSS when radio off. Asked by QuanTa.
-
-					Calling MgntDisconnect() instead of MgntActSet_802_11_DISASSOCIATE(),
-					because we do NOT need to set ssid to dummy ones.
-				*/
-				MgntDisconnect(dev, disas_lv_ss);
-
-				/* Clear content of bssDesc[] and bssDesc4Query[] to avoid reporting old bss to UI.	*/
-			}
+		 /* 070125, rcnjko: we always keep connected in AP mode. */
+
+		if (priv->RfOffReason > RF_CHANGE_BY_IPS) {
+			/*
+				060808, Annie:
+				Disconnect to current BSS when radio off. Asked by QuanTa.
+
+				Calling MgntDisconnect() instead of MgntActSet_802_11_DISASSOCIATE(),
+				because we do NOT need to set ssid to dummy ones.
+			*/
+			MgntDisconnect(dev, disas_lv_ss);
+			/* Clear content of bssDesc[] and bssDesc4Query[] to avoid reporting old bss to UI. */
+		}
 
 		priv->RfOffReason |= ChangeSource;
 		bActionAllowed = true;
@@ -1484,14 +1465,14 @@ MgntActSet_RF_State(
 		break;
 	}
 
-	if (bActionAllowed)	{
-				/* Config HW to the specified mode.	*/
+	if (bActionAllowed) {
+		/* Config HW to the specified mode. */
 		SetRFPowerState(dev, StateToSet);
 
 		/* Turn on RF.	*/
-		if (StateToSet == eRfOn)		{
+		if (StateToSet == eRfOn) {
 			HalEnableRx8185Dummy(dev);
-			if (bConnectBySSID)	{
+			if (bConnectBySSID) {
 				/* by amy not supported	*/
 			}
 		}
@@ -1542,7 +1523,7 @@ IPSEnter(
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	RT_RF_POWER_STATE rtState;
-	if (priv->bInactivePs)	{
+	if (priv->bInactivePs) {
 		rtState = priv->eRFPowerState;
 
 		/*
@@ -1554,7 +1535,7 @@ IPSEnter(
 			(5) AP mode (send Beacon)
 		*/
 		if (rtState == eRfOn && !priv->bSwRfProcessing
-			&& (priv->ieee80211->state != IEEE80211_LINKED))	{
+			&& (priv->ieee80211->state != IEEE80211_LINKED)) {
 			priv->eInactivePowerState = eRfOff;
 			InactivePowerSave(dev);
 		}
@@ -1567,9 +1548,9 @@ IPSLeave(
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	RT_RF_POWER_STATE rtState;
-	if (priv->bInactivePs)	{
+	if (priv->bInactivePs) {
 		rtState = priv->eRFPowerState;
-		if ((rtState == eRfOff || rtState == eRfSleep) && (!priv->bSwRfProcessing) && priv->RfOffReason <= RF_CHANGE_BY_IPS)	{
+		if ((rtState == eRfOff || rtState == eRfSleep) && (!priv->bSwRfProcessing) && priv->RfOffReason <= RF_CHANGE_BY_IPS) {
 			priv->eInactivePowerState = eRfOn;
 			InactivePowerSave(dev);
 		}
@@ -1582,8 +1563,8 @@ void rtl8185b_adapter_start(struct net_device *dev)
 	struct ieee80211_device *ieee = priv->ieee80211;
 
 	u8 SupportedWirelessMode;
-	u8			InitWirelessMode;
-	u8			bInvalidWirelessMode = 0;
+	u8 InitWirelessMode;
+	u8 bInvalidWirelessMode = 0;
 	u8 tmpu8;
 	u8 btCR9346;
 	u8 TmpU1b;
@@ -1598,14 +1579,14 @@ void rtl8185b_adapter_start(struct net_device *dev)
 	HwConfigureRTL8185(dev);
 	write_nic_dword(dev, MAC0, ((u32 *)dev->dev_addr)[0]);
 	write_nic_word(dev, MAC4, ((u32 *)dev->dev_addr)[1] & 0xffff);
-	write_nic_byte(dev, MSR, read_nic_byte(dev, MSR) & 0xf3);	/* default network type to 'No	Link'	*/
+	write_nic_byte(dev, MSR, read_nic_byte(dev, MSR) & 0xf3); /* default network type to 'No Link' */
 	write_nic_word(dev, BcnItv, 100);
 	write_nic_word(dev, AtimWnd, 2);
 	PlatformIOWrite2Byte(dev, FEMR, 0xFFFF);
 	write_nic_byte(dev, WPA_CONFIG, 0);
 	MacConfig_85BASIC(dev);
-	/*	Override the RFSW_CTRL (MAC offset 0x272-0x273), 2006.06.07, by rcnjko.	*/
-	/*	BT_DEMO_BOARD type	*/
+	/* Override the RFSW_CTRL (MAC offset 0x272-0x273), 2006.06.07, by rcnjko. */
+	/* BT_DEMO_BOARD type */
 	PlatformIOWrite2Byte(dev, RFSW_CTRL, 0x569a);
 
 	/*
@@ -1613,41 +1594,41 @@ void rtl8185b_adapter_start(struct net_device *dev)
 		Set up PHY related.
 	-----------------------------------------------------------------------------
 	*/
-	/* Enable Config3.PARAM_En to revise AnaaParm.	*/
-	write_nic_byte(dev, CR9346, 0xc0);	/* enable config register write */
+	/* Enable Config3.PARAM_En to revise AnaaParm. */
+	write_nic_byte(dev, CR9346, 0xc0); /* enable config register write */
 	tmpu8 = read_nic_byte(dev, CONFIG3);
 	write_nic_byte(dev, CONFIG3, (tmpu8 | CONFIG3_PARM_En));
-	/* Turn on Analog power.	*/
-	/* Asked for by William, otherwise, MAC 3-wire can't work, 2006.06.27, by rcnjko.	*/
+	/* Turn on Analog power. */
+	/* Asked for by William, otherwise, MAC 3-wire can't work, 2006.06.27, by rcnjko. */
 	write_nic_dword(dev, ANAPARAM2, ANAPARM2_ASIC_ON);
 	write_nic_dword(dev, ANAPARAM, ANAPARM_ASIC_ON);
 	write_nic_word(dev, ANAPARAM3, 0x0010);
 
 	write_nic_byte(dev, CONFIG3, tmpu8);
 	write_nic_byte(dev, CR9346, 0x00);
-	/* enable EEM0 and EEM1 in 9346CR			*/
+	/* enable EEM0 and EEM1 in 9346CR */
 	btCR9346 = read_nic_byte(dev, CR9346);
 	write_nic_byte(dev, CR9346, (btCR9346 | 0xC0));
 
-	/* B cut use LED1 to control HW RF on/off	*/
+	/* B cut use LED1 to control HW RF on/off */
 	TmpU1b = read_nic_byte(dev, CONFIG5);
 	TmpU1b = TmpU1b & ~BIT3;
 	write_nic_byte(dev, CONFIG5, TmpU1b);
 
-	/* disable EEM0 and EEM1 in 9346CR	*/
+	/* disable EEM0 and EEM1 in 9346CR */
 	btCR9346 &= ~(0xC0);
 	write_nic_byte(dev, CR9346, btCR9346);
 
-	/* Enable Led (suggested by Jong)	*/
-	/* B-cut RF Radio on/off  5e[3]=0	*/
+	/* Enable Led (suggested by Jong) */
+	/* B-cut RF Radio on/off  5e[3]=0 */
 	btPSR = read_nic_byte(dev, PSR);
 	write_nic_byte(dev, PSR, (btPSR | BIT3));
-	/* setup initial timing for RFE.	*/
+	/* setup initial timing for RFE. */
 	write_nic_word(dev, RFPinsOutput, 0x0480);
 	SetOutputEnableOfRfPins(dev);
 	write_nic_word(dev, RFPinsSelect, 0x2488);
 
-	/* PHY config.	*/
+	/* PHY config. */
 	PhyConfig8185(dev);
 
 	/*
@@ -1659,28 +1640,28 @@ void rtl8185b_adapter_start(struct net_device *dev)
 	if ((ieee->mode != WIRELESS_MODE_B) &&
 		(ieee->mode != WIRELESS_MODE_G) &&
 		(ieee->mode != WIRELESS_MODE_A) &&
-		(ieee->mode != WIRELESS_MODE_AUTO))	{
-		/* It should be one of B, G, A, or AUTO.	*/
+		(ieee->mode != WIRELESS_MODE_AUTO)) {
+		/* It should be one of B, G, A, or AUTO. */
 		bInvalidWirelessMode = 1;
-	}	else	{
-	/* One of B, G, A, or AUTO.	*/
-		/* Check if the wireless mode is supported by RF.	*/
+	} else {
+	/* One of B, G, A, or AUTO. */
+		/* Check if the wireless mode is supported by RF. */
 		if	((ieee->mode != WIRELESS_MODE_AUTO) &&
-			(ieee->mode & SupportedWirelessMode) == 0)	{
+			(ieee->mode & SupportedWirelessMode) == 0) {
 			bInvalidWirelessMode = 1;
 		}
 	}
 
-	if (bInvalidWirelessMode || ieee->mode == WIRELESS_MODE_AUTO)	{
-		/* Auto or other invalid value.				*/
-		/* Assigne a wireless mode to initialize.	*/
-		if ((SupportedWirelessMode & WIRELESS_MODE_A))	{
+	if (bInvalidWirelessMode || ieee->mode == WIRELESS_MODE_AUTO) {
+		/* Auto or other invalid value. */
+		/* Assigne a wireless mode to initialize. */
+		if ((SupportedWirelessMode & WIRELESS_MODE_A)) {
 			InitWirelessMode = WIRELESS_MODE_A;
-		}	else if ((SupportedWirelessMode & WIRELESS_MODE_G))	{
+		} else if ((SupportedWirelessMode & WIRELESS_MODE_G)) {
 			InitWirelessMode = WIRELESS_MODE_G;
-		}	else if ((SupportedWirelessMode & WIRELESS_MODE_B))	{
+		} else if ((SupportedWirelessMode & WIRELESS_MODE_B)) {
 			InitWirelessMode = WIRELESS_MODE_B;
-		}	else	{
+		} else {
 			DMESGW("InitializeAdapter8185(): No valid wireless mode supported, SupportedWirelessMode(%x)!!!\n",
 				 SupportedWirelessMode);
 			InitWirelessMode = WIRELESS_MODE_B;
@@ -1690,11 +1671,11 @@ void rtl8185b_adapter_start(struct net_device *dev)
 		if (bInvalidWirelessMode)
 			ieee->mode = (WIRELESS_MODE)InitWirelessMode;
 
-	}	else	{
-	/* One of B, G, A.	*/
+	} else {
+	/* One of B, G, A. */
 		InitWirelessMode = ieee->mode;
 	}
-/* by amy for power save	*/
+/* by amy for power save */
 	priv->eRFPowerState = eRfOff;
 	priv->RfOffReason = 0;
 	{
@@ -1706,7 +1687,7 @@ void rtl8185b_adapter_start(struct net_device *dev)
 	if (priv->bInactivePs)
 		MgntActSet_RF_State(dev , eRfOff, RF_CHANGE_BY_IPS);
 
-/* by amy for power save	*/
+/* by amy for power save */
 
 	ActSetWirelessMode8185(dev, (u8)(InitWirelessMode));
 
@@ -1715,7 +1696,7 @@ void rtl8185b_adapter_start(struct net_device *dev)
 	rtl8185b_irq_enable(dev);
 
 	netif_start_queue(dev);
-	}
+}
 
 void rtl8185b_rx_enable(struct net_device *dev)
 {
@@ -1728,7 +1709,7 @@ void rtl8185b_rx_enable(struct net_device *dev)
 		DMESG("NIC in promisc mode");
 
 	if (priv->ieee80211->iw_mode == IW_MODE_MONITOR || \
-	   dev->flags & IFF_PROMISC)	{
+	   dev->flags & IFF_PROMISC) {
 		priv->ReceiveConfig = priv->ReceiveConfig & (~RCR_APM);
 		priv->ReceiveConfig = priv->ReceiveConfig | RCR_AAP;
 	}
-- 
1.7.7.6

