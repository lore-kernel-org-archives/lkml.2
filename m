Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab2DCLev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 07:34:51 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37330 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab2DCLet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 07:34:49 -0400
From: Max Tottenham <mtottenh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Max Tottenham <mtottenh@gmail.com>
Subject: [PATCH 4/8] Staging: bcm: IPv6Protocol.c coding style fix
Date: Tue,  3 Apr 2012 12:35:27 +0100
Message-Id: <1333452931-3195-4-git-send-email-mtottenh@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1333452931-3195-1-git-send-email-mtottenh@gmail.com>
References: <1333452931-3195-1-git-send-email-mtottenh@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fourth patch in a series of patches to fix  coding style in IPv6Protocol.c
Continuation of fixing spacing arount ','

Signed-off-by: Max Tottenham <mtottenh@gmail.com>
---
 drivers/staging/bcm/IPv6Protocol.c |   46 ++++++++++++++++++------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/bcm/IPv6Protocol.c b/drivers/staging/bcm/IPv6Protocol.c
index 6bb949c..7bc1dc2 100644
--- a/drivers/staging/bcm/IPv6Protocol.c
+++ b/drivers/staging/bcm/IPv6Protocol.c
@@ -34,7 +34,7 @@ static UCHAR * GetNextIPV6ChainedHeader(UCHAR **ppucPayload, UCHAR *pucNextHeade
 		{
 
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 HopByHop Header");
-			usNextHeaderOffset+=sizeof(IPV6HopByHopOptionsHeader);
+			usNextHeaderOffset += sizeof(IPV6HopByHopOptionsHeader);
 		}
 		break;
 
@@ -51,7 +51,7 @@ static UCHAR * GetNextIPV6ChainedHeader(UCHAR **ppucPayload, UCHAR *pucNextHeade
 	case IPV6HDR_TYPE_FRAGMENTATION:
 		{
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Fragmentation Header");
-			usNextHeaderOffset+= sizeof(IPV6FragmentHeader);
+			usNextHeaderOffset += sizeof(IPV6FragmentHeader);
 
 		}
 		break;
@@ -60,8 +60,8 @@ static UCHAR * GetNextIPV6ChainedHeader(UCHAR **ppucPayload, UCHAR *pucNextHeade
 			IPV6DestOptionsHeader *pstIpv6DestOptsHdr = (IPV6DestOptionsHeader *)pucPayloadPtr;
 			int nTotalOptions = pstIpv6DestOptsHdr->ucHdrExtLen;
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 DestOpts Header Header");
-			usNextHeaderOffset+= sizeof(IPV6DestOptionsHeader);
-			usNextHeaderOffset+= nTotalOptions * IPV6_DESTOPTS_HDR_OPTIONSIZE ;
+			usNextHeaderOffset += sizeof(IPV6DestOptionsHeader);
+			usNextHeaderOffset += nTotalOptions * IPV6_DESTOPTS_HDR_OPTIONSIZE ;
 
 		}
 		break;
@@ -70,7 +70,7 @@ static UCHAR * GetNextIPV6ChainedHeader(UCHAR **ppucPayload, UCHAR *pucNextHeade
 			IPV6AuthenticationHeader *pstIpv6AuthHdr = (IPV6AuthenticationHeader *)pucPayloadPtr;
 			int nHdrLen = pstIpv6AuthHdr->ucLength;
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Authentication Header");
-			usNextHeaderOffset+= nHdrLen * 4;
+			usNextHeaderOffset += nHdrLen * 4;
 		}
 		break;
 	case IPV6HDR_TYPE_ENCRYPTEDSECURITYPAYLOAD:
@@ -128,7 +128,7 @@ static UCHAR GetIpv6ProtocolPorts(UCHAR *pucPayload, USHORT *pusSrcPort, USHORT
 {
 	UCHAR *pIpv6HdrScanContext = pucPayload;
 	BOOLEAN bDone = FALSE;
-	UCHAR ucHeaderType =0;
+	UCHAR ucHeaderType = 0;
 	UCHAR *pucNextHeader = NULL;
 	PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
 
@@ -141,9 +141,9 @@ static UCHAR GetIpv6ProtocolPorts(UCHAR *pucPayload, USHORT *pusSrcPort, USHORT
 	while (!bDone) {
 		pucNextHeader = GetNextIPV6ChainedHeader(&pIpv6HdrScanContext, &ucHeaderType, &bDone, &usPayloadLength);
 		if(bDone) {
-			if((ucHeaderType==TCP_HEADER_TYPE) || (ucHeaderType == UDP_HEADER_TYPE)) {
-				 *pusSrcPort=*((PUSHORT)(pucNextHeader));
-				 *pusDestPort=*((PUSHORT)(pucNextHeader+2));
+			if((ucHeaderType == TCP_HEADER_TYPE) || (ucHeaderType == UDP_HEADER_TYPE)) {
+				 *pusSrcPort = *((PUSHORT)(pucNextHeader));
+				 *pusDestPort = *((PUSHORT)(pucNextHeader+2));
 				 BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, " \nProtocol Ports - Src Port :0x%x Dest Port : 0x%x", ntohs(*pusSrcPort), ntohs(*pusDestPort));
 			}
 			break;
@@ -163,7 +163,7 @@ USHORT	IpVersion6(PMINI_ADAPTER Adapter, PVOID pcIpHeader,
 {
 	USHORT	ushDestPort = 0;
 	USHORT	ushSrcPort = 0;
-	UCHAR   ucNextProtocolAboveIP =0;
+	UCHAR   ucNextProtocolAboveIP = 0;
 	IPV6Header *pstIpv6Header = NULL;
 	BOOLEAN bClassificationSucceed = FALSE;
 
@@ -200,11 +200,11 @@ USHORT	IpVersion6(PMINI_ADAPTER Adapter, PVOID pcIpHeader,
 			break;
 		}
 
-		bClassificationSucceed=MatchSrcIpv6Address(pstClassifierRule,pstIpv6Header);
+		bClassificationSucceed = MatchSrcIpv6Address(pstClassifierRule, pstIpv6Header);
         	if (!bClassificationSucceed)
 	            break;
 
-	        bClassificationSucceed=MatchDestIpv6Address(pstClassifierRule,pstIpv6Header);
+	        bClassificationSucceed = MatchDestIpv6Address(pstClassifierRule, pstIpv6Header);
 	        if (!bClassificationSucceed)
         	    break;
 
@@ -213,7 +213,7 @@ USHORT	IpVersion6(PMINI_ADAPTER Adapter, PVOID pcIpHeader,
 		 * For IPv6 the next protocol at end of 
 		 * Chain of IPv6 prot headers
 		 */
-		bClassificationSucceed=MatchProtocol(pstClassifierRule, ucNextProtocolAboveIP);
+		bClassificationSucceed = MatchProtocol(pstClassifierRule, ucNextProtocolAboveIP);
 	        if (!bClassificationSucceed)
 	            break;
         	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Protocol Matched");
@@ -221,15 +221,15 @@ USHORT	IpVersion6(PMINI_ADAPTER Adapter, PVOID pcIpHeader,
 		if ((ucNextProtocolAboveIP == TCP_HEADER_TYPE) || (ucNextProtocolAboveIP == UDP_HEADER_TYPE)) {
 			/* Match Src Port */
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Source Port:%x\n", ntohs(ushSrcPort));
-			bClassificationSucceed=MatchSrcPort(pstClassifierRule, ntohs(ushSrcPort));
+			bClassificationSucceed = MatchSrcPort(pstClassifierRule, ntohs(ushSrcPort));
 			if (!bClassificationSucceed)
 				break;
 
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Src Port Matched");
 
 			/* Match Dest Port */
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Destination Port:%x\n",ntohs(ushDestPort));
-			bClassificationSucceed=MatchDestPort(pstClassifierRule,ntohs(ushDestPort));
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Destination Port:%x\n", ntohs(ushDestPort));
+			bClassificationSucceed = MatchDestPort(pstClassifierRule, ntohs(ushDestPort));
 			if (!bClassificationSucceed)
 				break;
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Dest Port Matched");
@@ -238,7 +238,7 @@ USHORT	IpVersion6(PMINI_ADAPTER Adapter, PVOID pcIpHeader,
 
 	if (TRUE == bClassificationSucceed) {
 		INT iMatchedSFQueueIndex = 0;
-		iMatchedSFQueueIndex = SearchSfid(Adapter,pstClassifierRule->ulSFID);
+		iMatchedSFQueueIndex = SearchSfid(Adapter, pstClassifierRule->ulSFID);
 		if(iMatchedSFQueueIndex >= NO_OF_QUEUES) {
 			bClassificationSucceed = FALSE;
 		} else {
@@ -271,11 +271,11 @@ static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule, IPV6Hea
 
 
 	/* First Convert the Ip Address in the packet to Host Endian order */
-	for (uiIpv6AddIndex = 0; uiIpv6AddIndex<uiIpv6AddrNoLongWords; uiIpv6AddIndex++) {
-		aulSrcIP[uiIpv6AddIndex]=ntohl(pstIpv6Header->ulSrcIpAddress[uiIpv6AddIndex]);
+	for (uiIpv6AddIndex = 0; uiIpv6AddIndex < uiIpv6AddrNoLongWords; uiIpv6AddIndex++) {
+		aulSrcIP[uiIpv6AddIndex] = ntohl(pstIpv6Header->ulSrcIpAddress[uiIpv6AddIndex]);
 	}
 
-	for (uiLoopIndex = 0; uiLoopIndex<uiCountIPSrcAddresses; uiLoopIndex += uiIpv6AddrNoLongWords) {
+	for (uiLoopIndex = 0; uiLoopIndex < uiCountIPSrcAddresses; uiLoopIndex += uiIpv6AddrNoLongWords) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Src Ipv6 Address In Received Packet : \n ");
 		DumpIpv6Address(aulSrcIP);
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Src Ipv6 Mask In Classifier Rule: \n");
@@ -323,11 +323,11 @@ static BOOLEAN MatchDestIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule, IPV6He
 
 
 	/* First Convert the Ip Address in the packet to Host Endian order */
-	for (uiIpv6AddIndex = 0;uiIpv6AddIndex < uiIpv6AddrNoLongWords; uiIpv6AddIndex++) {
-		aulDestIP[uiIpv6AddIndex]=ntohl(pstIpv6Header->ulDestIpAddress[uiIpv6AddIndex]);
+	for (uiIpv6AddIndex = 0; uiIpv6AddIndex < uiIpv6AddrNoLongWords; uiIpv6AddIndex++) {
+		aulDestIP[uiIpv6AddIndex] = ntohl(pstIpv6Header->ulDestIpAddress[uiIpv6AddIndex]);
 	}
 
-	for (uiLoopIndex = 0;uiLoopIndex < uiCountIPDestinationAddresses; uiLoopIndex += uiIpv6AddrNoLongWords) {
+	for (uiLoopIndex = 0; uiLoopIndex < uiCountIPDestinationAddresses; uiLoopIndex += uiIpv6AddrNoLongWords) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Destination Ipv6 Address In Received Packet : \n ");
 		DumpIpv6Address(aulDestIP);
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Destination Ipv6 Mask In Classifier Rule: \n");
-- 
1.7.3.4

