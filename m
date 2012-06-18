Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab2FRQTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:19:37 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47839 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124Ab2FRQTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:19:32 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 05/22] UBI: Fastmap: Rework ubi_wl_put_fm_peb()
Date: Mon, 18 Jun 2012 18:18:48 +0200
Message-Id: <1340036345-96726-6-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340036345-96726-1-git-send-email-richard@nod.at>
References: <1340036345-96726-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/wl.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index a64cd83..369e07f 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -827,13 +827,14 @@ static int do_sync_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
  *
  * see: ubi_wl_put_peb()
  */
-int ubi_wl_put_fm_peb(struct ubi_device *ubi, struct ubi_wl_entry *used_e,
-    int torture)
+int ubi_wl_put_fm_peb(struct ubi_device *ubi, struct ubi_wl_entry *fm_e,
+		      int torture)
 {
 	struct ubi_wl_entry *e;
-	int pnum = used_e->pnum;
+	int pnum = fm_e->pnum;
 
 	dbg_wl("PEB %d", pnum);
+
 	ubi_assert(pnum >= 0);
 	ubi_assert(pnum < ubi->peb_count);
 
@@ -845,11 +846,11 @@ int ubi_wl_put_fm_peb(struct ubi_device *ubi, struct ubi_wl_entry *used_e,
 	 * has never seen any PEB used by the original fastmap.
 	 */
 	if (!e) {
-		e = used_e;
-
+		e = fm_e;
 		ubi_assert(e->ec);
 		ubi->lookuptbl[pnum] = e;
-	}
+	} else
+		kfree(fm_e);
 
 	spin_unlock(&ubi->wl_lock);
 
-- 
1.7.6.5

