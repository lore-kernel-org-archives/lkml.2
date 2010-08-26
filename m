Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab0HZXaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 19:30:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:58038 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614Ab0HZXaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 19:30:07 -0400
Date: Thu, 26 Aug 2010 23:29:40 GMT
From: tip-bot for Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, jeremy@xensource.com, hpa@zytor.com,
        mingo@redhat.com, konrad.wilk@oracle.com,
        fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, jeremy@xensource.com,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1282845485-8991-7-git-send-email-konrad.wilk@oracle.com>
References: <1282845485-8991-7-git-send-email-konrad.wilk@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/iommu] x86, xen-swiotlb: Make Xen-SWIOTLB use IOMMU_INIT_* macros.
Message-ID: <tip-5cb3a267939a223eb84692d229569d2ef493d7ca@git.kernel.org>
Git-Commit-ID: 5cb3a267939a223eb84692d229569d2ef493d7ca
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 26 Aug 2010 23:29:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5cb3a267939a223eb84692d229569d2ef493d7ca
Gitweb:     http://git.kernel.org/tip/5cb3a267939a223eb84692d229569d2ef493d7ca
Author:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
AuthorDate: Thu, 26 Aug 2010 13:58:01 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 26 Aug 2010 15:14:06 -0700

x86, xen-swiotlb: Make Xen-SWIOTLB use IOMMU_INIT_* macros.

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

CC: Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
LKML-Reference: <1282845485-8991-7-git-send-email-konrad.wilk@oracle.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
