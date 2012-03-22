Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995Ab2CVVs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:48:28 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:59345 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755924Ab2CVVsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:48:24 -0400
Date: Thu, 22 Mar 2012 14:48:17 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [git pull] PCI changes (including maintainer change)
Message-ID: <20120322144817.796e3a8a@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/B/y5JvzE69B4LsOl.oC/IFd"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/B/y5JvzE69B4LsOl.oC/IFd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The following changes since commit
4f262acfde22b63498b5e4f165e53d3bb4e96400:

  Merge branch 'fixes' of git://git.linaro.org/people/rmk/linux-arm (2012-0=
3-07 08:33:03 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci linux-next

This pull has some good cleanups from Bjorn and Yinghai, as well as
some more code from Yinghai to better handle resource re-allocation
when enabled.

There's also a new initcall_debug feature from Arjan which will print
out quirk timing information to help identify slow quirks for fixing or
refinement (Yinghai sent in a few patches to do just that once the new
debug code landed).

Beyond that, I'm handing off PCI maintainership to Bjorn Helgaas.  He's
been a core PCI and Linux contributor for some time now, and has kindly
volunteered to take over.  I just don't feel I have the time for PCI
review and work that it deserves lately (I've taken on some other
projects), and haven't been as responsive lately as I'd like, so I
approached Bjorn asking if he'd like to manage things.  He's going to
give it a try, and I'm confident he'll do at least as well as I have in
keeping the tree managed, patches flowing, and keeping things stable.

Thanks,
Jesse

Alan Cox (1):
      x86/mrst/pci: avoid SoC fixups on non-SoC platforms

Amos Kong (1):
      PCI: Can continually add funcs after adding func0

Anthony PERARD (1):
      PCI: Add PCI_EXP_TYPE_PCIE_BRIDGE value

Arjan van de Ven (1):
      PCI: Annotate PCI quirks in initcall_debug style

Bjorn Helgaas (38):
      x86/PCI: don't fall back to defaults if _CRS has no apertures
      PCI: make pci_flags always available
      PCI: add pci_clear_flags()
      alpha/PCI: replace pci_probe_only with pci_flags
      arm/PCI: remove arch pci_flags definition
      arm/PCI: use pci_flags PCI_PROBE_ONLY instead of arm-specific flag
      microblaze/PCI: remove unused pci_flags
      mips/PCI: replace pci_probe_only with pci_flags
      mips/PCI: removed unused pci_probe configurability
      powerpc/PCI: make pci_probe_only default to 0
      powerpc/PCI: replace pci_probe_only with pci_flags
      unicore32/PCI: use pci_flags PCI_PROBE_ONLY instead of arm-specific f=
lag
      PCI: make pci_flags non-weak
      PCI: don't publish new root bus until it's fully initialized
      PCI: add struct pci_host_bridge and a list of all bridges found
      PCI: add struct pci_host_bridge_window with CPU/bus address offset
      PCI: convert bus addresses to resource when reading BARs
      PCI: add generic pcibios_resource_to_bus()
      alpha/PCI: get rid of device resource fixups
      arm/PCI: get rid of device resource fixups
      ia64/PCI: SN: convert to pci_scan_root_bus() for correct root bus res=
ources
      ia64/PCI: get rid of device resource fixups
      microblaze/PCI: get rid of device resource fixups
      mips/PCI: get rid of device resource fixups
      mn10300/PCI: get rid of device resource fixups
      parisc/PCI: get rid of device resource fixups
      powerpc/PCI: get rid of device resource fixups
      sh/PCI: get rid of device resource fixups
      sparc/PCI: get rid of device resource fixups
      xtensa/PCI: get rid of device resource fixups
      PCI: collapse pcibios_resource_to_bus
      PCI: fix bridge I/O window bus-to-resource conversion
      arm/PCI: don't export pci_flags
      powerpc/PCI: compute I/O space bus-to-resource offset consistently
      powerpc/PCI: convert devtree bus addresses to resource
      powerpc/PCI: allow reallocation on PA Semi
      sparc/PCI: convert devtree and arch-probed bus addresses to resource
      unicore32/PCI: move <asm-generic/pci-bridge.h> include to asm/pci.h

Danny Kukawka (1):
      PCI hotplug: cpcihp: fix debug module parameter to be bool

Jacob Pan (2):
      x86/mrst/pci: assign d3_delay to 0 for Langwell devices
      x86/mrst/pci: v4l/atomisp: treat atomisp as real pci device

Jesse Barnes (3):
      Merge branch 'pci-next+probe_only+bus2res-fb127cb' of git://github.co=
m/bjorn-helgaas/linux into linux-next
      PCI: hand PCI maintenance over to Bjorn Helgaas
      PCI: Bjorn gets PCI hotplug too

Julia Lawall (1):
      PCI: drivers/pci/hotplug/ibmphp_ebda.c: add missing iounmap

Kay, Allen M (1):
      PCI: check for pci bar restore completion and retry

Konrad Rzeszutek Wilk (2):
      PCI: Introduce __pci_reset_function_locked to be used when holding de=
vice_lock.
      xen/pciback: Support pci_reset_function, aka FLR or D3 support.

MUNEDA Takahiro (1):
      PCI: Add pcie_hp=3Dnomsi to disable MSI/MSI-X for pciehp driver

Masanari Iida (1):
      PCI: Fix typo in setup-res.c

Matthew Garrett (1):
      PCI: pcie: Add support for setting default ASPM policy

Myron Stowe (4):
      PCI: Fix starting basis for resource requests
      x86/PCI: Infrastructure to maintain a list of FW-assigned BIOS BAR va=
lues
      x86/PCI: Convert maintaining FW-assigned BIOS BAR values to use a list
      x86/PCI: add spinlock held check to 'pcibios_fwaddrmap_lookup()'

Rafael J. Wysocki (2):
      PCI / PM: Disable wakeup during shutdown for devices not enabled to w=
ake up
      PCI / PCIe: Introduce command line option to disable ARI

Thomas Jarosch (1):
      PCI: Add quirk for still enabled interrupts on Intel Sandy Bridge GPUs

Yinghai Lu (51):
      PCI : Calculate right add_size
      PCI: Make add_to_list() return status
      PCI: Move get_res_add_size() function
      PCI: try to assign required+option size first
      PCI: Use add_list in pcie hotplug path.
      PCI: Make rescan bus increase bridge resource size if needed
      PCI: Make pci_rescan_bus handle add_list
      PCI: make re-allocation try harder by reassigning ranges higher in th=
e heirarchy
      PCI: Move pdev_sort_resources() to setup-bus.c
      PCI: Move struct resource_list to setup-bus.c
      PCI: Replace resource_list with generic list
      PCI: Merge pci_dev_resource_x and pci_dev_resource
      PCI: Rename dev_res_x to add_res or fail_res
      PCI: make free_list() into a function
      PCI: add debug print out for add_size
      PCI: remove add_to_failed_list()
      PCI: make sriov work with hotplug remove
      PCI: Separate pci_bus_read_dev_vendor_id from pci_scan_device
      PCI: pciehp: replace unconditional sleep with config space access che=
ck
      PCI: pciehp: make check_link_active more helpful
      PCI: pciehp: Add pcie_wait_link_not_active()
      PCI: pciehp: Add Disable/enable link functions
      PCI: pciehp: Disable/enable link during slot power off/on
      PCI: Fix /sys warning when sriov enabled and card is hot removed
      PCI: Disable cardbus bridge MEM1 prefetchable bit
      PCI: Fix "cardbus bridge resources as optional" size handling
      PCI: Skip cardbus assigned resource reset during pci bus rescan
      PCI: Fix device class print out
      PCI: fix memleak for pci dev removing during hotplug
      PCI: move pci_find_saved_cap out of linux/pci.h
      PCI: Retry on IORESOURCE_IO type allocations
      PCI: prepare pci=3Drealloc for multiple options
      PCI: print out suggestion about using pci=3Drealloc
      PCI: add a PCI resource reallocation config option
      PCI: Add class support in quirk handling
      PCI: Use class for quirk for via_no_dac
      PCI: Use class quirk for intel fix_transparent_bridge
      PCI: Use class for quirk for pci_fixup_video
      PCI: Use class for quirk for host bridge mmio_always_on
      PCI: Use class for quirk for cardbus_legacy
      PCI: Use class for quirk for legacy ATA NO_D3
      PCI: Use class for quirk for netmos class fixup
      PCI: Use class for quirk for intel e100 interrupt fixup
      PCI: Use class for quirk for ti816x class fixup
      PCI: Use class for quirk for usb host controller fixup
      PCI: Move "pci reassigndev resource alignment" out of quirks.c
      PCI: print out PCI device info along with duration
      PCI: Rename pci_remove_bus_device to pci_stop_and_remove_bus_device
      PCI: Rename pci_remove_behind_bridge to pci_stop_and_remove_behind_br=
idge
      PCI: export __pci_remove_bus_device
      PCI: make acpihp use __pci_remove_bus_device instead

 Documentation/kernel-parameters.txt        |   14 +-
 MAINTAINERS                                |    4 +-
 arch/alpha/include/asm/pci.h               |    7 +-
 arch/alpha/kernel/pci.c                    |   86 +----
 arch/alpha/kernel/pci_impl.h               |    3 -
 arch/alpha/kernel/sys_marvel.c             |    3 +-
 arch/alpha/kernel/sys_titan.c              |    3 +-
 arch/arm/common/it8152.c                   |    4 +-
 arch/arm/include/asm/pci.h                 |    8 -
 arch/arm/kernel/bios32.c                   |   75 +---
 arch/arm/mach-cns3xxx/pcie.c               |    4 +-
 arch/arm/mach-dove/pcie.c                  |    4 +-
 arch/arm/mach-footbridge/dc21285.c         |    8 +-
 arch/arm/mach-integrator/pci_v3.c          |    7 +-
 arch/arm/mach-iop13xx/pci.c                |    4 +-
 arch/arm/mach-ixp2000/ixdp2400.c           |    4 +-
 arch/arm/mach-ixp2000/ixdp2800.c           |    4 +-
 arch/arm/mach-ixp2000/ixdp2x00.c           |    4 +-
 arch/arm/mach-ixp2000/pci.c                |    6 +-
 arch/arm/mach-ixp23xx/pci.c                |    6 +-
 arch/arm/mach-ixp4xx/common-pci.c          |    4 +-
 arch/arm/mach-kirkwood/pcie.c              |    4 +-
 arch/arm/mach-ks8695/pci.c                 |    4 +-
 arch/arm/mach-mv78xx0/pcie.c               |    4 +-
 arch/arm/mach-orion5x/pci.c                |   14 +-
 arch/arm/mach-sa1100/pci-nanoengine.c      |    8 +-
 arch/arm/mach-tegra/pcie.c                 |    6 +-
 arch/arm/mach-versatile/pci.c              |    6 +-
 arch/arm/mm/iomap.c                        |    3 -
 arch/arm/plat-iop/pci.c                    |    4 +-
 arch/ia64/include/asm/pci.h                |    6 -
 arch/ia64/pci/pci.c                        |   55 +---
 arch/ia64/sn/kernel/io_init.c              |   16 +-
 arch/microblaze/include/asm/pci-bridge.h   |    1 -
 arch/microblaze/include/asm/pci.h          |    8 -
 arch/microblaze/pci/pci-common.c           |  117 +-----
 arch/mips/include/asm/pci.h                |    9 +-
 arch/mips/pci/fixup-cobalt.c               |   61 ---
 arch/mips/pci/pci-bcm1480.c                |    2 +-
 arch/mips/pci/pci-ip27.c                   |    2 +-
 arch/mips/pci/pci-lantiq.c                 |    3 +-
 arch/mips/pci/pci-sb1250.c                 |    2 +-
 arch/mips/pci/pci-xlr.c                    |    2 +-
 arch/mips/pci/pci.c                        |   89 +----
 arch/mn10300/include/asm/pci.h             |   16 -
 arch/mn10300/unit-asb2305/pci.c            |   62 +---
 arch/parisc/include/asm/pci.h              |   38 --
 arch/parisc/kernel/pci.c                   |   52 ---
 arch/powerpc/include/asm/pci.h             |    9 +-
 arch/powerpc/include/asm/ppc-pci.h         |    2 -
 arch/powerpc/kernel/pci-common.c           |   86 +----
 arch/powerpc/kernel/pci_32.c               |    6 +-
 arch/powerpc/kernel/pci_64.c               |    7 +-
 arch/powerpc/kernel/pci_of_scan.c          |   12 +-
 arch/powerpc/kernel/rtas_pci.c             |   10 +-
 arch/powerpc/platforms/iseries/pci.c       |    2 +-
 arch/powerpc/platforms/maple/pci.c         |    2 +-
 arch/powerpc/platforms/pasemi/pci.c        |    3 -
 arch/powerpc/platforms/powermac/pci.c      |    3 -
 arch/powerpc/platforms/powernv/pci-ioda.c  |    5 +-
 arch/powerpc/platforms/powernv/pci.c       |    5 +-
 arch/powerpc/platforms/pseries/pci_dlpar.c |    2 +-
 arch/powerpc/platforms/pseries/setup.c     |    3 +
 arch/powerpc/platforms/wsp/wsp_pci.c       |    1 -
 arch/sh/drivers/pci/pci.c                  |   75 +---
 arch/sh/include/asm/pci.h                  |    6 -
 arch/sparc/include/asm/pci_32.h            |    8 -
 arch/sparc/include/asm/pci_64.h            |    8 -
 arch/sparc/kernel/leon_pci.c               |   47 +--
 arch/sparc/kernel/pci.c                    |  106 ++----
 arch/unicore32/include/asm/pci.h           |    1 +
 arch/unicore32/kernel/pci.c                |    5 +-
 arch/x86/kernel/pci-dma.c                  |    5 +-
 arch/x86/pci/acpi.c                        |    7 +-
 arch/x86/pci/fixup.c                       |   12 +-
 arch/x86/pci/i386.c                        |   85 ++++-
 arch/x86/pci/mrst.c                        |   40 ++-
 arch/xtensa/kernel/pci.c                   |   17 +-
 drivers/message/fusion/mptbase.c           |    2 +-
 drivers/parisc/dino.c                      |   27 +-
 drivers/parisc/lba_pci.c                   |   31 +-
 drivers/pci/Kconfig                        |   13 +
 drivers/pci/bus.c                          |   30 +-
 drivers/pci/hotplug/acpiphp_glue.c         |   33 +-
 drivers/pci/hotplug/cpci_hotplug_pci.c     |    2 +-
 drivers/pci/hotplug/cpcihp_generic.c       |    2 +-
 drivers/pci/hotplug/cpqphp_pci.c           |    2 +-
 drivers/pci/hotplug/fakephp.c              |    2 +-
 drivers/pci/hotplug/ibmphp_core.c          |    2 +-
 drivers/pci/hotplug/ibmphp_ebda.c          |    6 +-
 drivers/pci/hotplug/pciehp_hpc.c           |  133 +++++-
 drivers/pci/hotplug/pciehp_pci.c           |    2 +-
 drivers/pci/hotplug/rpadlpar_core.c        |    2 +-
 drivers/pci/hotplug/sgi_hotplug.c          |    2 +-
 drivers/pci/hotplug/shpchp_pci.c           |    2 +-
 drivers/pci/iov.c                          |   12 +-
 drivers/pci/pci-driver.c                   |   10 +
 drivers/pci/pci-sysfs.c                    |    7 +-
 drivers/pci/pci.c                          |  133 ++++++-
 drivers/pci/pci.h                          |   10 +-
 drivers/pci/pcie/Kconfig                   |   25 +
 drivers/pci/pcie/aspm.c                    |    8 +
 drivers/pci/pcie/portdrv.h                 |   12 +
 drivers/pci/pcie/portdrv_core.c            |   16 +-
 drivers/pci/probe.c                        |  298 +++++++++----
 drivers/pci/quirks.c                       |  182 ++++----
 drivers/pci/remove.c                       |   27 +-
 drivers/pci/setup-bus.c                    |  660 +++++++++++++++++++-----=
----
 drivers/pci/setup-res.c                    |   94 ++---
 drivers/pci/xen-pcifront.c                 |    4 +-
 drivers/pcmcia/cardbus.c                   |    2 +-
 drivers/platform/x86/asus-wmi.c            |    2 +-
 drivers/platform/x86/eeepc-laptop.c        |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c        |    2 +-
 drivers/usb/host/pci-quirks.c              |    3 +-
 drivers/xen/xen-pciback/pci_stub.c         |   41 ++-
 drivers/xen/xen-pciback/pciback.h          |    1 +
 include/asm-generic/pci-bridge.h           |    6 +
 include/asm-generic/pci.h                  |   24 -
 include/linux/ioport.h                     |    6 -
 include/linux/pci.h                        |  106 +++--
 include/linux/pci_regs.h                   |    1 +
 122 files changed, 1715 insertions(+), 1708 deletions(-)


--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/B/y5JvzE69B4LsOl.oC/IFd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPa54hAAoJEIEoDkX4Qk9htjwP/RZiA4MuANbe5k+kVRSzlLI5
kSxr6ZAUfgxQbL3GTmyy6HU1BjJLfxFO7k/XCA5MQK/Hgm2M4vxxb3UKYCeaWUIQ
4oICmhCFN5gemfhfFrK9fJPrOUwC5rJ3gmO6kS0y58Vvq4N7tY3T74/e/YDsKI8b
1ncQY+o3PkZKg/pl1QbCGaq6ZdW2q2wBCELprtiuzyS5YgcXIpdDJOKC0Yu5ozmP
kyNUqw8yCkww0expCyz4pp1vTwP7bCZae1cXRs6+P3Y928b6YoLgGnMpxHpT1q84
4T8ZELVUgN7SHaUmRpL9AwPCjvSm+F0VQQIxRkMIklMWaKMhHeldJXqQkJlLPOxm
iheCt1gAkJq26Rq67ju7AOlC6TXgBpFMt8lXL8joZTgShU3bcuISQETExaeOvdSA
I5MzwEVM39HRrJWRhi2Car+oZGC33vqfkwgg00CO7m+W0a7GhE4Vt0tgGxAQ3Zh1
cTfnb4pL04HqEG+Ok4HlkceK/Ne/SqrPiTsA2i6atz+sOp8OHwevF4ttVB+GIn0T
0yRxWZETK318QAqUKacaCaHwVkAKdLUdvy4Oi3XfVwFgbhnqbQt0YGnsx+repL8Q
V5EZfg8YzOx+amfzUfNT/oHYX04w/QupS06XvznM/YDHudNViAL4gF+m9Xxwan0l
yBXPL5uLKWNiVZqNjNcT
=YzvX
-----END PGP SIGNATURE-----

--Sig_/B/y5JvzE69B4LsOl.oC/IFd--
