Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab2JAHlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 03:41:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53758 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab2JAHli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 03:41:38 -0400
From: Daniel J Blueman <daniel@quora.org>
To: Ingo Molnar <mingo@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Daniel J Blueman <daniel@quora.org>
Subject: [PATCH] Correct AMD IOMMU printing
Date: Mon,  1 Oct 2012 15:41:13 +0800
Message-Id: <1349077273-17297-1-git-send-email-daniel@quora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an AMD IOMMU is detected, prevent printing unintended blank line.

Signed-off-by: Daniel J Blueman <daniel@quora.org>
---
 drivers/iommu/amd_iommu_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 18a89b7..49d9d32 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1115,8 +1115,8 @@ static void print_iommu_info(void)
 				if (iommu_feature(iommu, (1ULL << i)))
 					pr_cont(" %s", feat_str[i]);
 			}
+			pr_cont("\n");
 		}
-		pr_cont("\n");
 	}
 }
 
-- 
1.7.9.5

