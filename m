Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201Ab1E0Vpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 17:45:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:45725 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab1E0Vpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 17:45:45 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/5] perf tools: Make sure kptr_restrict warnings fit 80 col terms
Date: Fri, 27 May 2011 18:45:32 -0300
Message-Id: <1306532736-3790-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1306532736-3790-1-git-send-email-acme@infradead.org>
References: <1306532736-3790-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Suggested-by: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Link: http://lkml.kernel.org/n/tip-i1p8vrhq7xveyui6t1sc914e@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   19 ++++++++-----------
 tools/perf/builtin-report.c |   17 +++++++----------
 2 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 2ca107f..8e2c857 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -824,17 +824,14 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	symbol__init();
 
 	if (symbol_conf.kptr_restrict)
-		pr_warning("WARNING: Kernel address maps "
-			   "(/proc/{kallsyms,modules}) are restricted, "
-			   "check /proc/sys/kernel/kptr_restrict.\n\n"
-			   "Samples in kernel functions may not be resolved "
-			   "if a suitable vmlinux file is not found in the "
-			   "buildid cache or in the vmlinux path.\n\n"
-			   "Samples in kernel modules won't be resolved "
-			   "at all.\n\n"
-			   "If some relocation was applied (e.g. kexec) "
-			   "symbols may be misresolved even with a suitable "
-			   "vmlinux or kallsyms file.\n\n");
+		pr_warning(
+"WARNING: Kernel address maps (/proc/{kallsyms,modules}) are restricted,\n"
+"check /proc/sys/kernel/kptr_restrict.\n\n"
+"Samples in kernel functions may not be resolved if a suitable vmlinux\n"
+"file is not found in the buildid cache or in the vmlinux path.\n\n"
+"Samples in kernel modules won't be resolved at all.\n\n"
+"If some relocation was applied (e.g. kexec) symbols may be misresolved\n"
+"even with a suitable vmlinux or kallsyms file.\n\n");
 
 	if (no_buildid_cache || no_buildid)
 		disable_buildid_cache();
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 99156c3..287a173 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -281,17 +281,14 @@ static int __cmd_report(void)
 	      kernel_kmap->ref_reloc_sym->addr == 0))) {
 		const struct dso *kdso = kernel_map->dso;
 
-		ui__warning("Kernel address maps "
-			    "(/proc/{kallsyms,modules}) were restricted, "
-			    "check /proc/sys/kernel/kptr_restrict before "
-			    "running 'perf record'.\n\n%s\n\n"
-			    "Samples in kernel modules can't be resolved "
-			    "as well.\n\n",
+		ui__warning(
+"Kernel address maps (/proc/{kallsyms,modules}) were restricted.\n\n"
+"Check /proc/sys/kernel/kptr_restrict before running 'perf record'.\n\n%s\n\n"
+"Samples in kernel modules can't be resolved as well.\n\n",
 			    RB_EMPTY_ROOT(&kdso->symbols[MAP__FUNCTION]) ?
-			    "As no suitable kallsyms nor vmlinux was found, "
-			    "kernel samples can't be resolved." :
-			    "If some relocation was applied (e.g. kexec) "
-			    "symbols may be misresolved.");
+"As no suitable kallsyms nor vmlinux was found, kernel samples\n"
+"can't be resolved." :
+"If some relocation was applied (e.g. kexec) symbols may be misresolved.");
 	}
 
 	if (dump_trace) {
-- 
1.6.2.5

