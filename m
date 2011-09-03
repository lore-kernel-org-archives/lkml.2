Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab1ICKza (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 06:55:30 -0400
Received: from aaar.vm.bytemark.co.uk ([80.68.92.230]:56235 "EHLO
	aaar.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab1ICKz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 06:55:28 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, stable@kernel.org,
        linux-kernel@vger.kernel.org, stefan.bader@canonical.com,
        stefano.stabellini@eu.citrix.com
In-Reply-To: <20110831185110.GA11782@kroah.com>
References: <20110822152354.GA24763@dumpdata.com>
	 <1314778698.28989.28.camel@zakaz.uk.xensource.com>
	 <20110831185110.GA11782@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-egDQ6G3jiNbHZT9Wj49X"
Date: Sat, 03 Sep 2011 11:55:08 +0100
Message-ID: <1315047308.19389.1714.camel@dagon.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-SA-Exim-Connect-IP: 192.168.1.7
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: Please back-port git commit
 196cfe2ae8fcdc03b3c7d627e7dfe8c0ce7229f9 and
 89153b5cae9f40c224a5d321665a97bf14220c2c to 3.0.x
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-egDQ6G3jiNbHZT9Wj49X
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-08-31 at 11:51 -0700, Greg KH wrote:
> On Wed, Aug 31, 2011 at 09:18:18AM +0100, Ian Campbell wrote:
> > On Mon, 2011-08-22 at 11:23 -0400, Konrad Rzeszutek Wilk wrote:
> > > Hey Greg,
> > >=20
> > > I've two patches that are in Linus's upstream kernel, but I neglected=
 to
> > > put the stable@kernel.org on them (duh!). Both Fedora and Ubuntu are =
carrying
> > > those two patches - but it would be nice if other distros got them.
> > >=20
> > > The two patches are:
> > >=20
> > > commit 196cfe2ae8fcdc03b3c7d627e7dfe8c0ce7229f9
> > > Author: Stefan Bader <stefan.bader@canonical.com>
> > > Date:   Thu Jul 14 15:30:22 2011 +0200
> > >=20
> > >     xen-blkfront: Drop name and minor adjustments for emulated scsi d=
evices
> > >=20
> > > commit 89153b5cae9f40c224a5d321665a97bf14220c2c
> > > Author: Stefan Bader <stefan.bader@canonical.com>
> > > Date:   Thu Jul 14 15:30:37 2011 +0200
> > >=20
> > >     xen-blkfront: Fix one off warning about name clash
> > >=20
> > > Please back-port them to 3.0.x kernel. Thank=20
> >=20
> > On a related note having this in stable/longterm (including 2.6.32.y)
> > seems like a good idea? (it was already in the 3.0 baseline)
> >=20
> > commit 4352b47ab7918108b389a48d2163c9a4c2aaf139
> > Author: Marek Marczykowski <marmarek@mimuw.edu.pl>
> > Date:   Tue May 3 12:04:52 2011 -0400
> >=20
> >     xen-blkfront: fix data size for xenbus_gather in blkfront_connect
> >    =20
> >     barrier variable is int, not long. This overflow caused another var=
iable
> >     override: "err" (in PV code) and "binfo" (in xenlinux code -
> >     drivers/xen/blkfront/blkfront.c). The later caused incorrect device
> >     flags (RO/removable etc).
> >    =20
> >     Signed-off-by: Marek Marczykowski <marmarek@mimuw.edu.pl>
> >     Acked-by: Ian Campbell <Ian.Campbell@citrix.com>
> >     [v1: Changed title]
> >     Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>=20
> It might, but it doesn't seem to apply to the .32 or .33-longterm
> kernels at all, so I would need a backported version to be able to apply
> it successfully.

This seems to do the trick.

Ian.

=46rom 2a98f42bfd3308e429b6f03b3e5bce43b11bded8 Mon Sep 17 00:00:00 2001
From: Marek Marczykowski <marmarek@mimuw.edu.pl>
Date: Tue, 3 May 2011 12:04:52 -0400
Subject: [PATCH] xen-blkfront: fix data size for xenbus_gather in blkfront_=
connect

barrier variable is int, not long. This overflow caused another variable
override: "err" (in PV code) and "binfo" (in xenlinux code -
drivers/xen/blkfront/blkfront.c). The later caused incorrect device
flags (RO/removable etc).

Signed-off-by: Marek Marczykowski <marmarek@mimuw.edu.pl>
Acked-by: Ian Campbell <Ian.Campbell@citrix.com>
[v1: Changed title]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkfront.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index b8578bb..a2e8977 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -889,7 +889,7 @@ static void blkfront_connect(struct blkfront_info *info=
)
 	}
=20
 	err =3D xenbus_gather(XBT_NIL, info->xbdev->otherend,
-			    "feature-barrier", "%lu", &info->feature_barrier,
+			    "feature-barrier", "%d", &info->feature_barrier,
 			    NULL);
 	if (err)
 		info->feature_barrier =3D 0;
--=20
1.7.2.5


--=20
Ian Campbell


Please don't put a strain on our friendship by asking me to do something
for you.

--=-egDQ6G3jiNbHZT9Wj49X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCgAGBQJOYgeMAAoJEOxjaZd5B0+o6hoP/jGuEq8b0GYEgx54E8rMThge
OXhWI0B36x1seAXdZ4yfpUNTI4SkzmEvxwz9LhA7Pfq+2U1hShQ9SioI0D6O3gl0
B7b4cJvAtqW4kJ+xLy9TANGflSyj5votUAJVi6yULpbuDc3OOwiBh77L0bARNWpP
vl/OUTqD5j0Z5RxMvozrr6rRceKxlst82X2bwBiVk+dVpKw4DgL+BFaCmeXsE87t
Xppd/Bbw3gOBzNa1p+vCxqmdHGnOR4pWisEAtFnxOM7+c8rw6IgJZ5UENNUH6htK
nVwfdv087IyltX5cqrbWhCQhFr/qPpkRQS0QVC6UrMx6DUB4vQDc3iJRFW0fhTCL
HA1VeK0NNbV0bWJ671Ghu9hR0ObbiL9X5LufN4vpH2pMuAxa/PBFuHZClNJ76bRJ
qc+5aj+dZG9A76q6juNHT0McPC1N2wvviGP2VigjDZ3d/TpUoDV2wXuvMoa1d4Z6
TlgXfV8AKIJ5Z68L2jeBDma/LW9nCvY5FJD/TgcT5tGVmPiFGZW1y4Cr2EduNAxE
D1mStaiifyAR3dKcMTpfFrg5vkc+85ML8LcLzj06X9wRY4sn4Dkgl0LiXfR0wxMS
QIYyWjZAlXBvsm3YT2fAEF5AIq18xk1wKyNZLyv7P4fpBfXv2eV3/9ygUgFim65x
Qai0kaBqXBfmXEvmJrHG
=8qi9
-----END PGP SIGNATURE-----

--=-egDQ6G3jiNbHZT9Wj49X--

