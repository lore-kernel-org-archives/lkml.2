Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab2JDMvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 08:51:13 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:57091 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab2JDMvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 08:51:09 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 01/20] perf hists: Add struct hists pointer to struct hist_entry
Date: Thu,  4 Oct 2012 21:49:35 +0900
Message-Id: <1349354994-17853-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1349354994-17853-1-git-send-email-namhyung@kernel.org>
References: <1349354994-17853-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding pointer back to the parent struct hists for struct hists_entry.

This will be useful in future for any hist_entry's data computation,
that depends on total data of its parent hists.

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c |    2 ++
 tools/perf/util/sort.h |    1 +
 2 files changed, 3 insertions(+)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 236bc9d98ff2..040f34c79a53 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -325,6 +325,7 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 		.parent = sym_parent,
 		.filtered = symbol__parent_filter(sym_parent),
 		.branch_info = bi,
+		.hists	= self,
 	};
 
 	return add_hist_entry(self, &entry, al, period);
@@ -346,6 +347,7 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 		.period	= period,
 		.parent = sym_parent,
 		.filtered = symbol__parent_filter(sym_parent),
+		.hists	= self,
 	};
 
 	return add_hist_entry(self, &entry, al, period);
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 12d634792de5..eb3959b8e9d9 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -79,6 +79,7 @@ struct hist_entry {
 		struct rb_root	  sorted_chain;
 	};
 	struct branch_info	*branch_info;
+	struct hists		*hists;
 	struct callchain_root	callchain[0];
 };
 
-- 
1.7.9.2

