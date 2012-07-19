Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab2GSMmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 08:42:51 -0400
Received: from sh.osrg.net ([192.16.179.4]:52950 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506Ab2GSMmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 08:42:46 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-nilfs <linux-nilfs@vger.kernel.org>,
        Vyacheslav Dubeyko <slava@dubeyko.com>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 1/2] NILFS2: add omitted comments for structures in nilfs2_fs.h
Date: Thu, 19 Jul 2012 21:34:18 +0900
Message-Id: <1342701259-32314-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1342701259-32314-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1342701259-32314-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20070423(IM149)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.7 (sh.osrg.net [192.16.179.4]); Thu, 19 Jul 2012 21:42:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vyacheslav Dubeyko <slava@dubeyko.com>

This patch adds omitted comments for structures in nilfs2_fs.h.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 include/linux/nilfs2_fs.h |   63 ++++++++++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 24 deletions(-)

diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 89bd4a4..9875576 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -293,7 +293,7 @@ struct nilfs_dir_entry {
 	__le64	inode;			/* Inode number */
 	__le16	rec_len;		/* Directory entry length */
 	__u8	name_len;		/* Name length */
-	__u8	file_type;
+	__u8	file_type;		/* Dir entry type (file, dir, etc) */
 	char	name[NILFS_NAME_LEN];	/* File name */
 	char    pad;
 };
@@ -395,7 +395,7 @@ union nilfs_binfo {
 };
 
 /**
- * struct nilfs_segment_summary - segment summary
+ * struct nilfs_segment_summary - segment summary header
  * @ss_datasum: checksum of data
  * @ss_sumsum: checksum of segment summary
  * @ss_magic: magic number
@@ -683,9 +683,9 @@ struct nilfs_sufile_header {
 
 /**
  * nilfs_suinfo - segment usage information
- * @sui_lastmod:
- * @sui_nblocks:
- * @sui_flags:
+ * @sui_lastmod: timestamp of last modification
+ * @sui_nblocks: number of written blocks in segment
+ * @sui_flags: segment usage flags
  */
 struct nilfs_suinfo {
 	__u64 sui_lastmod;
@@ -716,9 +716,10 @@ enum {
 };
 
 /**
- * struct nilfs_cpmode -
- * @cc_cno:
- * @cc_mode:
+ * struct nilfs_cpmode - change checkpoint mode structure
+ * @cm_cno: checkpoint number
+ * @cm_mode: mode of checkpoint
+ * @cm_pad: padding
  */
 struct nilfs_cpmode {
 	__u64 cm_cno;
@@ -728,11 +729,11 @@ struct nilfs_cpmode {
 
 /**
  * struct nilfs_argv - argument vector
- * @v_base:
- * @v_nmembs:
- * @v_size:
- * @v_flags:
- * @v_index:
+ * @v_base: pointer on data array from userspace
+ * @v_nmembs: number of members in data array
+ * @v_size: size of data array in bytes
+ * @v_flags: flags
+ * @v_index: start number of target data items
  */
 struct nilfs_argv {
 	__u64 v_base;
@@ -743,9 +744,9 @@ struct nilfs_argv {
 };
 
 /**
- * struct nilfs_period -
- * @p_start:
- * @p_end:
+ * struct nilfs_period - period of checkpoint numbers
+ * @p_start: start checkpoint number (inclusive)
+ * @p_end: end checkpoint number (exclusive)
  */
 struct nilfs_period {
 	__u64 p_start;
@@ -753,7 +754,7 @@ struct nilfs_period {
 };
 
 /**
- * struct nilfs_cpstat -
+ * struct nilfs_cpstat - checkpoint statistics
  * @cs_cno: checkpoint number
  * @cs_ncps: number of checkpoints
  * @cs_nsss: number of snapshots
@@ -765,7 +766,7 @@ struct nilfs_cpstat {
 };
 
 /**
- * struct nilfs_sustat -
+ * struct nilfs_sustat - segment usage statistics
  * @ss_nsegs: number of segments
  * @ss_ncleansegs: number of clean segments
  * @ss_ndirtysegs: number of dirty segments
@@ -784,10 +785,10 @@ struct nilfs_sustat {
 
 /**
  * struct nilfs_vinfo - virtual block number information
- * @vi_vblocknr:
- * @vi_start:
- * @vi_end:
- * @vi_blocknr:
+ * @vi_vblocknr: virtual block number
+ * @vi_start: start checkpoint number (inclusive)
+ * @vi_end: end checkpoint number (exclusive)
+ * @vi_blocknr: disk block number
  */
 struct nilfs_vinfo {
 	__u64 vi_vblocknr;
@@ -797,7 +798,15 @@ struct nilfs_vinfo {
 };
 
 /**
- * struct nilfs_vdesc -
+ * struct nilfs_vdesc - descriptor of virtual block number
+ * @vd_ino: inode number
+ * @vd_cno: checkpoint number
+ * @vd_vblocknr: virtual block number
+ * @vd_period: period of checkpoint numbers
+ * @vd_blocknr: disk block number
+ * @vd_offset: logical block offset inside a file
+ * @vd_flags: flags (data or node block)
+ * @vd_pad: padding
  */
 struct nilfs_vdesc {
 	__u64 vd_ino;
@@ -811,7 +820,13 @@ struct nilfs_vdesc {
 };
 
 /**
- * struct nilfs_bdesc -
+ * struct nilfs_bdesc - descriptor of disk block number
+ * @bd_ino: inode number
+ * @bd_oblocknr: disk block address (for skipping dead blocks)
+ * @bd_blocknr: disk block address
+ * @bd_offset: logical block offset inside a file
+ * @bd_level: level in the b-tree organization
+ * @bd_pad: padding
  */
 struct nilfs_bdesc {
 	__u64 bd_ino;
-- 
1.7.9.3

