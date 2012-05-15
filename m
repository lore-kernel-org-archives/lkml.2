Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966021Ab2EORMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 13:12:19 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47836 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965811Ab2EORL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 13:11:26 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: tglx@linutronix.de, dedekind1@gmail.com, linux-kernel@vger.kernel.org,
        Heinz.Egger@linutronix.de, tim.bird@am.sony.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/7] [RFC] UBI: Export compare_lebs()
Date: Tue, 15 May 2012 19:11:06 +0200
Message-Id: <1337101871-31181-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1337101871-31181-1-git-send-email-richard@nod.at>
References: <1337101871-31181-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fastmap mechanism needs this funtion,
rename it to ubi_compare_lebs() and export it.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/scan.c |    8 ++++----
 drivers/mtd/ubi/ubi.h  |    4 ++++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/ubi/scan.c b/drivers/mtd/ubi/scan.c
index c26b1ad..69be65f 100644
--- a/drivers/mtd/ubi/scan.c
+++ b/drivers/mtd/ubi/scan.c
@@ -295,7 +295,7 @@ static struct ubi_scan_volume *add_volume(struct ubi_scan_info *si, int vol_id,
 }
 
 /**
- * compare_lebs - find out which logical eraseblock is newer.
+ * ubi_compare_lebs - find out which logical eraseblock is newer.
  * @ubi: UBI device description object
  * @seb: first logical eraseblock to compare
  * @pnum: physical eraseblock number of the second logical eraseblock to
@@ -314,7 +314,7 @@ static struct ubi_scan_volume *add_volume(struct ubi_scan_info *si, int vol_id,
  *     o bit 2 is cleared: the older LEB is not corrupted;
  *     o bit 2 is set: the older LEB is corrupted.
  */
-static int compare_lebs(struct ubi_device *ubi, const struct ubi_scan_leb *seb,
+int ubi_compare_lebs(struct ubi_device *ubi, const struct ubi_scan_leb *seb,
 			int pnum, const struct ubi_vid_hdr *vid_hdr)
 {
 	void *buf;
@@ -503,7 +503,7 @@ int ubi_scan_add_used(struct ubi_device *ubi, struct ubi_scan_info *si,
 		 * sequence numbers. We still can attach these images, unless
 		 * there is a need to distinguish between old and new
 		 * eraseblocks, in which case we'll refuse the image in
-		 * 'compare_lebs()'. In other words, we attach old clean
+		 * 'ubi_compare_lebs()'. In other words, we attach old clean
 		 * images, but refuse attaching old images with duplicated
 		 * logical eraseblocks because there was an unclean reboot.
 		 */
@@ -519,7 +519,7 @@ int ubi_scan_add_used(struct ubi_device *ubi, struct ubi_scan_info *si,
 		 * Now we have to drop the older one and preserve the newer
 		 * one.
 		 */
-		cmp_res = compare_lebs(ubi, seb, pnum, vid_hdr);
+		cmp_res = ubi_compare_lebs(ubi, seb, pnum, vid_hdr);
 		if (cmp_res < 0)
 			return cmp_res;
 
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 00c48f6..50c2af2 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -576,6 +576,10 @@ void ubi_do_get_device_info(struct ubi_device *ubi, struct ubi_device_info *di);
 void ubi_do_get_volume_info(struct ubi_device *ubi, struct ubi_volume *vol,
 			    struct ubi_volume_info *vi);
 
+/* scan.c */
+int ubi_compare_lebs(struct ubi_device *ubi, const struct ubi_scan_leb *seb,
+		      int pnum, const struct ubi_vid_hdr *vid_hdr);
+
 /*
  * ubi_rb_for_each_entry - walk an RB-tree.
  * @rb: a pointer to type 'struct rb_node' to use as a loop counter
-- 
1.7.6.5

