Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab2ALJ4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 04:56:07 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:41684 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364Ab2ALJzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 04:55:33 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Tony Lindgren <tony@atomide.com>
Cc: kernel-janitors@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/15] arch/arm/mach-omap2/smartreflex.c: add missing iounmap
Date: Thu, 12 Jan 2012 10:55:17 +0100
Message-Id: <1326362117-29371-15-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Add missing iounmap in error handling code, in a case where the function
already preforms iounmap on some other execution path.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
statement S,S1;
int ret;
@@
e = \(ioremap\|ioremap_nocache\)(...)
... when != iounmap(e)
if (<+...e...+>) S
... when any
    when != iounmap(e)
*if (...)
   { ... when != iounmap(e)
     return ...; }
... when any
iounmap(e);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 arch/arm/mach-omap2/smartreflex.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
index 9dd9345..7e755bb 100644
--- a/arch/arm/mach-omap2/smartreflex.c
+++ b/arch/arm/mach-omap2/smartreflex.c
@@ -897,7 +897,7 @@ static int __init omap_sr_probe(struct platform_device *pdev)
 		ret = sr_late_init(sr_info);
 		if (ret) {
 			pr_warning("%s: Error in SR late init\n", __func__);
-			return ret;
+			goto err_iounmap;
 		}
 	}
 

