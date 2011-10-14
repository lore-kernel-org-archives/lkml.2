Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab1JNEcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:32:52 -0400
Received: from smtp-out.google.com ([74.125.121.67]:50002 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932362Ab1JNE2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:28:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=ssvW/5Lh1ec2DWcZmkqhLp83CZI/wQtgwYCpZKkQHjMLgjjtUq9PXHbum+VG4ZrJl
	jjL013IARlg9Z9k8W2Z3A==
Subject: [PATCH v2 11/29] microblaze/PCI: make pcibios_setup_phb_resources()
	static
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Oct 2011 22:28:03 -0600
Message-ID: <20111014042803.23504.11906.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20111014042142.23504.70417.stgit@bhelgaas.mtv.corp.google.com>
References: <20111014042142.23504.70417.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Michal Simek <monstr@monstr.eu>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/microblaze/include/asm/pci-bridge.h |    1 -
 arch/microblaze/pci/pci-common.c         |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/microblaze/include/asm/pci-bridge.h b/arch/microblaze/include/asm/pci-bridge.h
index 32764cd..e9834b2 100644
--- a/arch/microblaze/include/asm/pci-bridge.h
+++ b/arch/microblaze/include/asm/pci-bridge.h
@@ -140,7 +140,6 @@ extern void pci_process_bridge_OF_ranges(struct pci_controller *hose,
 /* Allocate & free a PCI host bridge structure */
 extern struct pci_controller *pcibios_alloc_controller(struct device_node *dev);
 extern void pcibios_free_controller(struct pci_controller *phb);
-extern void pcibios_setup_phb_resources(struct pci_controller *hose);
 
 #endif	/* __KERNEL__ */
 #endif	/* _ASM_MICROBLAZE_PCI_BRIDGE_H */
diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index 9df5e5b..9dde153 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -1507,7 +1507,7 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
 	return pci_enable_resources(dev, mask);
 }
 
-void __devinit pcibios_setup_phb_resources(struct pci_controller *hose)
+static void __devinit pcibios_setup_phb_resources(struct pci_controller *hose)
 {
 	struct pci_bus *bus = hose->bus;
 	struct resource *res;

