Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab3AHXgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:36:43 -0500
Received: from mail.windriver.com ([147.11.1.11]:63301 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661Ab3AHXgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:36:40 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Xi Wang <xi.wang@gmail.com>, Ben Myers <bpm@sgi.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 18/77] xfs: fix acl count validation in xfs_acl_from_disk()
Date: Tue, 8 Jan 2013 18:34:57 -0500
Message-ID: <1357688156-25387-19-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xi Wang <xi.wang@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 093019cf1b18dd31b2c3b77acce4e000e2cbc9ce upstream.

Commit fa8b18ed didn't prevent the integer overflow and possible
memory corruption.  "count" can go negative and bypass the check.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
[PG: in 2.6.34, xfs still had "linux-2.6" as a path component.]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/xfs/linux-2.6/xfs_acl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/linux-2.6/xfs_acl.c b/fs/xfs/linux-2.6/xfs_acl.c
index e82cce7..d509dfd 100644
--- a/fs/xfs/linux-2.6/xfs_acl.c
+++ b/fs/xfs/linux-2.6/xfs_acl.c
@@ -39,7 +39,7 @@ xfs_acl_from_disk(struct xfs_acl *aclp)
 	struct posix_acl_entry *acl_e;
 	struct posix_acl *acl;
 	struct xfs_acl_entry *ace;
-	int count, i;
+	unsigned int count, i;
 
 	count = be32_to_cpu(aclp->acl_cnt);
 	if (count > XFS_ACL_MAX_ENTRIES)
-- 
1.7.12.1

