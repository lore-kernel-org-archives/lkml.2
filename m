Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab2DCLem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 07:34:42 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59536 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab2DCLek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 07:34:40 -0400
From: Max Tottenham <mtottenh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Max Tottenham <mtottenh@gmail.com>
Subject: [PATCH 3/8] Staging: bcm: IPv6Protocol.c fix coding style
Date: Tue,  3 Apr 2012 12:35:26 +0100
Message-Id: <1333452931-3195-3-git-send-email-mtottenh@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1333452931-3195-1-git-send-email-mtottenh@gmail.com>
References: <1333452931-3195-1-git-send-email-mtottenh@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Third in a series of patches to fix coding style in Ipv6Protocol.c
This patch fixes the spacing around ',' in function calls.

Signed-off-by: Max Tottenham <mtottenh@gmail.com>
---
 drivers/staging/bcm/IPv6Protocol.c |   86 ++++++++++++++++++------------------
 1 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/bcm/IPv6Protocol.c b/drivers/staging/bcm/IPv6Protocol.c
index de513bc..6bb949c 100644
--- a/drivers/staging/bcm/IPv6Protocol.c
+++ b/drivers/staging/bcm/IPv6Protocol.c
@@ -1,10 +1,10 @@
 #include "headers.h"
 
-static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,IPV6Header *pstIpv6Header);
-static BOOLEAN MatchDestIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,IPV6Header *pstIpv6Header);
+static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule, IPV6Header *pstIpv6Header);
+static BOOLEAN MatchDestIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule, IPV6Header *pstIpv6Header);
 static VOID DumpIpv6Header(IPV6Header *pstIpv6Header);
 
-static UCHAR * GetNextIPV6ChainedHeader(UCHAR **ppucPayload,UCHAR *pucNextHeader,BOOLEAN *bParseDone,USHORT *pusPayloadLength)
+static UCHAR * GetNextIPV6ChainedHeader(UCHAR **ppucPayload, UCHAR *pucNextHeader, BOOLEAN *bParseDone, USHORT *pusPayloadLength)
 {
 	UCHAR *pucRetHeaderPtr = NULL;
 	UCHAR *pucPayloadPtr = NULL;
@@ -33,7 +33,7 @@ static UCHAR * GetNextIPV6ChainedHeader(UCHAR **ppucPayload,UCHAR *pucNextHeader
 	case IPV6HDR_TYPE_HOPBYHOP:
 		{
 
-			BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 HopByHop Header");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 HopByHop Header");
 			usNextHeaderOffset+=sizeof(IPV6HopByHopOptionsHeader);
 		}
 		break;
@@ -41,7 +41,7 @@ static UCHAR * GetNextIPV6ChainedHeader(UCHAR **ppucPayload,UCHAR *pucNextHeader
 	case IPV6HDR_TYPE_ROUTING:
 		{
 			IPV6RoutingHeader *pstIpv6RoutingHeader;
-			BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Routing Header");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Routing Header");
 			pstIpv6RoutingHeader = (IPV6RoutingHeader *)pucPayloadPtr;
 			usNextHeaderOffset += sizeof(IPV6RoutingHeader);
 			usNextHeaderOffset += pstIpv6RoutingHeader->ucNumAddresses * IPV6_ADDRESS_SIZEINBYTES;
@@ -50,7 +50,7 @@ static UCHAR * GetNextIPV6ChainedHeader(UCHAR **ppucPayload,UCHAR *pucNextHeader
 		break;
 	case IPV6HDR_TYPE_FRAGMENTATION:
 		{
-			BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Fragmentation Header");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Fragmentation Header");
 			usNextHeaderOffset+= sizeof(IPV6FragmentHeader);
 
 		}
@@ -59,7 +59,7 @@ static UCHAR * GetNextIPV6ChainedHeader(UCHAR **ppucPayload,UCHAR *pucNextHeader
 		{
 			IPV6DestOptionsHeader *pstIpv6DestOptsHdr = (IPV6DestOptionsHeader *)pucPayloadPtr;
 			int nTotalOptions = pstIpv6DestOptsHdr->ucHdrExtLen;
-			BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 DestOpts Header Header");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 DestOpts Header Header");
 			usNextHeaderOffset+= sizeof(IPV6DestOptionsHeader);
 			usNextHeaderOffset+= nTotalOptions * IPV6_DESTOPTS_HDR_OPTIONSIZE ;
 
@@ -69,32 +69,32 @@ static UCHAR * GetNextIPV6ChainedHeader(UCHAR **ppucPayload,UCHAR *pucNextHeader
 		{
 			IPV6AuthenticationHeader *pstIpv6AuthHdr = (IPV6AuthenticationHeader *)pucPayloadPtr;
 			int nHdrLen = pstIpv6AuthHdr->ucLength;
-			BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Authentication Header");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Authentication Header");
 			usNextHeaderOffset+= nHdrLen * 4;
 		}
 		break;
 	case IPV6HDR_TYPE_ENCRYPTEDSECURITYPAYLOAD:
 		{
-			BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Encrypted Security Payload Header");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Encrypted Security Payload Header");
 			*bParseDone = TRUE;
 
 		}
 		break;
 	case IPV6_ICMP_HDR_TYPE:
 		{
-			BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, " ICMP Header");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, " ICMP Header");
 			*bParseDone = TRUE;
 		}
 		break;
 	case TCP_HEADER_TYPE:
 		{
-			BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, " \nTCP Header");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, " \nTCP Header");
 			*bParseDone = TRUE;
 		}
 		break;
 	case UDP_HEADER_TYPE:
 		{
-			BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, " \nUDP Header");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, " \nUDP Header");
 			*bParseDone = TRUE;
 		}
 		break;
@@ -124,7 +124,7 @@ static UCHAR * GetNextIPV6ChainedHeader(UCHAR **ppucPayload,UCHAR *pucNextHeader
 }
 
 
-static UCHAR GetIpv6ProtocolPorts(UCHAR *pucPayload,USHORT *pusSrcPort,USHORT *pusDestPort,USHORT usPayloadLength,UCHAR ucNextHeader)
+static UCHAR GetIpv6ProtocolPorts(UCHAR *pucPayload, USHORT *pusSrcPort, USHORT *pusDestPort, USHORT usPayloadLength, UCHAR ucNextHeader)
 {
 	UCHAR *pIpv6HdrScanContext = pucPayload;
 	BOOLEAN bDone = FALSE;
@@ -139,12 +139,12 @@ static UCHAR GetIpv6ProtocolPorts(UCHAR *pucPayload,USHORT *pusSrcPort,USHORT *p
 	*pusSrcPort = *pusDestPort = 0;
 	ucHeaderType = ucNextHeader;
 	while (!bDone) {
-		pucNextHeader = GetNextIPV6ChainedHeader(&pIpv6HdrScanContext,&ucHeaderType,&bDone,&usPayloadLength);
+		pucNextHeader = GetNextIPV6ChainedHeader(&pIpv6HdrScanContext, &ucHeaderType, &bDone, &usPayloadLength);
 		if(bDone) {
 			if((ucHeaderType==TCP_HEADER_TYPE) || (ucHeaderType == UDP_HEADER_TYPE)) {
 				 *pusSrcPort=*((PUSHORT)(pucNextHeader));
 				 *pusDestPort=*((PUSHORT)(pucNextHeader+2));
-				 BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, " \nProtocol Ports - Src Port :0x%x Dest Port : 0x%x",ntohs(*pusSrcPort),ntohs(*pusDestPort));
+				 BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, " \nProtocol Ports - Src Port :0x%x Dest Port : 0x%x", ntohs(*pusSrcPort), ntohs(*pusDestPort));
 			}
 			break;
 
@@ -167,7 +167,7 @@ USHORT	IpVersion6(PMINI_ADAPTER Adapter, PVOID pcIpHeader,
 	IPV6Header *pstIpv6Header = NULL;
 	BOOLEAN bClassificationSucceed = FALSE;
 
-	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "IpVersion6 ==========>\n");
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "IpVersion6 ==========>\n");
 
 	pstIpv6Header = (IPV6Header *)pcIpHeader;
 
@@ -213,26 +213,26 @@ USHORT	IpVersion6(PMINI_ADAPTER Adapter, PVOID pcIpHeader,
 		 * For IPv6 the next protocol at end of 
 		 * Chain of IPv6 prot headers
 		 */
-		bClassificationSucceed=MatchProtocol(pstClassifierRule,ucNextProtocolAboveIP);
+		bClassificationSucceed=MatchProtocol(pstClassifierRule, ucNextProtocolAboveIP);
 	        if (!bClassificationSucceed)
 	            break;
-        	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Protocol Matched");
+        	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Protocol Matched");
 
 		if ((ucNextProtocolAboveIP == TCP_HEADER_TYPE) || (ucNextProtocolAboveIP == UDP_HEADER_TYPE)) {
 			/* Match Src Port */
-			BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Source Port:%x\n",ntohs(ushSrcPort));
-			bClassificationSucceed=MatchSrcPort(pstClassifierRule,ntohs(ushSrcPort));
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Source Port:%x\n", ntohs(ushSrcPort));
+			bClassificationSucceed=MatchSrcPort(pstClassifierRule, ntohs(ushSrcPort));
 			if (!bClassificationSucceed)
 				break;
 
-			BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Src Port Matched");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Src Port Matched");
 
 			/* Match Dest Port */
-			BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Destination Port:%x\n",ntohs(ushDestPort));
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Destination Port:%x\n",ntohs(ushDestPort));
 			bClassificationSucceed=MatchDestPort(pstClassifierRule,ntohs(ushDestPort));
 			if (!bClassificationSucceed)
 				break;
-			BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Dest Port Matched");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Dest Port Matched");
 		}
 	} while (0);
 
@@ -252,7 +252,7 @@ USHORT	IpVersion6(PMINI_ADAPTER Adapter, PVOID pcIpHeader,
 }
 
 
-static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,IPV6Header *pstIpv6Header)
+static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule, IPV6Header *pstIpv6Header)
 {
 	UINT uiLoopIndex = 0;
 	UINT uiIpv6AddIndex = 0;
@@ -276,11 +276,11 @@ static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,IPV6Head
 	}
 
 	for (uiLoopIndex = 0; uiLoopIndex<uiCountIPSrcAddresses; uiLoopIndex += uiIpv6AddrNoLongWords) {
-		BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Src Ipv6 Address In Received Packet : \n ");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Src Ipv6 Address In Received Packet : \n ");
 		DumpIpv6Address(aulSrcIP);
-		BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Src Ipv6 Mask In Classifier Rule: \n");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Src Ipv6 Mask In Classifier Rule: \n");
 		DumpIpv6Address(&pstClassifierRule->stSrcIpAddress.ulIpv6Mask[uiLoopIndex]);
-		BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Src Ipv6 Address In Classifier Rule : \n");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Src Ipv6 Address In Classifier Rule : \n");
 		DumpIpv6Address(&pstClassifierRule->stSrcIpAddress.ulIpv6Addr[uiLoopIndex]);
 
 		for (uiIpv6AddIndex = 0; uiIpv6AddIndex < uiIpv6AddrNoLongWords; uiIpv6AddIndex++) {
@@ -295,7 +295,7 @@ static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,IPV6Head
 
 			if (uiIpv6AddIndex ==  uiIpv6AddrNoLongWords-1) {
 				/* Match Found */
-				BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Ipv6 Src Ip Address Matched\n");
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Ipv6 Src Ip Address Matched\n");
 				return TRUE;
 			}
 		}
@@ -303,7 +303,7 @@ static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,IPV6Head
 	return FALSE;
 }
 
-static BOOLEAN MatchDestIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,IPV6Header *pstIpv6Header)
+static BOOLEAN MatchDestIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule, IPV6Header *pstIpv6Header)
 {
 	UINT uiLoopIndex = 0;
 	UINT uiIpv6AddIndex = 0;
@@ -328,11 +328,11 @@ static BOOLEAN MatchDestIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,IPV6Hea
 	}
 
 	for (uiLoopIndex = 0;uiLoopIndex < uiCountIPDestinationAddresses; uiLoopIndex += uiIpv6AddrNoLongWords) {
-		BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Destination Ipv6 Address In Received Packet : \n ");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Destination Ipv6 Address In Received Packet : \n ");
 		DumpIpv6Address(aulDestIP);
-		BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Destination Ipv6 Mask In Classifier Rule: \n");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Destination Ipv6 Mask In Classifier Rule: \n");
 		DumpIpv6Address(&pstClassifierRule->stDestIpAddress.ulIpv6Mask[uiLoopIndex]);
-		BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Destination Ipv6 Address In Classifier Rule : \n");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Destination Ipv6 Address In Classifier Rule : \n");
 		DumpIpv6Address(&pstClassifierRule->stDestIpAddress.ulIpv6Addr[uiLoopIndex]);
 
 		for (uiIpv6AddIndex = 0; uiIpv6AddIndex < uiIpv6AddrNoLongWords; uiIpv6AddIndex++) {
@@ -347,7 +347,7 @@ static BOOLEAN MatchDestIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,IPV6Hea
 
 			if (uiIpv6AddIndex ==  uiIpv6AddrNoLongWords-1) {
 				/* Match Found */
-				BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Ipv6 Destination Ip Address Matched\n");
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Ipv6 Destination Ip Address Matched\n");
 				return TRUE;
 			}
 		}
@@ -362,7 +362,7 @@ VOID DumpIpv6Address(ULONG *puIpv6Address)
 	UINT uiIpv6AddIndex = 0;
 	PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
 	for (uiIpv6AddIndex = 0; uiIpv6AddIndex < uiIpv6AddrNoLongWords; uiIpv6AddIndex++) {
-		BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, ":%lx",puIpv6Address[uiIpv6AddIndex]);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, ":%lx", puIpv6Address[uiIpv6AddIndex]);
 	}
 
 }
@@ -372,23 +372,23 @@ static VOID DumpIpv6Header(IPV6Header *pstIpv6Header)
 	UCHAR ucVersion;
 	UCHAR ucPrio;
 	PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
-	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "----Ipv6 Header---");
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "----Ipv6 Header---");
 	ucVersion = pstIpv6Header->ucVersionPrio & 0xf0;
-	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Version : %x \n",ucVersion);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Version : %x \n", ucVersion);
 	ucPrio = pstIpv6Header->ucVersionPrio & 0x0f;
-	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Priority : %x \n",ucPrio);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Priority : %x \n", ucPrio);
 	/* 
 	 * BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, 
 	 * "Flow Label : %x \n",(pstIpv6Header->ucVersionPrio &0xf0);
 	 */
-	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Payload Length : %x \n",ntohs(pstIpv6Header->usPayloadLength));
-	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Next Header : %x \n",pstIpv6Header->ucNextHeader);
-	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Hop Limit : %x \n",pstIpv6Header->ucHopLimit);
-	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Src Address :\n");
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Payload Length : %x \n", ntohs(pstIpv6Header->usPayloadLength));
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Next Header : %x \n", pstIpv6Header->ucNextHeader);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Hop Limit : %x \n", pstIpv6Header->ucHopLimit);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Src Address :\n");
 	DumpIpv6Address(pstIpv6Header->ulSrcIpAddress);
-	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Dest Address :\n");
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Dest Address :\n");
 	DumpIpv6Address(pstIpv6Header->ulDestIpAddress);
-	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "----Ipv6 Header End---");
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "----Ipv6 Header End---");
 
 
 }
-- 
1.7.3.4

