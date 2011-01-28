Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab1A1EFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 23:05:03 -0500
Received: from mail.perches.com ([173.55.12.10]:3419 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709Ab1A1EEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 23:04:48 -0500
From: Joe Perches <joe@perches.com>
To: Vipin Mehta <vmehta@atheros.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/15] staging: ath6kl: Convert enum A_STATUS to int
Date: Thu, 27 Jan 2011 20:04:19 -0800
Message-Id: <ca2f0c078c2d7ee857648c925d7072119d50f18d.1296186677.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1296186677.git.joe@perches.com>
References: <cover.1296186677.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert enum members to int as well.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/ath6kl/bmi/include/bmi_internal.h  |    4 +-
 drivers/staging/ath6kl/bmi/src/bmi.c               |   72 ++--
 .../hif/sdio/linux_sdio/include/hif_internal.h     |   10 +-
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   |   46 +-
 .../ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c   |   12 +-
 drivers/staging/ath6kl/htc2/AR6000/ar6k.c          |   74 ++--
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h          |   72 ++--
 drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c   |   38 +-
 drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c    |   40 +-
 .../ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c        |   58 ++--
 drivers/staging/ath6kl/htc2/htc.c                  |   10 +-
 drivers/staging/ath6kl/htc2/htc_internal.h         |    8 +-
 drivers/staging/ath6kl/htc2/htc_recv.c             |   40 +-
 drivers/staging/ath6kl/htc2/htc_send.c             |   10 +-
 drivers/staging/ath6kl/htc2/htc_services.c         |    8 +-
 drivers/staging/ath6kl/include/a_debug.h           |    4 +-
 drivers/staging/ath6kl/include/ar3kconfig.h        |    4 +-
 drivers/staging/ath6kl/include/ar6000_diag.h       |   10 +-
 drivers/staging/ath6kl/include/bmi.h               |   34 +-
 drivers/staging/ath6kl/include/common/athdefs.h    |   75 ++--
 drivers/staging/ath6kl/include/common_drv.h        |   24 +-
 drivers/staging/ath6kl/include/dset_api.h          |    4 +-
 drivers/staging/ath6kl/include/gpio_api.h          |   10 +-
 drivers/staging/ath6kl/include/hci_transport_api.h |   18 +-
 drivers/staging/ath6kl/include/hif.h               |   34 +-
 drivers/staging/ath6kl/include/htc_api.h           |   18 +-
 drivers/staging/ath6kl/include/htc_packet.h        |    2 +-
 drivers/staging/ath6kl/include/wlan_api.h          |    2 +-
 drivers/staging/ath6kl/include/wmi_api.h           |  274 +++++-----
 drivers/staging/ath6kl/miscdrv/ar3kconfig.c        |   38 +-
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c   |   28 +-
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h   |    4 +-
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c   |   18 +-
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h   |    6 +-
 drivers/staging/ath6kl/miscdrv/common_drv.c        |   66 ++--
 drivers/staging/ath6kl/miscdrv/credit_dist.c       |    2 +-
 drivers/staging/ath6kl/os/linux/ar6000_android.c   |    6 +-
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |  106 ++--
 drivers/staging/ath6kl/os/linux/ar6000_pm.c        |   34 +-
 drivers/staging/ath6kl/os/linux/ar6000_raw_if.c    |    6 +-
 drivers/staging/ath6kl/os/linux/ar6k_pal.c         |   14 +-
 drivers/staging/ath6kl/os/linux/cfg80211.c         |   10 +-
 .../staging/ath6kl/os/linux/export_hci_transport.c |   28 +-
 drivers/staging/ath6kl/os/linux/hci_bridge.c       |   48 +-
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |    8 +-
 .../ath6kl/os/linux/include/ar6xapi_linux.h        |   30 +-
 drivers/staging/ath6kl/os/linux/include/cfg80211.h |    2 +-
 .../ath6kl/os/linux/include/export_hci_transport.h |   22 +-
 .../staging/ath6kl/os/linux/include/osapi_linux.h  |   18 +-
 drivers/staging/ath6kl/os/linux/ioctl.c            |   38 +-
 drivers/staging/ath6kl/os/linux/netbuf.c           |   18 +-
 drivers/staging/ath6kl/os/linux/wireless_ext.c     |    8 +-
 drivers/staging/ath6kl/reorder/rcv_aggr.c          |    4 +-
 drivers/staging/ath6kl/wlan/src/wlan_recv_beacon.c |    2 +-
 drivers/staging/ath6kl/wmi/wmi.c                   |  528 ++++++++++----------
 55 files changed, 1055 insertions(+), 1052 deletions(-)

diff --git a/drivers/staging/ath6kl/bmi/include/bmi_internal.h b/drivers/staging/ath6kl/bmi/include/bmi_internal.h
index a44027c..34e86f3 100644
--- a/drivers/staging/ath6kl/bmi/include/bmi_internal.h
+++ b/drivers/staging/ath6kl/bmi/include/bmi_internal.h
@@ -41,12 +41,12 @@
 /* ------ Global Variable Declarations ------- */
 static A_BOOL bmiDone;
 
-A_STATUS
+int
 bmiBufferSend(HIF_DEVICE *device,
               A_UCHAR *buffer,
               A_UINT32 length);
 
-A_STATUS
+int
 bmiBufferReceive(HIF_DEVICE *device,
                  A_UCHAR *buffer,
                  A_UINT32 length,
diff --git a/drivers/staging/ath6kl/bmi/src/bmi.c b/drivers/staging/ath6kl/bmi/src/bmi.c
index f17f563..a782166 100644
--- a/drivers/staging/ath6kl/bmi/src/bmi.c
+++ b/drivers/staging/ath6kl/bmi/src/bmi.c
@@ -105,10 +105,10 @@ BMICleanup(void)
     }
 }
 
-A_STATUS
+int
 BMIDone(HIF_DEVICE *device)
 {
-    A_STATUS status;
+    int status;
     A_UINT32 cid;
 
     if (bmiDone) {
@@ -141,10 +141,10 @@ BMIDone(HIF_DEVICE *device)
     return A_OK;
 }
 
-A_STATUS
+int
 BMIGetTargetInfo(HIF_DEVICE *device, struct bmi_target_info *targ_info)
 {
-    A_STATUS status;
+    int status;
     A_UINT32 cid;
 
     if (bmiDone) {
@@ -200,14 +200,14 @@ BMIGetTargetInfo(HIF_DEVICE *device, struct bmi_target_info *targ_info)
     return A_OK;
 }
 
-A_STATUS
+int
 BMIReadMemory(HIF_DEVICE *device,
               A_UINT32 address,
               A_UCHAR *buffer,
               A_UINT32 length)
 {
     A_UINT32 cid;
-    A_STATUS status;
+    int status;
     A_UINT32 offset;
     A_UINT32 remaining, rxlen;
 
@@ -256,14 +256,14 @@ BMIReadMemory(HIF_DEVICE *device,
     return A_OK;
 }
 
-A_STATUS
+int
 BMIWriteMemory(HIF_DEVICE *device,
                A_UINT32 address,
                A_UCHAR *buffer,
                A_UINT32 length)
 {
     A_UINT32 cid;
-    A_STATUS status;
+    int status;
     A_UINT32 offset;
     A_UINT32 remaining, txlen;
     const A_UINT32 header = sizeof(cid) + sizeof(address) + sizeof(length);
@@ -321,13 +321,13 @@ BMIWriteMemory(HIF_DEVICE *device,
     return A_OK;
 }
 
-A_STATUS
+int
 BMIExecute(HIF_DEVICE *device,
            A_UINT32 address,
            A_UINT32 *param)
 {
     A_UINT32 cid;
-    A_STATUS status;
+    int status;
     A_UINT32 offset;
 
     A_ASSERT(BMI_COMMAND_FITS(sizeof(cid) + sizeof(address) + sizeof(param)));
@@ -369,12 +369,12 @@ BMIExecute(HIF_DEVICE *device,
     return A_OK;
 }
 
-A_STATUS
+int
 BMISetAppStart(HIF_DEVICE *device,
                A_UINT32 address)
 {
     A_UINT32 cid;
-    A_STATUS status;
+    int status;
     A_UINT32 offset;
 
     A_ASSERT(BMI_COMMAND_FITS(sizeof(cid) + sizeof(address)));
@@ -406,13 +406,13 @@ BMISetAppStart(HIF_DEVICE *device,
     return A_OK;
 }
 
-A_STATUS
+int
 BMIReadSOCRegister(HIF_DEVICE *device,
                    A_UINT32 address,
                    A_UINT32 *param)
 {
     A_UINT32 cid;
-    A_STATUS status;
+    int status;
     A_UINT32 offset;
 
     A_ASSERT(BMI_COMMAND_FITS(sizeof(cid) + sizeof(address)));
@@ -452,13 +452,13 @@ BMIReadSOCRegister(HIF_DEVICE *device,
     return A_OK;
 }
 
-A_STATUS
+int
 BMIWriteSOCRegister(HIF_DEVICE *device,
                     A_UINT32 address,
                     A_UINT32 param)
 {
     A_UINT32 cid;
-    A_STATUS status;
+    int status;
     A_UINT32 offset;
 
     A_ASSERT(BMI_COMMAND_FITS(sizeof(cid) + sizeof(address) + sizeof(param)));
@@ -492,7 +492,7 @@ BMIWriteSOCRegister(HIF_DEVICE *device,
     return A_OK;
 }
 
-A_STATUS
+int
 BMIrompatchInstall(HIF_DEVICE *device,
                    A_UINT32 ROM_addr,
                    A_UINT32 RAM_addr,
@@ -501,7 +501,7 @@ BMIrompatchInstall(HIF_DEVICE *device,
                    A_UINT32 *rompatch_id)
 {
     A_UINT32 cid;
-    A_STATUS status;
+    int status;
     A_UINT32 offset;
 
     A_ASSERT(BMI_COMMAND_FITS(sizeof(cid) + sizeof(ROM_addr) + sizeof(RAM_addr) +
@@ -548,12 +548,12 @@ BMIrompatchInstall(HIF_DEVICE *device,
     return A_OK;
 }
 
-A_STATUS
+int
 BMIrompatchUninstall(HIF_DEVICE *device,
                      A_UINT32 rompatch_id)
 {
     A_UINT32 cid;
-    A_STATUS status;
+    int status;
     A_UINT32 offset;
 
     A_ASSERT(BMI_COMMAND_FITS(sizeof(cid) + sizeof(rompatch_id)));
@@ -585,14 +585,14 @@ BMIrompatchUninstall(HIF_DEVICE *device,
     return A_OK;
 }
 
-static A_STATUS
+static int
 _BMIrompatchChangeActivation(HIF_DEVICE *device,
                              A_UINT32 rompatch_count,
                              A_UINT32 *rompatch_list,
                              A_UINT32 do_activate)
 {
     A_UINT32 cid;
-    A_STATUS status;
+    int status;
     A_UINT32 offset;
     A_UINT32 length;
 
@@ -629,7 +629,7 @@ _BMIrompatchChangeActivation(HIF_DEVICE *device,
     return A_OK;
 }
 
-A_STATUS
+int
 BMIrompatchActivate(HIF_DEVICE *device,
                     A_UINT32 rompatch_count,
                     A_UINT32 *rompatch_list)
@@ -637,7 +637,7 @@ BMIrompatchActivate(HIF_DEVICE *device,
     return _BMIrompatchChangeActivation(device, rompatch_count, rompatch_list, 1);
 }
 
-A_STATUS
+int
 BMIrompatchDeactivate(HIF_DEVICE *device,
                       A_UINT32 rompatch_count,
                       A_UINT32 *rompatch_list)
@@ -645,13 +645,13 @@ BMIrompatchDeactivate(HIF_DEVICE *device,
     return _BMIrompatchChangeActivation(device, rompatch_count, rompatch_list, 0);
 }
 
-A_STATUS
+int
 BMILZData(HIF_DEVICE *device,
           A_UCHAR *buffer,
           A_UINT32 length)
 {
     A_UINT32 cid;
-    A_STATUS status;
+    int status;
     A_UINT32 offset;
     A_UINT32 remaining, txlen;
     const A_UINT32 header = sizeof(cid) + sizeof(length);
@@ -695,12 +695,12 @@ BMILZData(HIF_DEVICE *device,
     return A_OK;
 }
 
-A_STATUS
+int
 BMILZStreamStart(HIF_DEVICE *device,
                  A_UINT32 address)
 {
     A_UINT32 cid;
-    A_STATUS status;
+    int status;
     A_UINT32 offset;
 
     A_ASSERT(BMI_COMMAND_FITS(sizeof(cid) + sizeof(address)));
@@ -733,12 +733,12 @@ BMILZStreamStart(HIF_DEVICE *device,
 }
 
 /* BMI Access routines */
-A_STATUS
+int
 bmiBufferSend(HIF_DEVICE *device,
               A_UCHAR *buffer,
               A_UINT32 length)
 {
-    A_STATUS status;
+    int status;
     A_UINT32 timeout;
     A_UINT32 address;
     A_UINT32 mboxAddress[HTC_MAILBOX_NUM_MAX];
@@ -781,13 +781,13 @@ bmiBufferSend(HIF_DEVICE *device,
     return status;
 }
 
-A_STATUS
+int
 bmiBufferReceive(HIF_DEVICE *device,
                  A_UCHAR *buffer,
                  A_UINT32 length,
                  A_BOOL want_timeout)
 {
-    A_STATUS status;
+    int status;
     A_UINT32 address;
     A_UINT32 mboxAddress[HTC_MAILBOX_NUM_MAX];
     HIF_PENDING_EVENTS_INFO     hifPendingEvents;
@@ -957,10 +957,10 @@ bmiBufferReceive(HIF_DEVICE *device,
     return A_OK;
 }
 
-A_STATUS
+int
 BMIFastDownload(HIF_DEVICE *device, A_UINT32 address, A_UCHAR *buffer, A_UINT32 length)
 {
-    A_STATUS status = A_ERROR;
+    int status = A_ERROR;
     A_UINT32  lastWord = 0;
     A_UINT32  lastWordOffset = length & ~0x3;
     A_UINT32  unalignedBytes = length & 0x3;
@@ -997,13 +997,13 @@ BMIFastDownload(HIF_DEVICE *device, A_UINT32 address, A_UCHAR *buffer, A_UINT32
 	return status;
 }
 
-A_STATUS
+int
 BMIRawWrite(HIF_DEVICE *device, A_UCHAR *buffer, A_UINT32 length)
 {
     return bmiBufferSend(device, buffer, length);
 }
 
-A_STATUS
+int
 BMIRawRead(HIF_DEVICE *device, A_UCHAR *buffer, A_UINT32 length, A_BOOL want_timeout)
 {
     return bmiBufferReceive(device, buffer, length, want_timeout);
diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h b/drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h
index 857f35f..f72ba6c 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h
@@ -58,7 +58,7 @@ typedef struct bus_request {
     A_UINT32 length;
     A_UINT32 request;
     void *context;
-    A_STATUS status;
+    int status;
     struct _HIF_SCATTER_REQ_PRIV *pScatterReq;      /* this request is a scatter request */
 } BUS_REQUEST;
 
@@ -110,18 +110,18 @@ typedef struct _HIF_SCATTER_REQ_PRIV {
 
 #define ATH_DEBUG_SCATTER  ATH_DEBUG_MAKE_MODULE_MASK(0)
 
-A_STATUS SetupHIFScatterSupport(HIF_DEVICE *device, HIF_DEVICE_SCATTER_SUPPORT_INFO *pInfo);
+int SetupHIFScatterSupport(HIF_DEVICE *device, HIF_DEVICE_SCATTER_SUPPORT_INFO *pInfo);
 void CleanupHIFScatterResources(HIF_DEVICE *device);
-A_STATUS DoHifReadWriteScatter(HIF_DEVICE *device, BUS_REQUEST *busrequest);
+int DoHifReadWriteScatter(HIF_DEVICE *device, BUS_REQUEST *busrequest);
 
 #else  // HIF_LINUX_MMC_SCATTER_SUPPORT
 
-static inline A_STATUS SetupHIFScatterSupport(HIF_DEVICE *device, HIF_DEVICE_SCATTER_SUPPORT_INFO *pInfo) 
+static inline int SetupHIFScatterSupport(HIF_DEVICE *device, HIF_DEVICE_SCATTER_SUPPORT_INFO *pInfo)
 {
     return A_ENOTSUP;
 }
 
-static inline A_STATUS DoHifReadWriteScatter(HIF_DEVICE *device, BUS_REQUEST *busrequest) 
+static inline int DoHifReadWriteScatter(HIF_DEVICE *device, BUS_REQUEST *busrequest)
 {
     return A_ENOTSUP;
 }
diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
index e96662b..61166a5 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
@@ -107,8 +107,8 @@ extern A_UINT32 busspeedlow;
 extern A_UINT32 debughif;
 
 static void ResetAllCards(void);
-static A_STATUS hifDisableFunc(HIF_DEVICE *device, struct sdio_func *func);
-static A_STATUS hifEnableFunc(HIF_DEVICE *device, struct sdio_func *func);
+static int hifDisableFunc(HIF_DEVICE *device, struct sdio_func *func);
+static int hifEnableFunc(HIF_DEVICE *device, struct sdio_func *func);
 
 #ifdef DEBUG
 
@@ -123,7 +123,7 @@ ATH_DEBUG_INSTANTIATE_MODULE_VAR(hif,
 
 
 /* ------ Functions ------ */
-A_STATUS HIFInit(OSDRV_CALLBACKS *callbacks)
+int HIFInit(OSDRV_CALLBACKS *callbacks)
 {
     int status;
     AR_DEBUG_ASSERT(callbacks != NULL);
@@ -152,7 +152,7 @@ A_STATUS HIFInit(OSDRV_CALLBACKS *callbacks)
 
 }
 
-static A_STATUS
+static int
 __HIFReadWrite(HIF_DEVICE *device,
              A_UINT32 address,
              A_UCHAR *buffer,
@@ -161,7 +161,7 @@ __HIFReadWrite(HIF_DEVICE *device,
              void *context)
 {
     A_UINT8 opcode;
-    A_STATUS    status = A_OK;
+    int    status = A_OK;
     int     ret;
     A_UINT8 *tbuffer;
     A_BOOL   bounced = FALSE;
@@ -329,7 +329,7 @@ void AddToAsyncList(HIF_DEVICE *device, BUS_REQUEST *busrequest)
 
 
 /* queue a read/write request */
-A_STATUS
+int
 HIFReadWrite(HIF_DEVICE *device,
              A_UINT32 address,
              A_UCHAR *buffer,
@@ -337,7 +337,7 @@ HIFReadWrite(HIF_DEVICE *device,
              A_UINT32 request,
              void *context)
 {
-    A_STATUS    status = A_OK;
+    int    status = A_OK;
     BUS_REQUEST *busrequest;
 
 
@@ -375,7 +375,7 @@ HIFReadWrite(HIF_DEVICE *device,
                     /* interrupted, exit */
                     return A_ERROR;
                 } else {
-                    A_STATUS status = busrequest->status;
+                    int status = busrequest->status;
                     AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: sync return freeing 0x%lX: 0x%X\n", 
 						      (unsigned long)busrequest, busrequest->status));
                     AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: freeing req: 0x%X\n", (unsigned int)request));
@@ -402,7 +402,7 @@ static int async_task(void *param)
  {
     HIF_DEVICE *device;
     BUS_REQUEST *request;
-    A_STATUS status;
+    int status;
     unsigned long flags;
 
     device = (HIF_DEVICE *)param;
@@ -488,7 +488,7 @@ static A_INT32 IssueSDCommand(HIF_DEVICE *device, A_UINT32 opcode, A_UINT32 arg,
     return err;
 }
 
-A_STATUS ReinitSDIO(HIF_DEVICE *device)
+int ReinitSDIO(HIF_DEVICE *device)
 {
     A_INT32 err;
     struct mmc_host *host;
@@ -647,10 +647,10 @@ A_STATUS ReinitSDIO(HIF_DEVICE *device)
     return (err) ? A_ERROR : A_OK;
 }
 
-A_STATUS
+int
 PowerStateChangeNotify(HIF_DEVICE *device, HIF_DEVICE_POWER_CHANGE_TYPE config)
 {
-    A_STATUS status = A_OK;
+    int status = A_OK;
 #if defined(CONFIG_PM)
 	struct sdio_func *func = device->func;
     int old_reset_val;
@@ -690,12 +690,12 @@ PowerStateChangeNotify(HIF_DEVICE *device, HIF_DEVICE_POWER_CHANGE_TYPE config)
     return status;
 }
 
-A_STATUS
+int
 HIFConfigureDevice(HIF_DEVICE *device, HIF_DEVICE_CONFIG_OPCODE opcode,
                    void *config, A_UINT32 configLen)
 {
     A_UINT32 count;
-    A_STATUS status = A_OK;
+    int status = A_OK;
     
     switch(opcode) {
         case HIF_DEVICE_GET_MBOX_BLOCK_SIZE:
@@ -774,7 +774,7 @@ HIFShutDownDevice(HIF_DEVICE *device)
 static void
 hifIRQHandler(struct sdio_func *func)
 {
-    A_STATUS status;
+    int status;
     HIF_DEVICE *device;
     AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: +hifIRQHandler\n"));
 
@@ -949,10 +949,10 @@ hifFreeBusRequest(HIF_DEVICE *device, BUS_REQUEST *busrequest)
     spin_unlock_irqrestore(&device->lock, flag);
 }
 
-static A_STATUS hifDisableFunc(HIF_DEVICE *device, struct sdio_func *func)
+static int hifDisableFunc(HIF_DEVICE *device, struct sdio_func *func)
 {
     int ret;
-    A_STATUS status = A_OK;
+    int status = A_OK;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: +hifDisableFunc\n"));
     device = getHifDevice(func);
@@ -1080,7 +1080,7 @@ static int hifEnableFunc(HIF_DEVICE *device, struct sdio_func *func)
 static int hifDeviceSuspend(struct device *dev)
 {
     struct sdio_func *func=dev_to_sdio_func(dev);
-    A_STATUS status = A_OK;
+    int status = A_OK;
     HIF_DEVICE *device;   
 
     device = getHifDevice(func);
@@ -1107,7 +1107,7 @@ static int hifDeviceSuspend(struct device *dev)
 static int hifDeviceResume(struct device *dev)
 {
     struct sdio_func *func=dev_to_sdio_func(dev);
-    A_STATUS status = A_OK;
+    int status = A_OK;
     HIF_DEVICE *device;   
 
     device = getHifDevice(func);
@@ -1126,7 +1126,7 @@ static int hifDeviceResume(struct device *dev)
 
 static void hifDeviceRemoved(struct sdio_func *func)
 {
-    A_STATUS status = A_OK;
+    int status = A_OK;
     HIF_DEVICE *device;
     AR_DEBUG_ASSERT(func != NULL);
 
@@ -1151,11 +1151,11 @@ static void hifDeviceRemoved(struct sdio_func *func)
 /*
  * This should be moved to AR6K HTC layer.
  */
-A_STATUS hifWaitForPendingRecv(HIF_DEVICE *device)
+int hifWaitForPendingRecv(HIF_DEVICE *device)
 {
     A_INT32 cnt = 10;
     A_UINT8 host_int_status;
-    A_STATUS status = A_OK;
+    int status = A_OK;
 
     do {            		    
         while (atomic_read(&device->irqHandling)) {
@@ -1233,7 +1233,7 @@ void HIFReleaseDevice(HIF_DEVICE  *device)
     device->claimedContext = NULL;
 }
 
-A_STATUS HIFAttachHTC(HIF_DEVICE *device, HTC_CALLBACKS *callbacks)
+int HIFAttachHTC(HIF_DEVICE *device, HTC_CALLBACKS *callbacks)
 {
     if (device->htcCallbacks.context != NULL) {
             /* already in use! */
diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
index ee8b477..ceeced4 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
@@ -79,7 +79,7 @@ static HIF_SCATTER_REQ *AllocScatterReq(HIF_DEVICE *device)
 }
 
     /* called by async task to perform the operation synchronously using direct MMC APIs  */
-A_STATUS DoHifReadWriteScatter(HIF_DEVICE *device, BUS_REQUEST *busrequest)
+int DoHifReadWriteScatter(HIF_DEVICE *device, BUS_REQUEST *busrequest)
 {
     int                     i;
     A_UINT8                 rw;
@@ -89,7 +89,7 @@ A_STATUS DoHifReadWriteScatter(HIF_DEVICE *device, BUS_REQUEST *busrequest)
     struct mmc_data         data;
     HIF_SCATTER_REQ_PRIV   *pReqPriv;   
     HIF_SCATTER_REQ        *pReq;       
-    A_STATUS                status = A_OK;
+    int                status = A_OK;
     struct                  scatterlist *pSg;
     
     pReqPriv = busrequest->pScatterReq;
@@ -199,9 +199,9 @@ A_STATUS DoHifReadWriteScatter(HIF_DEVICE *device, BUS_REQUEST *busrequest)
 }
 
     /* callback to issue a read-write scatter request */
-static A_STATUS HifReadWriteScatter(HIF_DEVICE *device, HIF_SCATTER_REQ *pReq)
+static int HifReadWriteScatter(HIF_DEVICE *device, HIF_SCATTER_REQ *pReq)
 {
-    A_STATUS             status = A_EINVAL;
+    int             status = A_EINVAL;
     A_UINT32             request = pReq->Request;
     HIF_SCATTER_REQ_PRIV *pReqPriv = (HIF_SCATTER_REQ_PRIV *)pReq->HIFPrivate[0];
     
@@ -275,9 +275,9 @@ static A_STATUS HifReadWriteScatter(HIF_DEVICE *device, HIF_SCATTER_REQ *pReq)
 }
 
     /* setup of HIF scatter resources */
-A_STATUS SetupHIFScatterSupport(HIF_DEVICE *device, HIF_DEVICE_SCATTER_SUPPORT_INFO *pInfo)
+int SetupHIFScatterSupport(HIF_DEVICE *device, HIF_DEVICE_SCATTER_SUPPORT_INFO *pInfo)
 {
-    A_STATUS              status = A_ERROR;   
+    int              status = A_ERROR;
     int                   i;
     HIF_SCATTER_REQ_PRIV *pReqPriv;
     BUS_REQUEST          *busrequest;
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
index 1efc85c..8c6d659 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
@@ -35,8 +35,8 @@
 
 #define MAILBOX_FOR_BLOCK_SIZE          1
 
-A_STATUS DevEnableInterrupts(AR6K_DEVICE *pDev);
-A_STATUS DevDisableInterrupts(AR6K_DEVICE *pDev);
+int DevEnableInterrupts(AR6K_DEVICE *pDev);
+int DevDisableInterrupts(AR6K_DEVICE *pDev);
 
 static void DevCleanupVirtualScatterSupport(AR6K_DEVICE *pDev);
 
@@ -74,10 +74,10 @@ void DevCleanup(AR6K_DEVICE *pDev)
     }
 }
 
-A_STATUS DevSetup(AR6K_DEVICE *pDev)
+int DevSetup(AR6K_DEVICE *pDev)
 {
     A_UINT32 blocksizes[AR6K_MAILBOXES];
-    A_STATUS status = A_OK;
+    int status = A_OK;
     int      i;
     HTC_CALLBACKS htcCallbacks;
 
@@ -216,9 +216,9 @@ A_STATUS DevSetup(AR6K_DEVICE *pDev)
 
 }
 
-A_STATUS DevEnableInterrupts(AR6K_DEVICE *pDev)
+int DevEnableInterrupts(AR6K_DEVICE *pDev)
 {
-    A_STATUS                  status;
+    int                  status;
     AR6K_IRQ_ENABLE_REGISTERS regs;
 
     LOCK_AR6K(pDev);
@@ -276,7 +276,7 @@ A_STATUS DevEnableInterrupts(AR6K_DEVICE *pDev)
     return status;
 }
 
-A_STATUS DevDisableInterrupts(AR6K_DEVICE *pDev)
+int DevDisableInterrupts(AR6K_DEVICE *pDev)
 {
     AR6K_IRQ_ENABLE_REGISTERS regs;
 
@@ -301,7 +301,7 @@ A_STATUS DevDisableInterrupts(AR6K_DEVICE *pDev)
 }
 
 /* enable device interrupts */
-A_STATUS DevUnmaskInterrupts(AR6K_DEVICE *pDev)
+int DevUnmaskInterrupts(AR6K_DEVICE *pDev)
 {
     /* for good measure, make sure interrupt are disabled before unmasking at the HIF
      * layer.
@@ -309,7 +309,7 @@ A_STATUS DevUnmaskInterrupts(AR6K_DEVICE *pDev)
      * and when HTC is finally ready to handle interrupts, other software can perform target "soft" resets.
      * The AR6K interrupt enables reset back to an "enabled" state when this happens.
      *  */
-    A_STATUS IntStatus = A_OK;
+    int IntStatus = A_OK;
     DevDisableInterrupts(pDev);
 
 #ifdef THREAD_X
@@ -327,7 +327,7 @@ A_STATUS DevUnmaskInterrupts(AR6K_DEVICE *pDev)
 }
 
 /* disable all device interrupts */
-A_STATUS DevMaskInterrupts(AR6K_DEVICE *pDev)
+int DevMaskInterrupts(AR6K_DEVICE *pDev)
 {
         /* mask the interrupt at the HIF layer, we don't want a stray interrupt taken while
          * we zero out our shadow registers in DevDisableInterrupts()*/
@@ -355,9 +355,9 @@ static void DevDoEnableDisableRecvAsyncHandler(void *Context, HTC_PACKET *pPacke
 /* disable packet reception (used in case the host runs out of buffers)
  * this is the "override" method when the HIF reports another methods to
  * disable recv events */
-static A_STATUS DevDoEnableDisableRecvOverride(AR6K_DEVICE *pDev, A_BOOL EnableRecv, A_BOOL AsyncMode)
+static int DevDoEnableDisableRecvOverride(AR6K_DEVICE *pDev, A_BOOL EnableRecv, A_BOOL AsyncMode)
 {
-    A_STATUS                  status = A_OK;
+    int                  status = A_OK;
     HTC_PACKET                *pIOPacket = NULL;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_TRC,("DevDoEnableDisableRecvOverride: Enable:%d Mode:%d\n",
@@ -403,9 +403,9 @@ static A_STATUS DevDoEnableDisableRecvOverride(AR6K_DEVICE *pDev, A_BOOL EnableR
 /* disable packet reception (used in case the host runs out of buffers)
  * this is the "normal" method using the interrupt enable registers through
  * the host I/F */
-static A_STATUS DevDoEnableDisableRecvNormal(AR6K_DEVICE *pDev, A_BOOL EnableRecv, A_BOOL AsyncMode)
+static int DevDoEnableDisableRecvNormal(AR6K_DEVICE *pDev, A_BOOL EnableRecv, A_BOOL AsyncMode)
 {
-    A_STATUS                  status = A_OK;
+    int                  status = A_OK;
     HTC_PACKET                *pIOPacket = NULL;
     AR6K_IRQ_ENABLE_REGISTERS regs;
 
@@ -470,7 +470,7 @@ static A_STATUS DevDoEnableDisableRecvNormal(AR6K_DEVICE *pDev, A_BOOL EnableRec
 }
 
 
-A_STATUS DevStopRecv(AR6K_DEVICE *pDev, A_BOOL AsyncMode)
+int DevStopRecv(AR6K_DEVICE *pDev, A_BOOL AsyncMode)
 {
     if (NULL == pDev->HifMaskUmaskRecvEvent) {
         return DevDoEnableDisableRecvNormal(pDev,FALSE,AsyncMode);
@@ -479,7 +479,7 @@ A_STATUS DevStopRecv(AR6K_DEVICE *pDev, A_BOOL AsyncMode)
     }
 }
 
-A_STATUS DevEnableRecv(AR6K_DEVICE *pDev, A_BOOL AsyncMode)
+int DevEnableRecv(AR6K_DEVICE *pDev, A_BOOL AsyncMode)
 {
     if (NULL == pDev->HifMaskUmaskRecvEvent) {
         return DevDoEnableDisableRecvNormal(pDev,TRUE,AsyncMode);
@@ -488,9 +488,9 @@ A_STATUS DevEnableRecv(AR6K_DEVICE *pDev, A_BOOL AsyncMode)
     }
 }
 
-A_STATUS DevWaitForPendingRecv(AR6K_DEVICE *pDev,A_UINT32 TimeoutInMs,A_BOOL *pbIsRecvPending)
+int DevWaitForPendingRecv(AR6K_DEVICE *pDev,A_UINT32 TimeoutInMs,A_BOOL *pbIsRecvPending)
 {
-    A_STATUS    status          = A_OK;
+    int    status          = A_OK;
     A_UCHAR     host_int_status = 0x0;
     A_UINT32    counter         = 0x0;
 
@@ -608,7 +608,7 @@ static void DevFreeScatterReq(HIF_DEVICE *Context, HIF_SCATTER_REQ *pReq)
     UNLOCK_AR6K(pDev);
 }
 
-A_STATUS DevCopyScatterListToFromDMABuffer(HIF_SCATTER_REQ *pReq, A_BOOL FromDMA)
+int DevCopyScatterListToFromDMABuffer(HIF_SCATTER_REQ *pReq, A_BOOL FromDMA)
 {
     A_UINT8         *pDMABuffer = NULL;
     int             i, remaining;
@@ -664,10 +664,10 @@ static void DevReadWriteScatterAsyncHandler(void *Context, HTC_PACKET *pPacket)
     AR_DEBUG_PRINTF(ATH_DEBUG_RECV,("-DevReadWriteScatterAsyncHandler \n"));
 }
 
-static A_STATUS DevReadWriteScatter(HIF_DEVICE *Context, HIF_SCATTER_REQ *pReq)
+static int DevReadWriteScatter(HIF_DEVICE *Context, HIF_SCATTER_REQ *pReq)
 {
     AR6K_DEVICE     *pDev = (AR6K_DEVICE *)Context;
-    A_STATUS        status = A_OK;
+    int        status = A_OK;
     HTC_PACKET      *pIOPacket = NULL;
     A_UINT32        request = pReq->Request;
 
@@ -749,9 +749,9 @@ static void DevCleanupVirtualScatterSupport(AR6K_DEVICE *pDev)
 }
 
     /* function to set up virtual scatter support if HIF layer has not implemented the interface */
-static A_STATUS DevSetupVirtualScatterSupport(AR6K_DEVICE *pDev)
+static int DevSetupVirtualScatterSupport(AR6K_DEVICE *pDev)
 {
-    A_STATUS                     status = A_OK;
+    int                     status = A_OK;
     int                          bufferSize, sgreqSize;
     int                          i;
     DEV_SCATTER_DMA_VIRTUAL_INFO *pVirtualInfo;
@@ -811,9 +811,9 @@ static A_STATUS DevSetupVirtualScatterSupport(AR6K_DEVICE *pDev)
 }
 
 
-A_STATUS DevSetupMsgBundling(AR6K_DEVICE *pDev, int MaxMsgsPerTransfer)
+int DevSetupMsgBundling(AR6K_DEVICE *pDev, int MaxMsgsPerTransfer)
 {
-    A_STATUS status;
+    int status;
 
     if (pDev->MailBoxInfo.Flags & HIF_MBOX_FLAG_NO_BUNDLING) {
         AR_DEBUG_PRINTF(ATH_DEBUG_WARN, ("HIF requires bundling disabled\n"));
@@ -876,9 +876,9 @@ A_STATUS DevSetupMsgBundling(AR6K_DEVICE *pDev, int MaxMsgsPerTransfer)
     return status;
 }
 
-A_STATUS DevSubmitScatterRequest(AR6K_DEVICE *pDev, HIF_SCATTER_REQ *pScatterReq, A_BOOL Read, A_BOOL Async)
+int DevSubmitScatterRequest(AR6K_DEVICE *pDev, HIF_SCATTER_REQ *pScatterReq, A_BOOL Read, A_BOOL Async)
 {
-    A_STATUS status;
+    int status;
 
     if (Read) {
             /* read operation */
@@ -1125,9 +1125,9 @@ static A_UINT16 GetEndMarker(void)
 #define ATH_PRINT_OUT_ZONE ATH_DEBUG_ERR
 
 /* send the ordered buffers to the target */
-static A_STATUS SendBuffers(AR6K_DEVICE *pDev, int mbox)
+static int SendBuffers(AR6K_DEVICE *pDev, int mbox)
 {
-    A_STATUS         status = A_OK;
+    int         status = A_OK;
     A_UINT32         request = HIF_WR_SYNC_BLOCK_INC;
     BUFFER_PROC_LIST sendList[BUFFER_PROC_LIST_DEPTH];
     int              i;
@@ -1169,9 +1169,9 @@ static A_STATUS SendBuffers(AR6K_DEVICE *pDev, int mbox)
 }
 
 /* poll the mailbox credit counter until we get a credit or timeout */
-static A_STATUS GetCredits(AR6K_DEVICE *pDev, int mbox, int *pCredits)
+static int GetCredits(AR6K_DEVICE *pDev, int mbox, int *pCredits)
 {
-    A_STATUS status = A_OK;
+    int status = A_OK;
     int      timeout = TEST_CREDITS_RECV_TIMEOUT;
     A_UINT8  credits = 0;
     A_UINT32 address;
@@ -1216,9 +1216,9 @@ static A_STATUS GetCredits(AR6K_DEVICE *pDev, int mbox, int *pCredits)
 
 
 /* wait for the buffers to come back */
-static A_STATUS RecvBuffers(AR6K_DEVICE *pDev, int mbox)
+static int RecvBuffers(AR6K_DEVICE *pDev, int mbox)
 {
-    A_STATUS         status = A_OK;
+    int         status = A_OK;
     A_UINT32         request = HIF_RD_SYNC_BLOCK_INC;
     BUFFER_PROC_LIST recvList[BUFFER_PROC_LIST_DEPTH];
     int              curBuffer;
@@ -1294,9 +1294,9 @@ static A_STATUS RecvBuffers(AR6K_DEVICE *pDev, int mbox)
 
 }
 
-static A_STATUS DoOneMboxHWTest(AR6K_DEVICE *pDev, int mbox)
+static int DoOneMboxHWTest(AR6K_DEVICE *pDev, int mbox)
 {
-    A_STATUS status;
+    int status;
 
     do {
             /* send out buffers */
@@ -1330,10 +1330,10 @@ static A_STATUS DoOneMboxHWTest(AR6K_DEVICE *pDev, int mbox)
 }
 
 /* here is where the test starts */
-A_STATUS DoMboxHWTest(AR6K_DEVICE *pDev)
+int DoMboxHWTest(AR6K_DEVICE *pDev)
 {
     int      i;
-    A_STATUS status;
+    int status;
     int      credits = 0;
     A_UINT8  params[4];
     int      numBufs;
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
index b30fd87..7578e91 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
@@ -98,9 +98,9 @@ typedef struct AR6K_ASYNC_REG_IO_BUFFER {
 
 typedef struct _AR6K_GMBOX_INFO { 
     void        *pProtocolContext;
-    A_STATUS    (*pMessagePendingCallBack)(void *pContext, A_UINT8 LookAheadBytes[], int ValidBytes);
-    A_STATUS    (*pCreditsPendingCallback)(void *pContext, int NumCredits,  A_BOOL CreditIRQEnabled);
-    void        (*pTargetFailureCallback)(void *pContext, A_STATUS Status);
+    int    (*pMessagePendingCallBack)(void *pContext, A_UINT8 LookAheadBytes[], int ValidBytes);
+    int    (*pCreditsPendingCallback)(void *pContext, int NumCredits,  A_BOOL CreditIRQEnabled);
+    void        (*pTargetFailureCallback)(void *pContext, int Status);
     void        (*pStateDumpCallback)(void *pContext);
     A_BOOL      CreditCountIRQEnabled;    
 } AR6K_GMBOX_INFO; 
@@ -121,7 +121,7 @@ typedef struct _AR6K_DEVICE {
     HTC_PACKET_QUEUE            RegisterIOList;
     AR6K_ASYNC_REG_IO_BUFFER    RegIOBuffers[AR6K_MAX_REG_IO_BUFFERS];
     void                        (*TargetFailureCallback)(void *Context);
-    A_STATUS                    (*MessagePendingCallback)(void *Context, 
+    int                    (*MessagePendingCallback)(void *Context,
                                                           A_UINT32 LookAheads[], 
                                                           int NumLookAheads, 
                                                           A_BOOL *pAsyncProc,
@@ -147,16 +147,16 @@ typedef struct _AR6K_DEVICE {
 #define UNLOCK_AR6K(p)    A_MUTEX_UNLOCK(&(p)->Lock);
 #define REF_IRQ_STATUS_RECHECK(p) (p)->RecheckIRQStatusCnt = 1  /* note: no need to lock this, it only gets set */
 
-A_STATUS DevSetup(AR6K_DEVICE *pDev);
+int DevSetup(AR6K_DEVICE *pDev);
 void     DevCleanup(AR6K_DEVICE *pDev);
-A_STATUS DevUnmaskInterrupts(AR6K_DEVICE *pDev);
-A_STATUS DevMaskInterrupts(AR6K_DEVICE *pDev);
-A_STATUS DevPollMboxMsgRecv(AR6K_DEVICE *pDev,
+int DevUnmaskInterrupts(AR6K_DEVICE *pDev);
+int DevMaskInterrupts(AR6K_DEVICE *pDev);
+int DevPollMboxMsgRecv(AR6K_DEVICE *pDev,
                             A_UINT32    *pLookAhead,
                             int          TimeoutMS);
-A_STATUS DevRWCompletionHandler(void *context, A_STATUS status);
-A_STATUS DevDsrHandler(void *context);
-A_STATUS DevCheckPendingRecvMsgsAsync(void *context);
+int DevRWCompletionHandler(void *context, int status);
+int DevDsrHandler(void *context);
+int DevCheckPendingRecvMsgsAsync(void *context);
 void     DevAsyncIrqProcessComplete(AR6K_DEVICE *pDev);
 void     DevDumpRegisters(AR6K_DEVICE               *pDev,
                           AR6K_IRQ_PROC_REGISTERS   *pIrqProcRegs,
@@ -166,20 +166,20 @@ void     DevDumpRegisters(AR6K_DEVICE               *pDev,
 #define DEV_STOP_RECV_SYNC  FALSE
 #define DEV_ENABLE_RECV_ASYNC TRUE
 #define DEV_ENABLE_RECV_SYNC  FALSE
-A_STATUS DevStopRecv(AR6K_DEVICE *pDev, A_BOOL ASyncMode);
-A_STATUS DevEnableRecv(AR6K_DEVICE *pDev, A_BOOL ASyncMode);
-A_STATUS DevEnableInterrupts(AR6K_DEVICE *pDev);
-A_STATUS DevDisableInterrupts(AR6K_DEVICE *pDev);
-A_STATUS DevWaitForPendingRecv(AR6K_DEVICE *pDev,A_UINT32 TimeoutInMs,A_BOOL *pbIsRecvPending);
+int DevStopRecv(AR6K_DEVICE *pDev, A_BOOL ASyncMode);
+int DevEnableRecv(AR6K_DEVICE *pDev, A_BOOL ASyncMode);
+int DevEnableInterrupts(AR6K_DEVICE *pDev);
+int DevDisableInterrupts(AR6K_DEVICE *pDev);
+int DevWaitForPendingRecv(AR6K_DEVICE *pDev,A_UINT32 TimeoutInMs,A_BOOL *pbIsRecvPending);
 
 #define DEV_CALC_RECV_PADDED_LEN(pDev, length) (((length) + (pDev)->BlockMask) & (~((pDev)->BlockMask)))
 #define DEV_CALC_SEND_PADDED_LEN(pDev, length) DEV_CALC_RECV_PADDED_LEN(pDev,length)
 #define DEV_IS_LEN_BLOCK_ALIGNED(pDev, length) (((length) % (pDev)->BlockSize) == 0)
 
-static INLINE A_STATUS DevSendPacket(AR6K_DEVICE *pDev, HTC_PACKET *pPacket, A_UINT32 SendLength) {
+static INLINE int DevSendPacket(AR6K_DEVICE *pDev, HTC_PACKET *pPacket, A_UINT32 SendLength) {
     A_UINT32 paddedLength;
     A_BOOL   sync = (pPacket->Completion == NULL) ? TRUE : FALSE;
-    A_STATUS status;
+    int status;
 
        /* adjust the length to be a multiple of block size if appropriate */
     paddedLength = DEV_CALC_SEND_PADDED_LEN(pDev, SendLength);
@@ -219,9 +219,9 @@ static INLINE A_STATUS DevSendPacket(AR6K_DEVICE *pDev, HTC_PACKET *pPacket, A_U
     return status;
 }
                     
-static INLINE A_STATUS DevRecvPacket(AR6K_DEVICE *pDev, HTC_PACKET *pPacket, A_UINT32 RecvLength) {
+static INLINE int DevRecvPacket(AR6K_DEVICE *pDev, HTC_PACKET *pPacket, A_UINT32 RecvLength) {
     A_UINT32 paddedLength;
-    A_STATUS status;
+    int status;
     A_BOOL   sync = (pPacket->Completion == NULL) ? TRUE : FALSE;
 
         /* adjust the length to be a multiple of block size if appropriate */
@@ -272,7 +272,7 @@ static INLINE A_STATUS DevRecvPacket(AR6K_DEVICE *pDev, HTC_PACKET *pPacket, A_U
  *  
  */
   
-A_STATUS DevCopyScatterListToFromDMABuffer(HIF_SCATTER_REQ *pReq, A_BOOL FromDMA);
+int DevCopyScatterListToFromDMABuffer(HIF_SCATTER_REQ *pReq, A_BOOL FromDMA);
     
     /* copy any READ data back into scatter list */        
 #define DEV_FINISH_SCATTER_OPERATION(pR)                      \
@@ -283,7 +283,7 @@ A_STATUS DevCopyScatterListToFromDMABuffer(HIF_SCATTER_REQ *pReq, A_BOOL FromDMA
     }
     
     /* copy any WRITE data to bounce buffer */
-static INLINE A_STATUS DEV_PREPARE_SCATTER_OPERATION(HIF_SCATTER_REQ *pReq)  { 
+static INLINE int DEV_PREPARE_SCATTER_OPERATION(HIF_SCATTER_REQ *pReq)  {
     if ((pReq->Request & HIF_WRITE) && (pReq->ScatterMethod == HIF_SCATTER_DMA_BOUNCE)) {
         return DevCopyScatterListToFromDMABuffer(pReq,TO_DMA_BUFFER);    
     } else {
@@ -292,7 +292,7 @@ static INLINE A_STATUS DEV_PREPARE_SCATTER_OPERATION(HIF_SCATTER_REQ *pReq)  {
 }
         
     
-A_STATUS DevSetupMsgBundling(AR6K_DEVICE *pDev, int MaxMsgsPerTransfer);
+int DevSetupMsgBundling(AR6K_DEVICE *pDev, int MaxMsgsPerTransfer);
                                   
 #define DEV_GET_MAX_MSG_PER_BUNDLE(pDev)        (pDev)->HifScatterInfo.MaxScatterEntries
 #define DEV_GET_MAX_BUNDLE_LENGTH(pDev)         (pDev)->HifScatterInfo.MaxTransferSizePerScatterReq
@@ -309,10 +309,10 @@ A_STATUS DevSetupMsgBundling(AR6K_DEVICE *pDev, int MaxMsgsPerTransfer);
 #define DEV_SCATTER_WRITE FALSE
 #define DEV_SCATTER_ASYNC TRUE
 #define DEV_SCATTER_SYNC  FALSE
-A_STATUS DevSubmitScatterRequest(AR6K_DEVICE *pDev, HIF_SCATTER_REQ *pScatterReq, A_BOOL Read, A_BOOL Async);
+int DevSubmitScatterRequest(AR6K_DEVICE *pDev, HIF_SCATTER_REQ *pScatterReq, A_BOOL Read, A_BOOL Async);
 
 #ifdef MBOXHW_UNIT_TEST
-A_STATUS DoMboxHWTest(AR6K_DEVICE *pDev);
+int DoMboxHWTest(AR6K_DEVICE *pDev);
 #endif
 
     /* completely virtual */
@@ -334,8 +334,8 @@ void     DumpAR6KDevState(AR6K_DEVICE *pDev);
 #ifdef ATH_AR6K_ENABLE_GMBOX
 
 void     DevCleanupGMbox(AR6K_DEVICE *pDev);
-A_STATUS DevSetupGMbox(AR6K_DEVICE *pDev);
-A_STATUS DevCheckGMboxInterrupts(AR6K_DEVICE *pDev);
+int DevSetupGMbox(AR6K_DEVICE *pDev);
+int DevCheckGMboxInterrupts(AR6K_DEVICE *pDev);
 void     DevNotifyGMboxTargetFailure(AR6K_DEVICE *pDev);
 
 #else
@@ -345,7 +345,7 @@ void     DevNotifyGMboxTargetFailure(AR6K_DEVICE *pDev);
 #define DevCheckGMboxInterrupts(p) A_OK
 #define DevNotifyGMboxTargetFailure(p)
 
-static INLINE A_STATUS DevSetupGMbox(AR6K_DEVICE *pDev) {
+static INLINE int DevSetupGMbox(AR6K_DEVICE *pDev) {
     pDev->GMboxEnabled = FALSE;
     return A_OK;    
 }
@@ -356,7 +356,7 @@ static INLINE A_STATUS DevSetupGMbox(AR6K_DEVICE *pDev) {
 
     /* GMBOX protocol modules must expose each of these internal APIs */
 HCI_TRANSPORT_HANDLE GMboxAttachProtocol(AR6K_DEVICE *pDev, HCI_TRANSPORT_CONFIG_INFO *pInfo);
-A_STATUS             GMboxProtocolInstall(AR6K_DEVICE *pDev);
+int             GMboxProtocolInstall(AR6K_DEVICE *pDev);
 void                 GMboxProtocolUninstall(AR6K_DEVICE *pDev);
 
     /* API used by GMBOX protocol modules */
@@ -372,8 +372,8 @@ AR6K_DEVICE  *HTCGetAR6KDevice(void *HTCHandle);
 
 #define DEV_GMBOX_GET_PROTOCOL(pDev)  (pDev)->GMboxInfo.pProtocolContext
 
-A_STATUS DevGMboxWrite(AR6K_DEVICE *pDev, HTC_PACKET *pPacket, A_UINT32 WriteLength);
-A_STATUS DevGMboxRead(AR6K_DEVICE *pDev, HTC_PACKET *pPacket, A_UINT32 ReadLength);
+int DevGMboxWrite(AR6K_DEVICE *pDev, HTC_PACKET *pPacket, A_UINT32 WriteLength);
+int DevGMboxRead(AR6K_DEVICE *pDev, HTC_PACKET *pPacket, A_UINT32 ReadLength);
 
 #define PROC_IO_ASYNC TRUE
 #define PROC_IO_SYNC  FALSE
@@ -387,11 +387,11 @@ typedef enum GMBOX_IRQ_ACTION_TYPE {
     GMBOX_CREDIT_IRQ_DISABLE,
 } GMBOX_IRQ_ACTION_TYPE;
 
-A_STATUS DevGMboxIRQAction(AR6K_DEVICE *pDev, GMBOX_IRQ_ACTION_TYPE, A_BOOL AsyncMode);
-A_STATUS DevGMboxReadCreditCounter(AR6K_DEVICE *pDev, A_BOOL AsyncMode, int *pCredits);
-A_STATUS DevGMboxReadCreditSize(AR6K_DEVICE *pDev, int *pCreditSize);
-A_STATUS DevGMboxRecvLookAheadPeek(AR6K_DEVICE *pDev, A_UINT8 *pLookAheadBuffer, int *pLookAheadBytes);
-A_STATUS DevGMboxSetTargetInterrupt(AR6K_DEVICE *pDev, int SignalNumber, int AckTimeoutMS);
+int DevGMboxIRQAction(AR6K_DEVICE *pDev, GMBOX_IRQ_ACTION_TYPE, A_BOOL AsyncMode);
+int DevGMboxReadCreditCounter(AR6K_DEVICE *pDev, A_BOOL AsyncMode, int *pCredits);
+int DevGMboxReadCreditSize(AR6K_DEVICE *pDev, int *pCreditSize);
+int DevGMboxRecvLookAheadPeek(AR6K_DEVICE *pDev, A_UINT8 *pLookAheadBuffer, int *pLookAheadBytes);
+int DevGMboxSetTargetInterrupt(AR6K_DEVICE *pDev, int SignalNumber, int AckTimeoutMS);
 
 #endif
 
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
index 920123b..21d88f1 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
@@ -36,12 +36,12 @@
 extern void AR6KFreeIOPacket(AR6K_DEVICE *pDev, HTC_PACKET *pPacket);
 extern HTC_PACKET *AR6KAllocIOPacket(AR6K_DEVICE *pDev);
 
-static A_STATUS DevServiceDebugInterrupt(AR6K_DEVICE *pDev);
+static int DevServiceDebugInterrupt(AR6K_DEVICE *pDev);
 
 #define DELAY_PER_INTERVAL_MS 10  /* 10 MS delay per polling interval */
 
 /* completion routine for ALL HIF layer async I/O */
-A_STATUS DevRWCompletionHandler(void *context, A_STATUS status)
+int DevRWCompletionHandler(void *context, int status)
 {
     HTC_PACKET *pPacket = (HTC_PACKET *)context;
 
@@ -59,11 +59,11 @@ A_STATUS DevRWCompletionHandler(void *context, A_STATUS status)
 }
 
 /* mailbox recv message polling */
-A_STATUS DevPollMboxMsgRecv(AR6K_DEVICE *pDev,
+int DevPollMboxMsgRecv(AR6K_DEVICE *pDev,
                             A_UINT32    *pLookAhead,
                             int          TimeoutMS)
 {
-    A_STATUS status = A_OK;
+    int status = A_OK;
     int      timeout = TimeoutMS/DELAY_PER_INTERVAL_MS;
 
     A_ASSERT(timeout > 0);
@@ -152,9 +152,9 @@ A_STATUS DevPollMboxMsgRecv(AR6K_DEVICE *pDev,
     return status;
 }
 
-static A_STATUS DevServiceCPUInterrupt(AR6K_DEVICE *pDev)
+static int DevServiceCPUInterrupt(AR6K_DEVICE *pDev)
 {
-    A_STATUS status;
+    int status;
     A_UINT8  cpu_int_status;
     A_UINT8  regBuffer[4];
 
@@ -192,9 +192,9 @@ static A_STATUS DevServiceCPUInterrupt(AR6K_DEVICE *pDev)
 }
 
 
-static A_STATUS DevServiceErrorInterrupt(AR6K_DEVICE *pDev)
+static int DevServiceErrorInterrupt(AR6K_DEVICE *pDev)
 {
-    A_STATUS status;
+    int status;
     A_UINT8  error_int_status;
     A_UINT8  regBuffer[4];
 
@@ -245,10 +245,10 @@ static A_STATUS DevServiceErrorInterrupt(AR6K_DEVICE *pDev)
     return status;
 }
 
-static A_STATUS DevServiceDebugInterrupt(AR6K_DEVICE *pDev)
+static int DevServiceDebugInterrupt(AR6K_DEVICE *pDev)
 {
     A_UINT32 dummy;
-    A_STATUS status;
+    int status;
 
     /* Send a target failure event to the application */
     AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Target debug interrupt\n"));
@@ -275,7 +275,7 @@ static A_STATUS DevServiceDebugInterrupt(AR6K_DEVICE *pDev)
     return status;
 }
 
-static A_STATUS DevServiceCounterInterrupt(AR6K_DEVICE *pDev)
+static int DevServiceCounterInterrupt(AR6K_DEVICE *pDev)
 {
     A_UINT8 counter_int_status;
 
@@ -363,7 +363,7 @@ static void DevGetEventAsyncHandler(void *Context, HTC_PACKET *pPacket)
             HIFAckInterrupt(pDev->HIFDevice);
         } else {
             int      fetched = 0;
-            A_STATUS status;
+            int status;
 
             AR_DEBUG_PRINTF(ATH_DEBUG_IRQ,
                     (" DevGetEventAsyncHandler : detected another message, lookahead :0x%X \n",
@@ -388,10 +388,10 @@ static void DevGetEventAsyncHandler(void *Context, HTC_PACKET *pPacket)
 
 /* called by the HTC layer when it wants us to check if the device has any more pending
  * recv messages, this starts off a series of async requests to read interrupt registers  */
-A_STATUS DevCheckPendingRecvMsgsAsync(void *context)
+int DevCheckPendingRecvMsgsAsync(void *context)
 {
     AR6K_DEVICE  *pDev = (AR6K_DEVICE *)context;
-    A_STATUS      status = A_OK;
+    int      status = A_OK;
     HTC_PACKET   *pIOPacket;
 
     /* this is called in an ASYNC only context, we may NOT block, sleep or call any apis that can
@@ -467,9 +467,9 @@ void DevAsyncIrqProcessComplete(AR6K_DEVICE *pDev)
 }
 
 /* process pending interrupts synchronously */
-static A_STATUS ProcessPendingIRQs(AR6K_DEVICE *pDev, A_BOOL *pDone, A_BOOL *pASyncProcessing)
+static int ProcessPendingIRQs(AR6K_DEVICE *pDev, A_BOOL *pDone, A_BOOL *pASyncProcessing)
 {
-    A_STATUS    status = A_OK;
+    int    status = A_OK;
     A_UINT8     host_int_status = 0;
     A_UINT32    lookAhead = 0;
 
@@ -681,10 +681,10 @@ static A_STATUS ProcessPendingIRQs(AR6K_DEVICE *pDev, A_BOOL *pDone, A_BOOL *pAS
 
 
 /* Synchronousinterrupt handler, this handler kicks off all interrupt processing.*/
-A_STATUS DevDsrHandler(void *context)
+int DevDsrHandler(void *context)
 {
     AR6K_DEVICE *pDev = (AR6K_DEVICE *)context;
-    A_STATUS    status = A_OK;
+    int    status = A_OK;
     A_BOOL      done = FALSE;
     A_BOOL      asyncProc = FALSE;
 
@@ -746,7 +746,7 @@ A_STATUS DevDsrHandler(void *context)
 #ifdef ATH_DEBUG_MODULE
 void DumpAR6KDevState(AR6K_DEVICE *pDev)
 {
-    A_STATUS                    status;
+    int                    status;
     AR6K_IRQ_ENABLE_REGISTERS   regs;
     AR6K_IRQ_PROC_REGISTERS     procRegs;
 
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c
index e3d270d..d6b18ee 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c
@@ -74,9 +74,9 @@ static void DevGMboxIRQActionAsyncHandler(void *Context, HTC_PACKET *pPacket)
     AR_DEBUG_PRINTF(ATH_DEBUG_IRQ,("-DevGMboxIRQActionAsyncHandler \n"));
 }
 
-static A_STATUS DevGMboxCounterEnableDisable(AR6K_DEVICE *pDev, GMBOX_IRQ_ACTION_TYPE IrqAction, A_BOOL AsyncMode)
+static int DevGMboxCounterEnableDisable(AR6K_DEVICE *pDev, GMBOX_IRQ_ACTION_TYPE IrqAction, A_BOOL AsyncMode)
 {
-    A_STATUS                  status = A_OK;
+    int                  status = A_OK;
     AR6K_IRQ_ENABLE_REGISTERS regs;
     HTC_PACKET                *pIOPacket = NULL;  
     
@@ -155,9 +155,9 @@ static A_STATUS DevGMboxCounterEnableDisable(AR6K_DEVICE *pDev, GMBOX_IRQ_ACTION
 }
 
 
-A_STATUS DevGMboxIRQAction(AR6K_DEVICE *pDev, GMBOX_IRQ_ACTION_TYPE IrqAction, A_BOOL AsyncMode)
+int DevGMboxIRQAction(AR6K_DEVICE *pDev, GMBOX_IRQ_ACTION_TYPE IrqAction, A_BOOL AsyncMode)
 {
-    A_STATUS      status = A_OK;
+    int      status = A_OK;
     HTC_PACKET    *pIOPacket = NULL;   
     A_UINT8       GMboxIntControl[4];
 
@@ -269,9 +269,9 @@ void DevCleanupGMbox(AR6K_DEVICE *pDev)
     }
 }
 
-A_STATUS DevSetupGMbox(AR6K_DEVICE *pDev)
+int DevSetupGMbox(AR6K_DEVICE *pDev)
 {
-    A_STATUS    status = A_OK;
+    int    status = A_OK;
     A_UINT8     muxControl[4];
     
     do {
@@ -322,9 +322,9 @@ A_STATUS DevSetupGMbox(AR6K_DEVICE *pDev)
     return status;
 }
 
-A_STATUS DevCheckGMboxInterrupts(AR6K_DEVICE *pDev)
+int DevCheckGMboxInterrupts(AR6K_DEVICE *pDev)
 {
-    A_STATUS status = A_OK;
+    int status = A_OK;
     A_UINT8  counter_int_status;
     int      credits;
     A_UINT8  host_int_status2;
@@ -396,11 +396,11 @@ A_STATUS DevCheckGMboxInterrupts(AR6K_DEVICE *pDev)
 }
 
 
-A_STATUS DevGMboxWrite(AR6K_DEVICE *pDev, HTC_PACKET *pPacket, A_UINT32 WriteLength) 
+int DevGMboxWrite(AR6K_DEVICE *pDev, HTC_PACKET *pPacket, A_UINT32 WriteLength)
 {
     A_UINT32 paddedLength;
     A_BOOL   sync = (pPacket->Completion == NULL) ? TRUE : FALSE;
-    A_STATUS status;
+    int status;
     A_UINT32 address;
     
        /* adjust the length to be a multiple of block size if appropriate */
@@ -433,11 +433,11 @@ A_STATUS DevGMboxWrite(AR6K_DEVICE *pDev, HTC_PACKET *pPacket, A_UINT32 WriteLen
     return status;
 }
 
-A_STATUS DevGMboxRead(AR6K_DEVICE *pDev, HTC_PACKET *pPacket, A_UINT32 ReadLength) 
+int DevGMboxRead(AR6K_DEVICE *pDev, HTC_PACKET *pPacket, A_UINT32 ReadLength)
 {
     
     A_UINT32 paddedLength;
-    A_STATUS status;
+    int status;
     A_BOOL   sync = (pPacket->Completion == NULL) ? TRUE : FALSE;
 
         /* adjust the length to be a multiple of block size if appropriate */
@@ -539,9 +539,9 @@ static void DevGMboxReadCreditsAsyncHandler(void *Context, HTC_PACKET *pPacket)
     AR_DEBUG_PRINTF(ATH_DEBUG_IRQ,("-DevGMboxReadCreditsAsyncHandler \n"));
 }
 
-A_STATUS DevGMboxReadCreditCounter(AR6K_DEVICE *pDev, A_BOOL AsyncMode, int *pCredits)
+int DevGMboxReadCreditCounter(AR6K_DEVICE *pDev, A_BOOL AsyncMode, int *pCredits)
 {
-    A_STATUS    status = A_OK;
+    int    status = A_OK;
     HTC_PACKET  *pIOPacket = NULL;  
     
     AR_DEBUG_PRINTF(ATH_DEBUG_SEND,("+DevGMboxReadCreditCounter (%s) \n", AsyncMode ? "ASYNC" : "SYNC"));
@@ -602,9 +602,9 @@ A_STATUS DevGMboxReadCreditCounter(AR6K_DEVICE *pDev, A_BOOL AsyncMode, int *pCr
     return status;
 }
 
-A_STATUS DevGMboxReadCreditSize(AR6K_DEVICE *pDev, int *pCreditSize)
+int DevGMboxReadCreditSize(AR6K_DEVICE *pDev, int *pCreditSize)
 {
-    A_STATUS    status;
+    int    status;
     A_UINT8     buffer[4];
        
     status = HIFReadWrite(pDev->HIFDevice,
@@ -634,10 +634,10 @@ void DevNotifyGMboxTargetFailure(AR6K_DEVICE *pDev)
     }
 }
 
-A_STATUS DevGMboxRecvLookAheadPeek(AR6K_DEVICE *pDev, A_UINT8 *pLookAheadBuffer, int *pLookAheadBytes)
+int DevGMboxRecvLookAheadPeek(AR6K_DEVICE *pDev, A_UINT8 *pLookAheadBuffer, int *pLookAheadBytes)
 {
 
-    A_STATUS                    status = A_OK;
+    int                    status = A_OK;
     AR6K_IRQ_PROC_REGISTERS     procRegs;
     int                         maxCopy;
   
@@ -676,9 +676,9 @@ A_STATUS DevGMboxRecvLookAheadPeek(AR6K_DEVICE *pDev, A_UINT8 *pLookAheadBuffer,
     return status; 
 }
 
-A_STATUS DevGMboxSetTargetInterrupt(AR6K_DEVICE *pDev, int Signal, int AckTimeoutMS)
+int DevGMboxSetTargetInterrupt(AR6K_DEVICE *pDev, int Signal, int AckTimeoutMS)
 {
-    A_STATUS status = A_OK;
+    int status = A_OK;
     int      i;
     A_UINT8  buffer[4];
     
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
index db6d30c..6b61dc4 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
@@ -94,7 +94,7 @@ typedef struct {
     (p)->HCIConfig.pHCISendComplete((p)->HCIConfig.pContext, (pt));                            \
 }
     
-static A_STATUS HCITrySend(GMBOX_PROTO_HCI_UART *pProt, HTC_PACKET *pPacket, A_BOOL Synchronous);
+static int HCITrySend(GMBOX_PROTO_HCI_UART *pProt, HTC_PACKET *pPacket, A_BOOL Synchronous);
 
 static void HCIUartCleanup(GMBOX_PROTO_HCI_UART *pProtocol)
 {
@@ -106,9 +106,9 @@ static void HCIUartCleanup(GMBOX_PROTO_HCI_UART *pProtocol)
     A_FREE(pProtocol);    
 }
 
-static A_STATUS InitTxCreditState(GMBOX_PROTO_HCI_UART *pProt)
+static int InitTxCreditState(GMBOX_PROTO_HCI_UART *pProt)
 {
-    A_STATUS    status;
+    int    status;
     int         credits;
     int         creditPollCount = CREDIT_POLL_COUNT;
     A_BOOL      gotCredits = FALSE;
@@ -184,13 +184,13 @@ static A_STATUS InitTxCreditState(GMBOX_PROTO_HCI_UART *pProt)
     return status;
 }
 
-static A_STATUS CreditsAvailableCallback(void *pContext, int Credits, A_BOOL CreditIRQEnabled)
+static int CreditsAvailableCallback(void *pContext, int Credits, A_BOOL CreditIRQEnabled)
 {
     GMBOX_PROTO_HCI_UART *pProt = (GMBOX_PROTO_HCI_UART *)pContext;    
     A_BOOL               enableCreditIrq = FALSE;   
     A_BOOL               disableCreditIrq = FALSE;
     A_BOOL               doPendingSends = FALSE;
-    A_STATUS             status = A_OK;
+    int             status = A_OK;
     
     /** this callback is called under 2 conditions:
      *   1. The credit IRQ interrupt was enabled and signaled.
@@ -269,14 +269,14 @@ static A_STATUS CreditsAvailableCallback(void *pContext, int Credits, A_BOOL Cre
     return status;
 }
 
-static INLINE void NotifyTransportFailure(GMBOX_PROTO_HCI_UART  *pProt, A_STATUS status)
+static INLINE void NotifyTransportFailure(GMBOX_PROTO_HCI_UART  *pProt, int status)
 {
     if (pProt->HCIConfig.TransportFailure != NULL) {
         pProt->HCIConfig.TransportFailure(pProt->HCIConfig.pContext, status);
     }
 }
 
-static void FailureCallback(void *pContext, A_STATUS Status)
+static void FailureCallback(void *pContext, int Status)
 {
     GMBOX_PROTO_HCI_UART  *pProt = (GMBOX_PROTO_HCI_UART *)pContext; 
     
@@ -299,10 +299,10 @@ static void StateDumpCallback(void *pContext)
     AR_DEBUG_PRINTF(ATH_DEBUG_ANY,("==================================================\n"));
 }
 
-static A_STATUS HCIUartMessagePending(void *pContext, A_UINT8 LookAheadBytes[], int ValidBytes)
+static int HCIUartMessagePending(void *pContext, A_UINT8 LookAheadBytes[], int ValidBytes)
 {
     GMBOX_PROTO_HCI_UART        *pProt = (GMBOX_PROTO_HCI_UART *)pContext;
-    A_STATUS                    status = A_OK;
+    int                    status = A_OK;
     int                         totalRecvLength = 0;
     HCI_TRANSPORT_PACKET_TYPE   pktType = HCI_PACKET_INVALID;
     A_BOOL                      recvRefillCalled = FALSE;
@@ -542,9 +542,9 @@ static void HCISendPacketCompletion(void *Context, HTC_PACKET *pPacket)
     AR_DEBUG_PRINTF(ATH_DEBUG_SEND,("+HCISendPacketCompletion \n"));
 }
 
-static A_STATUS SeekCreditsSynch(GMBOX_PROTO_HCI_UART *pProt)
+static int SeekCreditsSynch(GMBOX_PROTO_HCI_UART *pProt)
 {
-    A_STATUS status = A_OK;
+    int status = A_OK;
     int      credits;
     int      retry = 100;
     
@@ -574,9 +574,9 @@ static A_STATUS SeekCreditsSynch(GMBOX_PROTO_HCI_UART *pProt)
     return status;
 }
 
-static A_STATUS HCITrySend(GMBOX_PROTO_HCI_UART *pProt, HTC_PACKET *pPacket, A_BOOL Synchronous)
+static int HCITrySend(GMBOX_PROTO_HCI_UART *pProt, HTC_PACKET *pPacket, A_BOOL Synchronous)
 {   
-    A_STATUS    status = A_OK;
+    int    status = A_OK;
     int         transferLength;
     int         creditsRequired, remainder;
     A_UINT8     hciUartType;
@@ -841,9 +841,9 @@ static void FlushRecvBuffers(GMBOX_PROTO_HCI_UART *pProt)
 
 /*** protocol module install entry point ***/
 
-A_STATUS GMboxProtocolInstall(AR6K_DEVICE *pDev)
+int GMboxProtocolInstall(AR6K_DEVICE *pDev)
 {
-    A_STATUS                status = A_OK;
+    int                status = A_OK;
     GMBOX_PROTO_HCI_UART    *pProtocol = NULL;
         
     do {
@@ -903,10 +903,10 @@ void GMboxProtocolUninstall(AR6K_DEVICE *pDev)
     
 }
 
-static A_STATUS NotifyTransportReady(GMBOX_PROTO_HCI_UART  *pProt)
+static int NotifyTransportReady(GMBOX_PROTO_HCI_UART  *pProt)
 {
     HCI_TRANSPORT_PROPERTIES props;
-    A_STATUS                 status = A_OK;
+    int                 status = A_OK;
     
     do {
         
@@ -996,10 +996,10 @@ void HCI_TransportDetach(HCI_TRANSPORT_HANDLE HciTrans)
     AR_DEBUG_PRINTF(ATH_DEBUG_TRC,("-HCI_TransportAttach \n"));
 }
 
-A_STATUS HCI_TransportAddReceivePkts(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET_QUEUE *pQueue)
+int HCI_TransportAddReceivePkts(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET_QUEUE *pQueue)
 {
     GMBOX_PROTO_HCI_UART  *pProt = (GMBOX_PROTO_HCI_UART *)HciTrans; 
-    A_STATUS              status = A_OK;
+    int              status = A_OK;
     A_BOOL                unblockRecv = FALSE;
     HTC_PACKET            *pPacket;
     
@@ -1064,7 +1064,7 @@ A_STATUS HCI_TransportAddReceivePkts(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET_Q
     return A_OK;    
 }
 
-A_STATUS HCI_TransportSendPkt(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET *pPacket, A_BOOL Synchronous)
+int HCI_TransportSendPkt(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET *pPacket, A_BOOL Synchronous)
 {
     GMBOX_PROTO_HCI_UART  *pProt = (GMBOX_PROTO_HCI_UART *)HciTrans;  
     
@@ -1097,9 +1097,9 @@ void HCI_TransportStop(HCI_TRANSPORT_HANDLE HciTrans)
     AR_DEBUG_PRINTF(ATH_DEBUG_TRC,("-HCI_TransportStop \n"));
 }
 
-A_STATUS HCI_TransportStart(HCI_TRANSPORT_HANDLE HciTrans)
+int HCI_TransportStart(HCI_TRANSPORT_HANDLE HciTrans)
 {
-    A_STATUS              status;
+    int              status;
     GMBOX_PROTO_HCI_UART  *pProt = (GMBOX_PROTO_HCI_UART *)HciTrans;
     
     AR_DEBUG_PRINTF(ATH_DEBUG_TRC,("+HCI_TransportStart \n"));
@@ -1144,7 +1144,7 @@ A_STATUS HCI_TransportStart(HCI_TRANSPORT_HANDLE HciTrans)
     return status;
 }
 
-A_STATUS HCI_TransportEnableDisableAsyncRecv(HCI_TRANSPORT_HANDLE HciTrans, A_BOOL Enable)
+int HCI_TransportEnableDisableAsyncRecv(HCI_TRANSPORT_HANDLE HciTrans, A_BOOL Enable)
 {
     GMBOX_PROTO_HCI_UART  *pProt = (GMBOX_PROTO_HCI_UART *)HciTrans;
     return DevGMboxIRQAction(pProt->pDev, 
@@ -1153,12 +1153,12 @@ A_STATUS HCI_TransportEnableDisableAsyncRecv(HCI_TRANSPORT_HANDLE HciTrans, A_BO
                              
 }
 
-A_STATUS HCI_TransportRecvHCIEventSync(HCI_TRANSPORT_HANDLE HciTrans,
+int HCI_TransportRecvHCIEventSync(HCI_TRANSPORT_HANDLE HciTrans,
                                        HTC_PACKET           *pPacket,
                                        int                  MaxPollMS)
 {
     GMBOX_PROTO_HCI_UART  *pProt = (GMBOX_PROTO_HCI_UART *)HciTrans;
-    A_STATUS              status = A_OK;
+    int              status = A_OK;
     A_UINT8               lookAhead[8];
     int                   bytes;
     int                   totalRecvLength;
@@ -1225,12 +1225,12 @@ A_STATUS HCI_TransportRecvHCIEventSync(HCI_TRANSPORT_HANDLE HciTrans,
 
 #define LSB_SCRATCH_IDX     4
 #define MSB_SCRATCH_IDX     5
-A_STATUS HCI_TransportSetBaudRate(HCI_TRANSPORT_HANDLE HciTrans, A_UINT32 Baud)
+int HCI_TransportSetBaudRate(HCI_TRANSPORT_HANDLE HciTrans, A_UINT32 Baud)
 {
     GMBOX_PROTO_HCI_UART  *pProt = (GMBOX_PROTO_HCI_UART *)HciTrans;
     HIF_DEVICE *pHIFDevice = (HIF_DEVICE *)(pProt->pDev->HIFDevice);
     A_UINT32 scaledBaud, scratchAddr;
-    A_STATUS status = A_OK;
+    int status = A_OK;
 
     /* Divide the desired baud rate by 100
      * Store the LSB in the local scratch register 4 and the MSB in the local
@@ -1256,9 +1256,9 @@ A_STATUS HCI_TransportSetBaudRate(HCI_TRANSPORT_HANDLE HciTrans, A_UINT32 Baud)
     return status;
 }
 
-A_STATUS HCI_TransportEnablePowerMgmt(HCI_TRANSPORT_HANDLE HciTrans, A_BOOL Enable)
+int HCI_TransportEnablePowerMgmt(HCI_TRANSPORT_HANDLE HciTrans, A_BOOL Enable)
 {
-    A_STATUS status;
+    int status;
     GMBOX_PROTO_HCI_UART  *pProt = (GMBOX_PROTO_HCI_UART *)HciTrans;
                              
     if (Enable) {
diff --git a/drivers/staging/ath6kl/htc2/htc.c b/drivers/staging/ath6kl/htc2/htc.c
index 7df62a2..2ab5975 100644
--- a/drivers/staging/ath6kl/htc2/htc.c
+++ b/drivers/staging/ath6kl/htc2/htc.c
@@ -93,7 +93,7 @@ static void HTCCleanup(HTC_TARGET *target)
 HTC_HANDLE HTCCreate(void *hif_handle, HTC_INIT_INFO *pInfo)
 {
     HTC_TARGET              *target = NULL;
-    A_STATUS                 status = A_OK;
+    int                 status = A_OK;
     int                      i;
     A_UINT32                 ctrl_bufsz;
     A_UINT32                 blocksizes[HTC_MAILBOX_NUM_MAX];
@@ -222,10 +222,10 @@ void *HTCGetHifDevice(HTC_HANDLE HTCHandle)
 
 /* wait for the target to arrive (sends HTC Ready message)
  * this operation is fully synchronous and the message is polled for */
-A_STATUS HTCWaitTarget(HTC_HANDLE HTCHandle)
+int HTCWaitTarget(HTC_HANDLE HTCHandle)
 {
     HTC_TARGET              *target = GET_HTC_TARGET_FROM_HANDLE(HTCHandle);
-    A_STATUS                 status;
+    int                 status;
     HTC_PACKET              *pPacket = NULL;
     HTC_READY_EX_MSG        *pRdyMsg;
 
@@ -369,11 +369,11 @@ A_STATUS HTCWaitTarget(HTC_HANDLE HTCHandle)
 
 
 /* Start HTC, enable interrupts and let the target know host has finished setup */
-A_STATUS HTCStart(HTC_HANDLE HTCHandle)
+int HTCStart(HTC_HANDLE HTCHandle)
 {
     HTC_TARGET *target = GET_HTC_TARGET_FROM_HANDLE(HTCHandle);
     HTC_PACKET *pPacket;
-    A_STATUS   status;
+    int   status;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_TRC, ("HTCStart Enter\n"));
 
diff --git a/drivers/staging/ath6kl/htc2/htc_internal.h b/drivers/staging/ath6kl/htc2/htc_internal.h
index bd6754b..46364cb 100644
--- a/drivers/staging/ath6kl/htc2/htc_internal.h
+++ b/drivers/staging/ath6kl/htc2/htc_internal.h
@@ -164,14 +164,14 @@ typedef struct _HTC_TARGET {
 /* internal HTC functions */
 void        HTCControlTxComplete(void *Context, HTC_PACKET *pPacket);
 void        HTCControlRecv(void *Context, HTC_PACKET *pPacket);
-A_STATUS    HTCWaitforControlMessage(HTC_TARGET *target, HTC_PACKET **ppControlPacket);
+int    HTCWaitforControlMessage(HTC_TARGET *target, HTC_PACKET **ppControlPacket);
 HTC_PACKET *HTCAllocControlBuffer(HTC_TARGET *target, HTC_PACKET_QUEUE *pList);
 void        HTCFreeControlBuffer(HTC_TARGET *target, HTC_PACKET *pPacket, HTC_PACKET_QUEUE *pList);
-A_STATUS    HTCIssueSend(HTC_TARGET *target, HTC_PACKET *pPacket);
+int    HTCIssueSend(HTC_TARGET *target, HTC_PACKET *pPacket);
 void        HTCRecvCompleteHandler(void *Context, HTC_PACKET *pPacket);
-A_STATUS    HTCRecvMessagePendingHandler(void *Context, A_UINT32 MsgLookAheads[], int NumLookAheads, A_BOOL *pAsyncProc, int *pNumPktsFetched);
+int    HTCRecvMessagePendingHandler(void *Context, A_UINT32 MsgLookAheads[], int NumLookAheads, A_BOOL *pAsyncProc, int *pNumPktsFetched);
 void        HTCProcessCreditRpt(HTC_TARGET *target, HTC_CREDIT_REPORT *pRpt, int NumEntries, HTC_ENDPOINT_ID FromEndpoint);
-A_STATUS    HTCSendSetupComplete(HTC_TARGET *target);
+int    HTCSendSetupComplete(HTC_TARGET *target);
 void        HTCFlushRecvBuffers(HTC_TARGET *target);
 void        HTCFlushSendPkts(HTC_TARGET *target);
 
diff --git a/drivers/staging/ath6kl/htc2/htc_recv.c b/drivers/staging/ath6kl/htc2/htc_recv.c
index 3503657..189d510 100644
--- a/drivers/staging/ath6kl/htc2/htc_recv.c
+++ b/drivers/staging/ath6kl/htc2/htc_recv.c
@@ -83,7 +83,7 @@ static void DoRecvCompletion(HTC_ENDPOINT     *pEndpoint,
 
 }
 
-static INLINE A_STATUS HTCProcessTrailer(HTC_TARGET *target,
+static INLINE int HTCProcessTrailer(HTC_TARGET *target,
                                          A_UINT8    *pBuffer,
                                          int         Length,
                                          A_UINT32   *pNextLookAheads,
@@ -95,7 +95,7 @@ static INLINE A_STATUS HTCProcessTrailer(HTC_TARGET *target,
     HTC_LOOKAHEAD_REPORT    *pLookAhead;
     A_UINT8                 *pOrigBuffer;
     int                     origLength;
-    A_STATUS                status;
+    int                status;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_RECV, ("+HTCProcessTrailer (length:%d) \n", Length));
 
@@ -226,14 +226,14 @@ static INLINE A_STATUS HTCProcessTrailer(HTC_TARGET *target,
 
 /* process a received message (i.e. strip off header, process any trailer data)
  * note : locks must be released when this function is called */
-static A_STATUS HTCProcessRecvHeader(HTC_TARGET *target, 
+static int HTCProcessRecvHeader(HTC_TARGET *target,
                                      HTC_PACKET *pPacket, 
                                      A_UINT32   *pNextLookAheads, 
                                      int        *pNumLookAheads)
 {
     A_UINT8   temp;
     A_UINT8   *pBuf;
-    A_STATUS  status = A_OK;
+    int  status = A_OK;
     A_UINT16  payloadLen;
     A_UINT32  lookAhead;
 
@@ -392,7 +392,7 @@ static INLINE void HTCAsyncRecvCheckMorePackets(HTC_TARGET  *target,
 {
         /* was there a lookahead for the next packet? */
     if (NumLookAheads > 0) {
-        A_STATUS nextStatus;
+        int nextStatus;
         int      fetched = 0;
         AR_DEBUG_PRINTF(ATH_DEBUG_RECV,
                         ("HTCAsyncRecvCheckMorePackets - num lookaheads were non-zero : %d \n",
@@ -521,7 +521,7 @@ void HTCRecvCompleteHandler(void *Context, HTC_PACKET *pPacket)
     HTC_ENDPOINT    *pEndpoint;
     A_UINT32        nextLookAheads[HTC_HOST_MAX_MSG_PER_BUNDLE];
     int             numLookAheads = 0;
-    A_STATUS        status;
+    int        status;
     A_BOOL          checkMorePkts = TRUE;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_RECV, ("+HTCRecvCompleteHandler (pkt:0x%lX, status:%d, ep:%d) \n",
@@ -587,9 +587,9 @@ void HTCRecvCompleteHandler(void *Context, HTC_PACKET *pPacket)
 /* synchronously wait for a control message from the target,
  * This function is used at initialization time ONLY.  At init messages
  * on ENDPOINT 0 are expected. */
-A_STATUS HTCWaitforControlMessage(HTC_TARGET *target, HTC_PACKET **ppControlPacket)
+int HTCWaitforControlMessage(HTC_TARGET *target, HTC_PACKET **ppControlPacket)
 {
-    A_STATUS        status;
+    int        status;
     A_UINT32        lookAhead;
     HTC_PACKET      *pPacket = NULL;
     HTC_FRAME_HDR   *pHdr;
@@ -686,13 +686,13 @@ A_STATUS HTCWaitforControlMessage(HTC_TARGET *target, HTC_PACKET **ppControlPack
     return status;
 }
 
-static A_STATUS AllocAndPrepareRxPackets(HTC_TARGET       *target, 
+static int AllocAndPrepareRxPackets(HTC_TARGET       *target,
                                          A_UINT32         LookAheads[], 
                                          int              Messages,                                        
                                          HTC_ENDPOINT     *pEndpoint, 
                                          HTC_PACKET_QUEUE *pQueue)
 {
-    A_STATUS         status = A_OK;
+    int         status = A_OK;
     HTC_PACKET      *pPacket;
     HTC_FRAME_HDR   *pHdr;
     int              i,j;
@@ -887,7 +887,7 @@ static void HTCAsyncRecvScatterCompletion(HIF_SCATTER_REQ *pScatterReq)
     A_UINT32            lookAheads[HTC_HOST_MAX_MSG_PER_BUNDLE];
     int                 numLookAheads = 0;
     HTC_TARGET          *target = (HTC_TARGET *)pScatterReq->Context;
-    A_STATUS            status;
+    int            status;
     A_BOOL              partialBundle = FALSE;
     HTC_PACKET_QUEUE    localRecvQueue;
     A_BOOL              procError = FALSE;
@@ -984,13 +984,13 @@ static void HTCAsyncRecvScatterCompletion(HIF_SCATTER_REQ *pScatterReq)
     AR_DEBUG_PRINTF(ATH_DEBUG_RECV,("-HTCAsyncRecvScatterCompletion \n"));
 }
 
-static A_STATUS HTCIssueRecvPacketBundle(HTC_TARGET        *target,
+static int HTCIssueRecvPacketBundle(HTC_TARGET        *target,
                                          HTC_PACKET_QUEUE  *pRecvPktQueue, 
                                          HTC_PACKET_QUEUE  *pSyncCompletionQueue,
                                          int               *pNumPacketsFetched,
                                          A_BOOL             PartialBundle)
 {
-    A_STATUS        status = A_OK;
+    int        status = A_OK;
     HIF_SCATTER_REQ *pScatterReq;
     int             i, totalLength;
     int             pktsToScatter;
@@ -1117,10 +1117,10 @@ static INLINE void CheckRecvWaterMark(HTC_ENDPOINT    *pEndpoint)
 }
 
 /* callback when device layer or lookahead report parsing detects a pending message */
-A_STATUS HTCRecvMessagePendingHandler(void *Context, A_UINT32 MsgLookAheads[], int NumLookAheads, A_BOOL *pAsyncProc, int *pNumPktsFetched)
+int HTCRecvMessagePendingHandler(void *Context, A_UINT32 MsgLookAheads[], int NumLookAheads, A_BOOL *pAsyncProc, int *pNumPktsFetched)
 {
     HTC_TARGET      *target = (HTC_TARGET *)Context;
-    A_STATUS         status = A_OK;
+    int         status = A_OK;
     HTC_PACKET      *pPacket;
     HTC_ENDPOINT    *pEndpoint;
     A_BOOL          asyncProc = FALSE;
@@ -1385,12 +1385,12 @@ A_STATUS HTCRecvMessagePendingHandler(void *Context, A_UINT32 MsgLookAheads[], i
     return status;
 }
 
-A_STATUS HTCAddReceivePktMultiple(HTC_HANDLE HTCHandle, HTC_PACKET_QUEUE *pPktQueue)
+int HTCAddReceivePktMultiple(HTC_HANDLE HTCHandle, HTC_PACKET_QUEUE *pPktQueue)
 {
     HTC_TARGET      *target = GET_HTC_TARGET_FROM_HANDLE(HTCHandle);
     HTC_ENDPOINT    *pEndpoint;
     A_BOOL          unblockRecv = FALSE;
-    A_STATUS        status = A_OK;
+    int        status = A_OK;
     HTC_PACKET      *pFirstPacket;
 
     pFirstPacket = HTC_GET_PKT_AT_HEAD(pPktQueue);
@@ -1455,7 +1455,7 @@ A_STATUS HTCAddReceivePktMultiple(HTC_HANDLE HTCHandle, HTC_PACKET_QUEUE *pPktQu
 }
 
 /* Makes a buffer available to the HTC module */
-A_STATUS HTCAddReceivePkt(HTC_HANDLE HTCHandle, HTC_PACKET *pPacket)
+int HTCAddReceivePkt(HTC_HANDLE HTCHandle, HTC_PACKET *pPacket)
 {
     HTC_PACKET_QUEUE queue;
     INIT_HTC_PACKET_QUEUE_AND_ADD(&queue,pPacket); 
@@ -1563,11 +1563,11 @@ int HTCGetNumRecvBuffers(HTC_HANDLE      HTCHandle,
     return HTC_PACKET_QUEUE_DEPTH(&(target->EndPoint[Endpoint].RxBuffers));
 }
 
-A_STATUS HTCWaitForPendingRecv(HTC_HANDLE   HTCHandle,
+int HTCWaitForPendingRecv(HTC_HANDLE   HTCHandle,
                                A_UINT32     TimeoutInMs,
                                A_BOOL      *pbIsRecvPending)
 {
-    A_STATUS    status  = A_OK;
+    int    status  = A_OK;
     HTC_TARGET *target  = GET_HTC_TARGET_FROM_HANDLE(HTCHandle);
 
     status = DevWaitForPendingRecv(&target->Device,
diff --git a/drivers/staging/ath6kl/htc2/htc_send.c b/drivers/staging/ath6kl/htc2/htc_send.c
index bc7ee78..7974008 100644
--- a/drivers/staging/ath6kl/htc2/htc_send.c
+++ b/drivers/staging/ath6kl/htc2/htc_send.c
@@ -113,9 +113,9 @@ static void HTCSendPktCompletionHandler(void *Context, HTC_PACKET *pPacket)
     DO_EP_TX_COMPLETION(pEndpoint,&container);
 }
 
-A_STATUS HTCIssueSend(HTC_TARGET *target, HTC_PACKET *pPacket)
+int HTCIssueSend(HTC_TARGET *target, HTC_PACKET *pPacket)
 {
-    A_STATUS status;
+    int status;
     A_BOOL   sync = FALSE;
 
     if (pPacket->Completion == NULL) {
@@ -270,7 +270,7 @@ static void HTCAsyncSendScatterCompletion(HIF_SCATTER_REQ *pScatterReq)
     HTC_PACKET          *pPacket;
     HTC_ENDPOINT        *pEndpoint = (HTC_ENDPOINT *)pScatterReq->Context;
     HTC_TARGET          *target = (HTC_TARGET *)pEndpoint->target;
-    A_STATUS            status = A_OK;
+    int            status = A_OK;
     HTC_PACKET_QUEUE    sendCompletes;
     
     INIT_HTC_PACKET_QUEUE(&sendCompletes);
@@ -668,7 +668,7 @@ static HTC_SEND_QUEUE_RESULT HTCTrySend(HTC_TARGET       *target,
     return HTC_SEND_QUEUE_OK;
 }
 
-A_STATUS  HTCSendPktsMultiple(HTC_HANDLE HTCHandle, HTC_PACKET_QUEUE *pPktQueue)
+int  HTCSendPktsMultiple(HTC_HANDLE HTCHandle, HTC_PACKET_QUEUE *pPktQueue)
 {
     HTC_TARGET      *target = GET_HTC_TARGET_FROM_HANDLE(HTCHandle);
     HTC_ENDPOINT    *pEndpoint;
@@ -709,7 +709,7 @@ A_STATUS  HTCSendPktsMultiple(HTC_HANDLE HTCHandle, HTC_PACKET_QUEUE *pPktQueue)
 }
 
 /* HTC API - HTCSendPkt */
-A_STATUS HTCSendPkt(HTC_HANDLE HTCHandle, HTC_PACKET *pPacket)
+int HTCSendPkt(HTC_HANDLE HTCHandle, HTC_PACKET *pPacket)
 {
     HTC_PACKET_QUEUE queue;
     
diff --git a/drivers/staging/ath6kl/htc2/htc_services.c b/drivers/staging/ath6kl/htc2/htc_services.c
index 64fddc0..a786602 100644
--- a/drivers/staging/ath6kl/htc2/htc_services.c
+++ b/drivers/staging/ath6kl/htc2/htc_services.c
@@ -57,10 +57,10 @@ void HTCControlRecv(void *Context, HTC_PACKET *pPacket)
     HTC_RECYCLE_RX_PKT((HTC_TARGET*)Context,pPacket,&((HTC_TARGET*)Context)->EndPoint[0]);
 }
 
-A_STATUS HTCSendSetupComplete(HTC_TARGET *target)
+int HTCSendSetupComplete(HTC_TARGET *target)
 {
     HTC_PACKET             *pSendPacket = NULL;
-    A_STATUS                status;
+    int                status;
 
     do {
            /* allocate a packet to send to the target */
@@ -121,12 +121,12 @@ A_STATUS HTCSendSetupComplete(HTC_TARGET *target)
 }
 
 
-A_STATUS HTCConnectService(HTC_HANDLE               HTCHandle,
+int HTCConnectService(HTC_HANDLE               HTCHandle,
                            HTC_SERVICE_CONNECT_REQ  *pConnectReq,
                            HTC_SERVICE_CONNECT_RESP *pConnectResp)
 {
     HTC_TARGET *target = GET_HTC_TARGET_FROM_HANDLE(HTCHandle);
-    A_STATUS                            status = A_OK;
+    int                            status = A_OK;
     HTC_PACKET                          *pRecvPacket = NULL;
     HTC_PACKET                          *pSendPacket = NULL;
     HTC_CONNECT_SERVICE_RESPONSE_MSG    *pResponseMsg;
diff --git a/drivers/staging/ath6kl/include/a_debug.h b/drivers/staging/ath6kl/include/a_debug.h
index 5a1b01f..007010c 100644
--- a/drivers/staging/ath6kl/include/a_debug.h
+++ b/drivers/staging/ath6kl/include/a_debug.h
@@ -181,8 +181,8 @@ void a_register_module_debug_info(ATH_DEBUG_MODULE_DBG_INFO *pInfo);
 
 #endif
 
-A_STATUS a_get_module_mask(A_CHAR *module_name, A_UINT32 *pMask);
-A_STATUS a_set_module_mask(A_CHAR *module_name, A_UINT32 Mask);
+int a_get_module_mask(A_CHAR *module_name, A_UINT32 *pMask);
+int a_set_module_mask(A_CHAR *module_name, A_UINT32 Mask);
 void a_dump_module_debug_info_by_name(A_CHAR *module_name);
 void a_module_debug_support_init(void);
 void a_module_debug_support_cleanup(void);
diff --git a/drivers/staging/ath6kl/include/ar3kconfig.h b/drivers/staging/ath6kl/include/ar3kconfig.h
index a10788c..24f5b2a 100644
--- a/drivers/staging/ath6kl/include/ar3kconfig.h
+++ b/drivers/staging/ath6kl/include/ar3kconfig.h
@@ -54,9 +54,9 @@ typedef struct {
     A_UINT8                  bdaddr[6];       /* Bluetooth device address */
 } AR3K_CONFIG_INFO;
                                                                                         
-A_STATUS AR3KConfigure(AR3K_CONFIG_INFO *pConfigInfo);
+int AR3KConfigure(AR3K_CONFIG_INFO *pConfigInfo);
 
-A_STATUS AR3KConfigureExit(void *config);
+int AR3KConfigureExit(void *config);
 
 #ifdef __cplusplus
 }
diff --git a/drivers/staging/ath6kl/include/ar6000_diag.h b/drivers/staging/ath6kl/include/ar6000_diag.h
index b53512e..1470d20 100644
--- a/drivers/staging/ath6kl/include/ar6000_diag.h
+++ b/drivers/staging/ath6kl/include/ar6000_diag.h
@@ -25,21 +25,21 @@
 #define AR6000_DIAG_H_
 
 
-A_STATUS
+int
 ar6000_ReadRegDiag(HIF_DEVICE *hifDevice, A_UINT32 *address, A_UINT32 *data);
 
-A_STATUS
+int
 ar6000_WriteRegDiag(HIF_DEVICE *hifDevice, A_UINT32 *address, A_UINT32 *data);
 
-A_STATUS
+int
 ar6000_ReadDataDiag(HIF_DEVICE *hifDevice, A_UINT32 address,
                     A_UCHAR *data, A_UINT32 length);
 
-A_STATUS
+int
 ar6000_WriteDataDiag(HIF_DEVICE *hifDevice, A_UINT32 address,
                      A_UCHAR *data, A_UINT32 length);
 
-A_STATUS
+int
 ar6k_ReadTargetRegister(HIF_DEVICE *hifDevice, int regsel, A_UINT32 *regval);
 
 void
diff --git a/drivers/staging/ath6kl/include/bmi.h b/drivers/staging/ath6kl/include/bmi.h
index 27aa98d..9b45dc31 100644
--- a/drivers/staging/ath6kl/include/bmi.h
+++ b/drivers/staging/ath6kl/include/bmi.h
@@ -43,44 +43,44 @@ BMIInit(void);
 void
 BMICleanup(void);
 
-A_STATUS
+int
 BMIDone(HIF_DEVICE *device);
 
-A_STATUS
+int
 BMIGetTargetInfo(HIF_DEVICE *device, struct bmi_target_info *targ_info);
 
-A_STATUS
+int
 BMIReadMemory(HIF_DEVICE *device,
               A_UINT32 address,
               A_UCHAR *buffer,
               A_UINT32 length);
 
-A_STATUS
+int
 BMIWriteMemory(HIF_DEVICE *device,
                A_UINT32 address,
                A_UCHAR *buffer,
                A_UINT32 length);
 
-A_STATUS
+int
 BMIExecute(HIF_DEVICE *device,
            A_UINT32 address,
            A_UINT32 *param);
 
-A_STATUS
+int
 BMISetAppStart(HIF_DEVICE *device,
                A_UINT32 address);
 
-A_STATUS
+int
 BMIReadSOCRegister(HIF_DEVICE *device,
                    A_UINT32 address,
                    A_UINT32 *param);
 
-A_STATUS
+int
 BMIWriteSOCRegister(HIF_DEVICE *device,
                     A_UINT32 address,
                     A_UINT32 param);
 
-A_STATUS
+int
 BMIrompatchInstall(HIF_DEVICE *device,
                    A_UINT32 ROM_addr,
                    A_UINT32 RAM_addr,
@@ -88,41 +88,41 @@ BMIrompatchInstall(HIF_DEVICE *device,
                    A_UINT32 do_activate,
                    A_UINT32 *patch_id);
 
-A_STATUS
+int
 BMIrompatchUninstall(HIF_DEVICE *device,
                      A_UINT32 rompatch_id);
 
-A_STATUS
+int
 BMIrompatchActivate(HIF_DEVICE *device,
                     A_UINT32 rompatch_count,
                     A_UINT32 *rompatch_list);
 
-A_STATUS
+int
 BMIrompatchDeactivate(HIF_DEVICE *device,
                       A_UINT32 rompatch_count,
                       A_UINT32 *rompatch_list);
 
-A_STATUS
+int
 BMILZStreamStart(HIF_DEVICE *device,
                  A_UINT32 address);
 
-A_STATUS
+int
 BMILZData(HIF_DEVICE *device,
           A_UCHAR *buffer,
           A_UINT32 length);
 
-A_STATUS
+int
 BMIFastDownload(HIF_DEVICE *device,
                 A_UINT32 address,
                 A_UCHAR *buffer,
                 A_UINT32 length);
 
-A_STATUS
+int
 BMIRawWrite(HIF_DEVICE *device,
             A_UCHAR *buffer,
             A_UINT32 length);
 
-A_STATUS
+int
 BMIRawRead(HIF_DEVICE *device, 
            A_UCHAR *buffer, 
            A_UINT32 length, 
diff --git a/drivers/staging/ath6kl/include/common/athdefs.h b/drivers/staging/ath6kl/include/common/athdefs.h
index b59bfd3..2cd0720 100644
--- a/drivers/staging/ath6kl/include/common/athdefs.h
+++ b/drivers/staging/ath6kl/include/common/athdefs.h
@@ -31,44 +31,47 @@
 
 /*
  * Generic error codes that can be used by hw, sta, ap, sim, dk
- * and any other environments. Since these are enums, feel free to
- * add any more codes that you need.
+ * and any other environments.
+ * Feel free to add any more codes that you need.
  */
 
-typedef enum {
-    A_ERROR = -1,               /* Generic error return */
-    A_OK = 0,                   /* success */
-                                /* Following values start at 1 */
-    A_DEVICE_NOT_FOUND,         /* not able to find PCI device */
-    A_NO_MEMORY,                /* not able to allocate memory, not available */
-    A_MEMORY_NOT_AVAIL,         /* memory region is not free for mapping */
-    A_NO_FREE_DESC,             /* no free descriptors available */
-    A_BAD_ADDRESS,              /* address does not match descriptor */
-    A_WIN_DRIVER_ERROR,         /* used in NT_HW version, if problem at init */
-    A_REGS_NOT_MAPPED,          /* registers not correctly mapped */
-    A_EPERM,                    /* Not superuser */
-    A_EACCES,                   /* Access denied */
-    A_ENOENT,                   /* No such entry, search failed, etc. */
-    A_EEXIST,                   /* The object already exists (can't create) */
-    A_EFAULT,                   /* Bad address fault */
-    A_EBUSY,                    /* Object is busy */
-    A_EINVAL,                   /* Invalid parameter */
-    A_EMSGSIZE,                 /* Inappropriate message buffer length */
-    A_ECANCELED,                /* Operation canceled */
-    A_ENOTSUP,                  /* Operation not supported */
-    A_ECOMM,                    /* Communication error on send */
-    A_EPROTO,                   /* Protocol error */
-    A_ENODEV,                   /* No such device */
-    A_EDEVNOTUP,                /* device is not UP */
-    A_NO_RESOURCE,              /* No resources for requested operation */
-    A_HARDWARE,                 /* Hardware failure */
-    A_PENDING,                  /* Asynchronous routine; will send up results la
-ter (typically in callback) */
-    A_EBADCHANNEL,              /* The channel cannot be used */
-    A_DECRYPT_ERROR,            /* Decryption error */
-    A_PHY_ERROR,                /* RX PHY error */
-    A_CONSUMED                  /* Object was consumed */
-} A_STATUS;
+#define A_ERROR			(-1)	/* Generic error return */
+#define A_OK			0	/* success */
+#define A_DEVICE_NOT_FOUND	1	/* not able to find PCI device */
+#define A_NO_MEMORY		2	/* not able to allocate memory,
+					 * not avail#defineable */
+#define A_MEMORY_NOT_AVAIL	3	/* memory region is not free for
+					 * mapping */
+#define A_NO_FREE_DESC		4	/* no free descriptors available */
+#define A_BAD_ADDRESS		5	/* address does not match descriptor */
+#define A_WIN_DRIVER_ERROR	6	/* used in NT_HW version,
+					 * if problem at init */
+#define A_REGS_NOT_MAPPED	7	/* registers not correctly mapped */
+#define A_EPERM			8	/* Not superuser */
+#define A_EACCES		0	/* Access denied */
+#define A_ENOENT		10	/* No such entry, search failed, etc. */
+#define A_EEXIST		11	/* The object already exists
+					 * (can't create) */
+#define A_EFAULT		12	/* Bad address fault */
+#define A_EBUSY			13	/* Object is busy */
+#define A_EINVAL		14	/* Invalid parameter */
+#define A_EMSGSIZE		15	/* Bad message buffer length */
+#define A_ECANCELED		16	/* Operation canceled */
+#define A_ENOTSUP		17	/* Operation not supported */
+#define A_ECOMM			18	/* Communication error on send */
+#define A_EPROTO		19	/* Protocol error */
+#define A_ENODEV		20	/* No such device */
+#define A_EDEVNOTUP		21	/* device is not UP */
+#define A_NO_RESOURCE		22	/* No resources for
+					 * requested operation */
+#define A_HARDWARE		23	/* Hardware failure */
+#define A_PENDING		24	/* Asynchronous routine; will send up
+					 * results later
+					 * (typically in callback) */
+#define A_EBADCHANNEL		25	/* The channel cannot be used */
+#define A_DECRYPT_ERROR		26	/* Decryption error */
+#define A_PHY_ERROR		27	/* RX PHY error */
+#define A_CONSUMED		28	/* Object was consumed */
 
 #define A_SUCCESS(x)        (x == A_OK)
 #define A_FAILED(x)         (!A_SUCCESS(x))
diff --git a/drivers/staging/ath6kl/include/common_drv.h b/drivers/staging/ath6kl/include/common_drv.h
index 8ebb93d..c6f0b2d 100644
--- a/drivers/staging/ath6kl/include/common_drv.h
+++ b/drivers/staging/ath6kl/include/common_drv.h
@@ -64,28 +64,28 @@ extern "C" {
 #endif
 
 /* OS-independent APIs */
-A_STATUS ar6000_setup_credit_dist(HTC_HANDLE HTCHandle, COMMON_CREDIT_STATE_INFO *pCredInfo);
+int ar6000_setup_credit_dist(HTC_HANDLE HTCHandle, COMMON_CREDIT_STATE_INFO *pCredInfo);
 
-A_STATUS ar6000_ReadRegDiag(HIF_DEVICE *hifDevice, A_UINT32 *address, A_UINT32 *data);
+int ar6000_ReadRegDiag(HIF_DEVICE *hifDevice, A_UINT32 *address, A_UINT32 *data);
 
-A_STATUS ar6000_WriteRegDiag(HIF_DEVICE *hifDevice, A_UINT32 *address, A_UINT32 *data);
+int ar6000_WriteRegDiag(HIF_DEVICE *hifDevice, A_UINT32 *address, A_UINT32 *data);
 
-A_STATUS ar6000_ReadDataDiag(HIF_DEVICE *hifDevice, A_UINT32 address,  A_UCHAR *data, A_UINT32 length);
+int ar6000_ReadDataDiag(HIF_DEVICE *hifDevice, A_UINT32 address,  A_UCHAR *data, A_UINT32 length);
 
-A_STATUS ar6000_reset_device(HIF_DEVICE *hifDevice, A_UINT32 TargetType, A_BOOL waitForCompletion, A_BOOL coldReset);
+int ar6000_reset_device(HIF_DEVICE *hifDevice, A_UINT32 TargetType, A_BOOL waitForCompletion, A_BOOL coldReset);
 
 void ar6000_dump_target_assert_info(HIF_DEVICE *hifDevice, A_UINT32 TargetType);
 
-A_STATUS ar6000_set_htc_params(HIF_DEVICE *hifDevice,
+int ar6000_set_htc_params(HIF_DEVICE *hifDevice,
                                A_UINT32    TargetType,
                                A_UINT32    MboxIsrYieldValue,
                                A_UINT8     HtcControlBuffers);
 
-A_STATUS ar6000_prepare_target(HIF_DEVICE *hifDevice,
+int ar6000_prepare_target(HIF_DEVICE *hifDevice,
                                A_UINT32    TargetType,
                                A_UINT32    TargetVersion);
 
-A_STATUS ar6000_set_hci_bridge_flags(HIF_DEVICE *hifDevice,
+int ar6000_set_hci_bridge_flags(HIF_DEVICE *hifDevice,
                                      A_UINT32    TargetType,
                                      A_UINT32    Flags);
 
@@ -93,13 +93,13 @@ void ar6000_copy_cust_data_from_target(HIF_DEVICE *hifDevice, A_UINT32 TargetTyp
 
 A_UINT8 *ar6000_get_cust_data_buffer(A_UINT32 TargetType);
 
-A_STATUS ar6000_setBTState(void *context, A_UINT8 *pInBuf, A_UINT32 InBufSize);
+int ar6000_setBTState(void *context, A_UINT8 *pInBuf, A_UINT32 InBufSize);
 
-A_STATUS ar6000_setDevicePowerState(void *context, A_UINT8 *pInBuf, A_UINT32 InBufSize);
+int ar6000_setDevicePowerState(void *context, A_UINT8 *pInBuf, A_UINT32 InBufSize);
 
-A_STATUS ar6000_setWowMode(void *context, A_UINT8 *pInBuf, A_UINT32 InBufSize);
+int ar6000_setWowMode(void *context, A_UINT8 *pInBuf, A_UINT32 InBufSize);
 
-A_STATUS ar6000_setHostMode(void *context, A_UINT8 *pInBuf, A_UINT32 InBufSize);
+int ar6000_setHostMode(void *context, A_UINT8 *pInBuf, A_UINT32 InBufSize);
 
 #ifdef __cplusplus
 }
diff --git a/drivers/staging/ath6kl/include/dset_api.h b/drivers/staging/ath6kl/include/dset_api.h
index 0cc121f..c2014f2 100644
--- a/drivers/staging/ath6kl/include/dset_api.h
+++ b/drivers/staging/ath6kl/include/dset_api.h
@@ -39,7 +39,7 @@ extern "C" {
 #endif
 
 /* Called to send a DataSet Open Reply back to the Target. */
-A_STATUS wmi_dset_open_reply(struct wmi_t *wmip,
+int wmi_dset_open_reply(struct wmi_t *wmip,
                              A_UINT32 status,
                              A_UINT32 access_cookie,
                              A_UINT32 size,
@@ -49,7 +49,7 @@ A_STATUS wmi_dset_open_reply(struct wmi_t *wmip,
                              A_UINT32 targ_reply_arg);
 
 /* Called to send a DataSet Data Reply back to the Target. */
-A_STATUS wmi_dset_data_reply(struct wmi_t *wmip,
+int wmi_dset_data_reply(struct wmi_t *wmip,
                              A_UINT32 status,
                              A_UINT8 *host_buf,
                              A_UINT32 length,
diff --git a/drivers/staging/ath6kl/include/gpio_api.h b/drivers/staging/ath6kl/include/gpio_api.h
index 96a1503..81c228d 100644
--- a/drivers/staging/ath6kl/include/gpio_api.h
+++ b/drivers/staging/ath6kl/include/gpio_api.h
@@ -28,7 +28,7 @@
 /*
  * Send a command to the Target in order to change output on GPIO pins.
  */
-A_STATUS wmi_gpio_output_set(struct wmi_t *wmip,
+int wmi_gpio_output_set(struct wmi_t *wmip,
                              A_UINT32 set_mask,
                              A_UINT32 clear_mask,
                              A_UINT32 enable_mask,
@@ -37,23 +37,23 @@ A_STATUS wmi_gpio_output_set(struct wmi_t *wmip,
 /*
  * Send a command to the Target requesting input state of GPIO pins.
  */
-A_STATUS wmi_gpio_input_get(struct wmi_t *wmip);
+int wmi_gpio_input_get(struct wmi_t *wmip);
 
 /*
  * Send a command to the Target to change the value of a GPIO register.
  */
-A_STATUS wmi_gpio_register_set(struct wmi_t *wmip,
+int wmi_gpio_register_set(struct wmi_t *wmip,
                                A_UINT32 gpioreg_id,
                                A_UINT32 value);
 
 /*
  * Send a command to the Target to fetch the value of a GPIO register.
  */
-A_STATUS wmi_gpio_register_get(struct wmi_t *wmip, A_UINT32 gpioreg_id);
+int wmi_gpio_register_get(struct wmi_t *wmip, A_UINT32 gpioreg_id);
 
 /*
  * Send a command to the Target, acknowledging some GPIO interrupts.
  */
-A_STATUS wmi_gpio_intr_ack(struct wmi_t *wmip, A_UINT32 ack_mask);
+int wmi_gpio_intr_ack(struct wmi_t *wmip, A_UINT32 ack_mask);
 
 #endif /* _GPIO_API_H_ */
diff --git a/drivers/staging/ath6kl/include/hci_transport_api.h b/drivers/staging/ath6kl/include/hci_transport_api.h
index b5157ea..b611ab1 100644
--- a/drivers/staging/ath6kl/include/hci_transport_api.h
+++ b/drivers/staging/ath6kl/include/hci_transport_api.h
@@ -90,8 +90,8 @@ typedef struct _HCI_TRANSPORT_CONFIG_INFO {
     int      EventRecvBufferWaterMark;   /* low watermark to trigger recv refill */  
     int      MaxSendQueueDepth;          /* max number of packets in the single send queue */
     void     *pContext;                  /* context for all callbacks */
-    void     (*TransportFailure)(void *pContext, A_STATUS Status); /* transport failure callback */
-    A_STATUS (*TransportReady)(HCI_TRANSPORT_HANDLE, HCI_TRANSPORT_PROPERTIES *,void *pContext); /* transport is ready */
+    void     (*TransportFailure)(void *pContext, int Status); /* transport failure callback */
+    int (*TransportReady)(HCI_TRANSPORT_HANDLE, HCI_TRANSPORT_PROPERTIES *,void *pContext); /* transport is ready */
     void     (*TransportRemoved)(void *pContext);                  /* transport was removed */
         /* packet processing callbacks */
     HCI_TRANSPORT_SEND_PKT_COMPLETE    pHCISendComplete;
@@ -141,7 +141,7 @@ void HCI_TransportDetach(HCI_TRANSPORT_HANDLE HciTrans);
   @example:
   @see also:
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-A_STATUS    HCI_TransportAddReceivePkts(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET_QUEUE *pQueue);
+int    HCI_TransportAddReceivePkts(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET_QUEUE *pQueue);
 
 /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   @desc: Send an HCI packet packet
@@ -166,7 +166,7 @@ A_STATUS    HCI_TransportAddReceivePkts(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKE
   @example:
   @see also: 
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-A_STATUS    HCI_TransportSendPkt(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET *pPacket, A_BOOL Synchronous);
+int    HCI_TransportSendPkt(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET *pPacket, A_BOOL Synchronous);
 
 
 /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
@@ -193,7 +193,7 @@ void        HCI_TransportStop(HCI_TRANSPORT_HANDLE HciTrans);
   @example:
   @see also:
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-A_STATUS    HCI_TransportStart(HCI_TRANSPORT_HANDLE HciTrans);
+int    HCI_TransportStart(HCI_TRANSPORT_HANDLE HciTrans);
 
 /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   @desc: Enable or Disable Asynchronous Recv
@@ -206,7 +206,7 @@ A_STATUS    HCI_TransportStart(HCI_TRANSPORT_HANDLE HciTrans);
   @example:
   @see also:
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-A_STATUS    HCI_TransportEnableDisableAsyncRecv(HCI_TRANSPORT_HANDLE HciTrans, A_BOOL Enable);
+int    HCI_TransportEnableDisableAsyncRecv(HCI_TRANSPORT_HANDLE HciTrans, A_BOOL Enable);
 
 /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   @desc: Receive an event packet from the HCI transport synchronously using polling
@@ -222,7 +222,7 @@ A_STATUS    HCI_TransportEnableDisableAsyncRecv(HCI_TRANSPORT_HANDLE HciTrans, A
   @example:
   @see also: HCI_TransportEnableDisableAsyncRecv
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-A_STATUS    HCI_TransportRecvHCIEventSync(HCI_TRANSPORT_HANDLE HciTrans, 
+int    HCI_TransportRecvHCIEventSync(HCI_TRANSPORT_HANDLE HciTrans,
                                           HTC_PACKET           *pPacket,
                                           int                  MaxPollMS);
 
@@ -237,7 +237,7 @@ A_STATUS    HCI_TransportRecvHCIEventSync(HCI_TRANSPORT_HANDLE HciTrans,
   @example:
   @see also: 
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-A_STATUS    HCI_TransportSetBaudRate(HCI_TRANSPORT_HANDLE HciTrans, A_UINT32 Baud);
+int    HCI_TransportSetBaudRate(HCI_TRANSPORT_HANDLE HciTrans, A_UINT32 Baud);
 
 /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   @desc: Enable/Disable HCI Transport Power Management
@@ -250,7 +250,7 @@ A_STATUS    HCI_TransportSetBaudRate(HCI_TRANSPORT_HANDLE HciTrans, A_UINT32 Bau
   @example:
   @see also: 
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-A_STATUS HCI_TransportEnablePowerMgmt(HCI_TRANSPORT_HANDLE HciTrans, A_BOOL Enable);
+int HCI_TransportEnablePowerMgmt(HCI_TRANSPORT_HANDLE HciTrans, A_BOOL Enable);
 
 #ifdef __cplusplus
 }
diff --git a/drivers/staging/ath6kl/include/hif.h b/drivers/staging/ath6kl/include/hif.h
index 2a08267..331d985 100644
--- a/drivers/staging/ath6kl/include/hif.h
+++ b/drivers/staging/ath6kl/include/hif.h
@@ -293,7 +293,7 @@ typedef struct _HIF_SCATTER_REQ {
     A_UINT32            TotalLength;        /* total length of entire transfer */
     A_UINT32            CallerFlags;        /* caller specific flags can be stored here */
     HIF_SCATTER_COMP_CB CompletionRoutine;  /* completion routine set by caller */
-    A_STATUS            CompletionStatus;   /* status of completion */
+    int            CompletionStatus;   /* status of completion */
     void                *Context;           /* caller context for this request */
     int                 ValidScatterEntries;  /* number of valid entries set by caller */
     HIF_SCATTER_METHOD  ScatterMethod;        /* scatter method handled by HIF */  
@@ -304,7 +304,7 @@ typedef struct _HIF_SCATTER_REQ {
 
 typedef HIF_SCATTER_REQ * ( *HIF_ALLOCATE_SCATTER_REQUEST)(HIF_DEVICE *device);
 typedef void ( *HIF_FREE_SCATTER_REQUEST)(HIF_DEVICE *device, HIF_SCATTER_REQ *request);
-typedef A_STATUS ( *HIF_READWRITE_SCATTER)(HIF_DEVICE *device, HIF_SCATTER_REQ *request);
+typedef int ( *HIF_READWRITE_SCATTER)(HIF_DEVICE *device, HIF_SCATTER_REQ *request);
 
 typedef struct _HIF_DEVICE_SCATTER_SUPPORT_INFO {
         /* information returned from HIF layer */
@@ -324,19 +324,19 @@ typedef struct {
 struct htc_callbacks {
     void      *context;     /* context to pass to the dsrhandler
                                note : rwCompletionHandler is provided the context passed to HIFReadWrite  */
-    A_STATUS (* rwCompletionHandler)(void *rwContext, A_STATUS status);
-    A_STATUS (* dsrHandler)(void *context);
+    int (* rwCompletionHandler)(void *rwContext, int status);
+    int (* dsrHandler)(void *context);
 };
 
 typedef struct osdrv_callbacks {
     void      *context;     /* context to pass for all callbacks except deviceRemovedHandler 
                                the deviceRemovedHandler is only called if the device is claimed */
-    A_STATUS (* deviceInsertedHandler)(void *context, void *hif_handle);
-    A_STATUS (* deviceRemovedHandler)(void *claimedContext, void *hif_handle);
-    A_STATUS (* deviceSuspendHandler)(void *context);
-    A_STATUS (* deviceResumeHandler)(void *context);
-    A_STATUS (* deviceWakeupHandler)(void *context);  
-    A_STATUS (* devicePowerChangeHandler)(void *context, HIF_DEVICE_POWER_CHANGE_TYPE config);  
+    int (* deviceInsertedHandler)(void *context, void *hif_handle);
+    int (* deviceRemovedHandler)(void *claimedContext, void *hif_handle);
+    int (* deviceSuspendHandler)(void *context);
+    int (* deviceResumeHandler)(void *context);
+    int (* deviceWakeupHandler)(void *context);
+    int (* devicePowerChangeHandler)(void *context, HIF_DEVICE_POWER_CHANGE_TYPE config);
 } OSDRV_CALLBACKS;
 
 #define HIF_OTHER_EVENTS     (1 << 0)   /* other interrupts (non-Recv) are pending, host
@@ -355,14 +355,14 @@ typedef struct _HIF_PENDING_EVENTS_INFO {
 
     /* function to get pending events , some HIF modules use special mechanisms
      * to detect packet available and other interrupts */
-typedef A_STATUS ( *HIF_PENDING_EVENTS_FUNC)(HIF_DEVICE              *device,
+typedef int ( *HIF_PENDING_EVENTS_FUNC)(HIF_DEVICE              *device,
                                              HIF_PENDING_EVENTS_INFO *pEvents,
                                              void                    *AsyncContext);
 
 #define HIF_MASK_RECV    TRUE
 #define HIF_UNMASK_RECV  FALSE
     /* function to mask recv events */
-typedef A_STATUS ( *HIF_MASK_UNMASK_RECV_EVENT)(HIF_DEVICE  *device,
+typedef int ( *HIF_MASK_UNMASK_RECV_EVENT)(HIF_DEVICE  *device,
                                                 A_BOOL      Mask,
                                                 void        *AsyncContext);
 
@@ -372,7 +372,7 @@ typedef A_STATUS ( *HIF_MASK_UNMASK_RECV_EVENT)(HIF_DEVICE  *device,
  * and to set OS driver callbacks (i.e. insertion/removal) to the HIF layer
  * 
  */
-A_STATUS HIFInit(OSDRV_CALLBACKS *callbacks);
+int HIFInit(OSDRV_CALLBACKS *callbacks);
 
 /* This API claims the HIF device and provides a context for handling removal.
  * The device removal callback is only called when the OSDRV layer claims
@@ -382,7 +382,7 @@ void HIFClaimDevice(HIF_DEVICE *device, void *claimedContext);
 void HIFReleaseDevice(HIF_DEVICE *device);
 
 /* This API allows the HTC layer to attach to the HIF device */
-A_STATUS HIFAttachHTC(HIF_DEVICE *device, HTC_CALLBACKS *callbacks);
+int HIFAttachHTC(HIF_DEVICE *device, HTC_CALLBACKS *callbacks);
 /* This API detaches the HTC layer from the HIF device */
 void     HIFDetachHTC(HIF_DEVICE *device);
 
@@ -398,7 +398,7 @@ void     HIFDetachHTC(HIF_DEVICE *device);
  * length - Amount of data to be transmitted or received.
  * request - Characterizes the attributes of the command.
  */
-A_STATUS
+int
 HIFReadWrite(HIF_DEVICE    *device,
              A_UINT32       address,
              A_UCHAR       *buffer,
@@ -441,7 +441,7 @@ int HIFIRQEventNotify(void);
 int HIFRWCompleteEventNotify(void);
 #endif
 
-A_STATUS
+int
 HIFConfigureDevice(HIF_DEVICE *device, HIF_DEVICE_CONFIG_OPCODE opcode,
                    void *config, A_UINT32 configLen);
 
@@ -449,7 +449,7 @@ HIFConfigureDevice(HIF_DEVICE *device, HIF_DEVICE_CONFIG_OPCODE opcode,
  * This API wait for the remaining MBOX messages to be drained
  * This should be moved to HTC AR6K layer
  */
-A_STATUS hifWaitForPendingRecv(HIF_DEVICE *device);
+int hifWaitForPendingRecv(HIF_DEVICE *device);
 
 #ifdef __cplusplus
 }
diff --git a/drivers/staging/ath6kl/include/htc_api.h b/drivers/staging/ath6kl/include/htc_api.h
index b007051..94040bf 100644
--- a/drivers/staging/ath6kl/include/htc_api.h
+++ b/drivers/staging/ath6kl/include/htc_api.h
@@ -45,7 +45,7 @@ typedef A_UINT16 HTC_SERVICE_ID;
 
 typedef struct _HTC_INIT_INFO {
     void   *pContext;           /* context for target failure notification */
-    void   (*TargetFailure)(void *Instance, A_STATUS Status);
+    void   (*TargetFailure)(void *Instance, int Status);
 } HTC_INIT_INFO;
 
 /* per service connection send completion */
@@ -319,7 +319,7 @@ void        HTCSetCreditDistribution(HTC_HANDLE               HTCHandle,
   @example:
   @see also: HTCConnectService
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-A_STATUS    HTCWaitTarget(HTC_HANDLE HTCHandle);
+int    HTCWaitTarget(HTC_HANDLE HTCHandle);
 /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   @desc: Start target service communications
   @function name: HTCStart
@@ -334,7 +334,7 @@ A_STATUS    HTCWaitTarget(HTC_HANDLE HTCHandle);
   @example:
   @see also: HTCConnectService
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-A_STATUS    HTCStart(HTC_HANDLE HTCHandle);
+int    HTCStart(HTC_HANDLE HTCHandle);
 /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   @desc: Add receive packet to HTC
   @function name: HTCAddReceivePkt
@@ -348,7 +348,7 @@ A_STATUS    HTCStart(HTC_HANDLE HTCHandle);
   @example:
   @see also:
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-A_STATUS    HTCAddReceivePkt(HTC_HANDLE HTCHandle, HTC_PACKET *pPacket);
+int    HTCAddReceivePkt(HTC_HANDLE HTCHandle, HTC_PACKET *pPacket);
 /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   @desc: Connect to an HTC service
   @function name: HTCConnectService
@@ -361,7 +361,7 @@ A_STATUS    HTCAddReceivePkt(HTC_HANDLE HTCHandle, HTC_PACKET *pPacket);
   @example:
   @see also: HTCStart
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-A_STATUS    HTCConnectService(HTC_HANDLE HTCHandle,
+int    HTCConnectService(HTC_HANDLE HTCHandle,
                               HTC_SERVICE_CONNECT_REQ  *pReq,
                               HTC_SERVICE_CONNECT_RESP *pResp);
 /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
@@ -377,7 +377,7 @@ A_STATUS    HTCConnectService(HTC_HANDLE HTCHandle,
   @example:
   @see also: HTCFlushEndpoint
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-A_STATUS    HTCSendPkt(HTC_HANDLE HTCHandle, HTC_PACKET *pPacket);
+int    HTCSendPkt(HTC_HANDLE HTCHandle, HTC_PACKET *pPacket);
 /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   @desc: Stop HTC service communications
   @function name: HTCStop
@@ -511,7 +511,7 @@ void HTCUnblockRecv(HTC_HANDLE HTCHandle);
   @example:
   @see also: HTCFlushEndpoint
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-A_STATUS    HTCSendPktsMultiple(HTC_HANDLE HTCHandle, HTC_PACKET_QUEUE *pPktQueue);
+int    HTCSendPktsMultiple(HTC_HANDLE HTCHandle, HTC_PACKET_QUEUE *pPktQueue);
 
 /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   @desc: Add multiple receive packets to HTC
@@ -530,7 +530,7 @@ A_STATUS    HTCSendPktsMultiple(HTC_HANDLE HTCHandle, HTC_PACKET_QUEUE *pPktQueu
   @example:
   @see also:
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-A_STATUS    HTCAddReceivePktMultiple(HTC_HANDLE HTCHandle, HTC_PACKET_QUEUE *pPktQueue);
+int    HTCAddReceivePktMultiple(HTC_HANDLE HTCHandle, HTC_PACKET_QUEUE *pPktQueue);
 
 /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   @desc: Check if an endpoint is marked active
@@ -564,7 +564,7 @@ int         HTCGetNumRecvBuffers(HTC_HANDLE      HTCHandle,
 /* internally used functions for testing... */
 void HTCEnableRecv(HTC_HANDLE HTCHandle);
 void HTCDisableRecv(HTC_HANDLE HTCHandle);
-A_STATUS HTCWaitForPendingRecv(HTC_HANDLE   HTCHandle,
+int HTCWaitForPendingRecv(HTC_HANDLE   HTCHandle,
                                A_UINT32     TimeoutInMs,
                                A_BOOL      *pbIsRecvPending);
 
diff --git a/drivers/staging/ath6kl/include/htc_packet.h b/drivers/staging/ath6kl/include/htc_packet.h
index 15175cf..243268c 100644
--- a/drivers/staging/ath6kl/include/htc_packet.h
+++ b/drivers/staging/ath6kl/include/htc_packet.h
@@ -89,7 +89,7 @@ typedef struct _HTC_PACKET {
     A_UINT32        BufferLength;   /* length of buffer */
     A_UINT32        ActualLength;   /* actual length of payload */
     HTC_ENDPOINT_ID Endpoint;       /* endpoint that this packet was sent/recv'd from */
-    A_STATUS        Status;         /* completion status */
+    int        Status;         /* completion status */
     union {
         HTC_TX_PACKET_INFO  AsTx;   /* Tx Packet specific info */
         HTC_RX_PACKET_INFO  AsRx;   /* Rx Packet specific info */
diff --git a/drivers/staging/ath6kl/include/wlan_api.h b/drivers/staging/ath6kl/include/wlan_api.h
index f55a645..041df74 100644
--- a/drivers/staging/ath6kl/include/wlan_api.h
+++ b/drivers/staging/ath6kl/include/wlan_api.h
@@ -96,7 +96,7 @@ void wlan_node_table_init(void *wmip, struct ieee80211_node_table *nt);
 void wlan_node_table_reset(struct ieee80211_node_table *nt);
 void wlan_node_table_cleanup(struct ieee80211_node_table *nt);
 
-A_STATUS wlan_parse_beacon(A_UINT8 *buf, int framelen,
+int wlan_parse_beacon(A_UINT8 *buf, int framelen,
                            struct ieee80211_common_ie *cie);
 
 A_UINT16 wlan_ieee2freq(int chan);
diff --git a/drivers/staging/ath6kl/include/wmi_api.h b/drivers/staging/ath6kl/include/wmi_api.h
index 4a91543..5207a19 100644
--- a/drivers/staging/ath6kl/include/wmi_api.h
+++ b/drivers/staging/ath6kl/include/wmi_api.h
@@ -70,21 +70,21 @@ void wmi_shutdown(struct wmi_t *wmip);
 HTC_ENDPOINT_ID wmi_get_control_ep(struct wmi_t * wmip);
 void wmi_set_control_ep(struct wmi_t * wmip, HTC_ENDPOINT_ID eid);
 A_UINT16  wmi_get_mapped_qos_queue(struct wmi_t *, A_UINT8);
-A_STATUS wmi_dix_2_dot3(struct wmi_t *wmip, void *osbuf);
-A_STATUS wmi_data_hdr_add(struct wmi_t *wmip, void *osbuf, A_UINT8 msgType, A_BOOL bMoreData, WMI_DATA_HDR_DATA_TYPE data_type,A_UINT8 metaVersion, void *pTxMetaS);
-A_STATUS wmi_dot3_2_dix(void *osbuf);
+int wmi_dix_2_dot3(struct wmi_t *wmip, void *osbuf);
+int wmi_data_hdr_add(struct wmi_t *wmip, void *osbuf, A_UINT8 msgType, A_BOOL bMoreData, WMI_DATA_HDR_DATA_TYPE data_type,A_UINT8 metaVersion, void *pTxMetaS);
+int wmi_dot3_2_dix(void *osbuf);
 
-A_STATUS wmi_dot11_hdr_remove (struct wmi_t *wmip, void *osbuf);
-A_STATUS wmi_dot11_hdr_add(struct wmi_t *wmip, void *osbuf, NETWORK_TYPE mode);
+int wmi_dot11_hdr_remove (struct wmi_t *wmip, void *osbuf);
+int wmi_dot11_hdr_add(struct wmi_t *wmip, void *osbuf, NETWORK_TYPE mode);
 
-A_STATUS wmi_data_hdr_remove(struct wmi_t *wmip, void *osbuf);
-A_STATUS wmi_syncpoint(struct wmi_t *wmip);
-A_STATUS wmi_syncpoint_reset(struct wmi_t *wmip);
+int wmi_data_hdr_remove(struct wmi_t *wmip, void *osbuf);
+int wmi_syncpoint(struct wmi_t *wmip);
+int wmi_syncpoint_reset(struct wmi_t *wmip);
 A_UINT8 wmi_implicit_create_pstream(struct wmi_t *wmip, void *osbuf, A_UINT32 layer2Priority, A_BOOL wmmEnabled);
 
 A_UINT8 wmi_determine_userPriority (A_UINT8 *pkt, A_UINT32 layer2Pri);
 
-A_STATUS wmi_control_rx(struct wmi_t *wmip, void *osbuf);
+int wmi_control_rx(struct wmi_t *wmip, void *osbuf);
 void wmi_iterate_nodes(struct wmi_t *wmip, wlan_node_iter_func *f, void *arg);
 void wmi_free_allnodes(struct wmi_t *wmip);
 bss_t *wmi_find_node(struct wmi_t *wmip, const A_UINT8 *macaddr);
@@ -99,10 +99,10 @@ typedef enum {
     END_WMIFLAG                     /* end marker */
 } WMI_SYNC_FLAG;
 
-A_STATUS wmi_cmd_send(struct wmi_t *wmip, void *osbuf, WMI_COMMAND_ID cmdId,
+int wmi_cmd_send(struct wmi_t *wmip, void *osbuf, WMI_COMMAND_ID cmdId,
                       WMI_SYNC_FLAG flag);
 
-A_STATUS wmi_connect_cmd(struct wmi_t *wmip,
+int wmi_connect_cmd(struct wmi_t *wmip,
                          NETWORK_TYPE netType,
                          DOT11_AUTH_MODE dot11AuthMode,
                          AUTH_MODE authMode,
@@ -116,209 +116,209 @@ A_STATUS wmi_connect_cmd(struct wmi_t *wmip,
                          A_UINT16 channel,
                          A_UINT32 ctrl_flags);
 
-A_STATUS wmi_reconnect_cmd(struct wmi_t *wmip,
+int wmi_reconnect_cmd(struct wmi_t *wmip,
                            A_UINT8 *bssid,
                            A_UINT16 channel);
-A_STATUS wmi_disconnect_cmd(struct wmi_t *wmip);
-A_STATUS wmi_getrev_cmd(struct wmi_t *wmip);
-A_STATUS wmi_startscan_cmd(struct wmi_t *wmip, WMI_SCAN_TYPE scanType,
+int wmi_disconnect_cmd(struct wmi_t *wmip);
+int wmi_getrev_cmd(struct wmi_t *wmip);
+int wmi_startscan_cmd(struct wmi_t *wmip, WMI_SCAN_TYPE scanType,
                            A_BOOL forceFgScan, A_BOOL isLegacy,
                            A_UINT32 homeDwellTime, A_UINT32 forceScanInterval,
                            A_INT8 numChan, A_UINT16 *channelList);
-A_STATUS wmi_scanparams_cmd(struct wmi_t *wmip, A_UINT16 fg_start_sec,
+int wmi_scanparams_cmd(struct wmi_t *wmip, A_UINT16 fg_start_sec,
                             A_UINT16 fg_end_sec, A_UINT16 bg_sec,
                             A_UINT16 minact_chdw_msec,
                             A_UINT16 maxact_chdw_msec, A_UINT16 pas_chdw_msec,
                             A_UINT8 shScanRatio, A_UINT8 scanCtrlFlags,
                             A_UINT32 max_dfsch_act_time,
                             A_UINT16 maxact_scan_per_ssid);
-A_STATUS wmi_bssfilter_cmd(struct wmi_t *wmip, A_UINT8 filter, A_UINT32 ieMask);
-A_STATUS wmi_probedSsid_cmd(struct wmi_t *wmip, A_UINT8 index, A_UINT8 flag,
+int wmi_bssfilter_cmd(struct wmi_t *wmip, A_UINT8 filter, A_UINT32 ieMask);
+int wmi_probedSsid_cmd(struct wmi_t *wmip, A_UINT8 index, A_UINT8 flag,
                             A_UINT8 ssidLength, A_UCHAR *ssid);
-A_STATUS wmi_listeninterval_cmd(struct wmi_t *wmip, A_UINT16 listenInterval, A_UINT16 listenBeacons);
-A_STATUS wmi_bmisstime_cmd(struct wmi_t *wmip, A_UINT16 bmisstime, A_UINT16 bmissbeacons);
-A_STATUS wmi_associnfo_cmd(struct wmi_t *wmip, A_UINT8 ieType,
+int wmi_listeninterval_cmd(struct wmi_t *wmip, A_UINT16 listenInterval, A_UINT16 listenBeacons);
+int wmi_bmisstime_cmd(struct wmi_t *wmip, A_UINT16 bmisstime, A_UINT16 bmissbeacons);
+int wmi_associnfo_cmd(struct wmi_t *wmip, A_UINT8 ieType,
                            A_UINT8 ieLen, A_UINT8 *ieInfo);
-A_STATUS wmi_powermode_cmd(struct wmi_t *wmip, A_UINT8 powerMode);
-A_STATUS wmi_ibsspmcaps_cmd(struct wmi_t *wmip, A_UINT8 pmEnable, A_UINT8 ttl,
+int wmi_powermode_cmd(struct wmi_t *wmip, A_UINT8 powerMode);
+int wmi_ibsspmcaps_cmd(struct wmi_t *wmip, A_UINT8 pmEnable, A_UINT8 ttl,
                             A_UINT16 atim_windows, A_UINT16 timeout_value);
-A_STATUS wmi_apps_cmd(struct wmi_t *wmip, A_UINT8 psType, A_UINT32 idle_time,
+int wmi_apps_cmd(struct wmi_t *wmip, A_UINT8 psType, A_UINT32 idle_time,
                    A_UINT32 ps_period, A_UINT8 sleep_period);
-A_STATUS wmi_pmparams_cmd(struct wmi_t *wmip, A_UINT16 idlePeriod,
+int wmi_pmparams_cmd(struct wmi_t *wmip, A_UINT16 idlePeriod,
                            A_UINT16 psPollNum, A_UINT16 dtimPolicy,
                            A_UINT16 wakup_tx_policy, A_UINT16 num_tx_to_wakeup,
                            A_UINT16 ps_fail_event_policy);
-A_STATUS wmi_disctimeout_cmd(struct wmi_t *wmip, A_UINT8 timeout);
-A_STATUS wmi_sync_cmd(struct wmi_t *wmip, A_UINT8 syncNumber);
-A_STATUS wmi_create_pstream_cmd(struct wmi_t *wmip, WMI_CREATE_PSTREAM_CMD *pstream);
-A_STATUS wmi_delete_pstream_cmd(struct wmi_t *wmip, A_UINT8 trafficClass, A_UINT8 streamID);
-A_STATUS wmi_set_framerate_cmd(struct wmi_t *wmip, A_UINT8 bEnable, A_UINT8 type, A_UINT8 subType, A_UINT16 rateMask);
-A_STATUS wmi_set_bitrate_cmd(struct wmi_t *wmip, A_INT32 dataRate, A_INT32 mgmtRate, A_INT32 ctlRate);
-A_STATUS wmi_get_bitrate_cmd(struct wmi_t *wmip);
+int wmi_disctimeout_cmd(struct wmi_t *wmip, A_UINT8 timeout);
+int wmi_sync_cmd(struct wmi_t *wmip, A_UINT8 syncNumber);
+int wmi_create_pstream_cmd(struct wmi_t *wmip, WMI_CREATE_PSTREAM_CMD *pstream);
+int wmi_delete_pstream_cmd(struct wmi_t *wmip, A_UINT8 trafficClass, A_UINT8 streamID);
+int wmi_set_framerate_cmd(struct wmi_t *wmip, A_UINT8 bEnable, A_UINT8 type, A_UINT8 subType, A_UINT16 rateMask);
+int wmi_set_bitrate_cmd(struct wmi_t *wmip, A_INT32 dataRate, A_INT32 mgmtRate, A_INT32 ctlRate);
+int wmi_get_bitrate_cmd(struct wmi_t *wmip);
 A_INT8   wmi_validate_bitrate(struct wmi_t *wmip, A_INT32 rate, A_INT8 *rate_idx);
-A_STATUS wmi_get_regDomain_cmd(struct wmi_t *wmip);
-A_STATUS wmi_get_channelList_cmd(struct wmi_t *wmip);
-A_STATUS wmi_set_channelParams_cmd(struct wmi_t *wmip, A_UINT8 scanParam,
+int wmi_get_regDomain_cmd(struct wmi_t *wmip);
+int wmi_get_channelList_cmd(struct wmi_t *wmip);
+int wmi_set_channelParams_cmd(struct wmi_t *wmip, A_UINT8 scanParam,
                                    WMI_PHY_MODE mode, A_INT8 numChan,
                                    A_UINT16 *channelList);
 
-A_STATUS wmi_set_snr_threshold_params(struct wmi_t *wmip,
+int wmi_set_snr_threshold_params(struct wmi_t *wmip,
                                        WMI_SNR_THRESHOLD_PARAMS_CMD *snrCmd);
-A_STATUS wmi_set_rssi_threshold_params(struct wmi_t *wmip,
+int wmi_set_rssi_threshold_params(struct wmi_t *wmip,
                                         WMI_RSSI_THRESHOLD_PARAMS_CMD *rssiCmd);
-A_STATUS wmi_clr_rssi_snr(struct wmi_t *wmip);
-A_STATUS wmi_set_lq_threshold_params(struct wmi_t *wmip,
+int wmi_clr_rssi_snr(struct wmi_t *wmip);
+int wmi_set_lq_threshold_params(struct wmi_t *wmip,
                                       WMI_LQ_THRESHOLD_PARAMS_CMD *lqCmd);
-A_STATUS wmi_set_rts_cmd(struct wmi_t *wmip, A_UINT16 threshold);
-A_STATUS wmi_set_lpreamble_cmd(struct wmi_t *wmip, A_UINT8 status, A_UINT8 preamblePolicy);
+int wmi_set_rts_cmd(struct wmi_t *wmip, A_UINT16 threshold);
+int wmi_set_lpreamble_cmd(struct wmi_t *wmip, A_UINT8 status, A_UINT8 preamblePolicy);
 
-A_STATUS wmi_set_error_report_bitmask(struct wmi_t *wmip, A_UINT32 bitmask);
+int wmi_set_error_report_bitmask(struct wmi_t *wmip, A_UINT32 bitmask);
 
-A_STATUS wmi_get_challenge_resp_cmd(struct wmi_t *wmip, A_UINT32 cookie,
+int wmi_get_challenge_resp_cmd(struct wmi_t *wmip, A_UINT32 cookie,
                                     A_UINT32 source);
 
-A_STATUS wmi_config_debug_module_cmd(struct wmi_t *wmip, A_UINT16 mmask,
+int wmi_config_debug_module_cmd(struct wmi_t *wmip, A_UINT16 mmask,
                                      A_UINT16 tsr, A_BOOL rep, A_UINT16 size,
                                      A_UINT32 valid);
 
-A_STATUS wmi_get_stats_cmd(struct wmi_t *wmip);
+int wmi_get_stats_cmd(struct wmi_t *wmip);
 
-A_STATUS wmi_addKey_cmd(struct wmi_t *wmip, A_UINT8 keyIndex,
+int wmi_addKey_cmd(struct wmi_t *wmip, A_UINT8 keyIndex,
                         CRYPTO_TYPE keyType, A_UINT8 keyUsage,
                         A_UINT8 keyLength,A_UINT8 *keyRSC,
                         A_UINT8 *keyMaterial, A_UINT8 key_op_ctrl, A_UINT8 *mac,
                         WMI_SYNC_FLAG sync_flag);
-A_STATUS wmi_add_krk_cmd(struct wmi_t *wmip, A_UINT8 *krk);
-A_STATUS wmi_delete_krk_cmd(struct wmi_t *wmip);
-A_STATUS wmi_deleteKey_cmd(struct wmi_t *wmip, A_UINT8 keyIndex);
-A_STATUS wmi_set_akmp_params_cmd(struct wmi_t *wmip,
+int wmi_add_krk_cmd(struct wmi_t *wmip, A_UINT8 *krk);
+int wmi_delete_krk_cmd(struct wmi_t *wmip);
+int wmi_deleteKey_cmd(struct wmi_t *wmip, A_UINT8 keyIndex);
+int wmi_set_akmp_params_cmd(struct wmi_t *wmip,
                                  WMI_SET_AKMP_PARAMS_CMD *akmpParams);
-A_STATUS wmi_get_pmkid_list_cmd(struct wmi_t *wmip);
-A_STATUS wmi_set_pmkid_list_cmd(struct wmi_t *wmip,
+int wmi_get_pmkid_list_cmd(struct wmi_t *wmip);
+int wmi_set_pmkid_list_cmd(struct wmi_t *wmip,
                                 WMI_SET_PMKID_LIST_CMD *pmkInfo);
-A_STATUS wmi_abort_scan_cmd(struct wmi_t *wmip);
-A_STATUS wmi_set_txPwr_cmd(struct wmi_t *wmip, A_UINT8 dbM);
-A_STATUS wmi_get_txPwr_cmd(struct wmi_t *wmip);
-A_STATUS wmi_addBadAp_cmd(struct wmi_t *wmip, A_UINT8 apIndex, A_UINT8 *bssid);
-A_STATUS wmi_deleteBadAp_cmd(struct wmi_t *wmip, A_UINT8 apIndex);
-A_STATUS wmi_set_tkip_countermeasures_cmd(struct wmi_t *wmip, A_BOOL en);
-A_STATUS wmi_setPmkid_cmd(struct wmi_t *wmip, A_UINT8 *bssid, A_UINT8 *pmkId,
+int wmi_abort_scan_cmd(struct wmi_t *wmip);
+int wmi_set_txPwr_cmd(struct wmi_t *wmip, A_UINT8 dbM);
+int wmi_get_txPwr_cmd(struct wmi_t *wmip);
+int wmi_addBadAp_cmd(struct wmi_t *wmip, A_UINT8 apIndex, A_UINT8 *bssid);
+int wmi_deleteBadAp_cmd(struct wmi_t *wmip, A_UINT8 apIndex);
+int wmi_set_tkip_countermeasures_cmd(struct wmi_t *wmip, A_BOOL en);
+int wmi_setPmkid_cmd(struct wmi_t *wmip, A_UINT8 *bssid, A_UINT8 *pmkId,
                           A_BOOL set);
-A_STATUS wmi_set_access_params_cmd(struct wmi_t *wmip, A_UINT8 ac, A_UINT16 txop,
+int wmi_set_access_params_cmd(struct wmi_t *wmip, A_UINT8 ac, A_UINT16 txop,
                                    A_UINT8 eCWmin, A_UINT8 eCWmax,
                                    A_UINT8 aifsn);
-A_STATUS wmi_set_retry_limits_cmd(struct wmi_t *wmip, A_UINT8 frameType,
+int wmi_set_retry_limits_cmd(struct wmi_t *wmip, A_UINT8 frameType,
                                   A_UINT8 trafficClass, A_UINT8 maxRetries,
                                   A_UINT8 enableNotify);
 
 void wmi_get_current_bssid(struct wmi_t *wmip, A_UINT8 *bssid);
 
-A_STATUS wmi_get_roam_tbl_cmd(struct wmi_t *wmip);
-A_STATUS wmi_get_roam_data_cmd(struct wmi_t *wmip, A_UINT8 roamDataType);
-A_STATUS wmi_set_roam_ctrl_cmd(struct wmi_t *wmip, WMI_SET_ROAM_CTRL_CMD *p,
+int wmi_get_roam_tbl_cmd(struct wmi_t *wmip);
+int wmi_get_roam_data_cmd(struct wmi_t *wmip, A_UINT8 roamDataType);
+int wmi_set_roam_ctrl_cmd(struct wmi_t *wmip, WMI_SET_ROAM_CTRL_CMD *p,
                                A_UINT8 size);
-A_STATUS wmi_set_powersave_timers_cmd(struct wmi_t *wmip,
+int wmi_set_powersave_timers_cmd(struct wmi_t *wmip,
                             WMI_POWERSAVE_TIMERS_POLICY_CMD *pCmd,
                             A_UINT8 size);
 
-A_STATUS wmi_set_opt_mode_cmd(struct wmi_t *wmip, A_UINT8 optMode);
-A_STATUS wmi_opt_tx_frame_cmd(struct wmi_t *wmip,
+int wmi_set_opt_mode_cmd(struct wmi_t *wmip, A_UINT8 optMode);
+int wmi_opt_tx_frame_cmd(struct wmi_t *wmip,
                               A_UINT8 frmType,
                               A_UINT8 *dstMacAddr,
                               A_UINT8 *bssid,
                               A_UINT16 optIEDataLen,
                               A_UINT8 *optIEData);
 
-A_STATUS wmi_set_adhoc_bconIntvl_cmd(struct wmi_t *wmip, A_UINT16 intvl);
-A_STATUS wmi_set_voice_pkt_size_cmd(struct wmi_t *wmip, A_UINT16 voicePktSize);
-A_STATUS wmi_set_max_sp_len_cmd(struct wmi_t *wmip, A_UINT8 maxSpLen);
+int wmi_set_adhoc_bconIntvl_cmd(struct wmi_t *wmip, A_UINT16 intvl);
+int wmi_set_voice_pkt_size_cmd(struct wmi_t *wmip, A_UINT16 voicePktSize);
+int wmi_set_max_sp_len_cmd(struct wmi_t *wmip, A_UINT8 maxSpLen);
 A_UINT8  convert_userPriority_to_trafficClass(A_UINT8 userPriority);
 A_UINT8 wmi_get_power_mode_cmd(struct wmi_t *wmip);
-A_STATUS wmi_verify_tspec_params(WMI_CREATE_PSTREAM_CMD *pCmd, A_BOOL tspecCompliance);
+int wmi_verify_tspec_params(WMI_CREATE_PSTREAM_CMD *pCmd, A_BOOL tspecCompliance);
 
 #ifdef CONFIG_HOST_TCMD_SUPPORT
-A_STATUS wmi_test_cmd(struct wmi_t *wmip, A_UINT8 *buf, A_UINT32  len);
+int wmi_test_cmd(struct wmi_t *wmip, A_UINT8 *buf, A_UINT32  len);
 #endif
 
-A_STATUS wmi_set_bt_status_cmd(struct wmi_t *wmip, A_UINT8 streamType, A_UINT8 status);
-A_STATUS wmi_set_bt_params_cmd(struct wmi_t *wmip, WMI_SET_BT_PARAMS_CMD* cmd);
+int wmi_set_bt_status_cmd(struct wmi_t *wmip, A_UINT8 streamType, A_UINT8 status);
+int wmi_set_bt_params_cmd(struct wmi_t *wmip, WMI_SET_BT_PARAMS_CMD* cmd);
 
-A_STATUS wmi_set_btcoex_fe_ant_cmd(struct wmi_t *wmip, WMI_SET_BTCOEX_FE_ANT_CMD * cmd);
+int wmi_set_btcoex_fe_ant_cmd(struct wmi_t *wmip, WMI_SET_BTCOEX_FE_ANT_CMD * cmd);
 
-A_STATUS wmi_set_btcoex_colocated_bt_dev_cmd(struct wmi_t *wmip,
+int wmi_set_btcoex_colocated_bt_dev_cmd(struct wmi_t *wmip,
 		                                WMI_SET_BTCOEX_COLOCATED_BT_DEV_CMD * cmd);
 
-A_STATUS wmi_set_btcoex_btinquiry_page_config_cmd(struct wmi_t *wmip,
+int wmi_set_btcoex_btinquiry_page_config_cmd(struct wmi_t *wmip,
                                			WMI_SET_BTCOEX_BTINQUIRY_PAGE_CONFIG_CMD *cmd);
 
-A_STATUS wmi_set_btcoex_sco_config_cmd(struct wmi_t *wmip,
+int wmi_set_btcoex_sco_config_cmd(struct wmi_t *wmip,
                    		              WMI_SET_BTCOEX_SCO_CONFIG_CMD * cmd);
 
-A_STATUS wmi_set_btcoex_a2dp_config_cmd(struct wmi_t *wmip,
+int wmi_set_btcoex_a2dp_config_cmd(struct wmi_t *wmip,
 		                                 WMI_SET_BTCOEX_A2DP_CONFIG_CMD* cmd);
 
 
-A_STATUS wmi_set_btcoex_aclcoex_config_cmd(struct wmi_t *wmip, WMI_SET_BTCOEX_ACLCOEX_CONFIG_CMD* cmd);
+int wmi_set_btcoex_aclcoex_config_cmd(struct wmi_t *wmip, WMI_SET_BTCOEX_ACLCOEX_CONFIG_CMD* cmd);
 
-A_STATUS wmi_set_btcoex_debug_cmd(struct wmi_t *wmip, WMI_SET_BTCOEX_DEBUG_CMD * cmd);
+int wmi_set_btcoex_debug_cmd(struct wmi_t *wmip, WMI_SET_BTCOEX_DEBUG_CMD * cmd);
 
-A_STATUS wmi_set_btcoex_bt_operating_status_cmd(struct wmi_t * wmip,
+int wmi_set_btcoex_bt_operating_status_cmd(struct wmi_t * wmip,
 							WMI_SET_BTCOEX_BT_OPERATING_STATUS_CMD * cmd);
 
-A_STATUS wmi_get_btcoex_config_cmd(struct wmi_t * wmip, WMI_GET_BTCOEX_CONFIG_CMD * cmd);
+int wmi_get_btcoex_config_cmd(struct wmi_t * wmip, WMI_GET_BTCOEX_CONFIG_CMD * cmd);
 
-A_STATUS wmi_get_btcoex_stats_cmd(struct wmi_t * wmip);
+int wmi_get_btcoex_stats_cmd(struct wmi_t * wmip);
 
-A_STATUS wmi_SGI_cmd(struct wmi_t *wmip, A_UINT32 sgiMask, A_UINT8 sgiPERThreshold);
+int wmi_SGI_cmd(struct wmi_t *wmip, A_UINT32 sgiMask, A_UINT8 sgiPERThreshold);
 
 /*
  *  This function is used to configure the fix rates mask to the target.
  */
-A_STATUS wmi_set_fixrates_cmd(struct wmi_t *wmip, A_UINT32 fixRatesMask);
-A_STATUS wmi_get_ratemask_cmd(struct wmi_t *wmip);
+int wmi_set_fixrates_cmd(struct wmi_t *wmip, A_UINT32 fixRatesMask);
+int wmi_get_ratemask_cmd(struct wmi_t *wmip);
 
-A_STATUS wmi_set_authmode_cmd(struct wmi_t *wmip, A_UINT8 mode);
+int wmi_set_authmode_cmd(struct wmi_t *wmip, A_UINT8 mode);
 
-A_STATUS wmi_set_reassocmode_cmd(struct wmi_t *wmip, A_UINT8 mode);
+int wmi_set_reassocmode_cmd(struct wmi_t *wmip, A_UINT8 mode);
 
-A_STATUS wmi_set_qos_supp_cmd(struct wmi_t *wmip,A_UINT8 status);
-A_STATUS wmi_set_wmm_cmd(struct wmi_t *wmip, WMI_WMM_STATUS status);
-A_STATUS wmi_set_wmm_txop(struct wmi_t *wmip, WMI_TXOP_CFG txEnable);
-A_STATUS wmi_set_country(struct wmi_t *wmip, A_UCHAR *countryCode);
+int wmi_set_qos_supp_cmd(struct wmi_t *wmip,A_UINT8 status);
+int wmi_set_wmm_cmd(struct wmi_t *wmip, WMI_WMM_STATUS status);
+int wmi_set_wmm_txop(struct wmi_t *wmip, WMI_TXOP_CFG txEnable);
+int wmi_set_country(struct wmi_t *wmip, A_UCHAR *countryCode);
 
-A_STATUS wmi_get_keepalive_configured(struct wmi_t *wmip);
+int wmi_get_keepalive_configured(struct wmi_t *wmip);
 A_UINT8 wmi_get_keepalive_cmd(struct wmi_t *wmip);
-A_STATUS wmi_set_keepalive_cmd(struct wmi_t *wmip, A_UINT8 keepaliveInterval);
+int wmi_set_keepalive_cmd(struct wmi_t *wmip, A_UINT8 keepaliveInterval);
 
-A_STATUS wmi_set_appie_cmd(struct wmi_t *wmip, A_UINT8 mgmtFrmType,
+int wmi_set_appie_cmd(struct wmi_t *wmip, A_UINT8 mgmtFrmType,
                            A_UINT8 ieLen,A_UINT8 *ieInfo);
 
-A_STATUS wmi_set_halparam_cmd(struct wmi_t *wmip, A_UINT8 *cmd, A_UINT16 dataLen);
+int wmi_set_halparam_cmd(struct wmi_t *wmip, A_UINT8 *cmd, A_UINT16 dataLen);
 
 A_INT32 wmi_get_rate(A_INT8 rateindex);
 
-A_STATUS wmi_set_ip_cmd(struct wmi_t *wmip, WMI_SET_IP_CMD *cmd);
+int wmi_set_ip_cmd(struct wmi_t *wmip, WMI_SET_IP_CMD *cmd);
 
 /*Wake on Wireless WMI commands*/
-A_STATUS wmi_set_host_sleep_mode_cmd(struct wmi_t *wmip, WMI_SET_HOST_SLEEP_MODE_CMD *cmd);
-A_STATUS wmi_set_wow_mode_cmd(struct wmi_t *wmip, WMI_SET_WOW_MODE_CMD *cmd);
-A_STATUS wmi_get_wow_list_cmd(struct wmi_t *wmip, WMI_GET_WOW_LIST_CMD *cmd);
-A_STATUS wmi_add_wow_pattern_cmd(struct wmi_t *wmip,
+int wmi_set_host_sleep_mode_cmd(struct wmi_t *wmip, WMI_SET_HOST_SLEEP_MODE_CMD *cmd);
+int wmi_set_wow_mode_cmd(struct wmi_t *wmip, WMI_SET_WOW_MODE_CMD *cmd);
+int wmi_get_wow_list_cmd(struct wmi_t *wmip, WMI_GET_WOW_LIST_CMD *cmd);
+int wmi_add_wow_pattern_cmd(struct wmi_t *wmip,
                                  WMI_ADD_WOW_PATTERN_CMD *cmd, A_UINT8* pattern, A_UINT8* mask, A_UINT8 pattern_size);
-A_STATUS wmi_del_wow_pattern_cmd(struct wmi_t *wmip,
+int wmi_del_wow_pattern_cmd(struct wmi_t *wmip,
                                  WMI_DEL_WOW_PATTERN_CMD *cmd);
-A_STATUS wmi_set_wsc_status_cmd(struct wmi_t *wmip, A_UINT32 status);
+int wmi_set_wsc_status_cmd(struct wmi_t *wmip, A_UINT32 status);
 
-A_STATUS
+int
 wmi_set_params_cmd(struct wmi_t *wmip, A_UINT32 opcode, A_UINT32 length, A_CHAR* buffer);
 
-A_STATUS
+int
 wmi_set_mcast_filter_cmd(struct wmi_t *wmip, A_UINT8 dot1, A_UINT8 dot2, A_UINT8 dot3, A_UINT8 dot4);
 
-A_STATUS
+int
 wmi_del_mcast_filter_cmd(struct wmi_t *wmip, A_UINT8 dot1, A_UINT8 dot2, A_UINT8 dot3, A_UINT8 dot4);
 
-A_STATUS
+int
 wmi_mcast_filter_cmd(struct wmi_t *wmip, A_UINT8 enable);
 
 bss_t *
@@ -333,93 +333,93 @@ void
 wmi_set_nodeage(struct wmi_t *wmip, A_UINT32 nodeAge);
 
 #if defined(CONFIG_TARGET_PROFILE_SUPPORT)
-A_STATUS wmi_prof_cfg_cmd(struct wmi_t *wmip, A_UINT32 period, A_UINT32 nbins);
-A_STATUS wmi_prof_addr_set_cmd(struct wmi_t *wmip, A_UINT32 addr);
-A_STATUS wmi_prof_start_cmd(struct wmi_t *wmip);
-A_STATUS wmi_prof_stop_cmd(struct wmi_t *wmip);
-A_STATUS wmi_prof_count_get_cmd(struct wmi_t *wmip);
+int wmi_prof_cfg_cmd(struct wmi_t *wmip, A_UINT32 period, A_UINT32 nbins);
+int wmi_prof_addr_set_cmd(struct wmi_t *wmip, A_UINT32 addr);
+int wmi_prof_start_cmd(struct wmi_t *wmip);
+int wmi_prof_stop_cmd(struct wmi_t *wmip);
+int wmi_prof_count_get_cmd(struct wmi_t *wmip);
 #endif /* CONFIG_TARGET_PROFILE_SUPPORT */
 #ifdef OS_ROAM_MANAGEMENT
 void wmi_scan_indication (struct wmi_t *wmip);
 #endif
 
-A_STATUS
+int
 wmi_set_target_event_report_cmd(struct wmi_t *wmip, WMI_SET_TARGET_EVENT_REPORT_CMD* cmd);
 
 bss_t   *wmi_rm_current_bss (struct wmi_t *wmip, A_UINT8 *id);
-A_STATUS wmi_add_current_bss (struct wmi_t *wmip, A_UINT8 *id, bss_t *bss);
+int wmi_add_current_bss (struct wmi_t *wmip, A_UINT8 *id, bss_t *bss);
 
 
 /*
  * AP mode
  */
-A_STATUS
+int
 wmi_ap_profile_commit(struct wmi_t *wmip, WMI_CONNECT_CMD *p);
 
-A_STATUS
+int
 wmi_ap_set_hidden_ssid(struct wmi_t *wmip, A_UINT8 hidden_ssid);
 
-A_STATUS
+int
 wmi_ap_set_num_sta(struct wmi_t *wmip, A_UINT8 num_sta);
 
-A_STATUS
+int
 wmi_ap_set_acl_policy(struct wmi_t *wmip, A_UINT8 policy);
 
-A_STATUS
+int
 wmi_ap_acl_mac_list(struct wmi_t *wmip, WMI_AP_ACL_MAC_CMD *a);
 
 A_UINT8
 acl_add_del_mac(WMI_AP_ACL *a, WMI_AP_ACL_MAC_CMD *acl);
 
-A_STATUS
+int
 wmi_ap_set_mlme(struct wmi_t *wmip, A_UINT8 cmd, A_UINT8 *mac, A_UINT16 reason);
 
-A_STATUS
+int
 wmi_set_pvb_cmd(struct wmi_t *wmip, A_UINT16 aid, A_BOOL flag);
 
-A_STATUS
+int
 wmi_ap_conn_inact_time(struct wmi_t *wmip, A_UINT32 period);
 
-A_STATUS
+int
 wmi_ap_bgscan_time(struct wmi_t *wmip, A_UINT32 period, A_UINT32 dwell);
 
-A_STATUS
+int
 wmi_ap_set_dtim(struct wmi_t *wmip, A_UINT8 dtim);
 
-A_STATUS
+int
 wmi_ap_set_rateset(struct wmi_t *wmip, A_UINT8 rateset);
 
-A_STATUS
+int
 wmi_set_ht_cap_cmd(struct wmi_t *wmip, WMI_SET_HT_CAP_CMD *cmd);
 
-A_STATUS
+int
 wmi_set_ht_op_cmd(struct wmi_t *wmip, A_UINT8 sta_chan_width);
 
-A_STATUS
+int
 wmi_send_hci_cmd(struct wmi_t *wmip, A_UINT8 *buf, A_UINT16 sz);
 
-A_STATUS
+int
 wmi_set_tx_select_rates_cmd(struct wmi_t *wmip, A_UINT32 *pMaskArray);
 
-A_STATUS
+int
 wmi_setup_aggr_cmd(struct wmi_t *wmip, A_UINT8 tid);
 
-A_STATUS
+int
 wmi_delete_aggr_cmd(struct wmi_t *wmip, A_UINT8 tid, A_BOOL uplink);
 
-A_STATUS
+int
 wmi_allow_aggr_cmd(struct wmi_t *wmip, A_UINT16 tx_tidmask, A_UINT16 rx_tidmask);
 
-A_STATUS 
+int
 wmi_set_rx_frame_format_cmd(struct wmi_t *wmip, A_UINT8 rxMetaVersion, A_BOOL rxDot11Hdr, A_BOOL defragOnHost);
 
-A_STATUS 
+int
 wmi_set_thin_mode_cmd(struct wmi_t *wmip, A_BOOL bThinMode);
 
-A_STATUS
+int
 wmi_set_wlan_conn_precedence_cmd(struct wmi_t *wmip, BT_WLAN_CONN_PRECEDENCE precedence);
 
-A_STATUS
+int
 wmi_set_pmk_cmd(struct wmi_t *wmip, A_UINT8 *pmk);
 
 A_UINT16
diff --git a/drivers/staging/ath6kl/miscdrv/ar3kconfig.c b/drivers/staging/ath6kl/miscdrv/ar3kconfig.c
index 83bc5be..687f963 100644
--- a/drivers/staging/ath6kl/miscdrv/ar3kconfig.c
+++ b/drivers/staging/ath6kl/miscdrv/ar3kconfig.c
@@ -47,14 +47,14 @@
 #define HCI_MAX_EVT_RECV_LENGTH             257
 #define EXIT_MIN_BOOT_COMMAND_STATUS_OFFSET  5
 
-A_STATUS AthPSInitialize(AR3K_CONFIG_INFO *hdev);
+int AthPSInitialize(AR3K_CONFIG_INFO *hdev);
 
-static A_STATUS SendHCICommand(AR3K_CONFIG_INFO *pConfig,
+static int SendHCICommand(AR3K_CONFIG_INFO *pConfig,
                                A_UINT8          *pBuffer,
                                int              Length)
 {
     HTC_PACKET  *pPacket = NULL;
-    A_STATUS    status = A_OK;
+    int    status = A_OK;
        
     do {   
         
@@ -84,11 +84,11 @@ static A_STATUS SendHCICommand(AR3K_CONFIG_INFO *pConfig,
     return status;
 }
 
-static A_STATUS RecvHCIEvent(AR3K_CONFIG_INFO *pConfig,
+static int RecvHCIEvent(AR3K_CONFIG_INFO *pConfig,
                              A_UINT8          *pBuffer,
                              int              *pLength)
 {
-    A_STATUS    status = A_OK; 
+    int    status = A_OK;
     HTC_PACKET  *pRecvPacket = NULL;
     
     do {
@@ -122,13 +122,13 @@ static A_STATUS RecvHCIEvent(AR3K_CONFIG_INFO *pConfig,
     return status;
 } 
     
-A_STATUS SendHCICommandWaitCommandComplete(AR3K_CONFIG_INFO *pConfig,
+int SendHCICommandWaitCommandComplete(AR3K_CONFIG_INFO *pConfig,
                                            A_UINT8          *pHCICommand,
                                            int              CmdLength,
                                            A_UINT8          **ppEventBuffer,
                                            A_UINT8          **ppBufferToFree)
 {
-    A_STATUS    status = A_OK;   
+    int    status = A_OK;
     A_UINT8     *pBuffer = NULL;
     A_UINT8     *pTemp;
     int         length;
@@ -209,9 +209,9 @@ A_STATUS SendHCICommandWaitCommandComplete(AR3K_CONFIG_INFO *pConfig,
     return status;    
 }
 
-static A_STATUS AR3KConfigureHCIBaud(AR3K_CONFIG_INFO *pConfig)
+static int AR3KConfigureHCIBaud(AR3K_CONFIG_INFO *pConfig)
 {
-    A_STATUS    status = A_OK;
+    int    status = A_OK;
     A_UINT8     hciBaudChangeCommand[] =  {0x0c,0xfc,0x2,0,0};
     A_UINT16    baudVal; 
     A_UINT8     *pEvent = NULL;
@@ -274,9 +274,9 @@ static A_STATUS AR3KConfigureHCIBaud(AR3K_CONFIG_INFO *pConfig)
     return status;
 }
 
-static A_STATUS AR3KExitMinBoot(AR3K_CONFIG_INFO *pConfig)
+static int AR3KExitMinBoot(AR3K_CONFIG_INFO *pConfig)
 {
-    A_STATUS  status;
+    int  status;
     A_CHAR    exitMinBootCmd[] = {0x25,0xFC,0x0c,0x03,0x00,0x00,0x00,0x00,0x00,0x00,
                                   0x00,0x00,0x00,0x00,0x00};
     A_UINT8   *pEvent = NULL;
@@ -310,9 +310,9 @@ static A_STATUS AR3KExitMinBoot(AR3K_CONFIG_INFO *pConfig)
     return status;                                              
 }
                                  
-static A_STATUS AR3KConfigureSendHCIReset(AR3K_CONFIG_INFO *pConfig)
+static int AR3KConfigureSendHCIReset(AR3K_CONFIG_INFO *pConfig)
 {
-    A_STATUS status = A_OK;
+    int status = A_OK;
     A_UINT8 hciResetCommand[] = {0x03,0x0c,0x0};
     A_UINT8 *pEvent = NULL;
     A_UINT8 *pBufferToFree = NULL;
@@ -334,9 +334,9 @@ static A_STATUS AR3KConfigureSendHCIReset(AR3K_CONFIG_INFO *pConfig)
     return status;
 }
 
-static A_STATUS AR3KEnableTLPM(AR3K_CONFIG_INFO *pConfig)
+static int AR3KEnableTLPM(AR3K_CONFIG_INFO *pConfig)
 {
-    A_STATUS  status;
+    int  status;
     /* AR3K vendor specific command for Host Wakeup Config */
     A_CHAR    hostWakeupConfig[] = {0x31,0xFC,0x18,
                                     0x02,0x00,0x00,0x00,
@@ -453,9 +453,9 @@ static A_STATUS AR3KEnableTLPM(AR3K_CONFIG_INFO *pConfig)
     return status;                                              
 }
 
-A_STATUS AR3KConfigure(AR3K_CONFIG_INFO *pConfig)
+int AR3KConfigure(AR3K_CONFIG_INFO *pConfig)
 {
-    A_STATUS        status = A_OK; 
+    int        status = A_OK;
         
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("AR3K Config: Configuring AR3K ...\n"));
                                 
@@ -521,9 +521,9 @@ A_STATUS AR3KConfigure(AR3K_CONFIG_INFO *pConfig)
     return status;
 }
 
-A_STATUS AR3KConfigureExit(void *config)
+int AR3KConfigureExit(void *config)
 {
-    A_STATUS        status = A_OK; 
+    int        status = A_OK;
     AR3K_CONFIG_INFO *pConfig = (AR3K_CONFIG_INFO *)config;
         
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("AR3K Config: Cleaning up AR3K ...\n"));
diff --git a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c
index 0e298db..50f2edd 100644
--- a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c
+++ b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c
@@ -46,7 +46,7 @@ typedef struct {
     AR3K_CONFIG_INFO *dev;
 }HciCommandListParam;
 
-A_STATUS SendHCICommandWaitCommandComplete(AR3K_CONFIG_INFO *pConfig,
+int SendHCICommandWaitCommandComplete(AR3K_CONFIG_INFO *pConfig,
                                            A_UINT8          *pHCICommand,
                                            int              CmdLength,
                                            A_UINT8          **ppEventBuffer,
@@ -56,8 +56,8 @@ A_UINT32  Rom_Version;
 A_UINT32  Build_Version;
 extern A_BOOL BDADDR;
 
-A_STATUS getDeviceType(AR3K_CONFIG_INFO *pConfig, A_UINT32 * code);
-A_STATUS ReadVersionInfo(AR3K_CONFIG_INFO *pConfig);
+int getDeviceType(AR3K_CONFIG_INFO *pConfig, A_UINT32 * code);
+int ReadVersionInfo(AR3K_CONFIG_INFO *pConfig);
 #ifndef HCI_TRANSPORT_SDIO
 
 DECLARE_WAIT_QUEUE_HEAD(PsCompleteEvent);
@@ -70,7 +70,7 @@ int PSHciWritepacket(struct hci_dev*,A_UCHAR* Data, A_UINT32 len);
 extern char *bdaddr;
 #endif /* HCI_TRANSPORT_SDIO */
 
-A_STATUS write_bdaddr(AR3K_CONFIG_INFO *pConfig,A_UCHAR *bdaddr,int type);
+int write_bdaddr(AR3K_CONFIG_INFO *pConfig,A_UCHAR *bdaddr,int type);
 
 int PSSendOps(void *arg);
 
@@ -91,9 +91,9 @@ void Hci_log(A_UCHAR * log_string,A_UCHAR *data,A_UINT32 len)
 
 
 
-A_STATUS AthPSInitialize(AR3K_CONFIG_INFO *hdev)
+int AthPSInitialize(AR3K_CONFIG_INFO *hdev)
 {
-    A_STATUS status = A_OK;
+    int status = A_OK;
     if(hdev == NULL) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Invalid Device handle received\n"));
         return A_ERROR;
@@ -389,7 +389,7 @@ complete:
  *  with a HCI Command Complete event.
  *  For HCI SDIO transport, this will be internally defined. 
  */
-A_STATUS SendHCICommandWaitCommandComplete(AR3K_CONFIG_INFO *pConfig,
+int SendHCICommandWaitCommandComplete(AR3K_CONFIG_INFO *pConfig,
                                            A_UINT8          *pHCICommand,
                                            int              CmdLength,
                                            A_UINT8          **ppEventBuffer,
@@ -419,7 +419,7 @@ A_STATUS SendHCICommandWaitCommandComplete(AR3K_CONFIG_INFO *pConfig,
 }
 #endif /* HCI_TRANSPORT_SDIO */
 
-A_STATUS ReadPSEvent(A_UCHAR* Data){
+int ReadPSEvent(A_UCHAR* Data){
     AR_DEBUG_PRINTF(ATH_DEBUG_ERR,(" PS Event %x %x %x\n",Data[4],Data[5],Data[3]));
                                 
     if(Data[4] == 0xFC && Data[5] == 0x00)
@@ -481,14 +481,14 @@ int str2ba(unsigned char *str_bdaddr,unsigned char *bdaddr)
 	return 0; 
 }
 
-A_STATUS write_bdaddr(AR3K_CONFIG_INFO *pConfig,A_UCHAR *bdaddr,int type)
+int write_bdaddr(AR3K_CONFIG_INFO *pConfig,A_UCHAR *bdaddr,int type)
 {
 	A_UCHAR bdaddr_cmd[] = { 0x0B, 0xFC, 0x0A, 0x01, 0x01, 
 							0x00, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
 
     A_UINT8 *event;
     A_UINT8 *bufferToFree = NULL;
-    A_STATUS result = A_ERROR;
+    int result = A_ERROR;
 	int inc,outc;
 
 	if (type == BDADDR_TYPE_STRING)
@@ -516,12 +516,12 @@ A_STATUS write_bdaddr(AR3K_CONFIG_INFO *pConfig,A_UCHAR *bdaddr,int type)
     return result;
 
 }
-A_STATUS ReadVersionInfo(AR3K_CONFIG_INFO *pConfig)
+int ReadVersionInfo(AR3K_CONFIG_INFO *pConfig)
 {
     A_UINT8   hciCommand[] =  {0x1E,0xfc,0x00};
     A_UINT8 *event;
     A_UINT8 *bufferToFree = NULL;
-    A_STATUS result = A_ERROR;
+    int result = A_ERROR;
     if(A_OK == SendHCICommandWaitCommandComplete(pConfig,hciCommand,sizeof(hciCommand),&event,&bufferToFree)) {
 	result = ReadPSEvent(event);
 
@@ -531,13 +531,13 @@ A_STATUS ReadVersionInfo(AR3K_CONFIG_INFO *pConfig)
    }
     return result;
 }
-A_STATUS getDeviceType(AR3K_CONFIG_INFO *pConfig, A_UINT32 * code)
+int getDeviceType(AR3K_CONFIG_INFO *pConfig, A_UINT32 * code)
 {
     A_UINT8   hciCommand[] =  {0x05,0xfc,0x05,0x00,0x00,0x00,0x00,0x04};
     A_UINT8 *event;
     A_UINT8 *bufferToFree = NULL;
     A_UINT32 reg;
-    A_STATUS result = A_ERROR;
+    int result = A_ERROR;
     *code = 0;
     hciCommand[3] = (A_UINT8)(FPGA_REGISTER & 0xFF);
     hciCommand[4] = (A_UINT8)((FPGA_REGISTER >> 8) & 0xFF);
diff --git a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h
index 4e5b7bf..975bf62 100644
--- a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h
+++ b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h
@@ -70,6 +70,6 @@ extern wait_queue_t Eventwait;
 extern A_UCHAR *HciEventpacket;
 #endif /* #ifndef HCI_TRANSPORT_SDIO */
 
-A_STATUS AthPSInitialize(AR3K_CONFIG_INFO *hdev);
-A_STATUS ReadPSEvent(A_UCHAR* Data);
+int AthPSInitialize(AR3K_CONFIG_INFO *hdev);
+int ReadPSEvent(A_UCHAR* Data);
 #endif /* __AR3KPSCONFIG_H */
diff --git a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
index 8dce054..3b2c0cc 100644
--- a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
+++ b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
@@ -127,10 +127,10 @@ tPsTagEntry PsTagEntry[RAMPS_MAX_PS_TAGS_PER_FILE];
 tRamPatch   RamPatch[MAX_NUM_PATCH_ENTRY];
 
 
-A_STATUS AthParseFilesUnified(A_UCHAR *srcbuffer,A_UINT32 srclen, int FileFormat);
+int AthParseFilesUnified(A_UCHAR *srcbuffer,A_UINT32 srclen, int FileFormat);
 char AthReadChar(A_UCHAR *buffer, A_UINT32 len,A_UINT32 *pos);
 char * AthGetLine(char * buffer, int maxlen, A_UCHAR *srcbuffer,A_UINT32 len,A_UINT32 *pos);
-static A_STATUS AthPSCreateHCICommand(A_UCHAR Opcode, A_UINT32 Param1,PSCmdPacket *PSPatchPacket,A_UINT32 *index);
+static int AthPSCreateHCICommand(A_UCHAR Opcode, A_UINT32 Param1,PSCmdPacket *PSPatchPacket,A_UINT32 *index);
 
 /* Function to reads the next character from the input buffer */
 char AthReadChar(A_UCHAR *buffer, A_UINT32 len,A_UINT32 *pos) 
@@ -315,7 +315,7 @@ unsigned int uReadDataInSection(char *pCharLine, ST_PS_DATA_FORMAT stPS_DataForm
         return (0x0FFF);
     }
 }
-A_STATUS AthParseFilesUnified(A_UCHAR *srcbuffer,A_UINT32 srclen, int FileFormat)
+int AthParseFilesUnified(A_UCHAR *srcbuffer,A_UINT32 srclen, int FileFormat)
 {
    char     *Buffer;
    char     *pCharLine;
@@ -558,7 +558,7 @@ A_STATUS AthParseFilesUnified(A_UCHAR *srcbuffer,A_UINT32 srclen, int FileFormat
 /********************/
 
 
-A_STATUS GetNextTwoChar(A_UCHAR *srcbuffer,A_UINT32 len, A_UINT32 *pos, char * buffer)
+int GetNextTwoChar(A_UCHAR *srcbuffer,A_UINT32 len, A_UINT32 *pos, char * buffer)
 {
     unsigned char ch;
 
@@ -579,7 +579,7 @@ A_STATUS GetNextTwoChar(A_UCHAR *srcbuffer,A_UINT32 len, A_UINT32 *pos, char * b
     return A_OK;
 }
 
-A_STATUS AthDoParsePatch(A_UCHAR *patchbuffer, A_UINT32 patchlen)
+int AthDoParsePatch(A_UCHAR *patchbuffer, A_UINT32 patchlen)
 {
 
     char  Byte[3];
@@ -659,9 +659,9 @@ A_STATUS AthDoParsePatch(A_UCHAR *patchbuffer, A_UINT32 patchlen)
 
 
 /********************/
-A_STATUS AthDoParsePS(A_UCHAR *srcbuffer, A_UINT32 srclen)
+int AthDoParsePS(A_UCHAR *srcbuffer, A_UINT32 srclen)
 {
-    A_STATUS status;
+    int status;
     int i;
     A_BOOL BDADDR_Present = A_ERROR;
 
@@ -833,7 +833,7 @@ int AthCreateCommandList(PSCmdPacket **HciPacketList, A_UINT32 *numPackets)
 ////////////////////////
 
 /////////////
-static A_STATUS AthPSCreateHCICommand(A_UCHAR Opcode, A_UINT32 Param1,PSCmdPacket *PSPatchPacket,A_UINT32 *index)
+static int AthPSCreateHCICommand(A_UCHAR Opcode, A_UINT32 Param1,PSCmdPacket *PSPatchPacket,A_UINT32 *index)
 {
     A_UCHAR *HCI_PS_Command;
     A_UINT32 Length;
@@ -955,7 +955,7 @@ static A_STATUS AthPSCreateHCICommand(A_UCHAR Opcode, A_UINT32 Param1,PSCmdPacke
     }
     return A_OK;
 }
-A_STATUS AthFreeCommandList(PSCmdPacket **HciPacketList, A_UINT32 numPackets)
+int AthFreeCommandList(PSCmdPacket **HciPacketList, A_UINT32 numPackets)
 {
     int i;
     if(*HciPacketList == NULL) {
diff --git a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h
index 007b0eb..96c3e3f 100644
--- a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h
+++ b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h
@@ -104,10 +104,10 @@ typedef struct PSCmdPacket
 } PSCmdPacket;
 
 /* Parses a Patch information buffer and store it in global structure */
-A_STATUS AthDoParsePatch(A_UCHAR *, A_UINT32);
+int AthDoParsePatch(A_UCHAR *, A_UINT32);
 
 /* parses a PS information buffer and stores it in a global structure */
-A_STATUS AthDoParsePS(A_UCHAR *, A_UINT32);
+int AthDoParsePS(A_UCHAR *, A_UINT32);
 
 /* 
  *  Uses the output of Both AthDoParsePS and AthDoParsePatch APIs to form HCI command array with
@@ -123,5 +123,5 @@ A_STATUS AthDoParsePS(A_UCHAR *, A_UINT32);
 int AthCreateCommandList(PSCmdPacket **, A_UINT32 *);
 
 /* Cleanup the dynamically allicated HCI command list */
-A_STATUS AthFreeCommandList(PSCmdPacket **HciPacketList, A_UINT32 numPackets);
+int AthFreeCommandList(PSCmdPacket **HciPacketList, A_UINT32 numPackets);
 #endif /* __AR3KPSPARSER_H */
diff --git a/drivers/staging/ath6kl/miscdrv/common_drv.c b/drivers/staging/ath6kl/miscdrv/common_drv.c
index 6754fde..2b5fe5b 100644
--- a/drivers/staging/ath6kl/miscdrv/common_drv.c
+++ b/drivers/staging/ath6kl/miscdrv/common_drv.c
@@ -83,9 +83,9 @@ static A_UINT8 custDataAR6003[AR6003_CUST_DATA_SIZE];
 #ifdef USE_4BYTE_REGISTER_ACCESS
 
     /* set the window address register (using 4-byte register access ). */
-A_STATUS ar6000_SetAddressWindowRegister(HIF_DEVICE *hifDevice, A_UINT32 RegisterAddr, A_UINT32 Address)
+int ar6000_SetAddressWindowRegister(HIF_DEVICE *hifDevice, A_UINT32 RegisterAddr, A_UINT32 Address)
 {
-    A_STATUS status;
+    int status;
     A_UINT8 addrValue[4];
     A_INT32 i;
 
@@ -144,9 +144,9 @@ A_STATUS ar6000_SetAddressWindowRegister(HIF_DEVICE *hifDevice, A_UINT32 Registe
 #else
 
     /* set the window address register */
-A_STATUS ar6000_SetAddressWindowRegister(HIF_DEVICE *hifDevice, A_UINT32 RegisterAddr, A_UINT32 Address)
+int ar6000_SetAddressWindowRegister(HIF_DEVICE *hifDevice, A_UINT32 RegisterAddr, A_UINT32 Address)
 {
-    A_STATUS status;
+    int status;
 
         /* write bytes 1,2,3 of the register to set the upper address bytes, the LSB is written
          * last to initiate the access cycle */
@@ -186,10 +186,10 @@ A_STATUS ar6000_SetAddressWindowRegister(HIF_DEVICE *hifDevice, A_UINT32 Registe
  * Read from the AR6000 through its diagnostic window.
  * No cooperation from the Target is required for this.
  */
-A_STATUS
+int
 ar6000_ReadRegDiag(HIF_DEVICE *hifDevice, A_UINT32 *address, A_UINT32 *data)
 {
-    A_STATUS status;
+    int status;
 
         /* set window register to start read cycle */
     status = ar6000_SetAddressWindowRegister(hifDevice,
@@ -220,10 +220,10 @@ ar6000_ReadRegDiag(HIF_DEVICE *hifDevice, A_UINT32 *address, A_UINT32 *data)
  * Write to the AR6000 through its diagnostic window.
  * No cooperation from the Target is required for this.
  */
-A_STATUS
+int
 ar6000_WriteRegDiag(HIF_DEVICE *hifDevice, A_UINT32 *address, A_UINT32 *data)
 {
-    A_STATUS status;
+    int status;
 
         /* set write data */
     status = HIFReadWrite(hifDevice,
@@ -243,12 +243,12 @@ ar6000_WriteRegDiag(HIF_DEVICE *hifDevice, A_UINT32 *address, A_UINT32 *data)
                                            *address);
     }
 
-A_STATUS
+int
 ar6000_ReadDataDiag(HIF_DEVICE *hifDevice, A_UINT32 address,
                     A_UCHAR *data, A_UINT32 length)
 {
     A_UINT32 count;
-    A_STATUS status = A_OK;
+    int status = A_OK;
 
     for (count = 0; count < length; count += 4, address += 4) {
         if ((status = ar6000_ReadRegDiag(hifDevice, &address,
@@ -261,12 +261,12 @@ ar6000_ReadDataDiag(HIF_DEVICE *hifDevice, A_UINT32 address,
     return status;
 }
 
-A_STATUS
+int
 ar6000_WriteDataDiag(HIF_DEVICE *hifDevice, A_UINT32 address,
                     A_UCHAR *data, A_UINT32 length)
 {
     A_UINT32 count;
-    A_STATUS status = A_OK;
+    int status = A_OK;
 
     for (count = 0; count < length; count += 4, address += 4) {
         if ((status = ar6000_WriteRegDiag(hifDevice, &address,
@@ -279,10 +279,10 @@ ar6000_WriteDataDiag(HIF_DEVICE *hifDevice, A_UINT32 address,
     return status;
 }
 
-A_STATUS
+int
 ar6k_ReadTargetRegister(HIF_DEVICE *hifDevice, int regsel, A_UINT32 *regval)
 {
-    A_STATUS status;
+    int status;
     A_UCHAR vals[4];
     A_UCHAR register_selection[4];
 
@@ -329,10 +329,10 @@ ar6k_FetchTargetRegs(HIF_DEVICE *hifDevice, A_UINT32 *targregs)
 }
 
 #if 0
-static A_STATUS
+static int
 _do_write_diag(HIF_DEVICE *hifDevice, A_UINT32 addr, A_UINT32 value)
 {
-    A_STATUS status;
+    int status;
 
     status = ar6000_WriteRegDiag(hifDevice, &addr, &value);
     if (status != A_OK)
@@ -357,7 +357,7 @@ _do_write_diag(HIF_DEVICE *hifDevice, A_UINT32 addr, A_UINT32 value)
  * TBD: Might want to add special handling for AR6K_OPTION_BMI_DISABLE.
  */
 #if 0
-static A_STATUS
+static int
 _delay_until_target_alive(HIF_DEVICE *hifDevice, A_INT32 wait_msecs, A_UINT32 TargetType)
 {
     A_INT32 actual_wait;
@@ -399,9 +399,9 @@ _delay_until_target_alive(HIF_DEVICE *hifDevice, A_INT32 wait_msecs, A_UINT32 Ta
 #define AR6002_RESET_CONTROL_ADDRESS 0x00004000
 #define AR6003_RESET_CONTROL_ADDRESS 0x00004000
 /* reset device */
-A_STATUS ar6000_reset_device(HIF_DEVICE *hifDevice, A_UINT32 TargetType, A_BOOL waitForCompletion, A_BOOL coldReset)
+int ar6000_reset_device(HIF_DEVICE *hifDevice, A_UINT32 TargetType, A_BOOL waitForCompletion, A_BOOL coldReset)
 {
-    A_STATUS status = A_OK;
+    int status = A_OK;
     A_UINT32 address;
     A_UINT32 data;
 
@@ -557,7 +557,7 @@ void ar6000_dump_target_assert_info(HIF_DEVICE *hifDevice, A_UINT32 TargetType)
 {
     A_UINT32 address;
     A_UINT32 regDumpArea = 0;
-    A_STATUS status;
+    int status;
     A_UINT32 regDumpValues[REGISTER_DUMP_LEN_MAX];
     A_UINT32 regDumpCount = 0;
     A_UINT32 i;
@@ -625,12 +625,12 @@ void ar6000_dump_target_assert_info(HIF_DEVICE *hifDevice, A_UINT32 TargetType)
 
 /* set HTC/Mbox operational parameters, this can only be called when the target is in the
  * BMI phase */
-A_STATUS ar6000_set_htc_params(HIF_DEVICE *hifDevice,
+int ar6000_set_htc_params(HIF_DEVICE *hifDevice,
                                A_UINT32    TargetType,
                                A_UINT32    MboxIsrYieldValue,
                                A_UINT8     HtcControlBuffers)
 {
-    A_STATUS status;
+    int status;
     A_UINT32 blocksizes[HTC_MAILBOX_NUM_MAX];
 
     do {
@@ -685,18 +685,18 @@ A_STATUS ar6000_set_htc_params(HIF_DEVICE *hifDevice,
 }
 
 
-static A_STATUS prepare_ar6002(HIF_DEVICE *hifDevice, A_UINT32 TargetVersion)
+static int prepare_ar6002(HIF_DEVICE *hifDevice, A_UINT32 TargetVersion)
 {
-    A_STATUS status = A_OK;
+    int status = A_OK;
 
     /* placeholder */
 
     return status;
 }
 
-static A_STATUS prepare_ar6003(HIF_DEVICE *hifDevice, A_UINT32 TargetVersion)
+static int prepare_ar6003(HIF_DEVICE *hifDevice, A_UINT32 TargetVersion)
 {
-    A_STATUS status = A_OK;
+    int status = A_OK;
 
     /* placeholder */
 
@@ -704,7 +704,7 @@ static A_STATUS prepare_ar6003(HIF_DEVICE *hifDevice, A_UINT32 TargetVersion)
 }
 
 /* this function assumes the caller has already initialized the BMI APIs */
-A_STATUS ar6000_prepare_target(HIF_DEVICE *hifDevice,
+int ar6000_prepare_target(HIF_DEVICE *hifDevice,
                                A_UINT32    TargetType,
                                A_UINT32    TargetVersion)
 {
@@ -725,7 +725,7 @@ A_STATUS ar6000_prepare_target(HIF_DEVICE *hifDevice,
  * THIS IS FOR USE ONLY WITH AR6002 REV 1.x.
  * TBDXXX: Remove this function when REV 1.x is desupported.
  */
-A_STATUS
+int
 ar6002_REV1_reset_force_host (HIF_DEVICE *hifDevice)
 {
     A_INT32 i;
@@ -735,7 +735,7 @@ ar6002_REV1_reset_force_host (HIF_DEVICE *hifDevice)
     };
     struct forceROM_s *ForceROM;
     A_INT32 szForceROM;
-    A_STATUS status = A_OK;
+    int status = A_OK;
     A_UINT32 address;
     A_UINT32 data;
 
@@ -934,7 +934,7 @@ void a_dump_module_debug_info_by_name(A_CHAR *module_name)
 
 }
 
-A_STATUS a_get_module_mask(A_CHAR *module_name, A_UINT32 *pMask)
+int a_get_module_mask(A_CHAR *module_name, A_UINT32 *pMask)
 {
     ATH_DEBUG_MODULE_DBG_INFO *pInfo = FindModule(module_name);
 
@@ -946,7 +946,7 @@ A_STATUS a_get_module_mask(A_CHAR *module_name, A_UINT32 *pMask)
     return A_OK;
 }
 
-A_STATUS a_set_module_mask(A_CHAR *module_name, A_UINT32 Mask)
+int a_set_module_mask(A_CHAR *module_name, A_UINT32 Mask)
 {
     ATH_DEBUG_MODULE_DBG_INFO *pInfo = FindModule(module_name);
 
@@ -999,11 +999,11 @@ void a_module_debug_support_cleanup(void)
 }
 
     /* can only be called during bmi init stage */
-A_STATUS ar6000_set_hci_bridge_flags(HIF_DEVICE *hifDevice,
+int ar6000_set_hci_bridge_flags(HIF_DEVICE *hifDevice,
                                      A_UINT32    TargetType,
                                      A_UINT32    Flags)
 {
-    A_STATUS status = A_OK;
+    int status = A_OK;
 
     do {
 
diff --git a/drivers/staging/ath6kl/miscdrv/credit_dist.c b/drivers/staging/ath6kl/miscdrv/credit_dist.c
index 91316e0..3f7543d 100644
--- a/drivers/staging/ath6kl/miscdrv/credit_dist.c
+++ b/drivers/staging/ath6kl/miscdrv/credit_dist.c
@@ -393,7 +393,7 @@ static void SeekCredits(COMMON_CREDIT_STATE_INFO *pCredInfo,
 }
 
 /* initialize and setup credit distribution */
-A_STATUS ar6000_setup_credit_dist(HTC_HANDLE HTCHandle, COMMON_CREDIT_STATE_INFO *pCredInfo)
+int ar6000_setup_credit_dist(HTC_HANDLE HTCHandle, COMMON_CREDIT_STATE_INFO *pCredInfo)
 {
     HTC_SERVICE_ID servicepriority[5];
 
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_android.c b/drivers/staging/ath6kl/os/linux/ar6000_android.c
index dbde05f..88487cc 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_android.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_android.c
@@ -51,7 +51,7 @@ static int screen_is_off;
 static struct early_suspend ar6k_early_suspend;
 #endif
 
-static A_STATUS (*ar6000_avail_ev_p)(void *, void *);
+static int (*ar6000_avail_ev_p)(void *, void *);
 
 #if defined(CONFIG_ANDROID_LOGGER) && (!defined(CONFIG_MMC_MSM))
 int logger_write(const enum logidx index,
@@ -269,9 +269,9 @@ void android_release_firmware(const struct firmware *firmware)
     }
 }
 
-static A_STATUS ar6000_android_avail_ev(void *context, void *hif_handle)
+static int ar6000_android_avail_ev(void *context, void *hif_handle)
 {
-    A_STATUS ret;    
+    int ret;
     ar6000_enable_mmchost_detect_change(0);
     ret = ar6000_avail_ev_p(context, hif_handle);
     return ret;
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 126a36a..c171be5 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -305,13 +305,13 @@ extern void android_module_exit(void);
 /*
  * HTC service connection handlers
  */
-static A_STATUS ar6000_avail_ev(void *context, void *hif_handle);
+static int ar6000_avail_ev(void *context, void *hif_handle);
 
-static A_STATUS ar6000_unavail_ev(void *context, void *hif_handle);
+static int ar6000_unavail_ev(void *context, void *hif_handle);
 
-A_STATUS ar6000_configure_target(AR_SOFTC_T *ar);
+int ar6000_configure_target(AR_SOFTC_T *ar);
 
-static void ar6000_target_failure(void *Instance, A_STATUS Status);
+static void ar6000_target_failure(void *Instance, int Status);
 
 static void ar6000_rx(void *Context, HTC_PACKET *pPacket);
 
@@ -343,17 +343,17 @@ ar6000_sysfs_bmi_write(struct file *fp, struct kobject *kobj,
                        struct bin_attribute *bin_attr,
                        char *buf, loff_t pos, size_t count);
 
-static A_STATUS
+static int
 ar6000_sysfs_bmi_init(AR_SOFTC_T *ar);
 
 /* HCI PAL callback function declarations */
-A_STATUS ar6k_setup_hci_pal(AR_SOFTC_T *ar);
+int ar6k_setup_hci_pal(AR_SOFTC_T *ar);
 void  ar6k_cleanup_hci_pal(AR_SOFTC_T *ar);
 
 static void
 ar6000_sysfs_bmi_deinit(AR_SOFTC_T *ar);
 
-A_STATUS
+int
 ar6000_sysfs_bmi_get_config(AR_SOFTC_T *ar, A_UINT32 mode);
 
 /*
@@ -370,7 +370,7 @@ static void ar6000_free_cookie(AR_SOFTC_T *ar, struct ar_cookie * cookie);
 static struct ar_cookie *ar6000_alloc_cookie(AR_SOFTC_T *ar);
 
 #ifdef USER_KEYS
-static A_STATUS ar6000_reinstall_keys(AR_SOFTC_T *ar,A_UINT8 key_op_ctrl);
+static int ar6000_reinstall_keys(AR_SOFTC_T *ar,A_UINT8 key_op_ctrl);
 #endif
 
 #ifdef CONFIG_AP_VIRTUAL_ADAPTER_SUPPORT
@@ -402,7 +402,7 @@ static struct net_device_ops ar6000_netdev_ops = {
  */
 #define REPORT_DEBUG_LOGS_TO_APP
 
-A_STATUS
+int
 ar6000_set_host_app_area(AR_SOFTC_T *ar)
 {
     A_UINT32 address, data;
@@ -430,7 +430,7 @@ dbglog_get_debug_hdr_ptr(AR_SOFTC_T *ar)
 {
     A_UINT32 param;
     A_UINT32 address;
-    A_STATUS status;
+    int status;
 
     address = TARG_VTOP(ar->arTargetType, HOST_INTEREST_ITEM_ADDRESS(ar, hi_dbglog_hdr));
     if ((status = ar6000_ReadDataDiag(ar->arHifDevice, address,
@@ -633,7 +633,7 @@ static int __init
 ar6000_init_module(void)
 {
     static int probed = 0;
-    A_STATUS status;
+    int status;
     OSDRV_CALLBACKS osdrvCallbacks;
 
     a_module_debug_support_init();
@@ -741,7 +741,7 @@ aptcTimerHandler(unsigned long arg)
     A_UINT32 numbytes;
     A_UINT32 throughput;
     AR_SOFTC_T *ar;
-    A_STATUS status;
+    int status;
 
     ar = (AR_SOFTC_T *)arg;
     A_ASSERT(ar != NULL);
@@ -852,10 +852,10 @@ ar6000_sysfs_bmi_write(struct file *fp, struct kobject *kobj,
     return count;
 }
 
-static A_STATUS
+static int
 ar6000_sysfs_bmi_init(AR_SOFTC_T *ar)
 {
-    A_STATUS status;
+    int status;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("BMI: Creating sysfs entry\n"));
     A_MEMZERO(&ar->osDevInfo, sizeof(HIF_DEVICE_OS_DEVICE_INFO));
@@ -993,10 +993,10 @@ ar6000_softmac_update(AR_SOFTC_T *ar, A_UCHAR *eeprom_data, size_t size)
 }
 #endif /* SOFTMAC_FILE_USED */
 
-static A_STATUS
+static int
 ar6000_transfer_bin_file(AR_SOFTC_T *ar, AR6K_BIN_FILE file, A_UINT32 address, A_BOOL compressed)
 {
-    A_STATUS status;
+    int status;
     const char *filename;
     const struct firmware *fw_entry;
     A_UINT32 fw_entry_size;
@@ -1157,7 +1157,7 @@ ar6000_transfer_bin_file(AR_SOFTC_T *ar, AR6K_BIN_FILE file, A_UINT32 address, A
 }
 #endif /* INIT_MODE_DRV_ENABLED */
 
-A_STATUS
+int
 ar6000_update_bdaddr(AR_SOFTC_T *ar)
 {
 
@@ -1184,7 +1184,7 @@ ar6000_update_bdaddr(AR_SOFTC_T *ar)
 return A_OK;
 }
 
-A_STATUS
+int
 ar6000_sysfs_bmi_get_config(AR_SOFTC_T *ar, A_UINT32 mode)
 {
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("BMI: Requesting device specific configuration\n"));
@@ -1205,7 +1205,7 @@ ar6000_sysfs_bmi_get_config(AR_SOFTC_T *ar, A_UINT32 mode)
 #ifdef INIT_MODE_DRV_ENABLED
     } else {
         /* The config is contained within the driver itself */
-        A_STATUS status;
+        int status;
         A_UINT32 param, options, sleep, address;
 
         /* Temporarily disable system sleep */
@@ -1399,7 +1399,7 @@ ar6000_sysfs_bmi_get_config(AR_SOFTC_T *ar, A_UINT32 mode)
     return A_OK;
 }
 
-A_STATUS
+int
 ar6000_configure_target(AR_SOFTC_T *ar)
 {
     A_UINT32 param;
@@ -1595,7 +1595,7 @@ init_netdev(struct net_device *dev, char *name)
 /*
  * HTC Event handlers
  */
-static A_STATUS
+static int
 ar6000_avail_ev(void *context, void *hif_handle)
 {
     int i;
@@ -1607,7 +1607,7 @@ ar6000_avail_ev(void *context, void *hif_handle)
 #ifdef ATH6K_CONFIG_CFG80211
     struct wireless_dev *wdev;
 #endif /* ATH6K_CONFIG_CFG80211 */
-    A_STATUS init_status = A_OK;
+    int init_status = A_OK;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("ar6000_available\n"));
 
@@ -1799,7 +1799,7 @@ ar6000_avail_ev(void *context, void *hif_handle)
         if ((wlaninitmode == WLAN_INIT_MODE_UDEV) ||
             (wlaninitmode == WLAN_INIT_MODE_DRV))
         {
-            A_STATUS status = A_OK;
+            int status = A_OK;
             do {
                 if ((status = ar6000_sysfs_bmi_get_config(ar, wlaninitmode)) != A_OK)
                 {
@@ -1850,7 +1850,7 @@ avail_ev_failed :
     return init_status;
 }
 
-static void ar6000_target_failure(void *Instance, A_STATUS Status)
+static void ar6000_target_failure(void *Instance, int Status)
 {
     AR_SOFTC_T *ar = (AR_SOFTC_T *)Instance;
     WMI_TARGET_ERROR_REPORT_EVENT errEvent;
@@ -1885,7 +1885,7 @@ static void ar6000_target_failure(void *Instance, A_STATUS Status)
     }
 }
 
-static A_STATUS
+static int
 ar6000_unavail_ev(void *context, void *hif_handle)
 {
     AR_SOFTC_T *ar = (AR_SOFTC_T *)context;
@@ -1899,7 +1899,7 @@ ar6000_unavail_ev(void *context, void *hif_handle)
 void
 ar6000_restart_endpoint(struct net_device *dev)
 {
-    A_STATUS status = A_OK;
+    int status = A_OK;
     AR_SOFTC_T *ar = (AR_SOFTC_T *)ar6k_priv(dev);
 
     BMIInit();
@@ -2015,7 +2015,7 @@ ar6000_stop_endpoint(struct net_device *dev, A_BOOL keepprofile, A_BOOL getdbglo
         // FIXME: workaround to reset BT's UART baud rate to default
         if (NULL != ar->exitCallback) {
             AR3K_CONFIG_INFO ar3kconfig;
-            A_STATUS status;
+            int status;
 
             A_MEMZERO(&ar3kconfig,sizeof(ar3kconfig));
             ar6000_set_default_ar3kconfig(ar, (void *)&ar3kconfig);
@@ -2344,11 +2344,11 @@ ar6000_close(struct net_device *dev)
 }
 
 /* connect to a service */
-static A_STATUS ar6000_connectservice(AR_SOFTC_T               *ar,
+static int ar6000_connectservice(AR_SOFTC_T               *ar,
                                       HTC_SERVICE_CONNECT_REQ  *pConnect,
                                       char                     *pDesc)
 {
-    A_STATUS                 status;
+    int                 status;
     HTC_SERVICE_CONNECT_RESP response;
 
     do {
@@ -2433,7 +2433,7 @@ ar6000_endpoint_id2_ac(void * devt, HTC_ENDPOINT_ID ep )
 int ar6000_init(struct net_device *dev)
 {
     AR_SOFTC_T *ar;
-    A_STATUS    status;
+    int    status;
     A_INT32     timeleft;
     A_INT16     i;
     int         ret = 0;
@@ -2618,7 +2618,7 @@ int ar6000_init(struct net_device *dev)
             hciHandles.netDevice = ar->arNetDev;
             hciHandles.hifDevice = ar->arHifDevice;
             hciHandles.htcHandle = ar->arHtcTarget;
-            status = (A_STATUS)(ar6kHciTransCallbacks.setupTransport(&hciHandles));
+            status = (int)(ar6kHciTransCallbacks.setupTransport(&hciHandles));
         }
 #else
         if (setuphci) {
@@ -3273,7 +3273,7 @@ applyAPTCHeuristics(AR_SOFTC_T *ar)
     A_UINT32 numbytes;
     A_UINT32 throughput;
     struct timeval ts;
-    A_STATUS status;
+    int status;
 
     AR6000_SPIN_LOCK(&ar->arLock, 0);
 
@@ -3395,7 +3395,7 @@ ar6000_tx_complete(void *Context, HTC_PACKET_QUEUE *pPacketQueue)
 {
     AR_SOFTC_T     *ar = (AR_SOFTC_T *)Context;
     A_UINT32        mapNo = 0;
-    A_STATUS        status;
+    int        status;
     struct ar_cookie * ar_cookie;
     HTC_ENDPOINT_ID   eid;
     A_BOOL          wakeEvent = FALSE;
@@ -3578,7 +3578,7 @@ ar6000_rx(void *Context, HTC_PACKET *pPacket)
     struct sk_buff *skb = (struct sk_buff *)pPacket->pPktContext;
     int minHdrLen;
     A_UINT8 containsDot11Hdr = 0;
-    A_STATUS        status = pPacket->Status;
+    int        status = pPacket->Status;
     HTC_ENDPOINT_ID   ept = pPacket->Endpoint;
 
     A_ASSERT((status != A_OK) ||
@@ -4762,7 +4762,7 @@ ar6000_hci_event_rcv_evt(struct ar6_softc *ar, WMI_HCI_EVENT *cmd)
     void *osbuf = NULL;
     A_INT8 i;
     A_UINT8 size, *buf;
-    A_STATUS ret = A_OK;
+    int ret = A_OK;
 
     size = cmd->evt_buf_sz + 4;
     osbuf = A_NETBUF_ALLOC(size);
@@ -4887,7 +4887,7 @@ ar6000_tkip_micerr_event(AR_SOFTC_T *ar, A_UINT8 keyid, A_BOOL ismcast)
 }
 
 void
-ar6000_scanComplete_event(AR_SOFTC_T *ar, A_STATUS status)
+ar6000_scanComplete_event(AR_SOFTC_T *ar, int status)
 {
 
 #ifdef ATH6K_CONFIG_CFG80211
@@ -5267,11 +5267,11 @@ ar6000_bssInfo_event_rx(AR_SOFTC_T *ar, A_UINT8 *datap, int len)
 
 A_UINT32 wmiSendCmdNum;
 
-A_STATUS
+int
 ar6000_control_tx(void *devt, void *osbuf, HTC_ENDPOINT_ID eid)
 {
     AR_SOFTC_T       *ar = (AR_SOFTC_T *)devt;
-    A_STATUS         status = A_OK;
+    int         status = A_OK;
     struct ar_cookie *cookie = NULL;
     int i;
 #ifdef CONFIG_PM
@@ -5649,13 +5649,13 @@ a_copy_from_user(void *to, const void *from, A_UINT32 n)
 }
 
 
-A_STATUS
+int
 ar6000_get_driver_cfg(struct net_device *dev,
                         A_UINT16 cfgParam,
                         void *result)
 {
 
-    A_STATUS    ret = 0;
+    int    ret = 0;
 
     switch(cfgParam)
     {
@@ -5958,11 +5958,11 @@ void ap_wapi_rekey_event(AR_SOFTC_T *ar, A_UINT8 type, A_UINT8 *mac)
 #endif
 
 #ifdef USER_KEYS
-static A_STATUS
+static int
 
 ar6000_reinstall_keys(AR_SOFTC_T *ar, A_UINT8 key_op_ctrl)
 {
-    A_STATUS status = A_OK;
+    int status = A_OK;
     struct ieee80211req_key *uik = &ar->user_saved_keys.ucast_ik;
     struct ieee80211req_key *bik = &ar->user_saved_keys.bcast_ik;
     CRYPTO_TYPE  keyType = ar->user_saved_keys.keyType;
@@ -6102,7 +6102,7 @@ ar6000_ap_mode_profile_commit(struct ar6_softc *ar)
     return 0;
 }
 
-A_STATUS
+int
 ar6000_connect_to_ap(struct ar6_softc *ar)
 {
     /* The ssid length check prevents second "essid off" from the user,
@@ -6110,7 +6110,7 @@ ar6000_connect_to_ap(struct ar6_softc *ar)
     */
     if((ar->arWmiReady == TRUE) && (ar->arSsidLen > 0) && ar->arNetworkType!=AP_NETWORK)
     {
-        A_STATUS status;
+        int status;
         if((ADHOC_NETWORK != ar->arNetworkType) &&
            (NONE_AUTH==ar->arAuthMode)          &&
            (WEP_CRYPT==ar->arPairwiseCrypto)) {
@@ -6173,7 +6173,7 @@ ar6000_connect_to_ap(struct ar6_softc *ar)
     return A_ERROR;
 }
 
-A_STATUS
+int
 ar6000_ap_mode_get_wpa_ie(struct ar6_softc *ar, struct ieee80211req_wpaie *wpaie)
 {
     sta_t *conn = NULL;
@@ -6189,7 +6189,7 @@ ar6000_ap_mode_get_wpa_ie(struct ar6_softc *ar, struct ieee80211req_wpaie *wpaie
     return 0;
 }
 
-A_STATUS
+int
 is_iwioctl_allowed(A_UINT8 mode, A_UINT16 cmd)
 {
     if(cmd >= SIOCSIWCOMMIT && cmd <= SIOCGIWPOWER) {
@@ -6206,7 +6206,7 @@ is_iwioctl_allowed(A_UINT8 mode, A_UINT16 cmd)
     return A_ENOTSUP;
 }
 
-A_STATUS
+int
 is_xioctl_allowed(A_UINT8 mode, int cmd)
 {
     if(sizeof(xioctl_filter)-1 < cmd) {
@@ -6224,7 +6224,7 @@ ap_set_wapi_key(struct ar6_softc *ar, void *ikey)
 {
     struct ieee80211req_key *ik = (struct ieee80211req_key *)ikey;
     KEY_USAGE   keyUsage = 0;
-    A_STATUS    status;
+    int    status;
 
     if (A_MEMCMP(ik->ik_macaddr, bcast_mac, IEEE80211_ADDR_LEN) == 0) {
         keyUsage = GROUP_USAGE;
@@ -6345,7 +6345,7 @@ static void DoHTCSendPktsTest(AR_SOFTC_T *ar, int MapNo, HTC_ENDPOINT_ID eid, st
  * AP mode.
  */
 
-A_STATUS ar6000_start_ap_interface(AR_SOFTC_T *ar)
+int ar6000_start_ap_interface(AR_SOFTC_T *ar)
 {
     AR_VIRTUAL_INTERFACE_T *arApDev;
 
@@ -6356,7 +6356,7 @@ A_STATUS ar6000_start_ap_interface(AR_SOFTC_T *ar)
     return A_OK;
 }
 
-A_STATUS ar6000_stop_ap_interface(AR_SOFTC_T *ar)
+int ar6000_stop_ap_interface(AR_SOFTC_T *ar)
 {
     AR_VIRTUAL_INTERFACE_T *arApDev;
 
@@ -6370,7 +6370,7 @@ A_STATUS ar6000_stop_ap_interface(AR_SOFTC_T *ar)
 }
 
 
-A_STATUS ar6000_create_ap_interface(AR_SOFTC_T *ar, char *ap_ifname) 
+int ar6000_create_ap_interface(AR_SOFTC_T *ar, char *ap_ifname)
 {
     struct net_device *dev;
     AR_VIRTUAL_INTERFACE_T *arApDev;
@@ -6403,7 +6403,7 @@ A_STATUS ar6000_create_ap_interface(AR_SOFTC_T *ar, char *ap_ifname)
     return A_OK;
 }
 
-A_STATUS ar6000_add_ap_interface(AR_SOFTC_T *ar, char *ap_ifname) 
+int ar6000_add_ap_interface(AR_SOFTC_T *ar, char *ap_ifname)
 {
     /* Interface already added, need not proceed further */
     if (ar->arApDev != NULL) {
@@ -6420,7 +6420,7 @@ A_STATUS ar6000_add_ap_interface(AR_SOFTC_T *ar, char *ap_ifname)
     return ar6000_start_ap_interface(ar);
 }
 
-A_STATUS ar6000_remove_ap_interface(AR_SOFTC_T *ar)
+int ar6000_remove_ap_interface(AR_SOFTC_T *ar)
 {
     if (arApNetDev) {
         ar6000_stop_ap_interface(ar);
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_pm.c b/drivers/staging/ath6kl/os/linux/ar6000_pm.c
index 13195d4..fbac264 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_pm.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_pm.c
@@ -57,7 +57,7 @@ ATH_DEBUG_INSTANTIATE_MODULE_VAR(pm,
 
 #endif /* DEBUG */
 
-A_STATUS ar6000_exit_cut_power_state(AR_SOFTC_T *ar);
+int ar6000_exit_cut_power_state(AR_SOFTC_T *ar);
 
 #ifdef CONFIG_PM
 static void ar6k_send_asleep_event_to_app(AR_SOFTC_T *ar, A_BOOL asleep)
@@ -122,7 +122,7 @@ static void ar6000_wow_suspend(AR_SOFTC_T *ar)
         struct in_ifaddr *ifa = NULL;
         struct in_device *in_dev;
         A_UINT8 macMask[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
-        A_STATUS status;
+        int status;
         WMI_ADD_WOW_PATTERN_CMD addWowCmd = { .filter = { 0 } };
         WMI_DEL_WOW_PATTERN_CMD delWowCmd;
         WMI_SET_HOST_SLEEP_MODE_CMD hostSleepMode = {FALSE, TRUE};
@@ -211,9 +211,9 @@ static void ar6000_wow_suspend(AR_SOFTC_T *ar)
     }
 }
 
-A_STATUS ar6000_suspend_ev(void *context)
+int ar6000_suspend_ev(void *context)
 {
-    A_STATUS status = A_OK;
+    int status = A_OK;
     AR_SOFTC_T *ar = (AR_SOFTC_T *)context;
     A_INT16 pmmode = ar->arSuspendConfig;
 wow_not_connected:
@@ -248,7 +248,7 @@ wow_not_connected:
     return status;
 }
 
-A_STATUS ar6000_resume_ev(void *context)
+int ar6000_resume_ev(void *context)
 {
     AR_SOFTC_T *ar = (AR_SOFTC_T *)context;
     A_UINT16 powerState = ar->arWlanPowerState;
@@ -290,10 +290,10 @@ void ar6000_check_wow_status(AR_SOFTC_T *ar, struct sk_buff *skb, A_BOOL isEvent
     }
 }
 
-A_STATUS ar6000_power_change_ev(void *context, A_UINT32 config)
+int ar6000_power_change_ev(void *context, A_UINT32 config)
 {
     AR_SOFTC_T *ar = (AR_SOFTC_T *)context;
-    A_STATUS status = A_OK;
+    int status = A_OK;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_PM, ("%s: power change event callback %d \n", __func__, config));
     switch (config) {
@@ -342,10 +342,10 @@ static struct platform_driver ar6000_pm_device = {
 };
 #endif /* CONFIG_PM */
 
-A_STATUS
+int
 ar6000_setup_cut_power_state(struct ar6_softc *ar,  AR6000_WLAN_STATE state)
 {
-    A_STATUS                      status = A_OK;
+    int                      status = A_OK;
     HIF_DEVICE_POWER_CHANGE_TYPE  config;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_PM, ("%s: Cut power %d %d \n", __func__,state, ar->arWlanPowerState));
@@ -412,10 +412,10 @@ ar6000_setup_cut_power_state(struct ar6_softc *ar,  AR6000_WLAN_STATE state)
     return status;
 }
 
-A_STATUS
+int
 ar6000_setup_deep_sleep_state(struct ar6_softc *ar, AR6000_WLAN_STATE state)
 {
-    A_STATUS status = A_OK;
+    int status = A_OK;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_PM, ("%s: Deep sleep %d %d \n", __func__,state, ar->arWlanPowerState));
 #ifdef CONFIG_PM
@@ -536,10 +536,10 @@ ar6000_setup_deep_sleep_state(struct ar6_softc *ar, AR6000_WLAN_STATE state)
     return status;
 }
 
-A_STATUS
+int
 ar6000_update_wlan_pwr_state(struct ar6_softc *ar, AR6000_WLAN_STATE state, A_BOOL pmEvent)
 {
-    A_STATUS status = A_OK;
+    int status = A_OK;
     A_UINT16 powerState, oldPowerState;
     AR6000_WLAN_STATE oldstate = ar->arWlanState;
     A_BOOL wlanOff = ar->arWlanOff;
@@ -650,12 +650,12 @@ ar6000_update_wlan_pwr_state(struct ar6_softc *ar, AR6000_WLAN_STATE state, A_BO
     return status;
 }
 
-A_STATUS
+int
 ar6000_set_bt_hw_state(struct ar6_softc *ar, A_UINT32 enable)
 {
 #ifdef CONFIG_PM
     A_BOOL off = (enable == 0);
-    A_STATUS status;
+    int status;
     if (ar->arBTOff == off) {
         return A_OK;
     }
@@ -667,10 +667,10 @@ ar6000_set_bt_hw_state(struct ar6_softc *ar, A_UINT32 enable)
 #endif
 }
 
-A_STATUS
+int
 ar6000_set_wlan_state(struct ar6_softc *ar, AR6000_WLAN_STATE state)
 {
-    A_STATUS status;
+    int status;
     A_BOOL off = (state == WLAN_DISABLED);
     if (ar->arWlanOff == off) {
         return A_OK;
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_raw_if.c b/drivers/staging/ath6kl/os/linux/ar6000_raw_if.c
index 6b8eeea..10f4885 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_raw_if.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_raw_if.c
@@ -111,10 +111,10 @@ ar6000_htc_raw_write_cb(void *Context, HTC_PACKET *pPacket)
 }
 
 /* connect to a service */
-static A_STATUS ar6000_connect_raw_service(AR_SOFTC_T        *ar,
+static int ar6000_connect_raw_service(AR_SOFTC_T        *ar,
                                            HTC_RAW_STREAM_ID StreamID)
 {
-    A_STATUS                 status;
+    int                 status;
     HTC_SERVICE_CONNECT_RESP response;
     A_UINT8                  streamNo;
     HTC_SERVICE_CONNECT_REQ  connect;
@@ -168,7 +168,7 @@ static A_STATUS ar6000_connect_raw_service(AR_SOFTC_T        *ar,
 
 int ar6000_htc_raw_open(AR_SOFTC_T *ar)
 {
-    A_STATUS status;
+    int status;
     int streamID, endPt, count2;
     raw_htc_buffer *buffer;
     HTC_SERVICE_ID servicepriority;
diff --git a/drivers/staging/ath6kl/os/linux/ar6k_pal.c b/drivers/staging/ath6kl/os/linux/ar6k_pal.c
index 6c98a88..10ee89e 100644
--- a/drivers/staging/ath6kl/os/linux/ar6k_pal.c
+++ b/drivers/staging/ath6kl/os/linux/ar6k_pal.c
@@ -120,7 +120,7 @@ static int btpal_send_frame(struct sk_buff *skb)
 	struct hci_dev *hdev = (struct hci_dev *)skb->dev;
 	HCI_TRANSPORT_PACKET_TYPE type;
 	ar6k_hci_pal_info_t *pHciPalInfo;
-	A_STATUS status = A_OK;
+	int status = A_OK;
 	struct sk_buff *txSkb = NULL;
 	AR_SOFTC_T *ar;
 
@@ -269,9 +269,9 @@ static void bt_cleanup_hci_pal(ar6k_hci_pal_info_t *pHciPalInfo)
 /*********************************************************
  * Allocate HCI device and store in PAL private info structure.
  *********************************************************/
-static A_STATUS bt_setup_hci_pal(ar6k_hci_pal_info_t *pHciPalInfo)
+static int bt_setup_hci_pal(ar6k_hci_pal_info_t *pHciPalInfo)
 {
-	A_STATUS status = A_OK;
+	int status = A_OK;
 	struct hci_dev *pHciDev = NULL;
 
 	if (!setupbtdev) {
@@ -402,9 +402,9 @@ A_BOOL ar6k_pal_recv_pkt(void *pHciPal, void *osbuf)
  * Registers a HCI device.
  * Registers packet receive callback function with ar6k 
  **********************************************************/
-A_STATUS ar6k_setup_hci_pal(void *ar_p)
+int ar6k_setup_hci_pal(void *ar_p)
 {
-	A_STATUS status = A_OK;
+	int status = A_OK;
 	ar6k_hci_pal_info_t *pHciPalInfo;
 	ar6k_pal_config_t ar6k_pal_config;
 	AR_SOFTC_T *ar = (AR_SOFTC_T *)ar_p;
@@ -443,7 +443,7 @@ A_STATUS ar6k_setup_hci_pal(void *ar_p)
 	return status;
 }
 #else  /* AR6K_ENABLE_HCI_PAL */
-A_STATUS ar6k_setup_hci_pal(void *ar_p)
+int ar6k_setup_hci_pal(void *ar_p)
 {
 	return A_OK;
 }
@@ -457,7 +457,7 @@ void ar6k_cleanup_hci_pal(void *ar_p)
  * Register init and callback function with ar6k
  * when PAL driver is a separate kernel module.
  ****************************************************/
-A_STATUS ar6k_register_hci_pal(HCI_TRANSPORT_CALLBACKS *hciTransCallbacks);
+int ar6k_register_hci_pal(HCI_TRANSPORT_CALLBACKS *hciTransCallbacks);
 static int __init pal_init_module(void)
 {
 	HCI_TRANSPORT_CALLBACKS hciTransCallbacks;
diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
index cbd9d55..e3dc99a 100644
--- a/drivers/staging/ath6kl/os/linux/cfg80211.c
+++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
@@ -245,7 +245,7 @@ ar6k_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
                       struct cfg80211_connect_params *sme)
 {
     AR_SOFTC_T *ar = ar6k_priv(dev);
-    A_STATUS status;
+    int status;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO, ("%s: \n", __func__));
 
@@ -780,7 +780,7 @@ ar6k_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 }
 
 void
-ar6k_cfg80211_scanComplete_event(AR_SOFTC_T *ar, A_STATUS status)
+ar6k_cfg80211_scanComplete_event(AR_SOFTC_T *ar, int status)
 {
 
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO, ("%s: status %d\n", __func__, status));
@@ -815,7 +815,7 @@ ar6k_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
     struct ar_key *key = NULL;
     A_UINT8 key_usage;
     A_UINT8 key_type;
-    A_STATUS status = 0;
+    int status = 0;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO, ("%s:\n", __func__));
 
@@ -982,7 +982,7 @@ ar6k_cfg80211_set_default_key(struct wiphy *wiphy, struct net_device *ndev,
 {
     AR_SOFTC_T *ar = (AR_SOFTC_T *)ar6k_priv(ndev);
     struct ar_key *key = NULL;
-    A_STATUS status = A_OK;
+    int status = A_OK;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO, ("%s: index %d\n", __func__, key_index));
 
@@ -1269,7 +1269,7 @@ ar6k_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
                         struct cfg80211_ibss_params *ibss_param)
 {
     AR_SOFTC_T *ar = ar6k_priv(dev);
-    A_STATUS status;
+    int status;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO, ("%s: \n", __func__));
 
diff --git a/drivers/staging/ath6kl/os/linux/export_hci_transport.c b/drivers/staging/ath6kl/os/linux/export_hci_transport.c
index ffbf3d2..03f4567 100644
--- a/drivers/staging/ath6kl/os/linux/export_hci_transport.c
+++ b/drivers/staging/ath6kl/os/linux/export_hci_transport.c
@@ -38,20 +38,20 @@
 
 HCI_TRANSPORT_HANDLE (*_HCI_TransportAttach)(void *HTCHandle, HCI_TRANSPORT_CONFIG_INFO *pInfo);
 void (*_HCI_TransportDetach)(HCI_TRANSPORT_HANDLE HciTrans);
-A_STATUS    (*_HCI_TransportAddReceivePkts)(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET_QUEUE *pQueue);
-A_STATUS    (*_HCI_TransportSendPkt)(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET *pPacket, A_BOOL Synchronous);
+int    (*_HCI_TransportAddReceivePkts)(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET_QUEUE *pQueue);
+int    (*_HCI_TransportSendPkt)(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET *pPacket, A_BOOL Synchronous);
 void        (*_HCI_TransportStop)(HCI_TRANSPORT_HANDLE HciTrans);
-A_STATUS    (*_HCI_TransportStart)(HCI_TRANSPORT_HANDLE HciTrans);
-A_STATUS    (*_HCI_TransportEnableDisableAsyncRecv)(HCI_TRANSPORT_HANDLE HciTrans, A_BOOL Enable);
-A_STATUS    (*_HCI_TransportRecvHCIEventSync)(HCI_TRANSPORT_HANDLE HciTrans, 
+int    (*_HCI_TransportStart)(HCI_TRANSPORT_HANDLE HciTrans);
+int    (*_HCI_TransportEnableDisableAsyncRecv)(HCI_TRANSPORT_HANDLE HciTrans, A_BOOL Enable);
+int    (*_HCI_TransportRecvHCIEventSync)(HCI_TRANSPORT_HANDLE HciTrans,
                                           HTC_PACKET           *pPacket,
                                           int                  MaxPollMS);
-A_STATUS    (*_HCI_TransportSetBaudRate)(HCI_TRANSPORT_HANDLE HciTrans, A_UINT32 Baud);
-A_STATUS    (*_HCI_TransportEnablePowerMgmt)(HCI_TRANSPORT_HANDLE HciTrans, A_BOOL Enable);
+int    (*_HCI_TransportSetBaudRate)(HCI_TRANSPORT_HANDLE HciTrans, A_UINT32 Baud);
+int    (*_HCI_TransportEnablePowerMgmt)(HCI_TRANSPORT_HANDLE HciTrans, A_BOOL Enable);
 
 extern HCI_TRANSPORT_CALLBACKS ar6kHciTransCallbacks;
 
-A_STATUS ar6000_register_hci_transport(HCI_TRANSPORT_CALLBACKS *hciTransCallbacks)
+int ar6000_register_hci_transport(HCI_TRANSPORT_CALLBACKS *hciTransCallbacks)
 {
     ar6kHciTransCallbacks = *hciTransCallbacks;
 
@@ -69,10 +69,10 @@ A_STATUS ar6000_register_hci_transport(HCI_TRANSPORT_CALLBACKS *hciTransCallback
     return A_OK;
 }
 
-A_STATUS
+int
 ar6000_get_hif_dev(HIF_DEVICE *device, void *config)
 {
-    A_STATUS status;
+    int status;
 
     status = HIFConfigureDevice(device,
                                 HIF_DEVICE_GET_OS_DEVICE,
@@ -81,13 +81,13 @@ ar6000_get_hif_dev(HIF_DEVICE *device, void *config)
     return status;
 }
 
-A_STATUS ar6000_set_uart_config(HIF_DEVICE *hifDevice, 
+int ar6000_set_uart_config(HIF_DEVICE *hifDevice,
                                 A_UINT32 scale, 
                                 A_UINT32 step)
 {
     A_UINT32 regAddress;
     A_UINT32 regVal;
-    A_STATUS status;
+    int status;
 
     regAddress = WLAN_UART_BASE_ADDRESS | UART_CLKDIV_ADDRESS;
     regVal = ((A_UINT32)scale << 16) | step;
@@ -97,10 +97,10 @@ A_STATUS ar6000_set_uart_config(HIF_DEVICE *hifDevice,
     return status;
 }
 
-A_STATUS ar6000_get_core_clock_config(HIF_DEVICE *hifDevice, A_UINT32 *data)
+int ar6000_get_core_clock_config(HIF_DEVICE *hifDevice, A_UINT32 *data)
 {
     A_UINT32 regAddress;
-    A_STATUS status;
+    int status;
 
     regAddress = WLAN_RTC_BASE_ADDRESS | WLAN_CPU_CLOCK_ADDRESS;
     /* read CPU clock settings*/
diff --git a/drivers/staging/ath6kl/os/linux/hci_bridge.c b/drivers/staging/ath6kl/os/linux/hci_bridge.c
index 5cdc3b8..c7e0b4e 100644
--- a/drivers/staging/ath6kl/os/linux/hci_bridge.c
+++ b/drivers/staging/ath6kl/os/linux/hci_bridge.c
@@ -106,9 +106,9 @@ AR3K_CONFIG_INFO      ar3kconfig;
 AR6K_HCI_BRIDGE_INFO *g_pHcidevInfo;
 #endif
 
-static A_STATUS bt_setup_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo);
+static int bt_setup_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo);
 static void     bt_cleanup_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo);
-static A_STATUS bt_register_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo);
+static int bt_register_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo);
 static A_BOOL   bt_indicate_recv(AR6K_HCI_BRIDGE_INFO      *pHcidevInfo, 
                                  HCI_TRANSPORT_PACKET_TYPE Type, 
                                  struct sk_buff            *skb);
@@ -116,14 +116,14 @@ static struct sk_buff *bt_alloc_buffer(AR6K_HCI_BRIDGE_INFO *pHcidevInfo, int Le
 static void     bt_free_buffer(AR6K_HCI_BRIDGE_INFO *pHcidevInfo, struct sk_buff *skb);   
                                
 #ifdef EXPORT_HCI_BRIDGE_INTERFACE
-A_STATUS ar6000_setup_hci(void *ar);
+int ar6000_setup_hci(void *ar);
 void     ar6000_cleanup_hci(void *ar);
-A_STATUS hci_test_send(void *ar, struct sk_buff *skb);
+int hci_test_send(void *ar, struct sk_buff *skb);
 #else
-A_STATUS ar6000_setup_hci(AR_SOFTC_T *ar);
+int ar6000_setup_hci(AR_SOFTC_T *ar);
 void     ar6000_cleanup_hci(AR_SOFTC_T *ar);
 /* HCI bridge testing */
-A_STATUS hci_test_send(AR_SOFTC_T *ar, struct sk_buff *skb);
+int hci_test_send(AR_SOFTC_T *ar, struct sk_buff *skb);
 #endif /* EXPORT_HCI_BRIDGE_INTERFACE */
 
 #define LOCK_BRIDGE(dev)   spin_lock_bh(&(dev)->BridgeLock)
@@ -215,12 +215,12 @@ static void RefillRecvBuffers(AR6K_HCI_BRIDGE_INFO      *pHcidevInfo,
 #define HOST_INTEREST_ITEM_ADDRESS(ar, item) \
         (((ar)->arTargetType == TARGET_TYPE_AR6002) ? AR6002_HOST_INTEREST_ITEM_ADDRESS(item) : \
         (((ar)->arTargetType == TARGET_TYPE_AR6003) ? AR6003_HOST_INTEREST_ITEM_ADDRESS(item) : 0))
-static A_STATUS ar6000_hci_transport_ready(HCI_TRANSPORT_HANDLE     HCIHandle, 
+static int ar6000_hci_transport_ready(HCI_TRANSPORT_HANDLE     HCIHandle,
                                            HCI_TRANSPORT_PROPERTIES *pProps, 
                                            void                     *pContext)
 {
     AR6K_HCI_BRIDGE_INFO *pHcidevInfo = (AR6K_HCI_BRIDGE_INFO *)pContext;
-    A_STATUS              status;
+    int              status;
     A_UINT32 address, hci_uart_pwr_mgmt_params;
 //    AR3K_CONFIG_INFO      ar3kconfig;
     
@@ -323,7 +323,7 @@ static A_STATUS ar6000_hci_transport_ready(HCI_TRANSPORT_HANDLE     HCIHandle,
     return status; 
 }
 
-static void ar6000_hci_transport_failure(void *pContext, A_STATUS Status)
+static void ar6000_hci_transport_failure(void *pContext, int Status)
 {
     AR6K_HCI_BRIDGE_INFO *pHcidevInfo = (AR6K_HCI_BRIDGE_INFO *)pContext;
     
@@ -464,13 +464,13 @@ static HCI_SEND_FULL_ACTION  ar6000_hci_pkt_send_full(void *pContext, HTC_PACKET
 }
 
 #ifdef EXPORT_HCI_BRIDGE_INTERFACE
-A_STATUS ar6000_setup_hci(void *ar)
+int ar6000_setup_hci(void *ar)
 #else
-A_STATUS ar6000_setup_hci(AR_SOFTC_T *ar)
+int ar6000_setup_hci(AR_SOFTC_T *ar)
 #endif
 {
     HCI_TRANSPORT_CONFIG_INFO config;
-    A_STATUS                  status = A_OK;
+    int                  status = A_OK;
     int                       i;
     HTC_PACKET                *pPacket;
     AR6K_HCI_BRIDGE_INFO      *pHcidevInfo;
@@ -596,9 +596,9 @@ void  ar6000_cleanup_hci(AR_SOFTC_T *ar)
 }
 
 #ifdef EXPORT_HCI_BRIDGE_INTERFACE
-A_STATUS hci_test_send(void *ar, struct sk_buff *skb)
+int hci_test_send(void *ar, struct sk_buff *skb)
 #else
-A_STATUS hci_test_send(AR_SOFTC_T *ar, struct sk_buff *skb)
+int hci_test_send(AR_SOFTC_T *ar, struct sk_buff *skb)
 #endif
 {
     int              status = A_OK;
@@ -712,7 +712,7 @@ static int bt_send_frame(struct sk_buff *skb)
     HCI_TRANSPORT_PACKET_TYPE  type;
     AR6K_HCI_BRIDGE_INFO       *pHcidevInfo;
     HTC_PACKET                 *pPacket;
-    A_STATUS                   status = A_OK;
+    int                   status = A_OK;
     struct sk_buff             *txSkb = NULL;
     
     if (!hdev) {
@@ -853,9 +853,9 @@ static void bt_destruct(struct hci_dev *hdev)
     /* nothing to do here */
 }
 
-static A_STATUS bt_setup_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo)
+static int bt_setup_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo)
 {
-    A_STATUS                    status = A_OK;
+    int                    status = A_OK;
     struct hci_dev              *pHciDev = NULL;
     HIF_DEVICE_OS_DEVICE_INFO   osDevInfo;
     
@@ -935,10 +935,10 @@ static void bt_cleanup_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo)
     }  
 }
 
-static A_STATUS bt_register_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo)
+static int bt_register_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo)
 {
     int       err;
-    A_STATUS  status = A_OK;
+    int  status = A_OK;
     
     do {          
         AR_DEBUG_PRINTF(ATH_DEBUG_HCI_BRIDGE, ("HCI Bridge: registering HCI... \n"));
@@ -1041,7 +1041,7 @@ static void bt_free_buffer(AR6K_HCI_BRIDGE_INFO *pHcidevInfo, struct sk_buff *sk
 #else // { CONFIG_BLUEZ_HCI_BRIDGE
 
     /* stubs when we only want to test the HCI bridging Interface without the HT stack */
-static A_STATUS bt_setup_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo)
+static int bt_setup_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo)
 {
     return A_OK;    
 }
@@ -1049,7 +1049,7 @@ static void bt_cleanup_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo)
 {   
      
 }
-static A_STATUS bt_register_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo)
+static int bt_register_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo)
 {
     A_ASSERT(FALSE);
     return A_ERROR;    
@@ -1080,9 +1080,9 @@ static void bt_free_buffer(AR6K_HCI_BRIDGE_INFO *pHcidevInfo, struct sk_buff *sk
     /* stubs when GMBOX support is not needed */
     
 #ifdef EXPORT_HCI_BRIDGE_INTERFACE
-A_STATUS ar6000_setup_hci(void *ar)
+int ar6000_setup_hci(void *ar)
 #else
-A_STATUS ar6000_setup_hci(AR_SOFTC_T *ar)
+int ar6000_setup_hci(AR_SOFTC_T *ar)
 #endif
 {
     return A_OK;   
@@ -1120,7 +1120,7 @@ int hci_test_send(AR_SOFTC_T *ar, struct sk_buff *skb)
 static int __init
 hcibridge_init_module(void)
 {
-    A_STATUS status;
+    int status;
     HCI_TRANSPORT_CALLBACKS hciTransCallbacks;
 
     hciTransCallbacks.setupTransport = ar6000_setup_hci;
diff --git a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
index e624883..0dee74a 100644
--- a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
+++ b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
@@ -121,8 +121,8 @@ struct USER_SAVEDKEYS {
 #define DBG_DEFAULTS    (DBG_ERROR|DBG_WARNING)
 
 
-A_STATUS ar6000_ReadRegDiag(HIF_DEVICE *hifDevice, A_UINT32 *address, A_UINT32 *data);
-A_STATUS ar6000_WriteRegDiag(HIF_DEVICE *hifDevice, A_UINT32 *address, A_UINT32 *data);
+int ar6000_ReadRegDiag(HIF_DEVICE *hifDevice, A_UINT32 *address, A_UINT32 *data);
+int ar6000_WriteRegDiag(HIF_DEVICE *hifDevice, A_UINT32 *address, A_UINT32 *data);
 
 #ifdef __cplusplus
 extern "C" {
@@ -737,12 +737,12 @@ remove_sta(AR_SOFTC_T *ar, A_UINT8 *mac, A_UINT16 reason);
 /* HCI support */
 
 #ifndef EXPORT_HCI_BRIDGE_INTERFACE
-A_STATUS ar6000_setup_hci(AR_SOFTC_T *ar);
+int ar6000_setup_hci(AR_SOFTC_T *ar);
 void     ar6000_cleanup_hci(AR_SOFTC_T *ar);
 void     ar6000_set_default_ar3kconfig(AR_SOFTC_T *ar, void *ar3kconfig);
 
 /* HCI bridge testing */
-A_STATUS hci_test_send(AR_SOFTC_T *ar, struct sk_buff *skb);
+int hci_test_send(AR_SOFTC_T *ar, struct sk_buff *skb);
 #endif
 
 ATH_DEBUG_DECLARE_EXTERN(htc);
diff --git a/drivers/staging/ath6kl/os/linux/include/ar6xapi_linux.h b/drivers/staging/ath6kl/os/linux/include/ar6xapi_linux.h
index ea2d181..29fac6b 100644
--- a/drivers/staging/ath6kl/os/linux/include/ar6xapi_linux.h
+++ b/drivers/staging/ath6kl/os/linux/include/ar6xapi_linux.h
@@ -31,7 +31,7 @@ struct ar6_softc;
 
 void ar6000_ready_event(void *devt, A_UINT8 *datap, A_UINT8 phyCap,
                         A_UINT32 sw_ver, A_UINT32 abi_ver);
-A_STATUS ar6000_control_tx(void *devt, void *osbuf, HTC_ENDPOINT_ID eid);
+int ar6000_control_tx(void *devt, void *osbuf, HTC_ENDPOINT_ID eid);
 void ar6000_connect_event(struct ar6_softc *ar, A_UINT16 channel,
                           A_UINT8 *bssid, A_UINT16 listenInterval,
                           A_UINT16 beaconInterval, NETWORK_TYPE networkType,
@@ -50,7 +50,7 @@ void ar6000_keepalive_rx(void *devt, A_UINT8 configured);
 void ar6000_neighborReport_event(struct ar6_softc *ar, int numAps,
                                  WMI_NEIGHBOR_INFO *info);
 void ar6000_set_numdataendpts(struct ar6_softc *ar, A_UINT32 num);
-void ar6000_scanComplete_event(struct ar6_softc *ar, A_STATUS status);
+void ar6000_scanComplete_event(struct ar6_softc *ar, int status);
 void ar6000_targetStats_event(struct ar6_softc *ar,  A_UINT8 *ptr, A_UINT32 len);
 void ar6000_rssiThreshold_event(struct ar6_softc *ar,
                                 WMI_RSSI_THRESHOLD_VAL newThreshold,
@@ -103,7 +103,7 @@ void ar6000_lqThresholdEvent_rx(void *devt, WMI_LQ_THRESHOLD_VAL range, A_UINT8
 
 void ar6000_ratemask_rx(void *devt, A_UINT32 ratemask);
 
-A_STATUS ar6000_get_driver_cfg(struct net_device *dev,
+int ar6000_get_driver_cfg(struct net_device *dev,
                                 A_UINT16 cfgParam,
                                 void *result);
 void ar6000_bssInfo_event_rx(struct ar6_softc *ar, A_UINT8 *data, int len);
@@ -149,12 +149,12 @@ A_UINT32 ar6000_getclkfreq (void);
 int ar6000_ap_mode_profile_commit(struct ar6_softc *ar);
 
 struct ieee80211req_wpaie;
-A_STATUS
+int
 ar6000_ap_mode_get_wpa_ie(struct ar6_softc *ar, struct ieee80211req_wpaie *wpaie);
 
-A_STATUS is_iwioctl_allowed(A_UINT8 mode, A_UINT16 cmd);
+int is_iwioctl_allowed(A_UINT8 mode, A_UINT16 cmd);
 
-A_STATUS is_xioctl_allowed(A_UINT8 mode, int cmd);
+int is_xioctl_allowed(A_UINT8 mode, int cmd);
 
 void ar6000_pspoll_event(struct ar6_softc *ar,A_UINT8 aid);
 
@@ -170,15 +170,15 @@ int ap_set_wapi_key(struct ar6_softc *ar, void *ik);
 void ap_wapi_rekey_event(struct ar6_softc *ar, A_UINT8 type, A_UINT8 *mac);
 #endif
 
-A_STATUS ar6000_connect_to_ap(struct ar6_softc *ar);
-A_STATUS ar6000_update_wlan_pwr_state(struct ar6_softc *ar, AR6000_WLAN_STATE state, A_BOOL suspending);
-A_STATUS ar6000_set_wlan_state(struct ar6_softc *ar, AR6000_WLAN_STATE state);
-A_STATUS ar6000_set_bt_hw_state(struct ar6_softc *ar, A_UINT32 state);
+int ar6000_connect_to_ap(struct ar6_softc *ar);
+int ar6000_update_wlan_pwr_state(struct ar6_softc *ar, AR6000_WLAN_STATE state, A_BOOL suspending);
+int ar6000_set_wlan_state(struct ar6_softc *ar, AR6000_WLAN_STATE state);
+int ar6000_set_bt_hw_state(struct ar6_softc *ar, A_UINT32 state);
 
 #ifdef CONFIG_PM
-A_STATUS ar6000_suspend_ev(void *context);
-A_STATUS ar6000_resume_ev(void *context);
-A_STATUS ar6000_power_change_ev(void *context, A_UINT32 config);
+int ar6000_suspend_ev(void *context);
+int ar6000_resume_ev(void *context);
+int ar6000_power_change_ev(void *context, A_UINT32 config);
 void ar6000_check_wow_status(struct ar6_softc *ar, struct sk_buff *skb, A_BOOL isEvent);
 #endif
 
@@ -186,8 +186,8 @@ void ar6000_pm_init(void);
 void ar6000_pm_exit(void);
 
 #ifdef CONFIG_AP_VIRTUAL_ADAPTER_SUPPORT
-A_STATUS ar6000_add_ap_interface(struct ar6_softc *ar, char *ifname);
-A_STATUS ar6000_remove_ap_interface(struct ar6_softc *ar);
+int ar6000_add_ap_interface(struct ar6_softc *ar, char *ifname);
+int ar6000_remove_ap_interface(struct ar6_softc *ar);
 #endif /* CONFIG_AP_VIRTUAL_ADAPTER_SUPPORT */
 
 #ifdef __cplusplus
diff --git a/drivers/staging/ath6kl/os/linux/include/cfg80211.h b/drivers/staging/ath6kl/os/linux/include/cfg80211.h
index b60e8ac..4494410 100644
--- a/drivers/staging/ath6kl/os/linux/include/cfg80211.h
+++ b/drivers/staging/ath6kl/os/linux/include/cfg80211.h
@@ -27,7 +27,7 @@
 struct wireless_dev *ar6k_cfg80211_init(struct device *dev);
 void ar6k_cfg80211_deinit(AR_SOFTC_T *ar);
 
-void ar6k_cfg80211_scanComplete_event(AR_SOFTC_T *ar, A_STATUS status);
+void ar6k_cfg80211_scanComplete_event(AR_SOFTC_T *ar, int status);
 
 void ar6k_cfg80211_connect_event(AR_SOFTC_T *ar, A_UINT16 channel,
                                 A_UINT8 *bssid, A_UINT16 listenInterval,
diff --git a/drivers/staging/ath6kl/os/linux/include/export_hci_transport.h b/drivers/staging/ath6kl/os/linux/include/export_hci_transport.h
index c150680..49a5d3f 100644
--- a/drivers/staging/ath6kl/os/linux/include/export_hci_transport.h
+++ b/drivers/staging/ath6kl/os/linux/include/export_hci_transport.h
@@ -27,16 +27,16 @@
 
 extern HCI_TRANSPORT_HANDLE (*_HCI_TransportAttach)(void *HTCHandle, HCI_TRANSPORT_CONFIG_INFO *pInfo);
 extern void (*_HCI_TransportDetach)(HCI_TRANSPORT_HANDLE HciTrans);
-extern A_STATUS    (*_HCI_TransportAddReceivePkts)(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET_QUEUE *pQueue);
-extern A_STATUS    (*_HCI_TransportSendPkt)(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET *pPacket, A_BOOL Synchronous);
+extern int    (*_HCI_TransportAddReceivePkts)(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET_QUEUE *pQueue);
+extern int    (*_HCI_TransportSendPkt)(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET *pPacket, A_BOOL Synchronous);
 extern void        (*_HCI_TransportStop)(HCI_TRANSPORT_HANDLE HciTrans);
-extern A_STATUS    (*_HCI_TransportStart)(HCI_TRANSPORT_HANDLE HciTrans);
-extern A_STATUS    (*_HCI_TransportEnableDisableAsyncRecv)(HCI_TRANSPORT_HANDLE HciTrans, A_BOOL Enable);
-extern A_STATUS    (*_HCI_TransportRecvHCIEventSync)(HCI_TRANSPORT_HANDLE HciTrans, 
+extern int    (*_HCI_TransportStart)(HCI_TRANSPORT_HANDLE HciTrans);
+extern int    (*_HCI_TransportEnableDisableAsyncRecv)(HCI_TRANSPORT_HANDLE HciTrans, A_BOOL Enable);
+extern int    (*_HCI_TransportRecvHCIEventSync)(HCI_TRANSPORT_HANDLE HciTrans,
                                           HTC_PACKET           *pPacket,
                                           int                  MaxPollMS);
-extern A_STATUS    (*_HCI_TransportSetBaudRate)(HCI_TRANSPORT_HANDLE HciTrans, A_UINT32 Baud);
-extern A_STATUS    (*_HCI_TransportEnablePowerMgmt)(HCI_TRANSPORT_HANDLE HciTrans, A_BOOL Enable);
+extern int    (*_HCI_TransportSetBaudRate)(HCI_TRANSPORT_HANDLE HciTrans, A_UINT32 Baud);
+extern int    (*_HCI_TransportEnablePowerMgmt)(HCI_TRANSPORT_HANDLE HciTrans, A_BOOL Enable);
 
 
 #define HCI_TransportAttach(HTCHandle, pInfo)   \
@@ -61,11 +61,11 @@ extern A_STATUS    (*_HCI_TransportEnablePowerMgmt)(HCI_TRANSPORT_HANDLE HciTran
             _HCI_TransportEnablePowerMgmt((HciTrans), (Enable))
 
 
-extern A_STATUS ar6000_register_hci_transport(HCI_TRANSPORT_CALLBACKS *hciTransCallbacks);
+extern int ar6000_register_hci_transport(HCI_TRANSPORT_CALLBACKS *hciTransCallbacks);
 
-extern A_STATUS ar6000_get_hif_dev(HIF_DEVICE *device, void *config);
+extern int ar6000_get_hif_dev(HIF_DEVICE *device, void *config);
 
-extern A_STATUS ar6000_set_uart_config(HIF_DEVICE *hifDevice, A_UINT32 scale, A_UINT32 step);
+extern int ar6000_set_uart_config(HIF_DEVICE *hifDevice, A_UINT32 scale, A_UINT32 step);
 
 /* get core clock register settings
  * data: 0 - 40/44MHz
@@ -73,4 +73,4 @@ extern A_STATUS ar6000_set_uart_config(HIF_DEVICE *hifDevice, A_UINT32 scale, A_
  *       where (5G band/2.4G band)
  * assume 2.4G band for now
  */
-extern A_STATUS ar6000_get_core_clock_config(HIF_DEVICE *hifDevice, A_UINT32 *data);
+extern int ar6000_get_core_clock_config(HIF_DEVICE *hifDevice, A_UINT32 *data);
diff --git a/drivers/staging/ath6kl/os/linux/include/osapi_linux.h b/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
index fce6ceb..a1dd024 100644
--- a/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
+++ b/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
@@ -307,15 +307,15 @@ void *a_netbuf_alloc_raw(int size);
 void a_netbuf_free(void *bufPtr);
 void *a_netbuf_to_data(void *bufPtr);
 A_UINT32 a_netbuf_to_len(void *bufPtr);
-A_STATUS a_netbuf_push(void *bufPtr, A_INT32 len);
-A_STATUS a_netbuf_push_data(void *bufPtr, char *srcPtr, A_INT32 len);
-A_STATUS a_netbuf_put(void *bufPtr, A_INT32 len);
-A_STATUS a_netbuf_put_data(void *bufPtr, char *srcPtr, A_INT32 len);
-A_STATUS a_netbuf_pull(void *bufPtr, A_INT32 len);
-A_STATUS a_netbuf_pull_data(void *bufPtr, char *dstPtr, A_INT32 len);
-A_STATUS a_netbuf_trim(void *bufPtr, A_INT32 len);
-A_STATUS a_netbuf_trim_data(void *bufPtr, char *dstPtr, A_INT32 len);
-A_STATUS a_netbuf_setlen(void *bufPtr, A_INT32 len);
+int a_netbuf_push(void *bufPtr, A_INT32 len);
+int a_netbuf_push_data(void *bufPtr, char *srcPtr, A_INT32 len);
+int a_netbuf_put(void *bufPtr, A_INT32 len);
+int a_netbuf_put_data(void *bufPtr, char *srcPtr, A_INT32 len);
+int a_netbuf_pull(void *bufPtr, A_INT32 len);
+int a_netbuf_pull_data(void *bufPtr, char *dstPtr, A_INT32 len);
+int a_netbuf_trim(void *bufPtr, A_INT32 len);
+int a_netbuf_trim_data(void *bufPtr, char *dstPtr, A_INT32 len);
+int a_netbuf_setlen(void *bufPtr, A_INT32 len);
 A_INT32 a_netbuf_headroom(void *bufPtr);
 void a_netbuf_enqueue(A_NETBUF_QUEUE_T *q, void *pkt);
 void a_netbuf_prequeue(A_NETBUF_QUEUE_T *q, void *pkt);
diff --git a/drivers/staging/ath6kl/os/linux/ioctl.c b/drivers/staging/ath6kl/os/linux/ioctl.c
index 0b10376..a159ae5 100644
--- a/drivers/staging/ath6kl/os/linux/ioctl.c
+++ b/drivers/staging/ath6kl/os/linux/ioctl.c
@@ -136,7 +136,7 @@ ar6000_ioctl_set_qos_supp(struct net_device *dev, struct ifreq *rq)
 {
     AR_SOFTC_T *ar = (AR_SOFTC_T *)ar6k_priv(dev);
     WMI_SET_QOS_SUPP_CMD cmd;
-    A_STATUS ret;
+    int ret;
 
     if ((dev->flags & IFF_UP) != IFF_UP) {
         return -EIO;
@@ -171,7 +171,7 @@ ar6000_ioctl_set_wmm(struct net_device *dev, struct ifreq *rq)
 {
     AR_SOFTC_T *ar = (AR_SOFTC_T *)ar6k_priv(dev);
     WMI_SET_WMM_CMD cmd;
-    A_STATUS ret;
+    int ret;
 
     if ((dev->flags & IFF_UP) != IFF_UP) {
         return -EIO;
@@ -212,7 +212,7 @@ ar6000_ioctl_set_txop(struct net_device *dev, struct ifreq *rq)
 {
     AR_SOFTC_T *ar = (AR_SOFTC_T *)ar6k_priv(dev);
     WMI_SET_WMM_TXOP_CMD cmd;
-    A_STATUS ret;
+    int ret;
 
     if ((dev->flags & IFF_UP) != IFF_UP) {
         return -EIO;
@@ -246,7 +246,7 @@ static int
 ar6000_ioctl_get_rd(struct net_device *dev, struct ifreq *rq)
 {
     AR_SOFTC_T *ar = (AR_SOFTC_T *)ar6k_priv(dev);
-    A_STATUS ret = 0;
+    int ret = 0;
 
     if ((dev->flags & IFF_UP) != IFF_UP || ar->arWmiReady == FALSE) {
         return -EIO;
@@ -264,7 +264,7 @@ ar6000_ioctl_set_country(struct net_device *dev, struct ifreq *rq)
 {
     AR_SOFTC_T *ar = (AR_SOFTC_T *)ar6k_priv(dev);
     WMI_AP_SET_COUNTRY_CMD cmd;
-    A_STATUS ret;
+    int ret;
 
     if ((dev->flags & IFF_UP) != IFF_UP) {
         return -EIO;
@@ -577,7 +577,7 @@ ar6000_ioctl_create_qos(struct net_device *dev, struct ifreq *rq)
 {
     AR_SOFTC_T *ar = (AR_SOFTC_T *)ar6k_priv(dev);
     WMI_CREATE_PSTREAM_CMD cmd;
-    A_STATUS ret;
+    int ret;
 
     if (ar->arWmiReady == FALSE) {
         return -EIO;
@@ -662,7 +662,7 @@ ar6000_ioctl_get_qos_queue(struct net_device *dev, struct ifreq *rq)
 }
 
 #ifdef CONFIG_HOST_TCMD_SUPPORT
-static A_STATUS
+static int
 ar6000_ioctl_tcmd_get_rx_report(struct net_device *dev,
                                  struct ifreq *rq, A_UINT8 *data, A_UINT32 len)
 {
@@ -1386,7 +1386,7 @@ ar6000_gpio_ack_rx(void)
     wake_up(&arEvent);
 }
 
-A_STATUS
+int
 ar6000_gpio_output_set(struct net_device *dev,
                        A_UINT32 set_mask,
                        A_UINT32 clear_mask,
@@ -1400,7 +1400,7 @@ ar6000_gpio_output_set(struct net_device *dev,
                 set_mask, clear_mask, enable_mask, disable_mask);
 }
 
-static A_STATUS
+static int
 ar6000_gpio_input_get(struct net_device *dev)
 {
     AR_SOFTC_T *ar = (AR_SOFTC_T *)ar6k_priv(dev);
@@ -1409,7 +1409,7 @@ ar6000_gpio_input_get(struct net_device *dev)
     return wmi_gpio_input_get(ar->arWmi);
 }
 
-static A_STATUS
+static int
 ar6000_gpio_register_set(struct net_device *dev,
                          A_UINT32 gpioreg_id,
                          A_UINT32 value)
@@ -1420,7 +1420,7 @@ ar6000_gpio_register_set(struct net_device *dev,
     return wmi_gpio_register_set(ar->arWmi, gpioreg_id, value);
 }
 
-static A_STATUS
+static int
 ar6000_gpio_register_get(struct net_device *dev,
                          A_UINT32 gpioreg_id)
 {
@@ -1430,7 +1430,7 @@ ar6000_gpio_register_get(struct net_device *dev,
     return wmi_gpio_register_get(ar->arWmi, gpioreg_id);
 }
 
-static A_STATUS
+static int
 ar6000_gpio_intr_ack(struct net_device *dev,
                      A_UINT32 ack_mask)
 {
@@ -1445,7 +1445,7 @@ ar6000_gpio_intr_ack(struct net_device *dev,
 static struct prof_count_s prof_count_results;
 static A_BOOL prof_count_available; /* Requested GPIO data available */
 
-static A_STATUS
+static int
 prof_count_get(struct net_device *dev)
 {
     AR_SOFTC_T *ar = (AR_SOFTC_T *)ar6k_priv(dev);
@@ -1469,14 +1469,14 @@ prof_count_rx(A_UINT32 addr, A_UINT32 count)
 #endif /* CONFIG_TARGET_PROFILE_SUPPORT */
 
 
-static A_STATUS
+static int
 ar6000_create_acl_data_osbuf(struct net_device *dev, A_UINT8 *userdata, void **p_osbuf)
 {
     void *osbuf = NULL;
     A_UINT8 tmp_space[8];
     HCI_ACL_DATA_PKT *acl;
     A_UINT8 hdr_size, *datap=NULL;
-    A_STATUS ret = A_OK;
+    int ret = A_OK;
 
     /* ACL is in data path. There is a need to create pool
      * mechanism for allocating and freeing NETBUFs - ToDo later.
@@ -1739,7 +1739,7 @@ int
 ar6000_ioctl_setkey(AR_SOFTC_T *ar, struct ieee80211req_key *ik)
 {
     KEY_USAGE keyUsage;
-    A_STATUS status;
+    int status;
     CRYPTO_TYPE keyType = NONE_CRYPT;
 
 #ifdef USER_KEYS
@@ -1885,7 +1885,7 @@ int ar6000_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
             goto ioctl_done;
     }
     } else {
-        A_STATUS ret = is_iwioctl_allowed(ar->arNextMode, cmd);
+        int ret = is_iwioctl_allowed(ar->arNextMode, cmd);
         if(ret == A_ENOTSUP) {
             A_PRINTF("iwioctl: cmd=0x%x not allowed in this mode\n", cmd);
             ret = -EOPNOTSUPP;
@@ -1994,7 +1994,7 @@ int ar6000_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
             } else if (copy_from_user(&req, userdata, sizeof(struct ieee80211req_addpmkid))) {
                 ret = -EFAULT;
             } else {
-                A_STATUS status;
+                int status;
 
                 AR_DEBUG_PRINTF(ATH_DEBUG_WLAN_CONNECT,("Add pmkid for %2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x en=%d\n",
                     req.pi_bssid[0], req.pi_bssid[1], req.pi_bssid[2],
@@ -3365,7 +3365,7 @@ int ar6000_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
         case AR6000_XIOCTL_WMI_SETFIXRATES:
         {
             WMI_FIX_RATES_CMD setFixRatesCmd;
-            A_STATUS returnStatus;
+            int returnStatus;
 
             if (ar->arWmiReady == FALSE) {
                     ret = -EIO;
diff --git a/drivers/staging/ath6kl/os/linux/netbuf.c b/drivers/staging/ath6kl/os/linux/netbuf.c
index 15e5d04..31848d7 100644
--- a/drivers/staging/ath6kl/os/linux/netbuf.c
+++ b/drivers/staging/ath6kl/os/linux/netbuf.c
@@ -105,7 +105,7 @@ a_netbuf_to_data(void *bufPtr)
  * Add len # of bytes to the beginning of the network buffer
  * pointed to by bufPtr
  */
-A_STATUS
+int
 a_netbuf_push(void *bufPtr, A_INT32 len)
 {
     skb_push((struct sk_buff *)bufPtr, len);
@@ -117,7 +117,7 @@ a_netbuf_push(void *bufPtr, A_INT32 len)
  * Add len # of bytes to the beginning of the network buffer
  * pointed to by bufPtr and also fill with data
  */
-A_STATUS
+int
 a_netbuf_push_data(void *bufPtr, char *srcPtr, A_INT32 len)
 {
     skb_push((struct sk_buff *) bufPtr, len);
@@ -130,7 +130,7 @@ a_netbuf_push_data(void *bufPtr, char *srcPtr, A_INT32 len)
  * Add len # of bytes to the end of the network buffer
  * pointed to by bufPtr
  */
-A_STATUS
+int
 a_netbuf_put(void *bufPtr, A_INT32 len)
 {
     skb_put((struct sk_buff *)bufPtr, len);
@@ -142,7 +142,7 @@ a_netbuf_put(void *bufPtr, A_INT32 len)
  * Add len # of bytes to the end of the network buffer
  * pointed to by bufPtr and also fill with data
  */
-A_STATUS
+int
 a_netbuf_put_data(void *bufPtr, char *srcPtr, A_INT32 len)
 {
     char *start = (char*)(((struct sk_buff *)bufPtr)->data +
@@ -157,7 +157,7 @@ a_netbuf_put_data(void *bufPtr, char *srcPtr, A_INT32 len)
 /*
  * Trim the network buffer pointed to by bufPtr to len # of bytes 
  */
-A_STATUS
+int
 a_netbuf_setlen(void *bufPtr, A_INT32 len)
 {
     skb_trim((struct sk_buff *)bufPtr, len);
@@ -168,7 +168,7 @@ a_netbuf_setlen(void *bufPtr, A_INT32 len)
 /*
  * Chop of len # of bytes from the end of the buffer.
  */
-A_STATUS
+int
 a_netbuf_trim(void *bufPtr, A_INT32 len)
 {
     skb_trim((struct sk_buff *)bufPtr, ((struct sk_buff *)bufPtr)->len - len);
@@ -179,7 +179,7 @@ a_netbuf_trim(void *bufPtr, A_INT32 len)
 /*
  * Chop of len # of bytes from the end of the buffer and return the data.
  */
-A_STATUS
+int
 a_netbuf_trim_data(void *bufPtr, char *dstPtr, A_INT32 len)
 {
     char *start = (char*)(((struct sk_buff *)bufPtr)->data +
@@ -204,7 +204,7 @@ a_netbuf_headroom(void *bufPtr)
 /*
  * Removes specified number of bytes from the beginning of the buffer
  */
-A_STATUS
+int
 a_netbuf_pull(void *bufPtr, A_INT32 len)
 {
     skb_pull((struct sk_buff *)bufPtr, len);
@@ -216,7 +216,7 @@ a_netbuf_pull(void *bufPtr, A_INT32 len)
  * Removes specified number of bytes from the beginning of the buffer
  * and return the data
  */
-A_STATUS
+int
 a_netbuf_pull_data(void *bufPtr, char *dstPtr, A_INT32 len)
 {
     A_MEMCPY(dstPtr, ((struct sk_buff *)bufPtr)->data, len);
diff --git a/drivers/staging/ath6kl/os/linux/wireless_ext.c b/drivers/staging/ath6kl/os/linux/wireless_ext.c
index bb6de0f..dc32e2d 100644
--- a/drivers/staging/ath6kl/os/linux/wireless_ext.c
+++ b/drivers/staging/ath6kl/os/linux/wireless_ext.c
@@ -463,7 +463,7 @@ ar6000_ioctl_siwessid(struct net_device *dev,
                      struct iw_point *data, char *ssid)
 {
     AR_SOFTC_T *ar = (AR_SOFTC_T *)ar6k_priv(dev);
-    A_STATUS status;
+    int status;
     A_UINT8     arNetworkType;
     A_UINT8 prevMode = ar->arNetworkType;
 
@@ -1548,7 +1548,7 @@ ar6000_ioctl_siwpmksa(struct net_device *dev,
 {
     AR_SOFTC_T *ar = (AR_SOFTC_T *)ar6k_priv(dev);
     A_INT32 ret;
-    A_STATUS status;
+    int status;
     struct iw_pmksa *pmksa;
 
     pmksa = (struct iw_pmksa *)extra;
@@ -1599,7 +1599,7 @@ static int ar6000_set_wapi_key(struct net_device *dev,
     A_INT32     index;
     A_UINT32    *PN;
     A_INT32     i;
-    A_STATUS    status;
+    int    status;
     A_UINT8     wapiKeyRsc[16];
     CRYPTO_TYPE keyType = WAPI_CRYPT;
     const A_UINT8 broadcastMac[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
@@ -1660,7 +1660,7 @@ ar6000_ioctl_siwencodeext(struct net_device *dev,
     A_INT32 keyLen;
     A_UINT8 *keyData;
     A_UINT8 keyRsc[8];
-    A_STATUS status;
+    int status;
     CRYPTO_TYPE keyType;
 #ifdef USER_KEYS
     struct ieee80211req_key ik;
diff --git a/drivers/staging/ath6kl/reorder/rcv_aggr.c b/drivers/staging/ath6kl/reorder/rcv_aggr.c
index 092bb30..d53ab15 100644
--- a/drivers/staging/ath6kl/reorder/rcv_aggr.c
+++ b/drivers/staging/ath6kl/reorder/rcv_aggr.c
@@ -33,7 +33,7 @@
 #include "aggr_rx_internal.h"
 #include "wmi.h"
 
-extern A_STATUS
+extern int
 wmi_dot3_2_dix(void *osbuf);
 
 static void
@@ -57,7 +57,7 @@ aggr_init(ALLOC_NETBUFS netbuf_allocator)
     AGGR_INFO   *p_aggr = NULL;
     RXTID *rxtid;
     A_UINT8 i;
-    A_STATUS status = A_OK;
+    int status = A_OK;
 
     A_PRINTF("In aggr_init..\n");
 
diff --git a/drivers/staging/ath6kl/wlan/src/wlan_recv_beacon.c b/drivers/staging/ath6kl/wlan/src/wlan_recv_beacon.c
index f4926f2..2743c4c 100644
--- a/drivers/staging/ath6kl/wlan/src/wlan_recv_beacon.c
+++ b/drivers/staging/ath6kl/wlan/src/wlan_recv_beacon.c
@@ -97,7 +97,7 @@ iswscoui(const A_UINT8 *frm)
     return frm[1] > 3 && LE_READ_4(frm+2) == ((0x04<<24)|WPA_OUI);
 }
 
-A_STATUS
+int
 wlan_parse_beacon(A_UINT8 *buf, int framelen, struct ieee80211_common_ie *cie)
 {
     A_UINT8 *frm, *efrm;
diff --git a/drivers/staging/ath6kl/wmi/wmi.c b/drivers/staging/ath6kl/wmi/wmi.c
index 7800778..1cf9e96 100644
--- a/drivers/staging/ath6kl/wmi/wmi.c
+++ b/drivers/staging/ath6kl/wmi/wmi.c
@@ -70,100 +70,100 @@ ATH_DEBUG_INSTANTIATE_MODULE_VAR(wmi,
 #define A_DPRINTF   AR_DEBUG_PRINTF
 #endif
 
-static A_STATUS wmi_ready_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
+static int wmi_ready_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
 
-static A_STATUS wmi_connect_event_rx(struct wmi_t *wmip, A_UINT8 *datap,
+static int wmi_connect_event_rx(struct wmi_t *wmip, A_UINT8 *datap,
                                      int len);
-static A_STATUS wmi_disconnect_event_rx(struct wmi_t *wmip, A_UINT8 *datap,
+static int wmi_disconnect_event_rx(struct wmi_t *wmip, A_UINT8 *datap,
                                         int len);
 
-static A_STATUS wmi_tkip_micerr_event_rx(struct wmi_t *wmip, A_UINT8 *datap,
+static int wmi_tkip_micerr_event_rx(struct wmi_t *wmip, A_UINT8 *datap,
                                         int len);
-static A_STATUS wmi_bssInfo_event_rx(struct wmi_t *wmip, A_UINT8 *datap,
+static int wmi_bssInfo_event_rx(struct wmi_t *wmip, A_UINT8 *datap,
                                      int len);
-static A_STATUS wmi_opt_frame_event_rx(struct wmi_t *wmip, A_UINT8 *datap,
+static int wmi_opt_frame_event_rx(struct wmi_t *wmip, A_UINT8 *datap,
                                        int len);
-static A_STATUS wmi_pstream_timeout_event_rx(struct wmi_t *wmip, A_UINT8 *datap,
+static int wmi_pstream_timeout_event_rx(struct wmi_t *wmip, A_UINT8 *datap,
                                      int len);
-static A_STATUS wmi_sync_point(struct wmi_t *wmip);
+static int wmi_sync_point(struct wmi_t *wmip);
 
-static A_STATUS wmi_bitrate_reply_rx(struct wmi_t *wmip, A_UINT8 *datap,
+static int wmi_bitrate_reply_rx(struct wmi_t *wmip, A_UINT8 *datap,
                                      int len);
-static A_STATUS wmi_ratemask_reply_rx(struct wmi_t *wmip, A_UINT8 *datap,
+static int wmi_ratemask_reply_rx(struct wmi_t *wmip, A_UINT8 *datap,
                                      int len);
-static A_STATUS wmi_channelList_reply_rx(struct wmi_t *wmip, A_UINT8 *datap,
+static int wmi_channelList_reply_rx(struct wmi_t *wmip, A_UINT8 *datap,
                                          int len);
-static A_STATUS wmi_regDomain_event_rx(struct wmi_t *wmip, A_UINT8 *datap,
+static int wmi_regDomain_event_rx(struct wmi_t *wmip, A_UINT8 *datap,
                                        int len);
-static A_STATUS wmi_txPwr_reply_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
-static A_STATUS wmi_neighborReport_event_rx(struct wmi_t *wmip, A_UINT8 *datap,
+static int wmi_txPwr_reply_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
+static int wmi_neighborReport_event_rx(struct wmi_t *wmip, A_UINT8 *datap,
                                              int len);
 
-static A_STATUS wmi_dset_open_req_rx(struct wmi_t *wmip, A_UINT8 *datap,
+static int wmi_dset_open_req_rx(struct wmi_t *wmip, A_UINT8 *datap,
                                      int len);
 #ifdef CONFIG_HOST_DSET_SUPPORT
-static A_STATUS wmi_dset_close_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
-static A_STATUS wmi_dset_data_req_rx(struct wmi_t *wmip, A_UINT8 *datap,
+static int wmi_dset_close_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
+static int wmi_dset_data_req_rx(struct wmi_t *wmip, A_UINT8 *datap,
                                      int len);
 #endif /* CONFIG_HOST_DSET_SUPPORT */
 
 
-static A_STATUS wmi_scanComplete_rx(struct wmi_t *wmip, A_UINT8 *datap,
+static int wmi_scanComplete_rx(struct wmi_t *wmip, A_UINT8 *datap,
                                      int len);
-static A_STATUS wmi_errorEvent_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
-static A_STATUS wmi_statsEvent_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
-static A_STATUS wmi_rssiThresholdEvent_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
-static A_STATUS wmi_hbChallengeResp_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
-static A_STATUS wmi_reportErrorEvent_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
-static A_STATUS wmi_cac_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
-static A_STATUS wmi_channel_change_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
-static A_STATUS wmi_roam_tbl_event_rx(struct wmi_t *wmip, A_UINT8 *datap,
+static int wmi_errorEvent_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
+static int wmi_statsEvent_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
+static int wmi_rssiThresholdEvent_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
+static int wmi_hbChallengeResp_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
+static int wmi_reportErrorEvent_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
+static int wmi_cac_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
+static int wmi_channel_change_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
+static int wmi_roam_tbl_event_rx(struct wmi_t *wmip, A_UINT8 *datap,
                                       int len);
-static A_STATUS wmi_roam_data_event_rx(struct wmi_t *wmip, A_UINT8 *datap,
+static int wmi_roam_data_event_rx(struct wmi_t *wmip, A_UINT8 *datap,
                                       int len);
-static A_STATUS wmi_get_wow_list_event_rx(struct wmi_t *wmip, A_UINT8 *datap,
+static int wmi_get_wow_list_event_rx(struct wmi_t *wmip, A_UINT8 *datap,
                                       int len);
-static A_STATUS
+static int
 wmi_get_pmkid_list_event_rx(struct wmi_t *wmip, A_UINT8 *datap, A_UINT32 len);
 
-static A_STATUS
+static int
 wmi_set_params_event_rx(struct wmi_t *wmip, A_UINT8 *datap, A_UINT32 len);
 
-static A_STATUS
+static int
 wmi_acm_reject_event_rx(struct wmi_t *wmip, A_UINT8 *datap, A_UINT32 len);
 
 #ifdef CONFIG_HOST_GPIO_SUPPORT
-static A_STATUS wmi_gpio_intr_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
-static A_STATUS wmi_gpio_data_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
-static A_STATUS wmi_gpio_ack_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
+static int wmi_gpio_intr_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
+static int wmi_gpio_data_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
+static int wmi_gpio_ack_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
 #endif /* CONFIG_HOST_GPIO_SUPPORT */
 
 #ifdef CONFIG_HOST_TCMD_SUPPORT
-static A_STATUS
+static int
 wmi_tcmd_test_report_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
 #endif
 
-static A_STATUS
+static int
 wmi_txRetryErrEvent_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
 
-static A_STATUS
+static int
 wmi_snrThresholdEvent_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
 
-static A_STATUS
+static int
 wmi_lqThresholdEvent_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
 
 static A_BOOL
 wmi_is_bitrate_index_valid(struct wmi_t *wmip, A_INT32 rateIndex);
 
-static A_STATUS
+static int
 wmi_aplistEvent_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
 
-static A_STATUS
+static int
 wmi_dbglog_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
 
-static A_STATUS wmi_keepalive_reply_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
+static int wmi_keepalive_reply_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
 
-A_STATUS wmi_cmd_send_xtnd(struct wmi_t *wmip, void *osbuf, WMIX_COMMAND_ID cmdId,
+int wmi_cmd_send_xtnd(struct wmi_t *wmip, void *osbuf, WMIX_COMMAND_ID cmdId,
                   WMI_SYNC_FLAG syncflag);
 
 A_UINT8 ar6000_get_upper_threshold(A_INT16 rssi, SQ_THRESHOLD_PARAMS *sq_thresh, A_UINT32 size);
@@ -171,33 +171,33 @@ A_UINT8 ar6000_get_lower_threshold(A_INT16 rssi, SQ_THRESHOLD_PARAMS *sq_thresh,
 
 void wmi_cache_configure_rssithreshold(struct wmi_t *wmip, WMI_RSSI_THRESHOLD_PARAMS_CMD *rssiCmd);
 void wmi_cache_configure_snrthreshold(struct wmi_t *wmip, WMI_SNR_THRESHOLD_PARAMS_CMD *snrCmd);
-static A_STATUS wmi_send_rssi_threshold_params(struct wmi_t *wmip,
+static int wmi_send_rssi_threshold_params(struct wmi_t *wmip,
                               WMI_RSSI_THRESHOLD_PARAMS_CMD *rssiCmd);
-static A_STATUS wmi_send_snr_threshold_params(struct wmi_t *wmip,
+static int wmi_send_snr_threshold_params(struct wmi_t *wmip,
                              WMI_SNR_THRESHOLD_PARAMS_CMD *snrCmd);
 #if defined(CONFIG_TARGET_PROFILE_SUPPORT)
-static A_STATUS
+static int
 wmi_prof_count_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
 #endif /* CONFIG_TARGET_PROFILE_SUPPORT */
 
-static A_STATUS wmi_pspoll_event_rx(struct wmi_t *wmip, A_UINT8 *datap,
+static int wmi_pspoll_event_rx(struct wmi_t *wmip, A_UINT8 *datap,
                                      int len);
-static A_STATUS wmi_dtimexpiry_event_rx(struct wmi_t *wmip, A_UINT8 *datap,
+static int wmi_dtimexpiry_event_rx(struct wmi_t *wmip, A_UINT8 *datap,
                                      int len);
 
-static A_STATUS wmi_peer_node_event_rx (struct wmi_t *wmip, A_UINT8 *datap,
+static int wmi_peer_node_event_rx (struct wmi_t *wmip, A_UINT8 *datap,
                                         int len);
 #ifdef ATH_AR6K_11N_SUPPORT
-static A_STATUS wmi_addba_req_event_rx(struct wmi_t *, A_UINT8 *, int);
-static A_STATUS wmi_addba_resp_event_rx(struct wmi_t *, A_UINT8 *, int);
-static A_STATUS wmi_delba_req_event_rx(struct wmi_t *, A_UINT8 *, int);
-static A_STATUS wmi_btcoex_config_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
-static A_STATUS wmi_btcoex_stats_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
+static int wmi_addba_req_event_rx(struct wmi_t *, A_UINT8 *, int);
+static int wmi_addba_resp_event_rx(struct wmi_t *, A_UINT8 *, int);
+static int wmi_delba_req_event_rx(struct wmi_t *, A_UINT8 *, int);
+static int wmi_btcoex_config_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
+static int wmi_btcoex_stats_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len);
 #endif
-static A_STATUS wmi_hci_event_rx(struct wmi_t *, A_UINT8 *, int);
+static int wmi_hci_event_rx(struct wmi_t *, A_UINT8 *, int);
 
 #ifdef WAPI_ENABLE
-static A_STATUS wmi_wapi_rekey_event_rx(struct wmi_t *wmip, A_UINT8 *datap,
+static int wmi_wapi_rekey_event_rx(struct wmi_t *wmip, A_UINT8 *datap,
                                      int len);
 #endif
 
@@ -391,7 +391,7 @@ wmi_shutdown(struct wmi_t *wmip)
  *  Assumes the entire DIX header is contigous and that there is
  *  enough room in the buffer for a 802.3 mac header and LLC+SNAP headers.
  */
-A_STATUS
+int
 wmi_dix_2_dot3(struct wmi_t *wmip, void *osbuf)
 {
     A_UINT8          *datap;
@@ -449,7 +449,7 @@ wmi_dix_2_dot3(struct wmi_t *wmip, void *osbuf)
     return (A_OK);
 }
 
-A_STATUS wmi_meta_add(struct wmi_t *wmip, void *osbuf, A_UINT8 *pVersion,void *pTxMetaS)
+int wmi_meta_add(struct wmi_t *wmip, void *osbuf, A_UINT8 *pVersion,void *pTxMetaS)
 {
     switch(*pVersion){
 	case 0:
@@ -494,13 +494,13 @@ A_STATUS wmi_meta_add(struct wmi_t *wmip, void *osbuf, A_UINT8 *pVersion,void *p
 }
 
 /* Adds a WMI data header */
-A_STATUS
+int
 wmi_data_hdr_add(struct wmi_t *wmip, void *osbuf, A_UINT8 msgType, A_BOOL bMoreData,
                     WMI_DATA_HDR_DATA_TYPE data_type,A_UINT8 metaVersion, void *pTxMetaS)
 {
     WMI_DATA_HDR     *dtHdr;
 //    A_UINT8 metaVersion = 0;
-    A_STATUS status;
+    int status;
 
     A_ASSERT(osbuf != NULL);
 
@@ -621,7 +621,7 @@ A_UINT8 wmi_implicit_create_pstream(struct wmi_t *wmip, void *osbuf, A_UINT32 la
     return trafficClass;
 }
 
-A_STATUS
+int
 wmi_dot11_hdr_add (struct wmi_t *wmip, void *osbuf, NETWORK_TYPE mode)
 {
     A_UINT8          *datap;
@@ -713,7 +713,7 @@ AddDot11Hdr:
     return (A_OK);
 }
 
-A_STATUS
+int
 wmi_dot11_hdr_remove(struct wmi_t *wmip, void *osbuf)
 {
     A_UINT8          *datap;
@@ -781,7 +781,7 @@ wmi_dot11_hdr_remove(struct wmi_t *wmip, void *osbuf)
  *  performs 802.3 to DIX encapsulation for received packets.
  *  Assumes the entire 802.3 header is contigous.
  */
-A_STATUS
+int
 wmi_dot3_2_dix(void *osbuf)
 {
     A_UINT8          *datap;
@@ -809,7 +809,7 @@ wmi_dot3_2_dix(void *osbuf)
 /*
  * Removes a WMI data header
  */
-A_STATUS
+int
 wmi_data_hdr_remove(struct wmi_t *wmip, void *osbuf)
 {
     A_ASSERT(osbuf != NULL);
@@ -826,14 +826,14 @@ wmi_iterate_nodes(struct wmi_t *wmip, wlan_node_iter_func *f, void *arg)
 /*
  * WMI Extended Event received from Target.
  */
-A_STATUS
+int
 wmi_control_rx_xtnd(struct wmi_t *wmip, void *osbuf)
 {
     WMIX_CMD_HDR *cmd;
     A_UINT16 id;
     A_UINT8 *datap;
     A_UINT32 len;
-    A_STATUS status = A_OK;
+    int status = A_OK;
 
     if (A_NETBUF_LEN(osbuf) < sizeof(WMIX_CMD_HDR)) {
         A_DPRINTF(DBG_WMI, (DBGFMT "bad packet 1\n", DBGARG));
@@ -903,14 +903,14 @@ wmi_control_rx_xtnd(struct wmi_t *wmip, void *osbuf)
  */
 A_UINT32 cmdRecvNum;
 
-A_STATUS
+int
 wmi_control_rx(struct wmi_t *wmip, void *osbuf)
 {
     WMI_CMD_HDR *cmd;
     A_UINT16 id;
     A_UINT8 *datap;
     A_UINT32 len, i, loggingReq;
-    A_STATUS status = A_OK;
+    int status = A_OK;
 
     A_ASSERT(osbuf != NULL);
     if (A_NETBUF_LEN(osbuf) < sizeof(WMI_CMD_HDR)) {
@@ -1192,7 +1192,7 @@ wmi_control_rx(struct wmi_t *wmip, void *osbuf)
 }
 
 /* Send a "simple" wmi command -- one with no arguments */
-static A_STATUS
+static int
 wmi_simple_cmd(struct wmi_t *wmip, WMI_COMMAND_ID cmdid)
 {
     void *osbuf;
@@ -1209,7 +1209,7 @@ wmi_simple_cmd(struct wmi_t *wmip, WMI_COMMAND_ID cmdid)
    Enabling this command only if GPIO or profiling support is enabled.
    This is to suppress warnings on some platforms */
 #if defined(CONFIG_HOST_GPIO_SUPPORT) || defined(CONFIG_TARGET_PROFILE_SUPPORT)
-static A_STATUS
+static int
 wmi_simple_cmd_xtnd(struct wmi_t *wmip, WMIX_COMMAND_ID cmdid)
 {
     void *osbuf;
@@ -1223,7 +1223,7 @@ wmi_simple_cmd_xtnd(struct wmi_t *wmip, WMIX_COMMAND_ID cmdid)
 }
 #endif
 
-static A_STATUS
+static int
 wmi_ready_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_READY_EVENT *ev = (WMI_READY_EVENT *)datap;
@@ -1257,7 +1257,7 @@ iswmmparam(const A_UINT8 *frm)
 }
 
 
-static A_STATUS
+static int
 wmi_connect_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_CONNECT_EVENT *ev;
@@ -1317,7 +1317,7 @@ wmi_connect_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-static A_STATUS
+static int
 wmi_regDomain_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_REG_DOMAIN_EVENT *ev;
@@ -1332,7 +1332,7 @@ wmi_regDomain_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-static A_STATUS
+static int
 wmi_neighborReport_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_NEIGHBOR_REPORT_EVENT *ev;
@@ -1353,7 +1353,7 @@ wmi_neighborReport_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-static A_STATUS
+static int
 wmi_disconnect_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_DISCONNECT_EVENT *ev;
@@ -1378,7 +1378,7 @@ wmi_disconnect_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-static A_STATUS
+static int
 wmi_peer_node_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_PEER_NODE_EVENT *ev;
@@ -1398,7 +1398,7 @@ wmi_peer_node_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-static A_STATUS
+static int
 wmi_tkip_micerr_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_TKIP_MICERR_EVENT *ev;
@@ -1414,7 +1414,7 @@ wmi_tkip_micerr_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-static A_STATUS
+static int
 wmi_bssInfo_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     bss_t *bss = NULL;
@@ -1578,7 +1578,7 @@ wmi_bssInfo_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-static A_STATUS
+static int
 wmi_opt_frame_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     bss_t *bss;
@@ -1623,7 +1623,7 @@ wmi_opt_frame_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     /* This event indicates inactivity timeout of a fatpipe(pstream)
      * at the target
      */
-static A_STATUS
+static int
 wmi_pstream_timeout_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_PSTREAM_TIMEOUT_EVENT *ev;
@@ -1653,7 +1653,7 @@ wmi_pstream_timeout_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-static A_STATUS
+static int
 wmi_bitrate_reply_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_BIT_RATE_REPLY *reply;
@@ -1684,7 +1684,7 @@ wmi_bitrate_reply_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-static A_STATUS
+static int
 wmi_ratemask_reply_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_FIX_RATES_REPLY *reply;
@@ -1701,7 +1701,7 @@ wmi_ratemask_reply_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-static A_STATUS
+static int
 wmi_channelList_reply_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_CHANNEL_LIST_REPLY *reply;
@@ -1718,7 +1718,7 @@ wmi_channelList_reply_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-static A_STATUS
+static int
 wmi_txPwr_reply_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_TX_PWR_REPLY *reply;
@@ -1733,7 +1733,7 @@ wmi_txPwr_reply_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 
     return A_OK;
 }
-static A_STATUS
+static int
 wmi_keepalive_reply_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_GET_KEEPALIVE_CMD *reply;
@@ -1750,7 +1750,7 @@ wmi_keepalive_reply_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 }
 
 
-static A_STATUS
+static int
 wmi_dset_open_req_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMIX_DSETOPENREQ_EVENT *dsetopenreq;
@@ -1771,7 +1771,7 @@ wmi_dset_open_req_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 }
 
 #ifdef CONFIG_HOST_DSET_SUPPORT
-static A_STATUS
+static int
 wmi_dset_close_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMIX_DSETCLOSE_EVENT *dsetclose;
@@ -1787,7 +1787,7 @@ wmi_dset_close_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-static A_STATUS
+static int
 wmi_dset_data_req_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMIX_DSETDATAREQ_EVENT *dsetdatareq;
@@ -1810,16 +1810,16 @@ wmi_dset_data_req_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 }
 #endif /* CONFIG_HOST_DSET_SUPPORT */
 
-static A_STATUS
+static int
 wmi_scanComplete_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_SCAN_COMPLETE_EVENT *ev;
 
     ev = (WMI_SCAN_COMPLETE_EVENT *)datap;
-    if ((A_STATUS)ev->status == A_OK) {
+    if ((int)ev->status == A_OK) {
         wlan_refresh_inactive_nodes(&wmip->wmi_scan_table);
     }
-    A_WMI_SCANCOMPLETE_EVENT(wmip->wmi_devt, (A_STATUS) ev->status);
+    A_WMI_SCANCOMPLETE_EVENT(wmip->wmi_devt, (int) ev->status);
     is_probe_ssid = FALSE;
 
     return A_OK;
@@ -1832,7 +1832,7 @@ wmi_scanComplete_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
  * Behavior of target after wmi error event is undefined.
  * A reset is recommended.
  */
-static A_STATUS
+static int
 wmi_errorEvent_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_CMD_ERROR_EVENT *ev;
@@ -1855,7 +1855,7 @@ wmi_errorEvent_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 }
 
 
-static A_STATUS
+static int
 wmi_statsEvent_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     A_DPRINTF(DBG_WMI, (DBGFMT "Enter\n", DBGARG));
@@ -1865,7 +1865,7 @@ wmi_statsEvent_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-static A_STATUS
+static int
 wmi_rssiThresholdEvent_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_RSSI_THRESHOLD_EVENT *reply;
@@ -1970,7 +1970,7 @@ wmi_rssiThresholdEvent_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 }
 
 
-static A_STATUS
+static int
 wmi_reportErrorEvent_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_TARGET_ERROR_REPORT_EVENT *reply;
@@ -1986,7 +1986,7 @@ wmi_reportErrorEvent_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-static A_STATUS
+static int
 wmi_cac_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_CAC_EVENT *reply;
@@ -2056,7 +2056,7 @@ wmi_cac_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-static A_STATUS
+static int
 wmi_channel_change_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_CHANNEL_CHANGE_EVENT *reply;
@@ -2073,7 +2073,7 @@ wmi_channel_change_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-static A_STATUS
+static int
 wmi_hbChallengeResp_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMIX_HB_CHALLENGE_RESP_EVENT *reply;
@@ -2089,7 +2089,7 @@ wmi_hbChallengeResp_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-static A_STATUS
+static int
 wmi_roam_tbl_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_TARGET_ROAM_TBL *reply;
@@ -2105,7 +2105,7 @@ wmi_roam_tbl_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-static A_STATUS
+static int
 wmi_roam_data_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_TARGET_ROAM_DATA *reply;
@@ -2121,7 +2121,7 @@ wmi_roam_data_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-static A_STATUS
+static int
 wmi_txRetryErrEvent_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     if (len < sizeof(WMI_TX_RETRY_ERR_EVENT)) {
@@ -2134,7 +2134,7 @@ wmi_txRetryErrEvent_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-static A_STATUS
+static int
 wmi_snrThresholdEvent_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_SNR_THRESHOLD_EVENT *reply;
@@ -2227,7 +2227,7 @@ wmi_snrThresholdEvent_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-static A_STATUS
+static int
 wmi_lqThresholdEvent_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_LQ_THRESHOLD_EVENT *reply;
@@ -2245,7 +2245,7 @@ wmi_lqThresholdEvent_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-static A_STATUS
+static int
 wmi_aplistEvent_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     A_UINT16 ap_info_entry_size;
@@ -2286,7 +2286,7 @@ wmi_aplistEvent_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-static A_STATUS
+static int
 wmi_dbglog_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     A_UINT32 dropped;
@@ -2299,7 +2299,7 @@ wmi_dbglog_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 }
 
 #ifdef CONFIG_HOST_GPIO_SUPPORT
-static A_STATUS
+static int
 wmi_gpio_intr_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMIX_GPIO_INTR_EVENT *gpio_intr = (WMIX_GPIO_INTR_EVENT *)datap;
@@ -2313,7 +2313,7 @@ wmi_gpio_intr_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-static A_STATUS
+static int
 wmi_gpio_data_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMIX_GPIO_DATA_EVENT *gpio_data = (WMIX_GPIO_DATA_EVENT *)datap;
@@ -2327,7 +2327,7 @@ wmi_gpio_data_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-static A_STATUS
+static int
 wmi_gpio_ack_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     A_DPRINTF(DBG_WMI, (DBGFMT "Enter\n", DBGARG));
@@ -2342,11 +2342,11 @@ wmi_gpio_ack_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
  * Called to send a wmi command. Command specific data is already built
  * on osbuf and current osbuf->data points to it.
  */
-A_STATUS
+int
 wmi_cmd_send(struct wmi_t *wmip, void *osbuf, WMI_COMMAND_ID cmdId,
                WMI_SYNC_FLAG syncflag)
 {
-    A_STATUS status;
+    int status;
 #define IS_OPT_TX_CMD(cmdId) ((cmdId == WMI_OPT_TX_FRAME_CMDID))
     WMI_CMD_HDR         *cHdr;
     HTC_ENDPOINT_ID     eid  = wmip->wmi_endpoint_id;
@@ -2398,7 +2398,7 @@ wmi_cmd_send(struct wmi_t *wmip, void *osbuf, WMI_COMMAND_ID cmdId,
 #undef IS_OPT_TX_CMD
 }
 
-A_STATUS
+int
 wmi_cmd_send_xtnd(struct wmi_t *wmip, void *osbuf, WMIX_COMMAND_ID cmdId,
                   WMI_SYNC_FLAG syncflag)
 {
@@ -2415,7 +2415,7 @@ wmi_cmd_send_xtnd(struct wmi_t *wmip, void *osbuf, WMIX_COMMAND_ID cmdId,
     return wmi_cmd_send(wmip, osbuf, WMI_EXTENSION_CMDID, syncflag);
 }
 
-A_STATUS
+int
 wmi_connect_cmd(struct wmi_t *wmip, NETWORK_TYPE netType,
                 DOT11_AUTH_MODE dot11AuthMode, AUTH_MODE authMode,
                 CRYPTO_TYPE pairwiseCrypto, A_UINT8 pairwiseCryptoLen,
@@ -2470,7 +2470,7 @@ wmi_connect_cmd(struct wmi_t *wmip, NETWORK_TYPE netType,
     return (wmi_cmd_send(wmip, osbuf, WMI_CONNECT_CMDID, NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_reconnect_cmd(struct wmi_t *wmip, A_UINT8 *bssid, A_UINT16 channel)
 {
     void *osbuf;
@@ -2496,10 +2496,10 @@ wmi_reconnect_cmd(struct wmi_t *wmip, A_UINT8 *bssid, A_UINT16 channel)
     return (wmi_cmd_send(wmip, osbuf, WMI_RECONNECT_CMDID, NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_disconnect_cmd(struct wmi_t *wmip)
 {
-    A_STATUS status;
+    int status;
     wmip->wmi_traffic_class = 100;
 
     /* Bug fix for 24817(elevator bug) - the disconnect command does not
@@ -2509,7 +2509,7 @@ wmi_disconnect_cmd(struct wmi_t *wmip)
     return status;
 }
 
-A_STATUS
+int
 wmi_startscan_cmd(struct wmi_t *wmip, WMI_SCAN_TYPE scanType,
                   A_BOOL forceFgScan, A_BOOL isLegacy,
                   A_UINT32 homeDwellTime, A_UINT32 forceScanInterval,
@@ -2553,7 +2553,7 @@ wmi_startscan_cmd(struct wmi_t *wmip, WMI_SCAN_TYPE scanType,
     return (wmi_cmd_send(wmip, osbuf, WMI_START_SCAN_CMDID, NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_scanparams_cmd(struct wmi_t *wmip, A_UINT16 fg_start_sec,
                    A_UINT16 fg_end_sec, A_UINT16 bg_sec,
                    A_UINT16 minact_chdw_msec, A_UINT16 maxact_chdw_msec,
@@ -2588,7 +2588,7 @@ wmi_scanparams_cmd(struct wmi_t *wmip, A_UINT16 fg_start_sec,
                          NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_bssfilter_cmd(struct wmi_t *wmip, A_UINT8 filter, A_UINT32 ieMask)
 {
     void *osbuf;
@@ -2614,7 +2614,7 @@ wmi_bssfilter_cmd(struct wmi_t *wmip, A_UINT8 filter, A_UINT32 ieMask)
                          NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_probedSsid_cmd(struct wmi_t *wmip, A_UINT8 index, A_UINT8 flag,
                    A_UINT8 ssidLength, A_UCHAR *ssid)
 {
@@ -2656,7 +2656,7 @@ wmi_probedSsid_cmd(struct wmi_t *wmip, A_UINT8 index, A_UINT8 flag,
                          NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_listeninterval_cmd(struct wmi_t *wmip, A_UINT16 listenInterval, A_UINT16 listenBeacons)
 {
     void *osbuf;
@@ -2678,7 +2678,7 @@ wmi_listeninterval_cmd(struct wmi_t *wmip, A_UINT16 listenInterval, A_UINT16 lis
                          NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_bmisstime_cmd(struct wmi_t *wmip, A_UINT16 bmissTime, A_UINT16 bmissBeacons)
 {
     void *osbuf;
@@ -2700,7 +2700,7 @@ wmi_bmisstime_cmd(struct wmi_t *wmip, A_UINT16 bmissTime, A_UINT16 bmissBeacons)
                          NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_associnfo_cmd(struct wmi_t *wmip, A_UINT8 ieType,
                      A_UINT8 ieLen, A_UINT8 *ieInfo)
 {
@@ -2726,7 +2726,7 @@ wmi_associnfo_cmd(struct wmi_t *wmip, A_UINT8 ieType,
                          NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_powermode_cmd(struct wmi_t *wmip, A_UINT8 powerMode)
 {
     void *osbuf;
@@ -2748,7 +2748,7 @@ wmi_powermode_cmd(struct wmi_t *wmip, A_UINT8 powerMode)
                          NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_ibsspmcaps_cmd(struct wmi_t *wmip, A_UINT8 pmEnable, A_UINT8 ttl,
                    A_UINT16 atim_windows, A_UINT16 timeout_value)
 {
@@ -2773,7 +2773,7 @@ wmi_ibsspmcaps_cmd(struct wmi_t *wmip, A_UINT8 pmEnable, A_UINT8 ttl,
                          NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_apps_cmd(struct wmi_t *wmip, A_UINT8 psType, A_UINT32 idle_time,
                    A_UINT32 ps_period, A_UINT8 sleep_period)
 {
@@ -2798,7 +2798,7 @@ wmi_apps_cmd(struct wmi_t *wmip, A_UINT8 psType, A_UINT32 idle_time,
                          NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_pmparams_cmd(struct wmi_t *wmip, A_UINT16 idlePeriod,
                  A_UINT16 psPollNum, A_UINT16 dtimPolicy,
                  A_UINT16 tx_wakeup_policy, A_UINT16 num_tx_to_wakeup,
@@ -2827,7 +2827,7 @@ wmi_pmparams_cmd(struct wmi_t *wmip, A_UINT16 idlePeriod,
                          NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_disctimeout_cmd(struct wmi_t *wmip, A_UINT8 timeout)
 {
     void *osbuf;
@@ -2848,7 +2848,7 @@ wmi_disctimeout_cmd(struct wmi_t *wmip, A_UINT8 timeout)
                          NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_addKey_cmd(struct wmi_t *wmip, A_UINT8 keyIndex, CRYPTO_TYPE keyType,
                A_UINT8 keyUsage, A_UINT8 keyLength, A_UINT8 *keyRSC,
                A_UINT8 *keyMaterial, A_UINT8 key_op_ctrl, A_UINT8 *macAddr,
@@ -2897,7 +2897,7 @@ wmi_addKey_cmd(struct wmi_t *wmip, A_UINT8 keyIndex, CRYPTO_TYPE keyType,
     return (wmi_cmd_send(wmip, osbuf, WMI_ADD_CIPHER_KEY_CMDID, sync_flag));
 }
 
-A_STATUS
+int
 wmi_add_krk_cmd(struct wmi_t *wmip, A_UINT8 *krk)
 {
     void *osbuf;
@@ -2917,13 +2917,13 @@ wmi_add_krk_cmd(struct wmi_t *wmip, A_UINT8 *krk)
     return (wmi_cmd_send(wmip, osbuf, WMI_ADD_KRK_CMDID, NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_delete_krk_cmd(struct wmi_t *wmip)
 {
     return wmi_simple_cmd(wmip, WMI_DELETE_KRK_CMDID);
 }
 
-A_STATUS
+int
 wmi_deleteKey_cmd(struct wmi_t *wmip, A_UINT8 keyIndex)
 {
     void *osbuf;
@@ -2948,7 +2948,7 @@ wmi_deleteKey_cmd(struct wmi_t *wmip, A_UINT8 keyIndex)
                          NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_setPmkid_cmd(struct wmi_t *wmip, A_UINT8 *bssid, A_UINT8 *pmkId,
                  A_BOOL set)
 {
@@ -2983,7 +2983,7 @@ wmi_setPmkid_cmd(struct wmi_t *wmip, A_UINT8 *bssid, A_UINT8 *pmkId,
     return (wmi_cmd_send(wmip, osbuf, WMI_SET_PMKID_CMDID, NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_set_tkip_countermeasures_cmd(struct wmi_t *wmip, A_BOOL en)
 {
     void *osbuf;
@@ -3003,7 +3003,7 @@ wmi_set_tkip_countermeasures_cmd(struct wmi_t *wmip, A_BOOL en)
             NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_set_akmp_params_cmd(struct wmi_t *wmip,
                         WMI_SET_AKMP_PARAMS_CMD *akmpParams)
 {
@@ -3023,7 +3023,7 @@ wmi_set_akmp_params_cmd(struct wmi_t *wmip,
             NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_set_pmkid_list_cmd(struct wmi_t *wmip,
                        WMI_SET_PMKID_LIST_CMD *pmkInfo)
 {
@@ -3053,13 +3053,13 @@ wmi_set_pmkid_list_cmd(struct wmi_t *wmip,
             NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_get_pmkid_list_cmd(struct wmi_t *wmip)
 {
     return wmi_simple_cmd(wmip, WMI_GET_PMKID_LIST_CMDID);
 }
 
-A_STATUS
+int
 wmi_dataSync_send(struct wmi_t *wmip, void *osbuf, HTC_ENDPOINT_ID eid)
 {
     WMI_DATA_HDR     *dtHdr;
@@ -3085,14 +3085,14 @@ typedef struct _WMI_DATA_SYNC_BUFS {
     void               *osbuf;
 }WMI_DATA_SYNC_BUFS;
 
-static A_STATUS
+static int
 wmi_sync_point(struct wmi_t *wmip)
 {
     void *cmd_osbuf;
     WMI_SYNC_CMD *cmd;
     WMI_DATA_SYNC_BUFS dataSyncBufs[WMM_NUM_AC];
     A_UINT8 i,numPriStreams=0;
-    A_STATUS status = A_OK;
+    int status = A_OK;
 
     A_DPRINTF(DBG_WMI, (DBGFMT "Enter\n", DBGARG));
 
@@ -3195,7 +3195,7 @@ wmi_sync_point(struct wmi_t *wmip)
     return (status);
 }
 
-A_STATUS
+int
 wmi_create_pstream_cmd(struct wmi_t *wmip, WMI_CREATE_PSTREAM_CMD *params)
 {
     void *osbuf;
@@ -3291,12 +3291,12 @@ wmi_create_pstream_cmd(struct wmi_t *wmip, WMI_CREATE_PSTREAM_CMD *params)
                          NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_delete_pstream_cmd(struct wmi_t *wmip, A_UINT8 trafficClass, A_UINT8 tsid)
 {
     void *osbuf;
     WMI_DELETE_PSTREAM_CMD *cmd;
-    A_STATUS status;
+    int status;
     A_UINT16 activeTsids=0;
 
     /* validate the parameters */
@@ -3355,7 +3355,7 @@ wmi_delete_pstream_cmd(struct wmi_t *wmip, A_UINT8 trafficClass, A_UINT8 tsid)
     return status;
 }
 
-A_STATUS
+int
 wmi_set_framerate_cmd(struct wmi_t *wmip, A_UINT8 bEnable, A_UINT8 type, A_UINT8 subType, A_UINT16 rateMask)
 {
     void *osbuf;
@@ -3394,7 +3394,7 @@ wmi_set_framerate_cmd(struct wmi_t *wmip, A_UINT8 bEnable, A_UINT8 type, A_UINT8
  * used to set the bit rate.  rate is in Kbps.  If rate == -1
  * then auto selection is used.
  */
-A_STATUS
+int
 wmi_set_bitrate_cmd(struct wmi_t *wmip, A_INT32 dataRate, A_INT32 mgmtRate, A_INT32 ctlRate)
 {
     void *osbuf;
@@ -3444,7 +3444,7 @@ wmi_set_bitrate_cmd(struct wmi_t *wmip, A_INT32 dataRate, A_INT32 mgmtRate, A_IN
     return (wmi_cmd_send(wmip, osbuf, WMI_SET_BITRATE_CMDID, NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_get_bitrate_cmd(struct wmi_t *wmip)
 {
     return wmi_simple_cmd(wmip, WMI_GET_BITRATE_CMDID);
@@ -3532,7 +3532,7 @@ wmi_validate_bitrate(struct wmi_t *wmip, A_INT32 rate, A_INT8 *rate_idx)
     return A_OK;
 }
 
-A_STATUS
+int
 wmi_set_fixrates_cmd(struct wmi_t *wmip, A_UINT32 fixRatesMask)
 {
     void *osbuf;
@@ -3572,13 +3572,13 @@ wmi_set_fixrates_cmd(struct wmi_t *wmip, A_UINT32 fixRatesMask)
     return (wmi_cmd_send(wmip, osbuf, WMI_SET_FIXRATES_CMDID, NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_get_ratemask_cmd(struct wmi_t *wmip)
 {
     return wmi_simple_cmd(wmip, WMI_GET_FIXRATES_CMDID);
 }
 
-A_STATUS
+int
 wmi_get_channelList_cmd(struct wmi_t *wmip)
 {
     return wmi_simple_cmd(wmip, WMI_GET_CHANNEL_LIST_CMDID);
@@ -3594,7 +3594,7 @@ wmi_get_channelList_cmd(struct wmi_t *wmip)
  * should limit its operation to.  It should be NULL if numChan == 0.  Size of
  * array should correspond to numChan entries.
  */
-A_STATUS
+int
 wmi_set_channelParams_cmd(struct wmi_t *wmip, A_UINT8 scanParam,
                           WMI_PHY_MODE mode, A_INT8 numChan,
                           A_UINT16 *channelList)
@@ -3681,7 +3681,7 @@ wmi_cache_configure_rssithreshold(struct wmi_t *wmip, WMI_RSSI_THRESHOLD_PARAMS_
 }
 }
 
-A_STATUS
+int
 wmi_set_rssi_threshold_params(struct wmi_t *wmip,
                               WMI_RSSI_THRESHOLD_PARAMS_CMD *rssiCmd)
 {
@@ -3706,7 +3706,7 @@ wmi_set_rssi_threshold_params(struct wmi_t *wmip,
     return (wmi_send_rssi_threshold_params(wmip, rssiCmd));
 }
 
-A_STATUS
+int
 wmi_set_ip_cmd(struct wmi_t *wmip, WMI_SET_IP_CMD *ipCmd)
 {
     void    *osbuf;
@@ -3731,7 +3731,7 @@ wmi_set_ip_cmd(struct wmi_t *wmip, WMI_SET_IP_CMD *ipCmd)
                             NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_set_host_sleep_mode_cmd(struct wmi_t *wmip,
                               WMI_SET_HOST_SLEEP_MODE_CMD *hostModeCmd)
 {
@@ -3793,7 +3793,7 @@ wmi_set_host_sleep_mode_cmd(struct wmi_t *wmip,
                             NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_set_wow_mode_cmd(struct wmi_t *wmip,
                               WMI_SET_WOW_MODE_CMD *wowModeCmd)
 {
@@ -3819,7 +3819,7 @@ wmi_set_wow_mode_cmd(struct wmi_t *wmip,
 
 }
 
-A_STATUS
+int
 wmi_get_wow_list_cmd(struct wmi_t *wmip,
                               WMI_GET_WOW_LIST_CMD *wowListCmd)
 {
@@ -3845,7 +3845,7 @@ wmi_get_wow_list_cmd(struct wmi_t *wmip,
 
 }
 
-static A_STATUS
+static int
 wmi_get_wow_list_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_GET_WOW_LIST_REPLY *reply;
@@ -3861,7 +3861,7 @@ wmi_get_wow_list_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-A_STATUS wmi_add_wow_pattern_cmd(struct wmi_t *wmip,
+int wmi_add_wow_pattern_cmd(struct wmi_t *wmip,
                                  WMI_ADD_WOW_PATTERN_CMD *addWowCmd,
                                  A_UINT8* pattern, A_UINT8* mask,
                                  A_UINT8 pattern_size)
@@ -3896,7 +3896,7 @@ A_STATUS wmi_add_wow_pattern_cmd(struct wmi_t *wmip,
                             NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_del_wow_pattern_cmd(struct wmi_t *wmip,
                               WMI_DEL_WOW_PATTERN_CMD *delWowCmd)
 {
@@ -3967,7 +3967,7 @@ wmi_cache_configure_snrthreshold(struct wmi_t *wmip, WMI_SNR_THRESHOLD_PARAMS_CM
     }
 
 }
-A_STATUS
+int
 wmi_set_snr_threshold_params(struct wmi_t *wmip,
                              WMI_SNR_THRESHOLD_PARAMS_CMD *snrCmd)
 {
@@ -3984,7 +3984,7 @@ wmi_set_snr_threshold_params(struct wmi_t *wmip,
     return (wmi_send_snr_threshold_params(wmip, snrCmd));
 }
 
-A_STATUS
+int
 wmi_clr_rssi_snr(struct wmi_t *wmip)
 {
     void    *osbuf;
@@ -3998,7 +3998,7 @@ wmi_clr_rssi_snr(struct wmi_t *wmip)
                             NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_set_lq_threshold_params(struct wmi_t *wmip,
                              WMI_LQ_THRESHOLD_PARAMS_CMD *lqCmd)
 {
@@ -4033,7 +4033,7 @@ wmi_set_lq_threshold_params(struct wmi_t *wmip,
                             NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_set_error_report_bitmask(struct wmi_t *wmip, A_UINT32 mask)
 {
     void    *osbuf;
@@ -4058,7 +4058,7 @@ wmi_set_error_report_bitmask(struct wmi_t *wmip, A_UINT32 mask)
                             NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_get_challenge_resp_cmd(struct wmi_t *wmip, A_UINT32 cookie, A_UINT32 source)
 {
     void *osbuf;
@@ -4079,7 +4079,7 @@ wmi_get_challenge_resp_cmd(struct wmi_t *wmip, A_UINT32 cookie, A_UINT32 source)
                               NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_config_debug_module_cmd(struct wmi_t *wmip, A_UINT16 mmask,
                             A_UINT16 tsr, A_BOOL rep, A_UINT16 size,
                             A_UINT32 valid)
@@ -4105,13 +4105,13 @@ wmi_config_debug_module_cmd(struct wmi_t *wmip, A_UINT16 mmask,
                               NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_get_stats_cmd(struct wmi_t *wmip)
 {
     return wmi_simple_cmd(wmip, WMI_GET_STATISTICS_CMDID);
 }
 
-A_STATUS
+int
 wmi_addBadAp_cmd(struct wmi_t *wmip, A_UINT8 apIndex, A_UINT8 *bssid)
 {
     void *osbuf;
@@ -4135,7 +4135,7 @@ wmi_addBadAp_cmd(struct wmi_t *wmip, A_UINT8 apIndex, A_UINT8 *bssid)
     return (wmi_cmd_send(wmip, osbuf, WMI_ADD_BAD_AP_CMDID, SYNC_BEFORE_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_deleteBadAp_cmd(struct wmi_t *wmip, A_UINT8 apIndex)
 {
     void *osbuf;
@@ -4159,13 +4159,13 @@ wmi_deleteBadAp_cmd(struct wmi_t *wmip, A_UINT8 apIndex)
                          NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_abort_scan_cmd(struct wmi_t *wmip)
 {
     return wmi_simple_cmd(wmip, WMI_ABORT_SCAN_CMDID);
 }
 
-A_STATUS
+int
 wmi_set_txPwr_cmd(struct wmi_t *wmip, A_UINT8 dbM)
 {
     void *osbuf;
@@ -4184,7 +4184,7 @@ wmi_set_txPwr_cmd(struct wmi_t *wmip, A_UINT8 dbM)
     return (wmi_cmd_send(wmip, osbuf, WMI_SET_TX_PWR_CMDID, NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_get_txPwr_cmd(struct wmi_t *wmip)
 {
     return wmi_simple_cmd(wmip, WMI_GET_TX_PWR_CMDID);
@@ -4202,13 +4202,13 @@ wmi_get_mapped_qos_queue(struct wmi_t *wmip, A_UINT8 trafficClass)
     return activeTsids;
 }
 
-A_STATUS
+int
 wmi_get_roam_tbl_cmd(struct wmi_t *wmip)
 {
     return wmi_simple_cmd(wmip, WMI_GET_ROAM_TBL_CMDID);
 }
 
-A_STATUS
+int
 wmi_get_roam_data_cmd(struct wmi_t *wmip, A_UINT8 roamDataType)
 {
     void *osbuf;
@@ -4229,7 +4229,7 @@ wmi_get_roam_data_cmd(struct wmi_t *wmip, A_UINT8 roamDataType)
                          NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_set_roam_ctrl_cmd(struct wmi_t *wmip, WMI_SET_ROAM_CTRL_CMD *p,
                       A_UINT8 size)
 {
@@ -4252,7 +4252,7 @@ wmi_set_roam_ctrl_cmd(struct wmi_t *wmip, WMI_SET_ROAM_CTRL_CMD *p,
                          NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_set_powersave_timers_cmd(struct wmi_t *wmip,
                             WMI_POWERSAVE_TIMERS_POLICY_CMD *pCmd,
                             A_UINT8 size)
@@ -4286,7 +4286,7 @@ wmi_set_powersave_timers_cmd(struct wmi_t *wmip,
 
 #ifdef CONFIG_HOST_GPIO_SUPPORT
 /* Send a command to Target to change GPIO output pins. */
-A_STATUS
+int
 wmi_gpio_output_set(struct wmi_t *wmip,
                     A_UINT32 set_mask,
                     A_UINT32 clear_mask,
@@ -4320,7 +4320,7 @@ wmi_gpio_output_set(struct wmi_t *wmip,
 }
 
 /* Send a command to the Target requesting state of the GPIO input pins */
-A_STATUS
+int
 wmi_gpio_input_get(struct wmi_t *wmip)
 {
     A_DPRINTF(DBG_WMI, (DBGFMT "Enter\n", DBGARG));
@@ -4329,7 +4329,7 @@ wmi_gpio_input_get(struct wmi_t *wmip)
 }
 
 /* Send a command to the Target that changes the value of a GPIO register. */
-A_STATUS
+int
 wmi_gpio_register_set(struct wmi_t *wmip,
                       A_UINT32 gpioreg_id,
                       A_UINT32 value)
@@ -4358,7 +4358,7 @@ wmi_gpio_register_set(struct wmi_t *wmip,
 }
 
 /* Send a command to the Target to fetch the value of a GPIO register. */
-A_STATUS
+int
 wmi_gpio_register_get(struct wmi_t *wmip,
                       A_UINT32 gpioreg_id)
 {
@@ -4384,7 +4384,7 @@ wmi_gpio_register_get(struct wmi_t *wmip,
 }
 
 /* Send a command to the Target acknowledging some GPIO interrupts. */
-A_STATUS
+int
 wmi_gpio_intr_ack(struct wmi_t *wmip,
                   A_UINT32 ack_mask)
 {
@@ -4410,7 +4410,7 @@ wmi_gpio_intr_ack(struct wmi_t *wmip,
 }
 #endif /* CONFIG_HOST_GPIO_SUPPORT */
 
-A_STATUS
+int
 wmi_set_access_params_cmd(struct wmi_t *wmip, A_UINT8 ac,  A_UINT16 txop, A_UINT8 eCWmin,
                           A_UINT8 eCWmax, A_UINT8 aifsn)
 {
@@ -4441,7 +4441,7 @@ wmi_set_access_params_cmd(struct wmi_t *wmip, A_UINT8 ac,  A_UINT16 txop, A_UINT
                          NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_set_retry_limits_cmd(struct wmi_t *wmip, A_UINT8 frameType,
                          A_UINT8 trafficClass, A_UINT8 maxRetries,
                          A_UINT8 enableNotify)
@@ -4488,7 +4488,7 @@ wmi_get_current_bssid(struct wmi_t *wmip, A_UINT8 *bssid)
     }
 }
 
-A_STATUS
+int
 wmi_set_opt_mode_cmd(struct wmi_t *wmip, A_UINT8 optMode)
 {
     void *osbuf;
@@ -4509,7 +4509,7 @@ wmi_set_opt_mode_cmd(struct wmi_t *wmip, A_UINT8 optMode)
                          SYNC_BOTH_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_opt_tx_frame_cmd(struct wmi_t *wmip,
                       A_UINT8 frmType,
                       A_UINT8 *dstMacAddr,
@@ -4540,7 +4540,7 @@ wmi_opt_tx_frame_cmd(struct wmi_t *wmip,
                          NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_set_adhoc_bconIntvl_cmd(struct wmi_t *wmip, A_UINT16 intvl)
 {
     void *osbuf;
@@ -4562,7 +4562,7 @@ wmi_set_adhoc_bconIntvl_cmd(struct wmi_t *wmip, A_UINT16 intvl)
 }
 
 
-A_STATUS
+int
 wmi_set_voice_pkt_size_cmd(struct wmi_t *wmip, A_UINT16 voicePktSize)
 {
     void *osbuf;
@@ -4584,7 +4584,7 @@ wmi_set_voice_pkt_size_cmd(struct wmi_t *wmip, A_UINT16 voicePktSize)
 }
 
 
-A_STATUS
+int
 wmi_set_max_sp_len_cmd(struct wmi_t *wmip, A_UINT8 maxSPLen)
 {
     void *osbuf;
@@ -4649,10 +4649,10 @@ wmi_get_power_mode_cmd(struct wmi_t *wmip)
     return wmip->wmi_powerMode;
 }
 
-A_STATUS
+int
 wmi_verify_tspec_params(WMI_CREATE_PSTREAM_CMD *pCmd, A_BOOL tspecCompliance)
 {
-    A_STATUS ret = A_OK;
+    int ret = A_OK;
 
 #define TSPEC_SUSPENSION_INTERVAL_ATHEROS_DEF (~0)
 #define TSPEC_SERVICE_START_TIME_ATHEROS_DEF  0
@@ -4682,7 +4682,7 @@ wmi_verify_tspec_params(WMI_CREATE_PSTREAM_CMD *pCmd, A_BOOL tspecCompliance)
 }
 
 #ifdef CONFIG_HOST_TCMD_SUPPORT
-static A_STATUS
+static int
 wmi_tcmd_test_report_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
 
@@ -4695,7 +4695,7 @@ wmi_tcmd_test_report_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 
 #endif /* CONFIG_HOST_TCMD_SUPPORT*/
 
-A_STATUS
+int
 wmi_set_authmode_cmd(struct wmi_t *wmip, A_UINT8 mode)
 {
     void *osbuf;
@@ -4716,7 +4716,7 @@ wmi_set_authmode_cmd(struct wmi_t *wmip, A_UINT8 mode)
             NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_set_reassocmode_cmd(struct wmi_t *wmip, A_UINT8 mode)
 {
     void *osbuf;
@@ -4737,7 +4737,7 @@ wmi_set_reassocmode_cmd(struct wmi_t *wmip, A_UINT8 mode)
             NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_set_lpreamble_cmd(struct wmi_t *wmip, A_UINT8 status, A_UINT8 preamblePolicy)
 {
     void *osbuf;
@@ -4759,7 +4759,7 @@ wmi_set_lpreamble_cmd(struct wmi_t *wmip, A_UINT8 status, A_UINT8 preamblePolicy
             NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_set_rts_cmd(struct wmi_t *wmip, A_UINT16 threshold)
 {
     void *osbuf;
@@ -4780,7 +4780,7 @@ wmi_set_rts_cmd(struct wmi_t *wmip, A_UINT16 threshold)
             NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_set_wmm_cmd(struct wmi_t *wmip, WMI_WMM_STATUS status)
 {
     void *osbuf;
@@ -4802,7 +4802,7 @@ wmi_set_wmm_cmd(struct wmi_t *wmip, WMI_WMM_STATUS status)
 
 }
 
-A_STATUS
+int
 wmi_set_qos_supp_cmd(struct wmi_t *wmip, A_UINT8 status)
 {
     void *osbuf;
@@ -4823,7 +4823,7 @@ wmi_set_qos_supp_cmd(struct wmi_t *wmip, A_UINT8 status)
 }
 
 
-A_STATUS
+int
 wmi_set_wmm_txop(struct wmi_t *wmip, WMI_TXOP_CFG cfg)
 {
     void *osbuf;
@@ -4848,7 +4848,7 @@ wmi_set_wmm_txop(struct wmi_t *wmip, WMI_TXOP_CFG cfg)
 
 }
 
-A_STATUS
+int
 wmi_set_country(struct wmi_t *wmip, A_UCHAR *countryCode)
 {
     void *osbuf;
@@ -4874,7 +4874,7 @@ wmi_set_country(struct wmi_t *wmip, A_UCHAR *countryCode)
    This would be beneficial for customers like Qualcomm, who might
    have different test command requirements from differnt manufacturers
  */
-A_STATUS
+int
 wmi_test_cmd(struct wmi_t *wmip, A_UINT8 *buf, A_UINT32  len)
 {
     void *osbuf;
@@ -4897,7 +4897,7 @@ wmi_test_cmd(struct wmi_t *wmip, A_UINT8 *buf, A_UINT32  len)
 
 #endif
 
-A_STATUS
+int
 wmi_set_bt_status_cmd(struct wmi_t *wmip, A_UINT8 streamType, A_UINT8 status)
 {
     void *osbuf;
@@ -4921,7 +4921,7 @@ wmi_set_bt_status_cmd(struct wmi_t *wmip, A_UINT8 streamType, A_UINT8 status)
             NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_set_bt_params_cmd(struct wmi_t *wmip, WMI_SET_BT_PARAMS_CMD* cmd)
 {
     void *osbuf;
@@ -4983,7 +4983,7 @@ wmi_set_bt_params_cmd(struct wmi_t *wmip, WMI_SET_BT_PARAMS_CMD* cmd)
             NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_set_btcoex_fe_ant_cmd(struct wmi_t *wmip, WMI_SET_BTCOEX_FE_ANT_CMD * cmd)
 {
 	void *osbuf;
@@ -5003,7 +5003,7 @@ wmi_set_btcoex_fe_ant_cmd(struct wmi_t *wmip, WMI_SET_BTCOEX_FE_ANT_CMD * cmd)
 }
 
 
-A_STATUS
+int
 wmi_set_btcoex_colocated_bt_dev_cmd(struct wmi_t *wmip,
 						WMI_SET_BTCOEX_COLOCATED_BT_DEV_CMD * cmd)
 {
@@ -5024,7 +5024,7 @@ wmi_set_btcoex_colocated_bt_dev_cmd(struct wmi_t *wmip,
 
 }
 
-A_STATUS
+int
 wmi_set_btcoex_btinquiry_page_config_cmd(struct wmi_t *wmip,
 						WMI_SET_BTCOEX_BTINQUIRY_PAGE_CONFIG_CMD* cmd)
 {
@@ -5044,7 +5044,7 @@ wmi_set_btcoex_btinquiry_page_config_cmd(struct wmi_t *wmip,
 
 }
 
-A_STATUS
+int
 wmi_set_btcoex_sco_config_cmd(struct wmi_t *wmip,
 						WMI_SET_BTCOEX_SCO_CONFIG_CMD * cmd)
 {
@@ -5064,7 +5064,7 @@ wmi_set_btcoex_sco_config_cmd(struct wmi_t *wmip,
 
 }
 
-A_STATUS
+int
 wmi_set_btcoex_a2dp_config_cmd(struct wmi_t *wmip,
 						WMI_SET_BTCOEX_A2DP_CONFIG_CMD * cmd)
 {
@@ -5084,7 +5084,7 @@ wmi_set_btcoex_a2dp_config_cmd(struct wmi_t *wmip,
 
 }
 
-A_STATUS
+int
 wmi_set_btcoex_aclcoex_config_cmd(struct wmi_t *wmip,
 						WMI_SET_BTCOEX_ACLCOEX_CONFIG_CMD * cmd)
 {
@@ -5104,7 +5104,7 @@ wmi_set_btcoex_aclcoex_config_cmd(struct wmi_t *wmip,
 
 }
 
-A_STATUS
+int
 wmi_set_btcoex_debug_cmd(struct wmi_t *wmip, WMI_SET_BTCOEX_DEBUG_CMD * cmd)
 {
 	void *osbuf;
@@ -5123,7 +5123,7 @@ wmi_set_btcoex_debug_cmd(struct wmi_t *wmip, WMI_SET_BTCOEX_DEBUG_CMD * cmd)
 
 }
 
-A_STATUS
+int
 wmi_set_btcoex_bt_operating_status_cmd(struct wmi_t * wmip,
 					WMI_SET_BTCOEX_BT_OPERATING_STATUS_CMD * cmd)
 {
@@ -5143,7 +5143,7 @@ wmi_set_btcoex_bt_operating_status_cmd(struct wmi_t * wmip,
 
 }
 
-A_STATUS
+int
 wmi_get_btcoex_config_cmd(struct wmi_t * wmip, WMI_GET_BTCOEX_CONFIG_CMD * cmd)
 {
 	void *osbuf;
@@ -5162,7 +5162,7 @@ wmi_get_btcoex_config_cmd(struct wmi_t * wmip, WMI_GET_BTCOEX_CONFIG_CMD * cmd)
 
 }
 
-A_STATUS
+int
 wmi_get_btcoex_stats_cmd(struct wmi_t *wmip)
 {
 
@@ -5170,7 +5170,7 @@ wmi_get_btcoex_stats_cmd(struct wmi_t *wmip)
 
 }
 
-A_STATUS
+int
 wmi_get_keepalive_configured(struct wmi_t *wmip)
 {
     void *osbuf;
@@ -5192,7 +5192,7 @@ wmi_get_keepalive_cmd(struct wmi_t *wmip)
     return wmip->wmi_keepaliveInterval;
 }
 
-A_STATUS
+int
 wmi_set_keepalive_cmd(struct wmi_t *wmip, A_UINT8 keepaliveInterval)
 {
     void *osbuf;
@@ -5214,7 +5214,7 @@ wmi_set_keepalive_cmd(struct wmi_t *wmip, A_UINT8 keepaliveInterval)
                          NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_set_params_cmd(struct wmi_t *wmip, A_UINT32 opcode, A_UINT32 length, A_CHAR* buffer)
 {
     void *osbuf;
@@ -5238,7 +5238,7 @@ wmi_set_params_cmd(struct wmi_t *wmip, A_UINT32 opcode, A_UINT32 length, A_CHAR*
 }
 
 
-A_STATUS
+int
 wmi_set_mcast_filter_cmd(struct wmi_t *wmip, A_UINT8 dot1, A_UINT8 dot2, A_UINT8 dot3, A_UINT8 dot4)
 {
     void *osbuf;
@@ -5264,7 +5264,7 @@ wmi_set_mcast_filter_cmd(struct wmi_t *wmip, A_UINT8 dot1, A_UINT8 dot2, A_UINT8
 }
 
 
-A_STATUS
+int
 wmi_del_mcast_filter_cmd(struct wmi_t *wmip, A_UINT8 dot1, A_UINT8 dot2, A_UINT8 dot3, A_UINT8 dot4)
 {
     void *osbuf;
@@ -5289,7 +5289,7 @@ wmi_del_mcast_filter_cmd(struct wmi_t *wmip, A_UINT8 dot1, A_UINT8 dot2, A_UINT8
                          NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_mcast_filter_cmd(struct wmi_t *wmip, A_UINT8 enable)
 {
     void *osbuf;
@@ -5309,7 +5309,7 @@ wmi_mcast_filter_cmd(struct wmi_t *wmip, A_UINT8 enable)
                          NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_set_appie_cmd(struct wmi_t *wmip, A_UINT8 mgmtFrmType, A_UINT8 ieLen,
                   A_UINT8 *ieInfo)
 {
@@ -5335,7 +5335,7 @@ wmi_set_appie_cmd(struct wmi_t *wmip, A_UINT8 mgmtFrmType, A_UINT8 ieLen,
     return (wmi_cmd_send(wmip, osbuf, WMI_SET_APPIE_CMDID, NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_set_halparam_cmd(struct wmi_t *wmip, A_UINT8 *cmd, A_UINT16 dataLen)
 {
     void *osbuf;
@@ -5426,7 +5426,7 @@ wmi_free_node(struct wmi_t *wmip, const A_UINT8 *macaddr)
     return;
 }
 
-A_STATUS
+int
 wmi_dset_open_reply(struct wmi_t *wmip,
                     A_UINT32 status,
                     A_UINT32 access_cookie,
@@ -5461,7 +5461,7 @@ wmi_dset_open_reply(struct wmi_t *wmip,
                              NO_SYNC_WMIFLAG));
 }
 
-static A_STATUS
+static int
 wmi_get_pmkid_list_event_rx(struct wmi_t *wmip, A_UINT8 *datap, A_UINT32 len)
 {
     WMI_PMKID_LIST_REPLY *reply;
@@ -5484,7 +5484,7 @@ wmi_get_pmkid_list_event_rx(struct wmi_t *wmip, A_UINT8 *datap, A_UINT32 len)
 }
 
 
-static A_STATUS
+static int
 wmi_set_params_event_rx(struct wmi_t *wmip, A_UINT8 *datap, A_UINT32 len)
 {
     WMI_SET_PARAMS_REPLY *reply;
@@ -5508,7 +5508,7 @@ wmi_set_params_event_rx(struct wmi_t *wmip, A_UINT8 *datap, A_UINT32 len)
 
 
 
-static A_STATUS
+static int
 wmi_acm_reject_event_rx(struct wmi_t *wmip, A_UINT8 *datap, A_UINT32 len)
 {
     WMI_ACM_REJECT_EVENT *ev;
@@ -5521,7 +5521,7 @@ wmi_acm_reject_event_rx(struct wmi_t *wmip, A_UINT8 *datap, A_UINT32 len)
 
 
 #ifdef CONFIG_HOST_DSET_SUPPORT
-A_STATUS
+int
 wmi_dset_data_reply(struct wmi_t *wmip,
                     A_UINT32 status,
                     A_UINT8 *user_buf,
@@ -5568,7 +5568,7 @@ wmi_dset_data_reply(struct wmi_t *wmip,
 }
 #endif /* CONFIG_HOST_DSET_SUPPORT */
 
-A_STATUS
+int
 wmi_set_wsc_status_cmd(struct wmi_t *wmip, A_UINT32 status)
 {
     void *osbuf;
@@ -5592,7 +5592,7 @@ wmi_set_wsc_status_cmd(struct wmi_t *wmip, A_UINT32 status)
 }
 
 #if defined(CONFIG_TARGET_PROFILE_SUPPORT)
-A_STATUS
+int
 wmi_prof_cfg_cmd(struct wmi_t *wmip,
                  A_UINT32 period,
                  A_UINT32 nbins)
@@ -5615,7 +5615,7 @@ wmi_prof_cfg_cmd(struct wmi_t *wmip,
     return (wmi_cmd_send_xtnd(wmip, osbuf, WMIX_PROF_CFG_CMDID, NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_prof_addr_set_cmd(struct wmi_t *wmip, A_UINT32 addr)
 {
     void *osbuf;
@@ -5635,26 +5635,26 @@ wmi_prof_addr_set_cmd(struct wmi_t *wmip, A_UINT32 addr)
     return (wmi_cmd_send_xtnd(wmip, osbuf, WMIX_PROF_ADDR_SET_CMDID, NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_prof_start_cmd(struct wmi_t *wmip)
 {
     return wmi_simple_cmd_xtnd(wmip, WMIX_PROF_START_CMDID);
 }
 
-A_STATUS
+int
 wmi_prof_stop_cmd(struct wmi_t *wmip)
 {
     return wmi_simple_cmd_xtnd(wmip, WMIX_PROF_STOP_CMDID);
 }
 
-A_STATUS
+int
 wmi_prof_count_get_cmd(struct wmi_t *wmip)
 {
     return wmi_simple_cmd_xtnd(wmip, WMIX_PROF_COUNT_GET_CMDID);
 }
 
 /* Called to handle WMIX_PROF_CONT_EVENTID */
-static A_STATUS
+static int
 wmi_prof_count_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMIX_PROF_COUNT_EVENT *prof_data = (WMIX_PROF_COUNT_EVENT *)datap;
@@ -5923,7 +5923,7 @@ ar6000_get_lower_threshold(A_INT16 rssi, SQ_THRESHOLD_PARAMS *sq_thresh,
 
     return threshold;
 }
-static A_STATUS
+static int
 wmi_send_rssi_threshold_params(struct wmi_t *wmip,
                               WMI_RSSI_THRESHOLD_PARAMS_CMD *rssiCmd)
 {
@@ -5947,7 +5947,7 @@ wmi_send_rssi_threshold_params(struct wmi_t *wmip,
     return (wmi_cmd_send(wmip, osbuf, WMI_RSSI_THRESHOLD_PARAMS_CMDID,
                             NO_SYNC_WMIFLAG));
 }
-static A_STATUS
+static int
 wmi_send_snr_threshold_params(struct wmi_t *wmip,
                              WMI_SNR_THRESHOLD_PARAMS_CMD *snrCmd)
 {
@@ -5971,7 +5971,7 @@ wmi_send_snr_threshold_params(struct wmi_t *wmip,
                             NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_set_target_event_report_cmd(struct wmi_t *wmip, WMI_SET_TARGET_EVENT_REPORT_CMD* cmd)
 {
     void *osbuf;
@@ -5998,14 +5998,14 @@ bss_t *wmi_rm_current_bss (struct wmi_t *wmip, A_UINT8 *id)
     return wlan_node_remove (&wmip->wmi_scan_table, id);
 }
 
-A_STATUS wmi_add_current_bss (struct wmi_t *wmip, A_UINT8 *id, bss_t *bss)
+int wmi_add_current_bss (struct wmi_t *wmip, A_UINT8 *id, bss_t *bss)
 {
     wlan_setup_node (&wmip->wmi_scan_table, bss, id);
     return A_OK;
 }
 
 #ifdef ATH_AR6K_11N_SUPPORT
-static A_STATUS
+static int
 wmi_addba_req_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_ADDBA_REQ_EVENT *cmd = (WMI_ADDBA_REQ_EVENT *)datap;
@@ -6016,7 +6016,7 @@ wmi_addba_req_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 }
 
 
-static A_STATUS
+static int
 wmi_addba_resp_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_ADDBA_RESP_EVENT *cmd = (WMI_ADDBA_RESP_EVENT *)datap;
@@ -6026,7 +6026,7 @@ wmi_addba_resp_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-static A_STATUS
+static int
 wmi_delba_req_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_DELBA_EVENT *cmd = (WMI_DELBA_EVENT *)datap;
@@ -6036,7 +6036,7 @@ wmi_delba_req_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-A_STATUS
+int
 wmi_btcoex_config_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
 	A_DPRINTF(DBG_WMI, (DBGFMT "Enter\n", DBGARG));
@@ -6047,7 +6047,7 @@ wmi_btcoex_config_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 }
 
 
-A_STATUS
+int
 wmi_btcoex_stats_event_rx(struct wmi_t * wmip,A_UINT8 * datap,int len)
 {
 	A_DPRINTF(DBG_WMI, (DBGFMT "Enter\n", DBGARG));
@@ -6059,7 +6059,7 @@ wmi_btcoex_stats_event_rx(struct wmi_t * wmip,A_UINT8 * datap,int len)
 }
 #endif
 
-static A_STATUS
+static int
 wmi_hci_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_HCI_EVENT *cmd = (WMI_HCI_EVENT *)datap;
@@ -6083,7 +6083,7 @@ wmi_hci_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
  * commit cmd will not be sent to target. Without calling this IOCTL
  * the changes will not take effect.
  */
-A_STATUS
+int
 wmi_ap_profile_commit(struct wmi_t *wmip, WMI_CONNECT_CMD *p)
 {
     void *osbuf;
@@ -6109,7 +6109,7 @@ wmi_ap_profile_commit(struct wmi_t *wmip, WMI_CONNECT_CMD *p)
  * This command will be used to enable/disable hidden ssid functioanlity of
  * beacon. If it is enabled, ssid will be NULL in beacon.
  */
-A_STATUS
+int
 wmi_ap_set_hidden_ssid(struct wmi_t *wmip, A_UINT8 hidden_ssid)
 {
     void *osbuf;
@@ -6138,7 +6138,7 @@ wmi_ap_set_hidden_ssid(struct wmi_t *wmip, A_UINT8 hidden_ssid)
  * is max num of STA supported by AP). Value was already validated
  * in ioctl.c
  */
-A_STATUS
+int
 wmi_ap_set_num_sta(struct wmi_t *wmip, A_UINT8 num_sta)
 {
     void *osbuf;
@@ -6166,7 +6166,7 @@ wmi_ap_set_num_sta(struct wmi_t *wmip, A_UINT8 num_sta)
  * be allowed to connect with this AP. When this list is empty
  * firware will allow all STAs till the count reaches AP_MAX_NUM_STA.
  */
-A_STATUS
+int
 wmi_ap_acl_mac_list(struct wmi_t *wmip, WMI_AP_ACL_MAC_CMD *acl)
 {
     void *osbuf;
@@ -6192,7 +6192,7 @@ wmi_ap_acl_mac_list(struct wmi_t *wmip, WMI_AP_ACL_MAC_CMD *acl)
  * be allowed to connect with this AP. When this list is empty
  * firware will allow all STAs till the count reaches AP_MAX_NUM_STA.
  */
-A_STATUS
+int
 wmi_ap_set_mlme(struct wmi_t *wmip, A_UINT8 cmd, A_UINT8 *mac, A_UINT16 reason)
 {
     void *osbuf;
@@ -6214,7 +6214,7 @@ wmi_ap_set_mlme(struct wmi_t *wmip, A_UINT8 cmd, A_UINT8 *mac, A_UINT16 reason)
     return (wmi_cmd_send(wmip, osbuf, WMI_AP_SET_MLME_CMDID, NO_SYNC_WMIFLAG));
 }
 
-static A_STATUS
+static int
 wmi_pspoll_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 {
     WMI_PSPOLL_EVENT *ev;
@@ -6228,7 +6228,7 @@ wmi_pspoll_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     return A_OK;
 }
 
-static A_STATUS
+static int
 wmi_dtimexpiry_event_rx(struct wmi_t *wmip, A_UINT8 *datap,int len)
 {
     A_WMI_DTIMEXPIRY_EVENT(wmip->wmi_devt);
@@ -6236,7 +6236,7 @@ wmi_dtimexpiry_event_rx(struct wmi_t *wmip, A_UINT8 *datap,int len)
 }
 
 #ifdef WAPI_ENABLE
-static A_STATUS
+static int
 wmi_wapi_rekey_event_rx(struct wmi_t *wmip, A_UINT8 *datap,int len)
 {
     A_UINT8 *ev;
@@ -6251,7 +6251,7 @@ wmi_wapi_rekey_event_rx(struct wmi_t *wmip, A_UINT8 *datap,int len)
 }
 #endif
 
-A_STATUS
+int
 wmi_set_pvb_cmd(struct wmi_t *wmip, A_UINT16 aid, A_BOOL flag)
 {
     WMI_AP_SET_PVB_CMD *cmd;
@@ -6272,7 +6272,7 @@ wmi_set_pvb_cmd(struct wmi_t *wmip, A_UINT16 aid, A_BOOL flag)
     return (wmi_cmd_send(wmip, osbuf, WMI_AP_SET_PVB_CMDID, NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_ap_conn_inact_time(struct wmi_t *wmip, A_UINT32 period)
 {
     WMI_AP_CONN_INACT_CMD *cmd;
@@ -6292,7 +6292,7 @@ wmi_ap_conn_inact_time(struct wmi_t *wmip, A_UINT32 period)
     return (wmi_cmd_send(wmip, osbuf, WMI_AP_CONN_INACT_CMDID, NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_ap_bgscan_time(struct wmi_t *wmip, A_UINT32 period, A_UINT32 dwell)
 {
     WMI_AP_PROT_SCAN_TIME_CMD *cmd;
@@ -6313,7 +6313,7 @@ wmi_ap_bgscan_time(struct wmi_t *wmip, A_UINT32 period, A_UINT32 dwell)
     return (wmi_cmd_send(wmip, osbuf, WMI_AP_PROT_SCAN_TIME_CMDID, NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_ap_set_dtim(struct wmi_t *wmip, A_UINT8 dtim)
 {
     WMI_AP_SET_DTIM_CMD *cmd;
@@ -6341,7 +6341,7 @@ wmi_ap_set_dtim(struct wmi_t *wmip, A_UINT8 dtim)
  * OR with AP_ACL_RETAIN_LIST_MASK, else the existing list will be cleared.
  * If there is no chage in policy, the list will be intact.
  */
-A_STATUS
+int
 wmi_ap_set_acl_policy(struct wmi_t *wmip, A_UINT8 policy)
 {
     void *osbuf;
@@ -6361,7 +6361,7 @@ wmi_ap_set_acl_policy(struct wmi_t *wmip, A_UINT8 policy)
     return (wmi_cmd_send(wmip, osbuf, WMI_AP_ACL_POLICY_CMDID, NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_ap_set_rateset(struct wmi_t *wmip, A_UINT8 rateset)
 {
     void *osbuf;
@@ -6382,7 +6382,7 @@ wmi_ap_set_rateset(struct wmi_t *wmip, A_UINT8 rateset)
 }
 
 #ifdef ATH_AR6K_11N_SUPPORT
-A_STATUS
+int
 wmi_set_ht_cap_cmd(struct wmi_t *wmip, WMI_SET_HT_CAP_CMD *cmd)
 {
     void *osbuf;
@@ -6407,7 +6407,7 @@ wmi_set_ht_cap_cmd(struct wmi_t *wmip, WMI_SET_HT_CAP_CMD *cmd)
                          NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_set_ht_op_cmd(struct wmi_t *wmip, A_UINT8 sta_chan_width)
 {
     void *osbuf;
@@ -6429,7 +6429,7 @@ wmi_set_ht_op_cmd(struct wmi_t *wmip, A_UINT8 sta_chan_width)
 }
 #endif
 
-A_STATUS
+int
 wmi_set_tx_select_rates_cmd(struct wmi_t *wmip, A_UINT32 *pMaskArray)
 {
     void *osbuf;
@@ -6450,7 +6450,7 @@ wmi_set_tx_select_rates_cmd(struct wmi_t *wmip, A_UINT32 *pMaskArray)
 }
 
 
-A_STATUS
+int
 wmi_send_hci_cmd(struct wmi_t *wmip, A_UINT8 *buf, A_UINT16 sz)
 {
     void *osbuf;
@@ -6470,7 +6470,7 @@ wmi_send_hci_cmd(struct wmi_t *wmip, A_UINT8 *buf, A_UINT16 sz)
 }
 
 #ifdef ATH_AR6K_11N_SUPPORT
-A_STATUS
+int
 wmi_allow_aggr_cmd(struct wmi_t *wmip, A_UINT16 tx_tidmask, A_UINT16 rx_tidmask)
 {
     void *osbuf;
@@ -6490,7 +6490,7 @@ wmi_allow_aggr_cmd(struct wmi_t *wmip, A_UINT16 tx_tidmask, A_UINT16 rx_tidmask)
     return (wmi_cmd_send(wmip, osbuf, WMI_ALLOW_AGGR_CMDID, NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_setup_aggr_cmd(struct wmi_t *wmip, A_UINT8 tid)
 {
     void *osbuf;
@@ -6509,7 +6509,7 @@ wmi_setup_aggr_cmd(struct wmi_t *wmip, A_UINT8 tid)
     return (wmi_cmd_send(wmip, osbuf, WMI_ADDBA_REQ_CMDID, NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_delete_aggr_cmd(struct wmi_t *wmip, A_UINT8 tid, A_BOOL uplink)
 {
     void *osbuf;
@@ -6531,7 +6531,7 @@ wmi_delete_aggr_cmd(struct wmi_t *wmip, A_UINT8 tid, A_BOOL uplink)
 }
 #endif
 
-A_STATUS
+int
 wmi_set_rx_frame_format_cmd(struct wmi_t *wmip, A_UINT8 rxMetaVersion,
                             A_BOOL rxDot11Hdr, A_BOOL defragOnHost)
 {
@@ -6555,7 +6555,7 @@ wmi_set_rx_frame_format_cmd(struct wmi_t *wmip, A_UINT8 rxMetaVersion,
 }
 
 
-A_STATUS
+int
 wmi_set_thin_mode_cmd(struct wmi_t *wmip, A_BOOL bThinMode)
 {
     void *osbuf;
@@ -6576,7 +6576,7 @@ wmi_set_thin_mode_cmd(struct wmi_t *wmip, A_BOOL bThinMode)
 }
 
 
-A_STATUS
+int
 wmi_set_wlan_conn_precedence_cmd(struct wmi_t *wmip, BT_WLAN_CONN_PRECEDENCE precedence)
 {
     void *osbuf;
@@ -6597,7 +6597,7 @@ wmi_set_wlan_conn_precedence_cmd(struct wmi_t *wmip, BT_WLAN_CONN_PRECEDENCE pre
                          NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_set_pmk_cmd(struct wmi_t *wmip, A_UINT8 *pmk)
 {
     void *osbuf;
@@ -6618,7 +6618,7 @@ wmi_set_pmk_cmd(struct wmi_t *wmip, A_UINT8 *pmk)
     return (wmi_cmd_send(wmip, osbuf, WMI_SET_PMK_CMDID, NO_SYNC_WMIFLAG));
 }
 
-A_STATUS
+int
 wmi_SGI_cmd(struct wmi_t *wmip, A_UINT32 sgiMask, A_UINT8 sgiPERThreshold)
 {
     void *osbuf;
-- 
1.7.4.rc3

