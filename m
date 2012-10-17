Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab2JQLdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 07:33:18 -0400
Received: from smtp.citrix.com ([66.165.176.89]:56272 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756022Ab2JQLcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 07:32:15 -0400
X-IronPort-AV: E=Sophos;i="4.80,600,1344211200"; 
   d="scan'208";a="41487902"
From: Ian Campbell <ian.campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@citrix.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xen.org, Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 4/6] xen: correctly use xen_pfn_t in remap_domain_mfn_range.
Date: Wed, 17 Oct 2012 12:32:10 +0100
Message-ID: <1350473532-15863-4-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1350473518.2460.58.camel@zakaz.uk.xensource.com>
References: <1350473518.2460.58.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For Xen on ARM a PFN is 64 bits so we need to use the appropriate
type here.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 arch/x86/xen/mmu.c    |    2 +-
 include/xen/xen-ops.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 1c5812b..d779e96 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2603,7 +2603,7 @@ static int remap_area_mfn_pte_fn(pte_t *ptep, pgtable_t token,
 
 int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
 			       unsigned long addr,
-			       unsigned long mfn, int nr,
+			       xen_pfn_t mfn, int nr,
 			       pgprot_t prot, unsigned domid,
 			       struct page **pages)
 
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index 6a40253..dc63e80 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -26,7 +26,7 @@ void xen_destroy_contiguous_region(unsigned long vstart, unsigned int order);
 struct vm_area_struct;
 int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
 			       unsigned long addr,
-			       unsigned long mfn, int nr,
+			       xen_pfn_t mfn, int nr,
 			       pgprot_t prot, unsigned domid,
 			       struct page **pages);
 int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
-- 
1.7.2.5

