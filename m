Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab1J1U3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 16:29:40 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:54622 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755389Ab1J1U3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 16:29:38 -0400
Date: Fri, 28 Oct 2011 13:29:35 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [git pull] PCI changes
Message-ID: <20111028132935.6630b575@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/IPhjJqk/CdkjtqIUBpfJKXd"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/IPhjJqk/CdkjtqIUBpfJKXd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Note!  There are two branches available, see below.

The following changes since commit
e9308cfd5ab4ade3d81cf591c7599c3a05a21b04:

  Merge branch 'gpio/merge' of git://git.secretlab.ca/git/linux-2.6 (2011-1=
0-14 17:07:52 +1200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci next-revert

Probably the most exciting bits of this series are the MPS fixes and
Joerg's PASID stuff.  But I don't think there's anything really risky
(i.e. no big resource management changes this time around).

We found a problem on PPC with the latency setup changes, so this
branch includes reverts for those patches.  However, another branch is
available with those patches rebased out if you prefer a cleaner
changelog.  See below for the changelog and diffstat to expect from
that branch.

Ben Hutchings (2):
      PCI: Add Solarflare vendor ID and SFC4000 device IDs
      PCI: Add quirk for known incorrect MPSS

Benjamin Herrenschmidt (2):
      PCI: Make pci_setup_bridge() non-static for use by arch code
      pci: Clamp pcie_set_readrq() when using "performance" settings

Jan Beulich (1):
      x86: constify PCI raw ops structures

Jesse Barnes (7):
      Revert "PCI: latency timer doesn't apply to PCIe"
      Revert "PCI: x86: use generic pcibios_set_master()"
      Revert "PCI: sh: use generic pcibios_set_master()"
      Revert "PCI: mn10300: use generic pcibios_set_master()"
      Revert "PCI: mips: use generic pcibios_set_master()"
      Revert "PCI: frv: use generic pcibios_set_master()"
      Revert "PCI: Pull PCI 'latency timer' setup up into the core"

Joerg Roedel (4):
      PCI: Move ATS implementation into own file
      PCI: Export ATS functions to modules
      PCI: Add implementation for PRI capability
      PCI: Add support for PASID capability

Jon Mason (3):
      PCI: Workaround for Intel MPS errata
      PCI: enable MPS "performance" setting to properly handle bridge MPS
      PCI: Clean-up MPS debug output

Josh Boyer (1):
      PCI quirk: mmc: Always check for lower base frequency quirk for Ricoh=
 1180:e823

Myron Stowe (7):
      PCI: Pull PCI 'latency timer' setup up into the core
      PCI: frv: use generic pcibios_set_master()
      PCI: mips: use generic pcibios_set_master()
      PCI: mn10300: use generic pcibios_set_master()
      PCI: sh: use generic pcibios_set_master()
      PCI: x86: use generic pcibios_set_master()
      PCI: latency timer doesn't apply to PCIe

Prarit Bhargava (1):
      PCI hotplug: acpiphp: Prevent deadlock on PCI-to-PCI bridge remove

Rafael J. Wysocki (2):
      PCI / PM: Extend PME polling to all PCI devices
      PCI / PM: Remove unnecessary error variable from acpi_dev_run_wake()

 arch/x86/include/asm/pci_x86.h     |    6 +-
 arch/x86/pci/ce4100.c              |    2 +-
 arch/x86/pci/common.c              |    4 +-
 arch/x86/pci/direct.c              |    6 +-
 arch/x86/pci/mmconfig_32.c         |    2 +-
 arch/x86/pci/mmconfig_64.c         |    2 +-
 arch/x86/pci/numaq_32.c            |    2 +-
 arch/x86/pci/olpc.c                |    2 +-
 arch/x86/pci/pcbios.c              |    4 +-
 drivers/acpi/osl.c                 |    3 +-
 drivers/net/sfc/efx.c              |   10 +-
 drivers/net/sfc/efx.h              |    4 -
 drivers/net/sfc/falcon.c           |    3 +-
 drivers/net/sfc/falcon_boards.c    |    3 +-
 drivers/pci/Kconfig                |   26 +++
 drivers/pci/Makefile               |    1 +
 drivers/pci/ats.c                  |  438 ++++++++++++++++++++++++++++++++=
++++
 drivers/pci/hotplug/acpiphp_glue.c |  109 ++++++++--
 drivers/pci/iov.c                  |  142 ------------
 drivers/pci/pci-acpi.c             |    6 +-
 drivers/pci/pci.c                  |   59 +++--
 drivers/pci/pcie/pme.c             |    9 +
 drivers/pci/probe.c                |   68 +++---
 drivers/pci/quirks.c               |  111 ++++++++--
 drivers/pci/setup-bus.c            |    2 +-
 include/acpi/acpiosxf.h            |    2 +
 include/linux/pci-ats.h            |   75 ++++++
 include/linux/pci.h                |    2 +
 include/linux/pci_ids.h            |    5 +
 include/linux/pci_regs.h           |   20 ++
 30 files changed, 868 insertions(+), 260 deletions(-)
 create mode 100644 drivers/pci/ats.c

--------- rebased tree info below

The following changes since commit e9308cfd5ab4ade3d81cf591c7599c3a05a21b04:

  Merge branch 'gpio/merge' of git://git.secretlab.ca/git/linux-2.6 (2011-1=
0-14 17:07:52 +1200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci next-rebase

Ben Hutchings (2):
      PCI: Add Solarflare vendor ID and SFC4000 device IDs
      PCI: Add quirk for known incorrect MPSS

Benjamin Herrenschmidt (2):
      PCI: Make pci_setup_bridge() non-static for use by arch code
      pci: Clamp pcie_set_readrq() when using "performance" settings

Jan Beulich (1):
      x86: constify PCI raw ops structures

Joerg Roedel (4):
      PCI: Move ATS implementation into own file
      PCI: Export ATS functions to modules
      PCI: Add implementation for PRI capability
      PCI: Add support for PASID capability

Jon Mason (3):
      PCI: Workaround for Intel MPS errata
      PCI: enable MPS "performance" setting to properly handle bridge MPS
      PCI: Clean-up MPS debug output

Josh Boyer (1):
      PCI quirk: mmc: Always check for lower base frequency quirk for Ricoh=
 1180:e823

Prarit Bhargava (1):
      PCI hotplug: acpiphp: Prevent deadlock on PCI-to-PCI bridge remove

Rafael J. Wysocki (2):
      PCI / PM: Extend PME polling to all PCI devices
      PCI / PM: Remove unnecessary error variable from acpi_dev_run_wake()

 arch/x86/include/asm/pci_x86.h     |    6 +-
 arch/x86/pci/ce4100.c              |    2 +-
 arch/x86/pci/common.c              |    4 +-
 arch/x86/pci/direct.c              |    6 +-
 arch/x86/pci/mmconfig_32.c         |    2 +-
 arch/x86/pci/mmconfig_64.c         |    2 +-
 arch/x86/pci/numaq_32.c            |    2 +-
 arch/x86/pci/olpc.c                |    2 +-
 arch/x86/pci/pcbios.c              |    4 +-
 drivers/acpi/osl.c                 |    3 +-
 drivers/net/sfc/efx.c              |   10 +-
 drivers/net/sfc/efx.h              |    4 -
 drivers/net/sfc/falcon.c           |    3 +-
 drivers/net/sfc/falcon_boards.c    |    3 +-
 drivers/pci/Kconfig                |   26 +++
 drivers/pci/Makefile               |    1 +
 drivers/pci/ats.c                  |  438 ++++++++++++++++++++++++++++++++=
++++
 drivers/pci/hotplug/acpiphp_glue.c |  109 ++++++++--
 drivers/pci/iov.c                  |  142 ------------
 drivers/pci/pci-acpi.c             |    6 +-
 drivers/pci/pci.c                  |   59 +++--
 drivers/pci/pcie/pme.c             |    9 +
 drivers/pci/probe.c                |   68 +++---
 drivers/pci/quirks.c               |  111 ++++++++--
 drivers/pci/setup-bus.c            |    2 +-
 include/acpi/acpiosxf.h            |    2 +
 include/linux/pci-ats.h            |   75 ++++++
 include/linux/pci.h                |    2 +
 include/linux/pci_ids.h            |    5 +
 include/linux/pci_regs.h           |   20 ++
 30 files changed, 868 insertions(+), 260 deletions(-)
 create mode 100644 drivers/pci/ats.c

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/IPhjJqk/CdkjtqIUBpfJKXd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOqxCvAAoJEIEoDkX4Qk9hiboP/RbvgFb2awf6VgVKt0p705E4
D5aDi4uLg+/o6wXmc6XrpeIj7B2kl4M8WT+FOvZjiB7IoBGe2AecYfwhKo2j9M63
aOic/RcICf0wjSTQz3qC/37XL7F5TbNcuvUTYH7FsUfkvkDNvL7knWane60uw+3v
oe7QYfG8+LzF+NZOxkQAFb6Fb2QEhyjIJhG4fmb2VLCUGAozHKZdM9Pjf4LewaHR
2BbBvwmDaQyEQ6hpuGLUYA9NTYqbhWc7WO1lauJZgLv0VtQVzYukljcfsNvL45U7
qQ2kafuG/U6sGfUHUIwCEAo6hQytlXj7DFXM5vHBJVjboTray5wNbtpEEUR8NwfF
6n9YEff8x4qFpHdbAf1fOxX+pVx3br9qFt+Q4De3J0oQI3ZlU9h4u6jmZfZwRAO5
esZdUQb6p+9NJdyhfvwn2eY2ra8Lv/Y5jKbeFr2uEVSb0Qkk9dEv9LFZUquAZGEH
3gw8xGFNanqzrNSV5fjRaEGPCGQZ+hW7uqXNooECGarDXev5TOuTNpMeZUzZLWzR
b8++u8liJsizCIji7F6kO6FQ9cW4mDi2Z5ocfZmc1L5wZyGITq0q/l1LGAe7uifY
owIJDtJedjpi4/g4Gn0wL6u/LU9rRtVVKZ6Be1i/xtnKY6Cy3H1hqnXdpnn08E8D
k23xMMyiNlCLM5WAb8YD
=9JnL
-----END PGP SIGNATURE-----

--Sig_/IPhjJqk/CdkjtqIUBpfJKXd--
