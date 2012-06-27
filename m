Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab2F0QA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 12:00:27 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47844 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756501Ab2F0P6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:58:18 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 10/16] UBI: Fastmap: More kernel doc updates
Date: Wed, 27 Jun 2012 17:57:50 +0200
Message-Id: <1340812676-14460-11-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340812676-14460-1-git-send-email-richard@nod.at>
References: <1340812676-14460-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c |   34 ++++++++++++++++++++++++++++++----
 1 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 07ac06e..c234d94 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -20,6 +20,9 @@
  * new_fm_vhdr - allocate a new volume header for fastmap usage.
  * @ubi: UBI device description object
  * @vol_id: the VID of the new header
+ *
+ * Returns a new struct ubi_vid_hdr on success.
+ * NULL indicates out of memory.
  */
 static struct ubi_vid_hdr *new_fm_vhdr(struct ubi_device *ubi, int vol_id)
 {
@@ -48,6 +51,8 @@ out:
  * @pnum: PEB number of the new attach erase block
  * @ec: erease counter of the new LEB
  * @scrub: scrub this PEB after attaching
+ *
+ * Returns 0 on success, < 0 indicates an internal error.
  */
 static int add_aeb(struct ubi_attach_info *ai, struct list_head *list,
 		   int pnum, int ec, int scrub)
@@ -79,13 +84,16 @@ static int add_aeb(struct ubi_attach_info *ai, struct list_head *list,
 }
 
 /**
- * add_vol - create and add a new scan volume to ubi_attach_info.
+ * add_vol - create and add a new volume to ubi_attach_info.
  * @ai: ubi_attach_info object
  * @vol_id: VID of the new volume
  * @used_ebs: number of used EBS
  * @data_pad: data padding value of the new volume
  * @vol_type: volume type
  * @last_eb_bytes: number of bytes in the last LEB
+ *
+ * Returns the new struct ubi_ainf_volume on success.
+ * NULL indicates an error.
  */
 static struct ubi_ainf_volume *add_vol(struct ubi_attach_info *ai, int vol_id,
 				       int used_ebs, int data_pad, u8 vol_type,
@@ -170,6 +178,8 @@ static void assign_aeb_to_av(struct ubi_attach_info *ai,
  * @av: the volume this LEB belongs to
  * @new_vh: the volume header derived from new_aeb
  * @new_aeb: the AEB to be examined
+ *
+ * Returns 0 on success, < 0 indicates an internal error.
  */
 static int update_vol(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		      struct ubi_ainf_volume *av, struct ubi_vid_hdr *new_vh,
@@ -264,6 +274,8 @@ static int update_vol(struct ubi_device *ubi, struct ubi_attach_info *ai,
  * @ai: attach info object
  * @new_vh: the volume header derived from new_aeb
  * @new_aeb: the AEB to be examined
+ *
+ * Returns 0 on success, < 0 indicates an internal error.
  */
 static int process_pool_aeb(struct ubi_device *ubi, struct ubi_attach_info *ai,
 			    struct ubi_vid_hdr *new_vh,
@@ -345,6 +357,9 @@ static void unmap_peb(struct ubi_attach_info *ai, int pnum)
  * @max_sqnum: pointer to the maximal sequence number
  * @eba_orphans: list of PEBs which need to be scanned
  * @free: list of PEBs which are most likely free (and go into @ai->free)
+ *
+ * Returns 0 on success, if the pool is unusable UBI_BAD_FASTMAP is returned.
+ * < 0 indicates an internal error.
  */
 static int scan_pool(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		     int *pebs, int pool_size, unsigned long long *max_sqnum,
@@ -493,6 +508,9 @@ static int count_fastmap_pebs(struct ubi_attach_info *ai)
  * @ai: UBI attach info object
  * @fm_raw: the fastmap it self as byte array
  * @fm_size: size of the fastmap in bytes
+ *
+ * Returns 0 on success, UBI_BAD_FASTMAP if the found fastmap was unusable.
+ * < 0 indicates an internal error.
  */
 static int ubi_attach_fastmap(struct ubi_device *ubi,
 			      struct ubi_attach_info *ai,
@@ -817,9 +835,9 @@ out:
  * @ubi: UBI device object
  * @ai: UBI attach info to be filled
  *
- * TODO: not urgent, but it is desireble to document error codes in the header
- * comments and probably describe what the function does, if there is something
- * to say (globally).
+ * Returns 0 on success, UBI_NO_FASTMAP if no fastmap was found,
+ * UBI_BAD_FASTMAP if one was found but is not usable.
+ * < 0 indicates an internal error.
  */
 int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 {
@@ -1068,6 +1086,8 @@ out:
  * ubi_write_fastmap - writes a fastmap.
  * @ubi: UBI device object
  * @new_fm: the to be written fastmap
+ *
+ * Returns 0 on success, < 0 indicates an internal error.
  */
 static int ubi_write_fastmap(struct ubi_device *ubi,
 			     struct ubi_fastmap_layout *new_fm)
@@ -1300,6 +1320,8 @@ out:
  * erase_block - Manually erase a PEB.
  * @ubi: UBI device object
  * @pnum: PEB to be erased
+ *
+ * Returns the new EC value on success, < 0 indicates an internal error.
  */
 static int erase_block(struct ubi_device *ubi, int pnum)
 {
@@ -1345,6 +1367,8 @@ out:
  * invalidate_fastmap - destroys a fastmap.
  * @ubi: UBI device object
  * @fm: the fastmap to be destroyed
+ *
+ * Returns 0 on success, < 0 indicates an internal error.
  */
 static int invalidate_fastmap(struct ubi_device *ubi,
 			      struct ubi_fastmap_layout *fm)
@@ -1376,6 +1400,8 @@ static int invalidate_fastmap(struct ubi_device *ubi,
  * ubi_update_fastmap - will be called by UBI if a volume changes or
  * a fastmap pool becomes full.
  * @ubi: UBI device object
+ *
+ * Returns 0 on success, < 0 indicates an internal error.
  */
 int ubi_update_fastmap(struct ubi_device *ubi)
 {
-- 
1.7.6.5

