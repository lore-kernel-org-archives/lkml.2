Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab2JEJHQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 05:07:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33071 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab2JEJHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 05:07:09 -0400
Date: Fri, 5 Oct 2012 02:06:46 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-c4b35351ef3145c9abad64999d1de0de1b8361ab@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, asharma@fb.com
In-Reply-To: <1349354994-17853-9-git-send-email-namhyung@kernel.org>
References: <1349354994-17853-9-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf hists: Move he->stat.
 nr_events initialization to a template
Git-Commit-ID: c4b35351ef3145c9abad64999d1de0de1b8361ab
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 02:06:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c4b35351ef3145c9abad64999d1de0de1b8361ab
Gitweb:     http://git.kernel.org/tip/c4b35351ef3145c9abad64999d1de0de1b8361ab
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 4 Oct 2012 21:49:42 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 4 Oct 2012 13:35:14 -0300

perf hists: Move he->stat.nr_events initialization to a template

Since it is set to 1 for a new hist entry, no need to set to separately.
Move it to a template entry.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1349354994-17853-9-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 3197f3f..02476cb 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -223,7 +223,7 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 
 	if (he != NULL) {
 		*he = *template;
-		he->stat.nr_events = 1;
+
 		if (he->ms.map)
 			he->ms.map->referenced = true;
 		if (symbol_conf.use_callchain)
@@ -323,6 +323,7 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 		.level	= al->level,
 		.stat = {
 			.period	= period,
+			.nr_events = 1,
 		},
 		.parent = sym_parent,
 		.filtered = symbol__parent_filter(sym_parent),
@@ -348,6 +349,7 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 		.level	= al->level,
 		.stat = {
 			.period	= period,
+			.nr_events = 1,
 		},
 		.parent = sym_parent,
 		.filtered = symbol__parent_filter(sym_parent),
