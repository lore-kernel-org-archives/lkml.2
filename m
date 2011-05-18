Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279Ab1ERRJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 13:09:55 -0400
Received: from smtp-out.google.com ([74.125.121.67]:24038 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932791Ab1ERRJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 13:09:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=d/Wrs07Wnf8Ql3g6JXXvT17CrF6StK9POxaeLj7e8rUW739G5TjDsLe2+1qwB8EZk
	/XbdBNdWIsbXDoXpv6zGA==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>,
        Nikhil Rao <ncrao@google.com>
Subject: [PATCH v2 1/3] sched: cleanup set_load_weight()
Date: Wed, 18 May 2011 10:09:38 -0700
Message-Id: <1305738580-9924-2-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1305738580-9924-1-git-send-email-ncrao@google.com>
References: <1305738580-9924-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid using long repetitious names; make this simpler and nicer to read. No
functional change introduced in this patch.

Signed-off-by: Nikhil Rao <ncrao@google.com>
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
-- 
1.7.3.1

