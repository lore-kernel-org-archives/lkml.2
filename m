Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab1HXGYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 02:24:35 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52532 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab1HXGYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 02:24:32 -0400
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: jbarnes@virtuousgeek.org, ralf@linux-mips.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, eyal@mips.com, zenon@mips.com,
        dengcheng.zhu@gmail.com
Subject: [RFC PATCH 0/3] Pass resources to pci_create_bus() and fix MIPS PCI resources
Date: Wed, 24 Aug 2011 14:24:20 +0800
Message-Id: <1314167063-15785-1-git-send-email-dengcheng.zhu@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For MIPS PCI, use the resources-list style to set up root resources rather than
filling in pci_bus->resource[] array directly. This will hide some ugly
implementation details.

In addition, change the pci_create_bus() interface to pass in available
resources to get them settled down early. This is to avoid possible resource
conflicts while doing pci_scan_slot() in pci_scan_child_bus(). Note that
pcibios_fixup_bus() can get rid of such conflicts, but it's done AFTER scanning
slots.

Deng-Cheng Zhu (3):
  MIPS: PCI: Use pci_bus_remove_resources()/pci_bus_add_resource() to
    set up root resources
  PCI: Pass available resources into pci_create_bus()
  MIPS: PCI: Pass controller's resources to pci_create_bus() in
    pcibios_scanbus()

 arch/microblaze/pci/pci-common.c |    3 +-
 arch/mips/pci/pci.c              |   49 +++++++++++++++++++++++++++++++++++--
 arch/powerpc/kernel/pci-common.c |    3 +-
 arch/sparc/kernel/pci.c          |    3 +-
 arch/x86/pci/acpi.c              |    2 +-
 drivers/pci/probe.c              |   15 ++++++++---
 include/linux/pci.h              |    3 +-
 7 files changed, 66 insertions(+), 12 deletions(-)

