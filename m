Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab2KDEmL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 00:42:11 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:23720 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab2KDEmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 00:42:05 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 0/8] PCI, ACPI, x86: Reserve fw allocated resource for hot-add root bus
Date: Sat,  3 Nov 2012 21:39:23 -0700
Message-Id: <1352003971-22278-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <20121030040237.GA10472@google.com>
References: <20121030040237.GA10472@google.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For root bus hot add, fw could assign some resource for the devices for
that root bus before notifying os via acpi, we should check and use those
resources at first just like we do for booting path.

At first, we need to refactor x86 pci pcibios_allocate related functions
for booting path to take bus as parameter.

After that, we could use the survey function for hot add root bus.

based on pci/yinghai-for-pci-root-bus-hotplug

could get from
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-survey-resources

Yinghai Lu (8):
  PCI, x86: Separate out pcibios_allocate_bridge_resources()
  PCI, x86: Separate out pcibios_allocate_dev_resources()
  PCI, x86: Let pcibios_allocate_bus_resources() take bus instead
  PCI, x86: Separate out rom resource claim
  PCI, x86: Add pcibios_fw_addr_done
  PCI, x86: Remove __init for hw/fw allocated functions
  PCI, x86: Claim FW allocated resources in hot add path.
  PCI, ACPI: reserve fw allocated resource for hot added root bus

 arch/x86/pci/i386.c     |  185 +++++++++++++++++++++++++++++++----------------
 drivers/acpi/pci_root.c |    4 +-
 drivers/pci/bus.c       |    2 +
 include/linux/pci.h     |    1 +
 4 files changed, 127 insertions(+), 65 deletions(-)

-- 
1.7.7

