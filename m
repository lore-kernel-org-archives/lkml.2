Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab2AHLse (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 06:48:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39185 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab2AHLsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 06:48:33 -0500
Date: Sun, 8 Jan 2012 03:48:05 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-k0d0rq9a8nqtkqohov8cir72@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Don'
 t update total_period on process_sample
Git-Commit-ID: df25f989a4390ca0dbc9cb24516d4b10c01ceda8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 08 Jan 2012 03:48:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  df25f989a4390ca0dbc9cb24516d4b10c01ceda8
Gitweb:     http://git.kernel.org/tip/df25f989a4390ca0dbc9cb24516d4b10c01ceda8
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 5 Jan 2012 12:21:08 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 6 Jan 2012 15:46:50 -0200

perf top: Don't update total_period on process_sample

It will be recalculated at __hists__output_resort, to take into account
filters possibly applied by the TUI, etc.

Since we do the percent math only for those entries that will appear on
the TUI instead of for _all_ the entries at decay time, updating it for
each sample makes the entries seem to decay faster when using the
navigation keys (since the screen will be refreshed), as we're not
coalescing the entries that are being batched to be merged at next
resort/decay time, but considering their periods.

Bug introduced in 743eb86.

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-k0d0rq9a8nqtkqohov8cir72@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 4f81eeb..d89dec9 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -235,7 +235,6 @@ static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 	if (he == NULL)
 		return NULL;
 
-	evsel->hists.stats.total_period += sample->period;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
 	return he;
 }
