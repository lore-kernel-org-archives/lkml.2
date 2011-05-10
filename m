Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab1EJQgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 12:36:19 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:8529 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab1EJQgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 12:36:18 -0400
X-SpamScore: -17
X-BigFish: VPS-17(z21eRz1803M936eKzz1202hzz8275dhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LKZNGB-01-4JG-02
X-M-MSG: 
Date: Tue, 10 May 2011 18:36:23 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: [git pull] (AMD mostly) IOMMU updates for 2.6.40
Message-ID: <20110510163623.GI30996@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following changes since commit 693d92a1bbc9e42681c42ed190bd42b636ca876f:

  Linux 2.6.39-rc7 (2011-05-09 19:33:54 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu/2.6.40

Joe Perches (1):
      arch/x86/kernel/pci-iommu_table.c: Convert sprintf_symbol to %pS

Joerg Roedel (18):
      x86/amd-iommu: Move compl-wait command building to own function
      x86/amd-iommu: Move inv-dte command building to own function
      x86/amd-iommu: Cleanup inv_pages command handling
      x86/amd-iommu: Cleanup completion-wait handling
      x86/amd-iommu: Remove command buffer resetting logic
      x86/amd-iommu: Rename iommu_flush* to domain_flush*
      x86/amd-iommu: Improve handling of full command buffer
      x86/amd-iommu: Rename iommu_flush_device
      x86/amd-iommu: Flush all internal TLBs when IOMMUs are enabled
      PCI: Move ATS declarations in seperate header file
      x86/amd-iommu: Select PCI_IOV with AMD IOMMU driver
      x86/amd-iommu: Flush device IOTLB if ATS is enabled
      x86/amd-iommu: Add flag to indicate IOTLB support
      x86/amd-iommu: Add ATS enable/disable code
      x86/amd-iommu: Add extended feature detection
      x86/amd-iommu: Add support for invalidate_all command
      Merge branches 'dma-debug/next', 'amd-iommu/command-cleanups', 'amd-iommu/ats' and 'amd-iommu/extended-features' into iommu/2.6.40
      x86/amd-iommu: Use threaded interupt handler

Stanislaw Gruszka (1):
      dma-debug: print information about leaked entry

 arch/x86/Kconfig                       |    1 +
 arch/x86/include/asm/amd_iommu_proto.h |   13 +-
 arch/x86/include/asm/amd_iommu_types.h |   28 ++-
 arch/x86/kernel/amd_iommu.c            |  526 +++++++++++++++++++-------------
 arch/x86/kernel/amd_iommu_init.c       |   48 +++-
 arch/x86/kernel/pci-iommu_table.c      |   18 +-
 drivers/pci/intel-iommu.c              |    1 +
 drivers/pci/iov.c                      |    1 +
 drivers/pci/pci.h                      |   37 ---
 include/linux/pci-ats.h                |   52 ++++
 lib/dma-debug.c                        |   18 +-
 11 files changed, 454 insertions(+), 289 deletions(-)
 create mode 100644 include/linux/pci-ats.h

Most changes are AMD IOMMU related. The other ones I picked up and
included here. The AMD IOMMU changes implement ATS support into the
driver, rework the command handling code and start the implementation
of upcoming AMD IOMMU features. The PCI changes included here make the
ATS functions available to the AMD IOMMU driver and are ACKed by
Jesse Barnes. Please pull.

Regards,

	Joerg


