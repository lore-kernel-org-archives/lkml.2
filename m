Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab2DCLfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 07:35:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55291 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264Ab2DCLfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 07:35:08 -0400
From: Max Tottenham <mtottenh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Max Tottenham <mtottenh@gmail.com>
Subject: [PATCH 7/8] Staging: bcm: IPv6Protocol.c: coding style fix
Date: Tue,  3 Apr 2012 12:35:30 +0100
Message-Id: <1333452931-3195-7-git-send-email-mtottenh@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1333452931-3195-1-git-send-email-mtottenh@gmail.com>
References: <1333452931-3195-1-git-send-email-mtottenh@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seventh patch in a series of patches to fix coding style in IPv6Protocol.c
this patch makes the file mostly conform to the 80 char line limit
there are some exceptions to this rule I have left in to aid readability

Signed-off-by: Max Tottenham <mtottenh@gmail.com>
---
 drivers/staging/bcm/IPv6Protocol.c |  162 ++++++++++++++++++++++++-----------
 1 files changed, 111 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/bcm/IPv6Protocol.c b/drivers/staging/bcm/IPv6Protocol.c
index 0f87119..d9c9cef 100644
--- a/drivers/staging/bcm/IPv6Protocol.c
+++ b/drivers/staging/bcm/IPv6Protocol.c
@@ -1,10 +1,13 @@
 #include "headers.h"
 
-static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule, IPV6Header *pstIpv6Header);
-static BOOLEAN MatchDestIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule, IPV6Header *pstIpv6Header);
+static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,
+	IPV6Header *pstIpv6Header);
+static BOOLEAN MatchDestIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,
+	IPV6Header *pstIpv6Header);
 static VOID DumpIpv6Header(IPV6Header *pstIpv6Header);
 
-static UCHAR *GetNextIPV6ChainedHeader(UCHAR **ppucPayload, UCHAR *pucNextHeader, BOOLEAN *bParseDone, USHORT *pusPayloadLength)
+static UCHAR *GetNextIPV6ChainedHeader(UCHAR **ppucPayload,
+	UCHAR *pucNextHeader, BOOLEAN *bParseDone, USHORT *pusPayloadLength)
 {
 	UCHAR *pucRetHeaderPtr = NULL;
 	UCHAR *pucPayloadPtr = NULL;
@@ -33,7 +36,8 @@ static UCHAR *GetNextIPV6ChainedHeader(UCHAR **ppucPayload, UCHAR *pucNextHeader
 	case IPV6HDR_TYPE_HOPBYHOP:
 		{
 
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 HopByHop Header");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG,
+					DBG_LVL_ALL, "\nIPv6 HopByHop Header");
 			usNextHeaderOffset += sizeof(IPV6HopByHopOptionsHeader);
 		}
 		break;
@@ -41,7 +45,8 @@ static UCHAR *GetNextIPV6ChainedHeader(UCHAR **ppucPayload, UCHAR *pucNextHeader
 	case IPV6HDR_TYPE_ROUTING:
 		{
 			IPV6RoutingHeader *pstIpv6RoutingHeader;
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Routing Header");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG,
+					DBG_LVL_ALL, "\nIPv6 Routing Header");
 			pstIpv6RoutingHeader = (IPV6RoutingHeader *)pucPayloadPtr;
 			usNextHeaderOffset += sizeof(IPV6RoutingHeader);
 			usNextHeaderOffset += pstIpv6RoutingHeader->ucNumAddresses * IPV6_ADDRESS_SIZEINBYTES;
@@ -50,7 +55,9 @@ static UCHAR *GetNextIPV6ChainedHeader(UCHAR **ppucPayload, UCHAR *pucNextHeader
 		break;
 	case IPV6HDR_TYPE_FRAGMENTATION:
 		{
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Fragmentation Header");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG,
+					DBG_LVL_ALL,
+					"\nIPv6 Fragmentation Header");
 			usNextHeaderOffset += sizeof(IPV6FragmentHeader);
 
 		}
@@ -59,7 +66,9 @@ static UCHAR *GetNextIPV6ChainedHeader(UCHAR **ppucPayload, UCHAR *pucNextHeader
 		{
 			IPV6DestOptionsHeader *pstIpv6DestOptsHdr = (IPV6DestOptionsHeader *)pucPayloadPtr;
 			int nTotalOptions = pstIpv6DestOptsHdr->ucHdrExtLen;
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 DestOpts Header Header");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG,
+					DBG_LVL_ALL,
+					"\nIPv6 DestOpts Header Header");
 			usNextHeaderOffset += sizeof(IPV6DestOptionsHeader);
 			usNextHeaderOffset += nTotalOptions * IPV6_DESTOPTS_HDR_OPTIONSIZE ;
 
@@ -69,32 +78,39 @@ static UCHAR *GetNextIPV6ChainedHeader(UCHAR **ppucPayload, UCHAR *pucNextHeader
 		{
 			IPV6AuthenticationHeader *pstIpv6AuthHdr = (IPV6AuthenticationHeader *)pucPayloadPtr;
 			int nHdrLen = pstIpv6AuthHdr->ucLength;
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Authentication Header");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG,
+					DBG_LVL_ALL,
+					"\nIPv6 Authentication Header");
 			usNextHeaderOffset += nHdrLen * 4;
 		}
 		break;
 	case IPV6HDR_TYPE_ENCRYPTEDSECURITYPAYLOAD:
 		{
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Encrypted Security Payload Header");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG,
+					DBG_LVL_ALL,
+					"\nIPv6 Encrypted Security Payload Header");
 			*bParseDone = TRUE;
 
 		}
 		break;
 	case IPV6_ICMP_HDR_TYPE:
 		{
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, " ICMP Header");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG,
+					DBG_LVL_ALL, "\nICMP Header");
 			*bParseDone = TRUE;
 		}
 		break;
 	case TCP_HEADER_TYPE:
 		{
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, " \nTCP Header");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG,
+					DBG_LVL_ALL, "\nTCP Header");
 			*bParseDone = TRUE;
 		}
 		break;
 	case UDP_HEADER_TYPE:
 		{
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, " \nUDP Header");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG,
+					DBG_LVL_ALL, "\nUDP Header");
 			*bParseDone = TRUE;
 		}
 		break;
@@ -124,7 +140,8 @@ static UCHAR *GetNextIPV6ChainedHeader(UCHAR **ppucPayload, UCHAR *pucNextHeader
 }
 
 
-static UCHAR GetIpv6ProtocolPorts(UCHAR *pucPayload, USHORT *pusSrcPort, USHORT *pusDestPort, USHORT usPayloadLength, UCHAR ucNextHeader)
+static UCHAR GetIpv6ProtocolPorts(UCHAR *pucPayload, USHORT *pusSrcPort,
+	USHORT *pusDestPort, USHORT usPayloadLength, UCHAR ucNextHeader)
 {
 	UCHAR *pIpv6HdrScanContext = pucPayload;
 	BOOLEAN bDone = FALSE;
@@ -139,12 +156,18 @@ static UCHAR GetIpv6ProtocolPorts(UCHAR *pucPayload, USHORT *pusSrcPort, USHORT
 	*pusSrcPort = *pusDestPort = 0;
 	ucHeaderType = ucNextHeader;
 	while (!bDone) {
-		pucNextHeader = GetNextIPV6ChainedHeader(&pIpv6HdrScanContext, &ucHeaderType, &bDone, &usPayloadLength);
+		pucNextHeader = GetNextIPV6ChainedHeader(&pIpv6HdrScanContext,
+					&ucHeaderType, &bDone, &usPayloadLength);
 		if (bDone) {
-			if ((ucHeaderType == TCP_HEADER_TYPE) || (ucHeaderType == UDP_HEADER_TYPE)) {
-				 *pusSrcPort = *((PUSHORT)(pucNextHeader));
-				 *pusDestPort = *((PUSHORT)(pucNextHeader+2));
-				 BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, " \nProtocol Ports - Src Port :0x%x Dest Port : 0x%x", ntohs(*pusSrcPort), ntohs(*pusDestPort));
+			if ((ucHeaderType == TCP_HEADER_TYPE) ||
+				(ucHeaderType == UDP_HEADER_TYPE)) {
+				*pusSrcPort = *((PUSHORT)(pucNextHeader));
+				*pusDestPort = *((PUSHORT)(pucNextHeader+2));
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG,
+						DBG_LVL_ALL,
+						"\nProtocol Ports - Src Port :0x%x Dest Port : 0x%x",
+						ntohs(*pusSrcPort),
+						ntohs(*pusDestPort));
 			}
 			break;
 
@@ -167,7 +190,8 @@ USHORT	IpVersion6(PMINI_ADAPTER Adapter, PVOID pcIpHeader,
 	IPV6Header *pstIpv6Header = NULL;
 	BOOLEAN bClassificationSucceed = FALSE;
 
-	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "IpVersion6 ==========>\n");
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG,
+			DBG_LVL_ALL, "IpVersion6 ==========>\n");
 
 	pstIpv6Header = (IPV6Header *)pcIpHeader;
 
@@ -200,11 +224,13 @@ USHORT	IpVersion6(PMINI_ADAPTER Adapter, PVOID pcIpHeader,
 			break;
 		}
 
-		bClassificationSucceed = MatchSrcIpv6Address(pstClassifierRule, pstIpv6Header);
+		bClassificationSucceed = MatchSrcIpv6Address(pstClassifierRule,
+								pstIpv6Header);
 		if (!bClassificationSucceed)
 			break;
 
-		bClassificationSucceed = MatchDestIpv6Address(pstClassifierRule, pstIpv6Header);
+		bClassificationSucceed = MatchDestIpv6Address(pstClassifierRule,
+								pstIpv6Header);
 		if (!bClassificationSucceed)
 			break;
 
@@ -213,27 +239,38 @@ USHORT	IpVersion6(PMINI_ADAPTER Adapter, PVOID pcIpHeader,
 		 * For IPv6 the next protocol at end of
 		 * Chain of IPv6 prot headers
 		 */
-		bClassificationSucceed = MatchProtocol(pstClassifierRule, ucNextProtocolAboveIP);
+		bClassificationSucceed = MatchProtocol(pstClassifierRule,
+							ucNextProtocolAboveIP);
 		if (!bClassificationSucceed)
 			break;
 
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Protocol Matched");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG,
+				DBG_LVL_ALL, "\nIPv6 Protocol Matched");
 
-		if ((ucNextProtocolAboveIP == TCP_HEADER_TYPE) || (ucNextProtocolAboveIP == UDP_HEADER_TYPE)) {
+		if ((ucNextProtocolAboveIP == TCP_HEADER_TYPE) ||
+			(ucNextProtocolAboveIP == UDP_HEADER_TYPE)) {
 			/* Match Src Port */
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Source Port:%x\n", ntohs(ushSrcPort));
-			bClassificationSucceed = MatchSrcPort(pstClassifierRule, ntohs(ushSrcPort));
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG,
+					DBG_LVL_ALL, "\nIPv6 Source Port:%x\n",
+					ntohs(ushSrcPort));
+			bClassificationSucceed = MatchSrcPort(pstClassifierRule,
+							ntohs(ushSrcPort));
 			if (!bClassificationSucceed)
 				break;
 
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Src Port Matched");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG,
+					DBG_LVL_ALL, "\nIPv6 Src Port Matched");
 
 			/* Match Dest Port */
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Destination Port:%x\n", ntohs(ushDestPort));
-			bClassificationSucceed = MatchDestPort(pstClassifierRule, ntohs(ushDestPort));
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG,
+					DBG_LVL_ALL, "\nIPv6 Destination Port:%x\n",
+					ntohs(ushDestPort));
+			bClassificationSucceed = MatchDestPort(pstClassifierRule,
+							ntohs(ushDestPort));
 			if (!bClassificationSucceed)
 				break;
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Dest Port Matched");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG,
+					DBG_LVL_ALL, "\nIPv6 Dest Port Matched");
 		}
 	} while (0);
 
@@ -253,7 +290,8 @@ USHORT	IpVersion6(PMINI_ADAPTER Adapter, PVOID pcIpHeader,
 }
 
 
-static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule, IPV6Header *pstIpv6Header)
+static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,
+	IPV6Header *pstIpv6Header)
 {
 	UINT uiLoopIndex = 0;
 	UINT uiIpv6AddIndex = 0;
@@ -277,11 +315,14 @@ static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule, IPV6Hea
 	}
 
 	for (uiLoopIndex = 0; uiLoopIndex < uiCountIPSrcAddresses; uiLoopIndex += uiIpv6AddrNoLongWords) {
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Src Ipv6 Address In Received Packet : \n ");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL,
+				"\n Src Ipv6 Address In Received Packet :\n ");
 		DumpIpv6Address(aulSrcIP);
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Src Ipv6 Mask In Classifier Rule: \n");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL,
+				"\n Src Ipv6 Mask In Classifier Rule:\n");
 		DumpIpv6Address(&pstClassifierRule->stSrcIpAddress.ulIpv6Mask[uiLoopIndex]);
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Src Ipv6 Address In Classifier Rule : \n");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL,
+				"\n Src Ipv6 Address In Classifier Rule :\n");
 		DumpIpv6Address(&pstClassifierRule->stSrcIpAddress.ulIpv6Addr[uiLoopIndex]);
 
 		for (uiIpv6AddIndex = 0; uiIpv6AddIndex < uiIpv6AddrNoLongWords; uiIpv6AddIndex++) {
@@ -296,7 +337,9 @@ static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule, IPV6Hea
 
 			if (uiIpv6AddIndex ==  uiIpv6AddrNoLongWords-1) {
 				/* Match Found */
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Ipv6 Src Ip Address Matched\n");
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG,
+						DBG_LVL_ALL,
+						"Ipv6 Src Ip Address Matched\n");
 				return TRUE;
 			}
 		}
@@ -304,7 +347,8 @@ static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule, IPV6Hea
 	return FALSE;
 }
 
-static BOOLEAN MatchDestIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule, IPV6Header *pstIpv6Header)
+static BOOLEAN MatchDestIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,
+	IPV6Header *pstIpv6Header)
 {
 	UINT uiLoopIndex = 0;
 	UINT uiIpv6AddIndex = 0;
@@ -329,11 +373,14 @@ static BOOLEAN MatchDestIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule, IPV6He
 	}
 
 	for (uiLoopIndex = 0; uiLoopIndex < uiCountIPDestinationAddresses; uiLoopIndex += uiIpv6AddrNoLongWords) {
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Destination Ipv6 Address In Received Packet : \n ");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL,
+				"\n Destination Ipv6 Address In Received Packet :\n ");
 		DumpIpv6Address(aulDestIP);
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Destination Ipv6 Mask In Classifier Rule: \n");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL,
+				"\n Destination Ipv6 Mask In Classifier Rule :\n");
 		DumpIpv6Address(&pstClassifierRule->stDestIpAddress.ulIpv6Mask[uiLoopIndex]);
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Destination Ipv6 Address In Classifier Rule : \n");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL,
+				"\n Destination Ipv6 Address In Classifier Rule :\n");
 		DumpIpv6Address(&pstClassifierRule->stDestIpAddress.ulIpv6Addr[uiLoopIndex]);
 
 		for (uiIpv6AddIndex = 0; uiIpv6AddIndex < uiIpv6AddrNoLongWords; uiIpv6AddIndex++) {
@@ -348,7 +395,9 @@ static BOOLEAN MatchDestIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule, IPV6He
 
 			if (uiIpv6AddIndex ==  uiIpv6AddrNoLongWords-1) {
 				/* Match Found */
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Ipv6 Destination Ip Address Matched\n");
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG,
+						DBG_LVL_ALL,
+						"Ipv6 Destination Ip Address Matched\n");
 				return TRUE;
 			}
 		}
@@ -363,7 +412,8 @@ VOID DumpIpv6Address(ULONG *puIpv6Address)
 	UINT uiIpv6AddIndex = 0;
 	PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
 	for (uiIpv6AddIndex = 0; uiIpv6AddIndex < uiIpv6AddrNoLongWords; uiIpv6AddIndex++) {
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, ":%lx", puIpv6Address[uiIpv6AddIndex]);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL,
+				":%lx", puIpv6Address[uiIpv6AddIndex]);
 	}
 
 }
@@ -373,23 +423,33 @@ static VOID DumpIpv6Header(IPV6Header *pstIpv6Header)
 	UCHAR ucVersion;
 	UCHAR ucPrio;
 	PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
-	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "----Ipv6 Header---");
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL,
+			"----Ipv6 Header---");
 	ucVersion = pstIpv6Header->ucVersionPrio & 0xf0;
-	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Version : %x \n", ucVersion);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL,
+			"Version : %x\n", ucVersion);
 	ucPrio = pstIpv6Header->ucVersionPrio & 0x0f;
-	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Priority : %x \n", ucPrio);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL,
+			"Priority : %x\n", ucPrio);
 	/*
 	 * BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL,
-	 * "Flow Label : %x \n",(pstIpv6Header->ucVersionPrio &0xf0);
+	 * "Flow Label : %x\n",(pstIpv6Header->ucVersionPrio &0xf0);
 	 */
-	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Payload Length : %x \n", ntohs(pstIpv6Header->usPayloadLength));
-	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Next Header : %x \n", pstIpv6Header->ucNextHeader);
-	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Hop Limit : %x \n", pstIpv6Header->ucHopLimit);
-	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Src Address :\n");
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL,
+			"Payload Length : %x\n",
+			ntohs(pstIpv6Header->usPayloadLength));
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL,
+			"Next Header : %x\n", pstIpv6Header->ucNextHeader);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL,
+			"Hop Limit : %x\n", pstIpv6Header->ucHopLimit);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL,
+			"Src Address :\n");
 	DumpIpv6Address(pstIpv6Header->ulSrcIpAddress);
-	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Dest Address :\n");
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL,
+			"Dest Address :\n");
 	DumpIpv6Address(pstIpv6Header->ulDestIpAddress);
-	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "----Ipv6 Header End---");
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL,
+			"----Ipv6 Header End---");
 
 
 }
-- 
1.7.3.4

