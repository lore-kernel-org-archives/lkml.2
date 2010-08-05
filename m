Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934361Ab0HEU2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:28:08 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:58153 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934348Ab0HEU1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:27:53 -0400
Date: Thu, 5 Aug 2010 22:27:51 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 36/42] tools/perf: Adjust confusing if indentation
Message-ID: <Pine.LNX.4.64.1008052227330.31692@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Outdent the code following the if.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r disable braces4@
position p1,p2;
statement S1,S2;
@@

(
if (...) { ... }
|
if (...) S1@p1 S2@p2
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

if (p1[0].column == p2[0].column):
  cocci.print_main("branch",p1)
  cocci.print_secs("after",p2)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
This patch does not change the semantics.  But it might not be the correct
fix either.

 tools/perf/builtin-timechart.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 5161619..9bcc38f 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -455,8 +455,8 @@ static void sched_switch(int cpu, u64 timestamp, struct trace_entry *te)
 		if (p->current->state != TYPE_NONE)
 			pid_put_sample(sw->next_pid, p->current->state, cpu, p->current->state_since, timestamp);
 
-			p->current->state_since = timestamp;
-			p->current->state = TYPE_RUNNING;
+		p->current->state_since = timestamp;
+		p->current->state = TYPE_RUNNING;
 	}
 
 	if (prev_p->current) {
