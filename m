Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab0C2Wca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 18:32:30 -0400
Received: from ozlabs.org ([203.10.76.45]:38925 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019Ab0C2Wc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 18:32:26 -0400
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
In-Reply-To: <4BB126F6.8020805@kernel.org>
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
	 <1269865331.24620.44.camel@concordia>  <4BB0DAC2.3000805@kernel.org>
	 <1269900605.2286.2.camel@concordia>  <4BB126F6.8020805@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-JbZlboFZu0u15Yf1qouQ"
Date: Tue, 30 Mar 2010 09:32:24 +1100
Message-ID: <1269901944.2286.18.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JbZlboFZu0u15Yf1qouQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-03-29 at 15:17 -0700, Yinghai Lu wrote:
> On 03/29/2010 03:10 PM, Michael Ellerman wrote:
> > On Mon, 2010-03-29 at 09:52 -0700, Yinghai Lu wrote:
> >> On 03/29/2010 05:22 AM, Michael Ellerman wrote:
> >>> On Sun, 2010-03-28 at 19:42 -0700, Yinghai Lu wrote:
> >>>> the new lmb could be used to early_res in x86.
> >>>>
> >>>> Suggested by: David, Ben, and Thomas
> >>>>
> >>>> First three patches should go into 2.6.34
> >>>>
> >>>> -v6: change sequence as requested by Thomas
> >>>> -v7: seperate them to more patches
> >>>> -v8: add boundary checking to make sure not free partial page.
> >>>> -v9: use lmb_debug to control print out of reserve_lmb.
> >>>>      add e820 clean up, and e820 become __initdata
> >>>
> >>> Bike shedding perhaps, but can you maintain the naming convention, ie=
.
> >>> lmb_xxx() rather than xxx_lmb(). Neither is necessarily better, but a=
ll
> >>> the existing functions use the lmb_xxx() style.
> >>>
> >>
> >> so you want
> >>
> >> find_lmb_area =3D=3D> lmb_find_area
> >> reserve_lmb =3D=3D> lmb_reserve
> >> free_lmb =3D=3D> lmb_free
> >>
> >> first one is ok,=20
> >>
> >> but next two we already have lmb_reserved and lmb_free without checkin=
g and increasing the size of region array.
> >=20
> > That was the point of my other mail. We now have two lmb APIs, one whic=
h
> > checks if the array will overflow and one which doesn't. That seems lik=
e
> > a bad idea. Having one called lmb_free() and one called free_lmb() is
> > definitely a bad idea, because it's completely non obvious which one
> > caters for overflow.
>=20
> I want to keep the affects to other lmb users to minium at first.

That's a good plan, but I don't think this is the nicest way to do it.

> and we can merge those functions later.
>=20
> or you insist on merging them in this patchset?

No I don't insist.

I _suggest_ that if we want to avoid affecting existing lmb users, then
the checking logic should go into the existing API, but be #ifdef'ed for
now - eg. CONFIG_DYNAMIC_LMB or something. That way you avoid affecting
existing users (more or less), but you don't add a new API that you then
have to remove later.

Having said that I don't think it really does affect existing users that
much. We still have the statically defined region arrays, and they're
still the same size, so sparc and powerpc should never need to resize,
except on machines where we currently run out of space in the array
anyway.

cheers

--=-JbZlboFZu0u15Yf1qouQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkuxKngACgkQdSjSd0sB4dIdvQCfW2e4J+uwH/haxiLmwNTgih7Y
qNMAnjC3EulzKev+qd4ju33uJlUtAtgC
=cCyd
-----END PGP SIGNATURE-----

--=-JbZlboFZu0u15Yf1qouQ--

