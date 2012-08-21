Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab2HUQ0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:26:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32867 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757999Ab2HUQ0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:26:50 -0400
Date: Tue, 21 Aug 2012 09:26:32 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-6606f8733d7b635e09e2dc3a391a5e1f0feb218f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, jolsa@redhat.com,
        robert.richter@amd.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, robert.richter@amd.com, peterz@infradead.org,
        tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1345144224-27280-4-git-send-email-robert.richter@amd.com>
References: <1345144224-27280-4-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Rename some variables for better understanding
Git-Commit-ID: 6606f8733d7b635e09e2dc3a391a5e1f0feb218f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:26:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6606f8733d7b635e09e2dc3a391a5e1f0feb218f
Gitweb:     http://git.kernel.org/tip/6606f8733d7b635e09e2dc3a391a5e1f0feb218f
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Thu, 16 Aug 2012 21:10:19 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 17 Aug 2012 13:11:58 -0300

perf tools: Rename some variables for better understanding

Trivial patch to improve understanding of code.

Varible attr is usually used for struct perf_event_attr. Using it in a
different context is irritating. Thus, renaming it.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1345144224-27280-4-git-send-email-robert.richter@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |   42 +++++++++++++++++++++---------------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 471b0c4..e2e5129 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -608,11 +608,11 @@ static int write_nrcpus(int fd, struct perf_header *h __used,
 static int write_event_desc(int fd, struct perf_header *h __used,
 			    struct perf_evlist *evlist)
 {
-	struct perf_evsel *attr;
+	struct perf_evsel *evsel;
 	u32 nre = 0, nri, sz;
 	int ret;
 
-	list_for_each_entry(attr, &evlist->entries, node)
+	list_for_each_entry(evsel, &evlist->entries, node)
 		nre++;
 
 	/*
@@ -625,14 +625,14 @@ static int write_event_desc(int fd, struct perf_header *h __used,
 	/*
 	 * size of perf_event_attr struct
 	 */
-	sz = (u32)sizeof(attr->attr);
+	sz = (u32)sizeof(evsel->attr);
 	ret = do_write(fd, &sz, sizeof(sz));
 	if (ret < 0)
 		return ret;
 
-	list_for_each_entry(attr, &evlist->entries, node) {
+	list_for_each_entry(evsel, &evlist->entries, node) {
 
-		ret = do_write(fd, &attr->attr, sz);
+		ret = do_write(fd, &evsel->attr, sz);
 		if (ret < 0)
 			return ret;
 		/*
@@ -642,7 +642,7 @@ static int write_event_desc(int fd, struct perf_header *h __used,
 		 * copy into an nri to be independent of the
 		 * type of ids,
 		 */
-		nri = attr->ids;
+		nri = evsel->ids;
 		ret = do_write(fd, &nri, sizeof(nri));
 		if (ret < 0)
 			return ret;
@@ -650,13 +650,13 @@ static int write_event_desc(int fd, struct perf_header *h __used,
 		/*
 		 * write event string as passed on cmdline
 		 */
-		ret = do_write_string(fd, perf_evsel__name(attr));
+		ret = do_write_string(fd, perf_evsel__name(evsel));
 		if (ret < 0)
 			return ret;
 		/*
 		 * write unique ids for this event
 		 */
-		ret = do_write(fd, attr->id, attr->ids * sizeof(u64));
+		ret = do_write(fd, evsel->id, evsel->ids * sizeof(u64));
 		if (ret < 0)
 			return ret;
 	}
@@ -1683,7 +1683,7 @@ int perf_session__write_header(struct perf_session *session,
 	struct perf_file_header f_header;
 	struct perf_file_attr   f_attr;
 	struct perf_header *header = &session->header;
-	struct perf_evsel *attr, *pair = NULL;
+	struct perf_evsel *evsel, *pair = NULL;
 	int err;
 
 	lseek(fd, sizeof(f_header), SEEK_SET);
@@ -1691,9 +1691,9 @@ int perf_session__write_header(struct perf_session *session,
 	if (session->evlist != evlist)
 		pair = perf_evlist__first(session->evlist);
 
-	list_for_each_entry(attr, &evlist->entries, node) {
-		attr->id_offset = lseek(fd, 0, SEEK_CUR);
-		err = do_write(fd, attr->id, attr->ids * sizeof(u64));
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		evsel->id_offset = lseek(fd, 0, SEEK_CUR);
+		err = do_write(fd, evsel->id, evsel->ids * sizeof(u64));
 		if (err < 0) {
 out_err_write:
 			pr_debug("failed to write perf header\n");
@@ -1703,19 +1703,19 @@ out_err_write:
 			err = do_write(fd, pair->id, pair->ids * sizeof(u64));
 			if (err < 0)
 				goto out_err_write;
-			attr->ids += pair->ids;
+			evsel->ids += pair->ids;
 			pair = perf_evsel__next(pair);
 		}
 	}
 
 	header->attr_offset = lseek(fd, 0, SEEK_CUR);
 
-	list_for_each_entry(attr, &evlist->entries, node) {
+	list_for_each_entry(evsel, &evlist->entries, node) {
 		f_attr = (struct perf_file_attr){
-			.attr = attr->attr,
+			.attr = evsel->attr,
 			.ids  = {
-				.offset = attr->id_offset,
-				.size   = attr->ids * sizeof(u64),
+				.offset = evsel->id_offset,
+				.size   = evsel->ids * sizeof(u64),
 			}
 		};
 		err = do_write(fd, &f_attr, sizeof(f_attr));
@@ -2277,12 +2277,12 @@ int perf_event__synthesize_attrs(struct perf_tool *tool,
 				   struct perf_session *session,
 				   perf_event__handler_t process)
 {
-	struct perf_evsel *attr;
+	struct perf_evsel *evsel;
 	int err = 0;
 
-	list_for_each_entry(attr, &session->evlist->entries, node) {
-		err = perf_event__synthesize_attr(tool, &attr->attr, attr->ids,
-						  attr->id, process);
+	list_for_each_entry(evsel, &session->evlist->entries, node) {
+		err = perf_event__synthesize_attr(tool, &evsel->attr, evsel->ids,
+						  evsel->id, process);
 		if (err) {
 			pr_debug("failed to create perf header attribute\n");
 			return err;
