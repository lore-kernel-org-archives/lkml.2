Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab0CRKDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 06:03:30 -0400
Received: from mail-ew0-f209.google.com ([209.85.219.209]:33673 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab0CRKD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 06:03:28 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Mar 2010 06:03:28 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IrkUZp73sDgamV3ngl1XR59XD1QtpGIKt4Om//7neJAnZUCoJ8l/Ze5VJlmQIyCl6J
         trNA5eq3A0AZ+L3n3CNgh4toKr699Xwt5XASqlE++iXaYTujfLhofSb6HAVclaU59TE/
         XwDFRP2EQe2Z1YvgBLxZ3SgjNvxvXc3Xo3SZ4=
From: Gorskin Ilya <revent82@gmail.com>
To: gregkh@suse.de, bzolnier@gmail.com, sd@sedf.de, jeffm@suse.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Gorskin <revent82@gmail.com>
Subject: [PATCH] Staging:rt2860: fix coding style issue in rt_linux.c
Date: Thu, 18 Mar 2010 14:56:47 +0500
Message-Id: <1268906207-5017-1-git-send-email-revent82@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gorskin <revent82@gmail.com>

Signed-off-by: Gorskin Ilya <revent82@gmail.com>
---
 drivers/staging/rt2860/rt_linux.c |   42 ++++++++++++++++++------------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/rt2860/rt_linux.c b/drivers/staging/rt2860/rt_linux.c
index b5c78ae..ac01b21 100644
--- a/drivers/staging/rt2860/rt_linux.c
+++ b/drivers/staging/rt2860/rt_linux.c
@@ -81,7 +81,7 @@ char const *pWirelessFloodEventText[IW_FLOOD_EVENT_TYPE_NUM] = {
 };
 
 /* timeout -- ms */
-void RTMP_SetPeriodicTimer(struct timer_list * pTimer,
+void RTMP_SetPeriodicTimer(struct timer_list *pTimer,
 			   IN unsigned long timeout)
 {
 	timeout = ((timeout * OS_HZ) / 1000);
@@ -91,7 +91,7 @@ void RTMP_SetPeriodicTimer(struct timer_list * pTimer,
 
 /* convert NdisMInitializeTimer --> RTMP_OS_Init_Timer */
 void RTMP_OS_Init_Timer(struct rt_rtmp_adapter *pAd,
-			struct timer_list * pTimer,
+			struct timer_list *pTimer,
 			IN TIMER_FUNCTION function, void *data)
 {
 	init_timer(pTimer);
@@ -99,7 +99,7 @@ void RTMP_OS_Init_Timer(struct rt_rtmp_adapter *pAd,
 	pTimer->function = function;
 }
 
-void RTMP_OS_Add_Timer(struct timer_list * pTimer,
+void RTMP_OS_Add_Timer(struct timer_list *pTimer,
 		       IN unsigned long timeout)
 {
 	if (timer_pending(pTimer))
@@ -110,14 +110,14 @@ void RTMP_OS_Add_Timer(struct timer_list * pTimer,
 	add_timer(pTimer);
 }
 
-void RTMP_OS_Mod_Timer(struct timer_list * pTimer,
+void RTMP_OS_Mod_Timer(struct timer_list *pTimer,
 		       IN unsigned long timeout)
 {
 	timeout = ((timeout * OS_HZ) / 1000);
 	mod_timer(pTimer, jiffies + timeout);
 }
 
-void RTMP_OS_Del_Timer(struct timer_list * pTimer,
+void RTMP_OS_Del_Timer(struct timer_list *pTimer,
 		       OUT BOOLEAN * pCancelled)
 {
 	if (timer_pending(pTimer)) {
@@ -145,7 +145,7 @@ void RTMPusecDelay(unsigned long usec)
 		udelay(usec % 50);
 }
 
-void RTMP_GetCurrentSystemTime(LARGE_INTEGER * time)
+void RTMP_GetCurrentSystemTime(LARGE_INTEGER *time)
 {
 	time->u.LowPart = jiffies;
 }
@@ -155,9 +155,9 @@ int os_alloc_mem(struct rt_rtmp_adapter *pAd, u8 ** mem, unsigned long size)
 {
 	*mem = (u8 *)kmalloc(size, GFP_ATOMIC);
 	if (*mem)
-		return (NDIS_STATUS_SUCCESS);
+		return NDIS_STATUS_SUCCESS;
 	else
-		return (NDIS_STATUS_FAILURE);
+		return NDIS_STATUS_FAILURE;
 }
 
 /* pAd MUST allow to be NULL */
@@ -166,7 +166,7 @@ int os_free_mem(struct rt_rtmp_adapter *pAd, void *mem)
 
 	ASSERT(mem);
 	kfree(mem);
-	return (NDIS_STATUS_SUCCESS);
+	return NDIS_STATUS_SUCCESS;
 }
 
 void *RtmpOSNetPktAlloc(struct rt_rtmp_adapter *pAd, IN int size)
@@ -175,7 +175,7 @@ void *RtmpOSNetPktAlloc(struct rt_rtmp_adapter *pAd, IN int size)
 	/* Add 2 more bytes for ip header alignment */
 	skb = dev_alloc_skb(size + 2);
 
-	return ((void *)skb);
+	return (void *)skb;
 }
 
 void *RTMP_AllocateFragPacketBuffer(struct rt_rtmp_adapter *pAd,
@@ -200,7 +200,7 @@ void *RTMP_AllocateFragPacketBuffer(struct rt_rtmp_adapter *pAd,
 void *RTMP_AllocateTxPacketBuffer(struct rt_rtmp_adapter *pAd,
 					 unsigned long Length,
 					 IN BOOLEAN Cached,
-					 void ** VirtualAddress)
+					 void **VirtualAddress)
 {
 	struct sk_buff *pkt;
 
@@ -270,7 +270,7 @@ void RTMPFreeAdapter(struct rt_rtmp_adapter *pAd)
 
 BOOLEAN OS_Need_Clone_Packet(void)
 {
-	return (FALSE);
+	return FALSE;
 }
 
 /*
@@ -298,7 +298,7 @@ BOOLEAN OS_Need_Clone_Packet(void)
 int RTMPCloneNdisPacket(struct rt_rtmp_adapter *pAd,
 				IN BOOLEAN pInsAMSDUHdr,
 				void *pInPacket,
-				void ** ppOutPacket)
+				void **ppOutPacket)
 {
 
 	struct sk_buff *pkt;
@@ -327,7 +327,7 @@ int RTMPCloneNdisPacket(struct rt_rtmp_adapter *pAd,
 
 /* the allocated NDIS PACKET must be freed via RTMPFreeNdisPacket() */
 int RTMPAllocateNdisPacket(struct rt_rtmp_adapter *pAd,
-				   void ** ppPacket,
+				   void **ppPacket,
 				   u8 *pHeader,
 				   u32 HeaderLen,
 				   u8 *pData, u32 DataLen)
@@ -390,7 +390,7 @@ int Sniff2BytesFromNdisBuffer(char *pFirstBuffer,
 
 void RTMP_QueryPacketInfo(void *pPacket,
 			  struct rt_packet_info *pPacketInfo,
-			  u8 ** pSrcBufVA, u32 * pSrcBufLen)
+			  u8 **pSrcBufVA, u32 * pSrcBufLen)
 {
 	pPacketInfo->BufferCount = 1;
 	pPacketInfo->pFirstBuffer = (char *)GET_OS_PKT_DATAPTR(pPacket);
@@ -401,9 +401,9 @@ void RTMP_QueryPacketInfo(void *pPacket,
 	*pSrcBufLen = GET_OS_PKT_LEN(pPacket);
 }
 
-void RTMP_QueryNextPacketInfo(void ** ppPacket,
+void RTMP_QueryNextPacketInfo(void **ppPacket,
 			      struct rt_packet_info *pPacketInfo,
-			      u8 ** pSrcBufVA, u32 * pSrcBufLen)
+			      u8 **pSrcBufVA, u32 * pSrcBufLen)
 {
 	void *pPacket = NULL;
 
@@ -588,7 +588,7 @@ rt_get_sg_list_from_packet(void *pPacket, struct rt_rtmp_sg_list *sg)
 	sg->NumberOfElements = 1;
 	sg->Elements[0].Address = GET_OS_PKT_DATAPTR(pPacket);
 	sg->Elements[0].Length = GET_OS_PKT_LEN(pPacket);
-	return (sg);
+	return sg;
 }
 
 void hex_dump(char *str, unsigned char *pSrcBufVA, unsigned int SrcBufLen)
@@ -1061,7 +1061,7 @@ void RtmpOSTaskCustomize(struct rt_rtmp_os_task *pTask)
 
 #ifndef KTHREAD_SUPPORT
 
-	daemonize((char *)& pTask->taskName[0] /*"%s",pAd->net_dev->name */ );
+	daemonize((char *)&pTask->taskName[0] /*"%s",pAd->net_dev->name */);
 
 	allow_signal(SIGTERM);
 	allow_signal(SIGKILL);
@@ -1246,7 +1246,7 @@ void RtmpOSNetDevFree(struct net_device *pNetDev)
 	free_netdev(pNetDev);
 }
 
-int RtmpOSNetDevAlloc(struct net_device ** new_dev_p, u32 privDataSize)
+int RtmpOSNetDevAlloc(struct net_device **new_dev_p, u32 privDataSize)
 {
 	/* assign it as null first. */
 	*new_dev_p = NULL;
@@ -1343,7 +1343,7 @@ struct net_device *RtmpOSNetDevCreate(struct rt_rtmp_adapter *pAd,
 	int status;
 
 	/* allocate a new network device */
-	status = RtmpOSNetDevAlloc(&pNetDev, 0 /*privMemSize */ );
+	status = RtmpOSNetDevAlloc(&pNetDev, 0 /*privMemSize */);
 	if (status != NDIS_STATUS_SUCCESS) {
 		/* allocation fail, exit */
 		DBGPRINT(RT_DEBUG_ERROR,
-- 
1.5.6.5

