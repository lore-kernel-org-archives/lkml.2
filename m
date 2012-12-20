Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab2LTQjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 11:39:25 -0500
Received: from 8bytes.org ([85.214.48.195]:39381 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab2LTQjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 11:39:20 -0500
Date: Thu, 20 Dec 2012 17:39:15 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU Updates for v3.8
Message-ID: <20121220163915.GB2522@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Dec 20 17:39:17 2012
X-DSPAM-Confidence: 0.9990
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50d33f3522971063116727
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

(Somehow my first mail was lost, at least I can't find it on LKML or the
 IOMMU list, so here it is again)

Hi Linus,

The following changes since commit 29594404d7fe73cd80eaa4ee8c43dcc53970c60e:

  Linux 3.7 (2012-12-10 19:30:57 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/iommu-updates-v3.8

for you to fetch changes up to 9c6ecf6a3ade2dc4b03a239af68058b22897af41:

  Merge branches 'iommu/fixes', 'dma-debug', 'x86/amd', 'x86/vt-d', 'arm/tegra' and 'arm/omap' into next (2012-12-16 12:24:09 +0100)

----------------------------------------------------------------

IOMMU Updates for Linux v3.8

A few new features this merge-window. The most important one is
probably, that dma-debug now warns if a dma-handle is not checked with
dma_mapping_error by the device driver. This requires minor changes to
some architectures which make use of dma-debug. Most of these changes
have the respective Acks by the Arch-Maintainers.
Besides that there are updates to the AMD IOMMU driver for refactor the
IOMMU-Groups support and to make sure it does not trigger a hardware
erratum.
The OMAP changes (for which I pulled in a branch from Tony Lindgren's
tree) have a conflict in linux-next with the arm-soc tree. The conflict
is in the file arch/arm/mach-omap2/clock44xx_data.c which is deleted in
the arm-soc tree. It is safe to delete the file too so solve the
conflict. Similar changes are done in the arm-soc tree in the common
clock framework migration. A missing hunk from the patch in the IOMMU
tree will be submitted as a seperate patch when the merge-window is
closed.

----------------------------------------------------------------
Alex Williamson (5):
      iommu/amd: Split IOMMU group initialization
      iommu/amd: Split IOMMU Group topology walk
      iommu/amd: Split upstream bus device lookup
      iommu/amd: Split IOMMU group allocation and attach
      iommu/amd: Properly account for virtual aliases in IOMMU groups

Hiroshi Doyu (3):
      iommu/tegra: smmu: Remove unnecessary PTC/TLB flush all
      iommu/tegra: gart: Move bus_set_iommu after probe for multi arch
      iommu/tegra: smmu: Move bus_set_iommu after probe for multi arch

Ido Yariv (3):
      ARM: OMAP: Merge iommu2.h into iommu.h
      ARM: OMAP2+: Move iopgtable header to drivers/iommu/
      ARM: OMAP2+: Make some definitions local

Joerg Roedel (4):
      iommu/amd: Don't use 512GB pages
      iommu/amd: Remove obsolete comment
      Merge branch 'omap-for-v3.8/cleanup-headers-iommu' of git://git.kernel.org/.../tmlind/linux-omap into arm/omap
      Merge branches 'iommu/fixes', 'dma-debug', 'x86/amd', 'x86/vt-d', 'arm/tegra' and 'arm/omap' into next

Ming Lei (1):
      ARM: dma-mapping: support debug_dma_mapping_error

Omar Ramirez Luna (5):
      iommu/omap: Remove redundant clock handling on ISR
      iommu/omap: Keep mmu enabled when requested
      iommu/omap: Migrate to hwmod framework
      iommu/omap: Adapt to runtime pm
      ARM: OMAP4: hwmod data: ipu and dsp to use parent clocks instead of leaf clocks

Shuah Khan (12):
      dma-debug: New interfaces to debug dma mapping errors
      Documentation DMA-API-HOWTO.txt Add dma mapping error check usage examples
      dma-debug: fix to not have dependency on get_dma_ops() interface
      sparc: dma-mapping: support debug_dma_mapping_error
      ARM64: dma_debug: add debug_dma_mapping_error support
      c6x: dma_debug: add debug_dma_mapping_error support
      ia64: dma_debug: add debug_dma_mapping_error support
      microblaze: dma-mapping: support debug_dma_mapping_error
      mips: dma_debug: add debug_dma_mapping_error support
      powerpc: dma_debug: add debug_dma_mapping_error support
      sh: dma_debug: add debug_dma_mapping_error support
      tile: dma_debug: add debug_dma_mapping_error support

Tom Mingarelli (1):
      intel-iommu: Prevent devices with RMRRs from being placed into SI Domain

Tony Lindgren (3):
      ARM: OMAP2+: Move plat/iovmm.h to include/linux/omap-iommu.h
      ARM: OMAP2+: Move iommu2 to drivers/iommu/omap-iommu2.c
      ARM: OMAP2+: Move iommu/iovmm headers to platform_data

 Documentation/DMA-API-HOWTO.txt                    |  126 +++++++++++++
 Documentation/DMA-API.txt                          |   12 ++
 arch/arm/include/asm/dma-mapping.h                 |    1 +
 arch/arm/mach-omap2/Makefile                       |    2 -
 arch/arm/mach-omap2/clock44xx_data.c               |   22 ---
 arch/arm/mach-omap2/devices.c                      |    4 +-
 arch/arm/mach-omap2/omap-iommu.c                   |  169 ++++-------------
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |    2 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |    6 +-
 arch/arm/plat-omap/include/plat/iommu2.h           |   96 ----------
 arch/arm/plat-omap/include/plat/iovmm.h            |   89 ---------
 arch/arm64/include/asm/dma-mapping.h               |    1 +
 arch/c6x/include/asm/dma-mapping.h                 |    1 +
 arch/ia64/include/asm/dma-mapping.h                |    1 +
 arch/microblaze/include/asm/dma-mapping.h          |    2 +
 arch/mips/include/asm/dma-mapping.h                |    2 +
 arch/powerpc/include/asm/dma-mapping.h             |    1 +
 arch/sh/include/asm/dma-mapping.h                  |    1 +
 arch/sparc/include/asm/dma-mapping.h               |    1 +
 arch/tile/include/asm/dma-mapping.h                |    1 +
 arch/x86/include/asm/dma-mapping.h                 |    1 +
 drivers/iommu/Makefile                             |    1 +
 drivers/iommu/amd_iommu.c                          |  196 ++++++++++++++------
 drivers/iommu/amd_iommu_types.h                    |    1 +
 drivers/iommu/intel-iommu.c                        |   31 ++++
 drivers/iommu/omap-iommu-debug.c                   |    8 +-
 drivers/iommu/omap-iommu.c                         |  107 +++++++----
 .../plat/iommu.h => drivers/iommu/omap-iommu.h     |  132 ++++++-------
 .../iommu2.c => drivers/iommu/omap-iommu2.c        |   47 +----
 .../iopgtable.h => drivers/iommu/omap-iopgtable.h  |   22 ---
 drivers/iommu/omap-iovmm.c                         |   50 ++++-
 drivers/iommu/tegra-gart.c                         |    2 +-
 drivers/iommu/tegra-smmu.c                         |    6 +-
 drivers/media/platform/omap3isp/isp.c              |    1 +
 drivers/media/platform/omap3isp/isp.h              |    4 +-
 drivers/media/platform/omap3isp/ispccdc.c          |    1 +
 drivers/media/platform/omap3isp/ispstat.c          |    1 +
 drivers/media/platform/omap3isp/ispvideo.c         |    3 +-
 include/linux/dma-debug.h                          |    7 +
 include/linux/omap-iommu.h                         |   52 ++++++
 include/linux/platform_data/iommu-omap.h           |   54 ++++++
 lib/dma-debug.c                                    |   66 ++++++-
 42 files changed, 752 insertions(+), 581 deletions(-)
 delete mode 100644 arch/arm/plat-omap/include/plat/iommu2.h
 delete mode 100644 arch/arm/plat-omap/include/plat/iovmm.h
 rename arch/arm/plat-omap/include/plat/iommu.h => drivers/iommu/omap-iommu.h (70%)
 rename arch/arm/mach-omap2/iommu2.c => drivers/iommu/omap-iommu2.c (88%)
 rename arch/arm/plat-omap/include/plat/iopgtable.h => drivers/iommu/omap-iopgtable.h (85%)
 create mode 100644 include/linux/omap-iommu.h
 create mode 100644 include/linux/platform_data/iommu-omap.h

Please pull.

Regards,

	Joerg


--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQ0z8zAAoJECvwRC2XARrjtI8QAKn3p6gifF/Yl4c8+KZQSwrv
z+9XgwuVsdbgRv3LeCGMvKabF3MR2V2F7mi3JtrYIrMTmwvrSnjHaCOC5uTTokhb
EocU1cgWzU2ejJ7eAW7GbanQCzVPLLARiUrAFFfYI2ZYax/Nj52gAx72BJXQip18
z3FeVxVqxrTioE/VQocFPJc+pC6iz0t2e58vefb2If3FvKnrIYYsZVu5j+j1lajY
tUEqHthk2dYPw9izbvVTrnUG8UqtPjg0BR7rCz/7zB6S9ceLN3DfZQlGZQwrCwwz
YR1a1ZCQKb2IVsHAorUr4i9Li5uvdcNIozImkdkCPQSuxPMJsom292kuWBk3Xr/U
CH4Nu9mj6Ecd4UZ+uxKzlkBv8RwnwVVxQoiB7/q5YJNchD9QAh3veYNqDIIbpAC4
fcwKbTQWbXmATnZmBmIht7kPjdtbeiTiStdK8C+T1tl2jM81W9qKWvr/dItrih2T
aFRX3GeY9wrlxE4aABxICmnLfCBrjIzZScpx/AlN3yj4IrHhm92yx1q/o6rqjvhO
xdCX2qcT2amsXHcuaavjc/MXwCActXNu4WETzltxKZOBkFBpGbAM7vCiRS9FgpW+
TEKwKx52Bb05zzxVnMxVVQZFaVMyr/+jDcX3lo3sl5PcM95S+/Ki0IJz0/jneWN1
nZG5LJxD9YHyLwWB/MMz
=q140
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--


