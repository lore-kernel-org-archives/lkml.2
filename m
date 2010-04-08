Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226Ab0DHTBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:01:43 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:28007 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933214Ab0DHTBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:01:35 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>, David.Woodhouse@intel.com
Cc: fenghua.yu@intel.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 4/6] pci/dmar/sriov: use physfn to search drhd for VF
Date: Thu,  8 Apr 2010 11:58:25 -0700
Message-Id: <1270753107-15881-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270753107-15881-1-git-send-email-yinghai@kernel.org>
References: <1270753107-15881-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BBE2800.0048,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When virtfn is used, we should use physfn to find correct drhd

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/dmar.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index d2f66a6..550f0a9 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -534,6 +534,11 @@ dmar_find_matched_drhd_unit(struct pci_dev *dev)
 	struct dmar_drhd_unit *dmaru = NULL;
 	struct acpi_dmar_hardware_unit *drhd;
 
+#ifdef CONFIG_PCI_IOV
+	if (dev->is_virtfn)
+		dev = dev->physfn;
+#endif
+
 	list_for_each_entry(dmaru, &dmar_drhd_units, list) {
 		drhd = container_of(dmaru->hdr,
 				    struct acpi_dmar_hardware_unit,
-- 
1.6.4.2

