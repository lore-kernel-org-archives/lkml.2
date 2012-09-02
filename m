Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab2IBVwg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:52:36 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:23506 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359Ab2IBVwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:52:31 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH part3 00/11] PCI, x86: pci root bus hotplug support - part3
Date: Sun,  2 Sep 2012 14:52:10 -0700
Message-Id: <1346622741-30799-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci bus rescan related changes.
So later root bus hotadd path could use pci_assign_unassigned_resource for root bus.

could get from
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-root-bus-hotplug-part3

Yinghai Lu (11):
  PCI: Separate out pci_assign_unassigned_bus_resources()
  PCI: Move back pci_rescan_bus() to probe.c
  PCI: pci_bus_size_bridges() should not size own bridge
  PCI: Use __pci_bus_size_bridges() directly in pci_assign_unassigned_bus_resources()
  PCI, sysfs: Use device_type and attr_groups with pci dev
  PCI, sysfs: Create rescan_bridge under /sys/.../pci/devices/... for pci bridges
  PCI: Add pci_bus_add_single_device()
  PCI: Make pci_rescan_bus_bridge_resize() use pci_scan_bridge
  PCI: Clean up rescan_bus_bridge_resize()
  PCI: Rescan bus or bridge using callback method too
  PCI, sysfs: Clean up rescan/remove with scheule_callback

 Documentation/ABI/testing/sysfs-bus-pci |   10 +++
 drivers/pci/bus.c                       |   39 ++++++++++++
 drivers/pci/hotplug/acpiphp_glue.c      |    3 +-
 drivers/pci/pci-sysfs.c                 |  101 ++++++++++++++++++++++++++----
 drivers/pci/pci.h                       |    1 +
 drivers/pci/probe.c                     |   30 ++++++++-
 drivers/pci/setup-bus.c                 |   50 +++++----------
 include/linux/pci.h                     |    3 +
 8 files changed, 185 insertions(+), 52 deletions(-)

-- 
1.7.7

