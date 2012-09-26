Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674Ab2IZRSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:18:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:10407 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757618Ab2IZRSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:18:43 -0400
X-IronPort-AV: E=Sophos;i="4.80,492,1344182400"; 
   d="scan'208";a="5922249"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 05/12] workqueue: don't wake up other workers in rescuer
Date: Thu, 27 Sep 2012 01:20:36 +0800
Message-Id: <1348680043-5077-6-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
References: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 01:18:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 01:18:45,
	Serialize complete at 2012/09/27 01:18:45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rescuer is NOT_RUNNING, so there is no sense when it wakes up other workers,
if there are available normal workers, they are already woken up when needed.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index c718b94..6c339bf 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2438,14 +2438,6 @@ repeat:
 
 		process_scheduled_works(rescuer);
 
-		/*
-		 * Leave this gcwq.  If keep_working() is %true, notify a
-		 * regular worker; otherwise, we end up with 0 concurrency
-		 * and stalling the execution.
-		 */
-		if (keep_working(pool))
-			wake_up_worker(pool);
-
 		spin_unlock_irq(&gcwq->lock);
 	}
 
-- 
1.7.7.6

