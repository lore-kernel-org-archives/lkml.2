Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab2GIMT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 08:19:27 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47840 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991Ab2GIMS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 08:18:58 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 6/7] UBI: Fastmap: Make sure that find_wl_entry() never returns NULL
Date: Mon,  9 Jul 2012 14:18:42 +0200
Message-Id: <1341836323-43916-7-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1341836323-43916-1-git-send-email-richard@nod.at>
References: <1341836323-43916-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the rbtree contains only one entry and we don't have fastmap
on flash find_wl_entry() might return NULL.
This must not happen.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/wl.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 79e3257..d61672d 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -376,7 +376,8 @@ static struct ubi_wl_entry *find_wl_entry(struct ubi_device *ubi,
 	/* If no fastmap has been written and this WL entry can be used
 	 * as anchor PEB, hold it back and return the second best WL entry
 	 * such that fastmap can use the anchor PEB later. */
-	if (!ubi->fm_disabled && !ubi->fm && e->pnum < UBI_FM_MAX_START)
+	if (prev_e && !ubi->fm_disabled &&
+	    !ubi->fm && e->pnum < UBI_FM_MAX_START)
 		return prev_e;
 
 	return e;
-- 
1.7.6.5

