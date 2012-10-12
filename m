Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153Ab2JLNT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 09:19:58 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30808 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933011Ab2JLNT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 09:19:57 -0400
Date: Fri, 12 Oct 2012 09:08:01 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.7-rc0-tag for v3.7-rc0
Message-ID: <20121012130800.GD32494@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.7-rc0-tag

which has four bug-fixes and one tiny feature that I forgot to put initially in my tree
due to oversight.

The feature is for kdump kernels to speed up the /proc/vmcore reading. There is a
ram_is_pfn helper function that the different platforms can register for. We are
now doing that.

The bug-fixes cover some embarrassing struct pv_cpu_ops variables being set to NULL
on Xen (but not baremetal). We had a similar issue in the past with {write|read}_msr_safe
and this fills the three missing ones. The other bug-fix is to make the console output
(hvc) be capable of dealing with misbehaving backends and not fall flat on its face.
Lastly, a quirk for older XenBus implementations that came with an ancient v3.4
hypervisor (so RHEL5 based) - reading of certain non-existent attributes just hangs
the guest during bootup - so we take precaution of not doing that on such older
installations.

That is it. Please pull!


 arch/x86/xen/enlighten.c           |   18 +++++++++++++++-
 arch/x86/xen/mmu.c                 |   41 ++++++++++++++++++++++++++++++++++++
 drivers/tty/hvc/hvc_xen.c          |    5 +++-
 drivers/xen/xenbus/xenbus_xs.c     |   21 ++++++++++++++++++
 include/xen/interface/hvm/hvm_op.h |   19 ++++++++++++++++
 5 files changed, 102 insertions(+), 2 deletions(-)

David Vrabel (1):
      xen/hvc: handle backend CLOSED without CLOSING

Konrad Rzeszutek Wilk (3):
      xen/bootup: allow read_tscp call for Xen PV guests.
      xen/bootup: allow {read|write}_cr8 pvops call.
      xen/pv-on-hvm kexec: add quirk for Xen 3.4 and shutdown watches.

Olaf Hering (1):
      xen pv-on-hvm: add pfn_is_ram helper for kdump


--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJQeBYsAAoJEFjIrFwIi8fJ2xcIALBrvKBKAcp2u/Pv0ntqvotD
okU46cIqXVCShioKI6tlP4OwOGlGZo1XIWDQ4UGm8fh1PhogUXJ+uuRws7ELE9Bo
ouBbFTTr+OhdsOlX3+KPtJoKjbjneEIAMAS86i+zTYJ4JDL/B8p02+dn5WQTAiMy
wJ8ErbQqL8ByEyg058tTxc+/AbAKg+fbAeqndNKnMIAvFVCyITKvcP0ye9P7lqrH
IGfzBnNwJW38BqhjjpjPwZWEOfwjfPcePLRJAkoUm95K39pRqDiTDI/UMs2jqE7Z
jWKuXZuGACzW/lcPgGc8HUE6ol7MuOwg8Oz2odEl+pJ+l3b0gCqG4BkbQArcrrI=
=4iLS
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
