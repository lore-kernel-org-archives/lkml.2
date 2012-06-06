Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab2FFNYH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 09:24:07 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:45295 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab2FFNXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 09:23:09 -0400
MIME-Version: 1.0
Date: Wed, 6 Jun 2012 21:23:08 +0800
Message-ID: <CAJd=RBCZL0ZkqsZJq4ydqn4gsDoDZmT8so_z8S1bJu_E58pvDQ@mail.gmail.com>
Subject: [patch] BFS 421: confine for_each_domain to SMP
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lets trap the insane build.


--- a/kernel/sched/bfs.c	Wed Jun  6 20:56:22 2012
+++ b/kernel/sched/bfs.c	Wed Jun  6 21:01:00 2012
@@ -324,7 +324,6 @@ int __weak arch_sd_sibling_asym_packing(
 {
        return 0*SD_ASYM_PACKING;
 }
-#endif

 #define rcu_dereference_check_sched_domain(p) \
 	rcu_dereference_check((p), \
@@ -339,6 +338,9 @@ int __weak arch_sd_sibling_asym_packing(
  */
 #define for_each_domain(cpu, __sd) \
 	for (__sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd);
__sd; __sd = __sd->parent)
+#else
+#define for_each_domain(cpu, __sd)	BUILD_BUG()
+#endif

 static inline void update_rq_clock(struct rq *rq);

--
