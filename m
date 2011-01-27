Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab1A0P3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 10:29:41 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:46355 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab1A0P3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 10:29:39 -0500
From: Julia Lawall <julia@diku.dk>
To: Tony Lindgren <tony@atomide.com>
Cc: kernel-janitors@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] arch/arm/mach-omap2/dma.c: Convert IS_ERR result to PTR_ERR
Date: Thu, 27 Jan 2011 16:49:06 +0100
Message-Id: <1296143347-17508-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code elsewhere returns a negative constant to an indicate an error,
while IS_ERR returns the result of a >= operation.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x;
@@

 if (...) { ...
- return IS_ERR(x);
+ return PTR_ERR(x);
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/arm/mach-omap2/dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/arch/arm/mach-omap2/dma.c b/arch/arm/mach-omap2/dma.c
--- a/arch/arm/mach-omap2/dma.c
+++ b/arch/arm/mach-omap2/dma.c
@@ -264,7 +264,7 @@ static int __init omap2_system_dma_init_
 	if (IS_ERR(od)) {
 		pr_err("%s: Cant build omap_device for %s:%s.\n",
 			__func__, name, oh->name);
-		return IS_ERR(od);
+		return PTR_ERR(od);
 	}
 
 	mem = platform_get_resource(&od->pdev, IORESOURCE_MEM, 0);

