Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab2FRQUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:20:48 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47847 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225Ab2FRQTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:19:42 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 18/22] UBI: Fastmap: Rename "early PEB" to "anchor PEB".
Date: Mon, 18 Jun 2012 18:19:01 +0200
Message-Id: <1340036345-96726-19-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340036345-96726-1-git-send-email-richard@nod.at>
References: <1340036345-96726-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"early PEB" is a very bad name.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c |    8 ++++----
 drivers/mtd/ubi/wl.c      |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 65fd7ee..bea9446 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1404,18 +1404,18 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 	spin_unlock(&ubi->wl_lock);
 
 	if (old_fm) {
-		/* no fresh early PEB was found, reuse the old one */
+		/* no fresh anchor PEB was found, reuse the old one */
 		if (!tmp_e) {
 			ret = erase_block(ubi, old_fm->e[0]->pnum);
 			if (ret < 0) {
-				ubi_err("could not erase old early PEB");
+				ubi_err("could not erase old anchor PEB");
 				goto err;
 			}
 
 			new_fm->e[0]->pnum = old_fm->e[0]->pnum;
 			new_fm->e[0]->ec = ret;
 		} else {
-			/* we've got a new early PEB, return the old one */
+			/* we've got a new anchor PEB, return the old one */
 			ubi_wl_put_fm_peb(ubi, old_fm->e[0],
 					  old_fm->to_be_tortured[0]);
 
@@ -1429,7 +1429,7 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 					  old_fm->to_be_tortured[i]);
 	} else {
 		if (!tmp_e) {
-			ubi_err("could not find an early PEB");
+			ubi_err("could not find an anchor PEB");
 			ret = -ENOSPC;
 			goto err;
 		}
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index be847d4..e5ab683 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -388,12 +388,12 @@ static struct ubi_wl_entry *find_mean_wl_entry(struct rb_root *root)
 }
 
 /**
- * find_early_wl_entry - find wear-leveling entry with the lowest pnum.
+ * find_anchor_wl_entry - find wear-leveling entry to used as anchor PEB.
  * @root: the RB-tree where to look for
  * @max_pnum: highest possible pnum
  */
-static struct ubi_wl_entry *find_early_wl_entry(struct rb_root *root,
-						int max_pnum)
+static struct ubi_wl_entry *find_anchor_wl_entry(struct rb_root *root,
+						 int max_pnum)
 {
 	struct rb_node *p;
 	struct ubi_wl_entry *e, *victim = NULL;
@@ -433,7 +433,7 @@ struct ubi_wl_entry *ubi_wl_get_fm_peb(struct ubi_device *ubi, int max_pnum)
 	if (max_pnum < 0)
 		e = find_mean_wl_entry(&ubi->free);
 	else
-		e = find_early_wl_entry(&ubi->free, max_pnum);
+		e = find_anchor_wl_entry(&ubi->free, max_pnum);
 
 	if (!e)
 		goto out;
-- 
1.7.6.5

