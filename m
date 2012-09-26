Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954Ab2IZRUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:20:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:12456 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757598Ab2IZRSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:18:44 -0400
X-IronPort-AV: E=Sophos;i="4.80,492,1344182400"; 
   d="scan'208";a="5922251"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 07/12] workqueue: remove WORKER_STARTED
Date: Thu, 27 Sep 2012 01:20:38 +0800
Message-Id: <1348680043-5077-8-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
References: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 01:18:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 01:18:46,
	Serialize complete at 2012/09/27 01:18:46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All newly created worker will enter idle soon,
WORKER_STARTED is not used any more, remove it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index fe3b1d3..d37f446 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -69,7 +69,6 @@ enum {
 	POOL_MANAGING_WORKERS   = 1 << 1,       /* managing workers */
 
 	/* worker flags */
-	WORKER_STARTED		= 1 << 0,	/* started */
 	WORKER_DIE		= 1 << 1,	/* die die die */
 	WORKER_IDLE		= 1 << 2,	/* is idle */
 	WORKER_PREP		= 1 << 3,	/* preparing to run works */
@@ -1838,7 +1837,6 @@ fail:
  */
 static void start_worker(struct worker *worker)
 {
-	worker->flags |= WORKER_STARTED;
 	worker->flags |= WORKER_PREP;
 	worker->pool->nr_workers++;
 	worker_enter_idle(worker);
@@ -1863,7 +1861,6 @@ static void destroy_worker(struct worker *worker)
 	/* sanity check frenzy */
 	BUG_ON(worker->current_work);
 	BUG_ON(!list_empty(&worker->scheduled));
-	BUG_ON(!(worker->flags & WORKER_STARTED));
 	BUG_ON(!(worker->flags & WORKER_IDLE));
 	BUG_ON(list_empty(&worker->entry));
 
-- 
1.7.7.6

