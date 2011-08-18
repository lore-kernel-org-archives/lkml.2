Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab1HRUN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 16:13:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:47039 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368Ab1HRUN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 16:13:57 -0400
Date: Thu, 18 Aug 2011 20:13:44 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-e71a059832753a8834a5a5080366879954ccdc4d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, daahern@cisco.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, daahern@cisco.com, mingo@elte.hu
In-Reply-To: <20110729232040.GA21838@quad>
References: <20110729232040.GA21838@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Add --symfs option
Git-Commit-ID: e71a059832753a8834a5a5080366879954ccdc4d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Thu, 18 Aug 2011 20:13:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e71a059832753a8834a5a5080366879954ccdc4d
Gitweb:     http://git.kernel.org/tip/e71a059832753a8834a5a5080366879954ccdc4d
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Sat, 30 Jul 2011 01:20:40 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 18 Aug 2011 07:40:34 -0300

perf annotate: Add --symfs option

If you have --symfs in perf report, then you also need it for perf
annotate.  This allows off-box assembly level analysis of perf.data
samples.

This patch complements:

commit ec5761eab318e50e69fcf8e63e9edaef5949c067
Author: David Ahern <daahern@cisco.com>
Date:   Thu Dec 9 13:27:07 2010 -0700

    perf symbols: Add symfs option for off-box analysis using specified tree

Acked-by: David Ahern <daahern@cisco.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Ahern <daahern@cisco.com>
Link: http://lkml.kernel.org/r/20110729232040.GA21838@quad
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-annotate.txt |    3 +++
 tools/perf/builtin-annotate.c              |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
index 5bc0600..98a31e3 100644
--- a/tools/perf/Documentation/perf-annotate.txt
+++ b/tools/perf/Documentation/perf-annotate.txt
@@ -80,6 +80,9 @@ OPTIONS
 	Interleave source code with assembly code. Enabled by default,
 	disable with --no-source.
 
+--symfs=<directory>::
+        Look for files with symbols relative to this directory.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-report[1]
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 5015e04..c5be288 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -267,6 +267,8 @@ static const struct option options[] = {
 	OPT_BOOLEAN('P', "full-paths", &full_paths,
 		    "Don't shorten the displayed pathnames"),
 	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
+	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
+		   "Look for files with symbols relative to this directory"),
 	OPT_BOOLEAN('0', "source", &symbol_conf.annotate_src,
 		    "Interleave source code with assembly code (default)"),
 	OPT_BOOLEAN('0', "asm-raw", &symbol_conf.annotate_asm_raw,
