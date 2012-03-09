Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab2CINUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 08:20:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58624 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab2CINUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 08:20:48 -0500
Date: Fri, 9 Mar 2012 05:20:19 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-225ce53910edc3c2322b1e4f2ed049a9196cd0b3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1328826068-11713-3-git-send-email-eranian@google.com>
References: <1328826068-11713-3-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/hw-branch-sampling] perf/x86:
  Add Intel LBR MSR definitions
Git-Commit-ID: 225ce53910edc3c2322b1e4f2ed049a9196cd0b3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Mar 2012 05:20:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  225ce53910edc3c2322b1e4f2ed049a9196cd0b3
Gitweb:     http://git.kernel.org/tip/225ce53910edc3c2322b1e4f2ed049a9196cd0b3
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 9 Feb 2012 23:20:52 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Mar 2012 14:55:39 +0100

perf/x86: Add Intel LBR MSR definitions

This patch adds the LBR definitions for NHM/WSM/SNB and Core.
It also adds the definitions for the architected LBR MSR:
LBR_SELECT, LBRT_TOS.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1328826068-11713-3-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
