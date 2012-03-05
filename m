Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab2CEQDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:03:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60117 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755067Ab2CEQBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:01:40 -0500
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com,
        sandeen@redhat.com, Kamal Mostafa <kamal@canonical.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 18/19] fs: Remove old freezing mechanism
Date: Mon,  5 Mar 2012 17:01:16 +0100
Message-Id: <1330963277-26336-19-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1330963277-26336-1-git-send-email-jack@suse.cz>
References: <1330963277-26336-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all users are converted, we can remove functions, variables, and
constants defined by the old freezing mechanism.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/super.c         |    1 -
 include/linux/fs.h |    8 --------
 2 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 8b0b40c..0830afb 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -209,7 +209,6 @@ static struct super_block *alloc_super(struct file_system_type *type)
 		mutex_init(&s->s_dquot.dqio_mutex);
 		mutex_init(&s->s_dquot.dqonoff_mutex);
 		init_rwsem(&s->s_dquot.dqptr_sem);
-		init_waitqueue_head(&s->s_wait_unfrozen);
 		s->s_maxbytes = MAX_NON_LFS;
 		s->s_op = &default_op;
 		s->s_time_gran = 1000000000;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 37667f3..fcb4135 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1483,8 +1483,6 @@ struct super_block {
 	struct hlist_node	s_instances;
 	struct quota_info	s_dquot;	/* Diskquota specific options */
 
-	int			s_frozen;
-	wait_queue_head_t	s_wait_unfrozen;
 	struct sb_writers	s_writers;
 
 	char s_id[32];				/* Informational name */
@@ -1537,12 +1535,6 @@ extern void prune_dcache_sb(struct super_block *sb, int nr_to_scan);
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

