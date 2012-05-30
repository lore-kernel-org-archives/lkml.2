Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab2E3Jw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 05:52:28 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:17644 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab2E3Jv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 05:51:59 -0400
From: Glauber Costa <glommer@parallels.com>
To: <linux-kernel@vger.kernel.org>
Cc: <cgroups@vger.kernel.org>, <devel@openvz.org>,
        Paul Turner <pjt@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tejun Heo <tj@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
        handai.szj@gmail.com, Andrew.Phillips@lmax.com,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH v3 5/6] Also record sleep start for a task group
Date: Wed, 30 May 2012 13:48:36 +0400
Message-Id: <1338371317-5980-6-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1338371317-5980-1-git-send-email-glommer@parallels.com>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we're dealing with a task group, instead of a task, also record
the start of its sleep time. Since the test agains TASK_UNINTERRUPTIBLE
does not really make sense and lack an obvious analogous, we always
record it as sleep_start, never block_start.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Turner <pjt@google.com>
---
 kernel/sched/fair.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c26fe38..d932559 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1182,7 +1182,8 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 				se->statistics.sleep_start = rq_of(cfs_rq)->clock;
 			if (tsk->state & TASK_UNINTERRUPTIBLE)
 				se->statistics.block_start = rq_of(cfs_rq)->clock;
-		}
+		} else
+			se->statistics.sleep_start = rq_of(cfs_rq)->clock;
 #endif
 	}
 
-- 
1.7.10.2

