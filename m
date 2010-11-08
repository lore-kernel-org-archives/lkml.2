Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab0KHWEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 17:04:09 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:46378
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755810Ab0KHWDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 17:03:02 -0500
From: Haiyang Zhang <haiyangz@linuxonhyperv.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: [PATCH 02/10] staging: hv: Convert camel cased struct fields in hv_api.h to lower cases
Date: Mon,  8 Nov 2010 14:04:39 -0800
Message-Id: <1289253887-2596-2-git-send-email-haiyangz@linuxonhyperv.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1289253887-2596-1-git-send-email-haiyangz@linuxonhyperv.com>
References: <1289253887-2596-1-git-send-email-haiyangz@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

staging: hv: Convert camel cased struct fields in hv_api.h to lower cases

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/channel.c      |   32 ++--
 drivers/staging/hv/channel_mgmt.c |    6 +-
 drivers/staging/hv/connection.c   |    4 +-
 drivers/staging/hv/hv.c           |  120 ++++++++--------
 drivers/staging/hv/hv_api.h       |  274 ++++++++++++++++++------------------
 drivers/staging/hv/vmbus.c        |   18 ++--
 6 files changed, 227 insertions(+), 227 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 9fa0fe1..7c15c40 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -43,24 +43,24 @@ static void DumpMonitorPage(struct hv_monitor_page *MonitorPage)
 	int j = 0;
 
 	DPRINT_DBG(VMBUS, "monitorPage - %p, trigger state - %d",
-		   MonitorPage, MonitorPage->TriggerState);
+		   MonitorPage, MonitorPage->trigger_state);
 
 	for (i = 0; i < 4; i++)
 		DPRINT_DBG(VMBUS, "trigger group (%d) - %llx", i,
-			   MonitorPage->TriggerGroup[i].AsUINT64);
+			   MonitorPage->trigger_group[i].as_uint64);
 
 	for (i = 0; i < 4; i++) {
 		for (j = 0; j < 32; j++) {
 			DPRINT_DBG(VMBUS, "latency (%d)(%d) - %llx", i, j,
-				   MonitorPage->Latency[i][j]);
+				   MonitorPage->latency[i][j]);
 		}
 	}
 	for (i = 0; i < 4; i++) {
 		for (j = 0; j < 32; j++) {
 			DPRINT_DBG(VMBUS, "param-conn id (%d)(%d) - %d", i, j,
-			       MonitorPage->Parameter[i][j].ConnectionId.Asu32);
+			       MonitorPage->parameter[i][j].connectionid.asu32);
 			DPRINT_DBG(VMBUS, "param-flag (%d)(%d) - %d", i, j,
-				MonitorPage->Parameter[i][j].FlagNumber);
+				MonitorPage->parameter[i][j].flag_number);
 		}
 	}
 }
@@ -84,8 +84,8 @@ static void vmbus_setevent(struct vmbus_channel *channel)
 		monitorpage++; /* Get the child to parent monitor page */
 
 		set_bit(channel->monitor_bit,
-			(unsigned long *)&monitorpage->TriggerGroup
-					[channel->monitor_grp].Pending);
+			(unsigned long *)&monitorpage->trigger_group
+					[channel->monitor_grp].pending);
 
 	} else {
 		VmbusSetEvent(channel->offermsg.child_relid);
@@ -108,7 +108,7 @@ static void VmbusChannelClearEvent(struct vmbus_channel *channel)
 		monitorPage++; /* Get the child to parent monitor page */
 
 		clear_bit(Channel->monitor_bit,
-			  (unsigned long *)&monitorPage->TriggerGroup
+			  (unsigned long *)&monitorPage->trigger_group
 					[Channel->monitor_grp].Pending);
 	}
 }
@@ -138,22 +138,22 @@ void vmbus_get_debug_info(struct vmbus_channel *channel,
 	debuginfo->monitorid = channel->offermsg.monitorid;
 
 	debuginfo->servermonitor_pending =
-			monitorpage->TriggerGroup[monitor_group].Pending;
+			monitorpage->trigger_group[monitor_group].pending;
 	debuginfo->servermonitor_latency =
-			monitorpage->Latency[monitor_group][monitor_offset];
+			monitorpage->latency[monitor_group][monitor_offset];
 	debuginfo->servermonitor_connectionid =
-			monitorpage->Parameter[monitor_group]
-					[monitor_offset].ConnectionId.u.Id;
+			monitorpage->parameter[monitor_group]
+					[monitor_offset].connectionid.u.id;
 
 	monitorpage++;
 
 	debuginfo->clientmonitor_pending =
-			monitorpage->TriggerGroup[monitor_group].Pending;
+			monitorpage->trigger_group[monitor_group].pending;
 	debuginfo->clientmonitor_latency =
-			monitorpage->Latency[monitor_group][monitor_offset];
+			monitorpage->latency[monitor_group][monitor_offset];
 	debuginfo->clientmonitor_connectionid =
-			monitorpage->Parameter[monitor_group]
-					[monitor_offset].ConnectionId.u.Id;
+			monitorpage->parameter[monitor_group]
+					[monitor_offset].connectionid.u.id;
 
 	RingBufferGetDebugInfo(&channel->inbound, &debuginfo->inbound);
 	RingBufferGetDebugInfo(&channel->outbound, &debuginfo->outbound);
diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index dbfe0f2..be34e38 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -742,8 +742,8 @@ void vmbus_onmessage(void *context)
 	struct vmbus_channel_message_header *hdr;
 	int size;
 
-	hdr = (struct vmbus_channel_message_header *)msg->u.Payload;
-	size = msg->Header.PayloadSize;
+	hdr = (struct vmbus_channel_message_header *)msg->u.payload;
+	size = msg->header.payload_size;
 
 	DPRINT_DBG(VMBUS, "message type %d size %d", hdr->msgtype, size);
 
@@ -752,7 +752,7 @@ void vmbus_onmessage(void *context)
 			   "Received invalid channel message type %d size %d",
 			   hdr->msgtype, size);
 		print_hex_dump_bytes("", DUMP_PREFIX_NONE,
-				     (unsigned char *)msg->u.Payload, size);
+				     (unsigned char *)msg->u.payload, size);
 		kfree(msg);
 		return;
 	}
diff --git a/drivers/staging/hv/connection.c b/drivers/staging/hv/connection.c
index 6f3f525..ba50dd8 100644
--- a/drivers/staging/hv/connection.c
+++ b/drivers/staging/hv/connection.c
@@ -309,8 +309,8 @@ int VmbusPostMessage(void *buffer, size_t bufferLen)
 {
 	union hv_connection_id connId;
 
-	connId.Asu32 = 0;
-	connId.u.Id = VMBUS_MESSAGE_CONNECTION_ID;
+	connId.asu32 = 0;
+	connId.u.id = VMBUS_MESSAGE_CONNECTION_ID;
 	return HvPostMessage(connId, 1, buffer, bufferLen);
 }
 
diff --git a/drivers/staging/hv/hv.c b/drivers/staging/hv/hv.c
index 86b1ddd..ab03327 100644
--- a/drivers/staging/hv/hv.c
+++ b/drivers/staging/hv/hv.c
@@ -50,7 +50,7 @@ static int HvQueryHypervisorPresence(void)
 	ebx = 0;
 	ecx = 0;
 	edx = 0;
-	op = HvCpuIdFunctionVersionAndFeatures;
+	op = HVCPUID_VERSION_FEATURES;
 	cpuid(op, &eax, &ebx, &ecx, &edx);
 
 	return ecx & HV_PRESENT_BIT;
@@ -76,7 +76,7 @@ static int HvQueryHypervisorInfo(void)
 	ebx = 0;
 	ecx = 0;
 	edx = 0;
-	op = HvCpuIdFunctionHvVendorAndMaxFunction;
+	op = HVCPUID_VENDOR_MAXFUNCTION;
 	cpuid(op, &eax, &ebx, &ecx, &edx);
 
 	DPRINT_INFO(VMBUS, "Vendor ID: %c%c%c%c%c%c%c%c%c%c%c%c",
@@ -98,7 +98,7 @@ static int HvQueryHypervisorInfo(void)
 	ebx = 0;
 	ecx = 0;
 	edx = 0;
-	op = HvCpuIdFunctionHvInterface;
+	op = HVCPUID_INTERFACE;
 	cpuid(op, &eax, &ebx, &ecx, &edx);
 
 	DPRINT_INFO(VMBUS, "Interface ID: %c%c%c%c",
@@ -107,12 +107,12 @@ static int HvQueryHypervisorInfo(void)
 		    ((eax >> 16) & 0xFF),
 		    ((eax >> 24) & 0xFF));
 
-	if (maxLeaf >= HvCpuIdFunctionMsHvVersion) {
+	if (maxLeaf >= HVCPUID_VERSION) {
 		eax = 0;
 		ebx = 0;
 		ecx = 0;
 		edx = 0;
-		op = HvCpuIdFunctionMsHvVersion;
+		op = HVCPUID_VERSION;
 		cpuid(op, &eax, &ebx, &ecx, &edx);
 		DPRINT_INFO(VMBUS, "OS Build:%d-%d.%d-%d-%d.%d",\
 			    eax,
@@ -222,7 +222,7 @@ int HvInit(void)
 	gHvContext.GuestId = HV_LINUX_GUEST_ID;
 
 	/* See if the hypercall page is already set */
-	rdmsrl(HV_X64_MSR_HYPERCALL, hypercallMsr.AsUINT64);
+	rdmsrl(HV_X64_MSR_HYPERCALL, hypercallMsr.as_uint64);
 
 	/*
 	* Allocate the hypercall page memory
@@ -236,16 +236,16 @@ int HvInit(void)
 		goto Cleanup;
 	}
 
-	hypercallMsr.Enable = 1;
+	hypercallMsr.enable = 1;
 
-	hypercallMsr.GuestPhysicalAddress = vmalloc_to_pfn(virtAddr);
-	wrmsrl(HV_X64_MSR_HYPERCALL, hypercallMsr.AsUINT64);
+	hypercallMsr.guest_physical_address = vmalloc_to_pfn(virtAddr);
+	wrmsrl(HV_X64_MSR_HYPERCALL, hypercallMsr.as_uint64);
 
 	/* Confirm that hypercall page did get setup. */
-	hypercallMsr.AsUINT64 = 0;
-	rdmsrl(HV_X64_MSR_HYPERCALL, hypercallMsr.AsUINT64);
+	hypercallMsr.as_uint64 = 0;
+	rdmsrl(HV_X64_MSR_HYPERCALL, hypercallMsr.as_uint64);
 
-	if (!hypercallMsr.Enable) {
+	if (!hypercallMsr.enable) {
 		DPRINT_ERR(VMBUS, "unable to set hypercall page!!");
 		goto Cleanup;
 	}
@@ -254,7 +254,7 @@ int HvInit(void)
 
 	DPRINT_INFO(VMBUS, "Hypercall page VA=%p, PA=0x%0llx",
 		    gHvContext.HypercallPage,
-		    (u64)hypercallMsr.GuestPhysicalAddress << PAGE_SHIFT);
+		    (u64)hypercallMsr.guest_physical_address << PAGE_SHIFT);
 
 	/* Setup the global signal event param for the signal event hypercall */
 	gHvContext.SignalEventBuffer =
@@ -267,19 +267,19 @@ int HvInit(void)
 		(struct hv_input_signal_event *)
 			(ALIGN_UP((unsigned long)gHvContext.SignalEventBuffer,
 				  HV_HYPERCALL_PARAM_ALIGN));
-	gHvContext.SignalEventParam->ConnectionId.Asu32 = 0;
-	gHvContext.SignalEventParam->ConnectionId.u.Id =
+	gHvContext.SignalEventParam->connectionid.asu32 = 0;
+	gHvContext.SignalEventParam->connectionid.u.id =
 						VMBUS_EVENT_CONNECTION_ID;
-	gHvContext.SignalEventParam->FlagNumber = 0;
-	gHvContext.SignalEventParam->RsvdZ = 0;
+	gHvContext.SignalEventParam->flag_number = 0;
+	gHvContext.SignalEventParam->rsvdz = 0;
 
 	return ret;
 
 Cleanup:
 	if (virtAddr) {
-		if (hypercallMsr.Enable) {
-			hypercallMsr.AsUINT64 = 0;
-			wrmsrl(HV_X64_MSR_HYPERCALL, hypercallMsr.AsUINT64);
+		if (hypercallMsr.enable) {
+			hypercallMsr.as_uint64 = 0;
+			wrmsrl(HV_X64_MSR_HYPERCALL, hypercallMsr.as_uint64);
 		}
 
 		vfree(virtAddr);
@@ -302,8 +302,8 @@ void HvCleanup(void)
 	gHvContext.SignalEventParam = NULL;
 
 	if (gHvContext.HypercallPage) {
-		hypercallMsr.AsUINT64 = 0;
-		wrmsrl(HV_X64_MSR_HYPERCALL, hypercallMsr.AsUINT64);
+		hypercallMsr.as_uint64 = 0;
+		wrmsrl(HV_X64_MSR_HYPERCALL, hypercallMsr.as_uint64);
 		vfree(gHvContext.HypercallPage);
 		gHvContext.HypercallPage = NULL;
 	}
@@ -337,12 +337,12 @@ u16 HvPostMessage(union hv_connection_id connectionId,
 	alignedMsg = (struct hv_input_post_message *)
 			(ALIGN_UP(addr, HV_HYPERCALL_PARAM_ALIGN));
 
-	alignedMsg->ConnectionId = connectionId;
-	alignedMsg->MessageType = messageType;
-	alignedMsg->PayloadSize = payloadSize;
-	memcpy((void *)alignedMsg->Payload, payload, payloadSize);
+	alignedMsg->connectionid = connectionId;
+	alignedMsg->message_type = messageType;
+	alignedMsg->payload_size = payloadSize;
+	memcpy((void *)alignedMsg->payload, payload, payloadSize);
 
-	status = HvDoHypercall(HvCallPostMessage, alignedMsg, NULL) & 0xFFFF;
+	status = HvDoHypercall(HVCALL_POST_MESSAGE, alignedMsg, NULL) & 0xFFFF;
 
 	kfree((void *)addr);
 
@@ -359,7 +359,7 @@ u16 HvSignalEvent(void)
 {
 	u16 status;
 
-	status = HvDoHypercall(HvCallSignalEvent, gHvContext.SignalEventParam,
+	status = HvDoHypercall(HVCALL_SIGNAL_EVENT, gHvContext.SignalEventParam,
 			       NULL) & 0xFFFF;
 	return status;
 }
@@ -407,47 +407,47 @@ void HvSynicInit(void *irqarg)
 	}
 
 	/* Setup the Synic's message page */
-	rdmsrl(HV_X64_MSR_SIMP, simp.AsUINT64);
-	simp.SimpEnabled = 1;
-	simp.BaseSimpGpa = virt_to_phys(gHvContext.synICMessagePage[cpu])
+	rdmsrl(HV_X64_MSR_SIMP, simp.as_uint64);
+	simp.simp_enabled = 1;
+	simp.base_simp_gpa = virt_to_phys(gHvContext.synICMessagePage[cpu])
 		>> PAGE_SHIFT;
 
-	DPRINT_DBG(VMBUS, "HV_X64_MSR_SIMP msr set to: %llx", simp.AsUINT64);
+	DPRINT_DBG(VMBUS, "HV_X64_MSR_SIMP msr set to: %llx", simp.as_uint64);
 
-	wrmsrl(HV_X64_MSR_SIMP, simp.AsUINT64);
+	wrmsrl(HV_X64_MSR_SIMP, simp.as_uint64);
 
 	/* Setup the Synic's event page */
-	rdmsrl(HV_X64_MSR_SIEFP, siefp.AsUINT64);
-	siefp.SiefpEnabled = 1;
-	siefp.BaseSiefpGpa = virt_to_phys(gHvContext.synICEventPage[cpu])
+	rdmsrl(HV_X64_MSR_SIEFP, siefp.as_uint64);
+	siefp.siefp_enabled = 1;
+	siefp.base_siefp_gpa = virt_to_phys(gHvContext.synICEventPage[cpu])
 		>> PAGE_SHIFT;
 
-	DPRINT_DBG(VMBUS, "HV_X64_MSR_SIEFP msr set to: %llx", siefp.AsUINT64);
+	DPRINT_DBG(VMBUS, "HV_X64_MSR_SIEFP msr set to: %llx", siefp.as_uint64);
 
-	wrmsrl(HV_X64_MSR_SIEFP, siefp.AsUINT64);
+	wrmsrl(HV_X64_MSR_SIEFP, siefp.as_uint64);
 
 	/* Setup the interception SINT. */
 	/* wrmsrl((HV_X64_MSR_SINT0 + HV_SYNIC_INTERCEPTION_SINT_INDEX), */
-	/*	  interceptionSint.AsUINT64); */
+	/*	  interceptionSint.as_uint64); */
 
 	/* Setup the shared SINT. */
-	rdmsrl(HV_X64_MSR_SINT0 + VMBUS_MESSAGE_SINT, sharedSint.AsUINT64);
+	rdmsrl(HV_X64_MSR_SINT0 + VMBUS_MESSAGE_SINT, sharedSint.as_uint64);
 
-	sharedSint.AsUINT64 = 0;
-	sharedSint.Vector = irqVector; /* HV_SHARED_SINT_IDT_VECTOR + 0x20; */
-	sharedSint.Masked = false;
-	sharedSint.AutoEoi = true;
+	sharedSint.as_uint64 = 0;
+	sharedSint.vector = irqVector; /* HV_SHARED_SINT_IDT_VECTOR + 0x20; */
+	sharedSint.masked = false;
+	sharedSint.auto_eoi = true;
 
 	DPRINT_DBG(VMBUS, "HV_X64_MSR_SINT1 msr set to: %llx",
-		   sharedSint.AsUINT64);
+		   sharedSint.as_uint64);
 
-	wrmsrl(HV_X64_MSR_SINT0 + VMBUS_MESSAGE_SINT, sharedSint.AsUINT64);
+	wrmsrl(HV_X64_MSR_SINT0 + VMBUS_MESSAGE_SINT, sharedSint.as_uint64);
 
 	/* Enable the global synic bit */
-	rdmsrl(HV_X64_MSR_SCONTROL, sctrl.AsUINT64);
-	sctrl.Enable = 1;
+	rdmsrl(HV_X64_MSR_SCONTROL, sctrl.as_uint64);
+	sctrl.enable = 1;
 
-	wrmsrl(HV_X64_MSR_SCONTROL, sctrl.AsUINT64);
+	wrmsrl(HV_X64_MSR_SCONTROL, sctrl.as_uint64);
 
 	gHvContext.SynICInitialized = true;
 	return;
@@ -474,25 +474,25 @@ void HvSynicCleanup(void *arg)
 	if (!gHvContext.SynICInitialized)
 		return;
 
-	rdmsrl(HV_X64_MSR_SINT0 + VMBUS_MESSAGE_SINT, sharedSint.AsUINT64);
+	rdmsrl(HV_X64_MSR_SINT0 + VMBUS_MESSAGE_SINT, sharedSint.as_uint64);
 
-	sharedSint.Masked = 1;
+	sharedSint.masked = 1;
 
 	/* Need to correctly cleanup in the case of SMP!!! */
 	/* Disable the interrupt */
-	wrmsrl(HV_X64_MSR_SINT0 + VMBUS_MESSAGE_SINT, sharedSint.AsUINT64);
+	wrmsrl(HV_X64_MSR_SINT0 + VMBUS_MESSAGE_SINT, sharedSint.as_uint64);
 
-	rdmsrl(HV_X64_MSR_SIMP, simp.AsUINT64);
-	simp.SimpEnabled = 0;
-	simp.BaseSimpGpa = 0;
+	rdmsrl(HV_X64_MSR_SIMP, simp.as_uint64);
+	simp.simp_enabled = 0;
+	simp.base_simp_gpa = 0;
 
-	wrmsrl(HV_X64_MSR_SIMP, simp.AsUINT64);
+	wrmsrl(HV_X64_MSR_SIMP, simp.as_uint64);
 
-	rdmsrl(HV_X64_MSR_SIEFP, siefp.AsUINT64);
-	siefp.SiefpEnabled = 0;
-	siefp.BaseSiefpGpa = 0;
+	rdmsrl(HV_X64_MSR_SIEFP, siefp.as_uint64);
+	siefp.siefp_enabled = 0;
+	siefp.base_siefp_gpa = 0;
 
-	wrmsrl(HV_X64_MSR_SIEFP, siefp.AsUINT64);
+	wrmsrl(HV_X64_MSR_SIEFP, siefp.as_uint64);
 
 	osd_PageFree(gHvContext.synICMessagePage[cpu], 1);
 	osd_PageFree(gHvContext.synICEventPage[cpu], 1);
diff --git a/drivers/staging/hv/hv_api.h b/drivers/staging/hv/hv_api.h
index 9eb818e..9df6472 100644
--- a/drivers/staging/hv/hv_api.h
+++ b/drivers/staging/hv/hv_api.h
@@ -510,21 +510,21 @@
 
 /*
  * The below CPUID leaves are present if VersionAndFeatures.HypervisorPresent
- * is set by CPUID(HvCpuIdFunctionVersionAndFeatures).
+ * is set by CPUID(HVCPUID_VERSION_FEATURES).
  */
 enum hv_cpuid_function {
-	HvCpuIdFunctionVersionAndFeatures		= 0x00000001,
-	HvCpuIdFunctionHvVendorAndMaxFunction		= 0x40000000,
-	HvCpuIdFunctionHvInterface			= 0x40000001,
+	HVCPUID_VERSION_FEATURES		= 0x00000001,
+	HVCPUID_VENDOR_MAXFUNCTION		= 0x40000000,
+	HVCPUID_INTERFACE			= 0x40000001,
 
 	/*
 	 * The remaining functions depend on the value of
-	 * HvCpuIdFunctionInterface
+	 * HVCPUID_INTERFACE
 	 */
-	HvCpuIdFunctionMsHvVersion			= 0x40000002,
-	HvCpuIdFunctionMsHvFeatures			= 0x40000003,
-	HvCpuIdFunctionMsHvEnlightenmentInformation	= 0x40000004,
-	HvCpuIdFunctionMsHvImplementationLimits		= 0x40000005,
+	HVCPUID_VERSION			= 0x40000002,
+	HVCPUID_FEATURES			= 0x40000003,
+	HVCPUID_ENLIGHTENMENT_INFO	= 0x40000004,
+	HVCPUID_IMPLEMENTATION_LIMITS		= 0x40000005,
 };
 
 /* Define the virtual APIC registers */
@@ -575,30 +575,30 @@ enum hv_cpuid_function {
 
 /* Define hypervisor message types. */
 enum hv_message_type {
-	HvMessageTypeNone			= 0x00000000,
+	HVMSG_NONE			= 0x00000000,
 
 	/* Memory access messages. */
-	HvMessageTypeUnmappedGpa		= 0x80000000,
-	HvMessageTypeGpaIntercept		= 0x80000001,
+	HVMSG_UNMAPPED_GPA		= 0x80000000,
+	HVMSG_GPA_INTERCEPT		= 0x80000001,
 
 	/* Timer notification messages. */
-	HvMessageTimerExpired			= 0x80000010,
+	HVMSG_TIMER_EXPIRED			= 0x80000010,
 
 	/* Error messages. */
-	HvMessageTypeInvalidVpRegisterValue	= 0x80000020,
-	HvMessageTypeUnrecoverableException	= 0x80000021,
-	HvMessageTypeUnsupportedFeature		= 0x80000022,
+	HVMSG_INVALID_VP_REGISTER_VALUE	= 0x80000020,
+	HVMSG_UNRECOVERABLE_EXCEPTION	= 0x80000021,
+	HVMSG_UNSUPPORTED_FEATURE		= 0x80000022,
 
 	/* Trace buffer complete messages. */
-	HvMessageTypeEventLogBufferComplete	= 0x80000040,
+	HVMSG_EVENTLOG_BUFFERCOMPLETE	= 0x80000040,
 
 	/* Platform-specific processor intercept messages. */
-	HvMessageTypeX64IoPortIntercept		= 0x80010000,
-	HvMessageTypeX64MsrIntercept		= 0x80010001,
-	HvMessageTypeX64CpuidIntercept		= 0x80010002,
-	HvMessageTypeX64ExceptionIntercept	= 0x80010003,
-	HvMessageTypeX64ApicEoi			= 0x80010004,
-	HvMessageTypeX64LegacyFpError		= 0x80010005
+	HVMSG_X64_IOPORT_INTERCEPT		= 0x80010000,
+	HVMSG_X64_MSR_INTERCEPT		= 0x80010001,
+	HVMSG_X64_CPUID_INTERCEPT		= 0x80010002,
+	HVMSG_X64_EXCEPTION_INTERCEPT	= 0x80010003,
+	HVMSG_X64_APIC_EOI			= 0x80010004,
+	HVMSG_X64_LEGACY_FP_ERROR		= 0x80010005
 };
 
 /* Define the number of synthetic interrupt sources. */
@@ -610,103 +610,103 @@ enum hv_message_type {
 
 /* Define connection identifier type. */
 union hv_connection_id {
-	u32 Asu32;
+	u32 asu32;
 	struct {
-		u32 Id:24;
-		u32 Reserved:8;
+		u32 id:24;
+		u32 reserved:8;
 	} u;
 };
 
 /* Define port identifier type. */
 union hv_port_id {
-	u32 Asu32;
+	u32 asu32;
 	struct {
-		u32 Id:24;
-		u32 Reserved:8;
+		u32 id:24;
+		u32 reserved:8;
 	} u ;
 };
 
 /* Define port type. */
 enum hv_port_type {
-	HvPortTypeMessage	= 1,
-	HvPortTypeEvent		= 2,
-	HvPortTypeMonitor	= 3
+	HVPORT_MSG	= 1,
+	HVPORT_EVENT		= 2,
+	HVPORT_MONITOR	= 3
 };
 
 /* Define port information structure. */
 struct hv_port_info {
-	enum hv_port_type PortType;
-	u32 Padding;
+	enum hv_port_type port_type;
+	u32 padding;
 	union {
 		struct {
-			u32 TargetSint;
-			u32 TargetVp;
-			u64 RsvdZ;
-		} MessagePortInfo;
+			u32 target_sint;
+			u32 target_vp;
+			u64 rsvdz;
+		} message_port_info;
 		struct {
-			u32 TargetSint;
-			u32 TargetVp;
-			u16 BaseFlagNumber;
-			u16 FlagCount;
-			u32 RsvdZ;
-		} EventPortInfo;
+			u32 target_sint;
+			u32 target_vp;
+			u16 base_flag_bumber;
+			u16 flag_count;
+			u32 rsvdz;
+		} event_port_info;
 		struct {
-			u64 MonitorAddress;
-			u64 RsvdZ;
-		} MonitorPortInfo;
+			u64 monitor_address;
+			u64 rsvdz;
+		} monitor_port_info;
 	};
 };
 
 struct hv_connection_info {
-	enum hv_port_type PortType;
-	u32 Padding;
+	enum hv_port_type port_type;
+	u32 padding;
 	union {
 		struct {
-			u64 RsvdZ;
-		} MessageConnectionInfo;
+			u64 rsvdz;
+		} message_connection_info;
 		struct {
-			u64 RsvdZ;
-		} EventConnectionInfo;
+			u64 rsvdz;
+		} event_connection_info;
 		struct {
-			u64 MonitorAddress;
-		} MonitorConnectionInfo;
+			u64 monitor_address;
+		} monitor_connection_info;
 	};
 };
 
 /* Define synthetic interrupt controller message flags. */
 union hv_message_flags {
-	u8 Asu8;
+	u8 asu8;
 	struct {
-		u8 MessagePending:1;
-		u8 Reserved:7;
+		u8 msg_pending:1;
+		u8 reserved:7;
 	};
 };
 
 /* Define synthetic interrupt controller message header. */
 struct hv_message_header {
-	enum hv_message_type MessageType;
-	u8 PayloadSize;
-	union hv_message_flags MessageFlags;
-	u8 Reserved[2];
+	enum hv_message_type message_type;
+	u8 payload_size;
+	union hv_message_flags message_flags;
+	u8 reserved[2];
 	union {
-		u64 Sender;
-		union hv_port_id Port;
+		u64 sender;
+		union hv_port_id port;
 	};
 };
 
 /* Define timer message payload structure. */
 struct hv_timer_message_payload {
-	u32 TimerIndex;
-	u32 Reserved;
-	u64 ExpirationTime;	/* When the timer expired */
-	u64 DeliveryTime;	/* When the message was delivered */
+	u32 timer_index;
+	u32 reserved;
+	u64 expiration_time;	/* When the timer expired */
+	u64 delivery_time;	/* When the message was delivered */
 };
 
 /* Define synthetic interrupt controller message format. */
 struct hv_message {
-	struct hv_message_header Header;
+	struct hv_message_header header;
 	union {
-		u64 Payload[HV_MESSAGE_PAYLOAD_QWORD_COUNT];
+		u64 payload[HV_MESSAGE_PAYLOAD_QWORD_COUNT];
 	} u ;
 };
 
@@ -715,82 +715,82 @@ struct hv_message {
 
 /* Define the synthetic interrupt message page layout. */
 struct hv_message_page {
-	struct hv_message SintMessage[HV_SYNIC_SINT_COUNT];
+	struct hv_message sint_message[HV_SYNIC_SINT_COUNT];
 };
 
 /* Define the synthetic interrupt controller event flags format. */
 union hv_synic_event_flags {
-	u8 Flags8[HV_EVENT_FLAGS_BYTE_COUNT];
-	u32 Flags32[HV_EVENT_FLAGS_DWORD_COUNT];
+	u8 flags8[HV_EVENT_FLAGS_BYTE_COUNT];
+	u32 flags32[HV_EVENT_FLAGS_DWORD_COUNT];
 };
 
 /* Define the synthetic interrupt flags page layout. */
 struct hv_synic_event_flags_page {
-	union hv_synic_event_flags SintEventFlags[HV_SYNIC_SINT_COUNT];
+	union hv_synic_event_flags sintevent_flags[HV_SYNIC_SINT_COUNT];
 };
 
 /* Define SynIC control register. */
 union hv_synic_scontrol {
-	u64 AsUINT64;
+	u64 as_uint64;
 	struct {
-		u64 Enable:1;
-		u64 Reserved:63;
+		u64 enable:1;
+		u64 reserved:63;
 	};
 };
 
 /* Define synthetic interrupt source. */
 union hv_synic_sint {
-	u64 AsUINT64;
+	u64 as_uint64;
 	struct {
-		u64 Vector:8;
-		u64 Reserved1:8;
-		u64 Masked:1;
-		u64 AutoEoi:1;
-		u64 Reserved2:46;
+		u64 vector:8;
+		u64 reserved1:8;
+		u64 masked:1;
+		u64 auto_eoi:1;
+		u64 reserved2:46;
 	};
 };
 
 /* Define the format of the SIMP register */
 union hv_synic_simp {
-	u64 AsUINT64;
+	u64 as_uint64;
 	struct {
-		u64 SimpEnabled:1;
-		u64 Preserved:11;
-		u64 BaseSimpGpa:52;
+		u64 simp_enabled:1;
+		u64 preserved:11;
+		u64 base_simp_gpa:52;
 	};
 };
 
 /* Define the format of the SIEFP register */
 union hv_synic_siefp {
-	u64 AsUINT64;
+	u64 as_uint64;
 	struct {
-		u64 SiefpEnabled:1;
-		u64 Preserved:11;
-		u64 BaseSiefpGpa:52;
+		u64 siefp_enabled:1;
+		u64 preserved:11;
+		u64 base_siefp_gpa:52;
 	};
 };
 
 /* Definitions for the monitored notification facility */
 union hv_monitor_trigger_group {
-	u64 AsUINT64;
+	u64 as_uint64;
 	struct {
-		u32 Pending;
-		u32 Armed;
+		u32 pending;
+		u32 armed;
 	};
 };
 
 struct hv_monitor_parameter {
-	union hv_connection_id ConnectionId;
-	u16 FlagNumber;
-	u16 RsvdZ;
+	union hv_connection_id connectionid;
+	u16 flagnumber;
+	u16 rsvdz;
 };
 
 union hv_monitor_trigger_state {
-	u32 Asu32;
+	u32 asu32;
 
 	struct {
-		u32 GroupEnable:4;
-		u32 RsvdZ:28;
+		u32 group_enable:4;
+		u32 rsvdz:28;
 	};
 };
 
@@ -814,42 +814,42 @@ union hv_monitor_trigger_state {
 /* | 840 | Rsvd4[0]                                     | */
 /* ------------------------------------------------------ */
 struct hv_monitor_page {
-	union hv_monitor_trigger_state TriggerState;
-	u32 RsvdZ1;
+	union hv_monitor_trigger_state trigger_state;
+	u32 rsvdz1;
 
-	union hv_monitor_trigger_group TriggerGroup[4];
-	u64 RsvdZ2[3];
+	union hv_monitor_trigger_group trigger_group[4];
+	u64 rsvdz2[3];
 
-	s32 NextCheckTime[4][32];
+	s32 next_checktime[4][32];
 
-	u16 Latency[4][32];
-	u64 RsvdZ3[32];
+	u16 latency[4][32];
+	u64 rsvdz3[32];
 
-	struct hv_monitor_parameter Parameter[4][32];
+	struct hv_monitor_parameter parameter[4][32];
 
-	u8 RsvdZ4[1984];
+	u8 rsvdz4[1984];
 };
 
 /* Declare the various hypercall operations. */
 enum hv_call_code {
-	HvCallPostMessage	= 0x005c,
-	HvCallSignalEvent	= 0x005d,
+	HVCALL_POST_MESSAGE	= 0x005c,
+	HVCALL_SIGNAL_EVENT	= 0x005d,
 };
 
 /* Definition of the HvPostMessage hypercall input structure. */
 struct hv_input_post_message {
-	union hv_connection_id ConnectionId;
-	u32 Reserved;
-	enum hv_message_type MessageType;
-	u32 PayloadSize;
-	u64 Payload[HV_MESSAGE_PAYLOAD_QWORD_COUNT];
+	union hv_connection_id connectionid;
+	u32 reserved;
+	enum hv_message_type message_type;
+	u32 payload_size;
+	u64 payload[HV_MESSAGE_PAYLOAD_QWORD_COUNT];
 };
 
 /* Definition of the HvSignalEvent hypercall input structure. */
 struct hv_input_signal_event {
-	union hv_connection_id ConnectionId;
-	u16 FlagNumber;
-	u16 RsvdZ;
+	union hv_connection_id connectionid;
+	u16 flag_number;
+	u16 rsvdz;
 };
 
 /*
@@ -859,16 +859,16 @@ struct hv_input_signal_event {
 
 /* Version info reported by guest OS's */
 enum hv_guest_os_vendor {
-	HvGuestOsVendorMicrosoft	= 0x0001
+	HVGUESTOS_VENDOR_MICROSOFT	= 0x0001
 };
 
 enum hv_guest_os_microsoft_ids {
-	HvGuestOsMicrosoftUndefined	= 0x00,
-	HvGuestOsMicrosoftMSDOS		= 0x01,
-	HvGuestOsMicrosoftWindows3x	= 0x02,
-	HvGuestOsMicrosoftWindows9x	= 0x03,
-	HvGuestOsMicrosoftWindowsNT	= 0x04,
-	HvGuestOsMicrosoftWindowsCE	= 0x05
+	HVGUESTOS_MICROSOFT_UNDEFINED	= 0x00,
+	HVGUESTOS_MICROSOFT_MSDOS		= 0x01,
+	HVGUESTOS_MICROSOFT_WINDOWS3X	= 0x02,
+	HVGUESTOS_MICROSOFT_WINDOWS9X	= 0x03,
+	HVGUESTOS_MICROSOFT_WINDOWSNT	= 0x04,
+	HVGUESTOS_MICROSOFT_WINDOWSCE	= 0x05
 };
 
 /*
@@ -877,14 +877,14 @@ enum hv_guest_os_microsoft_ids {
 #define HV_X64_MSR_GUEST_OS_ID	0x40000000
 
 union hv_x64_msr_guest_os_id_contents {
-	u64 AsUINT64;
+	u64 as_uint64;
 	struct {
-		u64 BuildNumber:16;
-		u64 ServiceVersion:8; /* Service Pack, etc. */
-		u64 MinorVersion:8;
-		u64 MajorVersion:8;
-		u64 OsId:8; /* enum hv_guest_os_microsoft_ids (if Vendor=MS) */
-		u64 VendorId:16; /* enum hv_guest_os_vendor */
+		u64 build_number:16;
+		u64 service_version:8; /* Service Pack, etc. */
+		u64 minor_version:8;
+		u64 major_version:8;
+		u64 os_id:8; /* enum hv_guest_os_microsoft_ids (if Vendor=MS) */
+		u64 vendor_id:16; /* enum hv_guest_os_vendor */
 	};
 };
 
@@ -894,11 +894,11 @@ union hv_x64_msr_guest_os_id_contents {
 #define HV_X64_MSR_HYPERCALL	0x40000001
 
 union hv_x64_msr_hypercall_contents {
-	u64 AsUINT64;
+	u64 as_uint64;
 	struct {
-		u64 Enable:1;
-		u64 Reserved:11;
-		u64 GuestPhysicalAddress:52;
+		u64 enable:1;
+		u64 reserved:11;
+		u64 guest_physical_address:52;
 	};
 };
 
diff --git a/drivers/staging/hv/vmbus.c b/drivers/staging/hv/vmbus.c
index d449daf..7c54ca9 100644
--- a/drivers/staging/hv/vmbus.c
+++ b/drivers/staging/hv/vmbus.c
@@ -153,7 +153,7 @@ static void VmbusOnMsgDPC(struct hv_driver *drv)
 	struct hv_message *copied;
 
 	while (1) {
-		if (msg->Header.MessageType == HvMessageTypeNone) {
+		if (msg->header.message_type == HVMSG_NONE) {
 			/* no msg */
 			break;
 		} else {
@@ -166,18 +166,18 @@ static void VmbusOnMsgDPC(struct hv_driver *drv)
 					      (void *)copied);
 		}
 
-		msg->Header.MessageType = HvMessageTypeNone;
+		msg->header.message_type = HVMSG_NONE;
 
 		/*
 		 * Make sure the write to MessageType (ie set to
-		 * HvMessageTypeNone) happens before we read the
+		 * HVMSG_NONE) happens before we read the
 		 * MessagePending and EOMing. Otherwise, the EOMing
 		 * will not deliver any more messages since there is
 		 * no empty slot
 		 */
 		mb();
 
-		if (msg->Header.MessageFlags.MessagePending) {
+		if (msg->header.message_flags.msg_pending) {
 			/*
 			 * This will cause message queue rescan to
 			 * possibly deliver another msg from the
@@ -212,10 +212,10 @@ static int VmbusOnISR(struct hv_driver *drv)
 	msg = (struct hv_message *)page_addr + VMBUS_MESSAGE_SINT;
 
 	/* Check if there are actual msgs to be process */
-	if (msg->Header.MessageType != HvMessageTypeNone) {
+	if (msg->header.message_type != HVMSG_NONE) {
 		DPRINT_DBG(VMBUS, "received msg type %d size %d",
-				msg->Header.MessageType,
-				msg->Header.PayloadSize);
+				msg->header.message_type,
+				msg->header.payload_size);
 		ret |= 0x1;
 	}
 
@@ -224,8 +224,8 @@ static int VmbusOnISR(struct hv_driver *drv)
 	event = (union hv_synic_event_flags *)page_addr + VMBUS_MESSAGE_SINT;
 
 	/* Since we are a child, we only need to check bit 0 */
-	if (test_and_clear_bit(0, (unsigned long *) &event->Flags32[0])) {
-		DPRINT_DBG(VMBUS, "received event %d", event->Flags32[0]);
+	if (test_and_clear_bit(0, (unsigned long *) &event->flags32[0])) {
+		DPRINT_DBG(VMBUS, "received event %d", event->flags32[0]);
 		ret |= 0x2;
 	}
 
-- 
1.6.3.2

