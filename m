Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089Ab0HDSU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:20:29 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:54946 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757937Ab0HDSUZ (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 4 Aug 2010 14:20:25 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: alex.williamson@redhat.com, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 14/20] x86/PCI: Export pci_walk_bus function.
Date: Wed,  4 Aug 2010 14:19:09 -0400
Message-Id: <1280945955-14229-15-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
References: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C59AF5E.0074:SCFMA4539814,ss=1,fgs=0
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
index 628ea20..dbe2861 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -297,6 +297,7 @@ void pci_walk_bus(struct pci_bus *top, int (*cb)(struct pci_dev *, void *),
 	}
 	up_read(&pci_bus_sem);
 }
+EXPORT_SYMBOL_GPL(pci_walk_bus);
 
 EXPORT_SYMBOL(pci_bus_alloc_resource);
 EXPORT_SYMBOL_GPL(pci_bus_add_device);
-- 
1.7.0.1

