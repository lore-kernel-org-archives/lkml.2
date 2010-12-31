Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab0LaOBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 09:01:20 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59595 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab0LaOBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 09:01:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=mOgfeGd7zH/5Quy49U3wi41A23zp1G1295XYhRc6fJI+BUKc0SW0Vtyzo1JBGMtri+
         W3To7eFrJRzCf48c+SUSbC7XjrmINCK3vyTrRKBktlR5hXsXpJqm+ALklOkVTv7ZakQ7
         nHIYoGmfVTjuynEcocIrKhnoJM8CiuDSxQS5w=
Date: Fri, 31 Dec 2010 15:01:09 +0100
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: dm-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>,
        Neil Brown <neilb@suse.de>
Subject: [PATCH wq#for-2.6.38] workqueue: use WQ_MEM_RECLAIM instead of
 WQ_RESCUER
Message-ID: <20101231140109.GL18831@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WQ_RESCUER is now an internal flag and should only be used in the
workqueue implementation proper.  Use WQ_MEM_RECLAIM instead.

This doesn't introduce any functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: dm-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Neil Brown <neilb@suse.de>
---
As this is trivial, I'd like to carry this through the wq tree if
there's no objection.

Thank you.

 drivers/md/md.c    |    2 +-
 fs/gfs2/glock.c    |    8 ++++----
 fs/nfs/inode.c     |    2 +-
 net/sunrpc/sched.c |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 84c46a1..66a01f7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7287,7 +7287,7 @@ static int __init md_init(void)
 {
 	int ret = -ENOMEM;
 
-	md_wq = alloc_workqueue("md", WQ_RESCUER, 0);
+	md_wq = alloc_workqueue("md", WQ_MEM_RECLAIM, 0);
 	if (!md_wq)
 		goto err_wq;
 
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index f92c177..beea184 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1782,12 +1782,12 @@ int __init gfs2_glock_init(void)
 	}
 #endif
 
-	glock_workqueue = alloc_workqueue("glock_workqueue", WQ_RESCUER |
-					  WQ_HIGHPRI | WQ_FREEZEABLE, 0);
+	glock_workqueue = alloc_workqueue("glock_workqueue",
+				WQ_MEM_RECLAIM | WQ_HIGHPRI | WQ_FREEZEABLE, 0);
 	if (IS_ERR(glock_workqueue))
 		return PTR_ERR(glock_workqueue);
-	gfs2_delete_workqueue = alloc_workqueue("delete_workqueue", WQ_RESCUER |
-						WQ_FREEZEABLE, 0);
+	gfs2_delete_workqueue = alloc_workqueue("delete_workqueue",
+					WQ_MEM_RECLAIM | WQ_FREEZEABLE, 0);
 	if (IS_ERR(gfs2_delete_workqueue)) {
 		destroy_workqueue(glock_workqueue);
 		return PTR_ERR(gfs2_delete_workqueue);
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 314f571..9403f3f 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1497,7 +1497,7 @@ static int nfsiod_start(void)
 {
 	struct workqueue_struct *wq;
 	dprintk("RPC:       creating workqueue nfsiod\n");
-	wq = alloc_workqueue("nfsiod", WQ_RESCUER, 0);
+	wq = alloc_workqueue("nfsiod", WQ_MEM_RECLAIM, 0);
 	if (wq == NULL)
 		return -ENOMEM;
 	nfsiod_workqueue = wq;
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 243fc09..2841cc6 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -908,7 +908,7 @@ static int rpciod_start(void)
 	 * Create the rpciod thread and wait for it to start.
 	 */
 	dprintk("RPC:       creating workqueue rpciod\n");
-	wq = alloc_workqueue("rpciod", WQ_RESCUER, 0);
+	wq = alloc_workqueue("rpciod", WQ_MEM_RECLAIM, 0);
 	rpciod_workqueue = wq;
 	return rpciod_workqueue != NULL;
 }
