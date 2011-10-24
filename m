Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab1JXNIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 09:08:16 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:63358 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510Ab1JXNIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 09:08:04 -0400
Date: Mon, 24 Oct 2011 08:54:48 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, dgdegra@tycho.nsa.gov, jbeulich@novell.com,
        olaf@aepfle.de, rdunlap@xenotime.net, stefano.stabellini@eu.citrix.com,
        thomas@m3y3r.de, Ian.Campbell@citrix.com
Subject: [GIT PULL] (xen) stable/drivers-3.2, stable/drivers.bugfixes-3.2 and
 stable/pci.fixes-3.2 for Linux 3.2-rc0
Message-ID: <20111024125448.GA19100@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4EA56325.0007,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please pull the three following git branches:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git  stable/drivers-3.2 stable/drivers.bugfixes-3.2  stable/pci.fixes-3.2

wherein:

#stable/drivers-3.2 is based on git commit 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe (Linux 3.0)
and contains improvements the XenBus driver to reset and restart PV drivers when a guest
is kexec/kdump-ing itself. Also we modify the XenBus subsystem to allow the daemon (which
is in charge all of the XenBus directories/files/attributes) to be present in any domain - not
just the initial one. This slowly paves the way for disegregating guests and allowing device
driver domains.

#stable/drivers.bugfixes-3.2 is based on git commit b6fd41e29dea9c6753b1843a77e50433e6123bcb (Linux 3.1-rc6)
and contains bug-fixes to the Xen PCI backend driver and as well the Xen PCI platform driver.
Nothing really exciting in there - just the normal variety of bug-fixes found
during 3.1 cycle.

#stable/pci.fixes-3.2 is based on git commit 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe (Linux 3.0)
and contains fixes to the Xen PCI frontend driver and the Xen SWIOTLB driver (fixes that
were in the native SWIOTLB driver). Also there is now support for multi-PCI domain boxes,
better reporting of errors, and checking by Xen SWIOTLB of arguments so that it won't
have to do needless work.

The credit list is as follow:

Dan Carpenter (1):
      xen/pciback: double lock typo

Daniel De Graaf (2):
      xenbus: Fix loopback event channel assuming domain 0
      xenbus: don't rely on xen_initial_domain to detect local xenstore

Jan Beulich (4):
      xen/pci: make bus notifier handler return sane values
      xen/pciback: use mutex rather than spinlock in passthrough backend
      xen/pciback: miscellaneous adjustments
      xen/pci: support multi-segment systems

Konrad Rzeszutek Wilk (9):
      xen-pcifront: Update warning comment to use 'e820_host' option.
      xen-swiotlb: Retry up three times to allocate Xen-SWIOTLB
      xen-swiotlb: Fix wrong panic.
      xen-swiotlb: When doing coherent alloc/dealloc check before swizzling the MFNs.
      xen/pciback: Use mutexes when working with Xenbus state transitions.
      xen/pciback: use mutex rather than spinlock in vpci backend
      xen/pv-on-hvm:kexec: Fix implicit declaration of function 'xen_hvm_domain'
      xen/pciback: Do not dereference psdev during printk when it is NULL.
      xen/pciback: Check if the device is found instead of blindly assuming so.

Olaf Hering (5):
      xen/pv-on-hvm kexec: prevent crash in xenwatch_thread() when stale watch events arrive
      xen/pv-on-hvm kexec: rebind virqs to existing eventchannel ports
      xen/pv-on-hvm kexec+kdump: reset PV devices in kexec or crash kernel
      xen/pv-on-hvm kexec: update xs_wire.h:xsd_sockmsg_type from xen-unstable
      xen/pv-on-hvm kexec: add xs_reset_watches to shutdown watches from old kernel

Randy Dunlap (1):
      xen-swiotlb: fix printk and panic args

Stefano Stabellini (2):
      xen: XEN_PVHVM depends on PCI
      xen: remove XEN_PLATFORM_PCI config option

Thomas Meyer (1):
      xen/pciback: use resource_size()


 arch/x86/pci/xen.c                          |   22 ++++-
 arch/x86/xen/Kconfig                        |    3 +-
 drivers/pci/xen-pcifront.c                  |    5 +-
 drivers/xen/Kconfig                         |   10 --
 drivers/xen/Makefile                        |    4 +-
 drivers/xen/events.c                        |   37 +++++++-
 drivers/xen/pci.c                           |  105 ++++++++++++++++++++---
 drivers/xen/swiotlb-xen.c                   |   70 ++++++++++++----
 drivers/xen/xen-pciback/conf_space.c        |    1 -
 drivers/xen/xen-pciback/conf_space_header.c |    5 +-
 drivers/xen/xen-pciback/conf_space_quirks.c |    3 +-
 drivers/xen/xen-pciback/passthrough.c       |   34 +++-----
 drivers/xen/xen-pciback/pci_stub.c          |   35 ++++-----
 drivers/xen/xen-pciback/pciback.h           |   32 +++++---
 drivers/xen/xen-pciback/pciback_ops.c       |    1 -
 drivers/xen/xen-pciback/vpci.c              |   35 ++++-----
 drivers/xen/xen-pciback/xenbus.c            |   27 +++----
 drivers/xen/xenbus/xenbus_comms.c           |    4 +-
 drivers/xen/xenbus/xenbus_probe.c           |  101 ++++++++++++-----------
 drivers/xen/xenbus/xenbus_probe_frontend.c  |  121 +++++++++++++++++++++++++++
 drivers/xen/xenbus/xenbus_xs.c              |   17 ++++-
 include/xen/interface/io/xs_wire.h          |    6 +-
 include/xen/interface/physdev.h             |   34 +++++++-
 23 files changed, 507 insertions(+), 205 deletions(-)

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOpWAXAAoJEFKFlzJcLqlYLYQP/j7e8hFoHIezjc7c1R2JGzhK
wnMfoJdgbHvH8U6/m+VxJLDOq4rJavrYMtGERRiAEw/H2w/Fsp2HsNThtbKkiXSl
tPOQC11+7YUZ/FPFrvTLsTlvrgFNiVOu51PgZXBhYHqAG9TVrldBi4t9jqGD8NX9
93iT8X9nfiO73XkJ21T/37yYb2OQpzg8svIF5Fj3DLBNj08b3mPgH3VFhCbOmhds
+0JdyKV97UxA8NcDVFNQiT+mOmKTX12UI+dfFF9Pb+IRnzFW6LKUjV2F0fJfhQ0y
AX0fn43tqXN6J/BPh9X+iiQAUCR+WJ/AVofOsYQ6wcUvjsyKtehaEMoOY2rGg5Ld
5SMFHcEf5p1jExXM7Q1NQDPPhE8BoVrt7yOjmIcbn41SOU3hqt4ohPy+aTRjVchE
8Gx6Z9i5u9KdUcBrahdeeaeEhvmqgeFvujYngtgcxgWytO4ho/jo3r8y6C6pCcLK
eqfea1dP1x67cB4p6o5pefxa5pKPTu/nl0RA4E4RuIT9f79CQclN/fAZCZxkJ63g
uK+E5VR5GTiiRstX2OJXVLvFeP7sQ0xiiL6zVUlJiHtoecmCpwebTlz0OZ2o1WX+
TcDP/P781jGUtfUyNc8UNEeb+nXiF2iH/YfxHJjOCXnpwODjsxtXsYiXa4SB121v
w2ugURq0f+jXhuGwkEfX
=x5vS
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
