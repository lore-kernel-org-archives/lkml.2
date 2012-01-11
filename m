Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933848Ab2AKSeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 13:34:20 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:60279 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932778Ab2AKSeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 13:34:15 -0500
Date: Wed, 11 Jan 2012 10:34:08 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [git pull] PCI changes
Message-ID: <20120111103408.30cfa338@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lrva.gLlR8acl2hBSfKt1jW"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/lrva.gLlR8acl2hBSfKt1jW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The following changes since commit
f423fc627b05f47bc9305f9661630fce30f208f9:

  Revert "rtc: Expire alarms after the time is set." (2012-01-04 07:57:22 -=
0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci linux-next

There's a fix pending for a build problem when CONFIG_AMD_NB=3Dn, but I
didn't want to delay the pull request any longer; I'll include it in
the next fixes pull.

This one doesn't include Yinghai's resource management stuff either,
I'll put that in my -next tree for the next merge window when Yinghai
has it ready.  That might be a good time to revert 12c22d6ef299 (the
revert of the transparent bridge sizing code we talked about), unless
you want to try it now.

It *does* include some nice improvements from Bjorn on how the root bus
and bus resource code is structured, some good boot fixes from Fedora,
and lots of misc fixes elsewhere.

There was definitely more rebasing than I'd like fairly late on, but that
was mainly to merge in fixes to Bjorn's series for various build errors
that got reported, so I don't think it invalidated testing (I generally
don't pull from you and rebase except after you've pulled from me).

Thanks,
Jesse

Alessandro Rubini (1):
      PCI: pci_ids: add device ids for STA2X11 device (aka ConneXT)

Alex Williamson (2):
      PCI: Fix PRI and PASID consistency
      PCI: Fix PCI_EXP_TYPE_RC_EC value

Andreas Herrmann (1):
      x86/PCI: amd: Kill misleading message about enablement of IO access t=
o PCI ECS]

Bjorn Helgaas (36):
      PCI: add helpers for building PCI bus resource lists
      PCI: show host bridges and root bus resources
      PCI: add pci_create_root_bus() that accepts resource list
      PCI: add pci_scan_root_bus() that accepts resource list
      PCI: convert pci_scan_bus() to use pci_create_root_bus()
      PCI: convert pci_scan_bus_parented() to use pci_create_root_bus()
      PCI: deprecate pci_scan_bus_parented()
      alpha/PCI: convert to pci_scan_root_bus() for correct root bus resour=
ces
      arm/PCI: convert to pci_scan_root_bus() for correct root bus resources
      frv/PCI: convert to pci_scan_root_bus() for correct root bus resources
      ia64/PCI: use pci_create_bus() instead of pci_scan_bus_parented()
      ia64/PCI: convert to pci_create_root_bus() for correct root bus resou=
rces
      microblaze/PCI: fix pci_bus_for_each_resource() usage
      microblaze/PCI: make pcibios_setup_phb_resources() static
      microblaze/PCI: convert to pci_create_root_bus() for correct root bus=
 resources
      microblaze/PCI: use pci_scan_root_bus()
      mips/PCI: convert to pci_scan_root_bus() for correct root bus resourc=
es
      mn10300/PCI: convert to pci_scan_root_bus() for correct root bus reso=
urces
      parisc/PCI: dino: use pci_create_bus() instead of pci_scan_bus_parent=
ed()
      parisc/PCI: dino: convert to pci_create_root_bus() for correct root b=
us resources
      parisc/PCI: lba: deal with LMMIO/PAT overlaps before creating PCI roo=
t bus
      parisc/PCI: lba: use pci_create_bus() instead of pci_scan_bus_parente=
d()
      parisc/PCI: lba: convert to pci_create_root_bus() for correct root bu=
s resources
      powerpc/PCI: make pcibios_setup_phb_resources() static
      powerpc/PCI: split PHB part out of pcibios_map_io_space()
      powerpc/PCI: convert to pci_create_root_bus()
      sh/PCI: convert to pci_scan_root_bus() for correct root bus resources
      sparc/PCI: convert to pci_create_root_bus()
      sparc32, leon/PCI: convert to pci_scan_root_bus() for correct root bu=
s resources
      x86/PCI: read Broadcom CNB20LE host bridge info before PCI scan
      x86/PCI: use pci_scan_bus() instead of pci_scan_bus_parented()
      x86/PCI: convert to pci_create_root_bus() and pci_scan_root_bus()
      xtensa/PCI: convert to pci_scan_root_bus() for correct root bus resou=
rces
      PCI: remove pci_create_bus()
      x86/PCI: amd: factor out MMCONFIG discovery
      PNP: work around Dell 1536/1546 BIOS MMCONFIG bug that breaks USB

Dave Jones (3):
      PCI: add set_nouse_crs for use by a pci=3Dnocrs blacklist
      PCI: Add Dell Studio 1557 to pci=3Dnocrs blacklist
      PCI: Add Thinkpad SL510 to pci=3Dnocrs blacklist

David Fries (1):
      PCI: pci_has_legacy_pm_support add driver and device to WARN

Eric W. Biederman (1):
      PCI: msi: Disable msi interrupts when we initialize a pci device

Gary Hade (1):
      x86/PCI: Ignore CPU non-addressable _CRS reserved memory resources

Hao, Xudong (1):
      PCI: Enable ATS at the device state restore

Jan Kiszka (3):
      PCI: Rework config space blocking services
      PCI: Introduce INTx check & mask API
      uio: Convert uio_generic_pci to new intx masking API

Kenji Kaneshige (2):
      PCI: pciehp: Fix wrong workqueue cleanup
      PCI: pciehp: Handle push button event asynchronously

Konrad Rzeszutek Wilk (1):
      x86/PCI: Expand the x86_msi_ops to have a restore MSIs.

Matthew Garrett (1):
      PCI: Rework ASPM disable code

Myron Stowe (16):
      PCI: add declaration for pcibios_set_master() to pci core
      PCI: ARM: convert pcibios_set_master() to a non-inlined function
      PCI: IA64: convert pcibios_set_master() to a non-inlined function
      PCI: MicroBlaze: convert pcibios_set_master() to a non-inlined functi=
on
      PCI: PowerPC: convert pcibios_set_master() to a non-inlined function
      PCI: SPARC: convert pcibios_set_master() to a non-inlined function
      PCI: TILE: convert pcibios_set_master() to a non-inlined function
      PCI: UniCore: convert pcibios_set_master() to a non-inlined function
      PCI: Xtensa: convert pcibios_set_master() to a non-inlined function
      PCI: Pull PCI 'latency timer' setup up into the core
      PCI: frv: use generic pcibios_set_master()
      PCI: MIPS: use generic pcibios_set_master()
      PCI: mn10300: use generic pcibios_set_master()
      PCI: sh: use generic pcibios_set_master()
      PCI: x86: use generic pcibios_set_master()
      PCI: latency timer doesn't apply to PCIe

Neil Horman (2):
      PCI/sysfs: add per pci device msi[x] irq listing (v5)
      PCI: msi: fix imbalanced refcount of msi irq sysfs objects

P. Christeas (1):
      PCI: kconfig: English typo in pci/pcie/Kconfig

Rafael J. Wysocki (1):
      PCI/ACPI/PM: Avoid resuming devices that don't signal PME

Ram Pai (1):
      PCI: delay configuration of SRIOV capability

Vincent Palatin (1):
      PCI/PM/Runtime: make PCI traces quieter

Yinghai Lu (3):
      PCI: Only call pci_stop_bus_device() one time for child devices at re=
move
      PCI: DEVICE_COUNT_RESOURCE should be equal to PCI_NUM_RESOURCES
      PCI: Increase resource array mask bit size in pcim_iomap_regions()

Zac Storer (1):
      PCI: fix a brace coding style issue in probe.c

 Documentation/ABI/testing/sysfs-bus-pci    |   18 +++
 Documentation/feature-removal-schedule.txt |   12 ++
 arch/alpha/kernel/pci.c                    |   40 ++++----
 arch/arm/common/it8152.c                   |    9 +-
 arch/arm/common/via82c505.c                |    3 +-
 arch/arm/include/asm/mach/pci.h            |    2 +-
 arch/arm/include/asm/pci.h                 |   12 --
 arch/arm/kernel/bios32.c                   |   34 +++----
 arch/arm/mach-cns3xxx/pcie.c               |    8 +-
 arch/arm/mach-dove/pcie.c                  |    9 +-
 arch/arm/mach-footbridge/dc21285.c         |    8 +-
 arch/arm/mach-integrator/pci_v3.c          |   19 ++--
 arch/arm/mach-iop13xx/pci.c                |   17 ++--
 arch/arm/mach-ixp2000/enp2611.c            |    3 +-
 arch/arm/mach-ixp2000/pci.c                |    8 +-
 arch/arm/mach-ixp23xx/pci.c                |    8 +-
 arch/arm/mach-ixp4xx/common-pci.c          |    8 +-
 arch/arm/mach-kirkwood/pcie.c              |    8 +-
 arch/arm/mach-ks8695/pci.c                 |    8 +-
 arch/arm/mach-mv78xx0/pcie.c               |    8 +-
 arch/arm/mach-orion5x/pci.c                |   16 ++--
 arch/arm/mach-sa1100/pci-nanoengine.c      |   13 ++-
 arch/arm/mach-tegra/pcie.c                 |    9 +-
 arch/arm/mach-versatile/pci.c              |   19 ++--
 arch/arm/plat-iop/pci.c                    |    8 +-
 arch/blackfin/include/asm/pci.h            |    4 -
 arch/frv/mb93090-mb00/pci-frv.c            |   20 ----
 arch/frv/mb93090-mb00/pci-frv.h            |    2 -
 arch/frv/mb93090-mb00/pci-vdk.c            |   11 +-
 arch/h8300/include/asm/pci.h               |    5 -
 arch/ia64/include/asm/pci.h                |    6 -
 arch/ia64/pci/pci.c                        |   43 ++++----
 arch/microblaze/include/asm/pci-bridge.h   |    1 -
 arch/microblaze/include/asm/pci.h          |    5 -
 arch/microblaze/pci/pci-common.c           |   43 ++++----
 arch/mips/pci/pci.c                        |   38 ++-----
 arch/mn10300/unit-asb2305/pci-asb2305.c    |   22 ----
 arch/mn10300/unit-asb2305/pci-asb2305.h    |    2 -
 arch/mn10300/unit-asb2305/pci.c            |   12 +-
 arch/powerpc/include/asm/pci-bridge.h      |    1 -
 arch/powerpc/include/asm/pci.h             |    5 -
 arch/powerpc/kernel/pci-common.c           |   30 ++++--
 arch/powerpc/kernel/pci_64.c               |   40 ++++----
 arch/sh/drivers/pci/pci.c                  |   41 ++------
 arch/sparc/include/asm/pci_32.h            |    5 -
 arch/sparc/include/asm/pci_64.h            |    5 -
 arch/sparc/kernel/leon_pci.c               |   25 ++---
 arch/sparc/kernel/pci.c                    |   22 ++--
 arch/tile/include/asm/pci.h                |    7 --
 arch/tile/kernel/pci.c                     |    5 +
 arch/unicore32/include/asm/pci.h           |    5 -
 arch/unicore32/kernel/pci.c                |    5 +
 arch/x86/include/asm/amd_nb.h              |    2 +
 arch/x86/include/asm/pci.h                 |    9 ++
 arch/x86/include/asm/pci_x86.h             |    2 -
 arch/x86/include/asm/topology.h            |    2 +-
 arch/x86/include/asm/x86_init.h            |    1 +
 arch/x86/kernel/amd_nb.c                   |   31 ++++++
 arch/x86/kernel/x86_init.c                 |    1 +
 arch/x86/pci/acpi.c                        |   75 ++++++++++---
 arch/x86/pci/amd_bus.c                     |   43 ++------
 arch/x86/pci/broadcom_bus.c                |   62 +++++++----
 arch/x86/pci/bus_numa.c                    |   31 +++---
 arch/x86/pci/common.c                      |   19 ++--
 arch/x86/pci/i386.c                        |   20 ----
 arch/x86/pci/legacy.c                      |    3 -
 arch/x86/pci/numaq_32.c                    |    2 -
 arch/xtensa/include/asm/pci.h              |    5 -
 arch/xtensa/kernel/pci.c                   |   90 ++++++++--------
 drivers/acpi/pci_irq.c                     |   10 +-
 drivers/acpi/pci_root.c                    |    7 ++
 drivers/parisc/dino.c                      |   47 ++++----
 drivers/parisc/lba_pci.c                   |   72 +++++++------
 drivers/pci/access.c                       |   76 +++++++++-----
 drivers/pci/ats.c                          |   37 +++++--
 drivers/pci/bus.c                          |   32 +++++-
 drivers/pci/hotplug/pciehp.h               |    1 -
 drivers/pci/hotplug/pciehp_core.c          |   11 +--
 drivers/pci/hotplug/pciehp_ctrl.c          |    4 +-
 drivers/pci/hotplug/pciehp_hpc.c           |    1 -
 drivers/pci/iov.c                          |   16 ++--
 drivers/pci/msi.c                          |  160 ++++++++++++++++++++++++=
+++-
 drivers/pci/pci-acpi.c                     |   13 ++-
 drivers/pci/pci-driver.c                   |    3 +-
 drivers/pci/pci.c                          |  153 ++++++++++++++++++++++++=
+-
 drivers/pci/pci.h                          |   10 ++
 drivers/pci/pcie/Kconfig                   |    2 +-
 drivers/pci/pcie/aspm.c                    |   58 +++++++----
 drivers/pci/probe.c                        |   68 +++++++++++--
 drivers/pci/remove.c                       |   10 ++-
 drivers/pci/setup-res.c                    |    6 +-
 drivers/pnp/quirks.c                       |   42 +++++++
 drivers/scsi/ipr.c                         |   67 +++++++++++--
 drivers/scsi/ipr.h                         |    1 +
 drivers/uio/uio_pci_generic.c              |   76 +------------
 include/linux/msi.h                        |    3 +
 include/linux/pci-aspm.h                   |    4 +-
 include/linux/pci.h                        |   51 ++++++----
 include/linux/pci_ids.h                    |   23 ++++
 include/linux/pci_regs.h                   |    6 +-
 lib/devres.c                               |    6 +-
 101 files changed, 1334 insertions(+), 857 deletions(-)

--Sig_/lrva.gLlR8acl2hBSfKt1jW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPDdYgAAoJEIEoDkX4Qk9h/vcP/iV18p2Hy/OBSUezCDWrhjdj
XWKBgtWlqSOmWMPGbc9v2YetUvLRmXln3f54Y56GiEZIqs9yN0ZW1AwzTSIUGJrf
Y/uIhD+HbF8W5+SCKfMvfZgZEgrlWOaLiKNDB7Sobum4y91plQ8Hbid7eCliYlGy
1Y5FQGOLK3ngLtSYYVaBXC888eEs24jNxkgN1nEolS6r58n9/AO0jiNQJLDvzkol
LeGxd8jXxUrFm4KqJ41lIPBuWXvAwe/Y2Sso5nO84cj+9Mq5CN0iFGR3U5pB1k1m
da5dXAxtyE8Sar8Mc5tQO71aXVTJLzEKliAySywPgU/9ZIhtJOgSQpZj4VuYqKcc
j1x0uKGTZzVv23MNAx/FYF1khvuEWgOsMS6qRbBmde3A+cBKe6scA57o5iteQK+C
r5dquu+8VP/8sv0/8mJqJ93ejOcLBc/++N7JswHcD9cDTzmji8+4zuPSypUxIJpf
U3+fQU08aH5Ph0pi9dFH7Egp40wp1Swxr16CkfEJo1rgq9Idiy7p6wPNv4dH8kLB
hfu/iF79m7ohIhH9DkOrsrOsfAqlROUrZAxmiqs7xsvM7PQIkukWuzNErJbsMUfQ
xWtcqo9/sF4dEfcLec5A6C8nXtDkYtfaRXIHw0bfsjJYKA11Inyqh99ru9i0FmjY
INvTxepGELJwiFe5sjWd
=gHrK
-----END PGP SIGNATURE-----

--Sig_/lrva.gLlR8acl2hBSfKt1jW--
