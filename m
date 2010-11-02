Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab0KBHK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 03:10:26 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:41325 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab0KBHKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 03:10:21 -0400
Message-ID: <4CCFB84F.6050102@web.de>
Date: Tue, 02 Nov 2010 08:05:51 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH] intel-iommu: Fix use after release during device attach
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+sG29kGqsp8zdCxTAy0BYwoMg0AsenCkYdFhwS
	Bm1/+yiErj/9U4Wgnh47tBIYhYM4V5W2ERBwhxmE88fAXO5TrA
	FPx/rGyIE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Obtail the new pgd pointer before releasing the page containing this
value.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---

Who is taking care of this? The kvm tree?

 drivers/pci/intel-iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 4789f8e..35463dd 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -3627,9 +3627,9 @@ static int intel_iommu_attach_device(struct iommu_domain *domain,
 
 		pte = dmar_domain->pgd;
 		if (dma_pte_present(pte)) {
-			free_pgtable_page(dmar_domain->pgd);
 			dmar_domain->pgd = (struct dma_pte *)
 				phys_to_virt(dma_pte_addr(pte));
+			free_pgtable_page(pte);
 		}
 		dmar_domain->agaw--;
 	}
-- 
1.7.1
