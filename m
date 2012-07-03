Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab2GCPsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 11:48:47 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:39256 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab2GCPsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 11:48:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/4] xen/perf: Define .glob for the different hypercalls.
Date: Tue,  3 Jul 2012 11:40:36 -0400
Message-Id: <1341330038-21686-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1341330038-21686-1-git-send-email-konrad.wilk@oracle.com>
References: <1341330038-21686-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us in perf to have this:

 99.67%  [kernel]             [k] xen_hypercall_sched_op
  0.11%  [kernel]             [k] xen_hypercall_xen_version

instead of the borring ever-encompassing:

 99.13%  [kernel]              [k] hypercall_page

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/xen-head.S |  102 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 100 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index aaa7291..f6ba51d 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -28,9 +28,107 @@ ENTRY(startup_xen)
 	__FINIT
 
 .pushsection .text
-	.align PAGE_SIZE
+	.balign PAGE_SIZE
 ENTRY(hypercall_page)
-	.skip PAGE_SIZE
+ENTRY(xen_hypercall_set_trap_table)
+	.skip 32
+ENTRY(xen_hypercall_mmu_update)
+	.skip 32
+ENTRY(xen_hypercall_set_gdt)
+	.skip 32
+ENTRY(xen_hypercall_stack_switch)
+	.skip 32
+ENTRY(xen_hypercall_set_callbacks)
+	.skip 32
+ENTRY(xen_hypercall_fpu_taskswitch)
+	.skip 32
+ENTRY(xen_hypercall_sched_op_compat)
+	.skip 32
+ENTRY(xen_hypercall_platform_op)
+	.skip 32
+ENTRY(xen_hypercall_set_debugreg)
+	.skip 32
+ENTRY(xen_hypercall_get_debugreg)
+	.skip 32
+ENTRY(xen_hypercall_update_descriptor)
+	.skip 32
+ENTRY(xen_hypercall_ni)
+	.skip 32
+ENTRY(xen_hypercall_memory_op)
+	.skip 32
+ENTRY(xen_hypercall_multicall)
+	.skip 32
+ENTRY(xen_hypercall_update_va_mapping)
+	.skip 32
+ENTRY(xen_hypercall_set_timer_op)
+	.skip 32
+ENTRY(xen_hypercall_event_channel_op_compat)
+	.skip 32
+ENTRY(xen_hypercall_xen_version)
+	.skip 32
+ENTRY(xen_hypercall_console_io)
+	.skip 32
+ENTRY(xen_hypercall_physdev_op_compat)
+	.skip 32
+ENTRY(xen_hypercall_grant_table_op)
+	.skip 32
+ENTRY(xen_hypercall_vm_assist)
+	.skip 32
+ENTRY(xen_hypercall_update_va_mapping_otherdomain)
+	.skip 32
+ENTRY(xen_hypercall_iret)
+	.skip 32
+ENTRY(xen_hypercall_vcpu_op)
+	.skip 32
+ENTRY(xen_hypercall_set_segment_base)
+	.skip 32
+ENTRY(xen_hypercall_mmuext_op)
+	.skip 32
+ENTRY(xen_hypercall_xsm_op)
+	.skip 32
+ENTRY(xen_hypercall_nmi_op)
+	.skip 32
+ENTRY(xen_hypercall_sched_op)
+	.skip 32
+ENTRY(xen_hypercall_callback_op)
+	.skip 32
+ENTRY(xen_hypercall_xenoprof_op)
+	.skip 32
+ENTRY(xen_hypercall_event_channel_op)
+	.skip 32
+ENTRY(xen_hypercall_physdev_op)
+	.skip 32
+ENTRY(xen_hypercall_hvm_op)
+	.skip 32
+ENTRY(xen_hypercall_sysctl)
+	.skip 32
+ENTRY(xen_hypercall_domctl)
+	.skip 32
+ENTRY(xen_hypercall_kexec_op)
+	.skip 32
+ENTRY(xen_hypercall_tmem_op) /* 38 */
+	.skip 32
+ENTRY(xen_hypercall_rsvr)
+	.skip 320
+ENTRY(xen_hypercall_mca) /* 48 */
+	.skip 32
+ENTRY(xen_hypercall_arch_1)
+	.skip 32
+ENTRY(xen_hypercall_arch_2)
+	.skip 32
+ENTRY(xen_hypercall_arch_3)
+	.skip 32
+ENTRY(xen_hypercall_arch_4)
+	.skip 32
+ENTRY(xen_hypercall_arch_5)
+	.skip 32
+ENTRY(xen_hypercall_arch_6)
+	.skip 32
+ENTRY(xen_hypercall_arch_7)
+	.skip 32
+ENTRY(xen_hypercall_other)
+	.skip 2272
+
 .popsection
 
 	ELFNOTE(Xen, XEN_ELFNOTE_GUEST_OS,       .asciz "linux")
-- 
1.7.7.6

