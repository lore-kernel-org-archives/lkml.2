Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935526Ab0HFKoI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 06:44:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47371 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934650Ab0HFKoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 06:44:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=E5XxHf1bE/txrHYeDoU7cPIleORAccOD9bZB7iROaLLJsnwHtFeulAZg/rLx2JkouA
         QosnWpQX7rADDdDbxjfdfCpbbouzsmVRBPX2igmbFALdgS1pLYlfCqGUir5b7qFk5sao
         lxRFDTJYQAdOm9uKfz7rj/Y/893nTRiCEvLNI=
From: Neil Munro <neilmunro@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Niadh <neilmunro@gmail.com>
Subject: [PATCH 985/985] Staging: RT2860: Fixed All errors in rt_linux.h
Date: Fri,  6 Aug 2010 11:49:50 +0100
Message-Id: <1281091790-3721-1-git-send-email-neilmunro@gmail.com>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Niadh <neilmunro@gmail.com>

Removed all errors from this file the warnings however remain.

Signed-off-by: Neil Munro <neilmunro@gmail.com>
---
 drivers/staging/rt2860/rt_linux.h |  126 +++++++++++++++++-------------------
 1 files changed, 60 insertions(+), 66 deletions(-)

diff --git a/drivers/staging/rt2860/rt_linux.h b/drivers/staging/rt2860/rt_linux.h
index b370fb2..80a7ed8 100644
--- a/drivers/staging/rt2860/rt_linux.h
+++ b/drivers/staging/rt2860/rt_linux.h
@@ -101,20 +101,19 @@ extern const struct iw_handler_def rt28xx_iw_handler_def;
 /***********************************************************************************
  *	OS Specific definitions and data structures
  ***********************************************************************************/
-typedef int (*HARD_START_XMIT_FUNC) (struct sk_buff * skb,
-				     struct net_device * net_dev);
+typedef int (*HARD_START_XMIT_FUNC) (struct sk_buff *skb,
+				     struct net_device *net_dev);

 #ifdef RTMP_MAC_PCI
 #ifndef PCI_DEVICE
-#define PCI_DEVICE(vend,dev) \
+#define PCI_DEVICE(vend, dev) \
 	.vendor = (vend), .device = (dev), \
 	.subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID
 #endif /* PCI_DEVICE // */
 #endif /* RTMP_MAC_PCI // */

 #define RT_MOD_INC_USE_COUNT() \
-	if (!try_module_get(THIS_MODULE)) \
-	{ \
+	if (!try_module_get(THIS_MODULE)) {\
 		DBGPRINT(RT_DEBUG_ERROR, ("%s: cannot reserve module\n", __func__)); \
 		return -1; \
 	}
@@ -142,8 +141,8 @@ struct iw_statistics *rt28xx_get_wireless_stats(IN struct net_device *net_dev);
 #define NDIS_STATUS_INVALID_DATA				0x02
 #define NDIS_STATUS_RESOURCES                   0x03

-#define NDIS_SET_PACKET_STATUS(_p, _status)			do{} while(0)
-#define NdisWriteErrorLogEntry(_a, _b, _c, _d)		do{} while(0)
+#define NDIS_SET_PACKET_STATUS (_p, _status)			do {} while (0)
+#define NdisWriteErrorLogEntry (_a, _b, _c, _d)		do {} while (0)

 /* statistics counter */
 #define STATS_INC_RX_PACKETS(_pAd, _dev)
@@ -207,7 +206,7 @@ struct os_lock {
 }

 #define NdisFreeSpinLock(lock)          \
-	do{}while(0)
+	do {} while (0)

 #define RTMP_SEM_LOCK(__lock)					\
 {												\
@@ -249,32 +248,32 @@ struct os_lock {
 #ifndef wait_event_interruptible_timeout
 #define __wait_event_interruptible_timeout(wq, condition, ret) \
 do { \
-        wait_queue_t __wait; \
-        init_waitqueue_entry(&__wait, current); \
-        add_wait_queue(&wq, &__wait); \
-        for (;;) { \
-                set_current_state(TASK_INTERRUPTIBLE); \
-                if (condition) \
-                        break; \
-                if (!signal_pending(current)) { \
-                        ret = schedule_timeout(ret); \
-                        if (!ret) \
-                                break; \
-                        continue; \
-                } \
-                ret = -ERESTARTSYS; \
-                break; \
-        } \
-        current->state = TASK_RUNNING; \
-        remove_wait_queue(&wq, &__wait); \
+	wait_queue_t __wait; \
+	init_waitqueue_entry(&__wait, current); \
+	add_wait_queue(&wq, &__wait); \
+	for (;;) { \
+		set_current_state(TASK_INTERRUPTIBLE); \
+		if (condition) \
+			break; \
+		if (!signal_pending(current)) { \
+			ret = schedule_timeout(ret); \
+			if (!ret) \
+				break; \
+			continue; \
+		} \
+		ret = -ERESTARTSYS; \
+		break; \
+	} \
+	current->state = TASK_RUNNING; \
+	remove_wait_queue(&wq, &__wait); \
 } while (0)

 #define wait_event_interruptible_timeout(wq, condition, timeout) \
 ({ \
-        long __ret = timeout; \
-        if (!(condition)) \
-                __wait_event_interruptible_timeout(wq, condition, __ret); \
-        __ret; \
+	long __ret = timeout; \
+	if (!(condition)) \
+		__wait_event_interruptible_timeout(wq, condition, __ret); \
+	__ret; \
 })
 #endif

@@ -289,8 +288,7 @@ do { \
 		wait_event_interruptible(_pTask->kthread_q, \
 								 _pTask->kthread_running || kthread_should_stop()); \
 		_pTask->kthread_running = FALSE; \
-		if (kthread_should_stop()) \
-		{ \
+		if (kthread_should_stop()) {\
 			RTMP_SET_FLAG(_pAd, fRTMP_ADAPTER_HALT_IN_PROGRESS); \
 			break; \
 		} \
@@ -299,13 +297,12 @@ do { \

 #ifdef KTHREAD_SUPPORT
 #define WAKE_UP(_pTask) \
-	do{ \
-		if ((_pTask)->kthread_task) \
-        { \
+	do { \
+		if ((_pTask)->kthread_task) {\
 			(_pTask)->kthread_running = TRUE; \
-	        wake_up(&(_pTask)->kthread_q); \
+			wake_up(&(_pTask)->kthread_q); \
 		} \
-	}while(0)
+	} while (0)
 #endif

 /***********************************************************************************
@@ -349,23 +346,23 @@ typedef void (*TIMER_FUNCTION) (unsigned long);
 	long _loop = ((_time)/(1000/OS_HZ)) > 0 ? ((_time)/(1000/OS_HZ)) : 1;\
 	wait_queue_head_t _wait; \
 	init_waitqueue_head(&_wait); \
-	for (_i=0; _i<(_loop); _i++) \
+	for (_i = 0; _i < (_loop); _i++) \
 		wait_event_interruptible_timeout(_wait, 0, ONE_TICK); }

-#define RTMP_TIME_AFTER(a,b)		\
+#define RTMP_TIME_AFTER(a , b)		\
 	(typecheck(unsigned long, (unsigned long)a) && \
 	 typecheck(unsigned long, (unsigned long)b) && \
 	 ((long)(b) - (long)(a) < 0))

-#define RTMP_TIME_AFTER_EQ(a,b)	\
+#define RTMP_TIME_AFTER_EQ(a , b)	\
 	(typecheck(unsigned long, (unsigned long)a) && \
 	 typecheck(unsigned long, (unsigned long)b) && \
 	 ((long)(a) - (long)(b) >= 0))
-#define RTMP_TIME_BEFORE(a,b)	RTMP_TIME_AFTER_EQ(b,a)
+#define RTMP_TIME_BEFORE(a , b)	RTMP_TIME_AFTER_EQ(b , a)

 #define ONE_TICK 1

-static inline void NdisGetSystemUpTime(unsigned long * time)
+static inline void NdisGetSystemUpTime(unsigned long *time)
 {
 	*time = jiffies;
 }
@@ -416,12 +413,11 @@ struct os_cookie {
 extern unsigned long RTDebugLevel;

 #define DBGPRINT_RAW(Level, Fmt)    \
-do{                                   \
-    if (Level <= RTDebugLevel)      \
-    {                               \
-        printk Fmt;               \
+do {                                   \
+    if (Level <= RTDebugLevel) {     \
+	printk Fmt;               \
     }                               \
-}while(0)
+} while (0)

 #define DBGPRINT(Level, Fmt)    DBGPRINT_RAW(Level, Fmt)

@@ -517,8 +513,7 @@ void linux_pci_unmap_single(struct rt_rtmp_adapter *pAd, dma_addr_t dma_addr,
 /*Patch for ASIC turst read/write bug, needs to remove after metel fix */
 #define RTMP_IO_READ32(_A, _R, _pV)								\
 {																\
-    if ((_A)->bPCIclkOff == FALSE)                                  \
-    {                                                               \
+    if ((_A)->bPCIclkOff == FALSE) {                                 \
 		(*_pV = readl((void *)((_A)->CSRBaseAddress + MAC_CSR0)));		\
 		(*_pV = readl((void *)((_A)->CSRBaseAddress + (_R))));			\
     }                                                               \
@@ -539,8 +534,7 @@ void linux_pci_unmap_single(struct rt_rtmp_adapter *pAd, dma_addr_t dma_addr,
 }
 #define RTMP_IO_WRITE32(_A, _R, _V)												\
 {																				\
-    if ((_A)->bPCIclkOff == FALSE)                                  \
-    {                                                               \
+    if ((_A)->bPCIclkOff == FALSE) {                                 \
 	u32 Val;																\
 	Val = readl((void *)((_A)->CSRBaseAddress + MAC_CSR0));			\
 	writel((_V), (void *)((_A)->CSRBaseAddress + (_R)));								\
@@ -632,7 +626,7 @@ void linux_pci_unmap_single(struct rt_rtmp_adapter *pAd, dma_addr_t dma_addr,

 #define RELEASE_NDIS_PACKET(_pAd, _pPacket, _Status)                    \
 {                                                                       \
-        RTMPFreeNdisPacket(_pAd, _pPacket);                             \
+	RTMPFreeNdisPacket(_pAd, _pPacket);                             \
 }

 /*
@@ -745,65 +739,65 @@ void linux_pci_unmap_single(struct rt_rtmp_adapter *pAd, dma_addr_t dma_addr,

 /*DHCP */
 #define RTMP_SET_PACKET_DHCP(_p, _flg)   													\
-			do{																				\
+			do {																				\
 				if (_flg)																	\
 					(RTPKT_TO_OSPKT(_p)->cb[CB_OFF+11]) |= (RTMP_PACKET_SPECIFIC_DHCP);		\
 				else																		\
 					(RTPKT_TO_OSPKT(_p)->cb[CB_OFF+11]) &= (!RTMP_PACKET_SPECIFIC_DHCP);	\
-			}while(0)
+			} while (0)
 #define RTMP_GET_PACKET_DHCP(_p)		(RTPKT_TO_OSPKT(_p)->cb[CB_OFF+11] & RTMP_PACKET_SPECIFIC_DHCP)

 /*EAPOL */
 #define RTMP_SET_PACKET_EAPOL(_p, _flg)   													\
-			do{																				\
+			do {																				\
 				if (_flg)																	\
 					(RTPKT_TO_OSPKT(_p)->cb[CB_OFF+11]) |= (RTMP_PACKET_SPECIFIC_EAPOL);		\
 				else																		\
 					(RTPKT_TO_OSPKT(_p)->cb[CB_OFF+11]) &= (!RTMP_PACKET_SPECIFIC_EAPOL);	\
-			}while(0)
+			} while (0)
 #define RTMP_GET_PACKET_EAPOL(_p)		(RTPKT_TO_OSPKT(_p)->cb[CB_OFF+11] & RTMP_PACKET_SPECIFIC_EAPOL)

 /*WAI */
 #define RTMP_SET_PACKET_WAI(_p, _flg)   													\
-			do{																				\
+			do {																				\
 				if (_flg)																	\
 					(RTPKT_TO_OSPKT(_p)->cb[CB_OFF+11]) |= (RTMP_PACKET_SPECIFIC_WAI);		\
 				else																		\
 					(RTPKT_TO_OSPKT(_p)->cb[CB_OFF+11]) &= (!RTMP_PACKET_SPECIFIC_WAI);	\
-			}while(0)
+			} while (0)
 #define RTMP_GET_PACKET_WAI(_p)		(RTPKT_TO_OSPKT(_p)->cb[CB_OFF+11] & RTMP_PACKET_SPECIFIC_WAI)

 #define RTMP_GET_PACKET_LOWRATE(_p)		(RTPKT_TO_OSPKT(_p)->cb[CB_OFF+11] & (RTMP_PACKET_SPECIFIC_EAPOL | RTMP_PACKET_SPECIFIC_DHCP | RTMP_PACKET_SPECIFIC_WAI))

 /*VLAN */
 #define RTMP_SET_PACKET_VLAN(_p, _flg)   													\
-			do{																				\
+			do {																				\
 				if (_flg)																	\
 					(RTPKT_TO_OSPKT(_p)->cb[CB_OFF+11]) |= (RTMP_PACKET_SPECIFIC_VLAN);		\
 				else																		\
 					(RTPKT_TO_OSPKT(_p)->cb[CB_OFF+11]) &= (!RTMP_PACKET_SPECIFIC_VLAN);	\
-			}while(0)
+			} while (0)
 #define RTMP_GET_PACKET_VLAN(_p)		(RTPKT_TO_OSPKT(_p)->cb[CB_OFF+11] & RTMP_PACKET_SPECIFIC_VLAN)

 /*LLC/SNAP */
 #define RTMP_SET_PACKET_LLCSNAP(_p, _flg)   													\
-			do{																				\
+			do {																				\
 				if (_flg)																	\
 					(RTPKT_TO_OSPKT(_p)->cb[CB_OFF+11]) |= (RTMP_PACKET_SPECIFIC_LLCSNAP);		\
 				else																		\
 					(RTPKT_TO_OSPKT(_p)->cb[CB_OFF+11]) &= (!RTMP_PACKET_SPECIFIC_LLCSNAP);		\
-			}while(0)
+			} while (0)

 #define RTMP_GET_PACKET_LLCSNAP(_p)		(RTPKT_TO_OSPKT(_p)->cb[CB_OFF+11] & RTMP_PACKET_SPECIFIC_LLCSNAP)

 /* IP */
 #define RTMP_SET_PACKET_IPV4(_p, _flg)														\
-			do{																				\
+			do {																				\
 				if (_flg)																	\
 					(RTPKT_TO_OSPKT(_p)->cb[CB_OFF+11]) |= (RTMP_PACKET_SPECIFIC_IPV4);		\
 				else																		\
 					(RTPKT_TO_OSPKT(_p)->cb[CB_OFF+11]) &= (!RTMP_PACKET_SPECIFIC_IPV4);	\
-			}while(0)
+			} while (0)

 #define RTMP_GET_PACKET_IPV4(_p)		(RTPKT_TO_OSPKT(_p)->cb[CB_OFF+11] & RTMP_PACKET_SPECIFIC_IPV4)

@@ -833,8 +827,8 @@ IRQ_HANDLE_TYPE rt2860_interrupt(int irq, void *dev_instance);

 int rt28xx_sta_ioctl(struct net_device *net_dev, IN OUT struct ifreq *rq, int cmd);

-extern int ra_mtd_write(int num, loff_t to, size_t len, const u_char * buf);
-extern int ra_mtd_read(int num, loff_t from, size_t len, u_char * buf);
+extern int ra_mtd_write(int num, loff_t to, size_t len, const u_char *buf);
+extern int ra_mtd_read(int num, loff_t from, size_t len, u_char *buf);

 #define GET_PAD_FROM_NET_DEV(_pAd, _net_dev)	(_pAd) = (struct rt_rtmp_adapter *)(_net_dev)->ml_priv;

--
1.7.2.1

