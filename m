Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab1COJee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:34:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756833Ab1COJeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:34:31 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 15/15] GFS2: Don't use _raw version of RCU dereference
Date: Tue, 15 Mar 2011 09:11:45 +0000
Message-Id: <1300180305-5993-16-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
References: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per RCU glock patch review comments, don't use the _raw
version of this function here.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 8648409..85044b4 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1723,7 +1723,7 @@ static inline struct gfs2_glock *glock_hash_chain(unsigned hash)
 
 static inline struct gfs2_glock *glock_hash_next(struct gfs2_glock *gl)
 {
-	return hlist_bl_entry(rcu_dereference_raw(gl->gl_list.next),
+	return hlist_bl_entry(rcu_dereference(gl->gl_list.next),
 			      struct gfs2_glock, gl_list);
 }
 
-- 
1.7.4

