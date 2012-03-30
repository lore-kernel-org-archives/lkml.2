Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760973Ab2C3SqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 14:46:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:44484 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756782Ab2C3SqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 14:46:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="135792267"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 00/10] vt-d irq_remap_ops patchset
Date: Fri, 30 Mar 2012 11:46:58 -0700
Message-Id: <1333133228-3134-1-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Here is the Joerg's irq_remap_ops patchset updated for the latest -tip.
Simplified some of the naming conventions to follow the irq_remapping
terminology. There are still some "if (irq_remapping_enabled)" checks in
io_apic.c that I would like to roll into the new io_apic_ops. I will
look into that shortly.

Joerg Roedel (8):
  iommu: Rename intr_remapping files to intel_intr_remapping
  iommu/vt-d: Make intr-remapping initialization generic
  iommu/vt-d: Convert missing apic.c intr-remapping call to remap_ops
  iommu/vt-d: Convert IR ioapic-setup to use remap_ops
  iommu/vt-d: Convert IR set_affinity function to remap_ops
  iommu/vt-d: Convert free_irte into a remap_ops callback
  iommu/vt-d: Convert MSI remapping setup to remap_ops
  x86, iommu/vt-d: Clean up interfaces for interrupt remapping

Suresh Siddha (2):
  iommu: rename intr_remapping references to irq_remapping
  iommu: rename intr_remapping.[ch] to irq_remapping.[ch]

 arch/ia64/include/asm/irq_remapping.h              |    4 +
 arch/x86/include/asm/irq_remapping.h               |  120 +++++--
 arch/x86/kernel/apic/apic.c                        |   30 +-
 arch/x86/kernel/apic/io_apic.c                     |  297 ++++-------------
 drivers/iommu/Makefile                             |    2 +-
 drivers/iommu/dmar.c                               |    9 +-
 drivers/iommu/intel-iommu.c                        |    3 +-
 .../{intr_remapping.c => intel_irq_remapping.c}    |  355 ++++++++++++++++----
 drivers/iommu/intr_remapping.h                     |   17 -
 drivers/iommu/irq_remapping.c                      |  164 +++++++++
 drivers/iommu/irq_remapping.h                      |   88 +++++
 include/linux/dmar.h                               |   85 -----
 12 files changed, 724 insertions(+), 450 deletions(-)
 create mode 100644 arch/ia64/include/asm/irq_remapping.h
 rename drivers/iommu/{intr_remapping.c => intel_irq_remapping.c} (66%)
 delete mode 100644 drivers/iommu/intr_remapping.h
 create mode 100644 drivers/iommu/irq_remapping.c
 create mode 100644 drivers/iommu/irq_remapping.h

-- 
1.7.6.5

