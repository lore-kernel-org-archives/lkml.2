Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab2JBODV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 10:03:21 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:42292 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab2JBODS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 10:03:18 -0400
Date: Tue, 2 Oct 2012 09:51:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.7-x86-tag
Message-ID: <20121002135147.GA15735@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.7-x86-tag

which as features/fixes for the x86 and the generic side of the Xen tree.

The signed tag has the wealth of details of what it contains, so I am copying
it here:

<signed tag>
    Features:
     * When hotplugging PCI devices in a PV guest we can allocate Xen-SWIOTLB later.
     * Cleanup Xen SWIOTLB.
     * Support pages out grants from HVM domains in the backends.
     * Support wild cards in xen-pciback.hide=(BDF) arguments.
     * Update grant status updates with upstream hypervisor.
     * Boot PV guests with more than 128GB.
     * Cleanup Xen MMU code/add comments.
     * Obtain XENVERS using a preferred method.
     * Lay out generic changes to support Xen ARM.
     * Allow privcmd ioctl for HVM (used to do only PV).
     * Do v2 of mmap_batch for privcmd ioctls.
     * If hypervisor saves the LED keyboard light - we will now instruct the kernel
       about its state.
    Fixes:
     * More fixes to Xen PCI backend for various calls/FLR/etc.
     * With more than 4GB in a 64-bit PV guest disable native SWIOTLB.
     * Fix up smatch warnings.
     * Fix up various return values in privmcmd and mm.
</signed tag>

It is rather a big pull - and some of them are architecture specific to prep
for the Xen ARM patches.

The 1-2 line changes are additions of #include files to support compilation
under ARM.

There are also changes to SWIOTLB - to allow it to be used later in
the boot process (so we can hotplug PCI devices and allocate SWIOTLB in case
we hadn't started it). IA64 does this too - so the patches expand the existing
function - and have been tested with success on IA64 to make sure they do not
introduce regressions.

Please pull!

Andres Lagar-Cavilla (3):
      xen/privcmd: add PRIVCMD_MMAPBATCH_V2 ioctl
      xen/privcmd: Fix mmap batch ioctl error status copy back.
      xen/gndev: Xen backend support for paged out grant targets V4.

Dan Carpenter (1):
      xen/privcmd: return -EFAULT on error

Daniel De Graaf (1):
      xen/sysfs: Use XENVER_guest_handle to query UUID

David Vrabel (1):
      xen/mm: return more precise error from xen_remap_domain_range()

Ian Campbell (1):
      xen: resynchronise grant table status codes with upstream

Jan Beulich (3):
      xen-pciback: support wild cards in slot specifications
      xen/vga: add the xen EFI video mode support
      xen-pciback: properly clean up after calling pcistub_device_find()

Konrad Rzeszutek Wilk (31):
      xen/perf: Define .glob for the different hypercalls.
      xen/p2m: Fix the comment describing the P2M tree.
      xen/x86: Use memblock_reserve for sensitive areas.
      xen/x86: Workaround 64-bit hypervisor and 32-bit initial domain.
      xen/swiotlb: Simplify the logic.
      xen/swiotlb: With more than 4GB on 64-bit, disable the native SWIOTLB.
      swiotlb: add the late swiotlb initialization function with iotlb memory
      xen/apic/xenbus/swiotlb/pcifront/grant/tmem: Make functions or variables static.
      xen/swiotlb: Remove functions not needed anymore.
      xen/swiotlb: Fix compile warnings when using plain integer instead of NULL pointer.
      Revert "xen/x86: Workaround 64-bit hypervisor and 32-bit initial domain." and "xen/x86: Use memblock_reserve for sensitive areas."
      xen/mmu: The xen_setup_kernel_pagetable doesn't need to return anything.
      xen/mmu: Provide comments describing the _ka and _va aliasing issue
      xen/mmu: use copy_page instead of memcpy.
      xen/mmu: For 64-bit do not call xen_map_identity_early
      xen/mmu: Recycle the Xen provided L4, L3, and L2 pages
      xen/p2m: Add logic to revector a P2M tree to use __va leafs.
      xen/mmu: Copy and revector the P2M tree.
      xen/mmu: Remove from __ka space PMD entries for pagetables.
      xen/mmu: Release just the MFN list, not MFN list and part of pagetables.
      xen/p2m: When revectoring deal with holes in the P2M array.
      xen/mmu: If the revector fails, don't attempt to revector anything else.
      xen/swiotlb: Move the nr_tbl determination in its own function.
      xen/swiotlb: Move the error strings to its own function.
      xen/swiotlb: Use the swiotlb_late_init_with_tbl to init Xen-SWIOTLB late when PV PCI is used.
      xen/swiotlb: For early initialization, return zero on success.
      xen/pcifront: Use Xen-SWIOTLB when initting if required.
      xen/swiotlb: Remove functions not needed anymore.
      xen/swiotlb: Fix compile warnings when using plain integer instead of NULL pointer.
      xen/x86: retrieve keyboard shift status flags from hypervisor.
      xen/pciback: Restore the PCI config space after an FLR.

Stefano Stabellini (7):
      xen: update xen_add_to_physmap interface
      xen: missing includes
      xen/events: fix unmask_evtchn for PV on HVM guests
      xen: clear IRQ_NOAUTOEN and IRQ_NOREQUEST
      xen: Introduce xen_pfn_t for pfn and mfn types
      xen: allow privcmd for HVM guests
      xen/arm: compile and run xenbus

 arch/ia64/include/asm/xen/interface.h      |    7 +-
 arch/x86/include/asm/xen/interface.h       |    7 +
 arch/x86/include/asm/xen/swiotlb-xen.h     |    2 +
 arch/x86/xen/apic.c                        |    3 +-
 arch/x86/xen/enlighten.c                   |   15 ++-
 arch/x86/xen/mmu.c                         |  190 ++++++++++++++++++++++------
 arch/x86/xen/p2m.c                         |   92 +++++++++++++-
 arch/x86/xen/pci-swiotlb-xen.c             |   52 +++++++-
 arch/x86/xen/platform-pci-unplug.c         |    1 +
 arch/x86/xen/setup.c                       |   18 +++
 arch/x86/xen/vga.c                         |    7 +
 arch/x86/xen/xen-head.S                    |   56 ++++++++-
 arch/x86/xen/xen-ops.h                     |    3 +-
 drivers/net/xen-netback/netback.c          |   11 +--
 drivers/pci/xen-pcifront.c                 |   15 ++-
 drivers/tty/hvc/hvc_xen.c                  |    2 +
 drivers/xen/events.c                       |   18 +++-
 drivers/xen/gntdev.c                       |    2 +-
 drivers/xen/grant-table.c                  |   67 +++++++++-
 drivers/xen/privcmd.c                      |  135 +++++++++++++++-----
 drivers/xen/swiotlb-xen.c                  |  119 +++++++++++-------
 drivers/xen/sys-hypervisor.c               |   13 ++-
 drivers/xen/tmem.c                         |    1 +
 drivers/xen/xen-pciback/pci_stub.c         |  136 ++++++++++++++++-----
 drivers/xen/xenbus/xenbus_client.c         |    6 +-
 drivers/xen/xenbus/xenbus_comms.c          |    2 +-
 drivers/xen/xenbus/xenbus_dev_backend.c    |    2 +-
 drivers/xen/xenbus/xenbus_probe.c          |   56 ++++++---
 drivers/xen/xenbus/xenbus_probe_frontend.c |    1 +
 drivers/xen/xenbus/xenbus_xs.c             |    3 +-
 include/linux/swiotlb.h                    |    1 +
 include/xen/grant_table.h                  |   12 ++
 include/xen/interface/grant_table.h        |   12 ++-
 include/xen/interface/memory.h             |    9 +-
 include/xen/interface/platform.h           |    7 +-
 include/xen/interface/version.h            |    3 +
 include/xen/interface/xen.h                |    8 +-
 include/xen/privcmd.h                      |   27 ++++-
 include/xen/swiotlb-xen.h                  |   11 +--
 lib/swiotlb.c                              |   33 ++++--
 40 files changed, 916 insertions(+), 249 deletions(-)

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJQavFvAAoJEFjIrFwIi8fJDxMIAKeMJjmXwo+jbz3ZEss36zIu
ZM1G1TGGWEs/CfiHFlb2CbiLQOijUxkteKUh2NIOVPmmFj/pUk9oXCi6l7bZRxDl
+Z8bWnoCBVx9xOrU8iTVKop+0qvLX8Py4kRy6V8TmVhRe17A2fOX+2kdP4xYRP+h
4lG6JmclUPvgGjgamsp2VXbbkMLF2RsADxLx2hFx1UfnuqhFoMlF8bbsQPwBLXY0
iXap0JNIbQKcBMIlh7Pm2Z7RGbAySzok614avT+lXmPdEj48KBhe27ZGzx/CcI2/
ZOgPLI3ptVfknAsGiamrzbN8+8laeK2GPfZQStdgtczwaFcRzHmZdEuYmLAlzY4=
=gXM4
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
