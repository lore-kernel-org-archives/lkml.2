Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab2KEIsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 03:48:30 -0500
Received: from mga03.intel.com ([143.182.124.21]:43668 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab2KEIs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 03:48:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,713,1344236400"; 
   d="scan'208";a="213506637"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH, resend] of: re-use kernel's kbasename()
Date: Mon,  5 Nov 2012 10:48:17 +0200
Message-Id: <1352105297-880-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
---
 drivers/of/fdt.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 91a375f..0ca0f9e 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -486,14 +486,8 @@ int __init of_scan_flat_dt(int (*it)(unsigned long node,
 		depth++;
 		pathp = (char *)p;
 		p = ALIGN(p + strlen(pathp) + 1, 4);
-		if ((*pathp) == '/') {
-			char *lp, *np;
-			for (lp = NULL, np = pathp; *np; np++)
-				if ((*np) == '/')
-					lp = np+1;
-			if (lp != NULL)
-				pathp = lp;
-		}
+		if (*pathp == '/')
+			pathp = kbasename(pathp);
 		rc = it(p, pathp, depth, data);
 		if (rc != 0)
 			break;
-- 
1.7.10.4

