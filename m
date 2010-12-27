Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab0L0PiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 10:38:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:1480 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142Ab0L0PiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 10:38:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,234,1291622400"; 
   d="scan'208";a="640775713"
Subject: [PATCH 6/7] perf: Use MSR names in the extra reg lists
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Dec 2010 23:38:16 +0800
Message-Id: <1293464296.2695.107.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MSR names is much more readable.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/include/asm/msr-index.h       |    3 +++
 arch/x86/kernel/cpu/perf_event_intel.c |    9 ++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 6b89f5e..c3c42b1 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -47,6 +47,9 @@
 #define MSR_IA32_MCG_STATUS		0x0000017a
 #define MSR_IA32_MCG_CTL		0x0000017b
 
+#define MSR_OFFCORE_RSP_0		0x000001a6
+#define MSR_OFFCORE_RSP_1		0x000001a7
+
 #define MSR_IA32_PEBS_ENABLE		0x000003f1
 #define MSR_IA32_DS_AREA		0x00000600
 #define MSR_IA32_PERF_CAPABILITIES	0x00000345
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index ad70c2c..0a67425 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -88,7 +88,8 @@ static struct event_constraint intel_nehalem_event_constraints[] =
 
 static struct extra_reg intel_nehalem_extra_regs[] =
 {
-	INTEL_EVENT_EXTRA_REG(0xb7, 0x1a6, 0xffff, 32), /* OFFCORE_RESPONSE */
+	/* OFFCORE_RESPONSE */
+	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff, 32),
 	EVENT_EXTRA_END
 };
 
@@ -112,8 +113,10 @@ static struct event_constraint intel_westmere_event_constraints[] =
 
 static struct extra_reg intel_westmere_extra_regs[] =
 {
-	INTEL_EVENT_EXTRA_REG(0xb7, 0x1a6, 0xffff, 32), /* OFFCORE_RESPONSE_0 */
-	INTEL_EVENT_EXTRA_REG(0xbb, 0x1a7, 0xffff, 32), /* OFFCORE_RESPONSE_1 */
+	/* OFFCORE_RESPONSE_0 */
+	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff, 32),
+	/* OFFCORE_RESPONSE_1 */
+	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0xffff, 32),
 	EVENT_EXTRA_END
 };
 
-- 
1.7.3





