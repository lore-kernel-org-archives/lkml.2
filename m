Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab1AXTg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 14:36:28 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:36302 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab1AXTgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 14:36:22 -0500
From: Julia Lawall <julia@diku.dk>
To: Tony Lindgren <tony@atomide.com>
Cc: kernel-janitors@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] arch/arm/mach-omap2/smartreflex.c: Add missing IS_ERR test
Date: Mon, 24 Jan 2011 20:55:22 +0100
Message-Id: <1295898922-18822-5-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295898922-18822-1-git-send-email-julia@diku.dk>
References: <1295898922-18822-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function _sr_lookup, defined in the same file, returns ERR_PTR not NULL in
an error case.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier f;
@@
f(...) { ... return ERR_PTR(...); }

@@
identifier r.f, fld;
expression x;
statement S1,S2;
@@
 x = f(...)
 ... when != IS_ERR(x)
(
 if (IS_ERR(x) ||...) S1 else S2
|
*x->fld
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/arm/mach-omap2/smartreflex.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
index 77ecebf..d7deadf 100644
--- a/arch/arm/mach-omap2/smartreflex.c
+++ b/arch/arm/mach-omap2/smartreflex.c
@@ -966,7 +966,7 @@ static int __devexit omap_sr_remove(struct platform_device *pdev)
 	}
 
 	sr_info = _sr_lookup(pdata->voltdm);
-	if (!sr_info) {
+	if (IS_ERR(sr_info)) {
 		dev_warn(&pdev->dev, "%s: omap_sr struct not found\n",
 			__func__);
 		return -EINVAL;

