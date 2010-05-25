Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab0EYNvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 09:51:16 -0400
Received: from smtp.nokia.com ([192.100.122.230]:37610 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758519Ab0EYNvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 09:51:12 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-fsdevel@vger.kernel.org
Subject: [PATCHv4 16/17] VFS: rename s_dirt to s_dirty
Date: Tue, 25 May 2010 16:49:11 +0300
Message-Id: <1274795352-3551-17-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 25 May 2010 13:50:56.0265 (UTC) FILETIME=[4C904F90:01CAFC11]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

... in order to make sure no one accesses the "s_dirt" flag
direclty - this should help to identify build errors earlier.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 include/linux/fs.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 21fe2b3..c2ddeee 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1318,7 +1318,7 @@ extern spinlock_t sb_lock;
 struct super_block {
 	struct list_head	s_list;		/* Keep this first */
 	dev_t			s_dev;		/* search index; _not_ kdev_t */
-	unsigned char		s_dirt;
+	unsigned char		s_dirty;
 	unsigned char		s_blocksize_bits;
 	unsigned long		s_blocksize;
 	loff_t			s_maxbytes;	/* Max file size */
@@ -1788,15 +1788,15 @@ extern void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb);
  */
 static inline void mark_sb_dirty(struct super_block *sb)
 {
-	sb->s_dirt = 1;
+	sb->s_dirty = 1;
 }
 static inline void mark_sb_clean(struct super_block *sb)
 {
-	sb->s_dirt = 0;
+	sb->s_dirty = 0;
 }
 static inline int is_sb_dirty(struct super_block *sb)
 {
-	return sb->s_dirt;
+	return sb->s_dirty;
 }
 
 /* Alas, no aliases. Too much hassle with bringing module.h everywhere */
-- 
1.6.6.1

