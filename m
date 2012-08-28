Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab2H1PoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 11:44:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56281 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab2H1PoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 11:44:21 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Don Dutile <ddutile@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 0/5] Simplify code by using hotplug safe pci_get_domain_bus_and_slot()
Date: Tue, 28 Aug 2012 23:43:53 +0800
Message-Id: <1346168638-32724-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following code has a race window between pci_find_bus() and pci_get_slot()
if PCI hotplug operation happens between them which removes the pci_bus.
So use PCI hotplug safe interface pci_get_domain_bus_and_slot() instead,
which also reduces code complexity.

struct pci_bus *pci_bus = pci_find_bus(domain, busno);
struct pci_dev *pci_dev = pci_get_slot(pci_bus, devfn);

Jiang Liu (5):
  PCI/IA64: simplify code by hotplug safe pci_get_domain_bus_and_slot()
  PCI/vga: simplify code by hotplug safe pci_get_domain_bus_and_slot()
  PCI/cpcihp: simplify code by hotplug safe
    pci_get_domain_bus_and_slot()
  PCI/IOV: simplify code by hotplug safe pci_get_domain_bus_and_slot()
  PCI/xen-pcifront: simplify code by hotplug safe
    pci_get_domain_bus_and_slot()

 arch/ia64/sn/kernel/io_common.c      |    4 +---
 drivers/gpu/vga/vgaarb.c             |   15 +++------------
 drivers/pci/hotplug/cpcihp_generic.c |    8 ++------
 drivers/pci/iov.c                    |    8 ++------
 drivers/pci/xen-pcifront.c           |   10 ++--------
 5 files changed, 10 insertions(+), 35 deletions(-)

-- 
1.7.9.5

