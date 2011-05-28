Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab1E1Pk1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 11:40:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:50219 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665Ab1E1PkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 11:40:25 -0400
Date: Sat, 28 May 2011 15:39:59 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-i1p8vrhq7xveyui6t1sc914e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Make sure kptr_restrict warnings fit 80 col terms
Git-Commit-ID: 646aaea615704010b5fd2c8c8891ff1a3a4b4f1a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 28 May 2011 15:40:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  646aaea615704010b5fd2c8c8891ff1a3a4b4f1a
Gitweb:     http://git.kernel.org/tip/646aaea615704010b5fd2c8c8891ff1a3a4b4f1a
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 27 May 2011 11:00:41 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 27 May 2011 16:02:09 -0300

perf tools: Make sure kptr_restrict warnings fit 80 col terms

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
