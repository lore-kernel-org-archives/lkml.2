Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab1BTHIw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 02:08:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48039 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab1BTHIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 02:08:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QqZjIJmYZygpl5xXBkS0vf3qyF12EyH4ejxGQHoaLVDqwluKGHVXOuqr62FE2HBrXw
         QcGopdeOs7q01z0e80U1V20FPxpazh33qxPim5lwMbwHOMi0bACRM/1LneIZE+4DFn+R
         0CsCgCQx1Enme/zaacV4baK8cJWa2WpxnRwZA=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [PATCH 4/5] sched: refactor task_group()
Date: Sun, 20 Feb 2011 15:08:15 +0800
Message-Id: <1298185696-4403-5-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1298185696-4403-1-git-send-email-yong.zhang0@gmail.com>
References: <1298185696-4403-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move cgroup-related task group finding to cgroup_task_group().
No function change.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
---
 kernel/sched.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 18d38e4..5c74f79 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -601,7 +601,7 @@ static inline int cpu_of(struct rq *rq)
  * holds that lock for each task it moves into the cgroup. Therefore
  * by holding that lock, we pin the task to the current cgroup.
  */
-static inline struct task_group *task_group(struct task_struct *p)
+static inline struct task_group *cgroup_task_group(struct task_struct *p)
 {
 	struct task_group *tg;
 	struct cgroup_subsys_state *css;
@@ -613,6 +613,14 @@ static inline struct task_group *task_group(struct task_struct *p)
 			lockdep_is_held(&task_rq(p)->lock));
 	tg = container_of(css, struct task_group, css);
 
+	return tg;
+}
+
+static inline struct task_group *task_group(struct task_struct *p)
+{
+	struct task_group *tg;
+
+	tg = cgroup_task_group(p);
 	return autogroup_task_group(p, tg);
 }
 
-- 
1.7.1

