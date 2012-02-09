Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab2BIW1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 17:27:36 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53325 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758607Ab2BIWWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 17:22:38 -0500
MIME-Version: 1.0
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, ravitillo@lbl.gov, vweaver1@eecs.utk.edu,
        khandual@linux.vnet.ibm.com, dsahern@gmail.com
Subject: [PATCH v6 02/18] perf: add Intel LBR MSR definitions
Date: Thu,  9 Feb 2012 23:20:52 +0100
Message-Id: <1328826068-11713-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1328826068-11713-1-git-send-email-eranian@google.com>
References: <1328826068-11713-1-git-send-email-eranian@google.com>
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
index a6962d9..ccb8059 100644
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
index 309d0cc..6710a51 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -203,23 +203,23 @@ void intel_pmu_lbr_read(void)
 void intel_pmu_lbr_init_core(void)
 {
 	x86_pmu.lbr_nr     = 4;
-	x86_pmu.lbr_tos    = 0x01c9;
-	x86_pmu.lbr_from   = 0x40;
-	x86_pmu.lbr_to     = 0x60;
+	x86_pmu.lbr_tos    = MSR_LBR_TOS;
+	x86_pmu.lbr_from   = MSR_LBR_CORE_FROM;
+	x86_pmu.lbr_to     = MSR_LBR_CORE_TO;
 }
 
 void intel_pmu_lbr_init_nhm(void)
 {
 	x86_pmu.lbr_nr     = 16;
-	x86_pmu.lbr_tos    = 0x01c9;
-	x86_pmu.lbr_from   = 0x680;
-	x86_pmu.lbr_to     = 0x6c0;
+	x86_pmu.lbr_tos    = MSR_LBR_TOS;
+	x86_pmu.lbr_from   = MSR_LBR_NHM_FROM;
+	x86_pmu.lbr_to     = MSR_LBR_NHM_TO;
 }
 
 void intel_pmu_lbr_init_atom(void)
 {
 	x86_pmu.lbr_nr	   = 8;
-	x86_pmu.lbr_tos    = 0x01c9;
-	x86_pmu.lbr_from   = 0x40;
-	x86_pmu.lbr_to     = 0x60;
+	x86_pmu.lbr_tos    = MSR_LBR_TOS;
+	x86_pmu.lbr_from   = MSR_LBR_CORE_FROM;
+	x86_pmu.lbr_to     = MSR_LBR_CORE_TO;
 }
-- 
1.7.4.1

