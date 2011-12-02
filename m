Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab1LBCFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 21:05:48 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46696 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861Ab1LBCFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 21:05:47 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.mage@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Forest Bond <forest@alittletooquiet.net>, devel@driverdev.osuosl.org
Subject: [PATCH 4/5] staging: vt6656: channel.c: Remove commented code and fixed issues of comment
Date: Fri,  2 Dec 2011 00:05:18 +0000
Message-Id: <1322784318-19991-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Forest Bond <forest@alittletooquiet.net>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/vt6656/channel.c |   52 ++++++++++---------------------------
 1 files changed, 14 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/vt6656/channel.c b/drivers/staging/vt6656/channel.c
index 954aee7..16fbfcf 100644
--- a/drivers/staging/vt6656/channel.c
+++ b/drivers/staging/vt6656/channel.c
@@ -39,14 +39,7 @@
 #include "channel.h"
 #include "rf.h"
 
-/*---------------------  Static Definitions -------------------------*/
 static int          msglevel                = MSG_LEVEL_INFO;
-//static int          msglevel                =MSG_LEVEL_DEBUG;
-
-/*---------------------  Static Classes  ----------------------------*/
-
-/*---------------------  Export Definitions -------------------------*/
-
 
 static SChannelTblElement sChannelTbl[CB_MAX_CHANNEL+1] =
 {
@@ -111,10 +104,10 @@ static SChannelTblElement sChannelTbl[CB_MAX_CHANNEL+1] =
 
 
 
-/************************************************************************
+/*
  * The Radar regulation rules for each country
- ************************************************************************/
-static  struct
+ */
+ static  struct
 {
     BYTE    byChannelCountryCode;             /* The country code         */
     char    chCountryCode[2];
@@ -122,9 +115,9 @@ static  struct
     BYTE    byPower[CB_MAX_CHANNEL];
 }   ChannelRuleTab[] =
 {
-/************************************************************************
+/*
  * This table is based on Athero driver rules
- ************************************************************************/
+ */
 /* Country          Available channels, ended with 0                    */
 /*                                           1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  */
 {CCODE_FCC,                     {'U','S'},  {   1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  1,  0,  1,  0,  1,  1,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  1,  1,  1}
@@ -370,8 +363,7 @@ static  struct
 
 #define NUM_RULES	ARRAY_SIZE(ChannelRuleTab)
 
-/*---------------------  Export function  -------------------------*/
-/************************************************************************
+/*
  * Country Channel Valid
  *  Input:  CountryCode, ChannelNum
  *          ChanneIndex is defined as VT3253 MAC channel:
@@ -383,12 +375,12 @@ static  struct
  *              16  = 4.9G channel 184
  *              .....
  *  Output: TRUE if the specified 5GHz band is allowed to be used.
-            False otherwise.
-// 4.9G => Ch 183, 184, 185, 187, 188, 189, 192, 196 (Value:15 ~ 22)
-
-// 5G => Ch 7, 8, 9, 11, 12, 16, 34, 36, 38, 40, 42, 44, 46, 48, 52, 56, 60, 64,
-// 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140, 149, 153, 157, 161, 165 (Value 23 ~ 56)
- ************************************************************************/
+ *           False otherwise.
+ * 4.9G => Ch 183, 184, 185, 187, 188, 189, 192, 196 (Value:15 ~ 22)
+ *
+ * 5G => Ch 7, 8, 9, 11, 12, 16, 34, 36, 38, 40, 42, 44, 46, 48, 52, 56, 60, 64,
+ * 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140, 149, 153, 157, 161, 165 (Value 23 ~ 56)
+ */
 BOOL
 ChannelValid(unsigned int CountryCode, unsigned int ChannelIndex)
 {
@@ -403,7 +395,7 @@ ChannelValid(unsigned int CountryCode, unsigned int ChannelIndex)
 
 }
 
-/************************************************************************
+/*
  * CHvChannelGetList
  * Get Available Channel List for a given country
  * Input:
@@ -414,7 +406,7 @@ ChannelValid(unsigned int CountryCode, unsigned int ChannelIndex)
  *                          0x0000000000000001 means channel 1 is supported
  *                          0x0000000000000003 means channel 1,2 are supported
  *                          0x000000000000000F means channel 1,2,..15 are supported
- ************************************************************************/
+ */
 BOOL
 CHvChannelGetList (
       unsigned int       uCountryCodeIdx,
@@ -457,18 +449,12 @@ void CHvInitChannelTable(void *pDeviceHandler)
         if (bMultiBand == TRUE) {
 		for (ii = 0; ii < CB_MAX_CHANNEL; ii++) {
 			sChannelTbl[ii+1].bValid = TRUE;
-                //pDevice->abyRegPwr[ii+1] = pDevice->abyOFDMDefaultPwr[ii+1];
-                //pDevice->abyLocalPwr[ii+1] = pDevice->abyOFDMDefaultPwr[ii+1];
 		}
 		for (ii = 0; ii < CB_MAX_CHANNEL_24G; ii++) {
-                //pDevice->abyRegPwr[ii+1] = pDevice->abyCCKDefaultPwr[ii+1];
-                //pDevice->abyLocalPwr[ii+1] = pDevice->abyCCKDefaultPwr[ii+1];
 		}
         } else {
 		for (ii = 0; ii < CB_MAX_CHANNEL_24G; ii++) {
 			sChannelTbl[ii+1].bValid = TRUE;
-                //pDevice->abyRegPwr[ii+1] = pDevice->abyCCKDefaultPwr[ii+1];
-                //pDevice->abyLocalPwr[ii+1] = pDevice->abyCCKDefaultPwr[ii+1];
 		}
         }
     } else if (pDevice->byZoneType <= CCODE_MAX) {
@@ -476,16 +462,12 @@ void CHvInitChannelTable(void *pDeviceHandler)
 		for (ii = 0; ii < CB_MAX_CHANNEL; ii++) {
 			if (ChannelRuleTab[pDevice->byZoneType].bChannelIdxList[ii] != 0) {
 				sChannelTbl[ii+1].bValid = TRUE;
-                    //pDevice->abyRegPwr[ii+1] = ChannelRuleTab[pDevice->byZoneType].byPower[ii];
-                    //pDevice->abyLocalPwr[ii+1] = ChannelRuleTab[pDevice->byZoneType].byPower[ii];
 			}
 		}
         } else {
 		for (ii = 0; ii < CB_MAX_CHANNEL_24G; ii++) {
 			if (ChannelRuleTab[pDevice->byZoneType].bChannelIdxList[ii] != 0) {
 				sChannelTbl[ii+1].bValid = TRUE;
-                    //pDevice->abyRegPwr[ii+1] = ChannelRuleTab[pDevice->byZoneType].byPower[ii];
-                    //pDevice->abyLocalPwr[ii+1] = ChannelRuleTab[pDevice->byZoneType].byPower[ii];
 			}
 		}
         }
@@ -493,12 +475,6 @@ void CHvInitChannelTable(void *pDeviceHandler)
     DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO"Zone=[%d][%c][%c]!!\n",pDevice->byZoneType,ChannelRuleTab[pDevice->byZoneType].chCountryCode[0],ChannelRuleTab[pDevice->byZoneType].chCountryCode[1]);
     for (ii = 0; ii < CB_MAX_CHANNEL; ii++) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Channel[%d] is [%d]\n",sChannelTbl[ii].byChannelNumber,sChannelTbl[ii+1].bValid);
-        /*if (pDevice->abyRegPwr[ii+1] == 0) {
-            pDevice->abyRegPwr[ii+1] = pDevice->abyOFDMDefaultPwr[ii+1];
-        }
-        if (pDevice->abyLocalPwr[ii+1] == 0) {
-            pDevice->abyLocalPwr[ii+1] = pDevice->abyOFDMDefaultPwr[ii+1];
-        }*/
     }
 }
 
-- 
1.7.4.4

