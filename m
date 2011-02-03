Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab1BCVKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:10:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:32934 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab1BCVKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:10:36 -0500
Date: Thu, 3 Feb 2011 21:10:02 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf stat: Fix aggreate counter reading accounting
Message-ID: <tip-52bcd9947bffae88bb1758f19277d678aaebc2ec@git.kernel.org>
Git-Commit-ID: 52bcd9947bffae88bb1758f19277d678aaebc2ec
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 03 Feb 2011 21:10:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  52bcd9947bffae88bb1758f19277d678aaebc2ec
Gitweb:     http://git.kernel.org/tip/52bcd9947bffae88bb1758f19277d678aaebc2ec
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 3 Feb 2011 17:26:06 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 3 Feb 2011 17:26:06 -0200

perf stat: Fix aggreate counter reading accounting

Introduced in: c52b12ed, when this sequence:

  count[0] = count[1] = count[2] = 0;

Was replaced with:

  aggr->val = 0;

Which is equivalent to zeroing just the first entry in the 'count'
array.

Fix it by zeroing the three entries with:

  aggr->val = aggr->ena = aggr->run = 0;

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index f5cfed6..d8575d3 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -90,7 +90,7 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 	int cpu, thread;
 	struct perf_counts_values *aggr = &evsel->counts->aggr, count;
 
-	aggr->val = 0;
+	aggr->val = aggr->ena = aggr->run = 0;
 
 	for (cpu = 0; cpu < ncpus; cpu++) {
 		for (thread = 0; thread < nthreads; thread++) {
