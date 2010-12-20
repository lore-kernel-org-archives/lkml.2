Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab0LTIiC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 03:38:02 -0500
Received: from hera.kernel.org ([140.211.167.34]:57811 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398Ab0LTIiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 03:38:00 -0500
Date: Mon, 20 Dec 2010 08:37:31 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <AANLkTinJ8hAG1TpyC+CSYPR47p48+1=E7fiC45hMXT_1@mail.gmail.com>
References: <AANLkTinJ8hAG1TpyC+CSYPR47p48+1=E7fiC45hMXT_1@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Remove debugging check
Message-ID: <tip-050c6c9b896625d9fa498265be17b82c5fc65257@git.kernel.org>
Git-Commit-ID: 050c6c9b896625d9fa498265be17b82c5fc65257
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 20 Dec 2010 08:37:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  050c6c9b896625d9fa498265be17b82c5fc65257
Gitweb:     http://git.kernel.org/tip/050c6c9b896625d9fa498265be17b82c5fc65257
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 19 Dec 2010 23:24:27 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 19 Dec 2010 23:24:27 +0100

sched: Remove debugging check

Linus reported that the new warning introduced by commit f26f9aff6aaf
"Sched: fix skip_clock_update optimization" triggers. The need_resched
flag can be set by other CPUs asynchronously so this debug check is
bogus - remove it.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <AANLkTinJ8hAG1TpyC+CSYPR47p48+1=E7fiC45hMXT_1@mail.gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 456c990..297d1a0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4128,7 +4128,6 @@ need_resched_nonpreemptible:
 		rq->nr_switches++;
 		rq->curr = next;
 		++*switch_count;
-		WARN_ON_ONCE(test_tsk_need_resched(next));
 
 		context_switch(rq, prev, next); /* unlocks the rq */
 		/*
