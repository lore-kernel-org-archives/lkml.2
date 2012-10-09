Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab2JIAgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 20:36:16 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:40462 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab2JIAgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 20:36:14 -0400
Message-ID: <1349742971.2674.75.camel@lorien2>
Subject: [PATCH] virt/kvm: change kvm_assign_device() to print return value
 when iommu_attach_device() fails
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: avi@redhat.com, mtosatti@redhat.com
Cc: kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Date: Mon, 08 Oct 2012 18:36:11 -0600
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change existing kernel error message to include return value from
iommu_attach_device() when it fails. This will help debug device
assignment failures more effectively.

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
---
 virt/kvm/iommu.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 037cb67..18e1e30 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -168,11 +168,7 @@ int kvm_assign_device(struct kvm *kvm,
 
 	r = iommu_attach_device(domain, &pdev->dev);
 	if (r) {
-		printk(KERN_ERR "assign device %x:%x:%x.%x failed",
-			pci_domain_nr(pdev->bus),
-			pdev->bus->number,
-			PCI_SLOT(pdev->devfn),
-			PCI_FUNC(pdev->devfn));
+		dev_err(&pdev->dev, "kvm assign device failed ret %d", r);
 		return r;
 	}
 
-- 
1.7.9.5



