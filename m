Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab1KRXlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:41:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53472 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab1KRXlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:41:44 -0500
Date: Fri, 18 Nov 2011 15:41:27 -0800
From: tip-bot for Paul Turner <pjt@google.com>
Message-ID: <tip-fccfdc6f0d8c83c854eeb6d93aa158f0e551bd49@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20111108042736.623812423@google.com>
References: <20111108042736.623812423@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix buglet in return_cfs_rq_runtime()
Git-Commit-ID: fccfdc6f0d8c83c854eeb6d93aa158f0e551bd49
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:41:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fccfdc6f0d8c83c854eeb6d93aa158f0e551bd49
Gitweb:     http://git.kernel.org/tip/fccfdc6f0d8c83c854eeb6d93aa158f0e551bd49
Author:     Paul Turner <pjt@google.com>
AuthorDate: Mon, 7 Nov 2011 20:26:34 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Nov 2011 08:43:45 +0100

sched: Fix buglet in return_cfs_rq_runtime()

In return_cfs_rq_runtime() we want to return bandwidth when there are no
remaining tasks, not "return" when this is the case.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20111108042736.623812423@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index ba0e1f4..a78ed27 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1756,7 +1756,7 @@ static void __return_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 
 static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
-	if (!cfs_rq->runtime_enabled || !cfs_rq->nr_running)
+	if (!cfs_rq->runtime_enabled || cfs_rq->nr_running)
 		return;
 
 	__return_cfs_rq_runtime(cfs_rq);
