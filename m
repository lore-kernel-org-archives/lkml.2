Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761896Ab2EQMxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:53:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761468Ab2EQMsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:48:35 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 07/24] GFS2: Fix function parameter comments in rgrp.c
Date: Thu, 17 May 2012 13:23:14 +0100
Message-Id: <1337257411-3173-8-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
References: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch just fixes a bunch of function parameter comments.
Slowly, over the years, the comments have gotten out of date
(mostly my fault, as I haven't been good at keeping them up to date).
This patch rectifies some of that.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 55dd010..5968eae 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -119,6 +119,7 @@ static inline void gfs2_setbit(struct gfs2_rgrpd *rgd, unsigned char *buf1,
 
 /**
  * gfs2_testbit - test a bit in the bitmaps
+ * @rgd: the resource group descriptor
  * @buffer: the buffer that holds the bitmaps
  * @buflen: the length (in bytes) of the buffer
  * @block: the block to read
@@ -180,7 +181,7 @@ static inline u64 gfs2_bit_search(const __le64 *ptr, u64 mask, u8 state)
 /**
  * gfs2_bitfit - Search an rgrp's bitmap buffer to find a bit-pair representing
  *       a block in a given allocation state.
- * @buffer: the buffer that holds the bitmaps
+ * @buf: the buffer that holds the bitmaps
  * @len: the length (in bytes) of the buffer
  * @goal: start search at this block's bit-pair (within @buffer)
  * @state: GFS2_BLKST_XXX the state of the block we're looking for.
@@ -232,6 +233,7 @@ static u32 gfs2_bitfit(const u8 *buf, const unsigned int len,
 
 /**
  * gfs2_bitcount - count the number of bits in a certain state
+ * @rgd: the resource group descriptor
  * @buffer: the buffer that holds the bitmaps
  * @buflen: the length (in bytes) of the buffer
  * @state: the state of the block we're looking for
@@ -265,7 +267,6 @@ static u32 gfs2_bitcount(struct gfs2_rgrpd *rgd, const u8 *buffer,
 
 /**
  * gfs2_rgrp_verify - Verify that a resource group is consistent
- * @sdp: the filesystem
  * @rgd: the rgrp
  *
  */
@@ -323,7 +324,8 @@ static inline int rgrp_contains_block(struct gfs2_rgrpd *rgd, u64 block)
 /**
  * gfs2_blk2rgrpd - Find resource group for a given data/meta block number
  * @sdp: The GFS2 superblock
- * @n: The data block number
+ * @blk: The data block number
+ * @exact: True if this needs to be an exact match
  *
  * Returns: The resource group, or NULL if not found
  */
@@ -381,7 +383,7 @@ struct gfs2_rgrpd *gfs2_rgrpd_get_first(struct gfs2_sbd *sdp)
 
 /**
  * gfs2_rgrpd_get_next - get the next RG
- * @rgd: A RG
+ * @rgd: the resource group descriptor
  *
  * Returns: The next rgrp
  */
@@ -530,6 +532,7 @@ static int compute_bitstructs(struct gfs2_rgrpd *rgd)
 
 /**
  * gfs2_ri_total - Total up the file system space, according to the rindex.
+ * @sdp: the filesystem
  *
  */
 u64 gfs2_ri_total(struct gfs2_sbd *sdp)
@@ -583,7 +586,8 @@ static int rgd_insert(struct gfs2_rgrpd *rgd)
 
 /**
  * read_rindex_entry - Pull in a new resource index entry from the disk
- * @gl: The glock covering the rindex inode
+ * @ip: The GFS2 inode
+ * @ra_state: The read-ahead state
  *
  * Returns: 0 on success, > 0 on EOF, error code otherwise
  */
@@ -742,7 +746,7 @@ static void gfs2_rgrp_out(struct gfs2_rgrpd *rgd, void *buf)
 
 /**
  * gfs2_rgrp_go_lock - Read in a RG's header and bitmaps
- * @rgd: the struct gfs2_rgrpd describing the RG to read in
+ * @gh: The glock holder for the resource group
  *
  * Read in all of a Resource Group's header and bitmap blocks.
  * Caller must eventually call gfs2_rgrp_relse() to free the bitmaps.
@@ -802,7 +806,7 @@ fail:
 
 /**
  * gfs2_rgrp_go_unlock - Release RG bitmaps read in with gfs2_rgrp_bh_get()
- * @rgd: the struct gfs2_rgrpd describing the RG to read in
+ * @gh: The glock holder for the resource group
  *
  */
 
@@ -1041,6 +1045,8 @@ static inline u32 gfs2_bi2rgd_blk(struct gfs2_bitmap *bi, u32 blk)
 /**
  * try_rgrp_unlink - Look for any unlinked, allocated, but unused inodes
  * @rgd: The rgrp
+ * @last_unlinked: block address of the last dinode we unlinked
+ * @skip: block address we should explicitly not unlink
  *
  * Returns: 0 if no error
  *          The inode, if one has been found, in inode.
@@ -1105,7 +1111,7 @@ static void try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked, u64 skip
 /**
  * get_local_rgrp - Choose and lock a rgrp for allocation
  * @ip: the inode to reserve space for
- * @rgp: the chosen and locked rgrp
+ * @last_unlinked: the last unlinked block
  *
  * Try to acquire rgrp in way which avoids contending with others.
  *
@@ -1174,6 +1180,7 @@ static void gfs2_blkrsv_put(struct gfs2_inode *ip)
 /**
  * gfs2_inplace_reserve - Reserve space in the filesystem
  * @ip: the inode to reserve space for
+ * @requested: the number of blocks to be reserved
  *
  * Returns: errno
  */
@@ -1272,7 +1279,6 @@ static unsigned char gfs2_get_block_type(struct gfs2_rgrpd *rgd, u64 block)
  * @rgd: the resource group descriptor
  * @goal: the goal block within the RG (start here to search for avail block)
  * @state: GFS2_BLKST_XXX the before-allocation state to find
- * @dinode: TRUE if the first block we allocate is for a dinode
  * @rbi: address of the pointer to the bitmap containing the block found
  *
  * Walk rgrp's bitmap to find bits that represent a block in @state.
@@ -1286,8 +1292,7 @@ static unsigned char gfs2_get_block_type(struct gfs2_rgrpd *rgd, u64 block)
  * Returns: the block number found relative to the bitmap rbi
  */
 
-static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal,
-			unsigned char state,
+static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal, unsigned char state,
 			struct gfs2_bitmap **rbi)
 {
 	struct gfs2_bitmap *bi = NULL;
@@ -1756,7 +1761,6 @@ void gfs2_rlist_add(struct gfs2_inode *ip, struct gfs2_rgrp_list *rlist,
  *      and initialize an array of glock holders for them
  * @rlist: the list of resource groups
  * @state: the lock state to acquire the RG lock in
- * @flags: the modifier flags for the holder structures
  *
  * FIXME: Don't use NOFAIL
  *
-- 
1.7.4

