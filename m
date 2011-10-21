Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab1JUT4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 15:56:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab1JUT4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 15:56:47 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 3/4] amd-iommu: Implement iommu_device_group
To: joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, chrisw@redhat.com, agraf@suse.de,
        dwg@au1.ibm.com, scottwood@freescale.com, B08248@freescale.com,
        benh@kernel.crashing.org, alex.williamson@redhat.com
Date: Fri, 21 Oct 2011 13:56:18 -0600
Message-ID: <20111021195618.8438.17663.stgit@s20.home>
In-Reply-To: <20111021195412.8438.9951.stgit@s20.home>
References: <20111021195412.8438.9951.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just use the amd_iommu_alias_table directly.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/iommu/amd_iommu.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 4ee277a..1d82b63 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2773,6 +2773,18 @@ static int amd_iommu_domain_has_cap(struct iommu_domain *domain,
 	return 0;
 }
 
+static int amd_iommu_device_group(struct device *dev, unsigned int *groupid)
+{
+	struct iommu_dev_data *dev_data = dev->archdata.iommu;
+
+	if (!dev_data)
+		return -ENODEV;
+
+	*groupid = amd_iommu_alias_table[dev_data->devid];
+
+	return 0;
+}
+
 static struct iommu_ops amd_iommu_ops = {
 	.domain_init = amd_iommu_domain_init,
 	.domain_destroy = amd_iommu_domain_destroy,
@@ -2782,6 +2794,7 @@ static struct iommu_ops amd_iommu_ops = {
 	.unmap = amd_iommu_unmap,
 	.iova_to_phys = amd_iommu_iova_to_phys,
 	.domain_has_cap = amd_iommu_domain_has_cap,
+	.device_group = amd_iommu_device_group,
 };
 
 /*****************************************************************************

