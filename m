Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab1DLLTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 07:19:39 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:21414 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab1DLLTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 07:19:38 -0400
X-IronPort-AV: E=Sophos;i="4.64,195,1301889600"; 
   d="scan'208";a="144559606"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, konrad.wilk@oracle.com, jeremy@goop.org,
        Stefano.Stabellini@eu.citrix.com, yinghai@kernel.org,
        hpa@linux.intel.com, mingo@elte.hu,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 1/4] xen: mask_rw_pte mark RO all pagetable pages up to pgt_buf_top
Date: Tue, 12 Apr 2011 12:19:49 +0100
Message-Id: <1302607192-21355-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1104121149280.22672@kaball-desktop>
References: <alpine.DEB.2.00.1104121149280.22672@kaball-desktop>
X-OriginalArrivalTime: 12 Apr 2011 11:19:37.0489 (UTC) FILETIME=[82348810:01CBF903]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

mask_rw_pte is currently checking if a pfn is a pagetable page if it
falls in the range pgt_buf_start - pgt_buf_end but that is incorrect
because pgt_buf_end is a moving target: pgt_buf_top is the real
boundary.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index c82df6c..6b833db 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1491,7 +1491,7 @@ static __init pte_t mask_rw_pte(pte_t *ptep, pte_t pte)
 	 * it is RO.
 	 */
 	if (((!is_early_ioremap_ptep(ptep) &&
-			pfn >= pgt_buf_start && pfn < pgt_buf_end)) ||
+			pfn >= pgt_buf_start && pfn < pgt_buf_top)) ||
 			(is_early_ioremap_ptep(ptep) && pfn != (pgt_buf_end - 1)))
 		pte = pte_wrprotect(pte);
 
-- 
1.7.2.3

