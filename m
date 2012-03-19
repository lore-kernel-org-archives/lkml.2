Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab2CSQAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:00:42 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:37868 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145Ab2CSQAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:00:39 -0400
Date: Mon, 19 Mar 2012 11:27:10 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] (xen) git pull stable/for-linus-3.4-tag for 3.4-rc0
Message-ID: <20120319152709.GA3649@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090206.4F675826.009D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull this tag for your v3.4-rc0 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.4-tag

which has three neat features:
 - PV multiconsole support, so that there can be hvc1, hvc2, etc; This can
   be used in HVM and in PV mode.

 - P-state and C-state power management driver that uploads said
   power management data to the hypervisor. It also inhibits cpufreq
   scaling drivers to load so that only the hypervisor can make power
   management decisions - fixing a weird perf bug. There is one thing
   in the Kconfig that you won't like: "default y if (X86_ACPI_CPUFREQ = y ||
   X86_POWERNOW_K8 = y)" (note, that it all depends on CONFIG_XEN which depends
   on CONFIG_PARAVIRT which by default is off). I've a fix to convert that
   boolean expression into "default m" which I am going to post after the
   cpufreq git pull - as the two patches to make this work depend on a fix in
   Dave Jones's tree.

 - Function Level Reset (FLR) support in the Xen PCI backend.

Fixes:
 - Kconfig dependencies for Xen PV keyboard and video
 - Compile warnings and constify fixes
 - Change over to use percpu_xxx instead of this_cpu_xxx

That is it! Please pull!

Alex Shi (1):
      xen: use this_cpu_xxx replace percpu_xxx funcs

Andrew Jones (1):
      xen kconfig: relax INPUT_XEN_KBDDEV_FRONTEND deps

Jan Beulich (3):
      xenbus: address compiler warnings
      xenbus: don't free other end details too early
      xen: constify all instances of "struct attribute_group"

Konrad Rzeszutek Wilk (6):
      pci: Introduce __pci_reset_function_locked to be used when holding device_lock.
      xen/pciback: Support pci_reset_function, aka FLR or D3 support.
      xen/setup/pm/acpi: Remove the call to boot_option_idle_override.
      xen/enlighten: Expose MWAIT and MWAIT_LEAF if hypervisor OKs it.
      xen/acpi-processor: C and P-state driver that uploads said data to hypervisor.
      Merge commit 'stable/for-linus-3.4-tag' into HEAD

Stefano Stabellini (4):
      hvc_xen: support PV on HVM consoles
      hvc_xen: implement multiconsole support
      hvc_xen: introduce HVC_XEN_FRONTEND
      xen/xenbus: ignore console/0

Tang Liang (1):
      xen: Utilize the restore_msi_irqs hook.

 arch/ia64/include/asm/xen/interface.h      |    1 +
 arch/x86/include/asm/xen/interface.h       |    1 +
 arch/x86/pci/xen.c                         |   27 ++
 arch/x86/xen/enlighten.c                   |   99 +++++-
 arch/x86/xen/irq.c                         |    8 +-
 arch/x86/xen/mmu.c                         |   20 +-
 arch/x86/xen/multicalls.h                  |    2 +-
 arch/x86/xen/setup.c                       |    1 -
 arch/x86/xen/smp.c                         |    2 +-
 drivers/input/misc/Kconfig                 |    2 +-
 drivers/pci/pci.c                          |   25 ++
 drivers/tty/hvc/Kconfig                    |    8 +
 drivers/tty/hvc/hvc_xen.c                  |  465 +++++++++++++++++++++---
 drivers/video/Kconfig                      |    1 +
 drivers/xen/Kconfig                        |   17 +
 drivers/xen/Makefile                       |    2 +-
 drivers/xen/sys-hypervisor.c               |    6 +-
 drivers/xen/xen-acpi-processor.c           |  562 ++++++++++++++++++++++++++++
 drivers/xen/xen-balloon.c                  |    2 +-
 drivers/xen/xen-pciback/pci_stub.c         |   41 ++-
 drivers/xen/xen-pciback/pciback.h          |    1 +
 drivers/xen/xen-selfballoon.c              |    2 +-
 drivers/xen/xenbus/xenbus_client.c         |    6 +-
 drivers/xen/xenbus/xenbus_probe.c          |    3 +-
 drivers/xen/xenbus/xenbus_probe_frontend.c |    6 +
 include/linux/pci.h                        |    1 +
 include/xen/interface/hvm/params.h         |    6 +-
 include/xen/interface/physdev.h            |    7 +
 include/xen/interface/platform.h           |   20 +-
 29 files changed, 1264 insertions(+), 80 deletions(-)

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJPZ1BHAAoJEFjIrFwIi8fJecEIALs+EUd2KlgzEwQ2l9lpk1kv
cDYt/CFUbMMX/Cm08JDDRqrSEDRoAgkFZhB3swzS7anUW8z+IVL5nmwdUSGqap98
a59P56Ev5Ev4xtLTGoi5q8FLxuFeXDxvnd9bxy4tPZfETY1vgPlKzSdKfJFmCYIQ
6gHAs1svsRVEDJbftx7t8mXzRrRDPjaV1ThqbWs1i6jbcWkYtS66lJBL7zQAMuJN
x/kDvF/0y/6kSHdgHlb1XtfSmjLVdWEEPbtOAcAIMQgMGyRaf9RupPX7RnJ0lVyR
wgbnQl9AnqF31Z2uNHluq0xPFIVIZcnKuBpdkCA5dXDpSuk7r+oI77WYDxut5DM=
=J7fU
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
