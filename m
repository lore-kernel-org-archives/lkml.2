Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab2BJFpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 00:45:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932380Ab2BJFpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 00:45:40 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net
Subject: [PATCH 33/60] fuse: remove the second argument of k[un]map_atomic()
Date: Fri, 10 Feb 2012 13:39:54 +0800
Message-Id: <1328852421-19678-34-git-send-email-amwang@redhat.com>
In-Reply-To: <1328852421-19678-1-git-send-email-amwang@redhat.com>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cong Wang <amwang@redhat.com>
---
 fs/fuse/dev.c  |    4 ++--
 fs/fuse/file.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 5f3368a..7df2b5e 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -838,10 +838,10 @@ static int fuse_copy_page(struct fuse_copy_state *cs, struct page **pagep,
 			}
 		}
 		if (page) {
-			void *mapaddr = kmap_atomic(page, KM_USER0);
+			void *mapaddr = kmap_atomic(page);
 			void *buf = mapaddr + offset;
 			offset += fuse_copy_do(cs, &buf, &count);
-			kunmap_atomic(mapaddr, KM_USER0);
+			kunmap_atomic(mapaddr);
 		} else
 			offset += fuse_copy_do(cs, NULL, &count);
 	}
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 4a199fd..a841868 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1887,11 +1887,11 @@ long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
 		    in_iovs + out_iovs > FUSE_IOCTL_MAX_IOV)
 			goto out;
 
-		vaddr = kmap_atomic(pages[0], KM_USER0);
+		vaddr = kmap_atomic(pages[0]);
 		err = fuse_copy_ioctl_iovec(fc, iov_page, vaddr,
 					    transferred, in_iovs + out_iovs,
 					    (flags & FUSE_IOCTL_COMPAT) != 0);
-		kunmap_atomic(vaddr, KM_USER0);
+		kunmap_atomic(vaddr);
 		if (err)
 			goto out;
 
-- 
1.7.7.6

