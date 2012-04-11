Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab2DKJDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 05:03:34 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63047 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab2DKJD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 05:03:26 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, dsahern@gmail.com,
        namhyung.kim@lge.com
Subject: [PATCH 3/5] perf tools: rename HEADER_TRACE_INFO to HEADER_TRACING_DATA
Date: Wed, 11 Apr 2012 11:01:27 +0200
Message-Id: <1334134889-20312-4-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1334134889-20312-1-git-send-email-eranian@google.com>
References: <1334134889-20312-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To match the PERF_RECORD_HEADER_TRACING_DATA record type.
This is the same info as the one used for pipe mode whereas
the other one is for regular file output. This will help in
the later patch to add meta-data infos in pipe mode.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-record.c |    4 ++--
 tools/perf/util/header.c    |   10 +++++-----
 tools/perf/util/header.h    |    2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index be4e1ee..2a64679 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -389,7 +389,7 @@ static void perf_record__mmap_read_all(struct perf_record *rec)
 			perf_record__mmap_read(rec, &rec->evlist->mmap[i]);
 	}
 
-	if (perf_header__has_feat(&rec->session->header, HEADER_TRACE_INFO))
+	if (perf_header__has_feat(&rec->session->header, HEADER_TRACING_DATA))
 		write_output(rec, &finished_round_event, sizeof(finished_round_event));
 }
 
@@ -471,7 +471,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		perf_header__clear_feat(&session->header, HEADER_BUILD_ID);
 
 	if (!have_tracepoints(&evsel_list->entries))
-		perf_header__clear_feat(&session->header, HEADER_TRACE_INFO);
+		perf_header__clear_feat(&session->header, HEADER_TRACING_DATA);
 
 	if (!rec->opts.branch_stack)
 		perf_header__clear_feat(&session->header, HEADER_BRANCH_STACK);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 4c7c2d7..99af448 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -442,7 +442,7 @@ static bool perf_session__read_build_ids(struct perf_session *session, bool with
 	return ret;
 }
 
-static int write_trace_info(int fd, struct perf_header *h __used,
+static int write_tracing_data(int fd, struct perf_header *h __used,
 			    struct perf_evlist *evlist)
 {
 	return read_tracing_data(fd, &evlist->entries);
@@ -1477,7 +1477,7 @@ static int perf_header__read_build_ids(struct perf_header *header,
 	return err;
 }
 
-static int process_trace_info(struct perf_file_section *section __unused,
+static int process_tracing_data(struct perf_file_section *section __unused,
 			      struct perf_header *ph __unused,
 			      int feat __unused, int fd)
 {
@@ -1513,11 +1513,11 @@ struct feature_ops {
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
-- 
1.7.4.1

