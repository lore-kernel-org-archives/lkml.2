Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab1CRRaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 13:30:18 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:35133 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757074Ab1CRRaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 13:30:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=BRzphQnO5V3s/ex+U563opSfemnme74geNuNP1iMw9YHlvZBbHV0YRBgLmR2BfJZtThvTV404cPQqTgmtgz/NacRtQsrekdQ1QAGfLVXClOtDJukneM7AwS/N5RfciUY;
Date: Fri, 18 Mar 2011 10:30:04 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [git pull] PCI changes
Message-ID: <20110318103004.02d78fe7@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
100b33c8bd8a3235fd0b7948338d6cbb3db3c63d:

  Linux 2.6.38-rc4 (2011-02-07 16:03:55 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 linux-next

The only scary thing in here is Ram's patchset to adjust our resource
allocation policy.  The old policy was too biased in favor of hotplug;
his patches try to make sure we can allocate space for devices detected
at boot first, only making hotplug windows available if possible
afterwards.

A couple of last minute fixes for the ACPI _DSM patch landed this week
as well, but they're very low risk so I think that's ok.

Ben Hutchings (1):
      PCI: sysfs: Fix failure path for addition of "vpd" attribute

Brandeburg, Jesse (1):
      PCI: remove quirk for pre-production systems

Jesper Juhl (1):
      PCI: Avoid potential NULL pointer dereference in pci_scan_bridge

Jiri Slaby (2):
      PCI: add more checking to ICH region quirks
      PCI: do not create quirk I/O regions below PCIBIOS_MIN_IO for ICH

Narendra_K@Dell.com (2):
      PCI: Export ACPI _DSM provided firmware instance number and string name to sysfs
      PCI: label: Fix compilation error when CONFIG_ACPI is unset

Prarit Bhargava (1):
      PCI: aer-inject: Override PCIe AER Mask Registers

Ram Pai (4):
      PCI: refactor io size calculation code
      PCI: data structure agnostic free list function
      PCI: introduce reset_resource()
      PCI: pre-allocate additional resources to devices only after successful allocation of essential resources.

Randy Dunlap (1):
      PCI: fix tlan build when CONFIG_PCI is not enabled

Seth Heasley (1):
      PCI/lpc: irq and pci_ids patch for Intel DH89xxCC DeviceIDs

Shyam_Iyer@Dell.com (1):
      PCI: label: remove #include of ACPI header to avoid warnings

Stefano Stabellini (1):
      PCI hotplug: acpiphp: set current_state to D0 in register_slot

 Documentation/ABI/testing/sysfs-bus-pci |   31 +++-
 arch/x86/pci/irq.c                      |   15 +-
 drivers/pci/Kconfig                     |    2 +
 drivers/pci/Makefile                    |    3 +-
 drivers/pci/hotplug/acpiphp_glue.c      |    1 +
 drivers/pci/pci-label.c                 |  252 +++++++++++++++++++++++-
 drivers/pci/pci-sysfs.c                 |    2 +-
 drivers/pci/pci.h                       |    2 +-
 drivers/pci/pcie/aer/aer_inject.c       |   31 +++-
 drivers/pci/probe.c                     |    4 +-
 drivers/pci/quirks.c                    |  113 +++++------
 drivers/pci/setup-bus.c                 |  321 +++++++++++++++++++++++--------
 include/linux/pci.h                     |    5 +
 include/linux/pci_ids.h                 |    3 +
 14 files changed, 614 insertions(+), 171 deletions(-)


-- 
Jesse Barnes, Intel Open Source Technology Center
