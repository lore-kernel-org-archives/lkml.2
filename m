Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab2GXXIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 19:08:23 -0400
Received: from 8bytes.org ([85.214.48.195]:34036 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755696Ab2GXXIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 19:08:20 -0400
Date: Wed, 25 Jul 2012 01:08:14 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU Updates for v3.6-rc1
Message-ID: <20120724230814.GA2762@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Jul 25 01:08:16 2012
X-DSPAM-Confidence: 0.9990
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 500f2ae020422116921064
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

The following changes since commit 28a33cbc24e4256c143dce96c7d93bf423229f92:

  Linux 3.5 (2012-07-21 13:58:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/iommu-u=
pdates-v3.6-rc1

for you to fetch changes up to 395e51f18d3b26619c1c462b7a1c0226846ac0a9:

  Merge branches 'iommu/fixes', 'x86/amd', 'groups', 'arm/tegra' and 'api/d=
omain-attr' into next (2012-07-23 12:17:00 +0200)

----------------------------------------------------------------

IOMMU Updates for Linux v3.6-rc1

The most important part of these updates is the IOMMU groups code
enhancement written by Alex Williamson. It abstracts the problem that a
given hardware IOMMU can't isolate any given device from any other
device (e.g. 32 bit PCI devices can't usually be isolated). Devices that
can't be isolated are grouped together. This code is required for the
upcoming VFIO framework.

Another IOMMU-API change written by be is the introduction of domain
attributes. This makes it easier to handle GART-like IOMMUs with the
IOMMU-API because now the start-address and the size of the domain
address space can be queried.

Besides that there are a few cleanups and fixes for the NVidia Tegra
IOMMU drivers and the reworked init-code for the AMD IOMMU. The later is
=66rom my patch-set to support interrupt remapping. The rest of this
patch-set requires x86 changes which are not mergabe yet. So full
support for interrupt remapping with AMD IOMMUs will come in a future
merge window.

----------------------------------------------------------------
Alex Williamson (12):
      PCI: add PCI DMA source ID quirk
      PCI: add ACS validation utility
      PCI: export pci_user functions for use by other drivers
      PCI: create common pcibios_err_to_errno
      PCI: misc pci_reg additions
      driver core: Add iommu_group tracking to struct device
      iommu: IOMMU Groups
      amd_iommu: Support IOMMU groups
      intel-iommu: Support IOMMU groups
      amd_iommu: Make use of DMA quirks and ACS checks in IOMMU groups
      intel-iommu: Make use of DMA quirks and ACS checks in IOMMU groups
      iommu: Remove group_mf

Hiroshi DOYU (3):
      iommu/tegra: Implement DOMAIN_ATTR_GEOMETRY attribute
      iommu/tegra: smmu: Remove unnecessary sanity check at alloc_pdir()
      iommu/tegra: smmu: Fix unsleepable memory allocation at alloc_pdir()

Hiroshi Doyu (5):
      iommu: Add DMA window parser, of_get_dma_window()
      iommu/tegra: smmu: Add device tree support for SMMU
      iommu/tegra: smmu: Simplify allocation at once
      iommu/tegra: smmu: Remove unnecessary cleanups with devm_*()
      iommu/tegra: smmu: Fix uninitialized var warning

Joerg Roedel (21):
      Merge remote-tracking branch 'pci-bjorn/topic/alex-vfio-prep' into gr=
oups
      iommu: Add domain-attribute handlers
      iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
      iommu/vt-d: Implement DOMAIN_ATTR_GEOMETRY attribute
      iommu/omap: Implement DOMAIN_ATTR_GEOMETRY attribute
      iommu/msm: Implement DOMAIN_ATTR_GEOMETRY attribute
      iommu/exynos: Implement DOMAIN_ATTR_GEOMETRY attribute
      iommu/tegra: Don't call alloc_pdir with as->lock
      Merge tag 'v3.5-rc7' into arm/tegra
      iommu/amd: Fix sparse warnings
      iommu/amd: Use acpi_get_table instead of acpi_table_parse
      iommu/amd: Split out PCI related parts of IOMMU initialization
      iommu/amd: Move informational prinks out of iommu_enable
      iommu/amd: Introduce early_amd_iommu_init routine
      iommu/amd: Split enable_iommus() routine
      iommu/amd: Move unmap_flush message to amd_iommu_init_dma_ops()
      iommu/amd: Introduce amd_iommu_init_dma routine
      iommu/amd: Convert iommu initialization to state machine
      iommu/amd: Add missing spin_lock initialization
      iommu/amd: Fix hotplug with iommu=3Dpt
      Merge branches 'iommu/fixes', 'x86/amd', 'groups', 'arm/tegra' and 'a=
pi/domain-attr' into next

 .../ABI/testing/sysfs-kernel-iommu_groups          |   14 +
 .../bindings/iommu/nvidia,tegra30-smmu.txt         |   21 +
 Documentation/kernel-parameters.txt                |    1 -
 arch/ia64/include/asm/iommu.h                      |    2 -
 arch/ia64/kernel/pci-dma.c                         |    1 -
 arch/x86/include/asm/iommu.h                       |    1 -
 arch/x86/kernel/pci-dma.c                          |   11 -
 drivers/iommu/Kconfig                              |    6 +-
 drivers/iommu/Makefile                             |    1 +
 drivers/iommu/amd_iommu.c                          |   99 +++-
 drivers/iommu/amd_iommu_init.c                     |  569 ++++++++++------=
--
 drivers/iommu/amd_iommu_types.h                    |   13 +-
 drivers/iommu/amd_iommu_v2.c                       |    4 +-
 drivers/iommu/exynos-iommu.c                       |    4 +
 drivers/iommu/intel-iommu.c                        |   93 +--
 drivers/iommu/iommu.c                              |  611 ++++++++++++++++=
+++-
 drivers/iommu/irq_remapping.c                      |    5 +
 drivers/iommu/msm_iommu.c                          |    5 +
 drivers/iommu/of_iommu.c                           |   90 +++
 drivers/iommu/omap-iommu.c                         |    4 +
 drivers/iommu/tegra-gart.c                         |    5 +
 drivers/iommu/tegra-smmu.c                         |  285 ++++-----
 drivers/pci/access.c                               |    6 +-
 drivers/pci/pci.c                                  |   69 +++
 drivers/pci/pci.h                                  |    7 -
 drivers/pci/quirks.c                               |   84 +++
 drivers/xen/xen-pciback/conf_space.c               |    6 +-
 include/linux/device.h                             |    2 +
 include/linux/iommu.h                              |  140 ++++-
 include/linux/of_iommu.h                           |   21 +
 include/linux/pci.h                                |   52 +-
 include/linux/pci_regs.h                           |  113 +++-
 32 files changed, 1839 insertions(+), 506 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-iommu_groups
 create mode 100644 Documentation/devicetree/bindings/iommu/nvidia,tegra30-=
smmu.txt
 create mode 100644 drivers/iommu/of_iommu.c
 create mode 100644 include/linux/of_iommu.h

Please pull.

Regards,

	Joerg


--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQDyreAAoJECvwRC2XARrjyS0P/12EOIx4FV2hJ5r4dICF1fCO
XE6kUV8zW/GG/fQy+dmVBlJiEiNmSvjMK8LVJmRvNHdrOV0tbFHgAAisILGa1ucU
Y4F0qS5cd+qiEVNhDO83QwiqT0tf3zeUleZwwb+X5TLexMbbbOADFqv4zeBqxn2q
l0MKVGQiiQYZFPmvAUDxDkn62/5QyMjRWGHtQ5yS6+TasJbCfcH8XflRlovk9lP0
Jr8hXACD5GROpHIapvcDOtjgUgMZEgFMHHJ9Rcrym+7VhOJUMQJcR0nMOfpooNIv
gXTuCwBS4x9/T/0Y6O7JcsCwGrlJ3AKUAGWI5VmnvVR//y5s1Bm4yq2ohtJJ63cK
NmC/MGtX39ALHVL9L0D6nUgnjQi9DTcMUbFORGkFbeBh8e4h+MXNWn7JJoT6TK+V
eSG7YMYFkMBFKA+obuwO9ki8qZNdGhWgOUME78pI9tLXBSwy5yhZaK3RWs9iPpqV
Tx3rou5yW5icQTQqEG0MPZYiZCM63zkqRZBaBlQDQIP8v2Xa9YPk8gz6HjbMYNfQ
hh/KmInROoCyQwmUe9KKRB3Lxu6FX2S6wJdp2s+HBLR4PwrLnu9K+JyAvbRocJ71
Dq48DB+vj+ogQ5hAi7U6zEKhebEn/nVfj76PKDX0PuvF4PkAxIR8AzBUkGm3jQY+
Knu51FGgyJfpmJnMEug8
=OgxB
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--


