Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620Ab1FWPbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 11:31:47 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:26561
	"EHLO CH1EHSOBE018.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757484Ab1FWPbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 11:31:44 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LN91SP-02-H5Z-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, David Brown <davidb@codeaurora.org>,
        <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/2] KVM: IOMMU: Use iommu_commit() in device-passthrough code
Date: Thu, 23 Jun 2011 17:31:23 +0200
Message-ID: <1308843083-10442-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308843083-10442-1-git-send-email-joerg.roedel@amd.com>
References: <1308843083-10442-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new iommu_commit() function in the KVM device
passthrough code.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 virt/kvm/iommu.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 62a9caf..87ef85a 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -187,6 +187,8 @@ int kvm_assign_device(struct kvm *kvm,
 		PCI_SLOT(assigned_dev->host_devfn),
 		PCI_FUNC(assigned_dev->host_devfn));
 
+	iommu_commit(domain);
+
 	return 0;
 out_unmap:
 	kvm_iommu_unmap_memslots(kvm);
@@ -215,6 +217,8 @@ int kvm_deassign_device(struct kvm *kvm,
 		PCI_SLOT(assigned_dev->host_devfn),
 		PCI_FUNC(assigned_dev->host_devfn));
 
+	iommu_commit(domain);
+
 	return 0;
 }
 
@@ -235,6 +239,8 @@ int kvm_iommu_map_guest(struct kvm *kvm)
 	if (r)
 		goto out_unmap;
 
+	iommu_commit(kvm->arch.iommu_domain);
+
 	return 0;
 
 out_unmap:
@@ -283,6 +289,8 @@ static void kvm_iommu_put_pages(struct kvm *kvm,
 
 		gfn += unmap_pages;
 	}
+
+	iommu_commit(domain);
 }
 
 static int kvm_iommu_unmap_memslots(struct kvm *kvm)
-- 
1.7.4.1


