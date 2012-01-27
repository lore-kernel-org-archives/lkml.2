Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab2A0H03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 02:26:29 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:49115 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab2A0H01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 02:26:27 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 2/7] x86, irq: more clear about msix printout
Date: Thu, 26 Jan 2012 23:25:48 -0800
Message-Id: <1327649153-16477-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327649153-16477-1-git-send-email-yinghai@kernel.org>
References: <1327649153-16477-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4F225192.001A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print out exact MSI or MSI-X instead of MSI/MSI-X

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e4ee9bc..f5c77ff 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3274,7 +3274,8 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 
 	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
 
-	dev_printk(KERN_DEBUG, &dev->dev, "irq %d for MSI/MSI-X\n", irq);
+	dev_printk(KERN_DEBUG, &dev->dev, "irq %d for MSI%s\n", irq,
+			 msidesc->msi_attrib.is_msix ? "-X" : "");
 
 	return 0;
 }
-- 
1.7.7

