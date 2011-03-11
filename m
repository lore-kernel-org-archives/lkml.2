Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab1CKKhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 05:37:38 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:5870 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab1CKKhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 05:37:37 -0500
X-IronPort-AV: E=Sophos;i="4.62,302,1297054800"; 
   d="scan'208";a="139763609"
From: Ian Campbell <ian.campbell@citrix.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen/pci: Fix build without XEN_DOM0
Date: Fri, 11 Mar 2011 10:37:32 +0000
Message-Id: <1299839852-12281-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 11 Mar 2011 10:37:35.0409 (UTC) FILETIME=[55B5AA10:01CBDFD8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The xen_*_device_domain_owner functions are stubbed out in <asm/xen/pci.h> if
CONFIG_XEN_DOM0 is not enabled so extend the ifdef in arch/x86/pci/xen.c to
cover the function bodies.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/pci/xen.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 393981f..ca58a73 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -471,7 +471,6 @@ void __init xen_setup_pirqs(void)
 			trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE);
 	}
 }
-#endif
 
 struct xen_device_domain_owner {
 	domid_t domain;
@@ -545,3 +544,4 @@ int xen_unregister_device_domain_owner(struct pci_dev *dev)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xen_unregister_device_domain_owner);
+#endif
-- 
1.5.6.5

