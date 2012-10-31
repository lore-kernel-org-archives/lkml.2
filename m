Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab2JaJkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:40:12 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33761 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab2JaJj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:39:59 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-87-5090f1eda614
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <003d01cdb74b$0c3fa420$24beec60$%kim@samsung.com>
In-reply-to: <003d01cdb74b$0c3fa420$24beec60$%kim@samsung.com>
Subject: [PATCH 02/17] f2fs: add on-disk layout
Date: Wed, 31 Oct 2012 18:39:57 +0900
Message-id: <004001cdb74b$b05c94a0$1115bde0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac23SwwW/9IJbTdIRgmy8VWYLJ8GMwAAI9jQ
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zI923HycEGHz6rGmxZ+9JFovLu+aw
	OTB5fN4kF8AYxWWTkpqTWZZapG+XwJVx8MMyxoKHhRW79pxlaWD8E93FyMkhIWAi8Xn9OSYI
	W0ziwr31bF2MXBxCAssYJR5dv8EKU7S3+w8TRGI6o8Ssm8/YIZx/jBJrvkxg7GLk4GAT0JbY
	vN8AJC4i8JBRYv+zpewg3UICthJP719jB6nhFLCTuHwiAiQsLKAvcf/YdxaQMIuAqkTjqhKQ
	MC9QddObi+wQtqDEj8n3WEBsZgF1iUnzFjFD2PISm9e8ZQZplQCKP/qrCxIWETCS+DX3OCtE
	ibjEpAcPwcawCAhIfJt8iAWiXFZi0wFmkCMlBJaxS+z+eJkd4kVJiYMrbrBMYBSfhWTzLCSb
	ZyHZPAvJigWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxQiJJagfjygaLQ4wCHIxKPLyG
	//oDhFgTy4orcw8xSnAwK4nwNlyfECDEm5JYWZValB9fVJqTWnyI0Qfo8onMUqLJ+cAozyuJ
	NzQ2NjEzMTUxtzQ1N8UhrCTO2+yREiAkkJ5YkpqdmlqQWgQzjomDU6qBMVfCvLPY2b7/03km
	q6B1okdED7Yt3Kz956p0HdOxBueiGTP7975zuZeiwvHPZGOWiJOw3+mWYvcC888tK7Y9ORDm
	/sKwZNUfdfYNbj8a2q64RNRpiO6pLj74o1dJXnqJ7IvMbGH+OeJSM1Z0XA74cKXNMF+/+KlZ
	9+Ltbh3clY+7y58k3z+mxFKckWioxVxUnAgAwDCghdECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t9jQd23HycEGLStULHYs/cki8XlXXPY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMOPhhGWPBw8KK
	XXvOsjQw/onuYuTkkBAwkdjb/YcJwhaTuHBvPVsXIxeHkMB0RolZN5+xQzj/GCXWfJnA2MXI
	wcEmoC2xeb8BSFxE4CGjxP5nS9lBuoUEbCWe3r/GDlLDKWAncflEBEhYWEBf4v6x7ywgYRYB
	VYnGVSUgYV6g6qY3F9khbEGJH5PvsYDYzALqEpPmLWKGsOUlNq95ywzSKgEUf/RXFyQsImAk
	8WvucVaIEnGJSQ8esk9gFJyFZNIsJJNmIZk0C0nLAkaWVYyiqQXJBcVJ6bmGesWJucWleel6
	yfm5mxjBcfpMagfjygaLQ4wCHIxKPLyG//oDhFgTy4orcw8xSnAwK4nwNlyfECDEm5JYWZVa
	lB9fVJqTWnyI0Qfoz4nMUqLJ+cAUklcSb2hsYmZkaWRmYWRibo5DWEmct9kjJUBIID2xJDU7
	NbUgtQhmHBMHp1QD4ybXp31FHT9+LP+8a/KpuRn81268zxboXp4vWZc5fZG7GF+fx7QNVZ8X
	9r6csW+/hKjExlPnXj98a90n9Hbz8fdn1yVVFOcU3bu6aEp+WcaqV18t3ixffunEeuEYXwHx
	nhreaN4zF5YsurmW+0qU5TbR+TP9bgv8Xvh48sl3D3o/rd72w/2dWMBNJZbijERDLeai4kQA
	FtXDcwADAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a header file describing the on-disk layout of f2fs.

Signed-off-by: Changman Lee <cm224.lee@samsung.com>
Signed-off-by: Chul Lee <chur.lee@samsung.com>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 include/linux/f2fs_fs.h |  410 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 410 insertions(+)
 create mode 100644 include/linux/f2fs_fs.h

diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
new file mode 100644
index 0000000..1429ece
--- /dev/null
+++ b/include/linux/f2fs_fs.h
@@ -0,0 +1,410 @@
+/**
+ * include/linux/f2fs_fs.h
+ *
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *             http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef _LINUX_F2FS_FS_H
+#define _LINUX_F2FS_FS_H
+
+#include <linux/pagemap.h>
+#include <linux/types.h>
+
+#define F2FS_SUPER_OFFSET		1024	/* byte-size offset */
+#define F2FS_LOG_SECTOR_SIZE		9	/* 9 bits for 512 byte */
+#define F2FS_LOG_SECTORS_PER_BLOCK	3	/* 4KB: F2FS_BLKSIZE */
+#define F2FS_BLKSIZE			4096	/* support only 4KB block */
+#define F2FS_MAX_EXTENSION		64	/* # of extension entries */
+
+#define NULL_ADDR		0x0U
+#define NEW_ADDR		-1U
+
+#define F2FS_ROOT_INO(sbi)	(sbi->root_ino_num)
+#define F2FS_NODE_INO(sbi)	(sbi->node_ino_num)
+#define F2FS_META_INO(sbi)	(sbi->meta_ino_num)
+
+/* This flag is used by node and meta inodes, and by recovery */
+#define GFP_F2FS_ZERO	(GFP_NOFS | __GFP_ZERO)
+
+/*
+ * For further optimization on multi-head logs, on-disk layout supports maximum
+ * 16 logs by default. The number, 16, is expected to cover all the cases
+ * enoughly. The implementaion currently uses no more than 6 logs.
+ * Half the logs are used for nodes, and the other half are used for data.
+ */
+#define MAX_ACTIVE_LOGS	16
+#define MAX_ACTIVE_NODE_LOGS	8
+#define MAX_ACTIVE_DATA_LOGS	8
+
+/*
+ * For superblock
+ */
+struct f2fs_super_block {
+	__le32 magic;			/* Magic Number */
+	__le16 major_ver;		/* Major Version */
+	__le16 minor_ver;		/* Minor Version */
+	__le32 log_sectorsize;		/* log2 sector size in bytes */
+	__le32 log_sectors_per_block;	/* log2 # of sectors per block */
+	__le32 log_blocksize;		/* log2 block size in bytes */
+	__le32 log_blocks_per_seg;	/* log2 # of blocks per segment */
+	__le32 segs_per_sec;		/* # of segments per section */
+	__le32 secs_per_zone;		/* # of sections per zone */
+	__le32 checksum_offset;		/* checksum offset inside super block */
+	__le64 block_count;		/* total # of user blocks */
+	__le32 section_count;		/* total # of sections */
+	__le32 segment_count;		/* total # of segments */
+	__le32 segment_count_ckpt;	/* # of segments for checkpoint */
+	__le32 segment_count_sit;	/* # of segments for SIT */
+	__le32 segment_count_nat;	/* # of segments for NAT */
+	__le32 segment_count_ssa;	/* # of segments for SSA */
+	__le32 segment_count_main;	/* # of segments for main area */
+	__le32 segment0_blkaddr;	/* start block address of segment 0 */
+	__le32 cp_blkaddr;		/* start block address of checkpoint */
+	__le32 sit_blkaddr;		/* start block address of SIT */
+	__le32 nat_blkaddr;		/* start block address of NAT */
+	__le32 ssa_blkaddr;		/* start block address of SSA */
+	__le32 main_blkaddr;		/* start block address of main area */
+	__le32 root_ino;		/* root inode number */
+	__le32 node_ino;		/* node inode number */
+	__le32 meta_ino;		/* meta inode number */
+	__u8 uuid[16];			/* 128-bit uuid for volume */
+	__le16 volume_name[512];	/* volume name */
+	__le32 extension_count;		/* # of extensions below */
+	__u8 extension_list[F2FS_MAX_EXTENSION][8];	/* extension array */
+} __packed;
+
+/*
+ * For checkpoint
+ */
+#define CP_ERROR_FLAG		0x00000008
+#define CP_COMPACT_SUM_FLAG	0x00000004
+#define CP_ORPHAN_PRESENT_FLAG	0x00000002
+#define CP_UMOUNT_FLAG		0x00000001
+
+struct f2fs_checkpoint {
+	__le64 checkpoint_ver;		/* checkpoint block version number */
+	__le64 user_block_count;	/* # of user blocks */
+	__le64 valid_block_count;	/* # of valid blocks in main area */
+	__le32 rsvd_segment_count;	/* # of reserved segments for gc */
+	__le32 overprov_segment_count;	/* # of overprovision segments */
+	__le32 free_segment_count;	/* # of free segments in main area */
+
+	/* information of current node segments */
+	__le32 cur_node_segno[MAX_ACTIVE_NODE_LOGS];
+	__le16 cur_node_blkoff[MAX_ACTIVE_NODE_LOGS];
+	/* information of current data segments */
+	__le32 cur_data_segno[MAX_ACTIVE_DATA_LOGS];
+	__le16 cur_data_blkoff[MAX_ACTIVE_DATA_LOGS];
+	__le32 ckpt_flags;		/* Flags : umount and journal_present */
+	__le32 cp_pack_total_block_count;	/* total # of one cp pack */
+	__le32 cp_pack_start_sum;	/* start block number of data summary */
+	__le32 valid_node_count;	/* Total number of valid nodes */
+	__le32 valid_inode_count;	/* Total number of valid inodes */
+	__le32 next_free_nid;		/* Next free node number */
+	__le32 sit_ver_bitmap_bytesize;	/* Default value 64 */
+	__le32 nat_ver_bitmap_bytesize; /* Default value 256 */
+	__le32 checksum_offset;		/* checksum offset inside cp block */
+	__le64 elapsed_time;		/* mounted time */
+	/* allocation type of current segment */
+	unsigned char alloc_type[MAX_ACTIVE_LOGS];
+
+	/* SIT and NAT version bitmap */
+	unsigned char sit_nat_version_bitmap[1];
+} __packed;
+
+/*
+ * For orphan inode management
+ */
+#define F2FS_ORPHANS_PER_BLOCK	1020
+
+struct f2fs_orphan_block {
+	__le32 ino[F2FS_ORPHANS_PER_BLOCK];	/* inode numbers */
+	__le32 reserved;	/* reserved */
+	__le16 blk_addr;	/* block index in current CP */
+	__le16 blk_count;	/* Number of orphan inode blocks in CP */
+	__le32 entry_count;	/* Total number of orphan nodes in current CP */
+	__le32 check_sum;	/* CRC32 for orphan inode block */
+} __packed;
+
+/*
+ * For NODE structure
+ */
+struct f2fs_extent {
+	__le32 fofs;		/* start file offset of the extent */
+	__le32 blk_addr;	/* start block address of the extent */
+	__le32 len;		/* lengh of the extent */
+} __packed;
+
+#define F2FS_MAX_NAME_LEN	256
+#define ADDRS_PER_INODE         923	/* Address Pointers in an Inode */
+#define ADDRS_PER_BLOCK         1018	/* Address Pointers in a Direct Block */
+#define NIDS_PER_BLOCK          1018	/* Node IDs in an Indirect Block */
+
+struct f2fs_inode {
+	__le16 i_mode;			/* file mode */
+	__u8 i_advise;			/* file hints */
+	__u8 i_reserved;		/* reserved */
+	__le32 i_uid;			/* user ID */
+	__le32 i_gid;			/* group ID */
+	__le32 i_links;			/* links count */
+	__le64 i_size;			/* file size in bytes */
+	__le64 i_blocks;		/* file size in blocks */
+	__le64 i_atime;			/* access time */
+	__le64 i_ctime;			/* change time */
+	__le64 i_mtime;			/* modification time */
+	__le32 i_atime_nsec;		/* access time in nano scale */
+	__le32 i_ctime_nsec;		/* change time in nano scale */
+	__le32 i_mtime_nsec;		/* modification time in nano scale */
+	__le32 i_generation;		/* file version (for NFS) */
+	__le32 i_current_depth;		/* only for directory depth */
+	__le32 i_xattr_nid;		/* nid to save xattr */
+	__le32 i_flags;			/* file attributes */
+	__le32 i_pino;			/* parent inode number */
+	__le32 i_namelen;		/* file name length */
+	__u8 i_name[F2FS_MAX_NAME_LEN];	/* file name for SPOR */
+
+	struct f2fs_extent i_ext;	/* caching a largest extent */
+
+	__le32 i_addr[ADDRS_PER_INODE];	/* Pointers to data blocks */
+
+	__le32 i_nid[5];		/* direct(2), indirect(2),
+						double_indirect(1) node id */
+} __packed;
+
+struct direct_node {
+	__le32 addr[ADDRS_PER_BLOCK];	/* array of data block address */
+} __packed;
+
+struct indirect_node {
+	__le32 nid[NIDS_PER_BLOCK];	/* array of data block address */
+} __packed;
+
+enum {
+	COLD_BIT_SHIFT = 0,
+	FSYNC_BIT_SHIFT,
+	DENT_BIT_SHIFT,
+	OFFSET_BIT_SHIFT
+};
+
+struct node_footer {
+	__le32 nid;		/* node id */
+	__le32 ino;		/* inode nunmber */
+	__le32 flag;		/* include cold/fsync/dentry marks and offset */
+	__le64 cp_ver;		/* checkpoint version */
+	__le32 next_blkaddr;	/* next node page block address */
+} __packed;
+
+struct f2fs_node {
+	/* can be one of three types: inode, direct, and indirect types */
+	union {
+		struct f2fs_inode i;
+		struct direct_node dn;
+		struct indirect_node in;
+	};
+	struct node_footer footer;
+} __packed;
+
+/*
+ * For NAT entries
+ */
+#define NAT_ENTRY_PER_BLOCK (PAGE_CACHE_SIZE / sizeof(struct f2fs_nat_entry))
+
+struct f2fs_nat_entry {
+	__u8 version;		/* latest version of cached nat entry */
+	__le32 ino;		/* inode number */
+	__le32 block_addr;	/* block address */
+} __packed;
+
+struct f2fs_nat_block {
+	struct f2fs_nat_entry entries[NAT_ENTRY_PER_BLOCK];
+} __packed;
+
+/*
+ * For SIT entries
+ *
+ * Each segment is 2MB in size by default so that a bitmap for validity of
+ * there-in blocks should occupy 64 bytes, 512 bits.
+ * Not allow to change this.
+ */
+#define SIT_VBLOCK_MAP_SIZE 64
+#define SIT_ENTRY_PER_BLOCK (PAGE_CACHE_SIZE / sizeof(struct f2fs_sit_entry))
+
+/*
+ * Note that f2fs_sit_entry->vblocks has the following bit-field information.
+ * [15:10] : allocation type such as CURSEG_XXXX_TYPE
+ * [9:0] : valid block count
+ */
+#define SIT_VBLOCKS_SHIFT	10
+#define SIT_VBLOCKS_MASK	((1 << SIT_VBLOCKS_SHIFT) - 1)
+#define GET_SIT_VBLOCKS(raw_sit)				\
+	(le16_to_cpu((raw_sit)->vblocks) & SIT_VBLOCKS_MASK)
+#define GET_SIT_TYPE(raw_sit)					\
+	((le16_to_cpu((raw_sit)->vblocks) & ~SIT_VBLOCKS_MASK)	\
+	 >> SIT_VBLOCKS_SHIFT)
+
+struct f2fs_sit_entry {
+	__le16 vblocks;				/* reference above */
+	__u8 valid_map[SIT_VBLOCK_MAP_SIZE];	/* bitmap for valid blocks */
+	__le64 mtime;				/* segment age for cleaning */
+} __packed;
+
+struct f2fs_sit_block {
+	struct f2fs_sit_entry entries[SIT_ENTRY_PER_BLOCK];
+} __packed;
+
+/*
+ * For segment summary
+ *
+ * One summary block contains exactly 512 summary entries, which represents
+ * exactly 2MB segment by default. Not allow to change the basic units.
+ *
+ * NOTE: For initializing fields, you must use set_summary
+ *
+ * - If data page, nid represents dnode's nid
+ * - If node page, nid represents the node page's nid.
+ *
+ * The ofs_in_node is used by only data page. It represents offset
+ * from node's page's beginning to get a data block address.
+ * ex) data_blkaddr = (block_t)(nodepage_start_address + ofs_in_node)
+ */
+#define ENTRIES_IN_SUM		512
+#define	SUMMARY_SIZE		(sizeof(struct f2fs_summary))
+#define	SUM_FOOTER_SIZE		(sizeof(struct summary_footer))
+#define SUM_ENTRY_SIZE		(SUMMARY_SIZE * ENTRIES_IN_SUM)
+
+/* a summary entry for a 4KB-sized block in a segment */
+struct f2fs_summary {
+	__le32 nid;		/* parent node id */
+	union {
+		__u8 reserved[3];
+		struct {
+			__u8 version;		/* node version number */
+			__le16 ofs_in_node;	/* block index in parent node */
+		} __packed;
+	};
+} __packed;
+
+/* summary block type, node or data, is stored to the summary_footer */
+#define SUM_TYPE_NODE		(1)
+#define SUM_TYPE_DATA		(0)
+
+struct summary_footer {
+	unsigned char entry_type;	/* SUM_TYPE_XXX */
+	__u32 check_sum;		/* summary checksum */
+} __packed;
+
+#define SUM_JOURNAL_SIZE	(PAGE_CACHE_SIZE - SUM_FOOTER_SIZE -\
+				SUM_ENTRY_SIZE)
+#define NAT_JOURNAL_ENTRIES	((SUM_JOURNAL_SIZE - 2) /\
+				sizeof(struct nat_journal_entry))
+#define NAT_JOURNAL_RESERVED	((SUM_JOURNAL_SIZE - 2) %\
+				sizeof(struct nat_journal_entry))
+#define SIT_JOURNAL_ENTRIES	((SUM_JOURNAL_SIZE - 2) /\
+				sizeof(struct sit_journal_entry))
+#define SIT_JOURNAL_RESERVED	((SUM_JOURNAL_SIZE - 2) %\
+				sizeof(struct sit_journal_entry))
+/*
+ * frequently updated NAT/SIT entries can be stored in the spare area in
+ * summary blocks
+ */
+enum {
+	NAT_JOURNAL = 0,
+	SIT_JOURNAL
+};
+
+struct nat_journal_entry {
+	__le32 nid;
+	struct f2fs_nat_entry ne;
+} __packed;
+
+struct nat_journal {
+	struct nat_journal_entry entries[NAT_JOURNAL_ENTRIES];
+	__u8 reserved[NAT_JOURNAL_RESERVED];
+} __packed;
+
+struct sit_journal_entry {
+	__le32 segno;
+	struct f2fs_sit_entry se;
+} __packed;
+
+struct sit_journal {
+	struct sit_journal_entry entries[SIT_JOURNAL_ENTRIES];
+	__u8 reserved[SIT_JOURNAL_RESERVED];
+} __packed;
+
+/* 4KB-sized summary block structure */
+struct f2fs_summary_block {
+	struct f2fs_summary entries[ENTRIES_IN_SUM];
+	union {
+		__le16 n_nats;
+		__le16 n_sits;
+	};
+	/* spare area is used by NAT or SIT journals */
+	union {
+		struct nat_journal nat_j;
+		struct sit_journal sit_j;
+	};
+	struct summary_footer footer;
+} __packed;
+
+/*
+ * For directory operations
+ */
+#define F2FS_DOT_HASH		0
+#define F2FS_DDOT_HASH		F2FS_DOT_HASH
+#define F2FS_MAX_HASH		(~((0x3ULL) << 62))
+#define F2FS_HASH_COL_BIT	((0x1ULL) << 63)
+
+typedef __le32	f2fs_hash_t;
+
+/* One directory entry slot covers 8bytes-long file name */
+#define F2FS_NAME_LEN		8
+
+/* the number of dentry in a block */
+#define NR_DENTRY_IN_BLOCK	214
+
+/* MAX level for dir lookup */
+#define MAX_DIR_HASH_DEPTH	63
+
+#define SIZE_OF_DIR_ENTRY	11	/* by byte */
+#define SIZE_OF_DENTRY_BITMAP	((NR_DENTRY_IN_BLOCK + BITS_PER_BYTE - 1) / \
+					BITS_PER_BYTE)
+#define SIZE_OF_RESERVED	(PAGE_SIZE - ((SIZE_OF_DIR_ENTRY + \
+				F2FS_NAME_LEN) * \
+				NR_DENTRY_IN_BLOCK + SIZE_OF_DENTRY_BITMAP))
+
+/* One directory entry slot representing F2FS_NAME_LEN-sized file name */
+struct f2fs_dir_entry {
+	__le32 hash_code;	/* hash code of file name */
+	__le32 ino;		/* inode number */
+	__le16 name_len;	/* lengh of file name */
+	__u8 file_type;		/* file type */
+} __packed;
+
+/* 4KB-sized directory entry block */
+struct f2fs_dentry_block {
+	/* validity bitmap for directory entries in each block */
+	__u8 dentry_bitmap[SIZE_OF_DENTRY_BITMAP];
+	__u8 reserved[SIZE_OF_RESERVED];
+	struct f2fs_dir_entry dentry[NR_DENTRY_IN_BLOCK];
+	__u8 filename[NR_DENTRY_IN_BLOCK][F2FS_NAME_LEN];
+} __packed;
+
+/* file types used in inode_info->flags */
+enum {
+	F2FS_FT_UNKNOWN,
+	F2FS_FT_REG_FILE,
+	F2FS_FT_DIR,
+	F2FS_FT_CHRDEV,
+	F2FS_FT_BLKDEV,
+	F2FS_FT_FIFO,
+	F2FS_FT_SOCK,
+	F2FS_FT_SYMLINK,
+	F2FS_FT_MAX
+};
+
+#endif  /* _LINUX_F2FS_FS_H */
-- 
1.7.9.5




---
Jaegeuk Kim
Samsung


