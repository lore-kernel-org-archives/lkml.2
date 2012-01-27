Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab2A0Qz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 11:55:59 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:17300 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab2A0Qz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 11:55:58 -0500
Date: Fri, 27 Jan 2012 11:53:30 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: david.vrabel@citrix.com
Subject: [GIT PULL] (xen) stable/for-linus-fixes-3.3 for v3.3-rc1
Message-ID: <20120127165330.GA5624@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4F22D71B.0090,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Linus,

Just two more fixes and I think that is all (I hope) from me until v3.4.

I had to merge in v3.3-rc1 for this branch as one of the fixes was dependent
on the patches that got submitted during this release cycle.
=20
Please git pull:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-li=
nus-fixes-3.3

which has two fixes:
 a) A spinlock issue where the Linux kernel was built with NR_CPUS < 256 we=
 would
    end up corrupting the spinlock. The regression was introduced in v3.2 so
    it is also CC-ing the stable tree.
 b) The granttable v2 looks to not work in HVM domains, and that seems to be
    due to not mapping the status pages. We can do the proper fix in 3.4
    time-frame.

That is it, please pull!

David Vrabel (1):
      x86: xen: size struct xen_spinlock to always fit in arch_spinlock_t

Konrad Rzeszutek Wilk (2):
      Merge commit 'v3.3-rc1' into stable/for-linus-fixes-3.3
      xen/granttable: Disable grant v2 for HVM domains.

 arch/x86/xen/spinlock.c   |   27 ++++++++++++++++++++++-----
 drivers/xen/grant-table.c |    7 +++++--
 2 files changed, 27 insertions(+), 7 deletions(-)

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJPItaEAAoJEFjIrFwIi8fJsGUH/i68q6psElK//KoTqrQM6qx9
vQCc+oMQsKp2RWeHAon/pCJszN2KVgNFuTYP54zP1Th678Z9zRExh6pJJjImxR1t
Nc0DhX+yT/qVczhFBFuW1zhjLPUs1xb6bOnlk9+/NMXhW9JQngHtcgeMmYlJM9E7
F7TxfJpNPhZrMiK/EEw5/uEV19gM2QK1fjRXPXrVVgxRURB87GcyxAC/ESDtjV33
t7yRXER1tHUnNbn0HOI8IoJcAb4xNmCG9iO27GNtBk+PbMqVmO+xhANo5uO+NpmW
GPRFbJkXdAB5xz0KQIKRmKXVYAuoqX6uFJxurt7Sn5eK/nySorft/jot8CPtYcg=
=p5wg
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
