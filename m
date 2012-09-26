Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702Ab2IZRSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:18:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:10407 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757661Ab2IZRSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:18:46 -0400
X-IronPort-AV: E=Sophos;i="4.80,492,1344182400"; 
   d="scan'208";a="5922254"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [RFC PATCH 11/12] workqueue: add WQ_CPU_INTENSIVE to system_long_wq
Date: Thu, 27 Sep 2012 01:20:42 +0800
Message-Id: <1348680043-5077-12-git-send-email-laijs@cn.fujitsu.com>
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

works in system_long_wq will be running long.
add WQ_CPU_INTENSIVE to system_long_wq to avoid these kinds of works occupy
the running wokers which delay the normal works.

if system_long_wq is designed for only sleep-long works, not running-long works,
this patch makes no sense.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 89fd1b2..ccb1d60 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3850,7 +3850,7 @@ static int __init init_workqueues(void)
 
 	system_wq = alloc_workqueue("events", 0, 0);
 	system_highpri_wq = alloc_workqueue("events_highpri", WQ_HIGHPRI, 0);
-	system_long_wq = alloc_workqueue("events_long", 0, 0);
+	system_long_wq = alloc_workqueue("events_long", WQ_CPU_INTENSIVE, 0);
 	system_unbound_wq = alloc_workqueue("events_unbound", WQ_UNBOUND,
 					    WQ_UNBOUND_MAX_ACTIVE);
 	system_freezable_wq = alloc_workqueue("events_freezable",
-- 
1.7.7.6

