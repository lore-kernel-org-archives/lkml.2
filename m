Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab2EGN6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 09:58:36 -0400
Received: from h2027444.stratoserver.net ([85.214.48.195]:35075 "EHLO
	h2027444.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571Ab2EGN6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 09:58:34 -0400
X-Greylist: delayed 494 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 May 2012 09:58:34 EDT
Date: Mon, 7 May 2012 15:50:18 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org
Subject: [git pull] irq remapping ops for x86
Message-ID: <20120507135018.GA16632@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon May  7 15:50:19 2012
X-DSPAM-Confidence: 0.9992
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4fa7d31b180751354330622
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following changes since commit d48b97b403d23f6df0b990cee652bdf9a52337a3:

  Linux 3.4-rc6 (2012-05-06 15:07:32 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git intr-remapping-ops

or as a signed tag at:
  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git intr-remapping-ops-for-ingo

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

This patchset introduces a generic ops-interface for
accessing interrupt remapping hardware on x86. It factors
out the VT-d specific code from io_apic.c and moves it to
drivers/iommu. These changes will be used to add support for
AMD interrupt remapping hardware.

Please pull.

Thanks,

	Joerg


