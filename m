Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab2FUVwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:52:41 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47842 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760501Ab2FUVu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:50:27 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 08/15] UBI: Fastmap: Fix lock inbalance
Date: Thu, 21 Jun 2012 23:50:01 +0200
Message-Id: <1340315408-27375-9-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340315408-27375-1-git-send-email-richard@nod.at>
References: <UBI fastmap updates>
 <1340315408-27375-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/wl.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 6f346f5..6771f30 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -473,7 +473,6 @@ retry:
 		if (ubi->works_count == 0) {
 			ubi_assert(list_empty(&ubi->works));
 			ubi_err("no free eraseblocks");
-			spin_unlock(&ubi->wl_lock);
 			return -ENOSPC;
 		}
 
-- 
1.7.6.5

