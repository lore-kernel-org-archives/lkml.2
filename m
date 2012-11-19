Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab2KSFdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:33:23 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:32818 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab2KSFdS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:33:18 -0500
X-Originating-IP: 217.70.178.142
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 56/58] sched: Only define init_cfs_bandwidth stub when CONFIG_FAIR_GROUP_SCHED=y
Date: Sun, 18 Nov 2012 21:28:35 -0800
Message-Id: <1353302917-13995-57-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/sched/fair.c defines a stub version of init_cfs_bandwidth when
CONFIG_CFS_BANDWIDTH=n.  A few other places in the scheduler call
init_cfs_bandwidth, but only when CONFIG_FAIR_GROUP_SCHED=y, and
kernel/sched/sched.h only prototypes init_cfs_bandwidth when
CONFIG_FAIR_GROUP_SCHED=y.  Wrap the stub in an ifdef
CONFIG_FAIR_GROUP_SCHED as well, to avoid defining it when not needed,
and to satisfy GCC (-Wmissing-prototypes) and Sparse (-Wdecl).

kernel/sched/fair.c:2098:6: warning: no previous prototype for ‘init_cfs_bandwidth’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/sched/fair.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7e29e80..0f03bf1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2095,9 +2095,8 @@ static inline int throttled_lb_pair(struct task_group *tg,
 	return 0;
 }
 
-void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
-
 #ifdef CONFIG_FAIR_GROUP_SCHED
+void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
 static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
 #endif
 
-- 
1.7.10.4

