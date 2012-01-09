Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701Ab2AIR2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 12:28:46 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:59786 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429Ab2AIR2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 12:28:45 -0500
Date: Mon, 9 Jan 2012 12:25:49 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: ian.campbell@citrix.com, JBeulich@suse.com, annie.li@oracle.com,
        waldi@debian.org, dgdegra@tycho.nsa.gov, david.vrabel@citrix.com,
        julia@diku.dk, tony.luck@intel.com, maxim.uvarov@oracle.com,
        anil@recoil.org, dkiper@net-space.pl, rdunlap@xenotime.net,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [GIT PULL] (xen) stable/for-linus-3.3 patches for 3.3-rc0
Message-ID: <20120109172549.GA31352@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090203.4F0B2390.008C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following git branch:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.3

There are eight exciting patchsets in this branch:
 - SysFS documentation updates. We are slowly updating them to make sure that the SysFS
   entires are properly documented.
 - Making the grant system able to use more fancier types of grants to speed-up
   guest to guest exchange of data (sub-page and transitive grants).
 - Updates in the backends to be able to export the Xen backends in an
   Hardware Virtualized Management (HVM) guest. We usually export those backends in
   the initial domain (dom0), but are moving slowly to make it possible to do it any guest
   (PV or HVM).
 - Better driver to deal with memory type ioctls calls. In the past we were doing
   ioctls on /proc/xen/priv_cmd (yuck) and with this are moving to doing it in
   /dev/xen/priv_cmd.
 - Fix a security issues were the guest could try to send a nasty (out of band)
   message and potentially cause mishap.
 - Remove duplicate initialization fields in the backend drivers.
 - Jeremy is now working for a fancy new startup so changing the MAINTAINERS file to
   reflect that his contribution are done during his private time.
 - Sensible config options. We had some that weren't all that good so adjusting
   them properly.
 - Bug-fixes.

That is it! Please push

Annie Li (7):
      xen/granttable: Introducing grant table V2 stucture
      xen/granttable: Refactor some code
      xen/granttable: Grant tables V2 implementation
      xen/granttable: Keep code format clean
      xen/granttable: Improve comments for function pointers
      xen/granttable: Support sub-page grants
      xen/granttable: Support transitive grants

Bastian Blank (5):
      xen: Add privcmd device driver
      xen: Add xenbus device driver
      xen: Add xenbus_backend device
      xen/privcmd: Remove unused support for arch specific privcmp mmap
      xen/xenbus-frontend: Make error message more clear

Daniel De Graaf (10):
      xen/gntalloc: Change gref_lock to a mutex
      xen/gnt{dev,alloc}: reserve event channels for notify
      xen/event: Add reference counting to event channels
      xen/events: prevent calling evtchn_get on invalid channels
      xen/gntalloc: release grant references on page free
      xen/gntalloc: fix reference counts on multi-page mappings
      xenbus: Support HVM backends
      xenbus: Use grant-table wrapper functions
      xen/grant-table: Support mappings required by blkback
      xen/netback: Enable netback on HVM guests

David Vrabel (2):
      xen: document balloon driver sysfs files
      xen: document backend sysfs files

Ian Campbell (3):
      xen/xenbus: Reject replies with payload > XENSTORE_PAYLOAD_MAX.
      xenbus: maximum buffer size is XENSTORE_PAYLOAD_MAX
      xen/xenbus: don't reimplement kvasprintf via a fixed size buffer

Jan Beulich (1):
      Xen: consolidate and simplify struct xenbus_driver instantiation

Jeremy Fitzhardinge (1):
      Xen: update MAINTAINER info

Julia Lawall (1):
      xen-gntalloc: introduce missing kfree

Konrad Rzeszutek Wilk (7):
      Merge branch 'stable/docs-for-3.3' into stable/for-linus-3.3
      xen/xenbus-frontend: Fix compile error with randconfig
      Merge commit 'v3.2-rc3' into stable/for-linus-3.3
      xen/xenbus: Fix compile error - missing header for xen_initial_domain()
      xen/pciback: Move the PCI_DEV_FLAGS_ASSIGNED ops to the "[un|]bind"
      xen/pciback: Fix "device has been assigned to X domain!" warning
      xen/pciback: Expand the warning message to include domain id.

Maxim Uvarov (1):
      xen: Make XEN_MAX_DOMAIN_MEMORY have more sensible defaults

Tony Luck (1):
      xen/ia64: fix build breakage because of conflicting u64 guest handles


 Documentation/ABI/stable/sysfs-bus-xen-backend     |   75 +++
 .../ABI/stable/sysfs-devices-system-xen_memory     |   77 +++
 arch/ia64/include/asm/xen/interface.h              |    2 +-
 arch/x86/xen/Kconfig                               |    4 +-
 arch/x86/xen/grant-table.c                         |   44 ++-
 drivers/block/xen-blkback/xenbus.c                 |    9 +-
 drivers/block/xen-blkfront.c                       |   11 +-
 drivers/input/misc/xen-kbdfront.c                  |    7 +-
 drivers/net/xen-netback/netback.c                  |    2 +-
 drivers/net/xen-netback/xenbus.c                   |    9 +-
 drivers/net/xen-netfront.c                         |    9 +-
 drivers/pci/xen-pcifront.c                         |   11 +-
 drivers/video/xen-fbfront.c                        |    9 +-
 drivers/xen/Kconfig                                |    7 +
 drivers/xen/Makefile                               |    2 +
 drivers/xen/events.c                               |   77 +++-
 drivers/xen/evtchn.c                               |    2 +-
 drivers/xen/gntalloc.c                             |  121 +++--
 drivers/xen/gntdev.c                               |   34 +-
 drivers/xen/grant-table.c                          |  518 ++++++++++++++--
 drivers/xen/privcmd.c                              |  435 ++++++++++++++
 drivers/xen/privcmd.h                              |    3 +
 drivers/xen/xen-pciback/pci_stub.c                 |    4 +
 drivers/xen/xen-pciback/xenbus.c                   |   19 +-
 drivers/xen/xenbus/Makefile                        |    2 +
 drivers/xen/xenbus/xenbus_client.c                 |  193 +++++-
 drivers/xen/xenbus/xenbus_comms.h                  |    4 +
 drivers/xen/xenbus/xenbus_dev_backend.c            |   90 +++
 drivers/xen/xenbus/xenbus_dev_frontend.c           |  625 ++++++++++++++++++++
 drivers/xen/xenbus/xenbus_probe.c                  |    9 +-
 drivers/xen/xenbus/xenbus_probe.h                  |    6 +-
 drivers/xen/xenbus/xenbus_probe_backend.c          |    8 +-
 drivers/xen/xenbus/xenbus_probe_frontend.c         |    8 +-
 drivers/xen/xenbus/xenbus_xs.c                     |   23 +-
 drivers/xen/xenfs/Makefile                         |    2 +-
 drivers/xen/xenfs/privcmd.c                        |  400 -------------
 drivers/xen/xenfs/super.c                          |    6 +-
 drivers/xen/xenfs/xenbus.c                         |  593 -------------------
 drivers/xen/xenfs/xenfs.h                          |    2 -
 include/xen/events.h                               |    7 +
 include/xen/grant_table.h                          |   37 +-
 include/xen/interface/grant_table.h                |  167 +++++-
 include/xen/interface/io/xs_wire.h                 |    3 +
 include/xen/interface/xen.h                        |    2 +
 include/xen/xenbus.h                               |   31 +-
 include/xen/xenbus_dev.h                           |   41 ++
 46 files changed, 2499 insertions(+), 1251 deletions(-)

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJPCyMYAAoJEFjIrFwIi8fJGj0H/3AAJu5IfSI6CiPi02QgNt46
s9klXwM6qSbsbWzLRFfizBQuu9pRtVP9mkZrwVcHdcnbJVPt7MUp6GylfVv7ZUcw
BKciISriDyqzOcn+TWxr0N7F7cLCOlp8wPedMjcGKaqQntynm/mrYpWBEwMfbssN
u+XlH/DkGDwCy0Rih3T4zz5BxdeqLqttlms3GqyNdu2BPhJQ6ApVjhh+iEvBh9fK
0kwDyQDu9i62OG6rPdW+bF0QU8SKHONFRS1bY8PtMTdG9hBEt24/TZl5A8G6x5kn
4DN7DFhMmcoEMs6zaFaxZDD3EMD6UuhbKWW1reKZw5Eq3Ck4/Q34C/9scePd8uk=
=yDUp
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
