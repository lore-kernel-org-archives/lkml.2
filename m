Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab0HAJJs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 05:09:48 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:45274 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab0HAJJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 05:09:46 -0400
Date: Sun, 1 Aug 2010 11:09:44 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] arch/sparc/mm: Use GFP_KERNEL
Message-ID: <Pine.LNX.4.64.1008011109260.21594@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

GFP_ATOMIC is not needed here, as evidenced by the other two uses of
GFP_KERNEL in the same function.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@ identifier f; @@

*f(...,GFP_ATOMIC,...)
... when != spin_unlock(...)
    when != read_unlock(...)
    when != write_unlock(...)
    when != read_unlock_irq(...)
    when != write_unlock_irq(...)
    when != read_unlock_irqrestore(...)
    when != write_unlock_irqrestore(...)
    when != spin_unlock_irq(...)
    when != spin_unlock_irqrestore(...)
*f(...,GFP_KERNEL,...)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/sparc/mm/iommu.c               |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/mm/iommu.c b/arch/sparc/mm/iommu.c
index 7385806..07fc6a6 100644
--- a/arch/sparc/mm/iommu.c
+++ b/arch/sparc/mm/iommu.c
@@ -63,7 +63,7 @@ static void __init sbus_iommu_init(struct platform_device *op)
 	unsigned long *bitmap;
 	unsigned long tmp;
 
-	iommu = kmalloc(sizeof(struct iommu_struct), GFP_ATOMIC);
+	iommu = kmalloc(sizeof(struct iommu_struct), GFP_KERNEL);
 	if (!iommu) {
 		prom_printf("Unable to allocate iommu structure\n");
 		prom_halt();
