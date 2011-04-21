Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab1DUJYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 05:24:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:41955 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778Ab1DUJYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 05:24:41 -0400
Date: Thu, 21 Apr 2011 09:24:09 GMT
From: tip-bot for Arun Sharma <asharma@fb.com>
Message-ID: <tip-qimdcdpekjqxuyqovy4kjusx@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, asharma@fb.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        tzanussi@gmail.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu, asharma@fb.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Add support for PERF_TYPE_RAW
Git-Commit-ID: 0817a6a3a4fc7c069111083351ca33a78da2a0c9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Apr 2011 09:24:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0817a6a3a4fc7c069111083351ca33a78da2a0c9
Gitweb:     http://git.kernel.org/tip/0817a6a3a4fc7c069111083351ca33a78da2a0c9
Author:     Arun Sharma <asharma@fb.com>
AuthorDate: Thu, 14 Apr 2011 10:38:18 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 19 Apr 2011 11:08:58 -0300

perf script: Add support for PERF_TYPE_RAW

Useful for getting stack traces for hardware events not handled by
PERF_TYPE_HARDWARE.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Arun Sharma <asharma@fb.com>
Link: http://lkml.kernel.org/n/tip-qimdcdpekjqxuyqovy4kjusx@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 6cf811a..b3012c4 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -82,6 +82,16 @@ static struct {
 				  PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
 				  PERF_OUTPUT_EVNAME | PERF_OUTPUT_TRACE,
 	},
+
+	[PERF_TYPE_RAW] = {
+		.user_set = false,
+
+		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
+			      PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
+			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_SYM,
+
+		.invalid_fields = PERF_OUTPUT_TRACE,
+	},
 };
 
 static bool output_set_by_user(void)
@@ -502,6 +512,8 @@ static int parse_output_fields(const struct option *opt __used,
 			type = PERF_TYPE_SOFTWARE;
 		else if (!strcmp(str, "trace"))
 			type = PERF_TYPE_TRACEPOINT;
+		else if (!strcmp(str, "raw"))
+			type = PERF_TYPE_RAW;
 		else {
 			fprintf(stderr, "Invalid event type in field string.\n");
 			return -EINVAL;
@@ -902,7 +914,7 @@ static const struct option options[] = {
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
 	OPT_CALLBACK('f', "fields", NULL, "str",
-		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace. Fields: comm,tid,pid,time,cpu,event,trace,sym",
+		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,sym",
 		     parse_output_fields),
 
 	OPT_END()
