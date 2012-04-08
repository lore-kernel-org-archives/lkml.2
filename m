Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab2DHRP0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 13:15:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38653 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab2DHRPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 13:15:24 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH RFC 0/2] PCI, x86: update MMCFG information when hot-plugging PCI host bridges
Date: Mon,  9 Apr 2012 01:12:07 +0800
Message-Id: <1333905129-8776-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <20120406115948.3536e6c8.izumi.taku@jp.fujitsu.com>
References: <20120406115948.3536e6c8.izumi.taku@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset enhance pci_root driver to update MMCFG information when
hot-plugging PCI root bridges. It applies to Yinghai's tree at
git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-root-bus-hotplug

The second patch is based on Taku Izumi work with some enhancements to
correctly handle PCI host bridges without _CBA method.

Jiang Liu (2):
  PCI,x86: introduce new MMCFG interfaces to support PCI host bridge
    hotplug
  PCI, ACPI, x86: update MMCFG information when hot-plugging PCI host
    bridges

 arch/x86/include/asm/pci_x86.h |    4 +
 arch/x86/pci/acpi.c            |   58 +++++++++++++
 arch/x86/pci/mmconfig-shared.c |  186 +++++++++++++++++++++++++++++++---------
 arch/x86/pci/mmconfig_32.c     |   28 ++++++-
 arch/x86/pci/mmconfig_64.c     |   35 +++++++-
 drivers/acpi/pci_root.c        |   20 +++++
 include/acpi/acnames.h         |    1 +
 include/linux/pci-acpi.h       |    3 +
 8 files changed, 288 insertions(+), 47 deletions(-)

-- 
1.7.5.4

