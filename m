Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab2DCLec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 07:34:32 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55291 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab2DCLeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 07:34:31 -0400
From: Max Tottenham <mtottenh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Max Tottenham <mtottenh@gmail.com>
Subject: [PATCH 2/8] Staging: bcm: IPv6Protocol.c coding style  fix
Date: Tue,  3 Apr 2012 12:35:25 +0100
Message-Id: <1333452931-3195-2-git-send-email-mtottenh@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1333452931-3195-1-git-send-email-mtottenh@gmail.com>
References: <1333452931-3195-1-git-send-email-mtottenh@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Second in a set of patches to fix coding style in IPv6Protocol.c
This patch changes the commenting style

Signed-off-by: Max Tottenham <mtottenh@gmail.com>
---
 drivers/staging/bcm/IPv6Protocol.c |   74 ++++++++++++++++++++++++------------
 1 files changed, 49 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/bcm/IPv6Protocol.c b/drivers/staging/bcm/IPv6Protocol.c
index cd5f1c3..de513bc 100644
--- a/drivers/staging/bcm/IPv6Protocol.c
+++ b/drivers/staging/bcm/IPv6Protocol.c
@@ -25,7 +25,7 @@ static UCHAR * GetNextIPV6ChainedHeader(UCHAR **ppucPayload,UCHAR *pucNextHeader
 		return NULL;
 	}
 
-	//Get the Nextt Header Type
+	/* Get the Nextt Header Type */
 	*bParseDone = FALSE;
 
 
@@ -154,9 +154,11 @@ static UCHAR GetIpv6ProtocolPorts(UCHAR *pucPayload,USHORT *pusSrcPort,USHORT *p
 }
 
 
-
-USHORT	IpVersion6(PMINI_ADAPTER Adapter, /**< Pointer to the driver control structure */
-					PVOID pcIpHeader, /**<Pointer to the IP Hdr of the packet*/
+/*
+ * Arg 1 PMINI_ADAPTER Adapter is a pointer ot the driver contorl structure
+ * Arg 2 PVOID pcIpHeader is a pointer to the IP header of the packet
+ */
+USHORT	IpVersion6(PMINI_ADAPTER Adapter, PVOID pcIpHeader,
 					S_CLASSIFIER_RULE *pstClassifierRule )
 {
 	USHORT	ushDestPort = 0;
@@ -171,7 +173,10 @@ USHORT	IpVersion6(PMINI_ADAPTER Adapter, /**< Pointer to the driver control stru
 
 	DumpIpv6Header(pstIpv6Header);
 
-	//Try to get the next higher layer protocol and the Ports Nos if TCP or UDP
+	/* 
+	 * Try to get the next higher layer protocol 
+	 * and the Ports Nos if TCP or UDP
+	 */
 	ucNextProtocolAboveIP = GetIpv6ProtocolPorts((UCHAR *)(pcIpHeader + sizeof(IPV6Header)),
 							&ushSrcPort,
 							&ushDestPort,
@@ -180,13 +185,18 @@ USHORT	IpVersion6(PMINI_ADAPTER Adapter, /**< Pointer to the driver control stru
 
 	do {
 		if (0 == pstClassifierRule->ucDirection) {
-			//cannot be processed for classification.
-		   // it is a down link connection
+			/* 
+			 * cannot be processed for classification.
+		   	 * it is a down link connection
+			 */
 			break;
 		}
 
 		if (!pstClassifierRule->bIpv6Protocol) {
-			//We are looking for Ipv6 Classifiers . Lets ignore this classifier and try the next one.
+			/*
+			 * We are looking for Ipv6 Classifiers 
+			 * Lets ignore this classifier and try the next one
+			 */
 			break;
 		}
 
@@ -198,14 +208,18 @@ USHORT	IpVersion6(PMINI_ADAPTER Adapter, /**< Pointer to the driver control stru
 	        if (!bClassificationSucceed)
         	    break;
 
-		//Match the protocol type.For IPv6 the next protocol at end of Chain of IPv6 prot headers
+		/* 
+		 * Match the protocol type.
+		 * For IPv6 the next protocol at end of 
+		 * Chain of IPv6 prot headers
+		 */
 		bClassificationSucceed=MatchProtocol(pstClassifierRule,ucNextProtocolAboveIP);
 	        if (!bClassificationSucceed)
 	            break;
         	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Protocol Matched");
 
 		if ((ucNextProtocolAboveIP == TCP_HEADER_TYPE) || (ucNextProtocolAboveIP == UDP_HEADER_TYPE)) {
-			//Match Src Port
+			/* Match Src Port */
 			BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Source Port:%x\n",ntohs(ushSrcPort));
 			bClassificationSucceed=MatchSrcPort(pstClassifierRule,ntohs(ushSrcPort));
 			if (!bClassificationSucceed)
@@ -213,7 +227,7 @@ USHORT	IpVersion6(PMINI_ADAPTER Adapter, /**< Pointer to the driver control stru
 
 			BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Src Port Matched");
 
-			//Match Dest Port
+			/* Match Dest Port */
 			BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\nIPv6 Destination Port:%x\n",ntohs(ushDestPort));
 			bClassificationSucceed=MatchDestPort(pstClassifierRule,ntohs(ushDestPort));
 			if (!bClassificationSucceed)
@@ -246,9 +260,9 @@ static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,IPV6Head
 	ULONG aulSrcIP[4];
 	PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
 	/*
-	//This is the no. of Src Addresses ie Range of IP Addresses contained
-	//in the classifier rule for which we need to match
-	*/
+	 * This is the no. of Src Addresses ie Range of IP Addresses contained
+	 * in the classifier rule for which we need to match
+	 */
 	UINT  uiCountIPSrcAddresses = (UINT)pstClassifierRule->ucIPSourceAddressLength;
 
 
@@ -256,7 +270,7 @@ static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,IPV6Head
 		return TRUE;
 
 
-	//First Convert the Ip Address in the packet to Host Endian order
+	/* First Convert the Ip Address in the packet to Host Endian order */
 	for (uiIpv6AddIndex = 0; uiIpv6AddIndex<uiIpv6AddrNoLongWords; uiIpv6AddIndex++) {
 		aulSrcIP[uiIpv6AddIndex]=ntohl(pstIpv6Header->ulSrcIpAddress[uiIpv6AddIndex]);
 	}
@@ -272,12 +286,15 @@ static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,IPV6Head
 		for (uiIpv6AddIndex = 0; uiIpv6AddIndex < uiIpv6AddrNoLongWords; uiIpv6AddIndex++) {
 			if ((pstClassifierRule->stSrcIpAddress.ulIpv6Mask[uiLoopIndex+uiIpv6AddIndex] & aulSrcIP[uiIpv6AddIndex])
 				!= pstClassifierRule->stSrcIpAddress.ulIpv6Addr[uiLoopIndex+uiIpv6AddIndex]) {
-				//Match failed for current Ipv6 Address.Try next Ipv6 Address
+				/* 
+				 * Match failed for current Ipv6 Address
+				 * Try next Ipv6 Address
+				 */
 				break;
 			}
 
 			if (uiIpv6AddIndex ==  uiIpv6AddrNoLongWords-1) {
-				//Match Found
+				/* Match Found */
 				BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Ipv6 Src Ip Address Matched\n");
 				return TRUE;
 			}
@@ -293,10 +310,11 @@ static BOOLEAN MatchDestIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,IPV6Hea
 	UINT uiIpv6AddrNoLongWords = 4;
 	ULONG aulDestIP[4];
 	PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
-	/*
-	//This is the no. of Destination Addresses ie Range of IP Addresses contained
-	//in the classifier rule for which we need to match
-	*/
+	/* 
+	 * This is the no. of Destination Addresses 
+	 * ie Range of IP Addresses contained in the classifier rule 
+	 * for which we need to match
+	 */
 	UINT  uiCountIPDestinationAddresses = (UINT)pstClassifierRule->ucIPDestinationAddressLength;
 
 
@@ -304,7 +322,7 @@ static BOOLEAN MatchDestIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,IPV6Hea
 		return TRUE;
 
 
-	//First Convert the Ip Address in the packet to Host Endian order
+	/* First Convert the Ip Address in the packet to Host Endian order */
 	for (uiIpv6AddIndex = 0;uiIpv6AddIndex < uiIpv6AddrNoLongWords; uiIpv6AddIndex++) {
 		aulDestIP[uiIpv6AddIndex]=ntohl(pstIpv6Header->ulDestIpAddress[uiIpv6AddIndex]);
 	}
@@ -320,12 +338,15 @@ static BOOLEAN MatchDestIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,IPV6Hea
 		for (uiIpv6AddIndex = 0; uiIpv6AddIndex < uiIpv6AddrNoLongWords; uiIpv6AddIndex++) {
 			if ((pstClassifierRule->stDestIpAddress.ulIpv6Mask[uiLoopIndex+uiIpv6AddIndex] & aulDestIP[uiIpv6AddIndex])
 				!= pstClassifierRule->stDestIpAddress.ulIpv6Addr[uiLoopIndex+uiIpv6AddIndex]) {
-				//Match failed for current Ipv6 Address.Try next Ipv6 Address
+				/* 
+				 * Match failed for current Ipv6 Address.
+				 * Try next Ipv6 Address
+				 */
 				break;
 			}
 
 			if (uiIpv6AddIndex ==  uiIpv6AddrNoLongWords-1) {
-				//Match Found
+				/* Match Found */
 				BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Ipv6 Destination Ip Address Matched\n");
 				return TRUE;
 			}
@@ -356,7 +377,10 @@ static VOID DumpIpv6Header(IPV6Header *pstIpv6Header)
 	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Version : %x \n",ucVersion);
 	ucPrio = pstIpv6Header->ucVersionPrio & 0x0f;
 	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Priority : %x \n",ucPrio);
-	//BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Flow Label : %x \n",(pstIpv6Header->ucVersionPrio &0xf0);
+	/* 
+	 * BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, 
+	 * "Flow Label : %x \n",(pstIpv6Header->ucVersionPrio &0xf0);
+	 */
 	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Payload Length : %x \n",ntohs(pstIpv6Header->usPayloadLength));
 	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Next Header : %x \n",pstIpv6Header->ucNextHeader);
 	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "Hop Limit : %x \n",pstIpv6Header->ucHopLimit);
-- 
1.7.3.4

