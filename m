Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab0KKCBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 21:01:04 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:35366 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932192Ab0KKCBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 21:01:01 -0500
From: Omar Ramirez Luna <omar.ramirez@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Fernando Guzman Lugo <x0095840@ti.com>,
        Rene Sapiens <rene.sapiens@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 01/02] omap: dsp: remove shm from normal memory
Date: Wed, 10 Nov 2010 19:50:24 -0600
Message-Id: <1289440225-27221-2-git-send-email-omar.ramirez@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289440225-27221-1-git-send-email-omar.ramirez@ti.com>
References: <1289440225-27221-1-git-send-email-omar.ramirez@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Contreras <felipe.contreras@gmail.com>

Also, don't be picky about the location, which incidentally fixes the
build since MEMBLOCK_REAL_LIMIT is gone on 2.6.37.

arch/arm/plat-omap/devices.c: In function 'omap_dsp_reserve_sdram_memblock':
arch/arm/plat-omap/devices.c:287: error: 'MEMBLOCK_REAL_LIMIT'
    undeclared (first use in this function)

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>
---
 arch/arm/plat-omap/devices.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-omap/devices.c b/arch/arm/plat-omap/devices.c
index 6f42a18..fc81912 100644
--- a/arch/arm/plat-omap/devices.c
+++ b/arch/arm/plat-omap/devices.c
@@ -284,12 +284,14 @@ void __init omap_dsp_reserve_sdram_memblock(void)
 	if (!size)
 		return;
 
-	paddr = __memblock_alloc_base(size, SZ_1M, MEMBLOCK_REAL_LIMIT);
+	paddr = memblock_alloc(size, SZ_1M);
 	if (!paddr) {
 		pr_err("%s: failed to reserve %x bytes\n",
 				__func__, size);
 		return;
 	}
+	memblock_free(paddr, size);
+	memblock_remove(paddr, size);
 
 	omap_dsp_phys_mempool_base = paddr;
 }
-- 
1.7.1

