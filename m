Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab2F0P6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:58:16 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47838 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab2F0P6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:58:13 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 04/16] UBI: Fastmap: Rename self_check_fastmap()
Date: Wed, 27 Jun 2012 17:57:44 +0200
Message-Id: <1340812676-14460-5-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340812676-14460-1-git-send-email-richard@nod.at>
References: <1340812676-14460-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index ba547e2..a596cef 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -462,7 +462,11 @@ out:
 	return ret;
 }
 
-static int self_check_fastmap(struct ubi_attach_info *ai)
+/**
+ * count_fastmap_pebs - Counts the PEBs found by fastmap.
+ * @ai: The UBI attach info object
+ */
+static int count_fastmap_pebs(struct ubi_attach_info *ai)
 {
 	struct ubi_ainf_peb *aeb;
 	struct ubi_ainf_volume *av;
@@ -1006,7 +1010,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	 * We do this here because in ubi_wl_init() it's too late
 	 * and we cannot fall back to scanning.
 	 */
-	if (WARN_ON(self_check_fastmap(ai) != ubi->peb_count -
+	if (WARN_ON(count_fastmap_pebs(ai) != ubi->peb_count -
 		    ai->bad_peb_count - used_blocks)) {
 		ret = UBI_BAD_FASTMAP;
 		kfree(fm);
-- 
1.7.6.5

