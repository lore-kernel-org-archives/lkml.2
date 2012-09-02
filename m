Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab2IBVyd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:54:33 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:19992 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab2IBVya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:54:30 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH part4 00/11] PCI, ACPI: pci root bus hotplug support - part4
Date: Sun,  2 Sep 2012 14:54:10 -0700
Message-Id: <1346622861-30865-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is core part of ACPI pci root bus hotplug support.

First add pci_stop_and_remove_bus support, so could use it to remove root bus.

Separate out hot add from acpiphp. User could only use pci_root_hp and pciehp.
And add hot removal notification support.

could get from
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-root-bus-hotplug-part4

Jiang Liu (3):
  PCI: Fix a device reference count leakage issue in pci_dev_present()
  PCI: Correctly clean up pci root buses in function pci_remove_bus()
  PCI: Fix an access-after-free issue in function pci_stop_and_remove_bus()

Yinghai Lu (8):
  PCI: Add pci_stop_and_remove_bus()
  PCI, acpiphp: Separate out hot-add support of pci host bridge
  PCI, ACPI: Make acpi_pci_root_remove remove pci root bus too
  PCI, ACPI: Add pci_root_hp hot removal notification support.
  PCI, ACPI: Add alloc_acpi_hp_work()
  PCI, acpiphp: Use acpi_hp_work
  PCI, pci_root_hp: Use acpi_hp_work
  PCI, ACPI: Make kacpi_hotplug_wq static

 drivers/acpi/Makefile              |    1 +
 drivers/acpi/osl.c                 |   24 +++-
 drivers/acpi/pci_root.c            |   14 ++
 drivers/acpi/pci_root_hp.c         |  271 ++++++++++++++++++++++++++++++++++++
 drivers/pci/hotplug/acpiphp_glue.c |   79 ++---------
 drivers/pci/remove.c               |   44 +++++-
 drivers/pci/search.c               |   10 +-
 include/acpi/acpiosxf.h            |    9 +-
 include/linux/pci.h                |    1 +
 9 files changed, 374 insertions(+), 79 deletions(-)
 create mode 100644 drivers/acpi/pci_root_hp.c

-- 
1.7.7

