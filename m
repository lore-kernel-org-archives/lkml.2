Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab0GNOEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 10:04:41 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:47034 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756521Ab0GNOEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 10:04:38 -0400
Date: Wed, 14 Jul 2010 16:04:36 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Samuel Ortiz <sameo@linux.intel.com>, Balaji T K <balajitk@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 2/5] drivers/mfd: Remove dead CONFIG_TWL4030_MADC
Message-ID: <d0fe8837d5273256219e7b5e243c2c831686dfcd.1279116162.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <c3c850bed3f5714f1efcfad24ad4f8bfcb6b5b54.1279116162.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3c850bed3f5714f1efcfad24ad4f8bfcb6b5b54.1279116162.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_TWL4030_MADC{,_MODULE} doesn't exist in Kconfig and is never
defined anywhere else, therefore removing all references for it from
the source code.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 drivers/mfd/twl-core.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 720e099..d8c7ae2 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -77,12 +77,6 @@
 #define twl_has_regulator()	false
 #endif
 
-#if defined(CONFIG_TWL4030_MADC) || defined(CONFIG_TWL4030_MADC_MODULE)
-#define twl_has_madc()	true
-#else
-#define twl_has_madc()	false
-#endif
-
 #ifdef CONFIG_TWL4030_POWER
 #define twl_has_power()        true
 #else
@@ -600,14 +594,6 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
 			return PTR_ERR(child);
 	}
 
-	if (twl_has_madc() && pdata->madc) {
-		child = add_child(2, "twl4030_madc",
-				pdata->madc, sizeof(*pdata->madc),
-				true, pdata->irq_base + MADC_INTR_OFFSET, 0);
-		if (IS_ERR(child))
-			return PTR_ERR(child);
-	}
-
 	if (twl_has_rtc()) {
 		/*
 		 * REVISIT platform_data here currently might expose the
-- 
1.7.0.4

