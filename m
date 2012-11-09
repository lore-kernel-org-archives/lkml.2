Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab2KIRrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:47:46 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58348 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab2KIRrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:47:42 -0500
MIME-Version: 1.0
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 9 Nov 2012 10:47:20 -0700
Message-ID: <CAErSpo4Wjh1t68W5z9a0iC0hJcEeGhJ7CKrEL42iZQJksboaOQ@mail.gmail.com>
Subject: [GIT PULL] PCI updates for v3.7
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are some fixes for v3.7.  Three are related to D3cold support,
and the last portdrv one is a fix for the PCIe capability accessor
rework we merged for v3.7-rc1.

Bjorn


The following changes since commit 8f0d8163b50e01f398b14bcd4dc039ac5ab18d64:

  Linux 3.7-rc3 (2012-10-28 12:24:48 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git
tags/3.7-pci-fixes

for you to fetch changes up to ff8e59bc4ec3f31789a47dce9b6fe44bd7bc5fcc:

  PCI/portdrv: Don't create hotplug slots unless port supports hotplug
(2012-11-05 16:59:59 -0700)

----------------------------------------------------------------
PCI updates for v3.7:

  Power management
      PCI/PM: Fix proc config reg access for D3cold and bridge suspending
      PCI/PM: Resume device before shutdown
      PCI/PM: Fix deadlock when unbinding device if parent in D3cold
  Hotplug
      PCI/portdrv: Don't create hotplug slots unless port supports hotplug

----------------------------------------------------------------
Bjorn Helgaas (1):
      Merge branch 'pci/huang-d3cold-fixes' into for-linus

Huang Ying (3):
      PCI/PM: Fix deadlock when unbinding device if parent in D3cold
      PCI/PM: Resume device before shutdown
      PCI/PM: Fix proc config reg access for D3cold and bridge suspending

Taku Izumi (1):
      PCI/portdrv: Don't create hotplug slots unless port supports hotplug

 drivers/pci/bus.c                  |  3 ---
 drivers/pci/pci-driver.c           | 12 ++----------
 drivers/pci/pci-sysfs.c            | 34 ----------------------------------
 drivers/pci/pci.c                  | 32 ++++++++++++++++++++++++++++++++
 drivers/pci/pci.h                  |  2 ++
 drivers/pci/pcie/aer/aerdrv_core.c | 20 ++++++++++++++++----
 drivers/pci/pcie/portdrv_core.c    |  3 ++-
 drivers/pci/proc.c                 |  8 ++++++++
 8 files changed, 62 insertions(+), 52 deletions(-)
