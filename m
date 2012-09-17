Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab2IQRnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:43:14 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:9434 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756929Ab2IQRkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:40:01 -0400
X-IronPort-AV: E=Sophos;i="4.80,437,1344211200"; 
   d="scan'208";a="208319294"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <linaro-dev@lists.linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <tim@xen.org>,
        <Ian.Campbell@citrix.com>, <konrad.wilk@oracle.com>,
        <Stefano.Stabellini@eu.citrix.com>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <devicetree-discuss@lists.ozlabs.org>,
        David Vrabel <david.vrabel@citrix.com>,
        Rob Herring <robherring2@gmail.com>,
        Dave Martin <dave.martin@linaro.org>
Subject: [PATCH v5 06/17] docs: Xen ARM DT bindings
Date: Mon, 17 Sep 2012 18:38:52 +0100
Message-ID: <1347903543-2135-6-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1209171215490.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1209171215490.29232@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a doc to describe the Xen ARM device tree bindings


Changes in v5:

- add a comment about the size of the grant table memory region;
- add a comment about the required presence of a GIC node;
- specify that the described properties are part of a top-level
"hypervisor" node;
- specify #address-cells and #size-cells for the example.


Changes in v4:

- "xen,xen" should be last as it is less specific;
- update reg property using 2 address-cells and 2 size-cells.


Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: devicetree-discuss@lists.ozlabs.org
CC: David Vrabel <david.vrabel@citrix.com>
CC: Rob Herring <robherring2@gmail.com>
CC: Dave Martin <dave.martin@linaro.org>
---
 Documentation/devicetree/bindings/arm/xen.txt |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/xen.txt

diff --git a/Documentation/devicetree/bindings/arm/xen.txt b/Documentation/devicetree/bindings/arm/xen.txt
new file mode 100644
index 0000000..0f7b9c2
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/xen.txt
@@ -0,0 +1,25 @@
+* Xen hypervisor device tree bindings
+
+Xen ARM virtual platforms shall have a top-level "hypervisor" node with
+the following properties:
+
+- compatible:
+	compatible = "xen,xen-<version>", "xen,xen";
+  where <version> is the version of the Xen ABI of the platform.
+
+- reg: specifies the base physical address and size of a region in
+  memory where the grant table should be mapped to, using an
+  HYPERVISOR_memory_op hypercall. The memory region is large enough to map
+  the whole grant table (it is larger or equal to gnttab_max_grant_frames()).
+
+- interrupts: the interrupt used by Xen to inject event notifications.
+  A GIC node is also required.
+
+
+Example (assuming #address-cells = <2> and #size-cells = <2>):
+
+hypervisor {
+	compatible = "xen,xen-4.3", "xen,xen";
+	reg = <0 0xb0000000 0 0x20000>;
+	interrupts = <1 15 0xf08>;
+};
-- 
1.7.2.5

