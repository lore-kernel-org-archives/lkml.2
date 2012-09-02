Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab2IBV4U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:56:20 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:40047 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359Ab2IBV4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:56:16 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH part5 0/7] PCI, ACPI: pci root bus hotplug support - part5
Date: Sun,  2 Sep 2012 14:55:58 -0700
Message-Id: <1346622965-30937-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This part is to make sure ioapic and dmar handling sequence.

aka need to start driver for ioapic and dmar before regular pci device drivers.
and need to stop dmar and ioapic driver after pci device drivers.

user acpi_pci_driver to start and stop ioapic and dmar driver.

could get from
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-root-bus-hotplug-part5


Jiang Liu (3):
  ACPI, PCI: Use normal list for struct acpi_pci_driver
  ACPI, PCI: Notify acpi_pci_drivers when hot-plugging PCI root bridges
  ACPI, PCI: Protect global lists in drivers/acpi/pci_root.c

Yinghai Lu (4):
  ACPI, PCI: Stop pci devices before acpi_pci_driver remove calling
  PCI: Set dev_node early for pci_dev
  PCI, x86: Move pci_enable_bridges() down
  ACPI, PCI: Skip extra pci_enable_bridges for non hot-add root

 drivers/acpi/pci_root.c    |  121 +++++++++++++++++++++++++++-----------------
 drivers/acpi/pci_root_hp.c |    1 +
 drivers/pci/probe.c        |    2 +
 drivers/pci/setup-bus.c    |    2 -
 include/acpi/acpi_bus.h    |    1 +
 include/linux/acpi.h       |    2 +-
 6 files changed, 79 insertions(+), 50 deletions(-)

-- 
1.7.7

