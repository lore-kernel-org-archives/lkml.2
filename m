Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab0H2PF5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 11:05:57 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:40389 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab0H2PFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 11:05:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vUJUJ5lDOzRRVjj9i9PqVvvdtwwzb9P3G6BtyoCIVlFj14m//V5sLNpxCvcmPn75M0
         6uWj9Xx+ZFqu07Cnj7Etp7p+A7xXTtADkFGsDgtpl9fKHLVPT8qd+1agdwx3LQPj1Usl
         jya0aDTJt8RQTo93AqgAm/fe6nn91x0kHEn0M=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, akpm@linux-foundation.org, mingo@elte.hu,
        arjan@linux.intel.com, a.p.zijlstra@chello.nl, tj@kernel.org,
        oleg@redhat.com
Subject: [RFC PATCH 2/6] workqueue: remove redundant timer_stats_timer_set_start_info()
Date: Sun, 29 Aug 2010 23:05:05 +0800
Message-Id: <1283094309-6635-3-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283094309-6635-1-git-send-email-yong.zhang0@gmail.com>
References: <1283094309-6635-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

No need to call timer_stats_timer_set_start_info() explicitly,
add_timer_on() and add_timer() have done the right job.

After this change, we can move timer_stats_timer_*_start_info()
from include/linux/timer.h to kernel/timer.c. Outsider should not
see those functions.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/workqueue.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 8bd600c..e87ffd7 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1094,8 +1094,6 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 		BUG_ON(timer_pending(timer));
 		BUG_ON(!list_empty(&work->entry));
 
-		timer_stats_timer_set_start_info(&dwork->timer);
-
 		/*
 		 * This stores cwq for the moment, for the timer_fn.
 		 * Note that the work's gcwq is preserved to allow
-- 
1.7.0.4

