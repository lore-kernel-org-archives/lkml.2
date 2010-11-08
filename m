Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab0KHWDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 17:03:04 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:46361
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755727Ab0KHWDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 17:03:01 -0500
From: Haiyang Zhang <haiyangz@linuxonhyperv.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: [PATCH 04/10] staging: hv: Convert camel cased local variables in hv.c to lower cases
Date: Mon,  8 Nov 2010 14:04:41 -0800
Message-Id: <1289253887-2596-4-git-send-email-haiyangz@linuxonhyperv.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1289253887-2596-3-git-send-email-haiyangz@linuxonhyperv.com>
References: <1289253887-2596-1-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-2-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-3-git-send-email-haiyangz@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

staging: hv: Convert camel cased local variables in hv.c to lower cases

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/hv.c |  172 +++++++++++++++++++++++-----------------------
 1 files changed, 86 insertions(+), 86 deletions(-)

diff --git a/drivers/staging/hv/hv.c b/drivers/staging/hv/hv.c
index d0e8c85..2fd234d 100644
--- a/drivers/staging/hv/hv.c
+++ b/drivers/staging/hv/hv.c
@@ -65,7 +65,7 @@ static int HvQueryHypervisorInfo(void)
 	unsigned int ebx;
 	unsigned int ecx;
 	unsigned int edx;
-	unsigned int maxLeaf;
+	unsigned int max_leaf;
 	unsigned int op;
 
 	/*
@@ -93,7 +93,7 @@ static int HvQueryHypervisorInfo(void)
 		    ((edx >> 16) & 0xFF),
 		    ((edx >> 24) & 0xFF));
 
-	maxLeaf = eax;
+	max_leaf = eax;
 	eax = 0;
 	ebx = 0;
 	ecx = 0;
@@ -107,7 +107,7 @@ static int HvQueryHypervisorInfo(void)
 		    ((eax >> 16) & 0xFF),
 		    ((eax >> 24) & 0xFF));
 
-	if (maxLeaf >= HVCPUID_VERSION) {
+	if (max_leaf >= HVCPUID_VERSION) {
 		eax = 0;
 		ebx = 0;
 		ecx = 0;
@@ -122,61 +122,61 @@ static int HvQueryHypervisorInfo(void)
 			    edx >> 24,
 			    edx & 0xFFFFFF);
 	}
-	return maxLeaf;
+	return max_leaf;
 }
 
 /*
  * HvDoHypercall - Invoke the specified hypercall
  */
-static u64 HvDoHypercall(u64 Control, void *Input, void *Output)
+static u64 HvDoHypercall(u64 control, void *input, void *output)
 {
 #ifdef CONFIG_X86_64
-	u64 hvStatus = 0;
-	u64 inputAddress = (Input) ? virt_to_phys(Input) : 0;
-	u64 outputAddress = (Output) ? virt_to_phys(Output) : 0;
-	volatile void *hypercallPage = hv_context.hypercall_page;
+	u64 hv_status = 0;
+	u64 input_address = (input) ? virt_to_phys(input) : 0;
+	u64 output_address = (output) ? virt_to_phys(output) : 0;
+	volatile void *hypercall_page = hv_context.hypercall_page;
 
 	DPRINT_DBG(VMBUS, "Hypercall <control %llx input phys %llx virt %p "
 		   "output phys %llx virt %p hypercall %p>",
-		   Control, inputAddress, Input,
-		   outputAddress, Output, hypercallPage);
+		   control, input_address, input,
+		   output_address, output, hypercall_page);
 
-	__asm__ __volatile__("mov %0, %%r8" : : "r" (outputAddress) : "r8");
-	__asm__ __volatile__("call *%3" : "=a" (hvStatus) :
-			     "c" (Control), "d" (inputAddress),
-			     "m" (hypercallPage));
+	__asm__ __volatile__("mov %0, %%r8" : : "r" (output_address) : "r8");
+	__asm__ __volatile__("call *%3" : "=a" (hv_status) :
+			     "c" (control), "d" (input_address),
+			     "m" (hypercall_page));
 
-	DPRINT_DBG(VMBUS, "Hypercall <return %llx>",  hvStatus);
+	DPRINT_DBG(VMBUS, "Hypercall <return %llx>",  hv_status);
 
-	return hvStatus;
+	return hv_status;
 
 #else
 
-	u32 controlHi = Control >> 32;
-	u32 controlLo = Control & 0xFFFFFFFF;
-	u32 hvStatusHi = 1;
-	u32 hvStatusLo = 1;
-	u64 inputAddress = (Input) ? virt_to_phys(Input) : 0;
-	u32 inputAddressHi = inputAddress >> 32;
-	u32 inputAddressLo = inputAddress & 0xFFFFFFFF;
-	u64 outputAddress = (Output) ? virt_to_phys(Output) : 0;
-	u32 outputAddressHi = outputAddress >> 32;
-	u32 outputAddressLo = outputAddress & 0xFFFFFFFF;
-	volatile void *hypercallPage = hv_context.hypercall_page;
+	u32 control_hi = control >> 32;
+	u32 control_lo = control & 0xFFFFFFFF;
+	u32 hv_status_hi = 1;
+	u32 hv_status_lo = 1;
+	u64 input_address = (input) ? virt_to_phys(input) : 0;
+	u32 input_address_hi = input_address >> 32;
+	u32 input_address_lo = input_address & 0xFFFFFFFF;
+	u64 output_address = (output) ? virt_to_phys(output) : 0;
+	u32 output_address_hi = output_address >> 32;
+	u32 output_address_lo = output_address & 0xFFFFFFFF;
+	volatile void *hypercall_page = hv_context.hypercall_page;
 
 	DPRINT_DBG(VMBUS, "Hypercall <control %llx input %p output %p>",
-		   Control, Input, Output);
+		   control, input, output);
 
-	__asm__ __volatile__ ("call *%8" : "=d"(hvStatusHi),
-			      "=a"(hvStatusLo) : "d" (controlHi),
-			      "a" (controlLo), "b" (inputAddressHi),
-			      "c" (inputAddressLo), "D"(outputAddressHi),
-			      "S"(outputAddressLo), "m" (hypercallPage));
+	__asm__ __volatile__ ("call *%8" : "=d"(hv_status_hi),
+			      "=a"(hv_status_lo) : "d" (control_hi),
+			      "a" (control_lo), "b" (input_address_hi),
+			      "c" (input_address_lo), "D"(output_address_hi),
+			      "S"(output_address_lo), "m" (hypercall_page));
 
 	DPRINT_DBG(VMBUS, "Hypercall <return %llx>",
-		   hvStatusLo | ((u64)hvStatusHi << 32));
+		   hv_status_lo | ((u64)hv_status_hi << 32));
 
-	return hvStatusLo | ((u64)hvStatusHi << 32);
+	return hv_status_lo | ((u64)hv_status_hi << 32);
 #endif /* !x86_64 */
 }
 
@@ -188,9 +188,9 @@ static u64 HvDoHypercall(u64 Control, void *Input, void *Output)
 int HvInit(void)
 {
 	int ret = 0;
-	int maxLeaf;
-	union hv_x64_msr_hypercall_contents hypercallMsr;
-	void *virtAddr = NULL;
+	int max_leaf;
+	union hv_x64_msr_hypercall_contents hypercall_msr;
+	void *virtaddr = NULL;
 
 	memset(hv_context.synic_event_page, 0, sizeof(void *) * MAX_NUM_CPUS);
 	memset(hv_context.synic_message_page, 0,
@@ -204,7 +204,7 @@ int HvInit(void)
 	DPRINT_INFO(VMBUS,
 		    "Windows hypervisor detected! Retrieving more info...");
 
-	maxLeaf = HvQueryHypervisorInfo();
+	max_leaf = HvQueryHypervisorInfo();
 	/* HvQueryHypervisorFeatures(maxLeaf); */
 
 	/*
@@ -223,39 +223,39 @@ int HvInit(void)
 	hv_context.guestid = HV_LINUX_GUEST_ID;
 
 	/* See if the hypercall page is already set */
-	rdmsrl(HV_X64_MSR_HYPERCALL, hypercallMsr.as_uint64);
+	rdmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
 
 	/*
 	* Allocate the hypercall page memory
-	* virtAddr = osd_PageAlloc(1);
+	* virtaddr = osd_PageAlloc(1);
 	*/
-	virtAddr = osd_VirtualAllocExec(PAGE_SIZE);
+	virtaddr = osd_VirtualAllocExec(PAGE_SIZE);
 
-	if (!virtAddr) {
+	if (!virtaddr) {
 		DPRINT_ERR(VMBUS,
 			   "unable to allocate hypercall page!!");
 		goto Cleanup;
 	}
 
-	hypercallMsr.enable = 1;
+	hypercall_msr.enable = 1;
 
-	hypercallMsr.guest_physical_address = vmalloc_to_pfn(virtAddr);
-	wrmsrl(HV_X64_MSR_HYPERCALL, hypercallMsr.as_uint64);
+	hypercall_msr.guest_physical_address = vmalloc_to_pfn(virtaddr);
+	wrmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
 
 	/* Confirm that hypercall page did get setup. */
-	hypercallMsr.as_uint64 = 0;
-	rdmsrl(HV_X64_MSR_HYPERCALL, hypercallMsr.as_uint64);
+	hypercall_msr.as_uint64 = 0;
+	rdmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
 
-	if (!hypercallMsr.enable) {
+	if (!hypercall_msr.enable) {
 		DPRINT_ERR(VMBUS, "unable to set hypercall page!!");
 		goto Cleanup;
 	}
 
-	hv_context.hypercall_page = virtAddr;
+	hv_context.hypercall_page = virtaddr;
 
 	DPRINT_INFO(VMBUS, "Hypercall page VA=%p, PA=0x%0llx",
 		    hv_context.hypercall_page,
-		    (u64)hypercallMsr.guest_physical_address << PAGE_SHIFT);
+		    (u64)hypercall_msr.guest_physical_address << PAGE_SHIFT);
 
 	/* Setup the global signal event param for the signal event hypercall */
 	hv_context.signal_event_buffer =
@@ -278,13 +278,13 @@ int HvInit(void)
 	return ret;
 
 Cleanup:
-	if (virtAddr) {
-		if (hypercallMsr.enable) {
-			hypercallMsr.as_uint64 = 0;
-			wrmsrl(HV_X64_MSR_HYPERCALL, hypercallMsr.as_uint64);
+	if (virtaddr) {
+		if (hypercall_msr.enable) {
+			hypercall_msr.as_uint64 = 0;
+			wrmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
 		}
 
-		vfree(virtAddr);
+		vfree(virtaddr);
 	}
 	ret = -1;
 	return ret;
@@ -297,15 +297,15 @@ Cleanup:
  */
 void HvCleanup(void)
 {
-	union hv_x64_msr_hypercall_contents hypercallMsr;
+	union hv_x64_msr_hypercall_contents hypercall_msr;
 
 	kfree(hv_context.signal_event_buffer);
 	hv_context.signal_event_buffer = NULL;
 	hv_context.signal_event_param = NULL;
 
 	if (hv_context.hypercall_page) {
-		hypercallMsr.as_uint64 = 0;
-		wrmsrl(HV_X64_MSR_HYPERCALL, hypercallMsr.as_uint64);
+		hypercall_msr.as_uint64 = 0;
+		wrmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
 		vfree(hv_context.hypercall_page);
 		hv_context.hypercall_page = NULL;
 	}
@@ -316,35 +316,35 @@ void HvCleanup(void)
  *
  * This involves a hypercall.
  */
-u16 HvPostMessage(union hv_connection_id connectionId,
-		  enum hv_message_type messageType,
-		  void *payload, size_t payloadSize)
+u16 HvPostMessage(union hv_connection_id connection_id,
+		  enum hv_message_type message_type,
+		  void *payload, size_t payload_size)
 {
-	struct alignedInput {
+	struct aligned_input {
 		u64 alignment8;
 		struct hv_input_post_message msg;
 	};
 
-	struct hv_input_post_message *alignedMsg;
+	struct hv_input_post_message *aligned_msg;
 	u16 status;
 	unsigned long addr;
 
-	if (payloadSize > HV_MESSAGE_PAYLOAD_BYTE_COUNT)
+	if (payload_size > HV_MESSAGE_PAYLOAD_BYTE_COUNT)
 		return -1;
 
-	addr = (unsigned long)kmalloc(sizeof(struct alignedInput), GFP_ATOMIC);
+	addr = (unsigned long)kmalloc(sizeof(struct aligned_input), GFP_ATOMIC);
 	if (!addr)
 		return -1;
 
-	alignedMsg = (struct hv_input_post_message *)
+	aligned_msg = (struct hv_input_post_message *)
 			(ALIGN_UP(addr, HV_HYPERCALL_PARAM_ALIGN));
 
-	alignedMsg->connectionid = connectionId;
-	alignedMsg->message_type = messageType;
-	alignedMsg->payload_size = payloadSize;
-	memcpy((void *)alignedMsg->payload, payload, payloadSize);
+	aligned_msg->connectionid = connection_id;
+	aligned_msg->message_type = message_type;
+	aligned_msg->payload_size = payload_size;
+	memcpy((void *)aligned_msg->payload, payload, payload_size);
 
-	status = HvDoHypercall(HVCALL_POST_MESSAGE, alignedMsg, NULL) & 0xFFFF;
+	status = HvDoHypercall(HVCALL_POST_MESSAGE, aligned_msg, NULL) & 0xFFFF;
 
 	kfree((void *)addr);
 
@@ -379,10 +379,10 @@ void HvSynicInit(void *irqarg)
 	u64 version;
 	union hv_synic_simp simp;
 	union hv_synic_siefp siefp;
-	union hv_synic_sint sharedSint;
+	union hv_synic_sint shared_sint;
 	union hv_synic_scontrol sctrl;
 
-	u32 irqVector = *((u32 *)(irqarg));
+	u32 irq_vector = *((u32 *)(irqarg));
 	int cpu = smp_processor_id();
 
 	if (!hv_context.hypercall_page)
@@ -436,17 +436,17 @@ void HvSynicInit(void *irqarg)
 	/*	  interceptionSint.as_uint64); */
 
 	/* Setup the shared SINT. */
-	rdmsrl(HV_X64_MSR_SINT0 + VMBUS_MESSAGE_SINT, sharedSint.as_uint64);
+	rdmsrl(HV_X64_MSR_SINT0 + VMBUS_MESSAGE_SINT, shared_sint.as_uint64);
 
-	sharedSint.as_uint64 = 0;
-	sharedSint.vector = irqVector; /* HV_SHARED_SINT_IDT_VECTOR + 0x20; */
-	sharedSint.masked = false;
-	sharedSint.auto_eoi = true;
+	shared_sint.as_uint64 = 0;
+	shared_sint.vector = irq_vector; /* HV_SHARED_SINT_IDT_VECTOR + 0x20; */
+	shared_sint.masked = false;
+	shared_sint.auto_eoi = true;
 
 	DPRINT_DBG(VMBUS, "HV_X64_MSR_SINT1 msr set to: %llx",
-		   sharedSint.as_uint64);
+		   shared_sint.as_uint64);
 
-	wrmsrl(HV_X64_MSR_SINT0 + VMBUS_MESSAGE_SINT, sharedSint.as_uint64);
+	wrmsrl(HV_X64_MSR_SINT0 + VMBUS_MESSAGE_SINT, shared_sint.as_uint64);
 
 	/* Enable the global synic bit */
 	rdmsrl(HV_X64_MSR_SCONTROL, sctrl.as_uint64);
@@ -471,7 +471,7 @@ Cleanup:
  */
 void HvSynicCleanup(void *arg)
 {
-	union hv_synic_sint sharedSint;
+	union hv_synic_sint shared_sint;
 	union hv_synic_simp simp;
 	union hv_synic_siefp siefp;
 	int cpu = smp_processor_id();
@@ -479,13 +479,13 @@ void HvSynicCleanup(void *arg)
 	if (!hv_context.synic_initialized)
 		return;
 
-	rdmsrl(HV_X64_MSR_SINT0 + VMBUS_MESSAGE_SINT, sharedSint.as_uint64);
+	rdmsrl(HV_X64_MSR_SINT0 + VMBUS_MESSAGE_SINT, shared_sint.as_uint64);
 
-	sharedSint.masked = 1;
+	shared_sint.masked = 1;
 
 	/* Need to correctly cleanup in the case of SMP!!! */
 	/* Disable the interrupt */
-	wrmsrl(HV_X64_MSR_SINT0 + VMBUS_MESSAGE_SINT, sharedSint.as_uint64);
+	wrmsrl(HV_X64_MSR_SINT0 + VMBUS_MESSAGE_SINT, shared_sint.as_uint64);
 
 	rdmsrl(HV_X64_MSR_SIMP, simp.as_uint64);
 	simp.simp_enabled = 0;
-- 
1.6.3.2

