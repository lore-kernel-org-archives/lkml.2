Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab1JRBgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 21:36:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50177 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757083Ab1JRBgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 21:36:44 -0400
Subject: WARNING in tty_ldisc_reinit
From: Ben Hutchings <ben@decadent.org.uk>
To: =?UTF-8?Q?=D0=94=D0=BC=D0=B8=D1=82=D1=80=D0=B8=D0=B9_?=
	 =?UTF-8?Q?=D0=9C=D0=B0=D1=82=D1=80=D0=BE=D1=81=D0=BE=D0=B2?= 
	<sgf.dma@gmail.com>,
        Jiri Slaby <jirislaby@gmail.com>
Cc: 645071@bugs.debian.org, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 18 Oct 2011 02:36:23 +0100
In-Reply-To: <CAFdVUFme+kwFaMmVThhry91L5V-hfwvd3R8EZhV2k0B5kCPMvA@mail.gmail.com>
References: <20111012100544.3554.54216.reportbug@shilvana.local>
	 <1318475974.4024.222.camel@deadeye>
	 <CAFdVUFmAN=HmHa4BWO7PUkDyp3=_oeom3Y+AFbvdV3HvYoRS7w@mail.gmail.com>
	 <CAFdVUFme+kwFaMmVThhry91L5V-hfwvd3R8EZhV2k0B5kCPMvA@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-lTBozG494a8ivfD5NtXH"
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318901789.3340.41.camel@deadeye>
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lTBozG494a8ivfD5NtXH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=D0=94=D0=BC=D0=B8=D1=82=D1=80=D0=B8=D0=B9 =D0=9C=D0=B0=D1=82=D1=80=D0=BE=
=D1=81=D0=BE=D0=B2 wrote:
> I try to compile with printk() instead of printk_ratelimited() in your
> patch, and it's succeeded. Then i install it with

Sorry, I didn't notice that would need to be changed.  Thanks for fixing
that yourself!

> # dpkg -i   ./linux-image-2.6.32-5-686-bigmem_2.6.32-38a~test_i386.deb
> # dpkg --configure --force-depends-version  linux-image-2.6.32-5-686-bigm=
em
>=20
> and then try to reproduce this bug. Here is the result:
>=20
> [   65.162361] apm: BIOS not found.
> [   65.276280] [drm] nouveau 0000:01:00.0: nouveau_channel_free: freeing =
fifo 2
> [   84.368180] tty_ldisc_reinit: refcount of  is still 2
[...]
> I suppose, that result of previous attempt is not very useful, because
> something is missed in the output (after "of" word). So, i rewrite
> your patch a little:
> [..]
> +               printk(KERN_DEBUG "%s: refcount of %p (%s, num=3D%d, mag=
=3D%d,
> flags=3D%d) is still %d\n",
> +                               __func__,
> +                               tty->ldisc->ops, tty->ldisc->ops->name, t=
ty->ldisc->ops->num,
> tty->ldisc->ops->magic, tty->ldisc->ops->flags,
> +                               atomic_read(&tty->ldisc->users));
> [..]

"%ps" should have resulted in printing the symbol name for the structure
that the argument points to.  I don't know why that didn't work.

Anyway, Jiri, this should be the information you wanted way back in
<http://article.gmane.org/gmane.linux.kernel/1176604>:

> [   83.736104] tty_ldisc_reinit: refcount of c13c7878 (n_tty, num=3D0, ma=
g=3D21507, flags=3D0) is still 2

You can find more explanation of when this happens in the bug log at
<http://bugs.debian.org/645071>.

Ben.

--=20
Ben Hutchings
No political challenge can be met by shopping. - George Monbiot

--=-lTBozG494a8ivfD5NtXH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATpzYGOe/yOyVhhEJAQoAYA/+IQhpP3n7BS3/cProYSrPkyRgaCpwLuWp
gWR5mwlSFvGYSAajoqMV95oL95ym03jyu+bAi+fbpZO8I+zJ9xKL62y6/bBfsSGr
TnyUObiyw4dhlCzyM7EZGWTUQI4lHMAiyGYwtYf+jmbVbl/s3+QFleazYJZEVr5a
QVRluYDEopA/JlZBr+bcz8v5Ydd9g3adEdBkeSJwaAma1J/P52JWJ0EtVrwE03mp
qnIS8C/xKEor2Igc0DUQ1b/+6x4DSr/HvxVT6SbuWxiXW5BXQqVK+CBHRv+DnRlS
chahB1YoJQg3V/2+ynWKbgmF2a6IQF9dM8pcsVL7ZNp50HDPCrdSTF97WvFRMuAU
HtUSTlnhY2JaYTMdsFKoVPK7KT0EEWG69XfScYp/U+s0VyqtC0RuoAeskMVYEknp
MOCQ6nJHJk0lHADXyjjsR9gi/9sl33y46VwNLERwlXSJPhBdLebiIv5epedWSGsK
igR0E+2G5qhZhFXl7Bihu3RRkTpcJFqxHKl6UQ/1bmfghmuONL84rVL72svWb1Fu
bjEfZaDG0bS8D4ojCKsxZdtzC1HsbV5mIGnXgiSVFg/hmNXvc9aWFRLNEy/kJ4e0
1gsm1wZxnpV3wHkJFZy4KRn/L2l4+OPhfYUhdrBiIPDLTWQpIPp5wQYR06jpJeg9
bY06TKCpNIk=
=2BMD
-----END PGP SIGNATURE-----

--=-lTBozG494a8ivfD5NtXH--
