Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab1A1EFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 23:05:06 -0500
Received: from mail.perches.com ([173.55.12.10]:3428 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759Ab1A1EEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 23:04:52 -0500
From: Joe Perches <joe@perches.com>
To: Vipin Mehta <vmehta@atheros.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/15] staging: ath6kl: Remove A_FAILED macro
Date: Thu, 27 Jan 2011 20:04:21 -0800
Message-Id: <9b0c2b1cc02902edc1fe08e01dcb6faef94a6a27.1296186677.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1296186677.git.joe@perches.com>
References: <cover.1296186677.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove obfuscating A_FAILED(foo) macro.
Just test for foo instead.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/ath6kl/bmi/src/bmi.c               |    6 +-
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   |    2 +-
 .../ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c   |    6 +-
 drivers/staging/ath6kl/htc2/AR6000/ar6k.c          |   22 +++++-----
 drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c   |   24 +++++-----
 drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c    |   28 ++++++------
 .../ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c        |   44 ++++++++++----------
 drivers/staging/ath6kl/htc2/htc.c                  |   18 ++++----
 drivers/staging/ath6kl/htc2/htc_recv.c             |   42 +++++++++---------
 drivers/staging/ath6kl/htc2/htc_send.c             |    4 +-
 drivers/staging/ath6kl/htc2/htc_services.c         |    4 +-
 drivers/staging/ath6kl/include/common/athdefs.h    |    2 -
 drivers/staging/ath6kl/miscdrv/ar3kconfig.c        |   36 ++++++++--------
 drivers/staging/ath6kl/miscdrv/common_drv.c        |   18 ++++----
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |   36 ++++++++--------
 drivers/staging/ath6kl/os/linux/ar6000_raw_if.c    |    8 ++--
 drivers/staging/ath6kl/os/linux/ar6k_pal.c         |    6 +-
 drivers/staging/ath6kl/os/linux/hci_bridge.c       |   18 ++++----
 drivers/staging/ath6kl/os/linux/ioctl.c            |    6 +-
 drivers/staging/ath6kl/wmi/wmi.c                   |    6 +-
 20 files changed, 166 insertions(+), 170 deletions(-)

diff --git a/drivers/staging/ath6kl/bmi/src/bmi.c b/drivers/staging/ath6kl/bmi/src/bmi.c
index ccec7c4..355e22b 100644
--- a/drivers/staging/ath6kl/bmi/src/bmi.c
+++ b/drivers/staging/ath6kl/bmi/src/bmi.c
@@ -966,7 +966,7 @@ BMIFastDownload(HIF_DEVICE *device, A_UINT32 address, A_UCHAR *buffer, A_UINT32
     A_UINT32  unalignedBytes = length & 0x3;
 
     status = BMILZStreamStart (device, address);
-    if (A_FAILED(status)) {
+    if (status) {
             return A_ERROR;
     }
 
@@ -977,7 +977,7 @@ BMIFastDownload(HIF_DEVICE *device, A_UINT32 address, A_UCHAR *buffer, A_UINT32
 
     status = BMILZData(device, buffer, lastWordOffset);
 
-    if (A_FAILED(status)) {
+    if (status) {
         return A_ERROR;
     }
 
@@ -990,7 +990,7 @@ BMIFastDownload(HIF_DEVICE *device, A_UINT32 address, A_UCHAR *buffer, A_UINT32
         // Close compressed stream and open a new (fake) one.  This serves mainly to flush Target caches.
         //
         status = BMILZStreamStart (device, 0x00);
-        if (A_FAILED(status)) {
+        if (status) {
            return A_ERROR;
         }
     }
diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
index 56f6a07..26d8a7f 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
@@ -724,7 +724,7 @@ HIFConfigureDevice(HIF_DEVICE *device, HIF_DEVICE_CONFIG_OPCODE opcode,
                 return A_ENOTSUP;    
             }
             status = SetupHIFScatterSupport(device, (HIF_DEVICE_SCATTER_SUPPORT_INFO *)config);
-            if (A_FAILED(status)) {
+            if (status) {
                 device->scatter_enabled = FALSE;           
             }
             break; 
diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
index ceeced4..7ec1f4a 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
@@ -176,7 +176,7 @@ int DoHifReadWriteScatter(HIF_DEVICE *device, BUS_REQUEST *busrequest)
         AR_DEBUG_PRINTF(ATH_DEBUG_ERROR, ("HIF-SCATTER: data error: %d \n",data.error));   
     }
 
-    if (A_FAILED(status)) {
+    if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERROR, ("HIF-SCATTER: FAILED!!! (%s) Address: 0x%X, Block mode (BlockLen: %d, BlockCount: %d)\n",
               (pReq->Request & HIF_WRITE) ? "WRITE":"READ",pReq->Address, data.blksz, data.blocks));        
     }
@@ -265,7 +265,7 @@ static int HifReadWriteScatter(HIF_DEVICE *device, HIF_SCATTER_REQ *pReq)
        
     } while (FALSE);
 
-    if (A_FAILED(status) && (request & HIF_ASYNCHRONOUS)) {
+    if (status && (request & HIF_ASYNCHRONOUS)) {
         pReq->CompletionStatus = status;
         pReq->CompletionRoutine(pReq);
         status = A_OK;
@@ -348,7 +348,7 @@ int SetupHIFScatterSupport(HIF_DEVICE *device, HIF_DEVICE_SCATTER_SUPPORT_INFO *
         
     } while (FALSE);
     
-    if (A_FAILED(status)) {
+    if (status) {
         CleanupHIFScatterResources(device);   
     }
     
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
index 65c5d9b..6a410f1 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
@@ -96,7 +96,7 @@ int DevSetup(AR6K_DEVICE *pDev)
 
         status = HIFAttachHTC(pDev->HIFDevice, &htcCallbacks);
 
-        if (A_FAILED(status)) {
+        if (status) {
             break;
         }
 
@@ -197,7 +197,7 @@ int DevSetup(AR6K_DEVICE *pDev)
 
         status = DevDisableInterrupts(pDev);
 
-        if (A_FAILED(status)) {
+        if (status) {
             break;
         }
 
@@ -205,7 +205,7 @@ int DevSetup(AR6K_DEVICE *pDev)
 
     } while (FALSE);
 
-    if (A_FAILED(status)) {
+    if (status) {
         if (pDev->HifAttached) {
             HIFDetachHTC(pDev->HIFDevice);
             pDev->HifAttached = FALSE;
@@ -343,7 +343,7 @@ static void DevDoEnableDisableRecvAsyncHandler(void *Context, HTC_PACKET *pPacke
 
     AR_DEBUG_PRINTF(ATH_DEBUG_IRQ,("+DevDoEnableDisableRecvAsyncHandler: (dev: 0x%lX)\n", (unsigned long)pDev));
 
-    if (A_FAILED(pPacket->Status)) {
+    if (pPacket->Status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
                 (" Failed to disable receiver, status:%d \n", pPacket->Status));
     }
@@ -393,7 +393,7 @@ static int DevDoEnableDisableRecvOverride(AR6K_DEVICE *pDev, A_BOOL EnableRecv,
 
     } while (FALSE);
 
-    if (A_FAILED(status) && (pIOPacket != NULL)) {
+    if (status && (pIOPacket != NULL)) {
         AR6KFreeIOPacket(pDev,pIOPacket);
     }
 
@@ -462,7 +462,7 @@ static int DevDoEnableDisableRecvNormal(AR6K_DEVICE *pDev, A_BOOL EnableRecv, A_
 
     } while (FALSE);
 
-    if (A_FAILED(status) && (pIOPacket != NULL)) {
+    if (status && (pIOPacket != NULL)) {
         AR6KFreeIOPacket(pDev,pIOPacket);
     }
 
@@ -510,7 +510,7 @@ int DevWaitForPendingRecv(AR6K_DEVICE *pDev,A_UINT32 TimeoutInMs,A_BOOL *pbIsRec
                               sizeof(A_UCHAR),
                               HIF_RD_SYNC_BYTE_INC,
                               NULL);
-        if(A_FAILED(status))
+        if(status)
         {
             AR_DEBUG_PRINTF(ATH_LOG_ERR,("DevWaitForPendingRecv:Read HOST_INT_STATUS_ADDRESS Failed 0x%X\n",status));
             break;
@@ -721,7 +721,7 @@ static int DevReadWriteScatter(HIF_DEVICE *Context, HIF_SCATTER_REQ *pReq)
 
     } while (FALSE);
 
-    if ((status != A_PENDING) && A_FAILED(status) && (request & HIF_ASYNCHRONOUS)) {
+    if ((status != A_PENDING) && status && (request & HIF_ASYNCHRONOUS)) {
         if (pIOPacket != NULL) {
             AR6KFreeIOPacket(pDev,pIOPacket);
         }
@@ -790,7 +790,7 @@ static int DevSetupVirtualScatterSupport(AR6K_DEVICE *pDev)
         DevFreeScatterReq((HIF_DEVICE *)pDev,pReq);
     }
 
-    if (A_FAILED(status)) {
+    if (status) {
         DevCleanupVirtualScatterSupport(pDev);
     } else {
         pDev->HifScatterInfo.pAllocateReqFunc = DevAllocScatterReq;
@@ -825,7 +825,7 @@ int DevSetupMsgBundling(AR6K_DEVICE *pDev, int MaxMsgsPerTransfer)
                                 &pDev->HifScatterInfo,
                                 sizeof(pDev->HifScatterInfo));
 
-    if (A_FAILED(status)) {
+    if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_WARN,
             ("AR6K: ** HIF layer does not support scatter requests (%d) \n",status));
 
@@ -919,7 +919,7 @@ int DevSubmitScatterRequest(AR6K_DEVICE *pDev, HIF_SCATTER_REQ *pScatterReq, A_B
 
     status = DEV_PREPARE_SCATTER_OPERATION(pScatterReq);
 
-    if (A_FAILED(status)) {
+    if (status) {
         if (Async) {
             pScatterReq->CompletionStatus = status;
             pScatterReq->CompletionRoutine(pScatterReq);
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
index f12ae42..1e3d6cd 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
@@ -85,7 +85,7 @@ int DevPollMboxMsgRecv(AR6K_DEVICE *pDev,
             status = pDev->GetPendingEventsFunc(pDev->HIFDevice,
                                             &events,
                                             NULL);
-            if (A_FAILED(status))
+            if (status)
             {
                 AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Failed to get pending events \n"));
                 break;
@@ -109,7 +109,7 @@ int DevPollMboxMsgRecv(AR6K_DEVICE *pDev,
                                   HIF_RD_SYNC_BYTE_INC,
                                   NULL);
 
-            if (A_FAILED(status)){
+            if (status){
                 AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Failed to read register table \n"));
                 break;
             }
@@ -310,7 +310,7 @@ static void DevGetEventAsyncHandler(void *Context, HTC_PACKET *pPacket)
 
     do {
 
-        if (A_FAILED(pPacket->Status)) {
+        if (pPacket->Status) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
                     (" GetEvents I/O request failed, status:%d \n", pPacket->Status));
             /* bail out, don't unmask HIF interrupt */
@@ -501,7 +501,7 @@ static int ProcessPendingIRQs(AR6K_DEVICE *pDev, A_BOOL *pDone, A_BOOL *pASyncPr
                                                 &events,
                                                 NULL);
 
-            if (A_FAILED(status)) {
+            if (status) {
                 break;
             }
 
@@ -550,7 +550,7 @@ static int ProcessPendingIRQs(AR6K_DEVICE *pDev, A_BOOL *pDone, A_BOOL *pASyncPr
                               HIF_RD_SYNC_BYTE_INC,
                               NULL);
 
-        if (A_FAILED(status)) {
+        if (status) {
             break;
         }
 
@@ -597,7 +597,7 @@ static int ProcessPendingIRQs(AR6K_DEVICE *pDev, A_BOOL *pDone, A_BOOL *pASyncPr
     do {
 
             /* did the interrupt status fetches succeed? */
-        if (A_FAILED(status)) {
+        if (status) {
             break;
         }
 
@@ -617,7 +617,7 @@ static int ProcessPendingIRQs(AR6K_DEVICE *pDev, A_BOOL *pDone, A_BOOL *pASyncPr
                  * completion routine of the callers read request. This can improve performance
                  * by reducing context switching when we rapidly pull packets */
             status = pDev->MessagePendingCallback(pDev->HTCContext, &lookAhead, 1, pASyncProcessing, &fetched);
-            if (A_FAILED(status)) {
+            if (status) {
                 break;
             }
 
@@ -637,7 +637,7 @@ static int ProcessPendingIRQs(AR6K_DEVICE *pDev, A_BOOL *pDone, A_BOOL *pASyncPr
         if (HOST_INT_STATUS_CPU_GET(host_int_status)) {
                 /* CPU Interrupt */
             status = DevServiceCPUInterrupt(pDev);
-            if (A_FAILED(status)){
+            if (status){
                 break;
             }
         }
@@ -645,7 +645,7 @@ static int ProcessPendingIRQs(AR6K_DEVICE *pDev, A_BOOL *pDone, A_BOOL *pASyncPr
         if (HOST_INT_STATUS_ERROR_GET(host_int_status)) {
                 /* Error Interrupt */
             status = DevServiceErrorInterrupt(pDev);
-            if (A_FAILED(status)){
+            if (status){
                 break;
             }
         }
@@ -653,7 +653,7 @@ static int ProcessPendingIRQs(AR6K_DEVICE *pDev, A_BOOL *pDone, A_BOOL *pASyncPr
         if (HOST_INT_STATUS_COUNTER_GET(host_int_status)) {
                 /* Counter Interrupt */
             status = DevServiceCounterInterrupt(pDev);
-            if (A_FAILED(status)){
+            if (status){
                 break;
             }
         }
@@ -697,7 +697,7 @@ int DevDsrHandler(void *context)
 
     while (!done) {
         status = ProcessPendingIRQs(pDev, &done, &asyncProc);
-        if (A_FAILED(status)) {
+        if (status) {
             break;
         }
 
@@ -763,7 +763,7 @@ void DumpAR6KDevState(AR6K_DEVICE *pDev)
                           HIF_RD_SYNC_BYTE_INC,
                           NULL);
 
-    if (A_FAILED(status)) {
+    if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
             ("DumpAR6KDevState : Failed to read register table (%d) \n",status));
         return;
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c
index 4c4c8fb..7416576 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c
@@ -65,7 +65,7 @@ static void DevGMboxIRQActionAsyncHandler(void *Context, HTC_PACKET *pPacket)
 
     AR_DEBUG_PRINTF(ATH_DEBUG_IRQ,("+DevGMboxIRQActionAsyncHandler: (dev: 0x%lX)\n", (unsigned long)pDev));
 
-    if (A_FAILED(pPacket->Status)) {
+    if (pPacket->Status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
                 ("IRQAction Operation (%d) failed! status:%d \n", pPacket->PktInfo.AsRx.HTCRxFlags,pPacket->Status));
     }
@@ -137,7 +137,7 @@ static int DevGMboxCounterEnableDisable(AR6K_DEVICE *pDev, GMBOX_IRQ_ACTION_TYPE
                               NULL);    
     } while (FALSE);
     
-    if (A_FAILED(status)) {
+    if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
                 (" IRQAction Operation (%d) failed! status:%d \n", IrqAction, status));    
     } else {
@@ -244,7 +244,7 @@ int DevGMboxIRQAction(AR6K_DEVICE *pDev, GMBOX_IRQ_ACTION_TYPE IrqAction, A_BOOL
 
     } while (FALSE);
 
-    if (A_FAILED(status)) {
+    if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
                 (" IRQAction Operation (%d) failed! status:%d \n", IrqAction, status));    
     } else {
@@ -285,7 +285,7 @@ int DevSetupGMbox(AR6K_DEVICE *pDev)
                     
         status = DevGMboxIRQAction(pDev, GMBOX_DISABLE_ALL, PROC_IO_SYNC);
         
-        if (A_FAILED(status)) {
+        if (status) {
             break;    
         }
        
@@ -305,13 +305,13 @@ int DevSetupGMbox(AR6K_DEVICE *pDev)
                               HIF_WR_SYNC_BYTE_FIX,  /* hit this register 4 times */
                               NULL);
         
-        if (A_FAILED(status)) {
+        if (status) {
             break;    
         }
         
         status = GMboxProtocolInstall(pDev);
         
-        if (A_FAILED(status)) {
+        if (status) {
             break;    
         }
         
@@ -348,7 +348,7 @@ int DevCheckGMboxInterrupts(AR6K_DEVICE *pDev)
             status = A_ECOMM;    
         }
         
-        if (A_FAILED(status)) {
+        if (status) {
             if (pDev->GMboxInfo.pTargetFailureCallback != NULL) {
                 pDev->GMboxInfo.pTargetFailureCallback(pDev->GMboxInfo.pProtocolContext, status);        
             }
@@ -365,7 +365,7 @@ int DevCheckGMboxInterrupts(AR6K_DEVICE *pDev)
             }
         } 
         
-        if (A_FAILED(status)) {
+        if (status) {
            break;                
         }
         
@@ -378,7 +378,7 @@ int DevCheckGMboxInterrupts(AR6K_DEVICE *pDev)
                 /* do synchronous read */
             status = DevGMboxReadCreditCounter(pDev, PROC_IO_SYNC, &credits);
             
-            if (A_FAILED(status)) {
+            if (status) {
                 break;    
             }
             
@@ -522,7 +522,7 @@ static void DevGMboxReadCreditsAsyncHandler(void *Context, HTC_PACKET *pPacket)
 
     AR_DEBUG_PRINTF(ATH_DEBUG_IRQ,("+DevGMboxReadCreditsAsyncHandler: (dev: 0x%lX)\n", (unsigned long)pDev));
 
-    if (A_FAILED(pPacket->Status)) {
+    if (pPacket->Status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
                 ("Read Credit Operation failed! status:%d \n", pPacket->Status));
     } else {
@@ -583,7 +583,7 @@ int DevGMboxReadCreditCounter(AR6K_DEVICE *pDev, A_BOOL AsyncMode, int *pCredits
                               NULL);    
     } while (FALSE);
     
-    if (A_FAILED(status)) {
+    if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
                 (" DevGMboxReadCreditCounter failed! status:%d \n", status));          
     }
@@ -659,7 +659,7 @@ int DevGMboxRecvLookAheadPeek(AR6K_DEVICE *pDev, A_UINT8 *pLookAheadBuffer, int
                               HIF_RD_SYNC_BYTE_INC,
                               NULL);
 
-        if (A_FAILED(status)) {
+        if (status) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
                 ("DevGMboxRecvLookAheadPeek : Failed to read register table (%d) \n",status));
             break;
@@ -701,7 +701,7 @@ int DevGMboxSetTargetInterrupt(AR6K_DEVICE *pDev, int Signal, int AckTimeoutMS)
                               HIF_WR_SYNC_BYTE_FIX, /* hit the register 4 times to align the I/O */
                               NULL);    
                           
-        if (A_FAILED(status)) {
+        if (status) {
             break;    
         }
         
@@ -718,7 +718,7 @@ int DevGMboxSetTargetInterrupt(AR6K_DEVICE *pDev, int Signal, int AckTimeoutMS)
                                   HIF_RD_SYNC_BYTE_FIX,
                                   NULL);    
                           
-            if (A_FAILED(status)) {
+            if (status) {
                 break;    
             }
                             
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
index 8c801b0..bdb8632 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
@@ -140,7 +140,7 @@ static int InitTxCreditState(GMBOX_PROTO_HCI_UART *pProt)
 
             status = DevGMboxReadCreditCounter(pProt->pDev, PROC_IO_SYNC, &credits);
     
-            if (A_FAILED(status)) {
+            if (status) {
                 break;    
             }
             
@@ -160,7 +160,7 @@ static int InitTxCreditState(GMBOX_PROTO_HCI_UART *pProt)
             pProt->CreditsMax += credits;
         }
         
-        if (A_FAILED(status)) {
+        if (status) {
             break;    
         }
         
@@ -174,7 +174,7 @@ static int InitTxCreditState(GMBOX_PROTO_HCI_UART *pProt)
             /* now get the size */
         status = DevGMboxReadCreditSize(pProt->pDev, &pProt->CreditSize);
         
-        if (A_FAILED(status)) {
+        if (status) {
             break;    
         }
                
@@ -353,7 +353,7 @@ static int HCIUartMessagePending(void *pContext, A_UINT8 LookAheadBytes[], int V
                 break;
         }
         
-        if (A_FAILED(status)) {
+        if (status) {
             break;    
         }
                 
@@ -426,7 +426,7 @@ static int HCIUartMessagePending(void *pContext, A_UINT8 LookAheadBytes[], int V
         
     do {
         
-        if (A_FAILED(status) || (NULL == pPacket)) {
+        if (status || (NULL == pPacket)) {
             break;    
         } 
         
@@ -438,7 +438,7 @@ static int HCIUartMessagePending(void *pContext, A_UINT8 LookAheadBytes[], int V
                 
         status = DevGMboxRead(pProt->pDev, pPacket, totalRecvLength);     
         
-        if (A_FAILED(status)) {
+        if (status) {
             break;    
         }
         
@@ -508,12 +508,12 @@ static int HCIUartMessagePending(void *pContext, A_UINT8 LookAheadBytes[], int V
     } while (FALSE);
         
         /* check if we need to disable the reciever */
-    if (A_FAILED(status) || blockRecv) {
+    if (status || blockRecv) {
         DevGMboxIRQAction(pProt->pDev, GMBOX_RECV_IRQ_DISABLE, PROC_IO_SYNC); 
     }
     
         /* see if we need to recycle the recv buffer */    
-    if (A_FAILED(status) && (pPacket != NULL)) {
+    if (status && (pPacket != NULL)) {
         HTC_PACKET_QUEUE queue;
         
         if (A_EPROTO == status) {
@@ -537,7 +537,7 @@ static void HCISendPacketCompletion(void *Context, HTC_PACKET *pPacket)
     GMBOX_PROTO_HCI_UART *pProt = (GMBOX_PROTO_HCI_UART *)Context;
     AR_DEBUG_PRINTF(ATH_DEBUG_SEND,("+HCISendPacketCompletion (pPacket:0x%lX) \n",(unsigned long)pPacket));
     
-    if (A_FAILED(pPacket->Status)) {
+    if (pPacket->Status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,(" Send Packet (0x%lX) failed: %d , len:%d \n",
             (unsigned long)pPacket, pPacket->Status, pPacket->ActualLength));        
     }
@@ -556,7 +556,7 @@ static int SeekCreditsSynch(GMBOX_PROTO_HCI_UART *pProt)
     while (TRUE) {                
         credits = 0;
         status =  DevGMboxReadCreditCounter(pProt->pDev, PROC_IO_SYNC, &credits);   
-        if (A_FAILED(status)) {
+        if (status) {
             break;    
         }
         LOCK_HCI_TX(pProt);
@@ -676,7 +676,7 @@ static int HCITrySend(GMBOX_PROTO_HCI_UART *pProt, HTC_PACKET *pPacket, A_BOOL S
                     break;
             }
                        
-            if (A_FAILED(status)) {
+            if (status) {
                 break;   
             }
             
@@ -706,7 +706,7 @@ static int HCITrySend(GMBOX_PROTO_HCI_UART *pProt, HTC_PACKET *pPacket, A_BOOL S
                     UNLOCK_HCI_TX(pProt);
                     status = SeekCreditsSynch(pProt);
                     LOCK_HCI_TX(pProt);
-                    if (A_FAILED(status)) {
+                    if (status) {
                         break;    
                     }                    
                     /* fall through and continue processing this send op */                    
@@ -784,7 +784,7 @@ static int HCITrySend(GMBOX_PROTO_HCI_UART *pProt, HTC_PACKET *pPacket, A_BOOL S
             UNLOCK_HCI_TX(pProt);
         }
     } else {   
-        if (A_FAILED(status) && (pPacket != NULL)) {
+        if (status && (pPacket != NULL)) {
             pPacket->Status = status;
             DO_HCI_SEND_INDICATION(pProt,pPacket); 
         }
@@ -1052,7 +1052,7 @@ int HCI_TransportAddReceivePkts(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET_QUEUE
     
     UNLOCK_HCI_RX(pProt);
     
-    if (A_FAILED(status)) {
+    if (status) {
         while (!HTC_QUEUE_EMPTY(pQueue)) {
             pPacket = HTC_PACKET_DEQUEUE(pQueue);      
             pPacket->Status = A_ECANCELED;
@@ -1116,25 +1116,25 @@ int HCI_TransportStart(HCI_TRANSPORT_HANDLE HciTrans)
         
         status = InitTxCreditState(pProt);   
         
-        if (A_FAILED(status)) {
+        if (status) {
             break;    
         }     
         
         status = DevGMboxIRQAction(pProt->pDev, GMBOX_ERRORS_IRQ_ENABLE, PROC_IO_SYNC);   
         
-        if (A_FAILED(status)) {
+        if (status) {
             break;   
         } 
             /* enable recv */   
         status = DevGMboxIRQAction(pProt->pDev, GMBOX_RECV_IRQ_ENABLE, PROC_IO_SYNC);
         
-        if (A_FAILED(status)) {
+        if (status) {
             break;   
         } 
             /* signal bridge side to power up BT */
         status = DevGMboxSetTargetInterrupt(pProt->pDev, MBOX_SIG_HCI_BRIDGE_BT_ON, BTON_TIMEOUT_MS);
         
-        if (A_FAILED(status)) {
+        if (status) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("HCI_TransportStart : Failed to trigger BT ON \n"));
             break;   
         } 
@@ -1178,7 +1178,7 @@ int HCI_TransportRecvHCIEventSync(HCI_TRANSPORT_HANDLE HciTrans,
         
         bytes = sizeof(lookAhead);
         status = DevGMboxRecvLookAheadPeek(pProt->pDev,lookAhead,&bytes);
-        if (A_FAILED(status)) {
+        if (status) {
             break;    
         }        
                 
@@ -1204,13 +1204,13 @@ int HCI_TransportRecvHCIEventSync(HCI_TRANSPORT_HANDLE HciTrans,
                 break;
         }
         
-        if (A_FAILED(status)) {
+        if (status) {
             break;    
         }
         
         pPacket->Completion = NULL;
         status = DevGMboxRead(pProt->pDev,pPacket,totalRecvLength); 
-        if (A_FAILED(status)) {
+        if (status) {
             break;    
         }
         
@@ -1272,7 +1272,7 @@ int HCI_TransportEnablePowerMgmt(HCI_TRANSPORT_HANDLE HciTrans, A_BOOL Enable)
         status = DevGMboxSetTargetInterrupt(pProt->pDev, MBOX_SIG_HCI_BRIDGE_PWR_SAV_OFF, BTPWRSAV_TIMEOUT_MS);
     }
 
-    if (A_FAILED(status)) {
+    if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Failed to enable/disable HCI power management!\n"));
     } else {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("HCI power management enabled/disabled!\n"));
diff --git a/drivers/staging/ath6kl/htc2/htc.c b/drivers/staging/ath6kl/htc2/htc.c
index 2ab5975..b24698e 100644
--- a/drivers/staging/ath6kl/htc2/htc.c
+++ b/drivers/staging/ath6kl/htc2/htc.c
@@ -137,7 +137,7 @@ HTC_HANDLE HTCCreate(void *hif_handle, HTC_INIT_INFO *pInfo)
             /* setup device layer */
         status = DevSetup(&target->Device);
 
-        if (A_FAILED(status)) {
+        if (status) {
             break;
         }
 
@@ -145,7 +145,7 @@ HTC_HANDLE HTCCreate(void *hif_handle, HTC_INIT_INFO *pInfo)
         /* get the block sizes */
         status = HIFConfigureDevice(hif_handle, HIF_DEVICE_GET_MBOX_BLOCK_SIZE,
                                     blocksizes, sizeof(blocksizes));
-        if (A_FAILED(status)) {
+        if (status) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Failed to get block size info from HIF layer...\n"));
             break;
         }
@@ -165,7 +165,7 @@ HTC_HANDLE HTCCreate(void *hif_handle, HTC_INIT_INFO *pInfo)
             }
         }
 
-        if (A_FAILED(status)) {
+        if (status) {
             break;
         }
 
@@ -192,7 +192,7 @@ HTC_HANDLE HTCCreate(void *hif_handle, HTC_INIT_INFO *pInfo)
 
     } while (FALSE);
 
-    if (A_FAILED(status)) {
+    if (status) {
         if (target != NULL) {
             HTCCleanup(target);
             target = NULL;
@@ -249,7 +249,7 @@ int HTCWaitTarget(HTC_HANDLE HTCHandle)
             /* we should be getting 1 control message that the target is ready */
         status = HTCWaitforControlMessage(target, &pPacket);
 
-        if (A_FAILED(status)) {
+        if (status) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR, (" Target Not Available!!\n"));
             break;
         }
@@ -305,7 +305,7 @@ int HTCWaitTarget(HTC_HANDLE HTCHandle)
                 /* limit what HTC can handle */
             target->MaxMsgPerBundle = min(HTC_HOST_MAX_MSG_PER_BUNDLE, target->MaxMsgPerBundle);          
                 /* target supports message bundling, setup device layer */
-            if (A_FAILED(DevSetupMsgBundling(&target->Device,target->MaxMsgPerBundle))) {
+            if (DevSetupMsgBundling(&target->Device,target->MaxMsgPerBundle)) {
                     /* device layer can't handle bundling */
                 target->MaxMsgPerBundle = 0;        
             } else {
@@ -351,7 +351,7 @@ int HTCWaitTarget(HTC_HANDLE HTCHandle)
                                    &connect,
                                    &resp);
 
-        if (!A_FAILED(status)) {
+        if (!status) {
             break;
         }
 
@@ -419,14 +419,14 @@ int HTCStart(HTC_HANDLE HTCHandle)
             * target that the setup phase is complete */
         status = HTCSendSetupComplete(target);
 
-        if (A_FAILED(status)) {
+        if (status) {
             break;
         }
 
             /* unmask interrupts */
         status = DevUnmaskInterrupts(&target->Device);
 
-        if (A_FAILED(status)) {
+        if (status) {
             HTCStop(target);
         }
 
diff --git a/drivers/staging/ath6kl/htc2/htc_recv.c b/drivers/staging/ath6kl/htc2/htc_recv.c
index 9762109..b38211b 100644
--- a/drivers/staging/ath6kl/htc2/htc_recv.c
+++ b/drivers/staging/ath6kl/htc2/htc_recv.c
@@ -204,7 +204,7 @@ static INLINE int HTCProcessTrailer(HTC_TARGET *target,
                 break;
         }
 
-        if (A_FAILED(status)) {
+        if (status) {
             break;
         }
 
@@ -214,7 +214,7 @@ static INLINE int HTCProcessTrailer(HTC_TARGET *target,
     }
 
 #ifdef ATH_DEBUG_MODULE
-    if (A_FAILED(status)) {
+    if (status) {
         DebugDumpBytes(pOrigBuffer,origLength,"BAD Recv Trailer");
     }
 #endif
@@ -341,7 +341,7 @@ static int HTCProcessRecvHeader(HTC_TARGET *target,
                                        pNumLookAheads,
                                        pPacket->Endpoint);
 
-            if (A_FAILED(status)) {
+            if (status) {
                 break;
             }
 
@@ -365,7 +365,7 @@ static int HTCProcessRecvHeader(HTC_TARGET *target,
 
     } while (FALSE);
 
-    if (A_FAILED(status)) {
+    if (status) {
             /* dump the whole packet */
 #ifdef ATH_DEBUG_MODULE
         DebugDumpBytes(pBuf,pPacket->ActualLength < 256 ? pPacket->ActualLength : 256 ,"BAD HTC Recv PKT");
@@ -537,7 +537,7 @@ void HTCRecvCompleteHandler(void *Context, HTC_PACKET *pPacket)
 
     do {
         
-        if (A_FAILED(status)) {
+        if (status) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("HTCRecvCompleteHandler: request failed (status:%d, ep:%d) \n",
                 pPacket->Status, pPacket->Endpoint));
             break;
@@ -545,7 +545,7 @@ void HTCRecvCompleteHandler(void *Context, HTC_PACKET *pPacket)
             /* process the header for any trailer data */
         status = HTCProcessRecvHeader(target,pPacket,nextLookAheads,&numLookAheads);
 
-        if (A_FAILED(status)) {
+        if (status) {
             break;
         }
         
@@ -570,7 +570,7 @@ void HTCRecvCompleteHandler(void *Context, HTC_PACKET *pPacket)
 
     } while (FALSE);
 
-    if (A_FAILED(status)) {
+    if (status) {
          AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
                          ("HTCRecvCompleteHandler , message fetch failed (status = %d) \n",
                          status));
@@ -605,7 +605,7 @@ int HTCWaitforControlMessage(HTC_TARGET *target, HTC_PACKET **ppControlPacket)
                                     &lookAhead,
                                     HTC_TARGET_RESPONSE_TIMEOUT);
 
-        if (A_FAILED(status)) {
+        if (status) {
             break;
         }
 
@@ -622,7 +622,7 @@ int HTCWaitforControlMessage(HTC_TARGET *target, HTC_PACKET **ppControlPacket)
             break;
         }
 
-        if (A_FAILED(status)) {
+        if (status) {
                 /* bad message */
             AR_DEBUG_ASSERT(FALSE);
             status = A_EPROTO;
@@ -653,7 +653,7 @@ int HTCWaitforControlMessage(HTC_TARGET *target, HTC_PACKET **ppControlPacket)
             /* get the message from the device, this will block */
         status = HTCIssueRecv(target, pPacket);
 
-        if (A_FAILED(status)) {
+        if (status) {
             break;
         }
 
@@ -662,7 +662,7 @@ int HTCWaitforControlMessage(HTC_TARGET *target, HTC_PACKET **ppControlPacket)
 
         pPacket->Status = status;
 
-        if (A_FAILED(status)) {
+        if (status) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
                     ("HTCWaitforControlMessage, HTCProcessRecvHeader failed (status = %d) \n",
                      status));
@@ -674,7 +674,7 @@ int HTCWaitforControlMessage(HTC_TARGET *target, HTC_PACKET **ppControlPacket)
 
     } while (FALSE);
 
-    if (A_FAILED(status)) {
+    if (status) {
         if (pPacket != NULL) {
                 /* cleanup buffer on error */
             HTC_FREE_CONTROL_RX(target,pPacket);
@@ -856,7 +856,7 @@ static int AllocAndPrepareRxPackets(HTC_TARGET       *target,
             pPacket->ActualLength = pHdr->PayloadLen + HTC_HDR_LENGTH;
         }
         
-        if (A_FAILED(status)) {
+        if (status) {
             if (A_NO_RESOURCE == status) {
                     /* this is actually okay */
                 status = A_OK;    
@@ -868,7 +868,7 @@ static int AllocAndPrepareRxPackets(HTC_TARGET       *target,
     
     UNLOCK_HTC_RX(target);
     
-    if (A_FAILED(status)) {
+    if (status) {
         while (!HTC_QUEUE_EMPTY(pQueue)) {
             pPacket = HTC_PACKET_DEQUEUE(pQueue);
                 /* recycle all allocated packets */
@@ -897,7 +897,7 @@ static void HTCAsyncRecvScatterCompletion(HIF_SCATTER_REQ *pScatterReq)
     
     A_ASSERT(!IS_DEV_IRQ_PROC_SYNC_MODE(&target->Device));
            
-    if (A_FAILED(pScatterReq->CompletionStatus)) {
+    if (pScatterReq->CompletionStatus) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("** Recv Scatter Request Failed: %d \n",pScatterReq->CompletionStatus));            
     }
     
@@ -1186,7 +1186,7 @@ int HTCRecvMessagePendingHandler(void *Context, A_UINT32 MsgLookAheads[], int Nu
                                           NumLookAheads,
                                           pEndpoint, 
                                           &recvPktQueue);        
-        if (A_FAILED(status)) {
+        if (status) {
             break;    
         }
  
@@ -1214,7 +1214,7 @@ int HTCRecvMessagePendingHandler(void *Context, A_UINT32 MsgLookAheads[], int Nu
                                                   asyncProc ? NULL : &syncCompletedPktsQueue,
                                                   &pktsFetched,
                                                   partialBundle);                                                   
-                if (A_FAILED(status)) {
+                if (status) {
                     break;
                 }
                 
@@ -1248,7 +1248,7 @@ int HTCRecvMessagePendingHandler(void *Context, A_UINT32 MsgLookAheads[], int Nu
                                     
                     /* go fetch the packet */
                 status = HTCIssueRecv(target, pPacket);              
-                if (A_FAILED(status)) {
+                if (status) {
                     break;
                 }  
                                
@@ -1295,7 +1295,7 @@ int HTCRecvMessagePendingHandler(void *Context, A_UINT32 MsgLookAheads[], int Nu
                 /* process header for each of the recv packets
                  * note: the lookahead of the last packet is useful for us to continue in this loop */            
             status = HTCProcessRecvHeader(target,pPacket,lookAheads,&NumLookAheads);
-            if (A_FAILED(status)) {
+            if (status) {
                 break;
             }
             
@@ -1317,7 +1317,7 @@ int HTCRecvMessagePendingHandler(void *Context, A_UINT32 MsgLookAheads[], int Nu
             DO_RCV_COMPLETION(pEndpoint,&container);
         }
 
-        if (A_FAILED(status)) {
+        if (status) {
             break;
         }
             
@@ -1346,7 +1346,7 @@ int HTCRecvMessagePendingHandler(void *Context, A_UINT32 MsgLookAheads[], int Nu
         REF_IRQ_STATUS_RECHECK(&target->Device);
     }
     
-    if (A_FAILED(status)) {
+    if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
                         ("Failed to get pending recv messages (%d) \n",status));
             /* cleanup any packets we allocated but didn't use to actually fetch any packets */                        
diff --git a/drivers/staging/ath6kl/htc2/htc_send.c b/drivers/staging/ath6kl/htc2/htc_send.c
index 7974008..e645e2d 100644
--- a/drivers/staging/ath6kl/htc2/htc_send.c
+++ b/drivers/staging/ath6kl/htc2/htc_send.c
@@ -81,7 +81,7 @@ static INLINE void CompleteSentPacket(HTC_TARGET *target, HTC_ENDPOINT *pEndpoin
 {
     pPacket->Completion = NULL;  
     
-    if (A_FAILED(pPacket->Status)) {
+    if (pPacket->Status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
             ("CompleteSentPacket: request failed (status:%d, ep:%d, length:%d creds:%d) \n",
                 pPacket->Status, pPacket->Endpoint, pPacket->ActualLength, pPacket->PktInfo.AsTx.CreditsUsed));                
@@ -280,7 +280,7 @@ static void HTCAsyncSendScatterCompletion(HIF_SCATTER_REQ *pScatterReq)
     
     DEV_FINISH_SCATTER_OPERATION(pScatterReq);
            
-    if (A_FAILED(pScatterReq->CompletionStatus)) {
+    if (pScatterReq->CompletionStatus) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("** Send Scatter Request Failed: %d \n",pScatterReq->CompletionStatus));            
         status = A_ERROR;
     }
diff --git a/drivers/staging/ath6kl/htc2/htc_services.c b/drivers/staging/ath6kl/htc2/htc_services.c
index a786602..63189b5 100644
--- a/drivers/staging/ath6kl/htc2/htc_services.c
+++ b/drivers/staging/ath6kl/htc2/htc_services.c
@@ -184,14 +184,14 @@ int HTCConnectService(HTC_HANDLE               HTCHandle,
             HTC_PREPARE_SEND_PKT(pSendPacket,0,0,0);
             status = HTCIssueSend(target,pSendPacket);
 
-            if (A_FAILED(status)) {
+            if (status) {
                 break;
             }
 
                 /* wait for response */
             status = HTCWaitforControlMessage(target, &pRecvPacket);
 
-            if (A_FAILED(status)) {
+            if (status) {
                 break;
             }
                 /* we controlled the buffer creation so it has to be properly aligned */
diff --git a/drivers/staging/ath6kl/include/common/athdefs.h b/drivers/staging/ath6kl/include/common/athdefs.h
index ef60754..c6ae9ba 100644
--- a/drivers/staging/ath6kl/include/common/athdefs.h
+++ b/drivers/staging/ath6kl/include/common/athdefs.h
@@ -73,8 +73,6 @@
 #define A_PHY_ERROR		27	/* RX PHY error */
 #define A_CONSUMED		28	/* Object was consumed */
 
-#define A_FAILED(x)         (!!x)
-
 #ifndef TRUE
 #define TRUE 1
 #endif
diff --git a/drivers/staging/ath6kl/miscdrv/ar3kconfig.c b/drivers/staging/ath6kl/miscdrv/ar3kconfig.c
index fa6b43f..4bdc489 100644
--- a/drivers/staging/ath6kl/miscdrv/ar3kconfig.c
+++ b/drivers/staging/ath6kl/miscdrv/ar3kconfig.c
@@ -107,7 +107,7 @@ static int RecvHCIEvent(AR3K_CONFIG_INFO *pConfig,
         status = HCI_TransportRecvHCIEventSync(pConfig->pHCIDev,
                                                pRecvPacket,
                                                HCI_EVENT_RESP_TIMEOUTMS);
-        if (A_FAILED(status)) {
+        if (status) {
             break;    
         }
 
@@ -158,7 +158,7 @@ int SendHCICommandWaitCommandComplete(AR3K_CONFIG_INFO *pConfig,
         status = SendHCICommand(pConfig,
                                 pBuffer + pConfig->pHCIProps->HeadRoom,
                                 CmdLength);
-        if (A_FAILED(status)) {
+        if (status) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("AR3K Config: Failed to send HCI Command (%d) \n", status));
             AR_DEBUG_PRINTBUF(pHCICommand,CmdLength,"HCI Bridge Failed HCI Command");
             break;    
@@ -167,7 +167,7 @@ int SendHCICommandWaitCommandComplete(AR3K_CONFIG_INFO *pConfig,
             /* reuse buffer to capture command complete event */
         A_MEMZERO(pBuffer,length);
         status = RecvHCIEvent(pConfig,pBuffer,&length);        
-        if (A_FAILED(status)) {
+        if (status) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("AR3K Config: HCI event recv failed \n"));
             AR_DEBUG_PRINTBUF(pHCICommand,CmdLength,"HCI Bridge Failed HCI Command");
             break;    
@@ -229,7 +229,7 @@ static int AR3KConfigureHCIBaud(AR3K_CONFIG_INFO *pConfig)
                                                        sizeof(hciBaudChangeCommand),
                                                        &pEvent,
                                                        &pBufferToFree);          
-            if (A_FAILED(status)) {
+            if (status) {
                 AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("AR3K Config: Baud rate change failed! \n"));  
                 break;    
             }
@@ -255,7 +255,7 @@ static int AR3KConfigureHCIBaud(AR3K_CONFIG_INFO *pConfig)
             /* Tell target to change UART baud rate for AR6K */
             status = HCI_TransportSetBaudRate(pConfig->pHCIDev, pConfig->AR3KBaudRate);
 
-            if (A_FAILED(status)) {
+            if (status) {
                 AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
                     ("AR3K Config: failed to set scale and step values: %d \n", status));
                 break;    
@@ -323,7 +323,7 @@ static int AR3KConfigureSendHCIReset(AR3K_CONFIG_INFO *pConfig)
                                                 &pEvent,
                                                 &pBufferToFree );
 
-    if (A_FAILED(status)) {
+    if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("AR3K Config: HCI reset failed! \n"));
     }
 
@@ -384,7 +384,7 @@ static int AR3KEnableTLPM(AR3K_CONFIG_INFO *pConfig)
     if (pBufferToFree != NULL) {
         A_FREE(pBufferToFree);    
     }
-    if (A_FAILED(status)) {
+    if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("HostWakeup Config Failed! \n"));    
         return status;
     }
@@ -399,7 +399,7 @@ static int AR3KEnableTLPM(AR3K_CONFIG_INFO *pConfig)
     if (pBufferToFree != NULL) {
         A_FREE(pBufferToFree);    
     }
-    if (A_FAILED(status)) {
+    if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Target Wakeup Config Failed! \n"));    
         return status;
     }
@@ -414,7 +414,7 @@ static int AR3KEnableTLPM(AR3K_CONFIG_INFO *pConfig)
     if (pBufferToFree != NULL) {
         A_FREE(pBufferToFree);    
     }
-    if (A_FAILED(status)) {
+    if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("HostWakeup Enable Failed! \n"));    
         return status;
     }
@@ -429,7 +429,7 @@ static int AR3KEnableTLPM(AR3K_CONFIG_INFO *pConfig)
     if (pBufferToFree != NULL) {
         A_FREE(pBufferToFree);    
     }
-    if (A_FAILED(status)) {
+    if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Target Wakeup Enable Failed! \n"));    
         return status;
     }
@@ -444,7 +444,7 @@ static int AR3KEnableTLPM(AR3K_CONFIG_INFO *pConfig)
     if (pBufferToFree != NULL) {
         A_FREE(pBufferToFree);    
     }
-    if (A_FAILED(status)) {
+    if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Sleep Enable Failed! \n"));    
     }
     
@@ -468,13 +468,13 @@ int AR3KConfigure(AR3K_CONFIG_INFO *pConfig)
         
             /* disable asynchronous recv while we issue commands and receive events synchronously */
         status = HCI_TransportEnableDisableAsyncRecv(pConfig->pHCIDev,FALSE);
-        if (A_FAILED(status)) {
+        if (status) {
             break;    
         }
       
         if (pConfig->Flags & AR3K_CONFIG_FLAG_FORCE_MINBOOT_EXIT) {
             status =  AR3KExitMinBoot(pConfig);   
-            if (A_FAILED(status)) {
+            if (status) {
                 break;    
             }    
         }
@@ -491,7 +491,7 @@ int AR3KConfigure(AR3K_CONFIG_INFO *pConfig)
  	if (pConfig->Flags & 
                 (AR3K_CONFIG_FLAG_SET_AR3K_BAUD | AR3K_CONFIG_FLAG_SET_AR6K_SCALE_STEP)) {
             status = AR3KConfigureHCIBaud(pConfig);      
-            if (A_FAILED(status)) {
+            if (status) {
                 break;    
             }
         }     
@@ -508,7 +508,7 @@ int AR3KConfigure(AR3K_CONFIG_INFO *pConfig)
                
            /* re-enable asynchronous recv */
         status = HCI_TransportEnableDisableAsyncRecv(pConfig->pHCIDev,TRUE);
-        if (A_FAILED(status)) {
+        if (status) {
             break;    
         }     
     
@@ -537,21 +537,21 @@ int AR3KConfigureExit(void *config)
         
             /* disable asynchronous recv while we issue commands and receive events synchronously */
         status = HCI_TransportEnableDisableAsyncRecv(pConfig->pHCIDev,FALSE);
-        if (A_FAILED(status)) {
+        if (status) {
             break;    
         }
       
         if (pConfig->Flags & 
                 (AR3K_CONFIG_FLAG_SET_AR3K_BAUD | AR3K_CONFIG_FLAG_SET_AR6K_SCALE_STEP)) {
             status = AR3KConfigureHCIBaud(pConfig);      
-            if (A_FAILED(status)) {
+            if (status) {
                 break;    
             }
         }
 
            /* re-enable asynchronous recv */
         status = HCI_TransportEnableDisableAsyncRecv(pConfig->pHCIDev,TRUE);
-        if (A_FAILED(status)) {
+        if (status) {
             break;    
         }     
     
diff --git a/drivers/staging/ath6kl/miscdrv/common_drv.c b/drivers/staging/ath6kl/miscdrv/common_drv.c
index 2b5fe5b..926f88f 100644
--- a/drivers/staging/ath6kl/miscdrv/common_drv.c
+++ b/drivers/staging/ath6kl/miscdrv/common_drv.c
@@ -428,7 +428,7 @@ int ar6000_reset_device(HIF_DEVICE *hifDevice, A_UINT32 TargetType, A_BOOL waitF
 
         status = ar6000_WriteRegDiag(hifDevice, &address, &data);
 
-        if (A_FAILED(status)) {
+        if (status) {
             break;
         }
 
@@ -458,7 +458,7 @@ int ar6000_reset_device(HIF_DEVICE *hifDevice, A_UINT32 TargetType, A_BOOL waitF
         data = 0;
         status = ar6000_ReadRegDiag(hifDevice, &address, &data);
 
-        if (A_FAILED(status)) {
+        if (status) {
             break;
         }
 
@@ -472,7 +472,7 @@ int ar6000_reset_device(HIF_DEVICE *hifDevice, A_UINT32 TargetType, A_BOOL waitF
 
     } while (FALSE);
 
-    if (A_FAILED(status)) {
+    if (status) {
         AR_DEBUG_PRINTF(ATH_LOG_ERR, ("Failed to reset target \n"));
     }
 
@@ -579,7 +579,7 @@ void ar6000_dump_target_assert_info(HIF_DEVICE *hifDevice, A_UINT32 TargetType)
             /* read RAM location through diagnostic window */
         status = ar6000_ReadRegDiag(hifDevice, &address, &regDumpArea);
 
-        if (A_FAILED(status)) {
+        if (status) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("AR6K: Failed to get ptr to register dump area \n"));
             break;
         }
@@ -599,7 +599,7 @@ void ar6000_dump_target_assert_info(HIF_DEVICE *hifDevice, A_UINT32 TargetType)
                                      (A_UCHAR *)&regDumpValues[0],
                                      regDumpCount * (sizeof(A_UINT32)));
 
-        if (A_FAILED(status)) {
+        if (status) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("AR6K: Failed to get register dump \n"));
             break;
         }
@@ -638,7 +638,7 @@ int ar6000_set_htc_params(HIF_DEVICE *hifDevice,
         status = HIFConfigureDevice(hifDevice, HIF_DEVICE_GET_MBOX_BLOCK_SIZE,
                                     blocksizes, sizeof(blocksizes));
 
-        if (A_FAILED(status)) {
+        if (status) {
             AR_DEBUG_PRINTF(ATH_LOG_ERR,("Failed to get block size info from HIF layer...\n"));
             break;
         }
@@ -658,7 +658,7 @@ int ar6000_set_htc_params(HIF_DEVICE *hifDevice,
                                 (A_UCHAR *)&blocksizes[1],
                                 4);
 
-        if (A_FAILED(status)) {
+        if (status) {
             AR_DEBUG_PRINTF(ATH_LOG_ERR,("BMIWriteMemory for IO block size failed \n"));
             break;
         }
@@ -673,7 +673,7 @@ int ar6000_set_htc_params(HIF_DEVICE *hifDevice,
                                     (A_UCHAR *)&MboxIsrYieldValue,
                                     4);
 
-            if (A_FAILED(status)) {
+            if (status) {
                 AR_DEBUG_PRINTF(ATH_LOG_ERR,("BMIWriteMemory for yield limit failed \n"));
                 break;
             }
@@ -771,7 +771,7 @@ ar6002_REV1_reset_force_host (HIF_DEVICE *hifDevice)
 
     address = 0x004ed4b0; /* REV1 target software ID is stored here */
     status = ar6000_ReadRegDiag(hifDevice, &address, &data);
-    if (A_FAILED(status) || (data != AR6002_VERSION_REV1)) {
+    if (status || (data != AR6002_VERSION_REV1)) {
         return A_ERROR; /* Not AR6002 REV1 */
     }
 
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 4ad78f2..9ed95e3 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -866,7 +866,7 @@ ar6000_sysfs_bmi_init(AR_SOFTC_T *ar)
                                 &ar->osDevInfo,
                                 sizeof(HIF_DEVICE_OS_DEVICE_INFO));
 
-    if (A_FAILED(status)) {
+    if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("BMI: Failed to get OS device info from HIF\n"));
         return A_ERROR;
     }
@@ -1536,18 +1536,16 @@ ar6000_configure_target(AR_SOFTC_T *ar)
         /* since BMIInit is called in the driver layer, we have to set the block
          * size here for the target */
 
-    if (A_FAILED(ar6000_set_htc_params(ar->arHifDevice,
-                                       ar->arTargetType,
-                                       mbox_yield_limit,
-                                       0 /* use default number of control buffers */
-                                       ))) {
+    if (ar6000_set_htc_params(ar->arHifDevice, ar->arTargetType,
+			      mbox_yield_limit, 0)) {
+				/* use default number of control buffers */
         return A_ERROR;
     }
 
     if (setupbtdev != 0) {
-        if (A_FAILED(ar6000_set_hci_bridge_flags(ar->arHifDevice,
-                                                 ar->arTargetType,
-                                                 setupbtdev))) {
+        if (ar6000_set_hci_bridge_flags(ar->arHifDevice,
+					ar->arTargetType,
+					setupbtdev)) {
             return A_ERROR;
         }
     }
@@ -1841,7 +1839,7 @@ ar6000_avail_ev(void *context, void *hif_handle)
                     (unsigned long)ar));
 
 avail_ev_failed :
-    if (A_FAILED(init_status)) {
+    if (init_status) {
         if (bmienable) { 
             ar6000_sysfs_bmi_deinit(ar);  
         }
@@ -2359,7 +2357,7 @@ static int ar6000_connectservice(AR_SOFTC_T               *ar,
                                    pConnect,
                                    &response);
 
-        if (A_FAILED(status)) {
+        if (status) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,(" Failed to connect to %s service status:%d \n",
                               pDesc, status));
             break;
@@ -2502,7 +2500,7 @@ int ar6000_init(struct net_device *dev)
              */
         status = HTCWaitTarget(ar->arHtcTarget);
 
-        if (A_FAILED(status)) {
+        if (status) {
             break;
         }
 
@@ -2533,7 +2531,7 @@ int ar6000_init(struct net_device *dev)
         status = ar6000_connectservice(ar,
                                        &connect,
                                        "WMI CONTROL");
-        if (A_FAILED(status)) {
+        if (status) {
             break;
         }
 
@@ -2563,7 +2561,7 @@ int ar6000_init(struct net_device *dev)
         status = ar6000_connectservice(ar,
                                        &connect,
                                        "WMI DATA BE");
-        if (A_FAILED(status)) {
+        if (status) {
             break;
         }
 
@@ -2573,7 +2571,7 @@ int ar6000_init(struct net_device *dev)
         status = ar6000_connectservice(ar,
                                        &connect,
                                        "WMI DATA BK");
-        if (A_FAILED(status)) {
+        if (status) {
             break;
         }
 
@@ -2583,7 +2581,7 @@ int ar6000_init(struct net_device *dev)
         status = ar6000_connectservice(ar,
                                        &connect,
                                        "WMI DATA VI");
-        if (A_FAILED(status)) {
+        if (status) {
             break;
         }
 
@@ -2596,7 +2594,7 @@ int ar6000_init(struct net_device *dev)
         status = ar6000_connectservice(ar,
                                        &connect,
                                        "WMI DATA VO");
-        if (A_FAILED(status)) {
+        if (status) {
             break;
         }
 
@@ -2636,7 +2634,7 @@ int ar6000_init(struct net_device *dev)
 
     } while (FALSE);
 
-    if (A_FAILED(status)) {
+    if (status) {
         ret = -EIO;
         goto ar6000_init_done;
     }
@@ -3455,7 +3453,7 @@ ar6000_tx_complete(void *Context, HTC_PACKET_QUEUE *pPacketQueue)
             }
         }
 
-        if (A_FAILED(status)) {
+        if (status) {
             if (status == A_ECANCELED) {
                     /* a packet was flushed  */
                 flushing = TRUE;
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_raw_if.c b/drivers/staging/ath6kl/os/linux/ar6000_raw_if.c
index 10f4885..59e2af4 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_raw_if.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_raw_if.c
@@ -147,7 +147,7 @@ static int ar6000_connect_raw_service(AR_SOFTC_T        *ar,
                                    &connect,
                                    &response);
         
-        if (A_FAILED(status)) {
+        if (status) {
             if (response.ConnectRespCode == HTC_SERVICE_NO_MORE_EP) {
                 AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("HTC RAW , No more streams allowed \n"));
                 status = A_OK;    
@@ -187,7 +187,7 @@ int ar6000_htc_raw_open(AR_SOFTC_T *ar)
     /* wait for target */
     status = HTCWaitTarget(ar->arHtcTarget);
         
-    if (A_FAILED(status)) {
+    if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("HTCWaitTarget failed (%d)\n", status));
         return -ENODEV;  
     }
@@ -206,7 +206,7 @@ int ar6000_htc_raw_open(AR_SOFTC_T *ar)
             /* try to connect to the raw service */
         status = ar6000_connect_raw_service(ar,streamID);
         
-        if (A_FAILED(status)) {
+        if (status) {
             break;    
         }
         
@@ -245,7 +245,7 @@ int ar6000_htc_raw_open(AR_SOFTC_T *ar)
         arRaw->write_buffer_available[streamID] = TRUE;
     }
     
-    if (A_FAILED(status)) {
+    if (status) {
         return -EIO;    
     }
     
diff --git a/drivers/staging/ath6kl/os/linux/ar6k_pal.c b/drivers/staging/ath6kl/os/linux/ar6k_pal.c
index 10ee89e..5a0b373 100644
--- a/drivers/staging/ath6kl/os/linux/ar6k_pal.c
+++ b/drivers/staging/ath6kl/os/linux/ar6k_pal.c
@@ -304,7 +304,7 @@ static int bt_setup_hci_pal(ar6k_hci_pal_info_t *pHciPalInfo)
 
 	} while (FALSE);
 
-	if (A_FAILED(status)) {
+	if (status) {
 		bt_cleanup_hci_pal(pHciPalInfo);    
 	}
 	return status;
@@ -423,7 +423,7 @@ int ar6k_setup_hci_pal(void *ar_p)
 		pHciPalInfo->ar = ar;
 
 		status = bt_setup_hci_pal(pHciPalInfo);
-		if (A_FAILED(status)) {
+		if (status) {
 			break;    
 		}
 
@@ -437,7 +437,7 @@ int ar6k_setup_hci_pal(void *ar_p)
 		ar6k_pal_transport_ready(ar->hcipal_info);
 	} while (FALSE);
 
-	if (A_FAILED(status)) {
+	if (status) {
 		ar6k_cleanup_hci_pal(ar);    
 	}
 	return status;
diff --git a/drivers/staging/ath6kl/os/linux/hci_bridge.c b/drivers/staging/ath6kl/os/linux/hci_bridge.c
index c7e0b4e..857ef8b 100644
--- a/drivers/staging/ath6kl/os/linux/hci_bridge.c
+++ b/drivers/staging/ath6kl/os/linux/hci_bridge.c
@@ -248,7 +248,7 @@ static int ar6000_hci_transport_ready(HCI_TRANSPORT_HANDLE     HCIHandle,
             /* start transport */
         status = HCI_TransportStart(pHcidevInfo->pHCIDev);
          
-        if (A_FAILED(status)) {
+        if (status) {
             break;    
         }
         
@@ -304,14 +304,14 @@ static int ar6000_hci_transport_ready(HCI_TRANSPORT_HANDLE     HCIHandle,
         /* configure the AR3K device */         
 		memcpy(ar3kconfig.bdaddr,pHcidevInfo->ar->bdaddr,6);
         status = AR3KConfigure(&ar3kconfig);
-        if (A_FAILED(status)) {
+        if (status) {
             break; 
         }
 
         /* Make sure both AR6K and AR3K have power management enabled */
         if (ar3kconfig.PwrMgmtEnabled) {
             status = HCI_TransportEnablePowerMgmt(pHcidevInfo->pHCIDev, TRUE);
-            if (A_FAILED(status)) {
+            if (status) {
                 AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("HCI Bridge: failed to enable TLPM for AR6K! \n"));
             }
         }
@@ -354,7 +354,7 @@ static void ar6000_hci_send_complete(void *pContext, HTC_PACKET *pPacket)
     A_ASSERT(osbuf != NULL);
     A_ASSERT(pHcidevInfo != NULL);
     
-    if (A_FAILED(pPacket->Status)) {
+    if (pPacket->Status) {
         if ((pPacket->Status != A_ECANCELED) && (pPacket->Status != A_NO_RESOURCE)) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("HCI Bridge: Send Packet Failed: %d \n",pPacket->Status)); 
         }   
@@ -376,7 +376,7 @@ static void ar6000_hci_pkt_recv(void *pContext, HTC_PACKET *pPacket)
           
     do {
         
-        if (A_FAILED(pPacket->Status)) {
+        if (pPacket->Status) {
             break;
         }
   
@@ -499,7 +499,7 @@ int ar6000_setup_hci(AR_SOFTC_T *ar)
         ar->exitCallback = AR3KConfigureExit;
     
         status = bt_setup_hci(pHcidevInfo);
-        if (A_FAILED(status)) {
+        if (status) {
             break;    
         }
         
@@ -546,7 +546,7 @@ int ar6000_setup_hci(AR_SOFTC_T *ar)
     
     } while (FALSE);
     
-    if (A_FAILED(status)) {
+    if (status) {
         if (pHcidevInfo != NULL) {
             if (NULL == pHcidevInfo->pHCIDev) {
                 /* GMBOX may not be present in older chips */
@@ -877,7 +877,7 @@ static int bt_setup_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo)
                                     sizeof(osDevInfo));
 #endif
                                     
-        if (A_FAILED(status)) {
+        if (status) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Failed to OS device info from HIF\n"));
             break;
         }
@@ -906,7 +906,7 @@ static int bt_setup_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo)
         
     } while (FALSE);
     
-    if (A_FAILED(status)) {
+    if (status) {
         bt_cleanup_hci(pHcidevInfo);    
     }
     
diff --git a/drivers/staging/ath6kl/os/linux/ioctl.c b/drivers/staging/ath6kl/os/linux/ioctl.c
index a159ae5..ea1f202 100644
--- a/drivers/staging/ath6kl/os/linux/ioctl.c
+++ b/drivers/staging/ath6kl/os/linux/ioctl.c
@@ -2203,7 +2203,7 @@ int ar6000_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
                                             0,  /* use default yield */
                                             0   /* use default number of HTC ctrl buffers */
                                             );
-                if (A_FAILED(ret)) {
+                if (ret) {
                     break;
                 }
                 /* Terminate the BMI phase */
@@ -4276,7 +4276,7 @@ int ar6000_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
                 break;
             }
 
-            if (A_FAILED(a_set_module_mask(moduleinfo.modulename, moduleinfo.mask))) {
+            if (a_set_module_mask(moduleinfo.modulename, moduleinfo.mask)) {
                 ret = -EFAULT;
             }
 
@@ -4291,7 +4291,7 @@ int ar6000_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
                 break;
             }
 
-            if (A_FAILED(a_get_module_mask(moduleinfo.modulename, &moduleinfo.mask))) {
+            if (a_get_module_mask(moduleinfo.modulename, &moduleinfo.mask)) {
                 ret = -EFAULT;
                 break;
             }
diff --git a/drivers/staging/ath6kl/wmi/wmi.c b/drivers/staging/ath6kl/wmi/wmi.c
index 1cf9e96..73cf866 100644
--- a/drivers/staging/ath6kl/wmi/wmi.c
+++ b/drivers/staging/ath6kl/wmi/wmi.c
@@ -3144,7 +3144,7 @@ wmi_sync_point(struct wmi_t *wmip)
         /* if Buffer allocation for any of the dataSync fails, then do not
          * send the Synchronize cmd on the control ep
          */
-        if (A_FAILED(status)) {
+        if (status) {
             break;
         }
 
@@ -3155,7 +3155,7 @@ wmi_sync_point(struct wmi_t *wmip)
     status = wmi_cmd_send(wmip, cmd_osbuf, WMI_SYNCHRONIZE_CMDID,
                           NO_SYNC_WMIFLAG);
 
-        if (A_FAILED(status)) {
+        if (status) {
             break;
     }
             /* cmd buffer sent, we no longer own it */
@@ -3170,7 +3170,7 @@ wmi_sync_point(struct wmi_t *wmip)
                                                             trafficClass)
                                       );
 
-            if (A_FAILED(status)) {
+            if (status) {
                 break;
             }
             /* we don't own this buffer anymore, NULL it out of the array so it
-- 
1.7.4.rc3

