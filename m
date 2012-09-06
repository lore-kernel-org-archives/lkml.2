Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751Ab2IFPsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:48:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758710Ab2IFPsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:48:36 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 03/12] perf hists: Add struct hists pointer to struct hist_entry
Date: Thu,  6 Sep 2012 17:46:57 +0200
Message-Id: <1346946426-13496-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
References: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding pointer back to the parent hists struct for struct hists_entry.

This will be useful in future for any hist_entry's data computation,
that depends on total data of its parent hists.

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/hist.c | 2 ++
 tools/perf/util/sort.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index b1817f1..0ed0683 100644
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
index e459c98..b0b4752 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -78,6 +78,7 @@ struct hist_entry {
 		struct rb_root	  sorted_chain;
 	};
 	struct branch_info	*branch_info;
+	struct hists		*hists;
 	struct callchain_root	callchain[0];
 };
 
-- 
1.7.11.4

