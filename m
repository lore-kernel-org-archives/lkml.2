Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab1JKDS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 23:18:58 -0400
Received: from smtp-out.google.com ([74.125.121.67]:44531 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab1JKDSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 23:18:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=l+8QegQK24RqiwlaQqs5ZHpQz5kul2pcqRGOPWMq108KfK2MzD+lFDqLh+XmpcLCj
	IoClW37BxIMXThyelxsFA==
Subject: [PATCH 05/12] powerpc/pci: make pcibios_setup_phb_resources() static
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 10 Oct 2011 21:18:52 -0600
Message-ID: <20111011031851.5149.49502.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20111011030726.5149.23793.stgit@bhelgaas.mtv.corp.google.com>
References: <20111011030726.5149.23793.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/powerpc/include/asm/pci-bridge.h |    1 -
 arch/powerpc/kernel/pci-common.c      |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/pci-bridge.h b/arch/powerpc/include/asm/pci-bridge.h
index 56b879a..31bf836 100644
--- a/arch/powerpc/include/asm/pci-bridge.h
+++ b/arch/powerpc/include/asm/pci-bridge.h
@@ -222,7 +222,6 @@ extern void pci_process_bridge_OF_ranges(struct pci_controller *hose,
 /* Allocate & free a PCI host bridge structure */
 extern struct pci_controller *pcibios_alloc_controller(struct device_node *dev);
 extern void pcibios_free_controller(struct pci_controller *phb);
-extern void pcibios_setup_phb_resources(struct pci_controller *hose);
 
 #ifdef CONFIG_PCI
 extern int pcibios_vaddr_is_ioport(void __iomem *address);
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index 2ede26a..1ba357cd 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -1554,7 +1554,7 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
 	return pci_enable_resources(dev, mask);
 }
 
-void __devinit pcibios_setup_phb_resources(struct pci_controller *hose)
+static void __devinit pcibios_setup_phb_resources(struct pci_controller *hose)
 {
 	struct pci_bus *bus = hose->bus;
 	struct resource *res;

