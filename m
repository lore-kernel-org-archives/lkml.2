Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab2FLOXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 10:23:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57264 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab2FLOVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 10:21:02 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@suse.cz,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 26/27] fs: Remove old freezing mechanism
Date: Tue, 12 Jun 2012 16:20:47 +0200
Message-Id: <1339510848-16992-27-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1339510848-16992-1-git-send-email-jack@suse.cz>
References: <1339510848-16992-1-git-send-email-jack@suse.cz>
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
 include/linux/fs.h |    3 ---
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 52b6191..98fdff4 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -216,7 +216,6 @@ static struct super_block *alloc_super(struct file_system_type *type)
 		mutex_init(&s->s_dquot.dqio_mutex);
 		mutex_init(&s->s_dquot.dqonoff_mutex);
 		init_rwsem(&s->s_dquot.dqptr_sem);
-		init_waitqueue_head(&s->s_wait_unfrozen);
 		s->s_maxbytes = MAX_NON_LFS;
 		s->s_op = &default_op;
 		s->s_time_gran = 1000000000;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 593bb25..2b61be4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1457,7 +1457,6 @@ extern spinlock_t sb_lock;
 enum {
 	SB_UNFROZEN = 0,		/* FS is unfrozen */
 	SB_FREEZE_WRITE	= 1,		/* Writes, dir ops, ioctls frozen */
-	SB_FREEZE_TRANS = 2,
 	SB_FREEZE_PAGEFAULT = 2,	/* Page faults stopped as well */
 	SB_FREEZE_FS = 3,		/* For internal FS use (e.g. to stop
 					 * internal threads if needed) */
@@ -1526,8 +1525,6 @@ struct super_block {
 	struct hlist_node	s_instances;
 	struct quota_info	s_dquot;	/* Diskquota specific options */
 
-	int			s_frozen;
-	wait_queue_head_t	s_wait_unfrozen;
 	struct sb_writers	s_writers;
 
 	char s_id[32];				/* Informational name */
-- 
1.7.1

