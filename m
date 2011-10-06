Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964958Ab1JFOtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 10:49:52 -0400
Received: from smtp-out.google.com ([74.125.121.67]:22940 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964946Ab1JFOtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 10:49:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:date:message-id:x-mailer:
	in-reply-to:references:x-system-of-record;
	b=ILSzHHRw66/N3Nko7+04+lCm+Sei679wFNZJRj5FZKL8Q4MohyieMiT3+kmMtkB7V
	fBwSc99m/7HFLtlAUEvqQ==
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, ming.m.lin@intel.com,
        andi@firstfloor.org, robert.richter@amd.com, ravitillo@lbl.gov
Subject: [PATCH 02/12] perf_events: add Intel LBR MSR definitions
Date: Thu,  6 Oct 2011 16:49:05 +0200
Message-Id: <1317912555-9559-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1317912555-9559-1-git-send-email-eranian@google.com>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the LBR definitions for NHM/WSM/SNB and Core.
It also adds the definitions for the architected LBR MSR:
LBR_SELECT, LBRT_TOS.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/include/asm/msr-index.h           |    7 +++++++
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |   18 +++++++++---------
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index d52609a..e8f5fbf 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -56,6 +56,13 @@
 #define MSR_OFFCORE_RSP_0		0x000001a6
 #define MSR_OFFCORE_RSP_1		0x000001a7
 
+#define MSR_LBR_SELECT			0x000001c8
+#define MSR_LBR_TOS			0x000001c9
+#define MSR_LBR_NHM_FROM		0x00000680
+#define MSR_LBR_NHM_TO			0x000006c0
+#define MSR_LBR_CORE_FROM		0x00000040
+#define MSR_LBR_CORE_TO			0x00000060
+
 #define MSR_IA32_PEBS_ENABLE		0x000003f1
 #define MSR_IA32_DS_AREA		0x00000600
 #define MSR_IA32_PERF_CAPABILITIES	0x00000345
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 528287a..e8a6851 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -199,25 +199,25 @@ static void intel_pmu_lbr_read(void)
 static void intel_pmu_lbr_init_core(void)
 {
 	x86_pmu.lbr_nr     = 4;
-	x86_pmu.lbr_tos    = 0x01c9;
-	x86_pmu.lbr_from   = 0x40;
-	x86_pmu.lbr_to     = 0x60;
+	x86_pmu.lbr_tos    = MSR_LBR_TOS;
+	x86_pmu.lbr_from   = MSR_LBR_CORE_FROM;
+	x86_pmu.lbr_to     = MSR_LBR_CORE_TO;
 }
 
 static void intel_pmu_lbr_init_nhm(void)
 {
 	x86_pmu.lbr_nr     = 16;
-	x86_pmu.lbr_tos    = 0x01c9;
-	x86_pmu.lbr_from   = 0x680;
-	x86_pmu.lbr_to     = 0x6c0;
+	x86_pmu.lbr_tos    = MSR_LBR_TOS;
+	x86_pmu.lbr_from   = MSR_LBR_NHM_FROM;
+	x86_pmu.lbr_to     = MSR_LBR_NHM_TO;
 }
 
 static void intel_pmu_lbr_init_atom(void)
 {
 	x86_pmu.lbr_nr	   = 8;
-	x86_pmu.lbr_tos    = 0x01c9;
-	x86_pmu.lbr_from   = 0x40;
-	x86_pmu.lbr_to     = 0x60;
+	x86_pmu.lbr_tos    = MSR_LBR_TOS;
+	x86_pmu.lbr_from   = MSR_LBR_CORE_FROM;
+	x86_pmu.lbr_to     = MSR_LBR_CORE_TO;
 }
 
 #endif /* CONFIG_CPU_SUP_INTEL */
-- 
1.7.4.1

