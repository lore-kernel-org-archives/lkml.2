Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759258Ab1LORXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 12:23:34 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:54020 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759000Ab1LORXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 12:23:33 -0500
Date: Thu, 15 Dec 2011 12:22:22 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Leonid.Kalev@ca.com, Neal.Taylor@ca.com, george.shuklin@gmail.com,
        david.vrabel@citrix.com, ian.campbell@citrix.com
Subject: [GIT PULL] (xen) stable/for-linus-fixes-3.2 for 3.2-rc6
Message-ID: <20111215172222.GD7272@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4EEA2D0A.00AD,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull this branch:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-fixes-3.2

which has two bug-fixes found recently. One of them is for how memory
is populated for a guest when the 'max memory' vs 'the initial amount of memory
the guest is going to launch with' is different. We used the wrong metric resulting
in capping the memory to 'the initial amount of  memory the guest is going to launch
with' and never being able to go to 'max memory'. The other bug is a boot-up bug found
with Dell hardware were none of the PCI devices were able to set their DMA mask. The fix
is rather embarrassing as I was the one who committed a similar fix to generic SWIOTLB a
year ago and completly forgot to propagate it to the Xen SWIOTLB library.

Please pull!

 arch/x86/xen/setup.c      |   18 +++++++++++++++---
 drivers/xen/swiotlb-xen.c |    4 ++--
 2 files changed, 17 insertions(+), 5 deletions(-)

Ian Campbell (1):
      xen: only limit memory map to maximum reservation for domain 0.

Konrad Rzeszutek Wilk (1):
      xen/swiotlb: Use page alignment for early buffer allocation.


--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJO6izJAAoJEFjIrFwIi8fJsboH/imFThWU+psNBOMYcy5rD2GT
MTv3sD2xKbdB6TMHEg/rol80BUVzbI2v1gJXbS2kfP9BZnLr7XAjeiqFzN4Gkhc8
uWSFeLawAwvnC75LRNiisF4GvORhGdbTtkcwlNP+zOqlcjT2gKchWPfxbTIeXUVz
hOR4T7r3q0mmsOGgPC1VDu7NDOFUfanf+ICUTNG5jJdLWN4nQzEl11i+5l1vyjUs
tKc9kI5NJ41O5JaQN892iwRwZgKI2BlmgNI4cR8mxn7eFYIKlXPRty5bSq6PtR39
XIM6vteavDdwSwfQf685NGxwf2xi35vN3RtP7/ul0VLTu0dy3Ux2uvR+/ji3Qf4=
=Mm5t
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
