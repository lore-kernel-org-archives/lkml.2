Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab2FRQX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:23:28 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47842 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224Ab2FRQTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:19:34 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 08/22] Revert "UBI: Fastmap: Check for duplicated PEBs in add_aeb()"
Date: Mon, 18 Jun 2012 18:18:51 +0200
Message-Id: <1340036345-96726-9-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340036345-96726-1-git-send-email-richard@nod.at>
References: <1340036345-96726-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 95bbb0d1b2ea86103edfdd4b07ddfb058b1e0eff.

That check is no longer needed.
It must not happen that fastmap creates duplicates.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index bc29835..caefcb3 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -54,10 +54,6 @@ static int add_aeb(struct ubi_attach_info *ai, struct list_head *list,
 {
 	struct ubi_ainf_peb *aeb;
 
-	list_for_each_entry(aeb, list, u.list)
-		if (aeb->pnum == pnum)
-			return 0;
-
 	aeb = kmem_cache_alloc(ai->aeb_slab_cache, GFP_KERNEL);
 	if (!aeb)
 		return -ENOMEM;
-- 
1.7.6.5

