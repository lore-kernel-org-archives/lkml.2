Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab2FSSAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:00:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:43358 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab2FSSAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:00:31 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>,
        Benjamin Redelings <benjamin.redelings@nescent.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, Ulrich Drepper <drepper@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 18/20] perf tools: Remove unused evsel parameter from machine__resolve_callchain
Date: Tue, 19 Jun 2012 14:50:19 -0300
Message-Id: <1340128221-17348-19-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1340128221-17348-1-git-send-email-acme@infradead.org>
References: <1340128221-17348-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Removing unused evsel parameter from machine__resolve_callchain
function. Plus related header file and callers changes.

The evsel parameter is unused since following commit:
  perf callchain: Make callchain cursors TLS
  commit 472606458f3e1ced5fe3cc5f04e90a6b5a4732cf
  Author: Namhyung Kim <namhyung.kim@lge.com>
  Date:   Thu May 31 14:43:26 2012 +0900

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Benjamin Redelings <benjamin.redelings@nescent.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Ulrich Drepper <drepper@gmail.com>
Link: http://lkml.kernel.org/r/1339420814-7379-9-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    4 ++--
 tools/perf/builtin-script.c |    4 ++--
 tools/perf/builtin-top.c    |    2 +-
 tools/perf/util/map.h       |    2 +-
 tools/perf/util/session.c   |    7 +++----
 tools/perf/util/session.h   |    4 ++--
 6 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index ea8ce8e..40b0ffc 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -69,7 +69,7 @@ static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 
 	if ((sort__has_parent || symbol_conf.use_callchain)
 	    && sample->callchain) {
-		err = machine__resolve_callchain(machine, evsel, al->thread,
+		err = machine__resolve_callchain(machine, al->thread,
 						 sample->callchain, &parent);
 		if (err)
 			return err;
@@ -140,7 +140,7 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 	struct hist_entry *he;
 
 	if ((sort__has_parent || symbol_conf.use_callchain) && sample->callchain) {
-		err = machine__resolve_callchain(machine, evsel, al->thread,
+		err = machine__resolve_callchain(machine, al->thread,
 						 sample->callchain, &parent);
 		if (err)
 			return err;
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 8f9f9b6..8fecd3b 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -389,7 +389,7 @@ static void print_sample_bts(union perf_event *event,
 			printf(" ");
 		else
 			printf("\n");
-		perf_event__print_ip(event, sample, machine, evsel,
+		perf_event__print_ip(event, sample, machine,
 				     PRINT_FIELD(SYM), PRINT_FIELD(DSO),
 				     PRINT_FIELD(SYMOFFSET));
 	}
@@ -433,7 +433,7 @@ static void process_event(union perf_event *event __unused,
 			printf(" ");
 		else
 			printf("\n");
-		perf_event__print_ip(event, sample, machine, evsel,
+		perf_event__print_ip(event, sample, machine,
 				     PRINT_FIELD(SYM), PRINT_FIELD(DSO),
 				     PRINT_FIELD(SYMOFFSET));
 	}
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 8090a28..e3cab5f 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -774,7 +774,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
 
 		if ((sort__has_parent || symbol_conf.use_callchain) &&
 		    sample->callchain) {
-			err = machine__resolve_callchain(machine, evsel, al.thread,
+			err = machine__resolve_callchain(machine, al.thread,
 							 sample->callchain, &parent);
 			if (err)
 				return;
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 81371ba..c14c665 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -157,7 +157,7 @@ void machine__exit(struct machine *self);
 void machine__delete(struct machine *self);
 
 int machine__resolve_callchain(struct machine *machine,
-			       struct perf_evsel *evsel, struct thread *thread,
+			       struct thread *thread,
 			       struct ip_callchain *chain,
 			       struct symbol **parent);
 int maps__set_kallsyms_ref_reloc_sym(struct map **maps, const char *symbol_name,
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 582ee38..febc0ae 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -289,7 +289,6 @@ struct branch_info *machine__resolve_bstack(struct machine *self,
 }
 
 int machine__resolve_callchain(struct machine *self,
-			       struct perf_evsel *evsel __used,
 			       struct thread *thread,
 			       struct ip_callchain *chain,
 			       struct symbol **parent)
@@ -1480,8 +1479,8 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 }
 
 void perf_event__print_ip(union perf_event *event, struct perf_sample *sample,
-			  struct machine *machine, struct perf_evsel *evsel,
-			  int print_sym, int print_dso, int print_symoffset)
+			  struct machine *machine, int print_sym,
+			  int print_dso, int print_symoffset)
 {
 	struct addr_location al;
 	struct callchain_cursor_node *node;
@@ -1495,7 +1494,7 @@ void perf_event__print_ip(union perf_event *event, struct perf_sample *sample,
 
 	if (symbol_conf.use_callchain && sample->callchain) {
 
-		if (machine__resolve_callchain(machine, evsel, al.thread,
+		if (machine__resolve_callchain(machine, al.thread,
 						sample->callchain, NULL) != 0) {
 			if (verbose)
 				error("Failed to resolve callchain. Skipping\n");
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 7a5434c..877d781 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -150,8 +150,8 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 					    unsigned int type);
 
 void perf_event__print_ip(union perf_event *event, struct perf_sample *sample,
-			  struct machine *machine, struct perf_evsel *evsel,
-			  int print_sym, int print_dso, int print_symoffset);
+			  struct machine *machine, int print_sym,
+			  int print_dso, int print_symoffset);
 
 int perf_session__cpu_bitmap(struct perf_session *session,
 			     const char *cpu_list, unsigned long *cpu_bitmap);
-- 
1.7.1

