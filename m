Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab0KRONL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:13:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:52163 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397Ab0KRONJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:13:09 -0500
Date: Thu, 18 Nov 2010 14:12:38 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20101115234938.204191702@google.com>
References: <20101115234938.204191702@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Update shares on idle_balance
Message-ID: <tip-c66eaf619c0c7937e9ded160ae83b5a7a6b19b56@git.kernel.org>
Git-Commit-ID: c66eaf619c0c7937e9ded160ae83b5a7a6b19b56
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Nov 2010 14:12:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c66eaf619c0c7937e9ded160ae83b5a7a6b19b56
Gitweb:     http://git.kernel.org/tip/c66eaf619c0c7937e9ded160ae83b5a7a6b19b56
Author:     Paul Turner <pjt@google.com>
AuthorDate: Mon, 15 Nov 2010 15:47:07 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Nov 2010 13:27:49 +0100

sched: Update shares on idle_balance

Since shares updates are no longer expensive and effectively local, update them
at idle_balance().  This allows us to more quickly redistribute shares to
another cpu when our load becomes idle.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20101115234938.204191702@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 6c84439..33f941d 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3343,6 +3343,7 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 	 */
 	raw_spin_unlock(&this_rq->lock);
 
+	update_shares(this_cpu);
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
 		int balance = 1;
