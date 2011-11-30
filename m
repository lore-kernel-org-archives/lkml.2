Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab1K3CTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:19:09 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:36102 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932083Ab1K3CTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:19:06 -0500
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 24/28] super: checkpatch wanking
Date: Tue, 29 Nov 2011 18:14:22 -0800
Message-Id: <bb9c0232160debe962edf4bc57031da899819004.1322609673.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1322609672.git.joe@perches.com>
References: <cover.1322609672.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now checkpatch clean.

$ ./scripts/checkpatch.pl -f --terse --nosummary fs/super.c | \
  cut -f3- -d":" | sort | uniq -c
      1  ERROR: code indent should use tabs where possible
      1  ERROR: do not initialise statics to 0 or NULL
      2  ERROR: "foo * bar" should be "foo *bar"
      2  ERROR: space required after that ',' (ctx:OxV)
      3  ERROR: trailing whitespace
     14  WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
      1  WARNING: line over 80 characters
      1  WARNING: please, no space before tabs
      2  WARNING: please, no spaces at the start of a line

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/super.c |   40 ++++++++++++++--------------------------
 1 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 23ff118..b550808 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -172,7 +172,8 @@ static struct super_block *alloc_super(struct file_system_type *type)
 		s->s_count = 1;
 		atomic_set(&s->s_active, 1);
 		mutex_init(&s->s_vfs_rename_mutex);
-		lockdep_set_class(&s->s_vfs_rename_mutex, &type->s_vfs_rename_key);
+		lockdep_set_class(&s->s_vfs_rename_mutex,
+				  &type->s_vfs_rename_key);
 		mutex_init(&s->s_dquot.dqio_mutex);
 		mutex_init(&s->s_dquot.dqonoff_mutex);
 		init_rwsem(&s->s_dquot.dqptr_sem);
@@ -267,7 +268,6 @@ void deactivate_locked_super(struct super_block *s)
 		up_write(&s->s_umount);
 	}
 }
-
 EXPORT_SYMBOL(deactivate_locked_super);
 
 /**
@@ -280,12 +280,11 @@ EXPORT_SYMBOL(deactivate_locked_super);
  */
 void deactivate_super(struct super_block *s)
 {
-        if (!atomic_add_unless(&s->s_active, -1, 1)) {
+	if (!atomic_add_unless(&s->s_active, -1, 1)) {
 		down_write(&s->s_umount);
 		deactivate_locked_super(s);
 	}
 }
-
 EXPORT_SYMBOL(deactivate_super);
 
 /**
@@ -293,7 +292,7 @@ EXPORT_SYMBOL(deactivate_super);
  *	@s: reference we are trying to make active
  *
  *	Tries to acquire an active reference.  grab_super() is used when we
- * 	had just found a superblock in super_blocks or fs_type->fs_supers
+ *	had just found a superblock in super_blocks or fs_type->fs_supers
  *	and want to turn it into a full-blown active reference.  grab_super()
  *	is called with sb_lock held and drops it.  Returns 1 in case of
  *	success, 0 if we had failed (superblock contents was already dead or
@@ -351,17 +350,16 @@ bool grab_super_passive(struct super_block *sb)
 /*
  * Superblock locking.  We really ought to get rid of these two.
  */
-void lock_super(struct super_block * sb)
+void lock_super(struct super_block *sb)
 {
 	mutex_lock(&sb->s_lock);
 }
+EXPORT_SYMBOL(lock_super);
 
-void unlock_super(struct super_block * sb)
+void unlock_super(struct super_block *sb)
 {
 	mutex_unlock(&sb->s_lock);
 }
-
-EXPORT_SYMBOL(lock_super);
 EXPORT_SYMBOL(unlock_super);
 
 /**
@@ -405,7 +403,6 @@ void generic_shutdown_super(struct super_block *sb)
 	spin_unlock(&sb_lock);
 	up_write(&sb->s_umount);
 }
-
 EXPORT_SYMBOL(generic_shutdown_super);
 
 /**
@@ -416,9 +413,9 @@ EXPORT_SYMBOL(generic_shutdown_super);
  *	@data:	argument to each of them
  */
 struct super_block *sget(struct file_system_type *type,
-			int (*test)(struct super_block *,void *),
-			int (*set)(struct super_block *,void *),
-			void *data)
+			 int (*test)(struct super_block *, void *),
+			 int (*set)(struct super_block *, void *),
+			 void *data)
 {
 	struct super_block *s = NULL;
 	struct super_block *old;
@@ -452,7 +449,7 @@ retry:
 			return ERR_PTR(-ENOMEM);
 		goto retry;
 	}
-		
+
 	err = set(s, data);
 	if (err) {
 		spin_unlock(&sb_lock);
@@ -469,7 +466,6 @@ retry:
 	register_shrinker(&s->s_shrink);
 	return s;
 }
-
 EXPORT_SYMBOL(sget);
 
 void drop_super(struct super_block *sb)
@@ -477,7 +473,6 @@ void drop_super(struct super_block *sb)
 	up_read(&sb->s_umount);
 	put_super(sb);
 }
-
 EXPORT_SYMBOL(drop_super);
 
 /**
@@ -587,13 +582,12 @@ void iterate_supers_type(struct file_system_type *type,
 		__put_super(p);
 	spin_unlock(&sb_lock);
 }
-
 EXPORT_SYMBOL(iterate_supers_type);
 
 /**
  *	get_super - get the superblock of a device
  *	@bdev: device to get the superblock for
- *	
+ *
  *	Scans the superblock list and finds the superblock of the file system
  *	mounted on the device given. %NULL is returned if no match is found.
  */
@@ -627,7 +621,6 @@ rescan:
 	spin_unlock(&sb_lock);
 	return NULL;
 }
-
 EXPORT_SYMBOL(get_super);
 
 /**
@@ -660,7 +653,7 @@ restart:
 	spin_unlock(&sb_lock);
 	return NULL;
 }
- 
+
 struct super_block *user_get_super(dev_t dev)
 {
 	struct super_block *sb;
@@ -799,7 +792,7 @@ void emergency_remount(void)
 
 static DEFINE_IDA(unnamed_dev_ida);
 static DEFINE_SPINLOCK(unnamed_dev_lock);/* protects the above */
-static int unnamed_dev_start = 0; /* don't bother trying below it */
+static int unnamed_dev_start;	/* don't bother trying below it */
 
 int get_anon_bdev(dev_t *p)
 {
@@ -851,7 +844,6 @@ int set_anon_super(struct super_block *s, void *data)
 		s->s_bdi = &noop_backing_dev_info;
 	return error;
 }
-
 EXPORT_SYMBOL(set_anon_super);
 
 void kill_anon_super(struct super_block *sb)
@@ -860,7 +852,6 @@ void kill_anon_super(struct super_block *sb)
 	generic_shutdown_super(sb);
 	free_anon_bdev(dev);
 }
-
 EXPORT_SYMBOL(kill_anon_super);
 
 void kill_litter_super(struct super_block *sb)
@@ -869,7 +860,6 @@ void kill_litter_super(struct super_block *sb)
 		d_genocide(sb->s_root);
 	kill_anon_super(sb);
 }
-
 EXPORT_SYMBOL(kill_litter_super);
 
 static int ns_test_super(struct super_block *sb, void *data)
@@ -906,7 +896,6 @@ struct dentry *mount_ns(struct file_system_type *fs_type, int flags,
 
 	return dget(sb->s_root);
 }
-
 EXPORT_SYMBOL(mount_ns);
 
 #ifdef CONFIG_BLOCK
@@ -1016,7 +1005,6 @@ void kill_block_super(struct super_block *sb)
 	WARN_ON_ONCE(!(mode & FMODE_EXCL));
 	blkdev_put(bdev, mode | FMODE_EXCL);
 }
-
 EXPORT_SYMBOL(kill_block_super);
 #endif
 
-- 
1.7.6.405.gc1be0

