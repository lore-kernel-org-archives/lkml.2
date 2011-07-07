Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab1GGIyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 04:54:11 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:5682 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab1GGIyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 04:54:06 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zz936eK4015Lzz1202hzz15d4R8275dhz32i668h839h944h64h)
X-Spam-TCS-SCL: 3:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LNYGQ1-02-8IB-02
X-M-MSG: 
Date: Thu, 7 Jul 2011 10:53:59 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: <linux-kernel@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>,
        <iommu@lists.linux-foundation.org>
Subject: [git pull] IOMMU updates for 3.1
Message-ID: <20110707085359.GC1956@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following changes since commit 56299378726d5f2ba8d3c8cbbd13cb280ba45e4f:

  Linux 3.0-rc4 (2011-06-20 20:25:46 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git iommu-3.1

Joerg Roedel (13):
      x86/amd-iommu: Remove redundant device_flush_dte() calls
      x86/amd-iommu: Introduce global dev_data_list
      x86/amd-iommu: Store devid in dev_data
      x86/amd-iommu: Store ATS state in dev_data
      x86/amd-iommu: Use only dev_data for dte and iotlb flushing routines
      x86/amd-iommu: Use only dev_data in low-level domain attach/detach functions
      x86/amd-iommu: Allow dev_data->alias to be NULL
      x86/amd-iommu: Search for existind dev_data before allocting a new one
      x86/amd-iommu: Store device alias as dev_data pointer
      iommu: Move iommu Kconfig entries to submenu
      iommu/amd: Move missing parts to drivers/iommu
      Merge branches 'amd/transparent-bridge' and 'core'
      iommu/amd: Don't use MSI address range for DMA addresses

Laura Abbott (1):
      iommu-api: Add missing header file

Ohad Ben-Cohen (4):
      drivers: iommu: move to a dedicated folder
      msm: iommu: move to drivers/iommu/
      x86: amd_iommu: move to drivers/iommu/
      x86/ia64: intel-iommu: move to drivers/iommu/

 arch/arm/mach-msm/Kconfig                          |   19 --
 arch/arm/mach-msm/Makefile                         |    2 +-
 arch/ia64/Kconfig                                  |   24 --
 arch/x86/Kconfig                                   |   79 -----
 arch/x86/kernel/Makefile                           |    1 -
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    1 +
 drivers/base/Makefile                              |    1 -
 drivers/iommu/Kconfig                              |  110 +++++++
 drivers/iommu/Makefile                             |    5 +
 {arch/x86/kernel => drivers/iommu}/amd_iommu.c     |  314 ++++++++++++--------
 .../x86/kernel => drivers/iommu}/amd_iommu_init.c  |    8 +-
 .../asm => drivers/iommu}/amd_iommu_proto.h        |    2 +-
 .../asm => drivers/iommu}/amd_iommu_types.h        |    9 +-
 drivers/{pci => iommu}/dmar.c                      |    0
 drivers/{pci => iommu}/intel-iommu.c               |    1 -
 drivers/{pci => iommu}/intr_remapping.c            |    1 -
 drivers/{pci => iommu}/intr_remapping.h            |    0
 drivers/{base => iommu}/iommu.c                    |    0
 drivers/{pci => iommu}/iova.c                      |    0
 .../mach-msm/iommu.c => drivers/iommu/msm_iommu.c  |    0
 .../iommu_dev.c => drivers/iommu/msm_iommu_dev.c   |    0
 drivers/pci/Makefile                               |    5 -
 drivers/pci/pci.h                                  |    2 -
 .../asm/amd_iommu.h => include/linux/amd-iommu.h   |    0
 include/linux/iommu.h                              |    2 +
 include/linux/pci.h                                |   11 +
 27 files changed, 332 insertions(+), 267 deletions(-)
 create mode 100644 drivers/iommu/Kconfig
 create mode 100644 drivers/iommu/Makefile
 rename {arch/x86/kernel => drivers/iommu}/amd_iommu.c (91%)
 rename {arch/x86/kernel => drivers/iommu}/amd_iommu_init.c (99%)
 rename {arch/x86/include/asm => drivers/iommu}/amd_iommu_proto.h (98%)
 rename {arch/x86/include/asm => drivers/iommu}/amd_iommu_types.h (98%)
 rename drivers/{pci => iommu}/dmar.c (100%)
 rename drivers/{pci => iommu}/intel-iommu.c (99%)
 rename drivers/{pci => iommu}/intr_remapping.c (99%)
 rename drivers/{pci => iommu}/intr_remapping.h (100%)
 rename drivers/{base => iommu}/iommu.c (100%)
 rename drivers/{pci => iommu}/iova.c (100%)
 rename arch/arm/mach-msm/iommu.c => drivers/iommu/msm_iommu.c (100%)
 rename arch/arm/mach-msm/iommu_dev.c => drivers/iommu/msm_iommu_dev.c (100%)
 rename arch/x86/include/asm/amd_iommu.h => include/linux/amd-iommu.h (100%)

These changes move all iommu-api drivers to drivers/iommu/.
Additionally this tree mades the amd iommu driver able to handle
device-ids which are not present as a real device in the system.
Please pull.

Thanks,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

