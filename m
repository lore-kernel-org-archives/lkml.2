Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041Ab1D2TJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:09:22 -0400
Received: from kroah.org ([198.145.64.141]:50213 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932705Ab1D2S6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:14 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:53 2011
Message-Id: <20110429185653.757562992@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:55:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Kiszka <jan.kiszka@siemens.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [12/55] intel-iommu: Fix use after release during device attach
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Kiszka <jan.kiszka@siemens.com>

commit 7a6610139a1e1d9297dd1c5d178022eac36839cb upstream.

Obtain the new pgd pointer before releasing the page containing this
value.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Reviewed-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/intel-iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -3627,9 +3627,9 @@ static int intel_iommu_attach_device(str
 
 		pte = dmar_domain->pgd;
 		if (dma_pte_present(pte)) {
-			free_pgtable_page(dmar_domain->pgd);
 			dmar_domain->pgd = (struct dma_pte *)
 				phys_to_virt(dma_pte_addr(pte));
+			free_pgtable_page(pte);
 		}
 		dmar_domain->agaw--;
 	}


