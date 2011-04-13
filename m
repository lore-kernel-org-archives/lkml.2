Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab1DMKAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 06:00:25 -0400
Received: from ns.vscht.cz ([147.33.15.5]:46792 "EHLO ns.vscht.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753Ab1DMKAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 06:00:23 -0400
From: Jiri Pinkava <jiri.pinkava@vscht.cz>
To: <dedekind1@gmail.com>
CC: <ben-linux@fluff.org>, <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, Jiri Pinkava <jiri.pinkava@vscht.cz>
Subject: [PATCH 2/2] nand: Remove unnecessary variable
Date: Wed, 13 Apr 2011 11:59:31 +0200
Message-ID: <1302688771-17252-2-git-send-email-jiri.pinkava@vscht.cz>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302688771-17252-1-git-send-email-jiri.pinkava@vscht.cz>
References: <1302665784.14691.5.camel@koala>
 <1302688771-17252-1-git-send-email-jiri.pinkava@vscht.cz>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jiri Pinkava <jiri.pinkava@vscht.cz>
---
 drivers/mtd/nand/s3c2410.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/nand/s3c2410.c b/drivers/mtd/nand/s3c2410.c
index cea775a..8041038 100644
--- a/drivers/mtd/nand/s3c2410.c
+++ b/drivers/mtd/nand/s3c2410.c
@@ -54,12 +54,6 @@ static int hardware_ecc = 1;
 static int hardware_ecc = 0;
 #endif
 
-#ifdef CONFIG_MTD_NAND_S3C2410_CLKSTOP
-static const int clock_stop = 1;
-#else
-static const int clock_stop = 0;
-#endif
-
 
 /* new oob placement block for use with hardware ecc generation
  */
@@ -169,7 +163,11 @@ static struct s3c2410_platform_nand *to_nand_plat(struct platform_device *dev)
 
 static inline int allow_clk_suspend(struct s3c2410_nand_info *info)
 {
-	return clock_stop;
+#ifdef CONFIG_MTD_NAND_S3C2410_CLKSTOP
+	return 1;
+#else
+	return 0;
+#endif
 }
 
 /**
-- 
1.7.4.4

