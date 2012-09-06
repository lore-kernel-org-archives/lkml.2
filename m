Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265Ab2IFViK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 17:38:10 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40745 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933187Ab2IFViH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 17:38:07 -0400
MIME-Version: 1.0
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 6 Sep 2012 15:37:45 -0600
Message-ID: <CAErSpo6i4LS7s+LULVyVcX8eAG8TnRpxqYnaqY4RVM7BBt24nw@mail.gmail.com>
Subject: [GIT PULL] PCI updates for v3.6
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are some more fixes for v3.6.  These all fix things we merged in
v3.6-rc1.  Four are fixes for the D3cold support, and one is for a
boot lockup on PA Semi caused by a printk while the console BAR is
still disabled.

Bjorn


The following changes since commit a6b881a5b8d4fa2135e55a74be6d6b1e17e445dd:

  Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu
(2012-08-21 10:08:39 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git
tags/3.6-pci-fixes

for you to fetch changes up to 0ff9514b579b4f2f3e6038cd961ce64c224c3c73:

  PCI: Don't print anything while decoding is disabled (2012-08-23
10:53:08 -0600)

----------------------------------------------------------------
PCI updates for v3.6:

  Power management
    - PCI/PM: Enable D3/D3cold by default for most devices
    - PCI/PM: Keep parent bridge active when probing device
    - PCI/PM: Fix config reg access for D3cold and bridge suspending
    - PCI/PM: Add ABI document for sysfs file d3cold_allowed
  Core
    - PCI: Don't print anything while decoding is disabled

----------------------------------------------------------------
Bjorn Helgaas (1):
      PCI: Don't print anything while decoding is disabled

Huang Ying (4):
      PCI/PM: Enable D3/D3cold by default for most devices
      PCI/PM: Keep parent bridge active when probing device
      PCI/PM: Fix config reg access for D3cold and bridge suspending
      PCI/PM: Add ABI document for sysfs file d3cold_allowed

 Documentation/ABI/testing/sysfs-bus-pci | 12 ++++++++++
 drivers/pci/pci-driver.c                |  6 +++++
 drivers/pci/pci-sysfs.c                 | 42 +++++++++++++++++++++++++++++++++
 drivers/pci/pci.c                       |  1 +
 drivers/pci/pcie/portdrv_pci.c          | 14 +++++++++++
 drivers/pci/probe.c                     | 31 +++++++++++++-----------
 6 files changed, 92 insertions(+), 14 deletions(-)
