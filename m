Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab0FIKPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:15:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:41391 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757439Ab0FIKPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:15:43 -0400
Date: Wed, 9 Jun 2010 10:15:13 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, trace: Remove superfluous rcu_read_lock()
Message-ID: <tip-8ed92280be013180e24c84456ab6babcb07037cc@git.kernel.org>
Git-Commit-ID: 8ed92280be013180e24c84456ab6babcb07037cc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Jun 2010 10:15:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8ed92280be013180e24c84456ab6babcb07037cc
Gitweb:     http://git.kernel.org/tip/8ed92280be013180e24c84456ab6babcb07037cc
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 21 May 2010 15:13:59 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Jun 2010 11:12:33 +0200

perf, trace: Remove superfluous rcu_read_lock()

__DO_TRACE() already calls the callbacks under rcu_read_lock_sched(),
which is sufficient for our needs, avoid doing it again.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 4bd3b59..b39bec3 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4613,12 +4613,10 @@ void perf_tp_event(u64 addr, u64 count, void *record, int entry_size,
 	perf_sample_data_init(&data, addr);
 	data.raw = &raw;
 
-	rcu_read_lock();
 	hlist_for_each_entry_rcu(event, node, head, hlist_entry) {
 		if (perf_tp_event_match(event, &data, regs))
 			perf_swevent_add(event, count, 1, &data, regs);
 	}
-	rcu_read_unlock();
 
 	perf_swevent_put_recursion_context(rctx);
 }
