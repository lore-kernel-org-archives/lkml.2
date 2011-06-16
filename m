Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685Ab1FPMUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:20:50 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:44449 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755959Ab1FPMUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:20:47 -0400
Date: Thu, 16 Jun 2011 14:10:40 +0200
From: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
To: Steve Wise <swise@chelsio.com>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: christian.dietrich@informatik.uni-erlangen.de
Subject: [PATCH 05/11] RDMA/hw/cxgb4: use printk_ratelimited() instead of
 printk_ratelimit()
Message-ID: <3bf562d8c92207221d39b2c96af4731308324d61.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
References: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since printk_ratelimit() shouldn't be used anymore (see comment in
include/linux/printk.h), replace it with printk_ratelimited().

Signed-off-by: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
---
 drivers/infiniband/hw/cxgb4/resource.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/resource.c b/drivers/infiniband/hw/cxgb4/resource.c
index 4fb50d5..407ff39 100644
--- a/drivers/infiniband/hw/cxgb4/resource.c
+++ b/drivers/infiniband/hw/cxgb4/resource.c
@@ -37,6 +37,7 @@
 #include <linux/spinlock.h>
 #include <linux/errno.h>
 #include <linux/genalloc.h>
+#include <linux/ratelimit.h>
 #include "iw_cxgb4.h"
 
 #define RANDOM_SIZE 16
@@ -311,8 +312,8 @@ u32 c4iw_pblpool_alloc(struct c4iw_rdev *rdev, int size)
 {
 	unsigned long addr = gen_pool_alloc(rdev->pbl_pool, size);
 	PDBG("%s addr 0x%x size %d\n", __func__, (u32)addr, size);
-	if (!addr && printk_ratelimit())
-		printk(KERN_WARNING MOD "%s: Out of PBL memory\n",
+	if (!addr)
+		printk_ratelimited(KERN_WARNING MOD "%s: Out of PBL memory\n",
 		       pci_name(rdev->lldi.pdev));
 	return (u32)addr;
 }
@@ -373,8 +374,8 @@ u32 c4iw_rqtpool_alloc(struct c4iw_rdev *rdev, int size)
 {
 	unsigned long addr = gen_pool_alloc(rdev->rqt_pool, size << 6);
 	PDBG("%s addr 0x%x size %d\n", __func__, (u32)addr, size << 6);
-	if (!addr && printk_ratelimit())
-		printk(KERN_WARNING MOD "%s: Out of RQT memory\n",
+	if (!addr)
+		printk_ratelimited(KERN_WARNING MOD "%s: Out of RQT memory\n",
 		       pci_name(rdev->lldi.pdev));
 	return (u32)addr;
 }
-- 
1.7.4.1

