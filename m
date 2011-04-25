Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220Ab1DYJlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 05:41:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35163 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758103Ab1DYJlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 05:41:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] cpumask: convert cpumask_of_cpu() with cpumask_of()
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20110425184245.2699.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon, 25 Apr 2011 18:41:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adapt the code to new api fashion. 

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/kthread.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 3b34d27..4102518 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -202,7 +202,7 @@ void kthread_bind(struct task_struct *p, unsigned int cpu)
 		return;
 	}
 
-	p->cpus_allowed = cpumask_of_cpu(cpu);
+	cpumask_copy(&p->cpus_allowed, cpumask_of(cpu));
 	p->rt.nr_cpus_allowed = 1;
 	p->flags |= PF_THREAD_BOUND;
 }
-- 
1.7.3.1



