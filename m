Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab0EKP4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:56:31 -0400
Received: from mail-va3.bigfish.com ([216.32.180.112]:57028 "EHLO
	mail78-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754084Ab0EKP42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:56:28 -0400
X-SpamScore: -23
X-BigFish: VPS-23(z21eWz936eM4015Lzz1202hzzz32i87h2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0L29ISV-01-164-02
X-M-MSG: 
Date: Tue, 11 May 2010 17:53:19 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] AMD IOMMU updates for 2.6.35
Message-ID: <20100511155319.GH22296@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following changes since commit b57f95a38233a2e73b679bea4a5453a1cc2a1cc9:

  Linux 2.6.34-rc7 (2010-05-09 18:36:28 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git amd-iommu/2.6.35

Joerg Roedel (12):
      iommu-api: Rename ->{un}map function pointers to ->{un}map_range
      iommu-api: Add iommu_map and iommu_unmap functions
      iommu-api: Add ->{un}map callbacks to iommu_ops
      VT-d: Change {un}map_range functions to implement {un}map interface
      kvm: Change kvm_iommu_map_pages to map large pages
      x86/amd-iommu: Make iommu_map_page and alloc_pte aware of page sizes
      x86/amd-iommu: Make iommu_unmap_page and fetch_pte aware of page sizes
      x86/amd-iommu: Make amd_iommu_iova_to_phys aware of multiple page sizes
      x86/amd-iommu: Implement ->{un}map callbacks for iommu-api
      iommu-api: Remove iommu_{un}map_range functions
      x86/amd-iommu: Add amd_iommu=off command line option
      Merge branch 'iommu/largepages' into amd-iommu/2.6.35

 Documentation/kernel-parameters.txt    |    2 +
 arch/x86/include/asm/amd_iommu_types.h |   34 ++++++
 arch/x86/kernel/amd_iommu.c            |  197 ++++++++++++++++++++------------
 arch/x86/kernel/amd_iommu_init.c       |    6 +
 drivers/base/iommu.c                   |   43 +++++---
 drivers/pci/intel-iommu.c              |   22 ++--
 include/linux/iommu.h                  |   24 ++--
 virt/kvm/iommu.c                       |  113 +++++++++++++++----
 8 files changed, 312 insertions(+), 129 deletions(-)

This pull request consists mostly of the patches for the IOMMU large
page support and the associated AMD IOMMU driver changes. The code also
touches KVM files. I asked Avi if it is ok if these changes go through
-tip and he is fine with that. Beside the largepage code it includes one
more patch which adds an amd_iommu=off command line parameter. Please
pull.

Thanks,
	Joerg


