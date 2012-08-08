Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab2HHGZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 02:25:10 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15723 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569Ab2HHGZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 02:25:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 07 Aug 2012 23:25:01 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: <iommu@lists.linux-foundation.org>, <linux-tegra@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Joerg Roedel <joerg.roedel@amd.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Chris Wright <chrisw@sous-sol.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] iommu/tegra: smmu: Use __debugfs_create_dir
Date: Wed, 8 Aug 2012 09:24:33 +0300
Message-ID: <1344407073-12030-3-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1344407073-12030-1-git-send-email-hdoyu@nvidia.com>
References: <1344407073-12030-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit c3b1a35 "debugfs: make sure that debugfs_create_file() gets
used only for regulars" doesn't allow to use debugfs_create_file() for
dir. Use the version with "data", __debugfs_create_dir().

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
Reported-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/iommu/tegra-smmu.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 5e51fb7..41aff7a 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -1035,9 +1035,7 @@ static void smmu_debugfs_create(struct smmu_device *smmu)
 	int i;
 	struct dentry *root;
 
-	root = debugfs_create_file(dev_name(smmu->dev),
-				   S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
-				   NULL, smmu, NULL);
+	root = __debugfs_create_dir(dev_name(smmu->dev), NULL, smmu);
 	if (!root)
 		goto err_out;
 	smmu->debugfs_root = root;
-- 
1.7.5.4

