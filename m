Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933997Ab1J3L5l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 07:57:41 -0400
Received: from 8bytes.org ([88.198.83.132]:44035 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933965Ab1J3L5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 07:57:40 -0400
Date: Sun, 30 Oct 2011 12:57:37 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Ohad Ben-Cohen <ohad@wizery.com>, Joerg.Roedel@amd.com,
        Greg KH <greg@kroah.com>, David Woodhouse <dwmw2@infradead.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [git pull] IOMMU updates for 3.2
Message-ID: <20111030115736.GA2626@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 899e3ee404961a90b828ad527573aaaac39f0ab1:

  Linux 3.1-rc10 (2011-10-17 21:06:23 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git next

The most important changes I ask you to pull are:

* Move of the OMAP IOMMU driver to drivers/iommu for future
  code consolidation with other IOMMU drivers (by Ohad)
* Generic IO page-fault reporting added to the IOMMU-API (by Ohad,
  currently only supported by OMAP IOMMU, but others will follow soon)
* The iommu_ops are not global anymore but a property of the bus_type
  now. This is indirectly required by the upcoming VFIO driver developed
  by Alex Williamson for KVM. This change touches the Device driver core
  and is acked by Greg. This change also allows more consolidation in
  the per-device handling code across IOMMU drivers (by me)
* The dma-debugging code does not yell anymore on sub-range sync calls
  (by Neil)
* Various other fixes

The top-commit-id of the next branch on my local machine is

	1abb4ba596a91a839f82e0c9c837b777d574e83d

Please pull. Shortlog and diff-stat attached.

Arnd Bergmann (1):
      iommu/omap: always provide iommu debug code

Joerg Roedel (16):
      omap: iommu: Fix up mutex->spin_lock conversion of iommu_lock
      iommu/core: Use PAGE_SIZE instead of hard-coded value
      Merge branches 'debug/dma-api', 'arm/omap', 'arm/msm' and 'core' into api-2
      iommu/omap: Fix build error with !IOMMU_SUPPORT
      iommu/amd: Fix wrong shift direction
      iommu/core: Define iommu_ops and register_iommu only with CONFIG_IOMMU_API
      Driver core: Add iommu_ops to bus_type
      iommu/core: Add bus_type parameter to iommu_domain_alloc
      iommu/core: Convert iommu_found to iommu_present
      iommu/core: Use bus->iommu_ops in the iommu-api
      iommu/amd: Use bus_set_iommu instead of register_iommu
      iommu/vt-d: Use bus_set_iommu instead of register_iommu
      iommu/omap: Use bus_set_iommu instead of register_iommu
      iommu/msm: Use bus_set_iommu instead of register_iommu
      iommu/core: Remove global iommu_ops and register_iommu
      Merge branches 'amd/fixes', 'debug/dma-api', 'arm/omap', 'arm/msm', 'core', 'iommu/fault-reporting' and 'api/iommu-ops-per-bus' into next

Laurent Pinchart (1):
      iommu/omap-iovmm: support non page-aligned buffers in iommu_vmap

Neil Horman (1):
      dma-debug: hash_bucket_find needs to allow for offsets within an entry

Ohad Ben-Cohen (16):
      omap: iommu: migrate to the generic IOMMU API
      omap: iommu/iovmm: move to dedicated iommu folder
      omap: iommu: stop exporting local functions
      omap: iommu: PREFETCH_IOTLB cleanup
      omap: iovmm: remove unused functionality
      omap: iommu: remove unused exported API
      omap: iommu: omapify 'struct iommu' and exposed API
      iommu: omap: add Kconfig OMAP dependency
      iommu/omap: cleanup: remove a redundant statement
      iommu/omap: ->unmap() should return order of unmapped page
      iommu/msm: ->unmap() should return order of unmapped page
      iommu/core: use the existing IS_ALIGNED macro
      iommu/core: Add fault reporting mechanism
      iommu/omap: Migrate to the generic fault report mechanism
      iommu/core: export iommu_set_fault_handler()
      iommu/core: let drivers know if an iommu fault handler isn't installed

 arch/arm/mach-omap2/iommu2.c                       |   31 +-
 arch/arm/plat-omap/Kconfig                         |   12 -
 arch/arm/plat-omap/Makefile                        |    2 -
 arch/arm/plat-omap/include/plat/iommu.h            |   78 ++--
 arch/arm/plat-omap/include/plat/iommu2.h           |    4 +-
 arch/arm/plat-omap/{ => include/plat}/iopgtable.h  |   20 +-
 arch/arm/plat-omap/include/plat/iovmm.h            |   30 +-
 arch/ia64/kvm/kvm-ia64.c                           |    3 +-
 arch/x86/kvm/x86.c                                 |    3 +-
 drivers/iommu/Kconfig                              |   19 +
 drivers/iommu/Makefile                             |    3 +
 drivers/iommu/amd_iommu.c                          |    4 +-
 drivers/iommu/intel-iommu.c                        |    2 +-
 drivers/iommu/iommu.c                              |  114 ++++-
 drivers/iommu/msm_iommu.c                          |    9 +-
 .../iommu/omap-iommu-debug.c                       |   36 +-
 .../iommu.c => drivers/iommu/omap-iommu.c          |  529 +++++++++++++-------
 .../iovmm.c => drivers/iommu/omap-iovmm.c          |  370 ++++----------
 drivers/media/video/Kconfig                        |    3 +-
 drivers/media/video/omap3isp/isp.c                 |   45 ++-
 drivers/media/video/omap3isp/isp.h                 |    5 +-
 drivers/media/video/omap3isp/ispccdc.c             |   25 +-
 drivers/media/video/omap3isp/ispstat.c             |   11 +-
 drivers/media/video/omap3isp/ispvideo.c            |    4 +-
 include/linux/device.h                             |    6 +
 include/linux/iommu.h                              |   76 +++-
 lib/dma-debug.c                                    |   68 +++-
 virt/kvm/iommu.c                                   |    4 +-
 28 files changed, 869 insertions(+), 647 deletions(-)
 rename arch/arm/plat-omap/{ => include/plat}/iopgtable.h (82%)
 rename arch/arm/plat-omap/iommu-debug.c => drivers/iommu/omap-iommu-debug.c (91%)
 rename arch/arm/plat-omap/iommu.c => drivers/iommu/omap-iommu.c (61%)
 rename arch/arm/plat-omap/iovmm.c => drivers/iommu/omap-iovmm.c (62%)

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOrTuwAAoJECvwRC2XARrj3AIP/jIp1252MsTY80qhAvHnmUKx
lIoGyPUC3Z2T+QKTWe21MElkJP55t0hM/eIVSMCa2czijsf2UOpY8ReBHkVir0HL
hEpujUFx/gmWqmETJA7BovBWku4yr8IzZPKXQ8vtMw/qx/s0IkIlOIiTTgHxyOmr
S9S1peo1UCWpcAt5OVFG/FXegzXcgNYXlNp2pz+Vv8JhuvbPCZOBf50mUlDSfSJ0
fXNTCPKXUUcojVnkVM0tcObrDJI/y6ftMb5FXFtzvJlcfJwka5voe2fN0+PUnXCp
+BIRTHFhER0xDKLPFn5wDrq/D445NXjEXci1MJrgda5/zuCije3fMtQeim0AZsBf
SCRmCfQpk6gvbLYTEQKAUHO61MT/jQLGDLrw4Hb2TRh7SKG1HuuKNz3a7zNLagOS
sggac8xPI2jhfstEzbKUfkAwjHKeLgx7TE/lREweH4ay+5LSTmlralDZdebs4+DN
fr6zrw36Xaigs3GMPcnrXnYT95/mllwVxgIGst9JR5yMdkDwYZPsOBL+eAYyjKs5
9OqyTYjhzhPWM2Yt5WQY33Z6DCCC1QK35O99id9HfcyCvHbCK4IMoYz/CmOfQvYA
+KldkyqDvqNT8XItDx6seVGh5pNdS3Yr9RBH+yZeYaKYlywkQhQcGKH4UdXfZEEO
CwZUwHHEfilP4iHfX2Gl
=Y/Ig
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
