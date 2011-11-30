Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647Ab1K3CSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:18:05 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:57454 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757630Ab1K3CSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:18:02 -0500
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 18/28] dcache: checkpatch wanking
Date: Tue, 29 Nov 2011 18:14:16 -0800
Message-Id: <c00a02d64b2e8a64df9e322d44f7ab4b4c2b7bf0.1322609673.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1322609672.git.joe@perches.com>
References: <cover.1322609672.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Style fixing, trivial 80 col and a kstrtoul checkpatch errors remain.

$ ./scripts/checkpatch.pl -f --terse --nosummary fs/dcache.c | \
  cut -f3- -d":" | sort | uniq -c
     10  ERROR: code indent should use tabs where possible
     15  ERROR: "foo * bar" should be "foo *bar"
      1  ERROR: space prohibited before that close parenthesis ')'
     21  ERROR: trailing whitespace
      1  WARNING: braces {} are not necessary for single statement blocks
      3  WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
      1  WARNING: externs should be avoided in .c files
      8  WARNING: line over 80 characters
      5  WARNING: please, no space before tabs
     20  WARNING: please, no spaces at the start of a line
      1  WARNING: simple_strtoul is obsolete, use kstrtoul instead
      1  WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/dcache.c |  128 ++++++++++++++++++++++++++++++-----------------------------
 1 files changed, 65 insertions(+), 63 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 6055631..1d62cf7 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -28,7 +28,7 @@
 #include <linux/module.h>
 #include <linux/mount.h>
 #include <linux/file.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/security.h>
 #include <linux/seqlock.h>
 #include <linux/swap.h>
@@ -84,7 +84,6 @@ EXPORT_SYMBOL_GPL(sysctl_vfs_cache_pressure);
 
 static __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lru_lock);
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(rename_lock);
-
 EXPORT_SYMBOL(rename_lock);
 
 static struct kmem_cache *dentry_cache __read_mostly;
@@ -145,7 +144,7 @@ static void __d_free(struct rcu_head *head)
 	WARN_ON(!list_empty(&dentry->d_alias));
 	if (dname_external(dentry))
 		kfree(dentry->d_name.name);
-	kmem_cache_free(dentry_cache, dentry); 
+	kmem_cache_free(dentry_cache, dentry);
 }
 
 /*
@@ -184,7 +183,7 @@ static inline void dentry_rcuwalk_barrier(struct dentry *dentry)
  * d_iput() operation if defined. Dentry has no refcount
  * and is unhashed.
  */
-static void dentry_iput(struct dentry * dentry)
+static void dentry_iput(struct dentry *dentry)
 	__releases(dentry->d_lock)
 	__releases(dentry->d_inode->i_lock)
 {
@@ -209,7 +208,7 @@ static void dentry_iput(struct dentry * dentry)
  * Release the dentry's inode, using the filesystem
  * d_iput() operation if defined. dentry remains in-use.
  */
-static void dentry_unlink_inode(struct dentry * dentry)
+static void dentry_unlink_inode(struct dentry *dentry)
 	__releases(dentry->d_lock)
 	__releases(dentry->d_inode->i_lock)
 {
@@ -437,7 +436,7 @@ relock:
 	return d_kill(dentry, parent);
 }
 
-/* 
+/*
  * This is dput
  *
  * This is complicated by the fact that we do not want to put
@@ -456,7 +455,7 @@ relock:
 
 /*
  * dput - release a dentry
- * @dentry: dentry to release 
+ * @dentry: dentry to release
  *
  * Release a dentry. This will drop the usage count and if appropriate
  * call the dentry unlink method as well as removing it from the queues and
@@ -485,7 +484,7 @@ repeat:
 	}
 
 	/* Unreachable? Get rid of it */
- 	if (d_unhashed(dentry))
+	if (d_unhashed(dentry))
 		goto kill_it;
 
 	/*
@@ -519,8 +518,8 @@ EXPORT_SYMBOL(dput);
  *
  * no dcache lock.
  */
- 
-int d_invalidate(struct dentry * dentry)
+
+int d_invalidate(struct dentry *dentry)
 {
 	/*
 	 * If it's already been dropped, return OK.
@@ -627,7 +626,7 @@ again:
 	discon_alias = NULL;
 	list_for_each_entry(alias, &inode->i_dentry, d_alias) {
 		spin_lock(&alias->d_lock);
- 		if (S_ISDIR(inode->i_mode) || !d_unhashed(alias)) {
+		if (S_ISDIR(inode->i_mode) || !d_unhashed(alias)) {
 			if (IS_ROOT(alias) &&
 			    (alias->d_flags & DCACHE_DISCONNECTED)) {
 				discon_alias = alias;
@@ -960,7 +959,8 @@ void shrink_dcache_for_umount(struct super_block *sb)
 	shrink_dcache_for_umount_subtree(dentry);
 
 	while (!hlist_bl_empty(&sb->s_anon)) {
-		dentry = hlist_bl_entry(hlist_bl_first(&sb->s_anon), struct dentry, d_hash);
+		dentry = hlist_bl_entry(hlist_bl_first(&sb->s_anon),
+					struct dentry, d_hash);
 		shrink_dcache_for_umount_subtree(dentry);
 	}
 }
@@ -971,7 +971,8 @@ void shrink_dcache_for_umount(struct super_block *sb)
  * the parenthood after dropping the lock and check
  * that the sequence number still matches.
  */
-static struct dentry *try_to_ascend(struct dentry *old, int locked, unsigned seq)
+static struct dentry *
+try_to_ascend(struct dentry *old, int locked, unsigned seq)
 {
 	struct dentry *new = old->d_parent;
 
@@ -999,7 +1000,7 @@ static struct dentry *try_to_ascend(struct dentry *old, int locked, unsigned seq
  * We descend to the next level whenever the d_subdirs
  * list is non-empty and continue searching.
  */
- 
+
 /**
  * have_submounts - check for mounts over a dentry
  * @parent: dentry to check.
@@ -1026,7 +1027,8 @@ repeat:
 resume:
 	while (next != &this_parent->d_subdirs) {
 		struct list_head *tmp = next;
-		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
+		struct dentry *dentry = list_entry(tmp, struct dentry,
+						   d_u.d_child);
 		next = tmp->next;
 
 		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
@@ -1090,7 +1092,7 @@ EXPORT_SYMBOL(have_submounts);
  * drop the lock and return early due to latency
  * constraints.
  */
-static int select_parent(struct dentry * parent)
+static int select_parent(struct dentry *parent)
 {
 	struct dentry *this_parent;
 	struct list_head *next;
@@ -1107,13 +1109,14 @@ repeat:
 resume:
 	while (next != &this_parent->d_subdirs) {
 		struct list_head *tmp = next;
-		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
+		struct dentry *dentry = list_entry(tmp, struct dentry,
+						   d_u.d_child);
 		next = tmp->next;
 
 		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 
-		/* 
-		 * move only zero ref count dentries to the end 
+		/*
+		 * move only zero ref count dentries to the end
 		 * of the unused list for prune_dcache
 		 */
 		if (!dentry->d_count) {
@@ -1179,8 +1182,8 @@ rename_retry:
  *
  * Prune the dcache to remove unused children of the parent dentry.
  */
- 
-void shrink_dcache_parent(struct dentry * parent)
+
+void shrink_dcache_parent(struct dentry *parent)
 {
 	struct super_block *sb = parent->d_sb;
 	int found;
@@ -1199,7 +1202,7 @@ EXPORT_SYMBOL(shrink_dcache_parent);
  * available. On a success the dentry is returned. The name passed in is
  * copied and the copy passed in may be reused after this call.
  */
- 
+
 struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
 {
 	struct dentry *dentry;
@@ -1212,12 +1215,12 @@ struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
 	if (name->len > DNAME_INLINE_LEN-1) {
 		dname = kmalloc(name->len + 1, GFP_KERNEL);
 		if (!dname) {
-			kmem_cache_free(dentry_cache, dentry); 
+			kmem_cache_free(dentry_cache, dentry);
 			return NULL;
 		}
 	} else  {
 		dname = dentry->d_iname;
-	}	
+	}
 	dentry->d_name.name = dname;
 
 	dentry->d_name.len = name->len;
@@ -1298,10 +1301,10 @@ EXPORT_SYMBOL(d_alloc_name);
 void d_set_d_op(struct dentry *dentry, const struct dentry_operations *op)
 {
 	WARN_ON_ONCE(dentry->d_op);
-	WARN_ON_ONCE(dentry->d_flags & (DCACHE_OP_HASH	|
-				DCACHE_OP_COMPARE	|
-				DCACHE_OP_REVALIDATE	|
-				DCACHE_OP_DELETE ));
+	WARN_ON_ONCE(dentry->d_flags & (DCACHE_OP_HASH		|
+					DCACHE_OP_COMPARE	|
+					DCACHE_OP_REVALIDATE	|
+					DCACHE_OP_DELETE));
 	dentry->d_op = op;
 	if (!op)
 		return;
@@ -1347,7 +1350,7 @@ static void __d_instantiate(struct dentry *dentry, struct inode *inode)
  * (or otherwise set) by the caller to indicate that it is now
  * in use by the dcache.
  */
- 
+
 void d_instantiate(struct dentry *entry, struct inode * inode)
 {
 	BUG_ON(!list_empty(&entry->d_alias));
@@ -1432,7 +1435,6 @@ struct dentry *d_instantiate_unique(struct dentry *entry, struct inode *inode)
 	iput(inode);
 	return result;
 }
-
 EXPORT_SYMBOL(d_instantiate_unique);
 
 /**
@@ -1443,8 +1445,8 @@ EXPORT_SYMBOL(d_instantiate_unique);
  * instantiated and returned. %NULL is returned if there is insufficient
  * memory or the inode passed is %NULL.
  */
- 
-struct dentry * d_alloc_root(struct inode * root_inode)
+
+struct dentry *d_alloc_root(struct inode *root_inode)
 {
 	struct dentry *res = NULL;
 
@@ -1459,7 +1461,7 @@ struct dentry * d_alloc_root(struct inode * root_inode)
 }
 EXPORT_SYMBOL(d_alloc_root);
 
-static struct dentry * __d_find_any_alias(struct inode *inode)
+static struct dentry *__d_find_any_alias(struct inode *inode)
 {
 	struct dentry *alias;
 
@@ -1470,7 +1472,7 @@ static struct dentry * __d_find_any_alias(struct inode *inode)
 	return alias;
 }
 
-static struct dentry * d_find_any_alias(struct inode *inode)
+static struct dentry *d_find_any_alias(struct inode *inode)
 {
 	struct dentry *de;
 
@@ -1798,10 +1800,10 @@ struct dentry *d_lookup(struct dentry *parent, struct qstr *name)
 	struct dentry *dentry;
 	unsigned seq;
 
-        do {
-                seq = read_seqbegin(&rename_lock);
-                dentry = __d_lookup(parent, name);
-                if (dentry)
+	do {
+		seq = read_seqbegin(&rename_lock);
+		dentry = __d_lookup(parent, name);
+		if (dentry)
 			break;
 	} while (read_seqretry(&rename_lock, seq));
 	return dentry;
@@ -1854,7 +1856,7 @@ struct dentry *__d_lookup(struct dentry *parent, struct qstr *name)
 	 * See Documentation/filesystems/path-lookup.txt for more details.
 	 */
 	rcu_read_lock();
-	
+
 	hlist_bl_for_each_entry_rcu(dentry, node, b, d_hash) {
 		const char *tname;
 		int tlen;
@@ -1890,10 +1892,10 @@ struct dentry *__d_lookup(struct dentry *parent, struct qstr *name)
 		break;
 next:
 		spin_unlock(&dentry->d_lock);
- 	}
- 	rcu_read_unlock();
+	}
+	rcu_read_unlock();
 
- 	return found;
+	return found;
 }
 
 /**
@@ -1965,7 +1967,7 @@ EXPORT_SYMBOL(d_validate);
  * it from the hash queues and waiting for
  * it to be deleted later when it has no users
  */
- 
+
 /**
  * d_delete - delete a dentry
  * @dentry: The dentry to delete
@@ -1973,8 +1975,8 @@ EXPORT_SYMBOL(d_validate);
  * Turn the dentry into a negative dentry if possible, otherwise
  * remove it from the hash queues so it can be deleted later
  */
- 
-void d_delete(struct dentry * dentry)
+
+void d_delete(struct dentry *dentry)
 {
 	struct inode *inode;
 	int isdir = 0;
@@ -2006,7 +2008,7 @@ again:
 }
 EXPORT_SYMBOL(d_delete);
 
-static void __d_rehash(struct dentry * entry, struct hlist_bl_head *b)
+static void __d_rehash(struct dentry *entry, struct hlist_bl_head *b)
 {
 	BUG_ON(!d_unhashed(entry));
 	hlist_bl_lock(b);
@@ -2015,7 +2017,7 @@ static void __d_rehash(struct dentry * entry, struct hlist_bl_head *b)
 	hlist_bl_unlock(b);
 }
 
-static void _d_rehash(struct dentry * entry)
+static void _d_rehash(struct dentry *entry)
 {
 	__d_rehash(entry, d_hash(entry->d_parent, entry->d_name.hash));
 }
@@ -2026,8 +2028,8 @@ static void _d_rehash(struct dentry * entry)
  *
  * Adds a dentry to the hash according to its name.
  */
- 
-void d_rehash(struct dentry * entry)
+
+void d_rehash(struct dentry *entry)
 {
 	spin_lock(&entry->d_lock);
 	_d_rehash(entry);
@@ -2160,7 +2162,7 @@ static void dentry_unlock_parents_for_move(struct dentry *dentry,
  * rename_lock, the i_mutex of the source and target directories,
  * and the sb->s_vfs_rename_mutex if they differ. See lock_rename().
  */
-static void __d_move(struct dentry * dentry, struct dentry * target)
+static void __d_move(struct dentry *dentry, struct dentry *target)
 {
 	if (!dentry->d_inode)
 		pr_warn("VFS: moving negative dcache entry\n");
@@ -2457,13 +2459,12 @@ static int prepend_path(const struct path *path, struct path *root,
 
 	br_read_lock(&vfsmount_lock);
 	while (dentry != root->dentry || vfsmnt != root->mnt) {
-		struct dentry * parent;
+		struct dentry *parent;
 
 		if (dentry == vfsmnt->mnt_root || IS_ROOT(dentry)) {
 			/* Global root? */
-			if (vfsmnt->mnt_parent == vfsmnt) {
+			if (vfsmnt->mnt_parent == vfsmnt)
 				goto global_root;
-			}
 			dentry = vfsmnt->mnt_mountpoint;
 			vfsmnt = vfsmnt->mnt_parent;
 			continue;
@@ -2808,7 +2809,7 @@ out:
  * Returns 0 otherwise.
  * Caller must ensure that "new_dentry" is pinned before calling is_subdir()
  */
-  
+
 int is_subdir(struct dentry *new_dentry, struct dentry *old_dentry)
 {
 	int result;
@@ -2876,7 +2877,8 @@ repeat:
 resume:
 	while (next != &this_parent->d_subdirs) {
 		struct list_head *tmp = next;
-		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
+		struct dentry *dentry = list_entry(tmp, struct dentry,
+						   d_u.d_child);
 		next = tmp->next;
 
 		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
@@ -2921,6 +2923,7 @@ rename_retry:
 	write_seqlock(&rename_lock);
 	goto again;
 }
+EXPORT_SYMBOL(d_genocide);
 
 /**
  * find_inode_number - check for dentry with name
@@ -2935,10 +2938,10 @@ rename_retry:
  * filesystems using synthetic inode numbers, and is necessary
  * to keep getcwd() working.
  */
- 
+
 ino_t find_inode_number(struct dentry *dir, struct qstr *name)
 {
-	struct dentry * dentry;
+	struct dentry *dentry;
 	ino_t ino = 0;
 
 	dentry = d_hash_and_lookup(dir, name);
@@ -2989,10 +2992,10 @@ static void __init dcache_init(void)
 {
 	int loop;
 
-	/* 
+	/*
 	 * A constructor could be added for stable state like the lists,
 	 * but it is probably not worth it because of the cache nature
-	 * of the dcache. 
+	 * of the dcache.
 	 */
 	dentry_cache = KMEM_CACHE(dentry,
 		SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD);
@@ -3019,8 +3022,6 @@ static void __init dcache_init(void)
 struct kmem_cache *names_cachep __read_mostly;
 EXPORT_SYMBOL(names_cachep);
 
-EXPORT_SYMBOL(d_genocide);
-
 void __init vfs_caches_init_early(void)
 {
 	dcache_init_early();
@@ -3031,8 +3032,9 @@ void __init vfs_caches_init(unsigned long mempages)
 {
 	unsigned long reserve;
 
-	/* Base hash sizes on available memory, with a reserve equal to
-           150% of current kernel size */
+	/* Base hash sizes on available memory
+	 * with a reserve equal to 150% of current kernel size
+	 */
 
 	reserve = min((mempages - nr_free_pages()) * 3/2, mempages - 1);
 	mempages -= reserve;
-- 
1.7.6.405.gc1be0

