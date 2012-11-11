Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab2KKUzL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 15:55:11 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50788 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2KKUzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 15:55:09 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Cyril Roelandt <tipecaml@gmail.com>,
        joerg.roedel@amd.com, hdoyu@nvidia.com, swarren@nvidia.com
Subject: [PATCH 2/3] iommu/tegra-smmu.c: fix dentry reference leak in smmu_debugfs_stats_show().
Date: Sun, 11 Nov 2012 21:49:30 +0100
Message-Id: <1352666971-13551-3-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1352666971-13551-1-git-send-email-tipecaml@gmail.com>
References: <1352666971-13551-1-git-send-email-tipecaml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call to d_find_alias() needs a corresponding dput().

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/iommu/tegra-smmu.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 4167863..4252d74 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -1052,6 +1052,7 @@ static int smmu_debugfs_stats_show(struct seq_file *s, void *v)
 			stats[i], val, offs);
 	}
 	seq_printf(s, "\n");
+	dput(dent);
 
 	return 0;
 }
-- 
1.7.10.4

