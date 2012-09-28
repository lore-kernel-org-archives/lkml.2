Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836Ab2I1OWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:22:37 -0400
Received: from mail.x86-64.org ([217.9.48.20]:60003 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab2I1OWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:22:36 -0400
From: Borislav Petkov <bp@amd64.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH] AMD, iommu: Fix features reporting
Date: Fri, 28 Sep 2012 16:22:26 +0200
Message-Id: <1348842146-8707-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

When the AMD IOMMU doesn't have extended features, an empty line
gets issued in dmesg like so:

[    3.061417] AMD-Vi: Found IOMMU at 0000:00:00.2 cap 0x40
[    3.066757] 							<---
[    3.068294] pci 0000:00:00.2: irq 72 for MSI/MSI-X
[    3.081213] AMD-Vi: Lazy IO/TLB flushing enabled

Fix it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/iommu/amd_iommu_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 18a89b760aaa..378aff1ff1e7 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1115,8 +1115,8 @@ static void print_iommu_info(void)
 				if (iommu_feature(iommu, (1ULL << i)))
 					pr_cont(" %s", feat_str[i]);
 			}
-		}
 		pr_cont("\n");
+		}
 	}
 }
 
-- 
1.7.11.rc1

