Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170Ab0JRT2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:28:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:58893 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755040Ab0JRT2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:28:12 -0400
Date: Mon, 18 Oct 2010 19:27:36 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, venki@google.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
        venki@google.com
In-Reply-To: <1286237003-12406-3-git-send-email-venki@google.com>
References: <1286237003-12406-3-git-send-email-venki@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Export account_system_vtime()
Message-ID: <tip-b7dadc38797584f6203386da1947ed5edf516646@git.kernel.org>
Git-Commit-ID: b7dadc38797584f6203386da1947ed5edf516646
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Oct 2010 19:27:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b7dadc38797584f6203386da1947ed5edf516646
Gitweb:     http://git.kernel.org/tip/b7dadc38797584f6203386da1947ed5edf516646
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 18 Oct 2010 20:00:37 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 Oct 2010 20:52:30 +0200

sched: Export account_system_vtime()

KVM uses it for example:

 ERROR: "account_system_vtime" [arch/x86/kvm/kvm.ko] undefined!

Cc: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1286237003-12406-3-git-send-email-venki@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 567f5cb..5998222 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1991,6 +1991,7 @@ void account_system_vtime(struct task_struct *curr)
 
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL_GPL(account_system_vtime);
 
 static void sched_irq_time_avg_update(struct rq *rq, u64 curr_irq_time)
 {
