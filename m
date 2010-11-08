Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab0KHWDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 17:03:06 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:45988
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755763Ab0KHWDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 17:03:01 -0500
From: Haiyang Zhang <haiyangz@linuxonhyperv.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: [PATCH 05/10] staging: hv: Convert camel cased functions in hv.c to lower cases
Date: Mon,  8 Nov 2010 14:04:42 -0800
Message-Id: <1289253887-2596-5-git-send-email-haiyangz@linuxonhyperv.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1289253887-2596-4-git-send-email-haiyangz@linuxonhyperv.com>
References: <1289253887-2596-1-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-2-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-3-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-4-git-send-email-haiyangz@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

staging: hv: Convert camel cased functions in hv.c to lower cases

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/connection.c |    4 +-
 drivers/staging/hv/hv.c         |   47 ++++++++++++++++++++------------------
 drivers/staging/hv/hv.h         |   16 ++++++------
 drivers/staging/hv/hv_api.h     |    4 +-
 drivers/staging/hv/vmbus.c      |    8 +++---
 5 files changed, 41 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/hv/connection.c b/drivers/staging/hv/connection.c
index ba50dd8..97321d1 100644
--- a/drivers/staging/hv/connection.c
+++ b/drivers/staging/hv/connection.c
@@ -311,7 +311,7 @@ int VmbusPostMessage(void *buffer, size_t bufferLen)
 
 	connId.asu32 = 0;
 	connId.u.id = VMBUS_MESSAGE_CONNECTION_ID;
-	return HvPostMessage(connId, 1, buffer, bufferLen);
+	return hv_post_message(connId, 1, buffer, bufferLen);
 }
 
 /*
@@ -324,5 +324,5 @@ int VmbusSetEvent(u32 childRelId)
 		(unsigned long *)gVmbusConnection.SendInterruptPage +
 		(childRelId >> 5));
 
-	return HvSignalEvent();
+	return hv_signal_event();
 }
diff --git a/drivers/staging/hv/hv.c b/drivers/staging/hv/hv.c
index 2fd234d..66f04d8 100644
--- a/drivers/staging/hv/hv.c
+++ b/drivers/staging/hv/hv.c
@@ -36,9 +36,10 @@ struct hv_context hv_context = {
 };
 
 /*
- * HvQueryHypervisorPresence - Query the cpuid for presense of windows hypervisor
+ * query_hypervisor_presence
+ * - Query the cpuid for presense of windows hypervisor
  */
-static int HvQueryHypervisorPresence(void)
+static int query_hypervisor_presence(void)
 {
 	unsigned int eax;
 	unsigned int ebx;
@@ -57,9 +58,9 @@ static int HvQueryHypervisorPresence(void)
 }
 
 /*
- * HvQueryHypervisorInfo - Get version info of the windows hypervisor
+ * query_hypervisor_info - Get version info of the windows hypervisor
  */
-static int HvQueryHypervisorInfo(void)
+static int query_hypervisor_info(void)
 {
 	unsigned int eax;
 	unsigned int ebx;
@@ -126,9 +127,9 @@ static int HvQueryHypervisorInfo(void)
 }
 
 /*
- * HvDoHypercall - Invoke the specified hypercall
+ * do_hypercall- Invoke the specified hypercall
  */
-static u64 HvDoHypercall(u64 control, void *input, void *output)
+static u64 do_hypercall(u64 control, void *input, void *output)
 {
 #ifdef CONFIG_X86_64
 	u64 hv_status = 0;
@@ -181,11 +182,11 @@ static u64 HvDoHypercall(u64 control, void *input, void *output)
 }
 
 /*
- * HvInit - Main initialization routine.
+ * hv_init - Main initialization routine.
  *
  * This routine must be called before any other routines in here are called
  */
-int HvInit(void)
+int hv_init(void)
 {
 	int ret = 0;
 	int max_leaf;
@@ -196,7 +197,7 @@ int HvInit(void)
 	memset(hv_context.synic_message_page, 0,
 	       sizeof(void *) * MAX_NUM_CPUS);
 
-	if (!HvQueryHypervisorPresence()) {
+	if (!query_hypervisor_presence()) {
 		DPRINT_ERR(VMBUS, "No Windows hypervisor detected!!");
 		goto Cleanup;
 	}
@@ -204,7 +205,7 @@ int HvInit(void)
 	DPRINT_INFO(VMBUS,
 		    "Windows hypervisor detected! Retrieving more info...");
 
-	max_leaf = HvQueryHypervisorInfo();
+	max_leaf = query_hypervisor_info();
 	/* HvQueryHypervisorFeatures(maxLeaf); */
 
 	/*
@@ -291,11 +292,11 @@ Cleanup:
 }
 
 /*
- * HvCleanup - Cleanup routine.
+ * hv_cleanup - Cleanup routine.
  *
  * This routine is called normally during driver unloading or exiting.
  */
-void HvCleanup(void)
+void hv_cleanup(void)
 {
 	union hv_x64_msr_hypercall_contents hypercall_msr;
 
@@ -312,11 +313,11 @@ void HvCleanup(void)
 }
 
 /*
- * HvPostMessage - Post a message using the hypervisor message IPC.
+ * hv_post_message - Post a message using the hypervisor message IPC.
  *
  * This involves a hypercall.
  */
-u16 HvPostMessage(union hv_connection_id connection_id,
+u16 hv_post_message(union hv_connection_id connection_id,
 		  enum hv_message_type message_type,
 		  void *payload, size_t payload_size)
 {
@@ -344,7 +345,8 @@ u16 HvPostMessage(union hv_connection_id connection_id,
 	aligned_msg->payload_size = payload_size;
 	memcpy((void *)aligned_msg->payload, payload, payload_size);
 
-	status = HvDoHypercall(HVCALL_POST_MESSAGE, aligned_msg, NULL) & 0xFFFF;
+	status = do_hypercall(HVCALL_POST_MESSAGE, aligned_msg, NULL)
+		& 0xFFFF;
 
 	kfree((void *)addr);
 
@@ -353,28 +355,29 @@ u16 HvPostMessage(union hv_connection_id connection_id,
 
 
 /*
- * HvSignalEvent - Signal an event on the specified connection using the hypervisor event IPC.
+ * hv_signal_event -
+ * Signal an event on the specified connection using the hypervisor event IPC.
  *
  * This involves a hypercall.
  */
-u16 HvSignalEvent(void)
+u16 hv_signal_event(void)
 {
 	u16 status;
 
-	status = HvDoHypercall(HVCALL_SIGNAL_EVENT,
+	status = do_hypercall(HVCALL_SIGNAL_EVENT,
 			       hv_context.signal_event_param,
 			       NULL) & 0xFFFF;
 	return status;
 }
 
 /*
- * HvSynicInit - Initialize the Synthethic Interrupt Controller.
+ * hv_synic_init - Initialize the Synthethic Interrupt Controller.
  *
  * If it is already initialized by another entity (ie x2v shim), we need to
  * retrieve the initialized message and event pages.  Otherwise, we create and
  * initialize the message and event pages.
  */
-void HvSynicInit(void *irqarg)
+void hv_synic_init(void *irqarg)
 {
 	u64 version;
 	union hv_synic_simp simp;
@@ -467,9 +470,9 @@ Cleanup:
 }
 
 /*
- * HvSynicCleanup - Cleanup routine for HvSynicInit().
+ * hv_synic_cleanup - Cleanup routine for hv_synic_init().
  */
-void HvSynicCleanup(void *arg)
+void hv_synic_cleanup(void *arg)
 {
 	union hv_synic_sint shared_sint;
 	union hv_synic_simp simp;
diff --git a/drivers/staging/hv/hv.h b/drivers/staging/hv/hv.h
index 6e396fc..829aff8 100644
--- a/drivers/staging/hv/hv.h
+++ b/drivers/staging/hv/hv.h
@@ -123,18 +123,18 @@ extern struct hv_context hv_context;
 
 /* Hv Interface */
 
-extern int HvInit(void);
+extern int hv_init(void);
 
-extern void HvCleanup(void);
+extern void hv_cleanup(void);
 
-extern u16 HvPostMessage(union hv_connection_id connectionId,
-			 enum hv_message_type messageType,
-			 void *payload, size_t payloadSize);
+extern u16 hv_post_message(union hv_connection_id connection_id,
+			 enum hv_message_type message_type,
+			 void *payload, size_t payload_size);
 
-extern u16 HvSignalEvent(void);
+extern u16 hv_signal_event(void);
 
-extern void HvSynicInit(void *irqarg);
+extern void hv_synic_init(void *irqarg);
 
-extern void HvSynicCleanup(void *arg);
+extern void hv_synic_cleanup(void *arg);
 
 #endif /* __HV_H__ */
diff --git a/drivers/staging/hv/hv_api.h b/drivers/staging/hv/hv_api.h
index 9df6472..70e863a 100644
--- a/drivers/staging/hv/hv_api.h
+++ b/drivers/staging/hv/hv_api.h
@@ -836,7 +836,7 @@ enum hv_call_code {
 	HVCALL_SIGNAL_EVENT	= 0x005d,
 };
 
-/* Definition of the HvPostMessage hypercall input structure. */
+/* Definition of the hv_post_message hypercall input structure. */
 struct hv_input_post_message {
 	union hv_connection_id connectionid;
 	u32 reserved;
@@ -845,7 +845,7 @@ struct hv_input_post_message {
 	u64 payload[HV_MESSAGE_PAYLOAD_QWORD_COUNT];
 };
 
-/* Definition of the HvSignalEvent hypercall input structure. */
+/* Definition of the hv_signal_event hypercall input structure. */
 struct hv_input_signal_event {
 	union hv_connection_id connectionid;
 	u16 flag_number;
diff --git a/drivers/staging/hv/vmbus.c b/drivers/staging/hv/vmbus.c
index b1ec876..e6462c6 100644
--- a/drivers/staging/hv/vmbus.c
+++ b/drivers/staging/hv/vmbus.c
@@ -109,7 +109,7 @@ static int VmbusOnDeviceAdd(struct hv_device *dev, void *AdditionalInfo)
 
 	/* strcpy(dev->name, "vmbus"); */
 	/* SynIC setup... */
-	on_each_cpu(HvSynicInit, (void *)irqvector, 1);
+	on_each_cpu(hv_synic_init, (void *)irqvector, 1);
 
 	/* Connect to VMBus in the root partition */
 	ret = VmbusConnect();
@@ -127,7 +127,7 @@ static int VmbusOnDeviceRemove(struct hv_device *dev)
 
 	vmbus_release_unattached_channels();
 	VmbusDisconnect();
-	on_each_cpu(HvSynicCleanup, NULL, 1);
+	on_each_cpu(hv_synic_cleanup, NULL, 1);
 	return ret;
 }
 
@@ -138,7 +138,7 @@ static void VmbusOnCleanup(struct hv_driver *drv)
 {
 	/* struct vmbus_driver *driver = (struct vmbus_driver *)drv; */
 
-	HvCleanup();
+	hv_cleanup();
 }
 
 /*
@@ -264,7 +264,7 @@ int VmbusInitialize(struct hv_driver *drv)
 	driver->GetChannelOffers	= VmbusGetChannelOffers;
 
 	/* Hypervisor initialization...setup hypercall page..etc */
-	ret = HvInit();
+	ret = hv_init();
 	if (ret != 0)
 		DPRINT_ERR(VMBUS, "Unable to initialize the hypervisor - 0x%x",
 				ret);
-- 
1.6.3.2

