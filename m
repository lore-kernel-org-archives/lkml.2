Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab2FWKIQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 06:08:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932Ab2FWKFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 06:05:46 -0400
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Muthukumar R <muthur@gmail.com>, linux-fsdevel@vger.kernel.org
Subject: [PATCH 12/12] pipe: remove KM_USER0 from comments
Date: Sat, 23 Jun 2012 18:04:23 +0800
Message-Id: <1340445863-16111-13-git-send-email-amwang@redhat.com>
In-Reply-To: <1340445863-16111-1-git-send-email-amwang@redhat.com>
References: <1340445863-16111-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cong Wang <amwang@redhat.com>
---
 fs/pipe.c                 |    2 +-
 include/linux/pipe_fs_i.h |    8 +++-----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 49c1065..95cbd6b 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -224,7 +224,7 @@ static void anon_pipe_buf_release(struct pipe_inode_info *pipe,
  *	and the caller has to be careful not to fault before calling
  *	the unmap function.
  *
- *	Note that this function occupies KM_USER0 if @atomic != 0.
+ *	Note that this function calls kmap_atomic() if @atomic != 0.
  */
 void *generic_pipe_buf_map(struct pipe_inode_info *pipe,
 			   struct pipe_buffer *buf, int atomic)
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index e1ac1ce..e11d1c0 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -86,11 +86,9 @@ struct pipe_buf_operations {
 	 * mapping or not. The atomic map is faster, however you can't take
 	 * page faults before calling ->unmap() again. So if you need to eg
 	 * access user data through copy_to/from_user(), then you must get
-	 * a non-atomic map. ->map() uses the KM_USER0 atomic slot for
-	 * atomic maps, so you can't map more than one pipe_buffer at once
-	 * and you have to be careful if mapping another page as source
-	 * or destination for a copy (IOW, it has to use something else
-	 * than KM_USER0).
+	 * a non-atomic map. ->map() uses the kmap_atomic slot for
+	 * atomic maps, you have to be careful if mapping another page as
+	 * source or destination for a copy.
 	 */
 	void * (*map)(struct pipe_inode_info *, struct pipe_buffer *, int);
 
-- 
1.7.7.6

