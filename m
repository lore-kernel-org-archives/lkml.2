Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab0CYFTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 01:19:21 -0400
Received: from mail.perches.com ([173.55.12.10]:1088 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556Ab0CYFRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 01:17:31 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH 05/13] drivers/staging/rt2860: Hoist assign from if
Date: Wed, 24 Mar 2010 22:16:59 -0700
Message-Id: <5840ed168f4039dc8c17d6d5eec26435e0bd9ade.1269493047.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <cover.1269493047.git.joe@perches.com>
References: <cover.1269493047.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/rt2860/common/cmm_data.c |    6 ++++--
 drivers/staging/rt2860/common/cmm_wpa.c  |   18 ++++++++----------
 drivers/staging/rt2860/common/spectrum.c |    7 ++++---
 drivers/staging/rt2860/pci_main_dev.c    |    6 ++++--
 drivers/staging/rt2860/rt_linux.c        |    7 ++++---
 5 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/rt2860/common/cmm_data.c b/drivers/staging/rt2860/common/cmm_data.c
index 68263ce..65b00e6 100644
--- a/drivers/staging/rt2860/common/cmm_data.c
+++ b/drivers/staging/rt2860/common/cmm_data.c
@@ -773,7 +773,8 @@ void RTMPDeQueuePacket(struct rt_rtmp_adapter *pAd, IN BOOLEAN bIntContext, u8 Q
 
 			/* probe the Queue Head */
 			pQueue = &pAd->TxSwQueue[QueIdx];
-			if ((pEntry = pQueue->Head) == NULL) {
+			pEntry = pQueue->Head;
+			if (pEntry == NULL) {
 				DEQUEUE_UNLOCK(&pAd->irq_lock, bIntContext,
 					       IrqFlags);
 				break;
@@ -824,7 +825,8 @@ void RTMPDeQueuePacket(struct rt_rtmp_adapter *pAd, IN BOOLEAN bIntContext, u8 Q
 				}
 
 				do {
-					if ((pEntry = pQueue->Head) == NULL)
+					pEntry = pQueue->Head;
+					if (pEntry == NULL)
 						break;
 
 					/* For TX_AMSDU_FRAME/TX_RALINK_FRAME, Need to check if next pakcet can do aggregation. */
diff --git a/drivers/staging/rt2860/common/cmm_wpa.c b/drivers/staging/rt2860/common/cmm_wpa.c
index 94e119f..c16f376 100644
--- a/drivers/staging/rt2860/common/cmm_wpa.c
+++ b/drivers/staging/rt2860/common/cmm_wpa.c
@@ -2928,25 +2928,23 @@ void WpaShowAllsuite(u8 *rsnie, u32 rsnie_len)
 	hex_dump("RSNIE", rsnie, rsnie_len);
 
 	/* group cipher */
-	if ((pSuite =
-	     GetSuiteFromRSNIE(rsnie, rsnie_len, GROUP_SUITE,
-			       &count)) != NULL) {
+	pSuite = GetSuiteFromRSNIE(rsnie, rsnie_len, GROUP_SUITE, &count);
+	if (pSuite != NULL) {
 		hex_dump("group cipher", pSuite, 4 * count);
 	}
 	/* pairwise cipher */
-	if ((pSuite =
-	     GetSuiteFromRSNIE(rsnie, rsnie_len, PAIRWISE_SUITE,
-			       &count)) != NULL) {
+	pSuite = GetSuiteFromRSNIE(rsnie, rsnie_len, PAIRWISE_SUITE, &count);
+	if (pSuite != NULL) {
 		hex_dump("pairwise cipher", pSuite, 4 * count);
 	}
 	/* AKM */
-	if ((pSuite =
-	     GetSuiteFromRSNIE(rsnie, rsnie_len, AKM_SUITE, &count)) != NULL) {
+	pSuite = GetSuiteFromRSNIE(rsnie, rsnie_len, AKM_SUITE, &count);
+	if (pSuite != NULL) {
 		hex_dump("AKM suite", pSuite, 4 * count);
 	}
 	/* PMKID */
-	if ((pSuite =
-	     GetSuiteFromRSNIE(rsnie, rsnie_len, PMKID_LIST, &count)) != NULL) {
+	pSuite = GetSuiteFromRSNIE(rsnie, rsnie_len, PMKID_LIST, &count);
+	if (pSuite != NULL) {
 		hex_dump("PMKID", pSuite, LEN_PMKID);
 	}
 
diff --git a/drivers/staging/rt2860/common/spectrum.c b/drivers/staging/rt2860/common/spectrum.c
index 51e38d8..2d5f847 100644
--- a/drivers/staging/rt2860/common/spectrum.c
+++ b/drivers/staging/rt2860/common/spectrum.c
@@ -1900,8 +1900,8 @@ static void PeerMeasureReportAction(struct rt_rtmp_adapter *pAd,
 /*      if (pAd->CommonCfg.bIEEE80211H != TRUE) */
 /*              return; */
 
-	if ((pMeasureReportInfo =
-	     kmalloc(sizeof(struct rt_measure_rpi_report), GFP_ATOMIC)) == NULL) {
+	pMeasureReportInfo = kmalloc(sizeof(struct rt_measure_rpi_report), GFP_ATOMIC);
+	if (pMeasureReportInfo == NULL) {
 		DBGPRINT(RT_DEBUG_ERROR,
 			 ("%s unable to alloc memory for measure report buffer (size=%zu).\n",
 			  __func__, sizeof(struct rt_measure_rpi_report)));
@@ -2016,7 +2016,8 @@ static void PeerTpcRepAction(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_e
 	NdisZeroMemory(&TpcRepInfo, sizeof(struct rt_tpc_report_info));
 	if (PeerTpcRepSanity
 	    (pAd, Elem->Msg, Elem->MsgLen, &DialogToken, &TpcRepInfo)) {
-		if ((pEntry = TpcReqLookUp(pAd, DialogToken)) != NULL) {
+		pEntry = TpcReqLookUp(pAd, DialogToken);
+		if (pEntry != NULL) {
 			TpcReqDelete(pAd, pEntry->DialogToken);
 			DBGPRINT(RT_DEBUG_TRACE,
 				 ("%s: DialogToken=%x, TxPwr=%d, LinkMargin=%d\n",
diff --git a/drivers/staging/rt2860/pci_main_dev.c b/drivers/staging/rt2860/pci_main_dev.c
index 6af4304..4271bcd 100644
--- a/drivers/staging/rt2860/pci_main_dev.c
+++ b/drivers/staging/rt2860/pci_main_dev.c
@@ -280,7 +280,8 @@ static int __devinit rt2860_probe(IN struct pci_dev *pci_dev,
 
 /*PCIDevInit============================================== */
 	/* wake up and enable device */
-	if ((rv = pci_enable_device(pci_dev)) != 0) {
+	rv = pci_enable_device(pci_dev);
+	if (rv != 0) {
 		DBGPRINT(RT_DEBUG_ERROR,
 			 ("Enable PCI device failed, errno=%d!\n", rv));
 		return rv;
@@ -288,7 +289,8 @@ static int __devinit rt2860_probe(IN struct pci_dev *pci_dev,
 
 	print_name = (char *)pci_name(pci_dev);
 
-	if ((rv = pci_request_regions(pci_dev, print_name)) != 0) {
+	rv = pci_request_regions(pci_dev, print_name);
+	if (rv != 0) {
 		DBGPRINT(RT_DEBUG_ERROR,
 			 ("Request PCI resource failed, errno=%d!\n", rv));
 		goto err_out;
diff --git a/drivers/staging/rt2860/rt_linux.c b/drivers/staging/rt2860/rt_linux.c
index b5c78ae..b5214eb 100644
--- a/drivers/staging/rt2860/rt_linux.c
+++ b/drivers/staging/rt2860/rt_linux.c
@@ -462,8 +462,8 @@ void *duplicate_pkt(struct rt_rtmp_adapter *pAd,
 	struct sk_buff *skb;
 	void *pPacket = NULL;
 
-	if ((skb =
-	     __dev_alloc_skb(HdrLen + DataSize + 2, MEM_ALLOC_FLAG)) != NULL) {
+	skb = __dev_alloc_skb(HdrLen + DataSize + 2, MEM_ALLOC_FLAG);
+	if (skb != NULL) {
 		skb_reserve(skb, 2);
 		NdisMoveMemory(skb_tail_pointer(skb), pHeader802_3, HdrLen);
 		skb_put(skb, HdrLen);
@@ -672,7 +672,8 @@ void RTMPSendWirelessEvent(struct rt_rtmp_adapter *pAd,
 		return;
 	}
 	/*Allocate memory and copy the msg. */
-	if ((pBuf = kmalloc(IW_CUSTOM_MAX_LEN, GFP_ATOMIC)) != NULL) {
+	pBuf = kmalloc(IW_CUSTOM_MAX_LEN, GFP_ATOMIC);
+	if (pBuf != NULL) {
 		/*Prepare the payload */
 		memset(pBuf, 0, IW_CUSTOM_MAX_LEN);
 
-- 
1.7.0.14.g7e948

