Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759690Ab2GLWiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:38:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58752 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759659Ab2GLWin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:38:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hiroshi DOYU <hdoyu@nvidia.com>, Chris Wright <chrisw@sous-sol.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [ 055/187] iommu/tegra: smmu: Fix unsleepable memory allocation
Date: Thu, 12 Jul 2012 15:33:31 -0700
Message-Id: <20120712191527.456311708@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hiroshi DOYU <hdoyu@nvidia.com>

commit 8f53dc724a83a0082184fa27df80c25c7df47340 upstream.

allo_pdir() is called in smmu_iommu_domain_init() with spin_lock
held. memory allocations in it have to be atomic/unsleepable.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
Reported-by: Chris Wright <chrisw@sous-sol.org>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/tegra-smmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -550,13 +550,13 @@ static int alloc_pdir(struct smmu_as *as
 		return 0;
 
 	as->pte_count = devm_kzalloc(smmu->dev,
-		     sizeof(as->pte_count[0]) * SMMU_PDIR_COUNT, GFP_KERNEL);
+		     sizeof(as->pte_count[0]) * SMMU_PDIR_COUNT, GFP_ATOMIC);
 	if (!as->pte_count) {
 		dev_err(smmu->dev,
 			"failed to allocate smmu_device PTE cunters\n");
 		return -ENOMEM;
 	}
-	as->pdir_page = alloc_page(GFP_KERNEL | __GFP_DMA);
+	as->pdir_page = alloc_page(GFP_ATOMIC | __GFP_DMA);
 	if (!as->pdir_page) {
 		dev_err(smmu->dev,
 			"failed to allocate smmu_device page directory\n");


