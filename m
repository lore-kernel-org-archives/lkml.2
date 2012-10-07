Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab2JGCnt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 22:43:49 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:35064 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab2JGCnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 22:43:47 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 43/49] tools/power turbostat: make -M output pretty
Date: Sat,  6 Oct 2012 22:43:13 -0400
Message-Id: <130ff304f6d31484fc73bb337bc635cba1ffe04c.1349554106.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <1349577799-566-1-git-send-email-lenb@kernel.org>
References: <1349577799-566-1-git-send-email-lenb@kernel.org>
In-Reply-To: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
References: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

The -M option dumps the specified 64-bit MSR with every sample.

Previously it was output at the end of each line.
However, with the v2 style of printing, the lines are now staggered,
making MSR output hard to read.

So move the MSR output column to the left where things are aligned.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 tools/power/x86/turbostat/turbostat.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 5db4add..5ce88dd 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -223,6 +223,8 @@ void print_header(void)
 	if (has_aperf)
 		outp += sprintf(outp, "  GHz");
 	outp += sprintf(outp, "  TSC");
+	if (extra_msr_offset)
+		outp += sprintf(outp, "          MSR 0x%04X", extra_msr_offset);
 	if (do_nhm_cstates)
 		outp += sprintf(outp, "    %%c1");
 	if (do_nhm_cstates)
@@ -239,8 +241,6 @@ void print_header(void)
 		outp += sprintf(outp, "   %%pc6");
 	if (do_snb_cstates)
 		outp += sprintf(outp, "   %%pc7");
-	if (extra_msr_offset)
-		outp += sprintf(outp, "        MSR 0x%x ", extra_msr_offset);
 
 	outp += sprintf(outp, "\n");
 }
@@ -361,6 +361,10 @@ int format_counters(struct thread_data *t, struct core_data *c,
 	/* TSC */
 	outp += sprintf(outp, "%5.2f", 1.0 * t->tsc/units/interval_float);
 
+	/* MSR */
+	if (extra_msr_offset)
+		outp += sprintf(outp, "  0x%016llx", t->extra_msr);
+
 	if (do_nhm_cstates) {
 		if (!skip_c1)
 			outp += sprintf(outp, " %6.2f", 100.0 * t->c1/t->tsc);
@@ -392,8 +396,6 @@ int format_counters(struct thread_data *t, struct core_data *c,
 	if (do_snb_cstates)
 		outp += sprintf(outp, " %6.2f", 100.0 * p->pc7/t->tsc);
 done:
-	if (extra_msr_offset)
-		outp += sprintf(outp, "  0x%016llx", t->extra_msr);
 	outp += sprintf(outp, "\n");
 
 	return 0;
-- 
1.8.0.rc0.18.gf84667d

