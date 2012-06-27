Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab2F0QB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 12:01:58 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47836 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070Ab2F0P6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:58:12 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 02/16] UBI: Fastmap: Kernel doc updates
Date: Wed, 27 Jun 2012 17:57:42 +0200
Message-Id: <1340812676-14460-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340812676-14460-1-git-send-email-richard@nod.at>
References: <1340812676-14460-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/attach.c    |    2 +-
 drivers/mtd/ubi/eba.c       |    8 ++++++++
 drivers/mtd/ubi/fastmap.c   |   16 +++++++++-------
 drivers/mtd/ubi/ubi-media.h |    5 +++--
 drivers/mtd/ubi/ubi.h       |    2 ++
 drivers/mtd/ubi/wl.c        |   32 +++++++++++++++++++++++++-------
 6 files changed, 48 insertions(+), 17 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index 00e58dd..021c7d3 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -750,7 +750,7 @@ struct ubi_ainf_peb *ubi_early_get_peb(struct ubi_device *ubi,
 /**
  * check_corruption - check the data area of PEB.
  * @ubi: UBI device description object
- * @vid_hrd: the (corrupted) VID header of this PEB
+ * @vid_hdr: the (corrupted) VID header of this PEB
  * @pnum: the physical eraseblock number to check
  *
  * This is a helper function which is used to distinguish between VID header
diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index cb30e7a..cb0139c 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -1178,6 +1178,7 @@ out_unlock_leb:
 /**
  * print_rsvd_warning - warn about not having enough reserved PEBs.
  * @ubi: UBI device description object
+ * @ai: UBI attach info object
  *
  * This is a helper function for 'ubi_eba_init()' which is called when UBI
  * cannot reserve enough PEBs for bad block handling. This function makes a
@@ -1216,6 +1217,13 @@ static void print_rsvd_warning(struct ubi_device *ubi,
 			ubi->corr_peb_count);
 }
 
+/**
+ * self_check_eba - run a self check on the EBA table construected by fastmap.
+ *
+ * @ubi: UBI device description object
+ * @ai_fastmap: UBI attach info object created by fastmap
+ * @ai_scan: UBI attach info object created by scanning
+ */
 int self_check_eba(struct ubi_device *ubi, struct ubi_attach_info *ai_fastmap,
 		   struct ubi_attach_info *ai_scan)
 {
diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index c6927a9..988f620 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -259,7 +259,7 @@ static int update_vol(struct ubi_device *ubi, struct ubi_attach_info *ai,
 }
 
 /**
- * process_pool_aeb - we found a non-empty PEB in a pool
+ * process_pool_aeb - we found a non-empty PEB in a pool.
  * @ubi: UBI device object
  * @ai: attach info object
  * @new_vh: the volume header derived from new_aeb
@@ -313,7 +313,7 @@ static int process_pool_aeb(struct ubi_device *ubi, struct ubi_attach_info *ai,
  * If fastmap detects a free PEB in the pool it has to check whether
  * this PEB has been unmapped after writing the fastmap.
  *
- * @ubi: UBI device object
+ * @ai: UBI attach info object
  * @pnum: The PEB to be unmapped
  */
 static void unmap_peb(struct ubi_attach_info *ai, int pnum)
@@ -338,13 +338,14 @@ static void unmap_peb(struct ubi_attach_info *ai, int pnum)
 }
 
 /**
- * scan_pool - scans a pool for changed (no longer empty PEBs)
+ * scan_pool - scans a pool for changed (no longer empty PEBs).
  * @ubi: UBI device object
  * @ai: attach info object
  * @pebs: an array of all PEB numbers in the to be scanned pool
  * @pool_size: size of the pool (number of entries in @pebs)
  * @max_sqnum: pointer to the maximal sequence number
  * @eba_orphans: list of PEBs which need to be scanned
+ * @free: list of PEBs which are most likely free (and go into @ai->free)
  */
 static int scan_pool(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		     int *pebs, int pool_size, unsigned long long *max_sqnum,
@@ -484,6 +485,7 @@ static int self_check_fastmap(struct ubi_attach_info *ai)
 /**
  * ubi_attach_fastmap - creates ubi_attach_info from a fastmap.
  * @ubi: UBI device object
+ * @ai: UBI attach info object
  * @fm_raw: the fastmap it self as byte array
  * @fm_size: size of the fastmap in bytes
  */
@@ -791,7 +793,7 @@ out:
 }
 
 /**
- * ubi_scan_fastmap - scan the fastmap
+ * ubi_scan_fastmap - scan the fastmap.
  * @ubi: UBI device object
  * @ai: UBI attach info to be filled
  *
@@ -1047,7 +1049,7 @@ out:
 }
 
 /**
- * ubi_write_fastmap - writes a fastmap
+ * ubi_write_fastmap - writes a fastmap.
  * @ubi: UBI device object
  * @new_fm: the to be written fastmap
  */
@@ -1279,7 +1281,7 @@ out:
 }
 
 /**
- * erase_block - Manually erase a PEB
+ * erase_block - Manually erase a PEB.
  * @ubi: UBI device object
  * @pnum: PEB to be erased
  */
@@ -1324,7 +1326,7 @@ out:
 }
 
 /**
- * invalidate_fastmap - destroys a fastmap
+ * invalidate_fastmap - destroys a fastmap.
  * @ubi: UBI device object
  * @fm: the fastmap to be destroyed
  */
diff --git a/drivers/mtd/ubi/ubi-media.h b/drivers/mtd/ubi/ubi-media.h
index a0648c1..eaf81a2 100644
--- a/drivers/mtd/ubi/ubi-media.h
+++ b/drivers/mtd/ubi/ubi-media.h
@@ -432,7 +432,8 @@ struct ubi_fm_sb {
  * struct ubi_fm_hdr - header of the fastmap data set
  * @magic: fastmap header magic number (%UBI_FM_HDR_MAGIC)
  * @free_peb_count: number of free PEBs known by this fastmap
- * @free_peb_count: number of used PEBs known by this fastmap
+ * @used_peb_count: number of used PEBs known by this fastmap
+ * @scrub_peb_count: number of to be scrubbed PEBs known by this fastmap
  * @bad_peb_count: number of bad PEBs known by this fastmap
  * @erase_peb_count: number of bad PEBs which have to be erased
  * @vol_count: number of UBI volumes known by this fastmap
@@ -500,7 +501,7 @@ struct ubi_fm_volhdr {
 
 /**
  * struct ubi_fm_eba - denotes an association beween a PEB and LEB
- * @magic EBA table magic number
+ * @magic: EBA table magic number
  * @reserved_pebs: number of table entries
  * @pnum: PEB number of LEB (LEB is the index)
  */
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 0ca01eb..b60818d 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -382,6 +382,8 @@ struct ubi_wl_entry;
  *
  * @fm: in-memory data structure of the currently used fastmap
  * @fm_pool: in-memory data structure of the fastmap pool
+ * @fm_wl_pool: in-memory data structure of the fastmap pool used by the WL
+ * 		sub-system
  * @fm_mutex: serializes ubi_update_fastmap()
  * @fm_sem: allows ubi_update_fastmap() to block EBA table changes
  * @fm_work: fastmap work queue
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 85a3373..06bf985 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -483,13 +483,13 @@ out:
 }
 
 /**
- * __ubi_wl_get_peb - get a physical eraseblock.
+ * __wl_get_peb - get a physical eraseblock.
  * @ubi: UBI device description object
  *
  * This function returns a physical eraseblock in case of success and a
  * negative error code in case of failure. Might sleep.
  */
-static int __ubi_wl_get_peb(struct ubi_device *ubi)
+static int __wl_get_peb(struct ubi_device *ubi)
 {
 	int err;
 	struct ubi_wl_entry *e;
@@ -585,7 +585,7 @@ static void refill_wl_user_pool(struct ubi_device *ubi)
 	return_unused_pool_pebs(ubi, pool);
 
 	for (pool->size = 0; pool->size < pool->max_size; pool->size++) {
-		pool->pebs[pool->size] = __ubi_wl_get_peb(ubi);
+		pool->pebs[pool->size] = __wl_get_peb(ubi);
 		if (pool->pebs[pool->size] < 0)
 			break;
 	}
@@ -604,7 +604,7 @@ void ubi_refill_pools(struct ubi_device *ubi)
 	spin_unlock(&ubi->wl_lock);
 }
 
-/* ubi_wl_get_peb - works exaclty like __ubi_wl_get_peb but keeps track of
+/* ubi_wl_get_peb - works exaclty like __wl_get_peb but keeps track of
  * the fastmap pool.
  */
 int ubi_wl_get_peb(struct ubi_device *ubi)
@@ -630,7 +630,7 @@ int ubi_wl_get_peb(struct ubi_device *ubi)
 	return ret;
 }
 
-/* get_peb_for_wl - returns a PEB to be used internally by the WL sub-system
+/* get_peb_for_wl - returns a PEB to be used internally by the WL sub-system.
  *
  * @ubi: UBI device description object
  */
@@ -818,7 +818,7 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 			int cancel);
 
 /**
- * ubi_is_erase_work - checks whether a work is erase work
+ * ubi_is_erase_work - checks whether a work is erase work.
  * @wrk: The work object to be checked
  */
 int ubi_is_erase_work(struct ubi_work *wrk)
@@ -862,6 +862,15 @@ static int schedule_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
 	return 0;
 }
 
+/**
+ * do_sync_erase - run the erase worker synchronously.
+ * @ubi: UBI device description object
+ * @e: the WL entry of the physical eraseblock to erase
+ * @vol_id: the volume ID that last used this PEB
+ * @lnum: the last used logical eraseblock number for the PEB
+ * @torture: if the physical eraseblock has to be tortured
+ *
+ */
 static int do_sync_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
 			 int vol_id, int lnum, int torture)
 {
@@ -884,8 +893,12 @@ static int do_sync_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
 /**
  * ubi_wl_put_fm_peb - returns a PEB used in a fastmap to the wear-leveling
  * sub-system.
- *
  * see: ubi_wl_put_peb()
+ *
+ * @ubi: UBI device description object
+ * @fm_e: physical eraseblock to return
+ * @lnum: the last used logical eraseblock number for the PEB
+ * @torture: if this physical eraseblock has to be tortured
  */
 int ubi_wl_put_fm_peb(struct ubi_device *ubi, struct ubi_wl_entry *fm_e,
 		      int lnum, int torture)
@@ -1229,6 +1242,7 @@ out_cancel:
 /**
  * ensure_wear_leveling - schedule wear-leveling if it is needed.
  * @ubi: UBI device description object
+ * @nested: set to non-zero if this function is called from UBI worker
  *
  * This function checks if it is time to start wear-leveling and schedules it
  * if yes. This function returns zero in case of success and a negative error
@@ -1295,6 +1309,10 @@ out_unlock:
 	return err;
 }
 
+/**
+ * ubi_ensure_anchor_pebs - schedule wear-leveling to produce an anchor PEB.
+ * @ubi: UBI device description object
+ */
 int ubi_ensure_anchor_pebs(struct ubi_device *ubi)
 {
 	struct ubi_work *wrk;
-- 
1.7.6.5

