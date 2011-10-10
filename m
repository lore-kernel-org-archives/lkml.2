Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab1JJIJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 04:09:21 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54824 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752692Ab1JJIJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 04:09:19 -0400
From: Joe Perches <joe@perches.com>
To: Jan Kara <jack@suse.cz>
Cc: NamJae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] udf: Neaten udf_debug uses
Date: Mon, 10 Oct 2011 01:08:07 -0700
Message-Id: <38c43333e8458d6080c152ea36d5f2a59242bdb1.1318233879.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1318233879.git.joe@perches.com>
References: <CAKYAXd9csZyMXAy_uopb-fHKtY8VBjWD6UVdbQ3QTHYPogLVrw@mail.gmail.com> <cover.1318233879.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just whitespace and argument alignment.
Introduce some checkpatch warnings that deserve to be ignored.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/udf/balloc.c    |   14 +++++----
 fs/udf/directory.c |    4 +-
 fs/udf/inode.c     |    3 +-
 fs/udf/lowlevel.c  |    2 +-
 fs/udf/partition.c |    8 ++--
 fs/udf/super.c     |   78 ++++++++++++++++++++++-----------------------------
 6 files changed, 50 insertions(+), 59 deletions(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index 95518a9..987585b 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -59,8 +59,8 @@ static int __load_block_bitmap(struct super_block *sb,
 	int nr_groups = bitmap->s_nr_groups;
 
 	if (block_group >= nr_groups) {
-		udf_debug("block_group (%d) > nr_groups (%d)\n", block_group,
-			  nr_groups);
+		udf_debug("block_group (%d) > nr_groups (%d)\n",
+			  block_group, nr_groups);
 	}
 
 	if (bitmap->s_block_bitmap[block_group]) {
@@ -126,8 +126,9 @@ static void udf_bitmap_free_blocks(struct super_block *sb,
 	if (bloc->logicalBlockNum + count < count ||
 	    (bloc->logicalBlockNum + count) > partmap->s_partition_len) {
 		udf_debug("%d < %d || %d + %d > %d\n",
-			  bloc->logicalBlockNum, 0, bloc->logicalBlockNum,
-			  count, partmap->s_partition_len);
+			  bloc->logicalBlockNum, 0,
+			  bloc->logicalBlockNum, count,
+			  partmap->s_partition_len);
 		goto error_return;
 	}
 
@@ -155,7 +156,7 @@ static void udf_bitmap_free_blocks(struct super_block *sb,
 			if (udf_set_bit(bit + i, bh->b_data)) {
 				udf_debug("bit %ld already set\n", bit + i);
 				udf_debug("byte=%2x\n",
-					((char *)bh->b_data)[(bit + i) >> 3]);
+					  ((char *)bh->b_data)[(bit + i) >> 3]);
 			}
 		}
 		udf_add_free_space(sb, sbi->s_partition, count);
@@ -369,7 +370,8 @@ static void udf_table_free_blocks(struct super_block *sb,
 	if (bloc->logicalBlockNum + count < count ||
 	    (bloc->logicalBlockNum + count) > partmap->s_partition_len) {
 		udf_debug("%d < %d || %d + %d > %d\n",
-			  bloc->logicalBlockNum, 0, bloc->logicalBlockNum, count,
+			  bloc->logicalBlockNum, 0,
+			  bloc->logicalBlockNum, count,
 			  partmap->s_partition_len);
 		goto error_return;
 	}
diff --git a/fs/udf/directory.c b/fs/udf/directory.c
index 4e08438..3e44f57 100644
--- a/fs/udf/directory.c
+++ b/fs/udf/directory.c
@@ -162,8 +162,8 @@ struct fileIdentDesc *udf_get_fileident(void *buffer, int bufsize, int *offset)
 	int padlen;
 
 	if ((!buffer) || (!offset)) {
-		udf_debug("invalidparms\n, buffer=%p, offset=%p\n", buffer,
-			  offset);
+		udf_debug("invalidparms, buffer=%p, offset=%p\n",
+			  buffer, offset);
 		return NULL;
 	}
 
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 663b04b..ffc7e0c 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1977,8 +1977,7 @@ int8_t udf_current_aext(struct inode *inode, struct extent_position *epos,
 		*elen = le32_to_cpu(lad->extLength) & UDF_EXTENT_LENGTH_MASK;
 		break;
 	default:
-		udf_debug("alloc_type = %d unsupported\n",
-				iinfo->i_alloc_type);
+		udf_debug("alloc_type = %d unsupported\n", iinfo->i_alloc_type);
 		return -1;
 	}
 
diff --git a/fs/udf/lowlevel.c b/fs/udf/lowlevel.c
index 43e24a3..6583fe9 100644
--- a/fs/udf/lowlevel.c
+++ b/fs/udf/lowlevel.c
@@ -38,7 +38,7 @@ unsigned int udf_get_last_session(struct super_block *sb)
 
 	if (i == 0) {
 		udf_debug("XA disk: %s, vol_desc_start=%d\n",
-			  (ms_info.xa_flag ? "yes" : "no"), ms_info.addr.lba);
+			  ms_info.xa_flag ? "yes" : "no", ms_info.addr.lba);
 		if (ms_info.xa_flag) /* necessary for a valid ms_info.addr */
 			vol_desc_start = ms_info.addr.lba;
 	} else {
diff --git a/fs/udf/partition.c b/fs/udf/partition.c
index c72edb2..f3e472c 100644
--- a/fs/udf/partition.c
+++ b/fs/udf/partition.c
@@ -33,8 +33,8 @@ uint32_t udf_get_pblock(struct super_block *sb, uint32_t block,
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct udf_part_map *map;
 	if (partition >= sbi->s_partitions) {
-		udf_debug("block=%d, partition=%d, offset=%d: "
-			  "invalid partition\n", block, partition, offset);
+		udf_debug("block=%d, partition=%d, offset=%d: invalid partition\n",
+			  block, partition, offset);
 		return 0xFFFFFFFF;
 	}
 	map = &sbi->s_partmaps[partition];
@@ -60,8 +60,8 @@ uint32_t udf_get_pblock_virt15(struct super_block *sb, uint32_t block,
 	vdata = &map->s_type_specific.s_virtual;
 
 	if (block > vdata->s_num_entries) {
-		udf_debug("Trying to access block beyond end of VAT "
-			  "(%d max %d)\n", block, vdata->s_num_entries);
+		udf_debug("Trying to access block beyond end of VAT (%d max %d)\n",
+			  block, vdata->s_num_entries);
 		return 0xFFFFFFFF;
 	}
 
diff --git a/fs/udf/super.c b/fs/udf/super.c
index b72c5ab..622330c 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -639,20 +639,16 @@ static loff_t udf_check_vsd(struct super_block *sb)
 				udf_debug("ISO9660 Boot Record found\n");
 				break;
 			case 1:
-				udf_debug("ISO9660 Primary Volume Descriptor "
-					  "found\n");
+				udf_debug("ISO9660 Primary Volume Descriptor found\n");
 				break;
 			case 2:
-				udf_debug("ISO9660 Supplementary Volume "
-					  "Descriptor found\n");
+				udf_debug("ISO9660 Supplementary Volume Descriptor found\n");
 				break;
 			case 3:
-				udf_debug("ISO9660 Volume Partition Descriptor "
-					  "found\n");
+				udf_debug("ISO9660 Volume Partition Descriptor found\n");
 				break;
 			case 255:
-				udf_debug("ISO9660 Volume Descriptor Set "
-					  "Terminator found\n");
+				udf_debug("ISO9660 Volume Descriptor Set Terminator found\n");
 				break;
 			default:
 				udf_debug("ISO9660 VRS (%u) found\n",
@@ -803,8 +799,7 @@ static int udf_load_pvoldesc(struct super_block *sb, sector_t block)
 			      pvoldesc->recordingDateAndTime)) {
 #ifdef UDFFS_DEBUG
 		struct timestamp *ts = &pvoldesc->recordingDateAndTime;
-		udf_debug("recording time %04u/%02u/%02u"
-			  " %02u:%02u (%x)\n",
+		udf_debug("recording time %04u/%02u/%02u %02u:%02u (%x)\n",
 			  le16_to_cpu(ts->year), ts->month, ts->day, ts->hour,
 			  ts->minute, le16_to_cpu(ts->typeAndTimezone));
 #endif
@@ -815,7 +810,7 @@ static int udf_load_pvoldesc(struct super_block *sb, sector_t block)
 			strncpy(UDF_SB(sb)->s_volume_ident, outstr->u_name,
 				outstr->u_len > 31 ? 31 : outstr->u_len);
 			udf_debug("volIdent[] = '%s'\n",
-					UDF_SB(sb)->s_volume_ident);
+				  UDF_SB(sb)->s_volume_ident);
 		}
 
 	if (!udf_build_ustr(instr, pvoldesc->volSetIdent, 128))
@@ -847,7 +842,7 @@ static int udf_load_metadata_files(struct super_block *sb, int partition)
 	addr.partitionReferenceNum = map->s_partition_num;
 
 	udf_debug("Metadata file location: block = %d part = %d\n",
-			  addr.logicalBlockNum, addr.partitionReferenceNum);
+		  addr.logicalBlockNum, addr.partitionReferenceNum);
 
 	mdata->s_metadata_fe = udf_iget(sb, &addr);
 
@@ -867,7 +862,7 @@ static int udf_load_metadata_files(struct super_block *sb, int partition)
 	addr.partitionReferenceNum = map->s_partition_num;
 
 	udf_debug("Mirror metadata file location: block = %d part = %d\n",
-			  addr.logicalBlockNum, addr.partitionReferenceNum);
+		  addr.logicalBlockNum, addr.partitionReferenceNum);
 
 	mdata->s_mirror_fe = udf_iget(sb, &addr);
 
@@ -896,7 +891,7 @@ static int udf_load_metadata_files(struct super_block *sb, int partition)
 		addr.partitionReferenceNum = map->s_partition_num;
 
 		udf_debug("Bitmap file location: block = %d part = %d\n",
-			addr.logicalBlockNum, addr.partitionReferenceNum);
+			  addr.logicalBlockNum, addr.partitionReferenceNum);
 
 		mdata->s_bitmap_fe = udf_iget(sb, &addr);
 
@@ -988,10 +983,9 @@ static int udf_fill_partdesc_info(struct super_block *sb,
 	if (p->accessType == cpu_to_le32(PD_ACCESS_TYPE_OVERWRITABLE))
 		map->s_partition_flags |= UDF_PART_FLAG_OVERWRITABLE;
 
-	udf_debug("Partition (%d type %x) starts at physical %d, "
-		  "block length %d\n", p_index,
-		  map->s_partition_type, map->s_partition_root,
-		  map->s_partition_len);
+	udf_debug("Partition (%d type %x) starts at physical %d, block length %d\n",
+		  p_index, map->s_partition_type,
+		  map->s_partition_root, map->s_partition_len);
 
 	if (strcmp(p->partitionContents.ident, PD_PARTITION_CONTENTS_NSR02) &&
 	    strcmp(p->partitionContents.ident, PD_PARTITION_CONTENTS_NSR03))
@@ -1008,12 +1002,12 @@ static int udf_fill_partdesc_info(struct super_block *sb,
 		map->s_uspace.s_table = udf_iget(sb, &loc);
 		if (!map->s_uspace.s_table) {
 			udf_debug("cannot load unallocSpaceTable (part %d)\n",
-					p_index);
+				  p_index);
 			return 1;
 		}
 		map->s_partition_flags |= UDF_PART_FLAG_UNALLOC_TABLE;
 		udf_debug("unallocSpaceTable (part %d) @ %ld\n",
-				p_index, map->s_uspace.s_table->i_ino);
+			  p_index, map->s_uspace.s_table->i_ino);
 	}
 
 	if (phd->unallocSpaceBitmap.extLength) {
@@ -1026,8 +1020,8 @@ static int udf_fill_partdesc_info(struct super_block *sb,
 		bitmap->s_extPosition = le32_to_cpu(
 				phd->unallocSpaceBitmap.extPosition);
 		map->s_partition_flags |= UDF_PART_FLAG_UNALLOC_BITMAP;
-		udf_debug("unallocSpaceBitmap (part %d) @ %d\n", p_index,
-						bitmap->s_extPosition);
+		udf_debug("unallocSpaceBitmap (part %d) @ %d\n",
+			  p_index, bitmap->s_extPosition);
 	}
 
 	if (phd->partitionIntegrityTable.extLength)
@@ -1043,13 +1037,13 @@ static int udf_fill_partdesc_info(struct super_block *sb,
 		map->s_fspace.s_table = udf_iget(sb, &loc);
 		if (!map->s_fspace.s_table) {
 			udf_debug("cannot load freedSpaceTable (part %d)\n",
-				p_index);
+				  p_index);
 			return 1;
 		}
 
 		map->s_partition_flags |= UDF_PART_FLAG_FREED_TABLE;
 		udf_debug("freedSpaceTable (part %d) @ %ld\n",
-				p_index, map->s_fspace.s_table->i_ino);
+			  p_index, map->s_fspace.s_table->i_ino);
 	}
 
 	if (phd->freedSpaceBitmap.extLength) {
@@ -1062,8 +1056,8 @@ static int udf_fill_partdesc_info(struct super_block *sb,
 		bitmap->s_extPosition = le32_to_cpu(
 				phd->freedSpaceBitmap.extPosition);
 		map->s_partition_flags |= UDF_PART_FLAG_FREED_BITMAP;
-		udf_debug("freedSpaceBitmap (part %d) @ %d\n", p_index,
-					bitmap->s_extPosition);
+		udf_debug("freedSpaceBitmap (part %d) @ %d\n",
+			  p_index, bitmap->s_extPosition);
 	}
 	return 0;
 }
@@ -1324,9 +1318,8 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 				struct metadataPartitionMap *mdm =
 						(struct metadataPartitionMap *)
 						&(lvd->partitionMaps[offset]);
-				udf_debug("Parsing Logical vol part %d "
-					"type %d  id=%s\n", i, type,
-					UDF_ID_METADATA);
+				udf_debug("Parsing Logical vol part %d type %d  id=%s\n",
+					  i, type, UDF_ID_METADATA);
 
 				map->s_partition_type = UDF_METADATA_MAP25;
 				map->s_partition_func = udf_get_pblock_meta25;
@@ -1345,21 +1338,20 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 					mdm->flags & 0x01;
 
 				udf_debug("Metadata Ident suffix=0x%x\n",
-					(le16_to_cpu(
-					 ((__le16 *)
-					      mdm->partIdent.identSuffix)[0])));
+					  le16_to_cpu(*(__le16 *)
+						      mdm->partIdent.identSuffix));
 				udf_debug("Metadata part num=%d\n",
-					le16_to_cpu(mdm->partitionNum));
+					  le16_to_cpu(mdm->partitionNum));
 				udf_debug("Metadata part alloc unit size=%d\n",
-					le32_to_cpu(mdm->allocUnitSize));
+					  le32_to_cpu(mdm->allocUnitSize));
 				udf_debug("Metadata file loc=%d\n",
-					le32_to_cpu(mdm->metadataFileLoc));
+					  le32_to_cpu(mdm->metadataFileLoc));
 				udf_debug("Mirror file loc=%d\n",
-				       le32_to_cpu(mdm->metadataMirrorFileLoc));
+					  le32_to_cpu(mdm->metadataMirrorFileLoc));
 				udf_debug("Bitmap file loc=%d\n",
-				       le32_to_cpu(mdm->metadataBitmapFileLoc));
+					  le32_to_cpu(mdm->metadataBitmapFileLoc));
 				udf_debug("Duplicate Flag: %d %d\n",
-					mdata->s_dup_md_flag, mdm->flags);
+					  mdata->s_dup_md_flag, mdm->flags);
 			} else {
 				udf_debug("Unknown ident: %s\n",
 					  upm2->partIdent.ident);
@@ -1369,16 +1361,15 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 			map->s_partition_num = le16_to_cpu(upm2->partitionNum);
 		}
 		udf_debug("Partition (%d:%d) type %d on volume %d\n",
-			  i, map->s_partition_num, type,
-			  map->s_volumeseqnum);
+			  i, map->s_partition_num, type, map->s_volumeseqnum);
 	}
 
 	if (fileset) {
 		struct long_ad *la = (struct long_ad *)&(lvd->logicalVolContentsUse[0]);
 
 		*fileset = lelb_to_cpu(la->extLocation);
-		udf_debug("FileSet found in LogicalVolDesc at block=%d, "
-			  "partition=%d\n", fileset->logicalBlockNum,
+		udf_debug("FileSet found in LogicalVolDesc at block=%d, partition=%d\n",
+			  fileset->logicalBlockNum,
 			  fileset->partitionReferenceNum);
 	}
 	if (lvd->integritySeqExt.extLength)
@@ -1732,8 +1723,7 @@ static int udf_load_vrs(struct super_block *sb, struct udf_options *uopt,
 			return 0;
 		}
 		if (nsr_off == -1)
-			udf_debug("Failed to read byte 32768. Assuming open "
-				  "disc. Skipping validity check\n");
+			udf_debug("Failed to read byte 32768. Assuming open disc. Skipping validity check\n");
 		if (!sbi->s_last_block)
 			sbi->s_last_block = udf_get_last_block(sb);
 	} else {
-- 
1.7.6.405.gc1be0

