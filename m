Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab2DPQPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:15:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40993 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623Ab2DPQO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:14:26 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: dchinner@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 25/27] fs: Remove old freezing mechanism
Date: Mon, 16 Apr 2012 18:14:03 +0200
Message-Id: <1334592845-22862-26-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1334592845-22862-1-git-send-email-jack@suse.cz>
References: <1334592845-22862-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all users are converted, we can remove functions, variables, and
constants defined by the old freezing mechanism.

BugLink: https://bugs.launchpad.net/bugs/897421
Tested-by: Kamal Mostafa <kamal@canonical.com>
Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
Tested-by: Dann Frazier <dann.frazier@canonical.com>
Tested-by: Massimo Morana <massimo.morana@canonical.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/super.c         |    1 -
 include/linux/fs.h |    9 ---------
 2 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 6ed27cd..7b2c81c 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -217,7 +217,6 @@ static struct super_block *alloc_super(struct file_system_type *type)
 		mutex_init(&s->s_dquot.dqio_mutex);
 		mutex_init(&s->s_dquot.dqonoff_mutex);
 		init_rwsem(&s->s_dquot.dqptr_sem);
-		init_waitqueue_head(&s->s_wait_unfrozen);
 		s->s_maxbytes = MAX_NON_LFS;
 		s->s_op = &default_op;
 		s->s_time_gran = 1000000000;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d3c5126..e6bb666 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1430,7 +1430,6 @@ extern spinlock_t sb_lock;
 enum {
 	SB_UNFROZEN = 0,		/* FS is unfrozen */
 	SB_FREEZE_WRITE	= 1,		/* Writes, dir ops, ioctls frozen */
-	SB_FREEZE_TRANS = 2,
 	SB_FREEZE_PAGEFAULT = 2,	/* Page faults stopped as well */
 	SB_FREEZE_FS = 3,		/* For internal FS use (e.g. to stop
 					 * internal threads if needed) */
@@ -1499,8 +1498,6 @@ struct super_block {
 	struct hlist_node	s_instances;
 	struct quota_info	s_dquot;	/* Diskquota specific options */
 
-	int			s_frozen;
-	wait_queue_head_t	s_wait_unfrozen;
 	struct sb_writers	s_writers;
 
 	char s_id[32];				/* Informational name */
@@ -1554,12 +1551,6 @@ extern void prune_dcache_sb(struct super_block *sb, int nr_to_scan);
 extern struct timespec current_fs_time(struct super_block *sb);
 
 /*
- * Snapshotting support.
- */
-/* Will go away when all users are converted */
-#define vfs_check_frozen(sb, level) do { } while (0)
-
-/*
  * until VFS tracks user namespaces for inodes, just make all files
  * belong to init_user_ns
  */
-- 
1.7.1

