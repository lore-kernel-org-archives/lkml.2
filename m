Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab0HZR65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 13:58:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18871 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab0HZR6y (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 26 Aug 2010 13:58:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: hpa@zytor.com, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 06/10] x86/xen-swiotlb: Make Xen-SWIOTLB use IOMMU_INIT_* macros.
Date: Thu, 26 Aug 2010 13:58:01 -0400
Message-Id: <1282845485-8991-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1282845485-8991-1-git-send-email-konrad.wilk@oracle.com>
References: <1282845485-8991-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We utilize the IOMMU_INIT macros to create this dependency:

               [null]
                 |
       [pci_xen_swiotlb_detect]
                 |
       [pci_swiotlb_detect_override]
                 |
       [pci_swiotlb_detect_4gb]

In other words, we set 'pci_xen_swiotlb_detect' to be
the first detection to be run during start.

CC: H. Peter Anvin <hpa@zytor.com>
CC: Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/pci-swiotlb-xen.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
index a013ec9..2247100 100644
--- a/arch/x86/xen/pci-swiotlb-xen.c
+++ b/arch/x86/xen/pci-swiotlb-xen.c
@@ -5,6 +5,7 @@
 
 #include <asm/xen/hypervisor.h>
 #include <xen/xen.h>
+#include <asm/iommu_table.h>
 
 int xen_swiotlb __read_mostly;
 
@@ -56,3 +57,7 @@ void __init pci_xen_swiotlb_init(void)
 		dma_ops = &xen_swiotlb_dma_ops;
 	}
 }
+IOMMU_INIT_FINISH(pci_xen_swiotlb_detect,
+		  0,
+		  pci_xen_swiotlb_init,
+		  0);
-- 
1.7.0.1

