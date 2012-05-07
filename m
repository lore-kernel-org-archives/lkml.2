Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674Ab2EGWrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 18:47:39 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756889Ab2EGWri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 18:47:38 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: dedekind1@gmail.com, dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] MTD: UBI: remove superfluous "!!" operation
Date: Tue,  8 May 2012 00:47:20 +0200
Message-Id: <1336430840-27232-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

!!(x < y) and (x < y) are identical expressions.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/ubi/scan.c b/drivers/mtd/ubi/scan.c
index 12c43b4..8d24435 100644
--- a/drivers/mtd/ubi/scan.c
+++ b/drivers/mtd/ubi/scan.c
@@ -337,7 +337,7 @@ static int compare_lebs(struct ubi_device *ubi, const struct ubi_scan_leb *seb,
 	}
 
 	/* Obviously the LEB with lower sequence counter is older */
-	second_is_newer = !!(sqnum2 > seb->sqnum);
+	second_is_newer = (sqnum2 > seb->sqnum);
 
 	/*
 	 * Now we know which copy is newer. If the copy flag of the PEB with
-- 
1.7.7.3

