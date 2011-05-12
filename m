Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab1ELO2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:28:23 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51509 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab1ELO2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:28:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=FjweMi6kV6D+9/nGEjMQqE9nTNzSoAmbyCwWm0NhXRfK1UEY+EU/B1VAXzXYmMdnik
         GR9cdL0qHF6mLQ6o2Cj1xLL6QIh3/4p/6rvIa5RQ1taosrB+Pjq/DLv0dCcsWjRZepeI
         meYQr69Ik+3P6dj70GcV+F/5Y4u16JFqDBnUI=
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
To: mingo@elte.hu
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sched: remove unused variable
Date: Thu, 12 May 2011 11:28:36 -0300
Message-Id: <1305210516-1653-1-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove variable that is set but not used, cleaning GCC warning.

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
---
 kernel/sched.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 312f8b9..66319fd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8553,7 +8553,6 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 {
 	struct rt_rq *rt_rq;
 	struct sched_rt_entity *rt_se;
-	struct rq *rq;
 	int i;
 
 	tg->rt_rq = kzalloc(sizeof(rt_rq) * nr_cpu_ids, GFP_KERNEL);
@@ -8567,8 +8566,6 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 			ktime_to_ns(def_rt_bandwidth.rt_period), 0);
 
 	for_each_possible_cpu(i) {
-		rq = cpu_rq(i);
-
 		rt_rq = kzalloc_node(sizeof(struct rt_rq),
 				     GFP_KERNEL, cpu_to_node(i));
 		if (!rt_rq)
-- 
1.7.5.1

