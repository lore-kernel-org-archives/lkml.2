Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935749Ab1ETTNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 15:13:38 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37031 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935691Ab1ETTNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 15:13:35 -0400
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linux-kernel@vger.kernel.org
Cc: Joerg Roedel <joerg.roedel@amd.com> (supporter:AMD IOMMU (AMD-VI)),
        Thomas Gleixner <tglx@linutronix.de> (maintainer:X86
	ARCHITECTURE...),
        Ingo Molnar <mingo@redhat.com> (maintainer:X86 ARCHITECTURE...),
        "H. Peter Anvin" <hpa@zytor.com> (maintainer:X86 ARCHITECTURE...),
        x86@kernel.org (maintainer:X86 ARCHITECTURE...),
        iommu@lists.linux-foundation.org (open list:AMD IOMMU (AMD-VI))
Subject: [PATCH 3/8] x86: Kill set but not used warning
Date: Fri, 20 May 2011 16:13:00 -0300
Message-Id: <1305918786-7239-3-git-send-email-padovan@profusion.mobi>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1305918786-7239-2-git-send-email-padovan@profusion.mobi>
References: <1305918786-7239-1-git-send-email-padovan@profusion.mobi>
 <1305918786-7239-2-git-send-email-padovan@profusion.mobi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
---
 arch/x86/kernel/amd_iommu.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 873e7e1..cd8cbeb5 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1538,13 +1538,11 @@ static void do_detach(struct device *dev)
 {
 	struct iommu_dev_data *dev_data;
 	struct amd_iommu *iommu;
-	struct pci_dev *pdev;
 	u16 devid;
 
 	devid    = get_device_id(dev);
 	iommu    = amd_iommu_rlookup_table[devid];
 	dev_data = get_dev_data(dev);
-	pdev     = to_pci_dev(dev);
 
 	/* decrease reference counters */
 	dev_data->domain->dev_iommu[iommu->index] -= 1;
@@ -1703,10 +1701,9 @@ static struct protection_domain *domain_for_device(struct device *dev)
 	struct protection_domain *dom;
 	struct iommu_dev_data *dev_data, *alias_data;
 	unsigned long flags;
-	u16 devid, alias;
+	u16 devid;
 
 	devid      = get_device_id(dev);
-	alias      = amd_iommu_alias_table[devid];
 	dev_data   = get_dev_data(dev);
 	alias_data = get_dev_data(dev_data->alias);
 	if (!alias_data)
-- 
1.7.5.1

