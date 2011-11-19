Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab1KSTt0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 14:49:26 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58758 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752159Ab1KSTtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 14:49:25 -0500
Message-ID: <1321732145.2885.163.camel@deadeye>
Subject: Re: [17/26] b43: refuse to load unsupported firmware
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, greg@kroah.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, roman-vl@meta.ua,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Date: Sat, 19 Nov 2011 19:49:05 +0000
In-Reply-To: <20111119190559.GC30197@suse.de>
References: <20111119000329.419617905@clark.kroah.org>
	 <1321723330.2885.145.camel@deadeye> <20111119190559.GC30197@suse.de>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ngTtci1XnwPyCQAxnVG6"
X-Mailer: Evolution 3.0.3-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ngTtci1XnwPyCQAxnVG6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2011-11-19 at 11:05 -0800, Greg KH wrote:
> On Sat, Nov 19, 2011 at 05:22:10PM +0000, Ben Hutchings wrote:
> > On Fri, 2011-11-18 at 16:02 -0800, Greg KH wrote:
> > > 3.1-stable review patch.  If anyone has any objections, please let me=
 know.
> > >=20
> > > ------------------
> > >=20
> > > [This patch is supposed to be applied in 3.1 (and maybe older) branch=
es only.]
> > >=20
> > > New kernels support newer firmware that users may try to incorrectly =
use
> > > with older kernels. Display error and explain the problem in such a c=
ase
> > >=20
> > > Signed-off-by: Rafa=C3=85=C2=82 Mi=C3=85=C2=82ecki <zajec5@gmail.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > >=20
> > > ---
> > >  drivers/net/wireless/b43/main.c |    7 +++++++
> > >  1 file changed, 7 insertions(+)
> > >=20
> > > --- a/drivers/net/wireless/b43/main.c
> > > +++ b/drivers/net/wireless/b43/main.c
> > > @@ -2508,6 +2508,13 @@ static int b43_upload_microcode(struct b
> > >  		b43_print_fw_helptext(dev->wl, 1);
> > >  		err =3D -EOPNOTSUPP;
> > >  		goto error;
> > > +	} else if (fwrev >=3D 598) {
> > > +		b43err(dev->wl, "YOUR FIRMWARE IS TOO NEW. Support for "
> > > +		       "firmware 598 and up requires kernel 3.2 or newer. You "
> > > +		       "have to install older firmware or upgrade kernel.\n");
> > > +		b43_print_fw_helptext(dev->wl, 1);
> > > +		err =3D -EOPNOTSUPP;
> > > +		goto error;
> > [...]
> >=20
> > Again, I strongly object to this way of handling the incompatibility.
> > The revision check is fine, but the solution must be to assign a
> > different filename for the newer revisions.  The changes to 3.0/3.1
> > should be deferred until this is resolved.
>=20
> You can object, however the driver author and maintainer wants it done
> this way for now, so that's a valid solution that I have to accept.  It
> solves real bugs that people have already hit when running the 3.0 and
> 3.1 kernels.

The revision check fixes a bug, yes.  What I'm concerned about is the
cop-out error message: 'We didn't deal with versioning properly, so you
get to solve the problem.'  It should be possible to reboot between
multiple installed kernel versions without modifying files.

> Propagating a userspace tool change for those systems
> would be much harder, if not impossible, don't you think? It would also
> require a much more intrusive change to the driver infrastructure to
> handle such a proposed change.

It is the new kernel version and firmware files that should be changed,
not the old ones.

There is another option which is to use the /lib/firmware/<kernel-ver>
directories to separate incompatible firmware versions.  That is not
nearly as good as using a API/ABI number in the filename, but it would
work and the error message could suggest it.

Ben.

--=20
Ben Hutchings
The world is coming to an end.	Please log off.

--=-ngTtci1XnwPyCQAxnVG6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATsgIMee/yOyVhhEJAQp6uA//dQfTB+UIad1X9f5L6revzcYaZQZ+ahrP
U0XobRanGvioeghnwMcDv8qQUaW6xjGuUmCjpySAjdwsjY00+2KDfAfTy+nMwuHl
r4KY4KmD6iV77fyPsHDrCzcgCpY32tkVion+DM0JYUHljBxlHUNoTxvgtZqjXgW/
JOBHojTJTXBtF9Y3ffner91wBgz3CIvdt8KSacxahVrhcDqh3db2c/R2Uupsngpe
UDZVI4Sqh9pcCO/0fJl+fMO+2BEYxCzPfTQtJ+x4Sp/OaWSWy5sRIDit/kAQcjyf
4eAb+DQWZGykacPmlUqgiU5ZKRFEZwk+gdydWQmKHkoki7BgiPiuZn3FYMj6H6gM
Q2M6Ek/Dd0EbhocBRozZM43n89DCVvLH04fxcc8qG/CbSqIJ3DVkW0GspHkrAlCU
O0dxy4QLEoYYUeFu01j+n8TtuEEgO0mP4Q3MKhTqB32I/hteEpNwi/hsfiijlsYP
aejCRYnx8304UiSnQKybJvdh21/642kYY3m2/y/6cojQOhVFX8BgAA0F6Zhxj4co
Z8ZQwE1YLqnMY5XETUFFYYfQy+F1+H56sjpNc8DImUI6RcTdaFI+vFYEzSClEKxv
egzrHzcyH6uU9c0aTsBPiZvfG8xRL+hgl6js+rZdI0RaXkBhO4Pj9wUnIr21HcBf
4RoHoYA8pNo=
=nIhd
-----END PGP SIGNATURE-----

--=-ngTtci1XnwPyCQAxnVG6--
