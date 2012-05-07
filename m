Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408Ab2EGUeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:34:07 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:51035 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230Ab2EGUab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:30:31 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 12/21] PCI: Add default busn_res for pci_scan_bus()
Date: Mon,  7 May 2012 13:29:57 -0700
Message-Id: <1336422606-4244-13-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
References: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 68e75cb..9f68b9d 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1836,9 +1836,10 @@ struct pci_bus * __devinit pci_scan_bus_parented(struct device *parent,
 
 	pci_add_resource(&resources, &ioport_resource);
 	pci_add_resource(&resources, &iomem_resource);
+	pci_add_resource(&resources, &busn_resource);
 	b = pci_create_root_bus(parent, bus, ops, sysdata, &resources);
 	if (b)
-		b->busn_res.end = pci_scan_child_bus(b);
+		pci_scan_child_bus(b);
 	else
 		pci_free_resource_list(&resources);
 	return b;
@@ -1853,9 +1854,10 @@ struct pci_bus * __devinit pci_scan_bus(int bus, struct pci_ops *ops,
 
 	pci_add_resource(&resources, &ioport_resource);
 	pci_add_resource(&resources, &iomem_resource);
+	pci_add_resource(&resources, &busn_resource);
 	b = pci_create_root_bus(NULL, bus, ops, sysdata, &resources);
 	if (b) {
-		b->busn_res.end = pci_scan_child_bus(b);
+		pci_scan_child_bus(b);
 		pci_bus_add_devices(b);
 	} else {
 		pci_free_resource_list(&resources);
-- 
1.7.7

