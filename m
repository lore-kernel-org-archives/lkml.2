Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab2JEPXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 11:23:21 -0400
Received: from 8bytes.org ([85.214.48.195]:55957 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617Ab2JEPXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 11:23:17 -0400
Date: Fri, 5 Oct 2012 17:23:12 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU Updates for v3.7-rc1
Message-ID: <20121005152312.GA4649@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Oct  5 17:23:13 2012
X-DSPAM-Confidence: 0.9989
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 506efb6122971976618682
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit a0d271cbfed1dd50278c6b06bead3d00ba0a88f9:

  Linux 3.6 (2012-09-30 16:47:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/iommu-updates-v3.7-rc1

for you to fetch changes up to 009487258399cb4f431992919fa0f386d1b74ceb:

  Merge branches 'dma-debug', 'iommu/fixes', 'arm/tegra', 'arm/exynos', 'x86/amd', 'x86/vt-d' and 'x86/amd-irq-remapping' into next (2012-10-02 14:40:03 +0200)

----------------------------------------------------------------

IOMMU Updates for Linux v3.7-rc1

This time the IOMMU updates contain a bunch of fixes and cleanups to
various IOMMU drivers and the DMA debug code. New features are the
code for IRQ remapping support with the AMD IOMMU (preperation for that
was already merged in the last release) and a debugfs interface to
export some statistics in the NVidia Tegra IOMMU driver.

----------------------------------------------------------------
Alex Williamson (1):
      intel-iommu: Default to non-coherent for domains unattached to iommus

Borislav Petkov (1):
      iommu/amd: Fix features reporting

Dan Carpenter (1):
      iommu/amd: Fix possible use after free in get_irq_table()

Frank Arnold (1):
      iommu/amd: Fix some typos

Hiroshi Doyu (2):
      iommu/tegra: smmu: debugfs for TLB/PTC statistics
      iommu/tegra: smmu: Use debugfs_create_dir for directory

Joerg Roedel (18):
      iommu/amd: Keep track of HPET and IOAPIC device ids
      iommu/amd: Add slab-cache for irq remapping tables
      iommu/amd: Allocate data structures to keep track of irq remapping tables
      iommu/amd: Check if IOAPIC information is correct
      iommu/amd: Split device table initialization into irq and dma part
      iommu/amd: Make sure IOMMU is not considered to translate itself
      iommu/amd: Add IRTE invalidation routine
      iommu/amd: Add routines to manage irq remapping tables
      iommu/amd: Add IOAPIC remapping routines
      iommu/amd: Implement MSI routines for interrupt remapping
      iommu/amd: Add call-back routine for HPET MSI
      iommu/amd: Add initialization routines for AMD interrupt remapping
      iommu/amd: Make sure irq remapping still works on dma init failure
      iommu/irq: Use amd_iommu_irq_ops if supported
      iommu/amd: Print message to system log when irq remapping is enabled
      iommu/amd: Report irq remapping through IOMMU-API
      iommu/amd: Remove obsolete comment line
      Merge branches 'dma-debug', 'iommu/fixes', 'arm/tegra', 'arm/exynos', 'x86/amd', 'x86/vt-d' and 'x86/amd-irq-remapping' into next

Shuah Khan (1):
      dma-debug: Remove local BUS_NOTIFY_UNBOUND_DRIVER define

Stephen Warren (1):
      dma: tegra: move smmu.h into SMMU driver

Wei Yongjun (2):
      iommu/amd: remove duplicated include from amd_iommu_init.c
      iommu/exynos: use list_del_init instead of list_del/INIT_LIST_HEAD

 arch/arm/mach-tegra/include/mach/smmu.h |   63 ----
 drivers/iommu/Kconfig                   |    2 +-
 drivers/iommu/amd_iommu.c               |  514 ++++++++++++++++++++++++++++++-
 drivers/iommu/amd_iommu_init.c          |  253 +++++++++++++--
 drivers/iommu/amd_iommu_proto.h         |    8 +
 drivers/iommu/amd_iommu_types.h         |   59 +++-
 drivers/iommu/exynos-iommu.c            |    3 +-
 drivers/iommu/intel-iommu.c             |    4 +-
 drivers/iommu/irq_remapping.c           |    5 +
 drivers/iommu/irq_remapping.h           |    6 +
 drivers/iommu/tegra-smmu.c              |  261 +++++++++++++++-
 lib/dma-debug.c                         |    5 -
 12 files changed, 1071 insertions(+), 112 deletions(-)
 delete mode 100644 arch/arm/mach-tegra/include/mach/smmu.h

Please pull.

Regards,

	Joerg


--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQbvtfAAoJECvwRC2XARrjUisP/2Xiq0Slg7N0pLLSN2x+n/F1
2ZWPsdCsa50RTt8eqcikvc11KOFlmX69+Y2w9lqrFpZlLzpUaNBu3jqikdudDDRR
wfqEuL5g43orl0ig19zRikT0cHd9X6iqLbQG22nxp3K6txsw1L8xH2BtU5PHF9A6
Wbv3EatRtECqKt/TTBaXa56UjFA2FCKm1gvx62af41AjMjawVBWouzNYSRfQO+5f
m/eQAUbRR29xnShFWLf0dPsIJFxPlMhEp/Hlrkbp1C1NUkvhoPmTiF8QScj2nLix
2VINYWN0TsLII6ytlMxzdzEo1NypIQ0FmkzE9FSotbtgJa/JK1GazWWhXDU8/z1a
3bhja/ohnCw+K8OC0S45DSEmyq6kcKwrr1con8JBOsE/krRM5CD2jMWfNgytYllK
bmKQYI9Murna9LnefXIrz6OcMyzorrGTmDA2PTu2qrnuxHgAclOx/bvOcpacJ97O
hwS44XnXo2ip1RtA+IhhLGbm4M7HuBxIWYHDouKKuYXN/KQSP0raNtfl1VAhSZ4O
igZGxxtf+HMNXK7ccgqO8Rv7W6TqW9mu/Ql4EnL/WFfLAaiC9oxsUKAw4glMd6Q9
6CTpB2FYKoARDGdJmiQBDdHSDOz14eVDmYQM+ByfMo/xNlGOQsW9NQwryGn0u8bm
w024t2im9nrJNArFEhkc
=MT7o
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--


