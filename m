Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab3AIAEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 19:04:10 -0500
Received: from mail1.windriver.com ([147.11.146.13]:53552 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934Ab3AHXgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:36:49 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>,
        Ben Myers <bpm@sgi.com>, Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 17/77] xfs: validate acl count
Date: Tue, 8 Jan 2013 18:34:56 -0500
Message-ID: <1357688156-25387-18-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit fa8b18edd752a8b4e9d1ee2cd615b82c93cf8bba upstream.

This prevents in-memory corruption and possible panics if the on-disk
ACL is badly corrupted.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
[PG: in 2.6.34, xfs still had "linux-2.6" as a path component.]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/xfs/linux-2.6/xfs_acl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/linux-2.6/xfs_acl.c b/fs/xfs/linux-2.6/xfs_acl.c
index a7bc925..e82cce7 100644
--- a/fs/xfs/linux-2.6/xfs_acl.c
+++ b/fs/xfs/linux-2.6/xfs_acl.c
@@ -42,6 +42,8 @@ xfs_acl_from_disk(struct xfs_acl *aclp)
 	int count, i;
 
 	count = be32_to_cpu(aclp->acl_cnt);
+	if (count > XFS_ACL_MAX_ENTRIES)
+		return ERR_PTR(-EFSCORRUPTED);
 
 	acl = posix_acl_alloc(count, GFP_KERNEL);
 	if (!acl)
-- 
1.7.12.1

