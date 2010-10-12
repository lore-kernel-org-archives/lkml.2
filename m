Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab0JLPqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:46:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28113 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757578Ab0JLPqs (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 12 Oct 2010 11:46:48 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 21/23] xen/pci: Request ACS when Xen-SWIOTLB is activated.
Date: Tue, 12 Oct 2010 11:44:29 -0400
Message-Id: <1286898271-32018-22-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
References: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It used to done in the Xen startup code but that is not really
appropiate.

[v2: Update Kconfig with PCI requirement]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/pci-swiotlb-xen.c |    4 ++++
 drivers/xen/Kconfig            |    2 +-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
index a013ec9..be4d80a 100644
--- a/arch/x86/xen/pci-swiotlb-xen.c
+++ b/arch/x86/xen/pci-swiotlb-xen.c
@@ -1,6 +1,7 @@
 /* Glue code to lib/swiotlb-xen.c */
 
 #include <linux/dma-mapping.h>
+#include <linux/pci.h>
 #include <xen/swiotlb-xen.h>
 
 #include <asm/xen/hypervisor.h>
@@ -54,5 +55,8 @@ void __init pci_xen_swiotlb_init(void)
 	if (xen_swiotlb) {
 		xen_swiotlb_init(1);
 		dma_ops = &xen_swiotlb_dma_ops;
+
+		/* Make sure ACS will be enabled */
+		pci_request_acs();
 	}
 }
diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 60d71e9..f70a627 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -74,6 +74,6 @@ config XEN_PLATFORM_PCI
 
 config SWIOTLB_XEN
 	def_bool y
-	depends on SWIOTLB
+	depends on PCI && SWIOTLB
 
 endmenu
-- 
1.7.0.4

