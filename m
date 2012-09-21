Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab2IUNm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 09:42:57 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:30901 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590Ab2IUNmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 09:42:55 -0400
Date: Fri, 21 Sep 2012 09:31:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.6-rc6-tag.
Message-ID: <20120921133153.GA13227@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hey Linus,

Please git pull the following two bug-fixes from:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.6-rc6-tag

which has two bug-fixes. One is a bootup that we had ignored until we found
that on DL380 G6 it was needed. The other is more recent - in v3.5 we added
batching for M2P override (Machine Frame Number -> Physical Frame Number), but
the original MFN was saved in an incorrect structure - and we would oops/restore
when restoring with the old MFN. Both of them CC the stable train. Please pull!

Konrad Rzeszutek Wilk (1):
      xen/boot: Disable BIOS SMP MP table search.

Stefano Stabellini (1):
      xen/m2p: do not reuse kmap_op->dev_bus_addr

arch/x86/include/asm/xen/page.h     |    3 ++-
 arch/x86/xen/enlighten.c            |    4 ++++
 arch/x86/xen/p2m.c                  |   27 +++++++++++----------------
 drivers/block/xen-blkback/blkback.c |    2 +-
 drivers/xen/gntdev.c                |    5 +++--
 drivers/xen/grant-table.c           |    6 ++++--
 include/xen/grant_table.h           |    3 ++-
 7 files changed, 27 insertions(+), 23 deletions(-)

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJQXGw3AAoJEFjIrFwIi8fJizUIAKdZSdxmQ4Dajm3UnPUbmUuk
u3CGIovXWZ6hmkqv6DBy+Y6+tn91QgePYtEfvHJ7J5DPPj60Cb/VZ/XRagGGPvMy
BC7LmPESkGzMrw+jzMlCPi1FmhJmVX7KSm5i7b85ejazPhQFwooJD169kAzwUJ1M
bfuxHl69VBuQIEPb0giLEO2soql+A+YDGYPMPcOxExv3NrHHi2F4czW8QIzkKUEe
eYHtylVM5zmkLZHVhk15uPG7Fx1aHI/iiY3w8tDcobbYTnbkMPSVXRdIAXV7cIZW
3dZAHctk9Vsqgj2uWVoOyzOTeaNBrWcnrUZ/BCDCBD2+e8Vu0Zgl5VUw3Xd3TDg=
=dsf9
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
