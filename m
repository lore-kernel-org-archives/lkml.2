Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab2I0LKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 07:10:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756167Ab2I0LKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 07:10:14 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 01/14] perf hists: Add struct hists pointer to struct hist_entry
Date: Thu, 27 Sep 2012 13:09:22 +0200
Message-Id: <1348744175-11115-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1348744175-11115-1-git-send-email-jolsa@redhat.com>
References: <1348744175-11115-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 tools/perf/util/hist.c | 2 ++
 tools/perf/util/sort.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 236bc9d..040f34c 100644
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
index 12d6347..eb3959b 100644
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
1.7.11.4

