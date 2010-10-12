Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab0JLPqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:46:24 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27679 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757305Ab0JLPqW (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 12 Oct 2010 11:46:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 13/23] x86/PCI: make sure _PAGE_IOMAP it set on pci mappings
Date: Tue, 12 Oct 2010 11:44:21 -0400
Message-Id: <1286898271-32018-14-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
References: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
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

