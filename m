Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab1CWLOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 07:14:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33796 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab1CWLN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 07:13:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=TIv0i2XwPtT8+WM6dnJLbqU9WHfGO8ZMLKxILcsddFm1cScew9V2thqCC+EPbB6eJ1
         Y8X9ISGhaGDtPbwtBkbMwF3hTJ7cxv+6dSZA80YskBRipjKJLg6XGmJHEWeDox8R5wpB
         4KdbKrfGvvxLD60pAObmEcRYhxIPc+dHYKE54=
Date: Wed, 23 Mar 2011 13:17:23 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] sched: remove unused rq variable and cpu_rq call from
 alloc_fair_sched_group
Message-ID: <20110323111722.GA4244@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched: remove unused rq variable and cpu_rq call from alloc_fair_sched_group

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 kernel/sched.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index a172494..23c687e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8434,7 +8434,6 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se;
-	struct rq *rq;
 	int i;
 
 	tg->cfs_rq = kzalloc(sizeof(cfs_rq) * nr_cpu_ids, GFP_KERNEL);
@@ -8447,8 +8446,6 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 	tg->shares = NICE_0_LOAD;
 
 	for_each_possible_cpu(i) {
-		rq = cpu_rq(i);
-
 		cfs_rq = kzalloc_node(sizeof(struct cfs_rq),
 				      GFP_KERNEL, cpu_to_node(i));
 		if (!cfs_rq)

