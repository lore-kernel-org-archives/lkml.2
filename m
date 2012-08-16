Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab2HPOqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:46:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917Ab2HPOqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:46:18 -0400
Date: Thu, 16 Aug 2012 16:45:56 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
        Matthew Wilcox <willy@linux.intel.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH 0/5] x86, MSI, AHCI: Support multiple MSIs
Message-ID: <cover.1345124063.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently multiple MSI mode is limited to a single vector per device (at
least on x86 and PPC). This series breathes life into pci_enable_msi_block()
and makes it possible to set interrupt affinity for multiple IRQs, similarly
to MSI-X. Yet, only for x86 and only when IOMMUs are present.

Although IRQ and PCI subsystems are modified, the current behaviour left
intact. The drivers could just start using multiple MSIs just by following
the existing documentation.

The AHCI device driver makes use of the new mode and a new function -
pci_enable_msi_block_auto() - patches 4,5.

The series is adapted to Ingo's -tip repository, x86/apic branch.
Patches 4,5 could be applied independently of patches 1-3.

Attached patches:
  1/5 x86, MSI: Support multiple MSIs in presense of IRQ remapping
  2/5 x86, MSI: Allocate as many multiple IRQs as requested
  3/5 x86, MSI: Minor readability fixes
  4/5 PCI, MSI: Enable multiple MSIs with pci_enable_msi_block_auto()
  5/5 AHCI: Support multiple MSIs

 Documentation/PCI/MSI-HOWTO.txt |   41 ++++++++-
 arch/x86/kernel/apic/io_apic.c  |  170 ++++++++++++++++++++++++++++++++++++---
 drivers/ata/ahci.c              |   11 +--
 drivers/ata/ahci.h              |    1 +
 drivers/ata/libahci.c           |   24 ++++++
 drivers/ata/libata-core.c       |   66 +++++++++++++++
 drivers/pci/msi.c               |   39 +++++++++-
 include/linux/irq.h             |    6 ++
 include/linux/libata.h          |    3 +
 include/linux/msi.h             |    1 +
 include/linux/pci.h             |    7 ++
 kernel/irq/chip.c               |   30 +++++--
 kernel/irq/irqdesc.c            |   31 +++++++
 13 files changed, 397 insertions(+), 33 deletions(-)

-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
