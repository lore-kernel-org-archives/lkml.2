Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030845Ab2B2RHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:07:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59781 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964977Ab2B2RHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:07:08 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dedekind1@gmail.com designates 10.50.236.5 as permitted sender) smtp.mail=dedekind1@gmail.com; dkim=pass header.i=dedekind1@gmail.com
Message-ID: <1330535372.3545.150.camel@sauron.fi.intel.com>
Subject: Re: [patch] Adding Secure Deletion to UBIFS
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Feb 2012 19:09:32 +0200
In-Reply-To: <alpine.DEB.2.00.1202231558400.13720@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>
	 <1329152067.22240.214.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1202231558400.13720@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-r471b1j2igp+BgeYigUd"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-r471b1j2igp+BgeYigUd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-02-23 at 15:59 +0100, Joel Reardon wrote:
> >
> > Could you make a separate patch which adds new on-flash format and make
> > sure that new ubifs binaries can mount the old formats and work with
> > them. And that old ubifs binaries gracefully reject the new format.
> >
>=20
> This patch provides a new version of two on-flash data structures for=20
> UBIFS:

Similarly - wrapped patch and git am wont' apply it, sorry.

> ubifs_branch and ubifs_data_node have been grown by 8 bytes to include a=
=20
> 64-bit reference
> to a key position, which is needed by a proposed ubifs secure deletion=
=20
> addition. This patch is generated
> against linux-3.2.1.

Please, use linux-ubifs tree instead:
git://git.infradead.org/linux-ubifs.git

It has the newest stuff.

> Because both data structures use C99 flexible arrays, it is not possible=
=20
> to add the new field as
> the last member of the structure.

>  Thus, it was added one before last, the=20
> last was renamed, and in a
> handful of places where it was used, a macro accessor is used to get the=
=20
> version-correct position.

Hmm, we can make it to be key[UBIFS_SK_LEN] instead, if it helps.

--=20
Best Regards,
Artem Bityutskiy

--=-r471b1j2igp+BgeYigUd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPTlvMAAoJECmIfjd9wqK0IFAP/Reyc4KEMnejBNMRSIka5/oG
sJFim5CbwaYX8Zj2YMTTDBW9RMrsg5TbKVlopluqFyL2m0BDZ13qU6CfmhePHcpr
3X+iDbYT36yQQtQ9FSUg40KSqvHjIlH7gIb7tnNTCRJmAcLQQk9/PV+InLC9AIFR
0yYhm6Q35A5a0VBb6RjxIXTmCq/SyLGfzjsc7nnpiJ/w78ThXrLHrOskpKQmXbiD
Yx/SufBnMhV3d/JqlRMDHshAFuyQzzkdB3dq/q9PtP+uBuyMtmS4O6trde6deL9D
x/ubPKqbsacSu4U0+YyqLe7M54PqjtnCbqRngaB/wyV7MtyVuVYM53UQ/NOTAxmB
vFLuYxEg7yMWaEvaK4QhF9IgN1ifibBZCvnE8f4vWFxzGSznd5SPYE9bue8DQPPp
pwApNkVTXgfpCQIZv0NpdFEGd8kVA/pFGco3Cs++sZYweWHc0NyMV6jP/favdUDq
GLW/Zyg3Taw0QXN4zwi6sU4/FqQmQfYKqhe5Nf8KPgzvbfq+36SEb8DB2atbU+ci
GjH0nrWPxhcMwP8Uqcs3flWEg5Ya+EZxJCmvFhyLdqc9CqFb4DD+XIHfckmaytyI
enqBBj3IpMtvpeo4FP7NnGBh/BqlM9bwTvO2e6n4ucwy2rFPflEvh/TITjDI8bER
/6pVoFdqrj4MSHjnAvK/
=FdCZ
-----END PGP SIGNATURE-----

--=-r471b1j2igp+BgeYigUd--

