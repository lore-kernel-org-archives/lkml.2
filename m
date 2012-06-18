Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab2FRQY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:24:26 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47836 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578Ab2FRQTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:19:24 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 02/22] UBI: Fastmap: Fix NULL pointer bug
Date: Mon, 18 Jun 2012 18:18:45 +0200
Message-Id: <1340036345-96726-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340036345-96726-1-git-send-email-richard@nod.at>
References: <1340036345-96726-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 8b033e5..5bbf1e3 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1290,11 +1290,14 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 				goto err;
 			}
 
-			tmp_e->pnum = old_fm->e[0]->pnum;
-			tmp_e->ec = old_fm->e[0]->ec;
+			new_fm->e[0]->pnum = old_fm->e[0]->pnum;
+			new_fm->e[0]->ec = old_fm->e[0]->ec;
 		} else {
 			/* we've got a new early PEB, return the old one */
 			ubi_wl_put_fm_peb(ubi, old_fm->e[0], 0);
+
+			new_fm->e[0]->pnum = tmp_e->pnum;
+			new_fm->e[0]->ec = tmp_e->ec;
 		}
 
 		/* return all other fastmap block to the wl system */
@@ -1307,10 +1310,10 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 
 			goto err;
 		}
-	}
 
-	new_fm->e[0]->pnum = tmp_e->pnum;
-	new_fm->e[0]->ec = tmp_e->ec;
+		new_fm->e[0]->pnum = tmp_e->pnum;
+		new_fm->e[0]->ec = tmp_e->ec;
+	}
 
 	if (new_fm->used_blocks > UBI_FM_MAX_BLOCKS) {
 		ubi_err("fastmap too large");
-- 
1.7.6.5

