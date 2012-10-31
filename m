Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760945Ab2JaWjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 18:39:11 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:38694 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab2JaWjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 18:39:07 -0400
X-AuditID: cbfee61b-b7f616d00000319b-2c-5091a8547220
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: "'Greg KH'" <gregkh@linuxfoundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, arnd@arndb.de, tytso@mit.edu,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <003d01cdb74b$0c3fa420$24beec60$%kim@samsung.com>
 <004d01cdb74d$07583b00$1608b100$%kim@samsung.com>
 <20121031155140.GB31543@kroah.com>
 <00f501cdb7b1$81ba5860$852f0920$%kim@samsung.com>
In-reply-to: <00f501cdb7b1$81ba5860$852f0920$%kim@samsung.com>
Subject: [PATCH 16/17 v2] f2fs: move proc files to debugfs
Date: Thu, 01 Nov 2012 07:38:12 +0900
Message-id: <00fb01cdb7b8$68dcaad0$3a960070$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac23f6Fjd3HkMJBoTG2iR+6V5Y3BSgAMWyAAAAG4RFA=
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zQ92QFRMDDG4fMrPYs/cki8XlXXPY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4MrY97ybveBcesWCtvNsDYzzQ7sYOTkkBEwkfp2axwhh
	i0lcuLeerYuRi0NIYBmjxKo7/1hhis79PwBWJCQwnVHi+N4YiKJ/jBLNt7cydTFycLAJaEts
	3m8AUiMioCXx7NgOZpAaZoHDjBKfHi1mgWg4xSixeEU/G0gVp4CdxOnNL8E2CAtYSbQ3Twez
	WQRUJX5NfMkEYvMK2ErsOrgIyhaU+DH5HguIzSygJ/Hxz21GCFteYvOat8wgR0gIqEs8+qsL
	cYSVxOfTR5khSsQlJj14yA4xXkDi2+RDLBDlshKbDoDdKSGwjl3iypol7BAPS0ocXHGDZQKj
	xCwkm2ch2TwLyeZZSFYsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRESZdI7GFc1WBxi
	FOBgVOLhnVA3MUCINbGsuDL3EKMEB7OSCO/jbqAQb0piZVVqUX58UWlOavEhRh+gyycyS4km
	5wMTQF5JvKGxsYmZiamJuaWpuSkOYSVx3maPlAAhgfTEktTs1NSC1CKYcUwcnFINjNNvuLJN
	E767oI7nr0ELf6fbX3bhRsFfr1atK8rxjVIvaHx9tDZWt+DNsqW/DE4UTVvcseD341nH1AT1
	Krt319+5YB3asjlb/sPT5IQFd/9UrvwR80Zw4ZaND/pzayYV1GsazpV1uFNiocqg6B9secCn
	/9mz46mJeUXLt6ecTJt0Y0b4zu9crEosxRmJhlrMRcWJADpBs+7fAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jQd2QFRMDDF7d07fYs/cki8XlXXPY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM2Pe8m73gXHrF
	grbzbA2M80O7GDk5JARMJM79P8AIYYtJXLi3ng3EFhKYzihxfG9MFyMXkP2PUaL59lamLkYO
	DjYBbYnN+w1AakQEtCSeHdvBDFLDLHCYUeLTo8UsEA2nGCUWr+gHm8QpYCdxevNLVhBbWMBK
	or15OpjNIqAq8WviSyYQm1fAVmLXwUVQtqDEj8n3WEBsZgE9iY9/bjNC2PISm9e8ZQY5QkJA
	XeLRX12II6wkPp8+ygxRIi4x6cFD9gmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddI
	rzgxt7g0L10vOT93EyM4hp9J72Bc1WBxiFGAg1GJh3dC3cQAIdbEsuLK3EOMEhzMSiK8j7uB
	QrwpiZVVqUX58UWlOanFhxh9gB6dyCwlmpwPTC95JfGGxiZmRpZGZhZGJubmOISVxHmbPVIC
	hATSE0tSs1NTC1KLYMYxcXBKNTB6/JvJmDJxwsJNru7mh/Y/+PPXd1md7fr2NeUl+daP0+o4
	dB4f+2KtcOxUyIbNqdyfDojEmast+VvAeX9D5uN3c5d+O+Y4z/7B/UWut7q/5H5yTPH4NPH+
	sodZLN3f67azNC1t9tnl3LnFNeFX6+v5514GiH6J8558Jj7+UvWE3WeDkyqiVwlNVmIpzkg0
	1GIuKk4EADqNckQOAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This moves all of the f2fs debugging files into debugfs. The files are
located in /sys/kernel/debug/f2fs/

Note, I think we are generating all of the same information in each of
the files for every unique f2fs filesystem in the machine.  This copies
the functionality that was present in the proc files, but this should be
fixed up in the future.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[jaegeuk.kim@samsung.com: merged 3 debugfs entries into a *status* entry]
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/debug.c |  361 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 361 insertions(+)
 create mode 100644 fs/f2fs/debug.c

diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
new file mode 100644
index 0000000..a56181c
--- /dev/null
+++ b/fs/f2fs/debug.c
@@ -0,0 +1,361 @@
+/**
+ * f2fs debugging statistics
+ *
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *             http://www.samsung.com/
+ * Copyright (c) 2012 Linux Foundation
+ * Copyright (c) 2012 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/fs.h>
+#include <linux/backing-dev.h>
+#include <linux/proc_fs.h>
+#include <linux/f2fs_fs.h>
+#include <linux/blkdev.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+#include "f2fs.h"
+#include "node.h"
+#include "segment.h"
+#include "gc.h"
+
+static LIST_HEAD(f2fs_stat_list);
+static struct dentry *debugfs_root;
+
+void update_general_status(struct f2fs_sb_info *sbi)
+{
+	struct f2fs_stat_info *si = sbi->stat_info;
+	int i;
+
+	/* valid check of the segment numbers */
+	si->hit_ext = sbi->read_hit_ext;
+	si->total_ext = sbi->total_hit_ext;
+	si->ndirty_node = get_pages(sbi, F2FS_DIRTY_NODES);
+	si->ndirty_dent = get_pages(sbi, F2FS_DIRTY_DENTS);
+	si->ndirty_dirs = sbi->n_dirty_dirs;
+	si->ndirty_meta = get_pages(sbi, F2FS_DIRTY_META);
+	si->total_count = (int)sbi->user_block_count / sbi->blocks_per_seg;
+	si->rsvd_segs = reserved_segments(sbi);
+	si->overp_segs = overprovision_segments(sbi);
+	si->valid_count = valid_user_blocks(sbi);
+	si->valid_node_count = valid_node_count(sbi);
+	si->valid_inode_count = valid_inode_count(sbi);
+	si->utilization = utilization(sbi);
+
+	si->free_segs = free_segments(sbi);
+	si->free_secs = free_sections(sbi);
+	si->prefree_count = prefree_segments(sbi);
+	si->dirty_count = dirty_segments(sbi);
+	si->node_pages = sbi->node_inode->i_mapping->nrpages;
+	si->meta_pages = sbi->meta_inode->i_mapping->nrpages;
+	si->nats = NM_I(sbi)->nat_cnt;
+	si->sits = SIT_I(sbi)->dirty_sentries;
+	si->fnids = NM_I(sbi)->fcnt;
+	si->bg_gc = sbi->bg_gc;
+	si->util_free = (int)(free_user_blocks(sbi) >> sbi->log_blocks_per_seg)
+		* 100 / (int)(sbi->user_block_count >> sbi->log_blocks_per_seg)
+		/ 2;
+	si->util_valid = (int)(written_block_count(sbi) >>
+						sbi->log_blocks_per_seg)
+		* 100 / (int)(sbi->user_block_count >> sbi->log_blocks_per_seg)
+		/ 2;
+	si->util_invalid = 50 - si->util_free - si->util_valid;
+	for (i = CURSEG_HOT_DATA; i <= CURSEG_COLD_NODE; i++) {
+		struct curseg_info *curseg = CURSEG_I(sbi, i);
+		si->curseg[i] = curseg->segno;
+		si->cursec[i] = curseg->segno / sbi->segs_per_sec;
+		si->curzone[i] = si->cursec[i] / sbi->secs_per_zone;
+	}
+
+	for (i = 0; i < 2; i++) {
+		si->segment_count[i] = sbi->segment_count[i];
+		si->block_count[i] = sbi->block_count[i];
+	}
+}
+
+/**
+ * This function calculates BDF of every segments
+ */
+static void update_sit_info(struct f2fs_sb_info *sbi)
+{
+	struct f2fs_stat_info *si = sbi->stat_info;
+	unsigned int blks_per_sec, hblks_per_sec, total_vblocks, bimodal, dist;
+	struct sit_info *sit_i = SIT_I(sbi);
+	unsigned int segno, vblocks;
+	int ndirty = 0;
+
+	bimodal = 0;
+	total_vblocks = 0;
+	blks_per_sec = sbi->segs_per_sec * (1 << sbi->log_blocks_per_seg);
+	hblks_per_sec = blks_per_sec / 2;
+	mutex_lock(&sit_i->sentry_lock);
+	for (segno = 0; segno < TOTAL_SEGS(sbi); segno += sbi->segs_per_sec) {
+		vblocks = get_valid_blocks(sbi, segno, sbi->segs_per_sec);
+		dist = abs(vblocks - hblks_per_sec);
+		bimodal += dist * dist;
+
+		if (vblocks > 0 && vblocks < blks_per_sec) {
+			total_vblocks += vblocks;
+			ndirty++;
+		}
+	}
+	mutex_unlock(&sit_i->sentry_lock);
+	dist = sbi->total_sections * hblks_per_sec * hblks_per_sec / 100;
+	si->bimodal = bimodal / dist;
+	if (si->dirty_count)
+		si->avg_vblocks = total_vblocks / ndirty;
+	else
+		si->avg_vblocks = 0;
+}
+
+/**
+ * This function calculates memory footprint.
+ */
+static void update_mem_info(struct f2fs_sb_info *sbi)
+{
+	struct f2fs_stat_info *si = sbi->stat_info;
+	unsigned npages;
+
+	if (si->base_mem)
+		goto get_cache;
+
+	si->base_mem = sizeof(struct f2fs_sb_info) + sbi->sb->s_blocksize;
+	si->base_mem += 2 * sizeof(struct f2fs_inode_info);
+	si->base_mem += sizeof(*sbi->ckpt);
+
+	/* build sm */
+	si->base_mem += sizeof(struct f2fs_sm_info);
+
+	/* build sit */
+	si->base_mem += sizeof(struct sit_info);
+	si->base_mem += TOTAL_SEGS(sbi) * sizeof(struct seg_entry);
+	si->base_mem += f2fs_bitmap_size(TOTAL_SEGS(sbi));
+	si->base_mem += 2 * SIT_VBLOCK_MAP_SIZE * TOTAL_SEGS(sbi);
+	if (sbi->segs_per_sec > 1)
+		si->base_mem += sbi->total_sections *
+			sizeof(struct sec_entry);
+	si->base_mem += __bitmap_size(sbi, SIT_BITMAP);
+
+	/* build free segmap */
+	si->base_mem += sizeof(struct free_segmap_info);
+	si->base_mem += f2fs_bitmap_size(TOTAL_SEGS(sbi));
+	si->base_mem += f2fs_bitmap_size(sbi->total_sections);
+
+	/* build curseg */
+	si->base_mem += sizeof(struct curseg_info) * NR_CURSEG_TYPE;
+	si->base_mem += PAGE_CACHE_SIZE * NR_CURSEG_TYPE;
+
+	/* build dirty segmap */
+	si->base_mem += sizeof(struct dirty_seglist_info);
+	si->base_mem += NR_DIRTY_TYPE * f2fs_bitmap_size(TOTAL_SEGS(sbi));
+	si->base_mem += 2 * f2fs_bitmap_size(TOTAL_SEGS(sbi));
+
+	/* buld nm */
+	si->base_mem += sizeof(struct f2fs_nm_info);
+	si->base_mem += __bitmap_size(sbi, NAT_BITMAP);
+
+	/* build gc */
+	si->base_mem += sizeof(struct f2fs_gc_kthread);
+
+get_cache:
+	/* free nids */
+	si->cache_mem = NM_I(sbi)->fcnt;
+	si->cache_mem += NM_I(sbi)->nat_cnt;
+	npages = sbi->node_inode->i_mapping->nrpages;
+	si->cache_mem += npages << PAGE_CACHE_SHIFT;
+	npages = sbi->meta_inode->i_mapping->nrpages;
+	si->cache_mem += npages << PAGE_CACHE_SHIFT;
+	si->cache_mem += sbi->n_orphans * sizeof(struct orphan_inode_entry);
+	si->cache_mem += sbi->n_dirty_dirs * sizeof(struct dir_inode_entry);
+}
+
+static int stat_show(struct seq_file *s, void *v)
+{
+	struct f2fs_stat_info *si, *next;
+	int i = 0;
+	int j;
+
+	list_for_each_entry_safe(si, next, &f2fs_stat_list, stat_list) {
+
+		mutex_lock(&si->stat_lock);
+		if (!si->sbi) {
+			mutex_unlock(&si->stat_lock);
+			continue;
+		}
+		update_general_status(si->sbi);
+
+		seq_printf(s, "\n=====[ partition info. #%d ]=====\n", i++);
+		seq_printf(s, "[SB: 1] [CP: 2] [NAT: %d] [SIT: %d] ",
+			   si->nat_area_segs, si->sit_area_segs);
+		seq_printf(s, "[SSA: %d] [MAIN: %d",
+			   si->ssa_area_segs, si->main_area_segs);
+		seq_printf(s, "(OverProv:%d Resv:%d)]\n\n",
+			   si->overp_segs, si->rsvd_segs);
+		seq_printf(s, "Utilization: %d%% (%d valid blocks)\n",
+			   si->utilization, si->valid_count);
+		seq_printf(s, "  - Node: %u (Inode: %u, ",
+			   si->valid_node_count, si->valid_inode_count);
+		seq_printf(s, "Other: %u)\n  - Data: %u\n",
+			   si->valid_node_count - si->valid_inode_count,
+			   si->valid_count - si->valid_node_count);
+		seq_printf(s, "\nMain area: %d segs, %d secs %d zones\n",
+			   si->main_area_segs, si->main_area_sections,
+			   si->main_area_zones);
+		seq_printf(s, "  - COLD  data: %d, %d, %d\n",
+			   si->curseg[CURSEG_COLD_DATA],
+			   si->cursec[CURSEG_COLD_DATA],
+			   si->curzone[CURSEG_COLD_DATA]);
+		seq_printf(s, "  - WARM  data: %d, %d, %d\n",
+			   si->curseg[CURSEG_WARM_DATA],
+			   si->cursec[CURSEG_WARM_DATA],
+			   si->curzone[CURSEG_WARM_DATA]);
+		seq_printf(s, "  - HOT   data: %d, %d, %d\n",
+			   si->curseg[CURSEG_HOT_DATA],
+			   si->cursec[CURSEG_HOT_DATA],
+			   si->curzone[CURSEG_HOT_DATA]);
+		seq_printf(s, "  - Dir   dnode: %d, %d, %d\n",
+			   si->curseg[CURSEG_HOT_NODE],
+			   si->cursec[CURSEG_HOT_NODE],
+			   si->curzone[CURSEG_HOT_NODE]);
+		seq_printf(s, "  - File   dnode: %d, %d, %d\n",
+			   si->curseg[CURSEG_WARM_NODE],
+			   si->cursec[CURSEG_WARM_NODE],
+			   si->curzone[CURSEG_WARM_NODE]);
+		seq_printf(s, "  - Indir nodes: %d, %d, %d\n",
+			   si->curseg[CURSEG_COLD_NODE],
+			   si->cursec[CURSEG_COLD_NODE],
+			   si->curzone[CURSEG_COLD_NODE]);
+		seq_printf(s, "\n  - Valid: %d\n  - Dirty: %d\n",
+			   si->main_area_segs - si->dirty_count -
+			   si->prefree_count - si->free_segs,
+			   si->dirty_count);
+		seq_printf(s, "  - Prefree: %d\n  - Free: %d (%d)\n\n",
+			   si->prefree_count, si->free_segs, si->free_secs);
+		seq_printf(s, "GC calls: %d (BG: %d)\n",
+			   si->call_count, si->bg_gc);
+		seq_printf(s, "  - data segments : %d\n", si->data_segs);
+		seq_printf(s, "  - node segments : %d\n", si->node_segs);
+		seq_printf(s, "Try to move %d blocks\n", si->tot_blks);
+		seq_printf(s, "  - data blocks : %d\n", si->data_blks);
+		seq_printf(s, "  - node blocks : %d\n", si->node_blks);
+		seq_printf(s, "\nExtent Hit Ratio: %d / %d\n",
+			   si->hit_ext, si->total_ext);
+		seq_printf(s, "\nBalancing F2FS Async:\n");
+		seq_printf(s, "  - nodes %4d in %4d\n",
+			   si->ndirty_node, si->node_pages);
+		seq_printf(s, "  - dents %4d in dirs:%4d\n",
+			   si->ndirty_dent, si->ndirty_dirs);
+		seq_printf(s, "  - meta %4d in %4d\n",
+			   si->ndirty_meta, si->meta_pages);
+		seq_printf(s, "  - NATs %5d > %lu\n",
+			   si->nats, NM_WOUT_THRESHOLD);
+		seq_printf(s, "  - SITs: %5d\n  - free_nids: %5d\n",
+			   si->sits, si->fnids);
+		seq_printf(s, "\nDistribution of User Blocks:");
+		seq_printf(s, " [ valid | invalid | free ]\n");
+		seq_printf(s, "  [");
+
+		for (j = 0; j < si->util_valid; j++)
+			seq_printf(s, "-");
+		seq_printf(s, "|");
+
+		for (j = 0; j < si->util_invalid; j++)
+			seq_printf(s, "-");
+		seq_printf(s, "|");
+
+		for (j = 0; j < si->util_free; j++)
+			seq_printf(s, "-");
+		seq_printf(s, "]\n\n");
+		seq_printf(s, "SSR: %u blocks in %u segments\n",
+			   si->block_count[SSR], si->segment_count[SSR]);
+		seq_printf(s, "LFS: %u blocks in %u segments\n",
+			   si->block_count[LFS], si->segment_count[LFS]);
+
+		/* segment usage info */
+		update_sit_info(si->sbi);
+		seq_printf(s, "\nBDF: %u, avg. vblocks: %u\n",
+			   si->bimodal, si->avg_vblocks);
+
+		/* memory footprint */
+		update_mem_info(si->sbi);
+		seq_printf(s, "\nMemory: %u KB = static: %u + cached: %u\n",
+				(si->base_mem + si->cache_mem) >> 10,
+				si->base_mem >> 10, si->cache_mem >> 10);
+		mutex_unlock(&si->stat_lock);
+	}
+	return 0;
+}
+
+static int stat_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, stat_show, inode->i_private);
+}
+
+static const struct file_operations stat_fops = {
+	.open = stat_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int init_stats(struct f2fs_sb_info *sbi)
+{
+	struct f2fs_super_block *raw_super = F2FS_RAW_SUPER(sbi);
+	struct f2fs_stat_info *si;
+
+	sbi->stat_info = kzalloc(sizeof(struct f2fs_stat_info), GFP_KERNEL);
+	if (!sbi->stat_info)
+		return -ENOMEM;
+
+	si = sbi->stat_info;
+	mutex_init(&si->stat_lock);
+	list_add_tail(&si->stat_list, &f2fs_stat_list);
+
+	si->all_area_segs = le32_to_cpu(raw_super->segment_count);
+	si->sit_area_segs = le32_to_cpu(raw_super->segment_count_sit);
+	si->nat_area_segs = le32_to_cpu(raw_super->segment_count_nat);
+	si->ssa_area_segs = le32_to_cpu(raw_super->segment_count_ssa);
+	si->main_area_segs = le32_to_cpu(raw_super->segment_count_main);
+	si->main_area_sections = le32_to_cpu(raw_super->section_count);
+	si->main_area_zones = si->main_area_sections /
+				le32_to_cpu(raw_super->secs_per_zone);
+	si->sbi = sbi;
+	return 0;
+}
+
+int f2fs_build_stats(struct f2fs_sb_info *sbi)
+{
+	int retval;
+
+	retval = init_stats(sbi);
+	if (retval)
+		return retval;
+
+	if (!debugfs_root)
+		debugfs_root = debugfs_create_dir("f2fs", NULL);
+
+	debugfs_create_file("status", S_IRUGO, debugfs_root, NULL, &stat_fops);
+	return 0;
+}
+
+void f2fs_destroy_stats(struct f2fs_sb_info *sbi)
+{
+	struct f2fs_stat_info *si = sbi->stat_info;
+
+	list_del(&si->stat_list);
+	mutex_lock(&si->stat_lock);
+	si->sbi = NULL;
+	mutex_unlock(&si->stat_lock);
+	kfree(sbi->stat_info);
+}
+
+void destroy_root_stats(void)
+{
+	debugfs_remove_recursive(debugfs_root);
+	debugfs_root = NULL;
+}
-- 
1.7.9.5




---
Jaegeuk Kim
Samsung


