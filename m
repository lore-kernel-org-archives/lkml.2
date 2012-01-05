Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171Ab2AER2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 12:28:34 -0500
Received: from 8bytes.org ([88.198.83.132]:37600 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449Ab2AER2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 12:28:32 -0500
Date: Thu, 5 Jan 2012 18:28:27 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [git pull] IOMMU updates for 3.3-rc1
Message-ID: <20120105172827.GA3809@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

The following changes since commit dc47ce90c3a822cd7c9e9339fe4d5f61dcb26b50:

  Linux 3.2-rc5 (2011-12-09 15:09:32 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git next

The most important changes for this merge window in the IOMMU tree are:

	* Generic support for multiple page-sizes. The iommu-layer now
	  gets a bitmap from the iommu-driver about the supported
	  page-sizes and the generic code splits the map-requests
	  accordingly (by Ohad Ben-Cohen)
	* Device-group code, the iommu-drivers now export information
	  which devices the iommu hardware can safely isolate and which
	  not. Devices which can't be safely isolated with the hardware
	  belong to the same group. This will be used by the VFIO
	  driver (by Alex Williamson)
	* AMD IOMMU driver extensions to support the version 2 of
	  AMD IOMMU hardware. With hardware that can make use of it this
	  is a step towards demand-paging for device-dma (by me)
	* Other random fixes and improvements

You also find a few patches in this pull-request which are from the PCI
tree. I pulled in the patches into the x86/amd branch from the
pri-changes branch kindly provided by Jesse Barnes. The patches in this
branch should also be in the PCI tree. I had to do this because patches
in the PCI tree renamed some constants I use in my new code. Doing it
this way makes sure that everything still compiles when this tree is
pulled.

The top-commit of the next branch on my local machine is

	f4e8a3c5e33972dc78f042f9e839b33e213325d0

When I did a test-pull of the branch against v3.2 there was a conflict
in drivers/pci/hotplug/acpiphp_glue.c (due to the changes I pulled in
=66rom the PCI tree). Please let me know in case you want me to fix that.

Thanks,

	Joerg

Alex Williamson (7):
      iommu: Add iommu_device_group callback and iommu_group sysfs entry
      iommu/intel: Implement iommu_device_group
      iommu/amd: Implement iommu_device_group
      iommu: Add option to group multi-function devices
      PCI: Fix PRI and PASID consistency
      PCI: Enable is not exposed as a PASID capability
      PCI: More PRI/PASID cleanup

Eric W. Biederman (1):
      PCI: msi: Disable msi interrupts when we initialize a pci device

Joerg Roedel (32):
      iommu: Fix compile error with !IOMMU_API
      Merge branch 'for-joerg' of git://git.kernel.org/.../ohad/linux into =
arm/omap
      iommu/amd: Convert dev_table_entry to u64
      iommu/amd: Get the maximum number of PASIDs supported
      iommu/amd: Setup PPR log when supported by IOMMU
      iommu/amd: Enable GT mode when supported by IOMMU
      iommu/amd: Add iommuv2 flag to struct amd_iommu
      iommu/amd: Put IOMMUv2 capable devices in pt_domain
      iommu/amd: Implement notifier for PPR faults
      iommu/amd: Add amd_iommu_domain_direct_map function
      iommu/amd: Add support for IOMMUv2 domain mode
      iommu/amd: Implement IOMMUv2 TLB flushing routines
      iommu/amd: Implement functions to manage GCR3 table
      iommu/amd: Implement function to send PPR completions
      iommu/amd: Add function to get IOMMUv2 domain for pdev
      iommu/amd: Add device errata handling
      iommu/amd: Add stat counter for IOMMUv2 events
      iommu/amd: Add driver stub for AMD IOMMUv2 support
      iommu/amd: Implement device aquisition code for IOMMUv2
      iommu/amd: Add routines to bind/unbind a pasid
      iommu/amd: Implement IO page-fault handler
      iommu/amd: Implement notifiers for IOMMUv2
      iommu/amd: Add invalid_ppr callback
      Merge branch 'iommu/page-sizes' into x86/amd
      Merge remote-tracking branch 'pci/pri-changes' into x86/amd
      iommu/amd: Adapt IOMMU driver to PCI register name changes
      iommu/amd: Add amd_iommu_device_info() function
      iommu/amd: Add invalidate-context call-back
      iommu/amd: Remove unnecessary cache flushes in amd_iommu_resume
      iommu/amd: Init stats for iommu=3Dpt
      iommu/amd: Set IOTLB invalidation timeout
      Merge branches 'iommu/fixes', 'arm/omap', 'x86/amd', 'iommu/page-size=
s' and 'iommu/group-id' into next

Kenji Kaneshige (2):
      PCI: pciehp: Fix wrong workqueue cleanup
      PCI: pciehp: Handle push button event asynchronously

KyongHo Cho (1):
      iommu: Initialize domain->handler in iommu_domain_alloc()

Matthew Garrett (1):
      PCI: Rework ASPM disable code

Neil Horman (1):
      PCI/sysfs: add per pci device msi[x] irq listing (v5)

Ohad Ben-Cohen (11):
      iommu/core: stop converting bytes to page order back and forth
      iommu/core: split mapping to page sizes as supported by the hardware
      iommu/omap: announce supported page sizes
      iommu/msm: announce supported page sizes
      iommu/amd: announce supported page sizes
      iommu/intel: announce supported page sizes
      iommu/core: remove the temporary pgsize settings
      ARM: OMAP: iommu: declare a private iommu binding struct
      ARM: OMAP3: bind omap3isp_device to its iommu device
      iommu/omap: eliminate the public omap_find_iommu_device() method
      iommu/omap: be verbose when omap_iommu_iova_to_phys fails

Rafael J. Wysocki (2):
      PCI/ACPI: Make acpiphp ignore root bridges using SHPC native hotplug
      PCI/ACPI/PM: Avoid resuming devices that don't signal PME

 Documentation/ABI/testing/sysfs-bus-pci |   18 +
 Documentation/kernel-parameters.txt     |    9 +-
 arch/arm/mach-omap2/devices.c           |    7 +
 arch/arm/plat-omap/include/plat/iommu.h |   31 +-
 arch/arm/plat-omap/include/plat/iovmm.h |   12 +-
 arch/ia64/include/asm/iommu.h           |    2 +
 arch/ia64/kernel/pci-dma.c              |    1 +
 arch/x86/include/asm/iommu.h            |    1 +
 arch/x86/kernel/pci-dma.c               |   11 +
 drivers/acpi/pci_root.c                 |    7 +
 drivers/iommu/Kconfig                   |   13 +-
 drivers/iommu/Makefile                  |    1 +
 drivers/iommu/amd_iommu.c               |  883 ++++++++++++++++++++++++++--
 drivers/iommu/amd_iommu_init.c          |  133 ++++-
 drivers/iommu/amd_iommu_proto.h         |   24 +
 drivers/iommu/amd_iommu_types.h         |  118 ++++-
 drivers/iommu/amd_iommu_v2.c            |  994 +++++++++++++++++++++++++++=
++++
 drivers/iommu/intel-iommu.c             |   79 +++-
 drivers/iommu/iommu.c                   |  179 ++++++-
 drivers/iommu/msm_iommu.c               |   25 +-
 drivers/iommu/omap-iommu.c              |   80 ++--
 drivers/iommu/omap-iovmm.c              |   48 +-
 drivers/media/video/omap3isp/isp.c      |   30 +-
 drivers/media/video/omap3isp/isp.h      |    2 -
 drivers/media/video/omap3isp/ispccdc.c  |   18 +-
 drivers/media/video/omap3isp/ispstat.c  |    8 +-
 drivers/media/video/omap3isp/ispvideo.c |    4 +-
 drivers/pci/ats.c                       |   90 ++--
 drivers/pci/hotplug/acpiphp_glue.c      |    4 +-
 drivers/pci/hotplug/pciehp.h            |    1 -
 drivers/pci/hotplug/pciehp_core.c       |   11 +-
 drivers/pci/hotplug/pciehp_ctrl.c       |    4 +-
 drivers/pci/hotplug/pciehp_hpc.c        |    1 -
 drivers/pci/msi.c                       |  121 ++++
 drivers/pci/pci-acpi.c                  |   13 +-
 drivers/pci/pcie/aspm.c                 |   58 ++-
 include/linux/acpi.h                    |    4 +
 include/linux/amd-iommu.h               |  138 +++++-
 include/linux/iommu.h                   |   33 +-
 include/linux/msi.h                     |    3 +
 include/linux/pci-aspm.h                |    4 +-
 include/linux/pci.h                     |    1 +
 include/linux/pci_regs.h                |   34 +-
 virt/kvm/iommu.c                        |    8 +-
 44 files changed, 2946 insertions(+), 320 deletions(-)
 create mode 100644 drivers/iommu/amd_iommu_v2.c


--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPBd27AAoJECvwRC2XARrjZAQP/if+BK5+ckNcCsaVmYNzQWWO
O3Nrnw0SGOexEzftr/rUfw7wFHe/jcVZ/hmr1d5gO9Fsm3GQP9DlsTufd+YXdK9W
IHAb2gKCkYEBTnmcItJkkLjOz7dq8eglbrmKQi33LlP4nACO2OXZ8dYrlPFLo4JS
64EGAo8WXf3juTQmsAX94VUebfPb+4avk0hzcw/Xhg0IlpswXeyTxiugriYV/ExL
8a1HkXWM5qciiPRkBd+BoJBOy4CBkIfle5SHMyE9Kd9GHztGD69nOvXFmpYBaIrN
SarokvvrImSF22MQ/WRJEcTFCt9rvvTspHwUSNOPiamBSJSFTGkCNEzo02sVTuUk
DHrj6qwzD5dfWP2Zn2kVdG8++Sztv9Cu0tdChS2c7y7Gt5Ai968tWw5ohb/O5zkf
9wp29zi7YY6jKFKgE4Og213ornzunBZNbJS0VXrRLKN5P6F1SXMjOWHUPYfMJPGO
2tofNCCbQg2UvNO1e0mUqX+keRmkntw0WWlFwlM6jZJPGBJpkv8kqy/T3umW08iD
N76NtmslLx2V3dxTfJpjEO6J0i0SDR45c/8gzsBUTJb1A3pZWb7VsI5gh2oORxCY
+vf5eQNEhmcu12bv5/EzB1+nIu6KqoOM0QEEMgcZ9lzEGxwy02wLO0N3mBCwRjq3
+9jZL0ru6EJyqXwt2weT
=OjEu
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
