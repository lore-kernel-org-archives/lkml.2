Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab2DCLfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 07:35:05 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55291 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab2DCLfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 07:35:01 -0400
From: Max Tottenham <mtottenh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Max Tottenham <mtottenh@gmail.com>
Subject: [PATCH 6/8] Staging: bcm: IPv6Protocol.c coding style fix
Date: Tue,  3 Apr 2012 12:35:29 +0100
Message-Id: <1333452931-3195-6-git-send-email-mtottenh@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1333452931-3195-1-git-send-email-mtottenh@gmail.com>
References: <1333452931-3195-1-git-send-email-mtottenh@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sixth in a series of patche to fix coding style in IPv6Protocol.c
This patch changes the format of if statments from:
	if (#VALUE == variable)
to:
	if (variable == #VALUE)

Signed-off-by: Max Tottenham <mtottenh@gmail.com>
---
 drivers/staging/bcm/IPv6Protocol.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/bcm/IPv6Protocol.c b/drivers/staging/bcm/IPv6Protocol.c
index 80173e7..0f87119 100644
--- a/drivers/staging/bcm/IPv6Protocol.c
+++ b/drivers/staging/bcm/IPv6Protocol.c
@@ -11,7 +11,7 @@ static UCHAR *GetNextIPV6ChainedHeader(UCHAR **ppucPayload, UCHAR *pucNextHeader
 	USHORT  usNextHeaderOffset = 0 ;
 	PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
 
-	if ((NULL == ppucPayload) || (*pusPayloadLength == 0) ||
+	if ((ppucPayload == NULL) || (*pusPayloadLength == 0) ||
 		(*bParseDone)) {
 		*bParseDone = TRUE;
 		return NULL;
@@ -184,7 +184,7 @@ USHORT	IpVersion6(PMINI_ADAPTER Adapter, PVOID pcIpHeader,
 							pstIpv6Header->ucNextHeader);
 
 	do {
-		if (0 == pstClassifierRule->ucDirection) {
+		if (pstClassifierRule->ucDirection == 0) {
 			/*
 			 * cannot be processed for classification.
 			 * it is a down link connection
@@ -237,13 +237,13 @@ USHORT	IpVersion6(PMINI_ADAPTER Adapter, PVOID pcIpHeader,
 		}
 	} while (0);
 
-	if (TRUE == bClassificationSucceed) {
+	if (bClassificationSucceed == TRUE) {
 		INT iMatchedSFQueueIndex = 0;
 		iMatchedSFQueueIndex = SearchSfid(Adapter, pstClassifierRule->ulSFID);
 		if (iMatchedSFQueueIndex >= NO_OF_QUEUES) {
 			bClassificationSucceed = FALSE;
 		} else {
-			if (FALSE == Adapter->PackInfo[iMatchedSFQueueIndex].bActive) {
+			if (Adapter->PackInfo[iMatchedSFQueueIndex].bActive == FALSE) {
 				bClassificationSucceed = FALSE;
 			}
 		}
@@ -267,7 +267,7 @@ static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule, IPV6Hea
 	UINT  uiCountIPSrcAddresses = (UINT)pstClassifierRule->ucIPSourceAddressLength;
 
 
-	if (0 == uiCountIPSrcAddresses)
+	if (uiCountIPSrcAddresses == 0)
 		return TRUE;
 
 
@@ -319,7 +319,7 @@ static BOOLEAN MatchDestIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule, IPV6He
 	UINT  uiCountIPDestinationAddresses = (UINT)pstClassifierRule->ucIPDestinationAddressLength;
 
 
-	if (0 == uiCountIPDestinationAddresses)
+	if (uiCountIPDestinationAddresses == 0)
 		return TRUE;
 
 
-- 
1.7.3.4

