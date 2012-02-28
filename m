Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030290Ab2B1WNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 17:13:00 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:27732 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966053Ab2B1WI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 17:08:29 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 09/24] PCI: add default res for pci_scan_bus
Date: Tue, 28 Feb 2012 14:07:28 -0800
Message-Id: <1330466863-28469-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330466863-28469-1-git-send-email-yinghai@kernel.org>
References: <1330466863-28469-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F4D5052.01B5,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 1149109..1c07aba 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1784,6 +1784,7 @@ struct pci_bus * __devinit pci_scan_bus_parented(struct device *parent,
 
 	pci_add_resource(&resources, &ioport_resource);
 	pci_add_resource(&resources, &iomem_resource);
+	pci_add_resource(&resources, &busn_resource);
 	b = pci_create_root_bus(parent, bus, ops, sysdata, &resources);
 	if (b)
 		b->subordinate = pci_scan_child_bus(b);
@@ -1801,6 +1802,7 @@ struct pci_bus * __devinit pci_scan_bus(int bus, struct pci_ops *ops,
 
 	pci_add_resource(&resources, &ioport_resource);
 	pci_add_resource(&resources, &iomem_resource);
+	pci_add_resource(&resources, &busn_resource);
 	b = pci_create_root_bus(NULL, bus, ops, sysdata, &resources);
 	if (b) {
 		b->subordinate = pci_scan_child_bus(b);
-- 
1.7.7

