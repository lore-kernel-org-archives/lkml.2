Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab2DCLd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 07:33:59 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34623 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab2DCLd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 07:33:58 -0400
From: Max Tottenham <mtottenh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Max Tottenham <mtottenh@gmail.com>
Subject: [PATCH 1/8] Staging: bcm: IPv6Protocol.c: Fix coding style
Date: Tue,  3 Apr 2012 12:35:24 +0100
Message-Id: <1333452931-3195-1-git-send-email-mtottenh@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first in a series of 8 patches to fix IPv6Protocol.c
This first patch fixes formatting issues for braced statements
(e.g. if/for/while)

Signed-off-by: Max Tottenham <mtottenh@gmail.com>
---
 drivers/staging/bcm/IPv6Protocol.c |  158 ++++++++++++++----------------------
 1 files changed, 62 insertions(+), 96 deletions(-)

diff --git a/drivers/staging/bcm/IPv6Protocol.c b/drivers/staging/bcm/IPv6Protocol.c
index 5b4fd37..cd5f1c3 100644
--- a/drivers/staging/bcm/IPv6Protocol.c
+++ b/drivers/staging/bcm/IPv6Protocol.c
@@ -9,20 +9,18 @@ static UCHAR * GetNextIPV6ChainedHeader(UCHAR **ppucPayload,UCHAR *pucNextHeader
 	UCHAR *pucRetHeaderPtr = NULL;
 	UCHAR *pucPayloadPtr = NULL;
 	USHORT  usNextHeaderOffset = 0 ;
-    PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
+	PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
 
-	if((NULL == ppucPayload) || (*pusPayloadLength == 0) || (*bParseDone))
-	{
+	if ((NULL == ppucPayload) || (*pusPayloadLength == 0) ||
+		(*bParseDone)) {
 		*bParseDone = TRUE;
 		return NULL;
-
 	}
 
 	pucRetHeaderPtr = *ppucPayload;
 	pucPayloadPtr = *ppucPayload;
 
-	if(!pucRetHeaderPtr || !pucPayloadPtr)
-	{
+	if (!pucRetHeaderPtr || !pucPayloadPtr) {
 		*bParseDone = TRUE;
 		return NULL;
 	}
@@ -31,9 +29,7 @@ static UCHAR * GetNextIPV6ChainedHeader(UCHAR **ppucPayload,UCHAR *pucNextHeader
 	*bParseDone = FALSE;
 
 
-
-	switch(*pucNextHeader)
-	{
+	switch (*pucNextHeader) {
 	case IPV6HDR_TYPE_HOPBYHOP:
 		{
 
@@ -102,7 +98,7 @@ static UCHAR * GetNextIPV6ChainedHeader(UCHAR **ppucPayload,UCHAR *pucNextHeader
 			*bParseDone = TRUE;
 		}
 		break;
-	default :
+	default:
 		{
 			*bParseDone = TRUE;
 
@@ -112,23 +108,17 @@ static UCHAR * GetNextIPV6ChainedHeader(UCHAR **ppucPayload,UCHAR *pucNextHeader
 
 	}
 
-	if(*bParseDone == FALSE)
-	{
-		if(*pusPayloadLength <= usNextHeaderOffset)
-		{
+	if (*bParseDone == FALSE) {
+		if(*pusPayloadLength <= usNextHeaderOffset) {
 			*bParseDone = TRUE;
-		}
-		else
-		{
+		} else {
 			*pucNextHeader = *pucPayloadPtr;
-			pucPayloadPtr+=usNextHeaderOffset;
-			(*pusPayloadLength)-=usNextHeaderOffset;
+			pucPayloadPtr += usNextHeaderOffset;
+			(*pusPayloadLength) -= usNextHeaderOffset;
 		}
 
 	}
 
-
-
 	*ppucPayload = pucPayloadPtr;
 	return pucRetHeaderPtr;
 }
@@ -140,22 +130,18 @@ static UCHAR GetIpv6ProtocolPorts(UCHAR *pucPayload,USHORT *pusSrcPort,USHORT *p
 	BOOLEAN bDone = FALSE;
 	UCHAR ucHeaderType =0;
 	UCHAR *pucNextHeader = NULL;
-    PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
+	PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
 
-	if( !pucPayload || (usPayloadLength == 0))
-	{
+	if ( !pucPayload || (usPayloadLength == 0)) {
 		return 0;
 	}
 
 	*pusSrcPort = *pusDestPort = 0;
 	ucHeaderType = ucNextHeader;
-	while(!bDone)
-	{
+	while (!bDone) {
 		pucNextHeader = GetNextIPV6ChainedHeader(&pIpv6HdrScanContext,&ucHeaderType,&bDone,&usPayloadLength);
-		if(bDone)
-		{
-			if((ucHeaderType==TCP_HEADER_TYPE) || (ucHeaderType == UDP_HEADER_TYPE))
-			{
+		if(bDone) {
+			if((ucHeaderType==TCP_HEADER_TYPE) || (ucHeaderType == UDP_HEADER_TYPE)) {
 				 *pusSrcPort=*((PUSHORT)(pucNextHeader));
 				 *pusDestPort=*((PUSHORT)(pucNextHeader+2));
 				 BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, " \nProtocol Ports - Src Port :0x%x Dest Port : 0x%x",ntohs(*pusSrcPort),ntohs(*pusDestPort));
@@ -192,41 +178,37 @@ USHORT	IpVersion6(PMINI_ADAPTER Adapter, /**< Pointer to the driver control stru
 							pstIpv6Header->usPayloadLength,
 							pstIpv6Header->ucNextHeader);
 
-	do
-	{
-		if(0 == pstClassifierRule->ucDirection)
-		{
+	do {
+		if (0 == pstClassifierRule->ucDirection) {
 			//cannot be processed for classification.
 		   // it is a down link connection
 			break;
 		}
 
-		if(!pstClassifierRule->bIpv6Protocol)
-		{
+		if (!pstClassifierRule->bIpv6Protocol) {
 			//We are looking for Ipv6 Classifiers . Lets ignore this classifier and try the next one.
 			break;
 		}
 
 		bClassificationSucceed=MatchSrcIpv6Address(pstClassifierRule,pstIpv6Header);
-        if(!bClassificationSucceed)
-            break;
+        	if (!bClassificationSucceed)
+	            break;
 
-        bClassificationSucceed=MatchDestIpv6Address(pstClassifierRule,pstIpv6Header);
-        if(!bClassificationSucceed)
-            break;
+	        bClassificationSucceed=MatchDestIpv6Address(pstClassifierRule,pstIpv6Header);
+	        if (!bClassificationSucceed)
+        	    break;
 
 		//Match the protocol type.For IPv6 the next protocol at end of Chain of IPv6 prot headers
 		bClassificationSucceed=MatchProtocol(pstClassifierRule,ucNextProtocolAboveIP);
-        if(!bClassificationSucceed)
-            break;
-        BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Protocol Matched");
+	        if (!bClassificationSucceed)
+	            break;
+        	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Protocol Matched");
 
-		if((ucNextProtocolAboveIP == TCP_HEADER_TYPE) || (ucNextProtocolAboveIP == UDP_HEADER_TYPE))
-		{
+		if ((ucNextProtocolAboveIP == TCP_HEADER_TYPE) || (ucNextProtocolAboveIP == UDP_HEADER_TYPE)) {
 			//Match Src Port
 			BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Source Port:%x\n",ntohs(ushSrcPort));
 			bClassificationSucceed=MatchSrcPort(pstClassifierRule,ntohs(ushSrcPort));
-			if(!bClassificationSucceed)
+			if (!bClassificationSucceed)
 				break;
 
 			BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Src Port Matched");
@@ -234,24 +216,19 @@ USHORT	IpVersion6(PMINI_ADAPTER Adapter, /**< Pointer to the driver control stru
 			//Match Dest Port
 			BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Destination Port:%x\n",ntohs(ushDestPort));
 			bClassificationSucceed=MatchDestPort(pstClassifierRule,ntohs(ushDestPort));
-			if(!bClassificationSucceed)
+			if (!bClassificationSucceed)
 				break;
 			BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Dest Port Matched");
 		}
-	}while(0);
+	} while (0);
 
-	if(TRUE==bClassificationSucceed)
-	{
+	if (TRUE == bClassificationSucceed) {
 		INT iMatchedSFQueueIndex = 0;
 		iMatchedSFQueueIndex = SearchSfid(Adapter,pstClassifierRule->ulSFID);
-		if(iMatchedSFQueueIndex >= NO_OF_QUEUES)
-		{
+		if(iMatchedSFQueueIndex >= NO_OF_QUEUES) {
 			bClassificationSucceed = FALSE;
-		}
-		else
-		{
-			if(FALSE == Adapter->PackInfo[iMatchedSFQueueIndex].bActive)
-			{
+		} else {
+			if (FALSE == Adapter->PackInfo[iMatchedSFQueueIndex].bActive) {
 				bClassificationSucceed = FALSE;
 			}
 		}
@@ -263,11 +240,11 @@ USHORT	IpVersion6(PMINI_ADAPTER Adapter, /**< Pointer to the driver control stru
 
 static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,IPV6Header *pstIpv6Header)
 {
-	UINT uiLoopIndex=0;
-	UINT  uiIpv6AddIndex=0;
-	UINT  uiIpv6AddrNoLongWords = 4;
+	UINT uiLoopIndex = 0;
+	UINT uiIpv6AddIndex = 0;
+	UINT uiIpv6AddrNoLongWords = 4;
 	ULONG aulSrcIP[4];
-    PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
+	PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
 	/*
 	//This is the no. of Src Addresses ie Range of IP Addresses contained
 	//in the classifier rule for which we need to match
@@ -275,18 +252,16 @@ static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,IPV6Head
 	UINT  uiCountIPSrcAddresses = (UINT)pstClassifierRule->ucIPSourceAddressLength;
 
 
-	if(0 == uiCountIPSrcAddresses)
+	if (0 == uiCountIPSrcAddresses)
 		return TRUE;
 
 
 	//First Convert the Ip Address in the packet to Host Endian order
-	for(uiIpv6AddIndex=0;uiIpv6AddIndex<uiIpv6AddrNoLongWords;uiIpv6AddIndex++)
-	{
+	for (uiIpv6AddIndex = 0; uiIpv6AddIndex<uiIpv6AddrNoLongWords; uiIpv6AddIndex++) {
 		aulSrcIP[uiIpv6AddIndex]=ntohl(pstIpv6Header->ulSrcIpAddress[uiIpv6AddIndex]);
 	}
 
-	for(uiLoopIndex=0;uiLoopIndex<uiCountIPSrcAddresses;uiLoopIndex+=uiIpv6AddrNoLongWords)
-	{
+	for (uiLoopIndex = 0; uiLoopIndex<uiCountIPSrcAddresses; uiLoopIndex += uiIpv6AddrNoLongWords) {
 		BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Src Ipv6 Address In Received Packet : \n ");
 		DumpIpv6Address(aulSrcIP);
 		BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Src Ipv6 Mask In Classifier Rule: \n");
@@ -294,17 +269,14 @@ static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,IPV6Head
 		BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Src Ipv6 Address In Classifier Rule : \n");
 		DumpIpv6Address(&pstClassifierRule->stSrcIpAddress.ulIpv6Addr[uiLoopIndex]);
 
-		for(uiIpv6AddIndex=0;uiIpv6AddIndex<uiIpv6AddrNoLongWords;uiIpv6AddIndex++)
-		{
-			if((pstClassifierRule->stSrcIpAddress.ulIpv6Mask[uiLoopIndex+uiIpv6AddIndex] & aulSrcIP[uiIpv6AddIndex])
-				!= pstClassifierRule->stSrcIpAddress.ulIpv6Addr[uiLoopIndex+uiIpv6AddIndex])
-			{
+		for (uiIpv6AddIndex = 0; uiIpv6AddIndex < uiIpv6AddrNoLongWords; uiIpv6AddIndex++) {
+			if ((pstClassifierRule->stSrcIpAddress.ulIpv6Mask[uiLoopIndex+uiIpv6AddIndex] & aulSrcIP[uiIpv6AddIndex])
+				!= pstClassifierRule->stSrcIpAddress.ulIpv6Addr[uiLoopIndex+uiIpv6AddIndex]) {
 				//Match failed for current Ipv6 Address.Try next Ipv6 Address
 				break;
 			}
 
-			if(uiIpv6AddIndex ==  uiIpv6AddrNoLongWords-1)
-			{
+			if (uiIpv6AddIndex ==  uiIpv6AddrNoLongWords-1) {
 				//Match Found
 				BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Ipv6 Src Ip Address Matched\n");
 				return TRUE;
@@ -316,11 +288,11 @@ static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,IPV6Head
 
 static BOOLEAN MatchDestIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,IPV6Header *pstIpv6Header)
 {
-	UINT uiLoopIndex=0;
-	UINT  uiIpv6AddIndex=0;
-	UINT  uiIpv6AddrNoLongWords = 4;
+	UINT uiLoopIndex = 0;
+	UINT uiIpv6AddIndex = 0;
+	UINT uiIpv6AddrNoLongWords = 4;
 	ULONG aulDestIP[4];
-    PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
+	PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
 	/*
 	//This is the no. of Destination Addresses ie Range of IP Addresses contained
 	//in the classifier rule for which we need to match
@@ -328,18 +300,16 @@ static BOOLEAN MatchDestIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,IPV6Hea
 	UINT  uiCountIPDestinationAddresses = (UINT)pstClassifierRule->ucIPDestinationAddressLength;
 
 
-	if(0 == uiCountIPDestinationAddresses)
+	if (0 == uiCountIPDestinationAddresses)
 		return TRUE;
 
 
 	//First Convert the Ip Address in the packet to Host Endian order
-	for(uiIpv6AddIndex=0;uiIpv6AddIndex<uiIpv6AddrNoLongWords;uiIpv6AddIndex++)
-	{
+	for (uiIpv6AddIndex = 0;uiIpv6AddIndex < uiIpv6AddrNoLongWords; uiIpv6AddIndex++) {
 		aulDestIP[uiIpv6AddIndex]=ntohl(pstIpv6Header->ulDestIpAddress[uiIpv6AddIndex]);
 	}
 
-	for(uiLoopIndex=0;uiLoopIndex<uiCountIPDestinationAddresses;uiLoopIndex+=uiIpv6AddrNoLongWords)
-	{
+	for (uiLoopIndex = 0;uiLoopIndex < uiCountIPDestinationAddresses; uiLoopIndex += uiIpv6AddrNoLongWords) {
 		BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Destination Ipv6 Address In Received Packet : \n ");
 		DumpIpv6Address(aulDestIP);
 		BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Destination Ipv6 Mask In Classifier Rule: \n");
@@ -347,17 +317,14 @@ static BOOLEAN MatchDestIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,IPV6Hea
 		BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Destination Ipv6 Address In Classifier Rule : \n");
 		DumpIpv6Address(&pstClassifierRule->stDestIpAddress.ulIpv6Addr[uiLoopIndex]);
 
-		for(uiIpv6AddIndex=0;uiIpv6AddIndex<uiIpv6AddrNoLongWords;uiIpv6AddIndex++)
-		{
-			if((pstClassifierRule->stDestIpAddress.ulIpv6Mask[uiLoopIndex+uiIpv6AddIndex] & aulDestIP[uiIpv6AddIndex])
-				!= pstClassifierRule->stDestIpAddress.ulIpv6Addr[uiLoopIndex+uiIpv6AddIndex])
-			{
+		for (uiIpv6AddIndex = 0; uiIpv6AddIndex < uiIpv6AddrNoLongWords; uiIpv6AddIndex++) {
+			if ((pstClassifierRule->stDestIpAddress.ulIpv6Mask[uiLoopIndex+uiIpv6AddIndex] & aulDestIP[uiIpv6AddIndex])
+				!= pstClassifierRule->stDestIpAddress.ulIpv6Addr[uiLoopIndex+uiIpv6AddIndex]) {
 				//Match failed for current Ipv6 Address.Try next Ipv6 Address
 				break;
 			}
 
-			if(uiIpv6AddIndex ==  uiIpv6AddrNoLongWords-1)
-			{
+			if (uiIpv6AddIndex ==  uiIpv6AddrNoLongWords-1) {
 				//Match Found
 				BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Ipv6 Destination Ip Address Matched\n");
 				return TRUE;
@@ -371,10 +338,9 @@ static BOOLEAN MatchDestIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,IPV6Hea
 VOID DumpIpv6Address(ULONG *puIpv6Address)
 {
 	UINT uiIpv6AddrNoLongWords = 4;
-	UINT  uiIpv6AddIndex=0;
-    PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
-	for(uiIpv6AddIndex=0;uiIpv6AddIndex<uiIpv6AddrNoLongWords;uiIpv6AddIndex++)
-	{
+	UINT uiIpv6AddIndex = 0;
+	PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
+	for (uiIpv6AddIndex = 0; uiIpv6AddIndex < uiIpv6AddrNoLongWords; uiIpv6AddIndex++) {
 		BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, ":%lx",puIpv6Address[uiIpv6AddIndex]);
 	}
 
@@ -383,8 +349,8 @@ VOID DumpIpv6Address(ULONG *puIpv6Address)
 static VOID DumpIpv6Header(IPV6Header *pstIpv6Header)
 {
 	UCHAR ucVersion;
-	UCHAR  ucPrio ;
-    PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
+	UCHAR ucPrio;
+	PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
 	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "----Ipv6 Header---");
 	ucVersion = pstIpv6Header->ucVersionPrio & 0xf0;
 	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Version : %x \n",ucVersion);
-- 
1.7.3.4

