Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934616Ab1ETNnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:43:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:36186 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934097Ab1ETNnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:43:20 -0400
Date: Fri, 20 May 2011 13:43:00 GMT
From: tip-bot for Nikhil Rao <ncrao@google.com>
Message-ID: <tip-f05998d4b80632f2cc00f108da503066ef5d38d5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@redhat.com, ncrao@google.com, efault@gmx.de,
        peterz@infradead.org, nikunj@linux.vnet.ibm.com,
        stephan.baerwolf@tu-ilmenau.de, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, ncrao@google.com, peterz@infradead.org,
        efault@gmx.de, nikunj@linux.vnet.ibm.com,
        stephan.baerwolf@tu-ilmenau.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1305738580-9924-2-git-send-email-ncrao@google.com>
References: <1305738580-9924-2-git-send-email-ncrao@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Cleanup set_load_weight()
Git-Commit-ID: f05998d4b80632f2cc00f108da503066ef5d38d5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 20 May 2011 13:43:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f05998d4b80632f2cc00f108da503066ef5d38d5
Gitweb:     http://git.kernel.org/tip/f05998d4b80632f2cc00f108da503066ef5d38d5
Author:     Nikhil Rao <ncrao@google.com>
AuthorDate: Wed, 18 May 2011 10:09:38 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 May 2011 14:16:49 +0200

sched: Cleanup set_load_weight()

Avoid using long repetitious names; make this simpler and nicer
to read. No functional change introduced in this patch.

Signed-off-by: Nikhil Rao <ncrao@google.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>
Cc: Mike Galbraith <efault@gmx.de>
Link: http://lkml.kernel.org/r/1305738580-9924-2-git-send-email-ncrao@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index c62acf4..d036048 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1778,17 +1778,20 @@ static void dec_nr_running(struct rq *rq)
 
 static void set_load_weight(struct task_struct *p)
 {
+	int prio = p->static_prio - MAX_RT_PRIO;
+	struct load_weight *load = &p->se.load;
+
 	/*
 	 * SCHED_IDLE tasks get minimal weight:
 	 */
 	if (p->policy == SCHED_IDLE) {
-		p->se.load.weight = WEIGHT_IDLEPRIO;
-		p->se.load.inv_weight = WMULT_IDLEPRIO;
+		load->weight = WEIGHT_IDLEPRIO;
+		load->inv_weight = WMULT_IDLEPRIO;
 		return;
 	}
 
-	p->se.load.weight = prio_to_weight[p->static_prio - MAX_RT_PRIO];
-	p->se.load.inv_weight = prio_to_wmult[p->static_prio - MAX_RT_PRIO];
+	load->weight = prio_to_weight[prio];
+	load->inv_weight = prio_to_wmult[prio];
 }
 
 static void enqueue_task(struct rq *rq, struct task_struct *p, int flags)
