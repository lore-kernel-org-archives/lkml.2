Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab2K3NBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 08:01:30 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60438 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675Ab2K3NB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 08:01:29 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 2/3] staging/rtl8187se: Fix spacing coding style in ieee80211/dot11d.c
Date: Fri, 30 Nov 2012 22:01:24 +0900
Message-Id: <1354280484-25482-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354280452-25365-1-git-send-email-yamanetoshi@gmail.com>
References: <1354280452-25365-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following errors and warnings fixed.
- WARNING: braces {} are not necessary for single statement blocks
- ERROR: that open brace { should be on the previous line
- ERROR: space required before the open parenthesis '('
- ERROR: space prohibited after that open parenthesis '('

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/rtl8187se/ieee80211/dot11d.c |   57 +++++++++++---------------
 1 file changed, 23 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/dot11d.c b/drivers/staging/rtl8187se/ieee80211/dot11d.c
index 247916b..b61a66d 100644
--- a/drivers/staging/rtl8187se/ieee80211/dot11d.c
+++ b/drivers/staging/rtl8187se/ieee80211/dot11d.c
@@ -39,12 +39,11 @@ Dot11d_Reset(struct ieee80211_device *ieee)
 	memset(pDot11dInfo->channel_map, 0, MAX_CHANNEL_NUMBER+1);
 	memset(pDot11dInfo->MaxTxPwrDbmList, 0xFF, MAX_CHANNEL_NUMBER+1);
 	// Set new channel map
-	for (i = 1; i <= 11; i++) {
+	for (i = 1; i <= 11; i++)
 		(pDot11dInfo->channel_map)[i] = 1;
-	}
-	for (i = 12; i <= 14; i++) {
+
+	for (i = 12; i <= 14; i++)
 		(pDot11dInfo->channel_map)[i] = 2;
-	}
 
 	pDot11dInfo->State = DOT11D_STATE_NONE;
 	pDot11dInfo->CountryIeLen = 0;
@@ -77,8 +76,7 @@ Dot11d_UpdateCountryIe(
 	u8 i, j, NumTriples, MaxChnlNum;
 	PCHNL_TXPOWER_TRIPLE pTriple;
 
-	if((CoutryIeLen - 3)%3 != 0)
-	{
+	if ((CoutryIeLen - 3)%3 != 0) {
 		printk("Dot11d_UpdateCountryIe(): Invalid country IE, skip it........1\n");
 		Dot11d_Reset(dev);
 		return;
@@ -89,23 +87,21 @@ Dot11d_UpdateCountryIe(
 	MaxChnlNum = 0;
 	NumTriples = (CoutryIeLen - 3) / 3; // skip 3-byte country string.
 	pTriple = (PCHNL_TXPOWER_TRIPLE)(pCoutryIe + 3);
-	for(i = 0; i < NumTriples; i++)
-	{
-		if(MaxChnlNum >= pTriple->FirstChnl)
-		{ // It is not in a monotonically increasing order, so stop processing.
+	for (i = 0; i < NumTriples; i++) {
+		if (MaxChnlNum >= pTriple->FirstChnl) {
+		// It is not in a monotonically increasing order, so stop processing.
 			printk("Dot11d_UpdateCountryIe(): Invalid country IE, skip it........1\n");
 			Dot11d_Reset(dev);
 			return;
 		}
-		if(MAX_CHANNEL_NUMBER < (pTriple->FirstChnl + pTriple->NumChnls))
-		{ // It is not a valid set of channel id, so stop processing.
+		if (MAX_CHANNEL_NUMBER < (pTriple->FirstChnl + pTriple->NumChnls)) {
+		// It is not a valid set of channel id, so stop processing.
 			printk("Dot11d_UpdateCountryIe(): Invalid country IE, skip it........2\n");
 			Dot11d_Reset(dev);
 			return;
 		}
 
-		for(j = 0 ; j < pTriple->NumChnls; j++)
-		{
+		for (j = 0 ; j < pTriple->NumChnls; j++) {
 			pDot11dInfo->channel_map[pTriple->FirstChnl + j] = 1;
 			pDot11dInfo->MaxTxPwrDbmList[pTriple->FirstChnl + j] = pTriple->MaxTxPowerInDbm;
 			MaxChnlNum = pTriple->FirstChnl + j;
@@ -116,8 +112,8 @@ Dot11d_UpdateCountryIe(
 #if 1
 	//printk("Dot11d_UpdateCountryIe(): Channel List:\n");
 	printk("Channel List:");
-	for(i = 1; i <= MAX_CHANNEL_NUMBER; i++)
-		if(pDot11dInfo->channel_map[i] > 0)
+	for (i = 1; i <= MAX_CHANNEL_NUMBER; i++)
+		if (pDot11dInfo->channel_map[i] > 0)
 			printk(" %d", i);
 	printk("\n");
 #endif
@@ -138,13 +134,11 @@ DOT11D_GetMaxTxPwrInDbm(
 	PRT_DOT11D_INFO pDot11dInfo = GET_DOT11D_INFO(dev);
 	u8 MaxTxPwrInDbm = 255;
 
-	if(MAX_CHANNEL_NUMBER < Channel)
-	{
+	if (MAX_CHANNEL_NUMBER < Channel) {
 		printk("DOT11D_GetMaxTxPwrInDbm(): Invalid Channel\n");
 		return MaxTxPwrInDbm;
 	}
-	if(pDot11dInfo->channel_map[Channel])
-	{
+	if (pDot11dInfo->channel_map[Channel]) {
 		MaxTxPwrInDbm = pDot11dInfo->MaxTxPwrDbmList[Channel];
 	}
 
@@ -159,15 +153,14 @@ DOT11D_ScanComplete(
 {
 	PRT_DOT11D_INFO pDot11dInfo = GET_DOT11D_INFO(dev);
 
-	switch(pDot11dInfo->State)
-	{
+	switch (pDot11dInfo->State) {
 	case DOT11D_STATE_LEARNED:
 		pDot11dInfo->State = DOT11D_STATE_DONE;
 		break;
 
 	case DOT11D_STATE_DONE:
-		if( GET_CIE_WATCHDOG(dev) == 0 )
-		{ // Reset country IE if previous one is gone.
+		if (GET_CIE_WATCHDOG(dev) == 0) {
+		// Reset country IE if previous one is gone.
 			Dot11d_Reset(dev);
 		}
 		break;
@@ -183,12 +176,11 @@ int IsLegalChannel(
 {
 	PRT_DOT11D_INFO pDot11dInfo = GET_DOT11D_INFO(dev);
 
-	if(MAX_CHANNEL_NUMBER < channel)
-	{
+	if (MAX_CHANNEL_NUMBER < channel) {
 		printk("IsLegalChannel(): Invalid Channel\n");
 		return 0;
 	}
-	if(pDot11dInfo->channel_map[channel] > 0)
+	if (pDot11dInfo->channel_map[channel] > 0)
 		return 1;
 	return 0;
 }
@@ -202,22 +194,19 @@ int ToLegalChannel(
 	u8 default_chn = 0;
 	u32 i = 0;
 
-	for (i = 1; i <= MAX_CHANNEL_NUMBER; i++)
-	{
-		if(pDot11dInfo->channel_map[i] > 0)
-		{
+	for (i = 1; i <= MAX_CHANNEL_NUMBER; i++) {
+		if (pDot11dInfo->channel_map[i] > 0) {
 			default_chn = i;
 			break;
 		}
 	}
 
-	if(MAX_CHANNEL_NUMBER < channel)
-	{
+	if (MAX_CHANNEL_NUMBER < channel) {
 		printk("IsLegalChannel(): Invalid Channel\n");
 		return default_chn;
 	}
 
-	if(pDot11dInfo->channel_map[channel] > 0)
+	if (pDot11dInfo->channel_map[channel] > 0)
 		return channel;
 
 	return default_chn;
-- 
1.7.9.5

