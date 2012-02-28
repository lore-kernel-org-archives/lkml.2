Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab2B1CEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 21:04:50 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:25636 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab2B1CEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 21:04:48 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 00/11] PCI: pci_host_bridge related cleanup
Date: Mon, 27 Feb 2012 18:03:40 -0800
Message-Id: <1330394631-28978-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020206.4F4C363D.0067,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

will add struct device dev into host_bridge struct.

also will add release support to make sure allocated resource get
freed during root bus removal.

The patches need to apply to pci/for-linus and pci/linux-next

because one patch that is needed only get into pci/for-linus only


could get from

        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-next


-v2: remove several null checking requested by Bjorn

64c033c: x86, PCI: Merge root info printing for nocrs path
690fe82: x86, PCI: Allocating pci_root_info for nocrs path
2f7ea95: x86, PCI: embed name acpi version pci_root_info struct
2f79741: x86, PCI: add host bridge resource release for using _CRS
698ed24: x86, PCI: break down get_current_resource()
5acc80e: PCI: add host bridge release support
6068c94: PCI: add generic device into pci_host_bridge struct
6d34e92: PCI: rename pci_host_bridge() to find_pci_root_bridge()
bd114df: x86, PCI: Fix memleak with get_current_resources
e92c582: x86, PCI: have own version for pcibios_bus_to_resource
56f109d: PCI: Separate host_bridge code out from probe.c


Thanks

Yinghai Lu

 arch/x86/pci/acpi.c         |  116 +++++++++++++++++++++++-----------
 arch/x86/pci/amd_bus.c      |   78 +++++++----------------
 arch/x86/pci/broadcom_bus.c |   14 +---
 arch/x86/pci/bus_numa.c     |   86 +++++++++++++++++++-------
 arch/x86/pci/bus_numa.h     |   19 +++---
 arch/x86/pci/i386.c         |   14 ++++
 drivers/pci/Makefile        |    2 +-
 drivers/pci/host-bridge.c   |   97 +++++++++++++++++++++++++++++
 drivers/pci/probe.c         |  145 ++++++++++--------------------------------
 include/linux/pci.h         |    9 +++-
 10 files changed, 334 insertions(+), 246 deletions(-)
 create mode 100644 drivers/pci/host-bridge.c

