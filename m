Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab2JEJAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 05:00:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32944 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab2JEJAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 05:00:37 -0400
Date: Fri, 5 Oct 2012 02:00:09 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-ae359f193a80e19166efaed7d400d1476057b865@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <1349354994-17853-2-git-send-email-namhyung@kernel.org>
References: <1349354994-17853-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf hists:
  Add struct hists pointer to struct hist_entry
Git-Commit-ID: ae359f193a80e19166efaed7d400d1476057b865
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 02:00:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ae359f193a80e19166efaed7d400d1476057b865
Gitweb:     http://git.kernel.org/tip/ae359f193a80e19166efaed7d400d1476057b865
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 4 Oct 2012 21:49:35 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 4 Oct 2012 13:27:00 -0300

perf hists: Add struct hists pointer to struct hist_entry

Adding pointer back to the parent struct hists for struct hists_entry.

This will be useful in future for any hist_entry's data computation,
that depends on total data of its parent hists.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1349354994-17853-2-git-send-email-namhyung@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |    2 ++
 tools/perf/util/sort.h |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

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
 
