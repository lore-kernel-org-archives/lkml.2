Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965132Ab2CMAgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:36:22 -0400
Received: from mail.windriver.com ([147.11.1.11]:48684 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965049Ab2CMAY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:29 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Chris Mason <chris.mason@oracle.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 154/196] btrfs: Require CAP_SYS_ADMIN for filesystem rebalance
Date: Mon, 12 Mar 2012 20:21:07 -0400
Message-Id: <1331598109-31424-109-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 6f88a4403def422bd8e276ddf6863d6ac71435d2 upstream.

Filesystem rebalancing (BTRFS_IOC_BALANCE) affects the entire
filesystem and may run uninterruptibly for a long time.  This does not
seem to be something that an unprivileged user should be able to do.

Reported-by: Aron Xu <happyaron.xu@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/btrfs/volumes.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8db7b14..c04ebb1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -22,6 +22,7 @@
 #include <linux/blkdev.h>
 #include <linux/random.h>
 #include <linux/iocontext.h>
+#include <linux/capability.h>
 #include <asm/div64.h>
 #include "compat.h"
 #include "ctree.h"
@@ -1908,6 +1909,9 @@ int btrfs_balance(struct btrfs_root *dev_root)
 	if (dev_root->fs_info->sb->s_flags & MS_RDONLY)
 		return -EROFS;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	mutex_lock(&dev_root->fs_info->volume_mutex);
 	dev_root = dev_root->fs_info->dev_root;
 
-- 
1.7.9.3

