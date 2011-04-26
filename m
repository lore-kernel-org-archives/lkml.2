Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415Ab1DZVOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:14:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:60554 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932332Ab1DZVOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="684327375"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: jeffm@suse.com, tony.luck@intel.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [58/106] tioca: Fix assignment from incompatible pointer warnings
Message-Id: <20110426211338.C116F3E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jeff Mahoney <jeffm@suse.com>

commit b4a6b3436531f6c5256e6d60d388c3c28ff1a0e9 upstream.

The prototype for sn_pci_provider->{dma_map,dma_map_consistent} expects
an unsigned long instead of a u64.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/ia64/sn/pci/tioca_provider.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/arch/ia64/sn/pci/tioca_provider.c
===================================================================
--- linux-2.6.35.y.orig/arch/ia64/sn/pci/tioca_provider.c
+++ linux-2.6.35.y/arch/ia64/sn/pci/tioca_provider.c
@@ -509,7 +509,7 @@ tioca_dma_unmap(struct pci_dev *pdev, dm
  * use the GART mapped mode.
  */
 static u64
-tioca_dma_map(struct pci_dev *pdev, u64 paddr, size_t byte_count, int dma_flags)
+tioca_dma_map(struct pci_dev *pdev, unsigned long paddr, size_t byte_count, int dma_flags)
 {
 	u64 mapaddr;
 
