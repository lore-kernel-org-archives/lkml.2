Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964Ab1KPCZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 21:25:11 -0500
Received: from mga03.intel.com ([143.182.124.21]:56654 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040Ab1KPCZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 21:25:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,518,1315206000"; 
   d="scan'208";a="37534582"
Subject: [PATCH] x86: fix an erroneous debug message
From: Zhang Rui <rui.zhang@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Renninger <trenn@suse.de>
Content-Type: multipart/mixed; boundary="=-9MvsXf2pyFq29WKVA4YH"
Date: Wed, 16 Nov 2011 10:23:20 +0800
Message-ID: <1321410200.19828.4.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9MvsXf2pyFq29WKVA4YH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Fix an erroneous debug message.
    
Signed-off-by: Zhang Rui <rui.zhang@intel.com>

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 3c31fa9..1a691f5 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3641,8 +3641,8 @@ int io_apic_set_pci_routing(struct device *dev, int irq,
 	int node;
 
 	if (!IO_APIC_IRQ(irq)) {
-		apic_printk(APIC_QUIET,KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ 0\n",
-			    irq_attr->ioapic);
+		apic_printk(APIC_QUIET,KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ %d\n",
+			    irq_attr->ioapic, irq);
 		return -EINVAL;
 	}
 


--=-9MvsXf2pyFq29WKVA4YH
Content-Disposition: attachment; filename="fix-1.patch"
Content-Type: text/x-patch; name="fix-1.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

commit 73291d135bbf4b627bbf0cd99587f0d3fbbc82f4
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Wed Nov 16 10:12:56 2011 +0800

    Fix a buggy debug messagge.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 3c31fa9..1a691f5 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3641,8 +3641,8 @@ int io_apic_set_pci_routing(struct device *dev, int irq,
 	int node;
 
 	if (!IO_APIC_IRQ(irq)) {
-		apic_printk(APIC_QUIET,KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ 0\n",
-			    irq_attr->ioapic);
+		apic_printk(APIC_QUIET,KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ %d\n",
+			    irq_attr->ioapic, irq);
 		return -EINVAL;
 	}
 

--=-9MvsXf2pyFq29WKVA4YH--

