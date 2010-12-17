Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab0LQMqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:46:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553Ab0LQMqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:46:06 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 01/15] GFS2: Change two WQ_RESCUERs into WQ_MEM_RECLAIM
Date: Fri, 17 Dec 2010 12:24:07 +0000
Message-Id: <1292588661-14350-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
References: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WQ_RESCUER flag should only be used internally to the
workqueue implementation.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index f92c177..5a56568 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1782,12 +1782,13 @@ int __init gfs2_glock_init(void)
 	}
 #endif
 
-	glock_workqueue = alloc_workqueue("glock_workqueue", WQ_RESCUER |
+	glock_workqueue = alloc_workqueue("glock_workqueue", WQ_MEM_RECLAIM |
 					  WQ_HIGHPRI | WQ_FREEZEABLE, 0);
 	if (IS_ERR(glock_workqueue))
 		return PTR_ERR(glock_workqueue);
-	gfs2_delete_workqueue = alloc_workqueue("delete_workqueue", WQ_RESCUER |
-						WQ_FREEZEABLE, 0);
+	gfs2_delete_workqueue = alloc_workqueue("delete_workqueue",
+						WQ_MEM_RECLAIM | WQ_FREEZEABLE,
+						0);
 	if (IS_ERR(gfs2_delete_workqueue)) {
 		destroy_workqueue(glock_workqueue);
 		return PTR_ERR(gfs2_delete_workqueue);
-- 
1.7.3.3

