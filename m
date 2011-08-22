Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab1HVQwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 12:52:18 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37870
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751054Ab1HVQwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 12:52:15 -0400
Date: Mon, 22 Aug 2011 12:52:12 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] block: remove READ_META and WRITE_META
Message-ID: <20110822165211.GA7257@infradead.org>
References: <4E4E6238.3080808@fusionio.com>
 <20110820174137.GA27243@infradead.org>
 <4E5146C1.508@fusionio.com>
 <20110821181935.GA28979@infradead.org>
 <4E515057.7040802@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E515057.7040802@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace all occurnanced of the undocumented READ_META with READ | REQ_META
and remove the unused WRITE_META define.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/ext3/inode.c
===================================================================
--- linux-2.6.orig/fs/ext3/inode.c	2011-08-21 19:17:33.523476760 -0700
+++ linux-2.6/fs/ext3/inode.c	2011-08-21 19:18:38.583476811 -0700
@@ -1134,7 +1134,7 @@ struct buffer_head *ext3_bread(handle_t
 		return bh;
 	if (buffer_uptodate(bh))
 		return bh;
-	ll_rw_block(READ_META, 1, &bh);
+	ll_rw_block(READ | REQ_META, 1, &bh);
 	wait_on_buffer(bh);
 	if (buffer_uptodate(bh))
 		return bh;
@@ -2807,7 +2807,7 @@ make_io:
 		trace_ext3_load_inode(inode);
 		get_bh(bh);
 		bh->b_end_io = end_buffer_read_sync;
-		submit_bh(READ_META, bh);
+		submit_bh(READ | REQ_META, bh);
 		wait_on_buffer(bh);
 		if (!buffer_uptodate(bh)) {
 			ext3_error(inode->i_sb, "ext3_get_inode_loc",
Index: linux-2.6/fs/ext3/namei.c
===================================================================
--- linux-2.6.orig/fs/ext3/namei.c	2011-08-21 19:17:33.543476759 -0700
+++ linux-2.6/fs/ext3/namei.c	2011-08-21 19:18:00.450143260 -0700
@@ -922,7 +922,7 @@ restart:
 				bh = ext3_getblk(NULL, dir, b++, 0, &err);
 				bh_use[ra_max] = bh;
 				if (bh)
-					ll_rw_block(READ_META, 1, &bh);
+					ll_rw_block(READ | REQ_META, 1, &bh);
 			}
 		}
 		if ((bh = bh_use[ra_ptr++]) == NULL)
Index: linux-2.6/fs/ext4/inode.c
===================================================================
--- linux-2.6.orig/fs/ext4/inode.c	2011-08-21 19:17:33.563476759 -0700
+++ linux-2.6/fs/ext4/inode.c	2011-08-21 19:18:11.500143356 -0700
@@ -650,7 +650,7 @@ struct buffer_head *ext4_bread(handle_t
 		return bh;
 	if (buffer_uptodate(bh))
 		return bh;
-	ll_rw_block(READ_META, 1, &bh);
+	ll_rw_block(READ | REQ_META, 1, &bh);
 	wait_on_buffer(bh);
 	if (buffer_uptodate(bh))
 		return bh;
@@ -3301,7 +3301,7 @@ make_io:
 		trace_ext4_load_inode(inode);
 		get_bh(bh);
 		bh->b_end_io = end_buffer_read_sync;
-		submit_bh(READ_META, bh);
+		submit_bh(READ | REQ_META, bh);
 		wait_on_buffer(bh);
 		if (!buffer_uptodate(bh)) {
 			EXT4_ERROR_INODE_BLOCK(inode, block,
Index: linux-2.6/fs/ext4/namei.c
===================================================================
--- linux-2.6.orig/fs/ext4/namei.c	2011-08-21 19:17:33.583476759 -0700
+++ linux-2.6/fs/ext4/namei.c	2011-08-21 19:18:17.826809949 -0700
@@ -922,7 +922,7 @@ restart:
 				bh = ext4_getblk(NULL, dir, b++, 0, &err);
 				bh_use[ra_max] = bh;
 				if (bh)
-					ll_rw_block(READ_META, 1, &bh);
+					ll_rw_block(READ | REQ_META, 1, &bh);
 			}
 		}
 		if ((bh = bh_use[ra_ptr++]) == NULL)
Index: linux-2.6/fs/gfs2/quota.c
===================================================================
--- linux-2.6.orig/fs/gfs2/quota.c	2011-08-21 19:17:33.603476760 -0700
+++ linux-2.6/fs/gfs2/quota.c	2011-08-21 19:18:33.716809868 -0700
@@ -709,7 +709,7 @@ get_a_page:
 		set_buffer_uptodate(bh);
 
 	if (!buffer_uptodate(bh)) {
-		ll_rw_block(READ_META, 1, &bh);
+		ll_rw_block(READ | REQ_META, 1, &bh);
 		wait_on_buffer(bh);
 		if (!buffer_uptodate(bh))
 			goto unlock_out;
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2011-08-21 19:18:48.493476308 -0700
+++ linux-2.6/include/linux/fs.h	2011-08-21 19:19:16.016809882 -0700
@@ -162,10 +162,8 @@ struct inodes_stat_t {
 #define READA			RWA_MASK
 
 #define READ_SYNC		(READ | REQ_SYNC)
-#define READ_META		(READ | REQ_META)
 #define WRITE_SYNC		(WRITE | REQ_SYNC | REQ_NOIDLE)
 #define WRITE_ODIRECT		(WRITE | REQ_SYNC)
-#define WRITE_META		(WRITE | REQ_META)
 #define WRITE_FLUSH		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_FLUSH)
 #define WRITE_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_FUA)
 #define WRITE_FLUSH_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_FLUSH | REQ_FUA)
