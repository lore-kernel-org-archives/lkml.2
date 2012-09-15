Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab2IODMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 23:12:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51468 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab2IODMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 23:12:35 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Tony Luck <tony.luck@intel.com>, Jiang Liu <jiang.liu@huawei.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v2 0/9] enhance PCI related drivers to handle hotplug events
Date: Sat, 15 Sep 2012 11:05:03 +0800
Message-Id: <1347678312-11124-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several PCI related drivers, such as pci_bind, pci_slot, acpiphp and
aerdrv, don't handle PCI device hotplug events, which may cause stale
state and even system crashes.

This patch set registers bus notification callbacks to update driver
states when PCI device hotplug happens.

V1->V2:
	Hook pcie_port_bus_type instead of pci_bus_type for aerdrv

Jiang Liu (7):
  PCI: make PCI device create/destroy logic symmetric
  PCI: split registration of PCI bus devices into two stages
  ACPI/pci_bind: correctly update binding relationship for PCI hotplug
  ACPI/pci-bind: remove bind/unbind callbacks from acpi_device_ops
  ACPI/pci_slot: update PCI slot information when PCI hotplug event
    happens
  PCI/acpiphp: update ACPI hotplug slot information when PCI hotplug
    happens
  PCI/acpiphp: serialize access to the bridge_list list

Yijing Wang (2):
  PCI: preserve dev->subordinate until pci_stop_dev() has been called
  PCI/AER: update AER configuration when PCI hotplug event happens

 drivers/acpi/glue.c                |    6 ++-
 drivers/acpi/internal.h            |    2 +
 drivers/acpi/pci_bind.c            |   85 ++++++++++++-----------------------
 drivers/acpi/pci_root.c            |   31 -------------
 drivers/acpi/pci_slot.c            |   86 ++++++++++++++++++++++++++++++++----
 drivers/acpi/scan.c                |   21 +--------
 drivers/pci/bus.c                  |    2 +-
 drivers/pci/hotplug/acpiphp_glue.c |   75 +++++++++++++++++++++++++++++--
 drivers/pci/pcie/aer/aerdrv.c      |   63 +++++++++++++++++++++++++-
 drivers/pci/probe.c                |    4 +-
 drivers/pci/remove.c               |   20 ++++-----
 include/acpi/acpi_bus.h            |    4 --
 include/acpi/acpi_drivers.h        |    1 -
 13 files changed, 262 insertions(+), 138 deletions(-)

-- 
1.7.9.5

