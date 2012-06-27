Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab2F0P7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:59:30 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47846 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757413Ab2F0P6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:58:21 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 12/16] UBI: Fastmap: Make checkpatch.pl happy
Date: Wed, 27 Jun 2012 17:57:52 +0200
Message-Id: <1340812676-14460-13-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340812676-14460-1-git-send-email-richard@nod.at>
References: <1340812676-14460-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c |   21 ++++++++++++---------
 drivers/mtd/ubi/wl.c      |   17 ++++++++---------
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index e285e3b..2c7c350 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -668,7 +668,7 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 			goto fail_bad;
 
 		if (be32_to_cpu(fmvhdr->magic) != UBI_FM_VHDR_MAGIC) {
-			ubi_err("bad fastmap vol header magic: 0x%x, "
+			ubi_err("bad fastmap vol header magic: 0x%x, " \
 				"expected: 0x%x",
 				be32_to_cpu(fmvhdr->magic), UBI_FM_VHDR_MAGIC);
 			goto fail_bad;
@@ -694,7 +694,7 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 			goto fail_bad;
 
 		if (be32_to_cpu(fm_eba->magic) != UBI_FM_EBA_MAGIC) {
-			ubi_err("bad fastmap EBA header magic: 0x%x, "
+			ubi_err("bad fastmap EBA header magic: 0x%x, " \
 				"expected: 0x%x",
 				be32_to_cpu(fm_eba->magic), UBI_FM_EBA_MAGIC);
 			goto fail_bad;
@@ -766,7 +766,7 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 
 			err = ubi_io_read_ec_hdr(ubi, tmp_aeb->pnum, ech, 0);
 			if (err && err != UBI_IO_BITFLIPS) {
-				ubi_err("unable to read EC header! PEB:%i "
+				ubi_err("unable to read EC header! PEB:%i " \
 					"err:%i", tmp_aeb->pnum, err);
 				ret = err > 0 ? UBI_BAD_FASTMAP : err;
 				kfree(ech);
@@ -1013,7 +1013,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 
 		if (i == 0) {
 			if (be32_to_cpu(vh->vol_id) != UBI_FM_SB_VOLUME_ID) {
-				ubi_err("bad fastmap anchor vol_id: 0x%x,"
+				ubi_err("bad fastmap anchor vol_id: 0x%x," \
 					" expected: 0x%x",
 					be32_to_cpu(vh->vol_id),
 					UBI_FM_SB_VOLUME_ID);
@@ -1024,7 +1024,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 			}
 		} else {
 			if (be32_to_cpu(vh->vol_id) != UBI_FM_DATA_VOLUME_ID) {
-				ubi_err("bad fastmap data vol_id: 0x%x,"
+				ubi_err("bad fastmap data vol_id: 0x%x," \
 					" expected: 0x%x",
 					be32_to_cpu(vh->vol_id),
 					UBI_FM_DATA_VOLUME_ID);
@@ -1040,7 +1040,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 		ret = ubi_io_read(ubi, fm_raw + (ubi->leb_size * i), pnum,
 				  ubi->leb_start, ubi->leb_size);
 		if (ret && ret != UBI_IO_BITFLIPS) {
-			ubi_err("unable to read fastmap block# %i (PEB: %i, "
+			ubi_err("unable to read fastmap block# %i (PEB: %i, " \
 				"err: %i)", i, pnum, ret);
 			kfree(fmsb);
 			kfree(fm);
@@ -1305,7 +1305,8 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 	}
 
 	fmsb->data_crc = 0;
-	fmsb->data_crc = cpu_to_be32(crc32(UBI_CRC32_INIT, fm_raw, new_fm->size));
+	fmsb->data_crc = cpu_to_be32(crc32(UBI_CRC32_INIT, fm_raw,
+					   new_fm->size));
 
 	for (i = 1; i < new_fm->used_blocks; i++) {
 		dvhdr->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
@@ -1510,7 +1511,8 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 				int j;
 
 				for (j = 1; j < i; j++)
-					ubi_wl_put_fm_peb(ubi, new_fm->e[j], j, 0);
+					ubi_wl_put_fm_peb(ubi, new_fm->e[j],
+							  j, 0);
 
 				ubi_err("could not erase old fastmap PEB");
 				goto err;
@@ -1541,7 +1543,8 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 				ubi_err("could not erase old anchor PEB");
 
 				for (i = 1; i < new_fm->used_blocks; i++)
-					ubi_wl_put_fm_peb(ubi, new_fm->e[i], i, 0);
+					ubi_wl_put_fm_peb(ubi, new_fm->e[i],
+							  i, 0);
 				goto err;
 			}
 
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 06bf985..28385d2 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -349,8 +349,8 @@ static void prot_queue_add(struct ubi_device *ubi, struct ubi_wl_entry *e)
  * This function looks for a wear leveling entry with erase counter closest to
  * min + @diff, where min is the smallest erase counter.
  */
-static struct ubi_wl_entry *find_wl_entry(struct ubi_device *ubi, struct rb_root *root,
-					  int diff)
+static struct ubi_wl_entry *find_wl_entry(struct ubi_device *ubi,
+					  struct rb_root *root, int diff)
 {
 	struct rb_node *p;
 	struct ubi_wl_entry *e, *prev_e = NULL;
@@ -403,12 +403,12 @@ static struct ubi_wl_entry *find_mean_wl_entry(struct ubi_device *ubi,
 		e = rb_entry(root->rb_node, struct ubi_wl_entry, u.rb);
 
 		/* If no fastmap has been written and this WL entry can be used
-		 * as anchor PEB, hold it back and return the second best WL entry
-		 * such that fastmap can use the anchor PEB later. */
+		 * as anchor PEB, hold it back and return the second best
+		 * WL entry such that fastmap can use the anchor PEB later. */
 		if (e && !ubi->fm && e->pnum < UBI_FM_MAX_START)
-			e = rb_entry(rb_next(root->rb_node), struct ubi_wl_entry, u.rb);
-	}
-	else
+			e = rb_entry(rb_next(root->rb_node),
+				     struct ubi_wl_entry, u.rb);
+	} else
 		e = find_wl_entry(ubi, root, WL_FREE_MAX_DIFF/2);
 
 	return e;
@@ -997,8 +997,7 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 		self_check_in_wl_tree(ubi, e1, &ubi->used);
 		rb_erase(&e1->u.rb, &ubi->used);
 		dbg_wl("anchor-move PEB %d to PEB %d", e1->pnum, e2->pnum);
-	}
-	else if (!ubi->scrub.rb_node) {
+	} else if (!ubi->scrub.rb_node) {
 		/*
 		 * Now pick the least worn-out used physical eraseblock and a
 		 * highly worn-out free physical eraseblock. If the erase
-- 
1.7.6.5

