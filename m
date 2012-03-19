Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab2CSFlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:41:12 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:26712 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab2CSFlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:41:09 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 00/11] PCI: pci_host_bridge related cleanup
Date: Sun, 18 Mar 2012 22:40:13 -0700
Message-Id: <1332135624-13528-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4F66C6F0.00BA,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

will add struct device dev into host_bridge struct.
also will add release support to make sure allocated resource get
freed during root bus removal including hostbridge and pci_sysdata.

The patches need to apply to linus v3.3 plus pci/linux-next

could get from
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-hostbridge-cleanup

-v2: dropped the patch that is with x86 pcibios_bus_to_resource that Bjorn objected.
     reorder the patchesset to mold one appended patch into previous patch.
-v3: separate the patchset.

Thanks

Yinghai

Yinghai Lu (11):
  PCI: Separate host_bridge code out from probe.c
  x86, PCI: Fix memleak with get_current_resources()
  PCI: Rename pci_host_bridge() to find_pci_root_bridge()
  PCI: Add generic device into pci_host_bridge struct
  PCI: Add host bridge release support
  x86, PCI: Break down get_current_resource()
  x86, PCI: Add host bridge resource release for _CRS path
  x86, PCI: Embed name into pci_root_info struct
  x86, PCI: Embed pci_sysdata into pci_root_info on acpi path
  x86, PCI: Allocate pci_root_info for not using _CRS path
  x86, PCI: Merge root info printing for not using _CRS path

 arch/x86/pci/acpi.c         |  116 +++++++++++++++++++++-------------
 arch/x86/pci/amd_bus.c      |   78 +++++++----------------
 arch/x86/pci/broadcom_bus.c |   17 +----
 arch/x86/pci/bus_numa.c     |   86 +++++++++++++++++++-------
 arch/x86/pci/bus_numa.h     |   19 +++---
 drivers/pci/Makefile        |    2 +-
 drivers/pci/host-bridge.c   |   96 ++++++++++++++++++++++++++++
 drivers/pci/probe.c         |  146 +++++++++++--------------------------------
 include/linux/pci.h         |    9 +++-
 9 files changed, 313 insertions(+), 256 deletions(-)
 create mode 100644 drivers/pci/host-bridge.c

-- 
1.7.7

