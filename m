Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab2DCLez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 07:34:55 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55291 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab2DCLew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 07:34:52 -0400
From: Max Tottenham <mtottenh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Max Tottenham <mtottenh@gmail.com>
Subject: [PATCH 5/8] Staging: bcm: IPv6Protocol.c coding style fix
Date: Tue,  3 Apr 2012 12:35:28 +0100
Message-Id: <1333452931-3195-5-git-send-email-mtottenh@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1333452931-3195-1-git-send-email-mtottenh@gmail.com>
References: <1333452931-3195-1-git-send-email-mtottenh@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fith in a series of patche to fi coding syle in IPv6Protocol.c
Fixed trailing whitespaces and replaced spaces with tabs
in code indents

Signed-off-by: Max Tottenham <mtottenh@gmail.com>
---
 drivers/staging/bcm/IPv6Protocol.c |   59 ++++++++++++++++++-----------------
 1 files changed, 30 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/bcm/IPv6Protocol.c b/drivers/staging/bcm/IPv6Protocol.c
index 7bc1dc2..80173e7 100644
--- a/drivers/staging/bcm/IPv6Protocol.c
+++ b/drivers/staging/bcm/IPv6Protocol.c
@@ -4,7 +4,7 @@ static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule, IPV6Hea
 static BOOLEAN MatchDestIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule, IPV6Header *pstIpv6Header);
 static VOID DumpIpv6Header(IPV6Header *pstIpv6Header);
 
-static UCHAR * GetNextIPV6ChainedHeader(UCHAR **ppucPayload, UCHAR *pucNextHeader, BOOLEAN *bParseDone, USHORT *pusPayloadLength)
+static UCHAR *GetNextIPV6ChainedHeader(UCHAR **ppucPayload, UCHAR *pucNextHeader, BOOLEAN *bParseDone, USHORT *pusPayloadLength)
 {
 	UCHAR *pucRetHeaderPtr = NULL;
 	UCHAR *pucPayloadPtr = NULL;
@@ -109,7 +109,7 @@ static UCHAR * GetNextIPV6ChainedHeader(UCHAR **ppucPayload, UCHAR *pucNextHeade
 	}
 
 	if (*bParseDone == FALSE) {
-		if(*pusPayloadLength <= usNextHeaderOffset) {
+		if (*pusPayloadLength <= usNextHeaderOffset) {
 			*bParseDone = TRUE;
 		} else {
 			*pucNextHeader = *pucPayloadPtr;
@@ -132,7 +132,7 @@ static UCHAR GetIpv6ProtocolPorts(UCHAR *pucPayload, USHORT *pusSrcPort, USHORT
 	UCHAR *pucNextHeader = NULL;
 	PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
 
-	if ( !pucPayload || (usPayloadLength == 0)) {
+	if (!pucPayload || (usPayloadLength == 0)) {
 		return 0;
 	}
 
@@ -140,8 +140,8 @@ static UCHAR GetIpv6ProtocolPorts(UCHAR *pucPayload, USHORT *pusSrcPort, USHORT
 	ucHeaderType = ucNextHeader;
 	while (!bDone) {
 		pucNextHeader = GetNextIPV6ChainedHeader(&pIpv6HdrScanContext, &ucHeaderType, &bDone, &usPayloadLength);
-		if(bDone) {
-			if((ucHeaderType == TCP_HEADER_TYPE) || (ucHeaderType == UDP_HEADER_TYPE)) {
+		if (bDone) {
+			if ((ucHeaderType == TCP_HEADER_TYPE) || (ucHeaderType == UDP_HEADER_TYPE)) {
 				 *pusSrcPort = *((PUSHORT)(pucNextHeader));
 				 *pusDestPort = *((PUSHORT)(pucNextHeader+2));
 				 BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, " \nProtocol Ports - Src Port :0x%x Dest Port : 0x%x", ntohs(*pusSrcPort), ntohs(*pusDestPort));
@@ -159,7 +159,7 @@ static UCHAR GetIpv6ProtocolPorts(UCHAR *pucPayload, USHORT *pusSrcPort, USHORT
  * Arg 2 PVOID pcIpHeader is a pointer to the IP header of the packet
  */
 USHORT	IpVersion6(PMINI_ADAPTER Adapter, PVOID pcIpHeader,
-					S_CLASSIFIER_RULE *pstClassifierRule )
+					S_CLASSIFIER_RULE *pstClassifierRule)
 {
 	USHORT	ushDestPort = 0;
 	USHORT	ushSrcPort = 0;
@@ -173,8 +173,8 @@ USHORT	IpVersion6(PMINI_ADAPTER Adapter, PVOID pcIpHeader,
 
 	DumpIpv6Header(pstIpv6Header);
 
-	/* 
-	 * Try to get the next higher layer protocol 
+	/*
+	 * Try to get the next higher layer protocol
 	 * and the Ports Nos if TCP or UDP
 	 */
 	ucNextProtocolAboveIP = GetIpv6ProtocolPorts((UCHAR *)(pcIpHeader + sizeof(IPV6Header)),
@@ -185,38 +185,39 @@ USHORT	IpVersion6(PMINI_ADAPTER Adapter, PVOID pcIpHeader,
 
 	do {
 		if (0 == pstClassifierRule->ucDirection) {
-			/* 
+			/*
 			 * cannot be processed for classification.
-		   	 * it is a down link connection
+			 * it is a down link connection
 			 */
 			break;
 		}
 
 		if (!pstClassifierRule->bIpv6Protocol) {
 			/*
-			 * We are looking for Ipv6 Classifiers 
+			 * We are looking for Ipv6 Classifiers
 			 * Lets ignore this classifier and try the next one
 			 */
 			break;
 		}
 
 		bClassificationSucceed = MatchSrcIpv6Address(pstClassifierRule, pstIpv6Header);
-        	if (!bClassificationSucceed)
-	            break;
+		if (!bClassificationSucceed)
+			break;
 
-	        bClassificationSucceed = MatchDestIpv6Address(pstClassifierRule, pstIpv6Header);
-	        if (!bClassificationSucceed)
-        	    break;
+		bClassificationSucceed = MatchDestIpv6Address(pstClassifierRule, pstIpv6Header);
+		if (!bClassificationSucceed)
+			break;
 
-		/* 
+		/*
 		 * Match the protocol type.
-		 * For IPv6 the next protocol at end of 
+		 * For IPv6 the next protocol at end of
 		 * Chain of IPv6 prot headers
 		 */
 		bClassificationSucceed = MatchProtocol(pstClassifierRule, ucNextProtocolAboveIP);
-	        if (!bClassificationSucceed)
-	            break;
-        	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Protocol Matched");
+		if (!bClassificationSucceed)
+			break;
+
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Protocol Matched");
 
 		if ((ucNextProtocolAboveIP == TCP_HEADER_TYPE) || (ucNextProtocolAboveIP == UDP_HEADER_TYPE)) {
 			/* Match Src Port */
@@ -239,7 +240,7 @@ USHORT	IpVersion6(PMINI_ADAPTER Adapter, PVOID pcIpHeader,
 	if (TRUE == bClassificationSucceed) {
 		INT iMatchedSFQueueIndex = 0;
 		iMatchedSFQueueIndex = SearchSfid(Adapter, pstClassifierRule->ulSFID);
-		if(iMatchedSFQueueIndex >= NO_OF_QUEUES) {
+		if (iMatchedSFQueueIndex >= NO_OF_QUEUES) {
 			bClassificationSucceed = FALSE;
 		} else {
 			if (FALSE == Adapter->PackInfo[iMatchedSFQueueIndex].bActive) {
@@ -286,7 +287,7 @@ static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule, IPV6Hea
 		for (uiIpv6AddIndex = 0; uiIpv6AddIndex < uiIpv6AddrNoLongWords; uiIpv6AddIndex++) {
 			if ((pstClassifierRule->stSrcIpAddress.ulIpv6Mask[uiLoopIndex+uiIpv6AddIndex] & aulSrcIP[uiIpv6AddIndex])
 				!= pstClassifierRule->stSrcIpAddress.ulIpv6Addr[uiLoopIndex+uiIpv6AddIndex]) {
-				/* 
+				/*
 				 * Match failed for current Ipv6 Address
 				 * Try next Ipv6 Address
 				 */
@@ -310,9 +311,9 @@ static BOOLEAN MatchDestIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule, IPV6He
 	UINT uiIpv6AddrNoLongWords = 4;
 	ULONG aulDestIP[4];
 	PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
-	/* 
-	 * This is the no. of Destination Addresses 
-	 * ie Range of IP Addresses contained in the classifier rule 
+	/*
+	 * This is the no. of Destination Addresses
+	 * ie Range of IP Addresses contained in the classifier rule
 	 * for which we need to match
 	 */
 	UINT  uiCountIPDestinationAddresses = (UINT)pstClassifierRule->ucIPDestinationAddressLength;
@@ -338,7 +339,7 @@ static BOOLEAN MatchDestIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule, IPV6He
 		for (uiIpv6AddIndex = 0; uiIpv6AddIndex < uiIpv6AddrNoLongWords; uiIpv6AddIndex++) {
 			if ((pstClassifierRule->stDestIpAddress.ulIpv6Mask[uiLoopIndex+uiIpv6AddIndex] & aulDestIP[uiIpv6AddIndex])
 				!= pstClassifierRule->stDestIpAddress.ulIpv6Addr[uiLoopIndex+uiIpv6AddIndex]) {
-				/* 
+				/*
 				 * Match failed for current Ipv6 Address.
 				 * Try next Ipv6 Address
 				 */
@@ -377,8 +378,8 @@ static VOID DumpIpv6Header(IPV6Header *pstIpv6Header)
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Version : %x \n", ucVersion);
 	ucPrio = pstIpv6Header->ucVersionPrio & 0x0f;
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Priority : %x \n", ucPrio);
-	/* 
-	 * BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, 
+	/*
+	 * BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL,
 	 * "Flow Label : %x \n",(pstIpv6Header->ucVersionPrio &0xf0);
 	 */
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Payload Length : %x \n", ntohs(pstIpv6Header->usPayloadLength));
-- 
1.7.3.4

