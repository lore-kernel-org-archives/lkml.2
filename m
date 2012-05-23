Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720Ab2EWP2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:28:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40955 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933518Ab2EWP2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:28:34 -0400
Date: Wed, 23 May 2012 08:28:11 -0700
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-2eeaaa095d155d47d47d5df07571105b8ae76ffd@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1337081295-10303-4-git-send-email-eranian@google.com>
References: <1337081295-10303-4-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  rename HEADER_TRACE_INFO to HEADER_TRACING_DATA
Git-Commit-ID: 2eeaaa095d155d47d47d5df07571105b8ae76ffd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 23 May 2012 08:28:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2eeaaa095d155d47d47d5df07571105b8ae76ffd
Gitweb:     http://git.kernel.org/tip/2eeaaa095d155d47d47d5df07571105b8ae76ffd
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 15 May 2012 13:28:13 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 22 May 2012 12:57:46 -0300

perf tools: rename HEADER_TRACE_INFO to HEADER_TRACING_DATA

To match the PERF_RECORD_HEADER_TRACING_DATA record type.

This is the same info as the one used for pipe mode whereas the other
one is for regular file output. This will help in the later patch to add
meta-data infos in pipe mode.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1337081295-10303-4-git-send-email-eranian@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    4 ++--
 tools/perf/util/header.c    |   10 +++++-----
 tools/perf/util/header.h    |    2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 8a3dfac..9c76add 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -396,7 +396,7 @@ static void perf_record__mmap_read_all(struct perf_record *rec)
 			perf_record__mmap_read(rec, &rec->evlist->mmap[i]);
 	}
 
-	if (perf_header__has_feat(&rec->session->header, HEADER_TRACE_INFO))
+	if (perf_header__has_feat(&rec->session->header, HEADER_TRACING_DATA))
 		write_output(rec, &finished_round_event, sizeof(finished_round_event));
 }
 
@@ -478,7 +478,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		perf_header__clear_feat(&session->header, HEADER_BUILD_ID);
 
 	if (!have_tracepoints(&evsel_list->entries))
-		perf_header__clear_feat(&session->header, HEADER_TRACE_INFO);
+		perf_header__clear_feat(&session->header, HEADER_TRACING_DATA);
 
 	if (!rec->opts.branch_stack)
 		perf_header__clear_feat(&session->header, HEADER_BRANCH_STACK);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 5385980..2dd5edf 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -437,7 +437,7 @@ static bool perf_session__read_build_ids(struct perf_session *session, bool with
 	return ret;
 }
 
-static int write_trace_info(int fd, struct perf_header *h __used,
+static int write_tracing_data(int fd, struct perf_header *h __used,
 			    struct perf_evlist *evlist)
 {
 	return read_tracing_data(fd, &evlist->entries);
@@ -1472,7 +1472,7 @@ out:
 	return err;
 }
 
-static int process_trace_info(struct perf_file_section *section __unused,
+static int process_tracing_data(struct perf_file_section *section __unused,
 			      struct perf_header *ph __unused,
 			      int feat __unused, int fd)
 {
@@ -1508,11 +1508,11 @@ struct feature_ops {
 		.full_only = true }
 
 /* feature_ops not implemented: */
-#define print_trace_info		NULL
-#define print_build_id			NULL
+#define print_tracing_data	NULL
+#define print_build_id		NULL
 
 static const struct feature_ops feat_ops[HEADER_LAST_FEATURE] = {
-	FEAT_OPP(HEADER_TRACE_INFO,	trace_info),
+	FEAT_OPP(HEADER_TRACING_DATA,	tracing_data),
 	FEAT_OPP(HEADER_BUILD_ID,	build_id),
 	FEAT_OPA(HEADER_HOSTNAME,	hostname),
 	FEAT_OPA(HEADER_OSRELEASE,	osrelease),
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 21a6be0..2d42b3e 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -12,7 +12,7 @@
 enum {
 	HEADER_RESERVED		= 0,	/* always cleared */
 	HEADER_FIRST_FEATURE	= 1,
-	HEADER_TRACE_INFO	= 1,
+	HEADER_TRACING_DATA	= 1,
 	HEADER_BUILD_ID,
 
 	HEADER_HOSTNAME,
