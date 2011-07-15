Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965446Ab1GOKle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 06:41:34 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:36677 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964982Ab1GOKld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 06:41:33 -0400
Subject: [PATCH] sched: reorder root_domain to remove 64 bit alignment
 padding
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>
Date: Fri, 15 Jul 2011 11:41:31 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1310726492.1977.5.camel@castor.rsk>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder root_domain to remove 8 bytes of alignment padding on 64 bit
builds, this shrinks the size from 1736 to 1728 bytes, therefore using
one fewer cachelines.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---

patch against v3.0-rc7

compiled & booted on x86_64.

I've been running this patch for 2 days without any obvious problems,
but I don't have any specific RT test cases.

regards
Richard



diff --git a/kernel/sched.c b/kernel/sched.c
index 9769c75..4ecf9db 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -422,6 +422,7 @@ struct rt_rq {
  */
 struct root_domain {
 	atomic_t refcount;
+	atomic_t rto_count;
 	struct rcu_head rcu;
 	cpumask_var_t span;
 	cpumask_var_t online;
@@ -431,7 +432,6 @@ struct root_domain {
 	 * one runnable RT task.
 	 */
 	cpumask_var_t rto_mask;
-	atomic_t rto_count;
 	struct cpupri cpupri;
 };
 


