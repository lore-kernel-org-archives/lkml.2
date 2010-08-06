Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935004Ab0HFRHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 13:07:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:42683 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934633Ab0HFRHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 13:07:31 -0400
Date: Fri, 6 Aug 2010 17:06:38 GMT
From: tip-bot for Julia Lawall <julia@diku.dk>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        julia@diku.dk, hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, julia@diku.dk, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <Pine.LNX.4.64.1008052227330.31692@ask.diku.dk>
References: <Pine.LNX.4.64.1008052227330.31692@ask.diku.dk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf timechart: Adjust confusing if indentation
Message-ID: <tip-33e26a1b492d21283d1372ddd547562d371dab98@git.kernel.org>
Git-Commit-ID: 33e26a1b492d21283d1372ddd547562d371dab98
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 06 Aug 2010 17:06:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  33e26a1b492d21283d1372ddd547562d371dab98
Gitweb:     http://git.kernel.org/tip/33e26a1b492d21283d1372ddd547562d371dab98
Author:     Julia Lawall <julia@diku.dk>
AuthorDate: Thu, 5 Aug 2010 22:27:51 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 5 Aug 2010 19:38:02 -0300

perf timechart: Adjust confusing if indentation

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

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <Pine.LNX.4.64.1008052227330.31692@ask.diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-timechart.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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
