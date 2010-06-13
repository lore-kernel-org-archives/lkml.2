Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab0FMIQE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 04:16:04 -0400
Received: from ozlabs.org ([203.10.76.45]:54719 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab0FMIP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 04:15:58 -0400
Subject: Re: [PATCH] device-tree: Drop properties with "/" in their name
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Christian Kujau <lists@nerdbynature.de>
Cc: linuxppc-dev@ozlabs.org, monstr@monstr.eu,
       microblaze-uclinux@itee.uq.edu.au, LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Grant Likely <grant.likely@secretlab.ca>
In-Reply-To: <alpine.DEB.2.01.1006130045230.3964@bogon.housecafe.de>
References: <0958c243b32f5f77028a794a9ce0d55f9a12121e.1274272289.git.michael@ellerman.id.au>
	 <alpine.DEB.2.01.1006130045230.3964@bogon.housecafe.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-sp3H1W+3SiC468jqd3YH"
Date: Sun, 13 Jun 2010 18:15:56 +1000
Message-ID: <1276416956.3251.93.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sp3H1W+3SiC468jqd3YH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-06-13 at 00:47 -0700, Christian Kujau wrote:
> On Wed, 19 May 2010 at 22:32, Michael Ellerman wrote:
> > Some bogus firmwares include properties with "/" in their name. This
> > causes problems when creating the /proc/device-tree file system,
> > because the slash is taken to indicate a directory.
> >=20
> > We don't care about those properties, and we don't want to encourage
> > them, so just throw them away when creating /proc/device-tree.
> >=20
> > Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
> > ---
> >=20
> > Hi Christian, if you could test this new patch that'd be great, thanks!
>=20
> I've tested the patch, the Badness is gone and the system is stable as=20
> ever. Will this be pushed to 2.6.35?

Hopefully yes :)

Looks like Ben has deferred it to Grant in patchwork, and he is pretty
busy I think with other OF patches ATM. Maybe he'll grab it or Ben can
pick it up .. guys ? :)

http://patchwork.ozlabs.org/patch/52978/

cheers

> >  fs/proc/proc_devtree.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/fs/proc/proc_devtree.c b/fs/proc/proc_devtree.c
> > index ce94801..d9396a4 100644
> > --- a/fs/proc/proc_devtree.c
> > +++ b/fs/proc/proc_devtree.c
> > @@ -209,6 +209,9 @@ void proc_device_tree_add_node(struct device_node *=
np,
> >  	for (pp =3D np->properties; pp !=3D NULL; pp =3D pp->next) {
> >  		p =3D pp->name;
> > =20
> > +		if (strchr(p, '/'))
> > +			continue;
> > +
> >  		if (duplicate_name(de, p))
> >  			p =3D fixup_name(np, de, p);
> > =20
> > --=20
> > 1.7.0.4
> >=20
> >=20
> >=20
>=20



--=-sp3H1W+3SiC468jqd3YH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkwUk7gACgkQdSjSd0sB4dJKlgCfa/P/28xBz838bEOKFIa0rjSv
AlEAnjcUFm025v08Rm1Hiisv8VLQL96k
=2U1m
-----END PGP SIGNATURE-----

--=-sp3H1W+3SiC468jqd3YH--

