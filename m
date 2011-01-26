Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab1AZMqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 07:46:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:57977 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693Ab1AZMqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 07:46:15 -0500
Date: Wed, 26 Jan 2011 12:45:44 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110122044852.102126037@google.com>
References: <20110122044852.102126037@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Avoid expensive initial update_cfs_load(), on UP too
Message-ID: <tip-2d65333ab09b9a11722d822231c85b9f251cfe9d@git.kernel.org>
Git-Commit-ID: 2d65333ab09b9a11722d822231c85b9f251cfe9d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 12:45:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2d65333ab09b9a11722d822231c85b9f251cfe9d
Gitweb:     http://git.kernel.org/tip/2d65333ab09b9a11722d822231c85b9f251cfe9d
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 26 Jan 2011 13:36:03 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Jan 2011 13:43:55 +0100

sched: Avoid expensive initial update_cfs_load(), on UP too

Fix the build on UP.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>
LKML-Reference: <20110122044852.102126037@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3fc5749..1f6ca89 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7931,8 +7931,10 @@ static void init_cfs_rq(struct cfs_rq *cfs_rq, struct rq *rq)
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	cfs_rq->rq = rq;
 	/* allow initial update_cfs_load() to truncate */
+#ifdef CONFIG_SMP
 	cfs_rq->load_stamp = 1;
 #endif
+#endif
 	cfs_rq->min_vruntime = (u64)(-(1LL << 20));
 }
 
