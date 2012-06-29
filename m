Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab2F2PQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:16:38 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47838 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107Ab2F2POm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:14:42 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 04/11] UBI: Fastmap: Move fastmap specific code into ubi_scan_fastmap()
Date: Fri, 29 Jun 2012 17:14:22 +0200
Message-Id: <1340982869-77042-5-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340982869-77042-1-git-send-email-richard@nod.at>
References: <1340982869-77042-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/attach.c  |    9 ---------
 drivers/mtd/ubi/fastmap.c |    4 ++++
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index e88521b..1b62d54 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -1384,15 +1384,6 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 	if (err)
 		goto out_ai;
 
-	/* TODO: Hmm why this code is not hidden in 'ubi_scan_fastmap()' ? */
-	if (ubi->fm) {
-		ubi->fm_pool.max_size = ubi->fm->max_pool_size;
-		ubi->fm_wl_pool.max_size = ubi->fm->max_wl_pool_size;
-
-		ubi_msg("fastmap pool size: %d", ubi->fm_pool.max_size);
-		ubi_msg("fastmap WL pool size: %d", ubi->fm_wl_pool.max_size);
-	}
-
 	err = ubi_wl_init(ubi, ai);
 	if (err)
 		goto out_vtbl;
diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 2c7c350..9b4fd34 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1096,6 +1096,10 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	}
 
 	ubi->fm = fm;
+	ubi->fm_pool.max_size = ubi->fm->max_pool_size;
+	ubi->fm_wl_pool.max_size = ubi->fm->max_wl_pool_size;
+	ubi_msg("fastmap pool size: %d", ubi->fm_pool.max_size);
+	ubi_msg("fastmap WL pool size: %d", ubi->fm_wl_pool.max_size);
 
 free_hdr:
 	ubi_free_vid_hdr(ubi, vh);
-- 
1.7.6.5

