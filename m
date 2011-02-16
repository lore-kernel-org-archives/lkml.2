Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab1BPWTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:19:16 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:21620 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685Ab1BPWTN (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 16 Feb 2011 17:19:13 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/3] pci/xen: Use xen_allocate_pirq_msi
Date: Wed, 16 Feb 2011 17:17:16 -0500
Message-Id: <1297894638-28007-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297894638-28007-1-git-send-email-konrad.wilk@oracle.com>
References: <1297894638-28007-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0203.4D5C4D58.01A2:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to use the old interface.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/pci/xen.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 25cd4a0..6432f75 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -157,14 +157,14 @@ static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 		goto error;
 	i = 0;
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
-		irq = xen_allocate_pirq(v[i], 0, /* not sharable */
+		xen_allocate_pirq_msi(
 			(type == PCI_CAP_ID_MSIX) ?
-			"pcifront-msi-x" : "pcifront-msi");
+			"pcifront-msi-x" : "pcifront-msi",
+			&irq, &v[i], XEN_ALLOC_IRQ);
 		if (irq < 0) {
 			ret = -1;
 			goto free;
 		}
-
 		ret = set_irq_msi(irq, msidesc);
 		if (ret)
 			goto error_while;
-- 
1.7.1

