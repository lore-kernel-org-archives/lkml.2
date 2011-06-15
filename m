Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab1FOTUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:20:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63588 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab1FOTUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:20:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        stefano.stabellini@eu.citrix.com, Ian.Campbell@citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 8/8] xen/pci: Remove unnecessary #ifdef CONFIG_ACPI
Date: Wed, 15 Jun 2011 15:19:47 -0400
Message-Id: <1308165587-24902-9-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308165587-24902-1-git-send-email-konrad.wilk@oracle.com>
References: <1308165587-24902-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4DF905E0.00CC:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the code paths that are guarded by CONFIG_XEN_DOM0
already depend on CONFIG_ACPI so the extra #ifdef has
no point being here.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/pci/xen.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index b53e1b7..e6ad37e 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -377,7 +377,6 @@ int __init pci_xen_hvm_init(void)
 }
 
 #ifdef CONFIG_XEN_DOM0
-#ifdef CONFIG_ACPI
 static __init void xen_setup_acpi_sci(void)
 {
 	int rc;
@@ -404,7 +403,6 @@ static __init void xen_setup_acpi_sci(void)
 
 	return;
 }
-#endif
 
 int __init pci_xen_initial_domain(void)
 {
@@ -414,7 +412,6 @@ int __init pci_xen_initial_domain(void)
 	x86_msi.setup_msi_irqs = xen_initdom_setup_msi_irqs;
 	x86_msi.teardown_msi_irq = xen_teardown_msi_irq;
 #endif
-#ifdef CONFIG_ACPI
 	xen_setup_acpi_sci();
 	__acpi_register_gsi = acpi_register_gsi_xen;
 	/* Pre-allocate legacy irqs */
@@ -427,7 +424,6 @@ int __init pci_xen_initial_domain(void)
 		xen_register_pirq(irq,
 			trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE, true);
 	}
-#endif
 	if (0 == nr_ioapics) {
 		for (irq = 0; irq < NR_IRQS_LEGACY; irq++) {
 			pirq = xen_allocate_pirq_gsi(irq);
-- 
1.7.4.1

