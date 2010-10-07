Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab0JGSaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 14:30:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:32920 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415Ab0JGSaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 14:30:08 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <Hiroshi.DOYU@nokia.com>
Cc: <felipe.contreras@nokia.com>, <ameya.palande@nokia.com>,
        <david.cohen@nokia.com>, <linux-kernel@vger.kernel.org>,
        <andy.shevchenko@gmail.com>, <linux-omap@vger.kernel.org>,
        Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCH] iovmm: IVA2 MMU range is from 0x11000000 to 0xFFFFFFFF
Date: Thu,  7 Oct 2010 13:43:41 -0500
Message-Id: <1286477021-23169-1-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IV2 MMU capable addresses start from 0x11000000

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 arch/arm/plat-omap/iovmm.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
index 75965a1..c0344f4 100644
--- a/arch/arm/plat-omap/iovmm.c
+++ b/arch/arm/plat-omap/iovmm.c
@@ -286,7 +286,12 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
 		/*
 		 * Reserve the first page for NULL
 		 */
-		start = PAGE_SIZE;
+		if (!strcmp(obj->name, "iva2"))
+			/* IVA2 MMU control starts from 0x11000000 */
+			start = 0x11000000;
+		else
+			start = PAGE_SIZE;
+
 		if (flags & IOVMF_LINEAR)
 			alignement = iopgsz_max(bytes);
 		start = roundup(start, alignement);
-- 
1.6.3.3

