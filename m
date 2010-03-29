Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab0C2WKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 18:10:10 -0400
Received: from ozlabs.org ([203.10.76.45]:51293 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884Ab0C2WKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 18:10:07 -0400
Subject: Re: [PATCH -v9 00/31] use lmb with x86
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <4BB0DAC2.3000805@kernel.org>
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
	 <1269865331.24620.44.camel@concordia>  <4BB0DAC2.3000805@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4q3TU5NL41D1KRAspBGS"
Date: Tue, 30 Mar 2010 09:10:05 +1100
Message-ID: <1269900605.2286.2.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4q3TU5NL41D1KRAspBGS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-03-29 at 09:52 -0700, Yinghai Lu wrote:
> On 03/29/2010 05:22 AM, Michael Ellerman wrote:
> > On Sun, 2010-03-28 at 19:42 -0700, Yinghai Lu wrote:
> >> the new lmb could be used to early_res in x86.
> >>
> >> Suggested by: David, Ben, and Thomas
> >>
> >> First three patches should go into 2.6.34
> >>
> >> -v6: change sequence as requested by Thomas
> >> -v7: seperate them to more patches
> >> -v8: add boundary checking to make sure not free partial page.
> >> -v9: use lmb_debug to control print out of reserve_lmb.
> >>      add e820 clean up, and e820 become __initdata
> >=20
> > Bike shedding perhaps, but can you maintain the naming convention, ie.
> > lmb_xxx() rather than xxx_lmb(). Neither is necessarily better, but all
> > the existing functions use the lmb_xxx() style.
> >=20
>=20
> so you want
>=20
> find_lmb_area =3D=3D> lmb_find_area
> reserve_lmb =3D=3D> lmb_reserve
> free_lmb =3D=3D> lmb_free
>=20
> first one is ok,=20
>=20
> but next two we already have lmb_reserved and lmb_free without checking a=
nd increasing the size of region array.

That was the point of my other mail. We now have two lmb APIs, one which
checks if the array will overflow and one which doesn't. That seems like
a bad idea. Having one called lmb_free() and one called free_lmb() is
definitely a bad idea, because it's completely non obvious which one
caters for overflow.

cheers





--=-4q3TU5NL41D1KRAspBGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkuxJTkACgkQdSjSd0sB4dIXuwCfYDlxa44/s24G6wPLHbWgnKuM
/RgAnj+ixdwULbX/Pl5KT8LnzlLDBWIv
=Sq9m
-----END PGP SIGNATURE-----

--=-4q3TU5NL41D1KRAspBGS--

