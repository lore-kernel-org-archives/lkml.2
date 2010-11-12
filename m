Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab0KLViO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:38:14 -0500
Received: from mail.perches.com ([173.55.12.10]:4992 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932150Ab0KLViL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:38:11 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/14] arch/frv: Use printf extension %pR for struct resource
Date: Fri, 12 Nov 2010 13:37:51 -0800
Message-Id: <e3d54579893308b67f14e063e84a7d9c86b058d9.1289597644.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289597644.git.joe@perches.com>
References: <cover.1289597644.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using %pR standardizes the struct resource output.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/frv/mb93090-mb00/pci-vdk.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/frv/mb93090-mb00/pci-vdk.c b/arch/frv/mb93090-mb00/pci-vdk.c
index f8dd37e..4ff9e70 100644
--- a/arch/frv/mb93090-mb00/pci-vdk.c
+++ b/arch/frv/mb93090-mb00/pci-vdk.c
@@ -382,9 +382,7 @@ int __init pcibios_init(void)
 	pci_ioport_resource.end		= (__reg_MB86943_sl_pci_io_range << 9) | 0x3ff;
 	pci_ioport_resource.end		+= pci_ioport_resource.start;
 
-	printk("PCI IO window:  %08llx-%08llx\n",
-	       (unsigned long long) pci_ioport_resource.start,
-	       (unsigned long long) pci_ioport_resource.end);
+	printk("PCI IO window:  %pR\n", &pci_ioport_resource);
 
 	pci_iomem_resource.start	= (__reg_MB86943_sl_pci_mem_base << 9) & 0xfffffc00;
 	pci_iomem_resource.end		= (__reg_MB86943_sl_pci_mem_range << 9) | 0x3ff;
@@ -397,9 +395,7 @@ int __init pcibios_init(void)
 	 */
 	pci_iomem_resource.start	+= 0x400;
 
-	printk("PCI MEM window: %08llx-%08llx\n",
-	       (unsigned long long) pci_iomem_resource.start,
-	       (unsigned long long) pci_iomem_resource.end);
+	printk("PCI MEM window: %pR\n", &pci_iomem_resource);
 	printk("PCI DMA memory: %08lx-%08lx\n",
 	       dma_coherent_mem_start, dma_coherent_mem_end);
 
-- 
1.7.3.1.g432b3.dirty

