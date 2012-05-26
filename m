Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab2EZNb2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 09:31:28 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:63786 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751694Ab2EZNb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 09:31:27 -0400
Message-ID: <1338039083.2525.27.camel@koala>
Subject: Re: [PATCH] UBIFS: compute KSA size and store in superblock
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sat, 26 May 2012 16:31:23 +0300
In-Reply-To: <alpine.DEB.2.00.1205261303000.9892@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205251509220.2989@eristoteles.iwoars.net>
	 <1337952271.30969.37.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1205261303000.9892@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-RhALlU5TcFxPQsPFj7VQ"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RhALlU5TcFxPQsPFj7VQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

BTW! While I remember this. You had a concern about bad blocks. I was
thinking that UBI can notify UBIFS every time it marks a block as bad
using the linux notifiers mechanism. UBI would tell UBIFS the volume id
and leb number. Then UBIFS could asynchronously do all the security
stuff which is required in the background thread, or by submitting a
work. I think this is doable, but certainly not a priority.

On Sat, 2012-05-26 at 13:21 +0200, Joel Reardon wrote:
> >
> > I do not have to time to review it now, but please, make sure that the
> > KSA size is according to 'max_leb_cnt' (see the --max-leb-cnt of the
> > mkfs.ubifs tool).
>=20
> Ahh, I see now I also need to add the min number of lebs to min_leb_cnt i=
f
> the feature is enabled.

Not sure what you mean...

> > Also, think about this use-case in general: you have
> > UBI volume of size X, then the volume is resized to Y > X, then mounted
> > - UBIFS should work and resize itself to Y, up to the 'max_leb_cnt'. If
> > Y > 'max_leb_cnt', we resize only to 'max_leb_cnt'.
>=20
> For this case, it should be fine if the KSA is sized to maxlebcnt.
> However, it will remain that size regardless of the real leb_cnt.

Yes, that's the idea. The lprops area behaves the same. This area stores
a small object for each LEB, so the more LEBs we have, the larger lprops
area is. And 'max_leb_cnt' defines lprops size. We can easily resize up
to 'max_leb_cnt' but re-sizing more than that is currently impossible.

> In general, removing KSA blocks is possible, but if datanodes are
> encrypted with keys on those blocks, then they must be re-encrypted with =
a
> different key on the smaller set (or somehow write the new last KSA block
> containing all the used keys from the removed KSA blocks along with a
> relocation table, but this seems like alot of coding if removing LEBs fro=
m
> the KSA isn't that important.)

Sure, no need to remove. Create them according to 'max_leb_cnt' and
that's it.

--=20
Best Regards,
Artem Bityutskiy

--=-RhALlU5TcFxPQsPFj7VQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPwNsrAAoJECmIfjd9wqK0cZoQAMuv/10qy3ky+wj2DFhlW4b5
PYQMdWQx70g37DLkgOa/HdkR+rRH/ewYN53BBDhRsCVYvSyzLERLljPPxjniug3f
tosyWeq3NbMyn/uCTyYS5yEJCVw8damBYLYvobD6mLwT/zNAt3fLIl7d5qdo7Wfi
cXBp46XoLV5qXQv2D3AwuvzJoER1eRTP3B+PE++qg8bAqrOUsNqN6zR7J4dzWfTX
aIARLkH5t1BBc1JRT6qL+bwCv1tosjxFjjqzCBmXWHEOqKbJWN0Om7U71/XtFnPS
xeqmH/RXcUr8e0yZiT5f33FxOaGcW9YUf5pikKW5tCB/jPhQHULay7NefS/FTLXY
5AZ2jnSkvLYBei1cZkmoTqQ2NohRHpIZBUPtZjH3nCOqsNWlF4pfBlMVnO/VkPot
TY/itH9hdkmQQ/NvmylM7YfcItPU32nB3fbpxEsOpPbJQec1R2Tl2GCNIpGj6cd/
XKidF3pHCSf0MPCWKBE/cjPUKXJMN4q+TgQOIqpN+OwlGiw++SiNZjQohPoV7Xfo
yvWF68piVxmuCoh+PKwcQrdXIdFStlnCwtF96sHfy7G6xeeSGYQO3n1yH75dLFox
+TpO22xmFrnX/1tPFYcFkfndhpIlhIIoXQ42uZsq8kr5924Pc8vBOA3Zclc8Kavx
12X+R+rlLjltlP4t2a0H
=jAO5
-----END PGP SIGNATURE-----

--=-RhALlU5TcFxPQsPFj7VQ--

