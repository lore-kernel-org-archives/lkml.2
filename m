Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab0JDSQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:16:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31466 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790Ab0JDSN7 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 4 Oct 2010 14:13:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 13/22] x86/PCI: make sure _PAGE_IOMAP it set on pci mappings
Date: Mon,  4 Oct 2010 14:13:26 -0400
Message-Id: <1286216015-9710-14-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286216015-9710-1-git-send-email-konrad.wilk@oracle.com>
References: <1286216015-9710-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

When mapping pci space via /sys or /proc, make sure we're really
doing a hardware mapping by setting _PAGE_IOMAP.

[ Impact: bugfix; make PCI mappings map the right pages ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: "H. Peter Anvin" <hpa@zytor.com>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Cc: x86@kernel.org
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 arch/x86/pci/i386.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 5525309..8379c2c 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -311,6 +311,8 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 		 */
 		prot |= _PAGE_CACHE_UC_MINUS;
 
+	prot |= _PAGE_IOMAP;	/* creating a mapping for IO */
+
 	vma->vm_page_prot = __pgprot(prot);
 
 	if (io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
-- 
1.7.0.4

