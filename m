Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab2JHLRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 07:17:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:18660 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941Ab2JHLRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 07:17:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,553,1344236400"; 
   d="asc'?scan'208";a="231953719"
Message-ID: <1349695030.1992.48.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBI fastmap for 3.7-rc1
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        Richard Weinberger <richard@nod.at>
Date: Mon, 08 Oct 2012 14:17:10 +0300
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-oCJ/2+1oCBFtOk6T8X9W"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oCJ/2+1oCBFtOk6T8X9W
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

here is the second UBI pull request which contains a big new
experimental feature. Please, pull with my apologies that it was exposed
to linux-next for shorter time than I usually do. Details are in the
signed tag.

Thanks!

The following changes since commit 55393ba1bdedc5ded79b34b4cc08898a7776cddb=
:

  UBI: fix trivial typo 'it' =3D> 'is' (2012-09-26 13:22:50 +0300)

are available in the git repository at:

  git://git.infradead.org/linux-ubi.git tags/upstream-3.7-rc1-fastmap

for you to fetch changes up to 76ac66e469f084d41742ba08923de76fbdc7dce3:

  UBI: Wire-up fastmap (2012-10-03 16:39:37 +0300)

----------------------------------------------------------------
This pull request contains the UBI fastmap support implemented by Richard
Weinberger from Linutronix. Fastmap is designed to address UBI's slow scann=
ing
issues. Namely, it introduces a new on-flash data-structure called "fastmap=
",
which stores the information about logical<->physical eraseblocks mappings.
So now to get this information just read the fastmap, instead of doing full
scan. More information here can be found in Richard's announcement in LKML
(Subject: UBI: Fastmap request for inclusion (v19)):

http://thread.gmane.org/gmane.linux.kernel/1364922/focus=3D1369109

One thing I want to explicitly say is that fastmap did not have large
enough linux-next exposure. It is partially my fault - I did not respond
quickly enough. I _really_ apologize for this. But it had good testing and
disabled by default, so I do not expect that we'll break anything.

Fastmap is declared as experimental so far, and it is off by default. We
did declare that the on-flash format may be changed. The reason for this is
that no one used it in real production so far, so there is a high risk that
something is missing. Besides, we do not have user-space tools supporting
fastmap so far.

Nevertheless, I suggest we merge this feature. Many people want UBI's scann=
ing
bottleneck to be fixed and merging fastmap now should accelerate its produc=
tion
use. The plan is to make it bullet-prove, somewhat clean-up, and make it th=
e
default for UBI. I do not know how many kernel releases will it take.

Basically, I what I want to do for fastmap is something like Linus did for
btrfs few years ago.

----------------------------------------------------------------
Richard Weinberger (10):
      UBI: Add fastmap on-flash data structures
      UBI: Add fastmap stuff to ubi.h
      UBI: Export next_sqnum()
      UBI: Add self_check_eba()
      UBI: Add fastmap bits to build.c
      UBI: Wire-up ->fm_sem
      UBI: Add fastmap stuff to attach.c
      UBI: Add fastmap support to the WL sub-system
      UBI: Add fastmap core
      UBI: Wire-up fastmap

 MAINTAINERS                 |    6 +
 drivers/mtd/ubi/Kconfig     |   21 +++
 drivers/mtd/ubi/Makefile    |    1 +
 drivers/mtd/ubi/attach.c    |  386 ++++++++++++++++++++++++++++++++-------=
---------
 drivers/mtd/ubi/build.c     |   70 ++++++++-
 drivers/mtd/ubi/eba.c       |  126 ++++++++++++++--
 drivers/mtd/ubi/fastmap.c   | 1537 +++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
++
 drivers/mtd/ubi/ubi-media.h |  137 +++++++++++++++++
 drivers/mtd/ubi/ubi.h       |  118 ++++++++++++++-
 drivers/mtd/ubi/wl.c        |  599 +++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++++++++++++---------
 10 files changed, 2790 insertions(+), 211 deletions(-)
 create mode 100644 drivers/mtd/ubi/fastmap.c

--=20
Best Regards,
Artem Bityutskiy

--=-oCJ/2+1oCBFtOk6T8X9W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQcrY2AAoJECmIfjd9wqK0bT8P/RWqQtTiDOylBSeEtFNSpk2q
ejUR4IhGJZjJTcPv9fuXsixTpHyKvDhyam00PIe89QribFe5+9bVVR45VDN8aQYs
PG+xuIP1/MUAbTIVfDMgTkZLR7Lbweg31W0lA7KaaUBkfpzf74obiQEtzDukR1tY
Wk409d0iksz45Vgp4MFKeYVgC69IVYE+Mq97pL5rRz/sILVrmvE98rA5H5KyZLBa
BrAJWvU6jg1XKVm1YZjIoy2LiIdCgCEOUvs7C6Y6PGu0nHsKqaGtsdWNPYhXLdtD
mSPxcKz2fssO7EK7cexVX+/R6Pz1OyCiDcxUkplC74oI5Cq5A0gOlHyS6HLIslyP
0nXj8dX7yDR06gqxC0Cl4zZJOr1ZO6057AlZrZJXGBXYqhSLzjNRRtchrUIkCQy/
ZzR7c6HWHeOBbgQamYJYnhQmpGiQ4Oa774SujQFBxIN2C2Bu1t6q71FNB0/GS6y0
Bw9R6meKxOt0unvzTpilKm6RJqpF9U9z7Fd1wdD4ia3cslhl6zMXTpVOIigiWiyD
OJ0+N8eJprfU2G1z3qPRCuNUcjcoRcdb6uyiql/eW7Vnw/vs2KlQCQdEwdjwBrTf
T4EW7qdve3pmfSZaMxe95h4OAXVS2FztgnqnUl2K1/FrBv9Jn2Vm4cvPg5ydiG52
BjFKWV2iv+OonxAuA+U1
=WLCA
-----END PGP SIGNATURE-----

--=-oCJ/2+1oCBFtOk6T8X9W--

