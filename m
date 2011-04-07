Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab1DGKaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 06:30:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:56157 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015Ab1DGKaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 06:30:07 -0400
Date: Thu, 7 Apr 2011 12:30:03 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, bheglaas@google.com,
        monstr@monstr.eu, tglx@linutronix.de
Subject: Re: [PATCH 4/5] x86/devicetree: Use generic PCI <-> OF matching
Message-ID: <20110407103003.GA8592@linutronix.de>
References: <1302146796-26825-1-git-send-email-benh@kernel.crashing.org>
 <1302146796-26825-5-git-send-email-benh@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1302146796-26825-5-git-send-email-benh@kernel.crashing.org>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Benjamin Herrenschmidt | 2011-04-07 13:26:35 [+1000]:

>Instead of walking the whole PCI tree to update the of_node's for
>PCI busses and devices after the fact, enable the new generic core
>code for doing so by providing the proper device nodes for the
>PCI host bridges
>
>Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Ben, please add this to the series or melt into this patch :)

>From 1460c529a53a393dd3b41cdcd72ecc6ff1d3646e Mon Sep 17 00:00:00 2001
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Thu, 7 Apr 2011 10:47:51 +0200
Subject: [PATCH] x86: dt: remove unused and/or shadowed variables

|arch/x86/kernel/devicetree.c: In function 'pcibios_get_phb_of_node':
|arch/x86/kernel/devicetree.c:135:23: warning: unused variable 'child'
|arch/x86/kernel/devicetree.c:129:15: warning: unused variable 'bus_min'
|arch/x86/kernel/devicetree.c:144:1: warning: control reaches end of non-void function
|arch/x86/kernel/devicetree.c:141:10: warning: 'bus' may be used uninitialized in this function

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/kernel/devicetree.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index f6c9d67..3568496 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -123,16 +123,13 @@ static int __init add_bus_probe(void)
 module_init(add_bus_probe);
 
 #ifdef CONFIG_PCI
-struct device_node * pcibios_get_phb_of_node(struct pci_bus *bus)
+struct device_node *pcibios_get_phb_of_node(struct pci_bus *bus)
 {
 	struct device_node *np;
-	unsigned int bus_min;
 
 	for_each_node_by_type(np, "pci") {
 		const void *prop;
-		struct pci_bus *bus;
 		unsigned int bus_min;
-		struct device_node *child;
 
 		prop = of_get_property(np, "bus-range", NULL);
 		if (!prop)
@@ -141,6 +138,7 @@ struct device_node * pcibios_get_phb_of_node(struct pci_bus *bus)
 		if (bus->number == bus_min)
 			return np;
 	}
+	return NULL;
 }
 
 static int x86_of_pci_irq_enable(struct pci_dev *dev)
-- 
1.7.4

