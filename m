Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162Ab2ISTEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 15:04:13 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:47905 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756910Ab2ISSzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 14:55:20 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 12/40] PCI, x86: Remove __init for hw/fw allocated functions
Date: Wed, 19 Sep 2012 11:54:26 -0700
Message-Id: <1348080894-23412-13-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1348080894-23412-1-git-send-email-yinghai@kernel.org>
References: <CAE9FiQWFcVNKMnV1qaHchwCXfZuMpyxf_f7GQy3FZid9YuLD3w@mail.gmail.com>
 <1348080894-23412-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

will need it for hot add path.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/i386.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index edfc376..1806e91 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -201,7 +201,7 @@ EXPORT_SYMBOL(pcibios_align_resource);
  *	    as well.
  */
 
-static void __init pcibios_allocate_bridge_resources(struct pci_dev *dev)
+static void pcibios_allocate_bridge_resources(struct pci_dev *dev)
 {
 	int idx;
 	struct resource *r;
@@ -223,7 +223,7 @@ static void __init pcibios_allocate_bridge_resources(struct pci_dev *dev)
 	}
 }
 
-static void __init pcibios_allocate_bus_resources(struct pci_bus *bus)
+static void pcibios_allocate_bus_resources(struct pci_bus *bus)
 {
 	struct pci_bus *child;
 
@@ -239,7 +239,7 @@ struct pci_check_idx_range {
 	int end;
 };
 
-static void __init pcibios_allocate_dev_resources(struct pci_dev *dev, int pass)
+static void pcibios_allocate_dev_resources(struct pci_dev *dev, int pass)
 {
 	int idx, disabled, i;
 	u16 command;
@@ -292,7 +292,7 @@ static void __init pcibios_allocate_dev_resources(struct pci_dev *dev, int pass)
 	}
 }
 
-static void __init pcibios_allocate_resources(struct pci_bus *bus, int pass)
+static void pcibios_allocate_resources(struct pci_bus *bus, int pass)
 {
 	struct pci_dev *dev;
 	struct pci_bus *child;
@@ -306,7 +306,7 @@ static void __init pcibios_allocate_resources(struct pci_bus *bus, int pass)
 	}
 }
 
-static void __init pcibios_allocate_dev_rom_resource(struct pci_dev *dev)
+static void pcibios_allocate_dev_rom_resource(struct pci_dev *dev)
 {
 	struct resource *r;
 
@@ -324,7 +324,7 @@ static void __init pcibios_allocate_dev_rom_resource(struct pci_dev *dev)
 		r->start = 0;
 	}
 }
-static void __init pcibios_allocate_rom_resources(struct pci_bus *bus)
+static void pcibios_allocate_rom_resources(struct pci_bus *bus)
 {
 	struct pci_dev *dev;
 	struct pci_bus *child;
-- 
1.7.7

