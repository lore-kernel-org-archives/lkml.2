Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607Ab0JLPq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:46:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28207 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab0JLPqx (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 12 Oct 2010 11:46:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 14/23] x86/PCI: Export pci_walk_bus function.
Date: Tue, 12 Oct 2010 11:44:22 -0400
Message-Id: <1286898271-32018-15-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
References: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preperation of modularizing Xen-pcifront the pci_walk_bus
needs to be exported so that the xen-pcifront module can walk
call the pci subsystem to walk the PCI devices and claim them.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org> [http://marc.info/?l=linux-pci&m=126149958010298&w=2]
---
 drivers/pci/bus.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 7f0af0e..69546e9 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -299,6 +299,7 @@ void pci_walk_bus(struct pci_bus *top, int (*cb)(struct pci_dev *, void *),
 	}
 	up_read(&pci_bus_sem);
 }
+EXPORT_SYMBOL_GPL(pci_walk_bus);
 
 EXPORT_SYMBOL(pci_bus_alloc_resource);
 EXPORT_SYMBOL_GPL(pci_bus_add_device);
-- 
1.7.0.4

