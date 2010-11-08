Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab0KHXVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 18:21:54 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19350 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab0KHXVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 18:21:52 -0500
Date: Tue, 9 Nov 2010 00:10:25 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        =?ISO-8859-15?Q?Sebastian_Dalfu=DF?= <sd@sedf.de>,
        Gorskin Ilya <revent82@gmail.com>, Yong Zhang <yong.zhang0@gmail.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 13/17][trivial] staging, rt2860: Remove unnecessary casts of
 void ptr returning alloc function return values
Message-ID: <alpine.LNX.2.00.1011082352190.23697@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The [vk][cmz]alloc(_node) family of functions return void pointers which
it's completely unnecessary/pointless to cast to other pointer types since
that happens implicitly.

This patch removes such casts from drivers/staging/rt2860/


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 common/ba_action.c |   12 ++++++------
 rt_main_dev.c      |    7 ++++---
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/rt2860/common/ba_action.c b/drivers/staging/rt2860/common/ba_action.c
index 8eef82d..ed8854b 100644
--- a/drivers/staging/rt2860/common/ba_action.c
+++ b/drivers/staging/rt2860/common/ba_action.c
@@ -799,8 +799,8 @@ void BAOriSessionTearDown(struct rt_rtmp_adapter *pAd,
 			/* force send specified TID DelBA */
 			struct rt_mlme_delba_req DelbaReq;
 			struct rt_mlme_queue_elem *Elem =
-			    (struct rt_mlme_queue_elem *)kmalloc(sizeof(struct rt_mlme_queue_elem),
-							MEM_ALLOC_FLAG);
+				kmalloc(sizeof(struct rt_mlme_queue_elem),
+					MEM_ALLOC_FLAG);
 			if (Elem != NULL) {
 				NdisZeroMemory(&DelbaReq, sizeof(DelbaReq));
 				NdisZeroMemory(Elem, sizeof(struct rt_mlme_queue_elem));
@@ -839,8 +839,8 @@ void BAOriSessionTearDown(struct rt_rtmp_adapter *pAd,
 	    && (pBAEntry->ORI_BA_Status == Originator_Done)) {
 		struct rt_mlme_delba_req DelbaReq;
 		struct rt_mlme_queue_elem *Elem =
-		    (struct rt_mlme_queue_elem *)kmalloc(sizeof(struct rt_mlme_queue_elem),
-						MEM_ALLOC_FLAG);
+			kmalloc(sizeof(struct rt_mlme_queue_elem),
+				MEM_ALLOC_FLAG);
 		if (Elem != NULL) {
 			NdisZeroMemory(&DelbaReq, sizeof(DelbaReq));
 			NdisZeroMemory(Elem, sizeof(struct rt_mlme_queue_elem));
@@ -908,8 +908,8 @@ void BARecSessionTearDown(struct rt_rtmp_adapter *pAd,
 		/* */
 		if (bPassive == FALSE) {
 			struct rt_mlme_queue_elem *Elem =
-			    (struct rt_mlme_queue_elem *)kmalloc(sizeof(struct rt_mlme_queue_elem),
-							MEM_ALLOC_FLAG);
+				kmalloc(sizeof(struct rt_mlme_queue_elem),
+					MEM_ALLOC_FLAG);
 			if (Elem != NULL) {
 				NdisZeroMemory(&DelbaReq, sizeof(DelbaReq));
 				NdisZeroMemory(Elem, sizeof(struct rt_mlme_queue_elem));
diff --git a/drivers/staging/rt2860/rt_main_dev.c b/drivers/staging/rt2860/rt_main_dev.c
index ad60cea..81671c4 100644
--- a/drivers/staging/rt2860/rt_main_dev.c
+++ b/drivers/staging/rt2860/rt_main_dev.c
@@ -101,8 +101,8 @@ int MainVirtualIF_close(IN struct net_device *net_dev)
 		    (!RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_NIC_NOT_EXIST))) {
 			struct rt_mlme_disassoc_req DisReq;
 			struct rt_mlme_queue_elem *MsgElem =
-			    (struct rt_mlme_queue_elem *)kmalloc(sizeof(struct rt_mlme_queue_elem),
-							MEM_ALLOC_FLAG);
+				kmalloc(sizeof(struct rt_mlme_queue_elem),
+					MEM_ALLOC_FLAG);
 
 			if (MsgElem) {
 				COPY_MAC_ADDR(DisReq.Addr,
@@ -724,7 +724,8 @@ Note:
 int AdapterBlockAllocateMemory(void *handle, void ** ppAd)
 {
 
-	*ppAd = (void *)vmalloc(sizeof(struct rt_rtmp_adapter));	/*pci_alloc_consistent(pci_dev, sizeof(struct rt_rtmp_adapter), phy_addr); */
+	*ppAd = vmalloc(sizeof(struct rt_rtmp_adapter));
+	/* pci_alloc_consistent(pci_dev, sizeof(struct rt_rtmp_adapter), phy_addr); */
 
 	if (*ppAd) {
 		NdisZeroMemory(*ppAd, sizeof(struct rt_rtmp_adapter));



-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

