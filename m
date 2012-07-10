Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab2GJBNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 21:13:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46918 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab2GJBNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 21:13:08 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        William Irwin <wli@holomorphy.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH v2] mm/hugetlb: fix error code in hugetlbfs_alloc_inode
Date: Tue, 10 Jul 2012 09:12:54 +0800
Message-Id: <1341882774-4772-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Changelog:
*v2 change -ENOMEM to ERR_PTR(-ENOMEM);

When kmem_cache_alloc fails alloc slab object from
hugetlbfs_inode_cachep, return -ENOMEM in usual. But
hugetlbfs_alloc_inode implementation has inconsitency
with it and returns NULL. Fix it to return -ENOMEM.

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 fs/hugetlbfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index c4b85d0..79a0f33 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -696,7 +696,7 @@ static struct inode *hugetlbfs_alloc_inode(struct super_block *sb)
 	p = kmem_cache_alloc(hugetlbfs_inode_cachep, GFP_KERNEL);
 	if (unlikely(!p)) {
 		hugetlbfs_inc_free_inodes(sbinfo);
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 	return &p->vfs_inode;
 }
-- 
1.7.5.4

