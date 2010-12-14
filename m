Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab0LNNGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 08:06:50 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:50848 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759274Ab0LNNGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 08:06:47 -0500
From: Fernando Guzman Lugo <fernando.lugo@ti.com>
To: <Hiroshi.DOYU@nokia.com>, <linux@arm.linux.org.uk>, <h-kanigeri2@ti.com>
Cc: <felipe.contreras@nokia.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <tony@atomide.com>, "Guzman Lugo, Fernando" <x0095840@ti.com>
Subject: [PATCHv6 3/4] omap: iovmm - replace __iounmap with iounmap
Date: Tue, 14 Dec 2010 07:07:26 -0600
Message-Id: <1292332047-8206-4-git-send-email-fernando.lugo@ti.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292332047-8206-1-git-send-email-fernando.lugo@ti.com>
References: <1292332047-8206-1-git-send-email-fernando.lugo@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guzman Lugo, Fernando <x0095840@ti.com>

__iounmap function is wrong for OMAP architecture,
instead use iounmap which will call to the correct function.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
Acked-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
---
 arch/arm/plat-omap/iovmm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
index 93a34d9..fa6e643 100644
--- a/arch/arm/plat-omap/iovmm.c
+++ b/arch/arm/plat-omap/iovmm.c
@@ -821,7 +821,7 @@ void iommu_kunmap(struct iommu *obj, u32 da)
 	struct sg_table *sgt;
 	typedef void (*func_t)(const void *);
 
-	sgt = unmap_vm_area(obj, da, (func_t)__iounmap,
+	sgt = unmap_vm_area(obj, da, (func_t)iounmap,
 			    IOVMF_LINEAR | IOVMF_MMIO);
 	if (!sgt)
 		dev_dbg(obj->dev, "%s: No sgt\n", __func__);
-- 
1.7.3.2

