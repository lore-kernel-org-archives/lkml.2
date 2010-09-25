Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab0IYSdA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 14:33:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41084 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098Ab0IYSc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 14:32:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=C6cKs7DZJGTuZyS8Syt98wDVU4OCfsQH05eaLtZhSvmVJLokXIpU/MT31vKQ+tuPK2
         +8T/7+fVduC7Nobqk72IVzUelZf74a/eNwpRbhbBfRNxuywuQlE1uuqjTRHcpehEYDOi
         YFk+T7s8nd/d8xUQngwLbk1LN4KjVvn64dFds=
From: Tracey Dent <tdent48227@gmail.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca, jack@suse.cz, dmonakhov@openvz.org,
        sandeen@redhat.com, hch@lst.de, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tracey Dent <Tdent48227@gmail.com>,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 05/10] Fs: ext4: ext4: cleaned up the file with checkpatch.pl
Date: Sat, 25 Sep 2010 14:31:56 -0400
Message-Id: <1285439521-2557-5-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tracey Dent <Tdent48227@gmail.com>

Fixed numerous issues that checkpatch.pl was having with the file

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 fs/ext4/ext4.h |   43 ++++++++++++++++++++-----------------------
 1 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 889ec9d..6aa5871 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -233,8 +233,7 @@ typedef struct ext4_io_end {
 /*
  * Structure of a blocks group descriptor
  */
-struct ext4_group_desc
-{
+struct ext4_group_desc	{
 	__le32	bg_block_bitmap_lo;	/* Blocks bitmap block */
 	__le32	bg_inode_bitmap_lo;	/* Inodes bitmap block */
 	__le32	bg_inode_table_lo;	/* Inodes table block */
@@ -513,8 +512,8 @@ struct ext4_new_group_data {
 #define EXT4_IOC_GROUP_EXTEND		_IOW('f', 7, unsigned long)
 #define EXT4_IOC_GROUP_ADD		_IOW('f', 8, struct ext4_new_group_input)
 #define EXT4_IOC_MIGRATE		_IO('f', 9)
- /* note ioctl 10 reserved for an early version of the FIEMAP ioctl */
- /* note ioctl 11 reserved for filesystem-independent FIEMAP ioctl */
+	/* note ioctl 10 reserved for an early version of the FIEMAP ioctl */
+	/* note ioctl 11 reserved for filesystem-independent FIEMAP ioctl */
 #define EXT4_IOC_ALLOC_DA_BLKS		_IO('f', 12)
 #define EXT4_IOC_MOVE_EXT		_IOWR('f', 15, struct move_extent)
 
@@ -649,17 +648,17 @@ struct move_extent {
 
 static inline __le32 ext4_encode_extra_time(struct timespec *time)
 {
-       return cpu_to_le32((sizeof(time->tv_sec) > 4 ?
-			   (time->tv_sec >> 32) & EXT4_EPOCH_MASK : 0) |
-                          ((time->tv_nsec << EXT4_EPOCH_BITS) & EXT4_NSEC_MASK));
+		return cpu_to_le32((sizeof(time->tv_sec) > 4 ?
+				(time->tv_sec >> 32) & EXT4_EPOCH_MASK : 0) |
+						((time->tv_nsec << EXT4_EPOCH_BITS) & EXT4_NSEC_MASK));
 }
 
 static inline void ext4_decode_extra_time(struct timespec *time, __le32 extra)
 {
-       if (sizeof(time->tv_sec) > 4)
+		if (sizeof(time->tv_sec) > 4)
 	       time->tv_sec |= (__u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK)
 			       << 32;
-       time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >> EXT4_EPOCH_BITS;
+		time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >> EXT4_EPOCH_BITS;
 }
 
 #define EXT4_INODE_SET_XTIME(xtime, inode, raw_inode)			       \
@@ -1261,23 +1260,23 @@ EXT4_INODE_BIT_FNS(state, state_flags)
  * Feature set definitions
  */
 
-#define EXT4_HAS_COMPAT_FEATURE(sb,mask)			\
+#define EXT4_HAS_COMPAT_FEATURE(sb, mask)			\
 	((EXT4_SB(sb)->s_es->s_feature_compat & cpu_to_le32(mask)) != 0)
-#define EXT4_HAS_RO_COMPAT_FEATURE(sb,mask)			\
+#define EXT4_HAS_RO_COMPAT_FEATURE(sb, mask)			\
 	((EXT4_SB(sb)->s_es->s_feature_ro_compat & cpu_to_le32(mask)) != 0)
-#define EXT4_HAS_INCOMPAT_FEATURE(sb,mask)			\
+#define EXT4_HAS_INCOMPAT_FEATURE(sb, mask)			\
 	((EXT4_SB(sb)->s_es->s_feature_incompat & cpu_to_le32(mask)) != 0)
-#define EXT4_SET_COMPAT_FEATURE(sb,mask)			\
+#define EXT4_SET_COMPAT_FEATURE(sb, mask)			\
 	EXT4_SB(sb)->s_es->s_feature_compat |= cpu_to_le32(mask)
-#define EXT4_SET_RO_COMPAT_FEATURE(sb,mask)			\
+#define EXT4_SET_RO_COMPAT_FEATURE(sb, mask)			\
 	EXT4_SB(sb)->s_es->s_feature_ro_compat |= cpu_to_le32(mask)
-#define EXT4_SET_INCOMPAT_FEATURE(sb,mask)			\
+#define EXT4_SET_INCOMPAT_FEATURE(sb, mask)			\
 	EXT4_SB(sb)->s_es->s_feature_incompat |= cpu_to_le32(mask)
-#define EXT4_CLEAR_COMPAT_FEATURE(sb,mask)			\
+#define EXT4_CLEAR_COMPAT_FEATURE(sb, mask)			\
 	EXT4_SB(sb)->s_es->s_feature_compat &= ~cpu_to_le32(mask)
-#define EXT4_CLEAR_RO_COMPAT_FEATURE(sb,mask)			\
+#define EXT4_CLEAR_RO_COMPAT_FEATURE(sb, mask)			\
 	EXT4_SB(sb)->s_es->s_feature_ro_compat &= ~cpu_to_le32(mask)
-#define EXT4_CLEAR_INCOMPAT_FEATURE(sb,mask)			\
+#define EXT4_CLEAR_INCOMPAT_FEATURE(sb, mask)			\
 	EXT4_SB(sb)->s_es->s_feature_incompat &= ~cpu_to_le32(mask)
 
 #define EXT4_FEATURE_COMPAT_DIR_PREALLOC	0x0001
@@ -1471,8 +1470,7 @@ static inline __le16 ext4_rec_len_to_disk(unsigned len, unsigned blocksize)
 #ifdef __KERNEL__
 
 /* hash info structure used by the directory hash */
-struct dx_hash_info
-{
+struct dx_hash_info		{
 	u32		hash;
 	u32		minor_hash;
 	int		hash_version;
@@ -1490,8 +1488,7 @@ struct dx_hash_info
 /*
  * Describe an inode's exact location on disk and in memory
  */
-struct ext4_iloc
-{
+struct ext4_iloc		{
 	struct buffer_head *bh;
 	unsigned long offset;
 	ext4_group_t block_group;
@@ -1947,7 +1944,7 @@ static inline void ext4_unlock_group(struct super_block *sb,
 static inline void ext4_mark_super_dirty(struct super_block *sb)
 {
 	if (EXT4_SB(sb)->s_journal == NULL)
-		sb->s_dirt =1;
+		sb->s_dirt = 1;
 }
 
 /*
-- 
1.7.3

