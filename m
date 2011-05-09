Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab1EIVra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:47:30 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47753
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752014Ab1EIVoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:55 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 121/206] Staging: hv: Change Cleanup to cleanup
Date: Mon,  9 May 2011 14:56:43 -0700
Message-Id: <1304978288-22999-121-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject line says it all.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/hv.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/hv/hv.c b/drivers/staging/hv/hv.c
index e0c2861..2efac38 100644
--- a/drivers/staging/hv/hv.c
+++ b/drivers/staging/hv/hv.c
@@ -161,7 +161,7 @@ int hv_init(void)
 	       sizeof(void *) * MAX_NUM_CPUS);
 
 	if (!query_hypervisor_presence())
-		goto Cleanup;
+		goto cleanup;
 
 	max_leaf = query_hypervisor_info();
 	/* HvQueryHypervisorFeatures(maxLeaf); */
@@ -172,7 +172,7 @@ int hv_init(void)
 	rdmsrl(HV_X64_MSR_GUEST_OS_ID, hv_context.guestid);
 
 	if (hv_context.guestid != 0)
-		goto Cleanup;
+		goto cleanup;
 
 	/* Write our OS info */
 	wrmsrl(HV_X64_MSR_GUEST_OS_ID, HV_LINUX_GUEST_ID);
@@ -188,7 +188,7 @@ int hv_init(void)
 	virtaddr = __vmalloc(PAGE_SIZE, GFP_KERNEL, PAGE_KERNEL_EXEC);
 
 	if (!virtaddr)
-		goto Cleanup;
+		goto cleanup;
 
 	hypercall_msr.enable = 1;
 
@@ -200,7 +200,7 @@ int hv_init(void)
 	rdmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
 
 	if (!hypercall_msr.enable)
-		goto Cleanup;
+		goto cleanup;
 
 	hv_context.hypercall_page = virtaddr;
 
@@ -209,7 +209,7 @@ int hv_init(void)
 			kmalloc(sizeof(struct hv_input_signal_event_buffer),
 				GFP_KERNEL);
 	if (!hv_context.signal_event_buffer)
-		goto Cleanup;
+		goto cleanup;
 
 	hv_context.signal_event_param =
 		(struct hv_input_signal_event *)
@@ -224,7 +224,7 @@ int hv_init(void)
 
 	return ret;
 
-Cleanup:
+cleanup:
 	if (virtaddr) {
 		if (hypercall_msr.enable) {
 			hypercall_msr.as_uint64 = 0;
@@ -345,7 +345,7 @@ void hv_synic_init(void *irqarg)
 
 	if (hv_context.synic_message_page[cpu] == NULL) {
 		pr_err("Unable to allocate SYNIC message page\n");
-		goto Cleanup;
+		goto cleanup;
 	}
 
 	hv_context.synic_event_page[cpu] =
@@ -353,7 +353,7 @@ void hv_synic_init(void *irqarg)
 
 	if (hv_context.synic_event_page[cpu] == NULL) {
 		pr_err("Unable to allocate SYNIC event page\n");
-		goto Cleanup;
+		goto cleanup;
 	}
 
 	/* Setup the Synic's message page */
@@ -391,7 +391,7 @@ void hv_synic_init(void *irqarg)
 	hv_context.synic_initialized = true;
 	return;
 
-Cleanup:
+cleanup:
 	if (hv_context.synic_event_page[cpu])
 		free_page((unsigned long)hv_context.synic_event_page[cpu]);
 
-- 
1.7.4.1

