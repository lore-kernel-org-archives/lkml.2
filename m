Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab2HNOZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:25:12 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:41241 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289Ab2HNOZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:25:04 -0400
Date: Tue, 14 Aug 2012 10:15:14 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.6-rc1-tag
Message-ID: <20120814141513.GA17776@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please pull this tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.6-rc1-tag

which has just one tiny fix - way back in v3.5 we added a mechanism to populate
back pages that were released (they overlapped with MMIO regions), but neglected to
reserve the proper amount of virtual space for extend_brk to work properly. Coincidentally
some other commit aligned the _brk space to larger area so I didn't trigger this until
it was run on a machine with more than 2GB of MMIO space.

 arch/x86/xen/p2m.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

Konrad Rzeszutek Wilk (1):
      xen/p2m: Reserve 8MB of _brk space for P2M leafs when populating back.


--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJQKl1rAAoJEFjIrFwIi8fJIzQIAM7KCWmrmf3pMFClEoeRzDB/
Ywtut3KZvbP+h35LGJvHBLURishtGRrmuW1aubb/J1TyE+z++6p/IEzArYZ6BjOY
eNFqCCPV8atQYJe1kRpHW1pJggHjIsQ7w3KP7bM6+0ROG3EXtgUh2oBybKN5YfWX
vz7Ol6RteTq1ElbQ1TrhyxN/4EkWHof8pViR677ofWhjKajRdF2aP5MF3oggAqg1
C8tZFkD9D0tf+JQKO00HSVmIGcY63EsceOt9+RuARQzI8zecyS9me3/99gWGsHSx
mDBigjxzWGfSTZC9R84WUmyLL98pIjNutdLvvsyfSBz+akd8xaOqWMWLpvBdwLU=
=wRra
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
