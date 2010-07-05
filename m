Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787Ab0GEMTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 08:19:30 -0400
Received: from smtp.nokia.com ([192.100.122.233]:49143 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758747Ab0GEMS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 08:18:59 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCHv6 8/9] VFS: rename s_dirt to s_dirty
Date: Mon,  5 Jul 2010 15:15:06 +0300
Message-Id: <1278332107-11443-9-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1278332107-11443-1-git-send-email-dedekind1@gmail.com>
References: <1278332107-11443-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 05 Jul 2010 12:18:44.0512 (UTC) FILETIME=[36518A00:01CB1C3C]
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
index 20d8cb0..1c11e36 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1319,7 +1319,7 @@ extern spinlock_t sb_lock;
 struct super_block {
 	struct list_head	s_list;		/* Keep this first */
 	dev_t			s_dev;		/* search index; _not_ kdev_t */
-	unsigned char		s_dirt;
+	unsigned char		s_dirty;
 	unsigned char		s_blocksize_bits;
 	unsigned long		s_blocksize;
 	loff_t			s_maxbytes;	/* Max file size */
@@ -1785,15 +1785,15 @@ extern void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb);
 
 static inline void sb_mark_dirty(struct super_block *sb)
 {
-	sb->s_dirt = 1;
+	sb->s_dirty = 1;
 }
 static inline void sb_mark_clean(struct super_block *sb)
 {
-	sb->s_dirt = 0;
+	sb->s_dirty = 0;
 }
 static inline int sb_is_dirty(struct super_block *sb)
 {
-	return sb->s_dirt;
+	return sb->s_dirty;
 }
 
 /* Alas, no aliases. Too much hassle with bringing module.h everywhere */
-- 
1.7.0.1

