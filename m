Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab1HMA14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 20:27:56 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53640 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab1HMA1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 20:27:49 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 08/10]fs Remove pointless "@" from various parts of the kernel
Date: Fri, 12 Aug 2011 17:27:13 -0700
Message-Id: <1313195235-4522-8-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1313195235-4522-1-git-send-email-justinmattock@gmail.com>
References: <1313195235-4522-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The patch series below removes some pointless "@"'s in various parts of the kernel.
Note: some might be useful, but then again, some just seemed a waste of space.
(and since the kernel is become bloated, might as well diet! even if it's a few bits)

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 fs/ext3/balloc.c      |    6 +++---
 fs/ext3/inode.c       |    2 +-
 fs/ext3/namei.c       |    2 +-
 fs/ext3/super.c       |    4 ++--
 fs/ext4/super.c       |    2 +-
 fs/jbd/commit.c       |    2 +-
 fs/jbd/transaction.c  |    6 +++---
 fs/jbd2/commit.c      |    2 +-
 fs/jbd2/transaction.c |    4 ++--
 fs/ocfs2/suballoc.c   |    2 +-
 10 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index 6386d76..afc0637 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -564,7 +564,7 @@ do_more:
 	 * We are about to start releasing blocks in the bitmap,
 	 * so we need undo access.
 	 */
-	/* @@@ check errors */
+	/* check errors */
 	BUFFER_TRACE(bitmap_bh, "getting undo access");
 	err = ext3_journal_get_undo_access(handle, bitmap_bh);
 	if (err)
@@ -607,7 +607,7 @@ do_more:
 			cond_resched();
 			jbd_lock_bh_state(bitmap_bh);
 		}
-		/* @@@ This prevents newly-allocated data from being
+		/* This prevents newly-allocated data from being
 		 * freed and then reallocated within the same
 		 * transaction.
 		 *
@@ -714,7 +714,7 @@ void ext3_free_blocks(handle_t *handle, struct inode *inode,
  * This would lead to corruption if we crashed between overwriting the
  * data and committing the delete.
  *
- * @@@ We may want to make this allocation behaviour conditional on
+ * We may want to make this allocation behaviour conditional on
  * data-writes at some point, and disable it for metadata allocations or
  * sync-data inodes.
  */
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 04da6ac..cb259e5 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1582,7 +1582,7 @@ static int buffer_unmapped(handle_t *handle, struct buffer_head *bh)
  * 16May01: If we're reentered then journal_current_handle() will be
  *	    non-zero. We simply *return*.
  *
- * 1 July 2001: @@@ FIXME:
+ * 1 July 2001: FIXME:
  *   In journalled data mode, a data buffer may be metadata against the
  *   current transaction.  But the same file is part of a shared mapping
  *   and someone does a writepage() on it.
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 6e18a0b..ff31566 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1949,7 +1949,7 @@ int ext3_orphan_add(handle_t *handle, struct inode *inode)
 	/* Orphan handling is only valid for files with data blocks
 	 * being truncated, or files being unlinked. */
 
-	/* @@@ FIXME: Observation from aviro:
+	/* FIXME: Observation from aviro:
 	 * I think I can trigger J_ASSERT in ext3_orphan_add().  We block
 	 * here (on s_orphan_lock), so race with ext3_link() which might bump
 	 * ->i_nlink. For, say it, character device. Not a regular file,
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 7beb69a..4a5a899 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1089,7 +1089,7 @@ static int parse_options (char *options, struct super_block *sb,
 			clear_opt(sbi->s_mount_opt, RESERVATION);
 			break;
 		case Opt_journal_update:
-			/* @@@ FIXME */
+			/* FIXME */
 			/* Eventually we will want to be able to create
 			   a journal file here.  For now, only allow the
 			   user to specify an existing inode to be the
@@ -1350,7 +1350,7 @@ static int ext3_setup_super(struct super_block *sb, struct ext3_super_block *es,
 			"warning: checktime reached, "
 			"running e2fsck is recommended");
 #if 0
-		/* @@@ We _will_ want to clear the valid bit if we find
+		/* We _will_ want to clear the valid bit if we find
                    inconsistencies, to force a fsck at reboot.  But for
                    a plain journaled filesystem we can keep it set as
                    valid forever! :) */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4687fea..3a468b4 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1600,7 +1600,7 @@ static int parse_options(char *options, struct super_block *sb,
 			break;
 #endif
 		case Opt_journal_update:
-			/* @@@ FIXME */
+			/* FIXME */
 			/* Eventually we will want to be able to create
 			   a journal file here.  For now, only allow the
 			   user to specify an existing inode to be the
diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 8799207..007d897 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -578,7 +578,7 @@ void journal_commit_transaction(journal_t *journal)
 		commit_transaction->t_outstanding_credits--;
 
 		/* Bump b_count to prevent truncate from stumbling over
-                   the shadowed buffer!  @@@ This can go if we ever get
+                   the shadowed buffer! This can go if we ever get
                    rid of the BJ_IO/BJ_Shadow pairing of buffers. */
 		get_bh(jh2bh(jh));
 
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 7e59c6e..c6e9370 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -202,7 +202,7 @@ repeat_locked:
 	 */
 
 	/*
-	 * @@@ AKPM: This seems rather over-defensive.  We're giving commit
+	 * AKPM: This seems rather over-defensive.  We're giving commit
 	 * a _lot_ of headroom: 1/4 of the journal plus the size of
 	 * the committing transaction.  Really, we only need to give it
 	 * committing_transaction->t_outstanding_credits plus "enough" for
@@ -533,7 +533,7 @@ do_get_write_access(handle_t *handle, struct journal_head *jh,
 repeat:
 	bh = jh2bh(jh);
 
-	/* @@@ Need to check for errors here at some point. */
+	/* Need to check for errors here at some point. */
 
 	lock_buffer(bh);
 	jbd_lock_bh_state(bh);
@@ -995,7 +995,7 @@ int journal_dirty_data(handle_t *handle, struct buffer_head *bh)
 			J_ASSERT_JH(jh, jh->b_transaction ==
 					journal->j_committing_transaction);
 
-			/* @@@ IS THIS TRUE  ? */
+			/* IS THIS TRUE  ? */
 			/*
 			 * Not any more.  Scenario: someone does a write()
 			 * in data=journal mode.  The buffer's transaction has
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index eef6979..e5b362d 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -571,7 +571,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		atomic_dec(&commit_transaction->t_outstanding_credits);
 
 		/* Bump b_count to prevent truncate from stumbling over
-                   the shadowed buffer!  @@@ This can go if we ever get
+                   the shadowed buffer! This can go if we ever get
                    rid of the BJ_IO/BJ_Shadow pairing of buffers. */
 		atomic_inc(&jh2bh(jh)->b_count);
 
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 2d71094..933d8b7 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -250,7 +250,7 @@ repeat:
 	 */
 
 	/*
-	 * @@@ AKPM: This seems rather over-defensive.  We're giving commit
+	 * AKPM: This seems rather over-defensive.  We're giving commit
 	 * a _lot_ of headroom: 1/4 of the journal plus the size of
 	 * the committing transaction.  Really, we only need to give it
 	 * committing_transaction->t_outstanding_credits plus "enough" for
@@ -602,7 +602,7 @@ do_get_write_access(handle_t *handle, struct journal_head *jh,
 repeat:
 	bh = jh2bh(jh);
 
-	/* @@@ Need to check for errors here at some point. */
+	/* Need to check for errors here at some point. */
 
 	lock_buffer(bh);
 	jbd_lock_bh_state(bh);
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index ba5d97e..55da3c1 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1252,7 +1252,7 @@ int ocfs2_reserve_clusters(struct ocfs2_super *osb,
  * This would lead to corruption if we crashed between overwriting the
  * data and committing the delete.
  *
- * @@@ We may want to make this allocation behaviour conditional on
+ * We may want to make this allocation behaviour conditional on
  * data-writes at some point, and disable it for metadata allocations or
  * sync-data inodes."
  *
-- 
1.7.6

