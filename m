Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab0JDSOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:14:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31564 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821Ab0JDSOD (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 4 Oct 2010 14:14:03 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 21/22] xen/pci: Request ACS when Xen-SWIOTLB is activated.
Date: Mon,  4 Oct 2010 14:13:34 -0400
Message-Id: <1286216015-9710-22-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286216015-9710-1-git-send-email-konrad.wilk@oracle.com>
References: <1286216015-9710-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It used to done in the Xen startup code but that is not really
appropiate.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/pci-swiotlb-xen.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

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
-- 
1.7.0.4

