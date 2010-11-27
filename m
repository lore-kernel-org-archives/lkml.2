Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab0K0VVk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 16:21:40 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47455 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517Ab0K0VVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 16:21:38 -0500
Date: Sun, 28 Nov 2010 08:21:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <gregkh@suse.de>
Cc: Valdis.Kletnieks@vt.edu, Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andres More <more.andres@gmail.com>,
        Charles Cl?ment <caratorn@gmail.com>, devel@driverdev.osuosl.org,
        Mike McCormack <mikem@ring3k.org>, Radu Voicilas <rvoicilas@gmail.com>
Subject: Re: The longest build error ever, ever, ever seen :) (Re:
 linux-next: Tree for November 26)
Message-Id: <20101128082126.eca68e5b.sfr@canb.auug.org.au>
In-Reply-To: <20101127182723.GA5389@suse.de>
References: <AANLkTinY3on+arwh-Rvqnbrx_FU4mKDmpwXR_EfkPJ0f@mail.gmail.com>
	<20101127164555.GA23508@suse.de>
	<256560.1290881547@localhost>
	<20101127182723.GA5389@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__28_Nov_2010_08_21_26_+1100_bymJPn1RYDap9y4p"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__28_Nov_2010_08_21_26_+1100_bymJPn1RYDap9y4p
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Sat, 27 Nov 2010 10:27:23 -0800 Greg KH <gregkh@suse.de> wrote:
>
> On Sat, Nov 27, 2010 at 01:12:27PM -0500, Valdis.Kletnieks@vt.edu wrote:
> > On Sat, 27 Nov 2010 08:45:55 PST, Greg KH said:
> > > On Sat, Nov 27, 2010 at 09:56:45AM +0100, Zimny Lech wrote:
> > > > Ave!
> > > >=20
> > > > 2010/11/26 Stephen Rothwell <sfr@canb.auug.org.au>:
> > > > > Hi all,
> > > > >
> > > >=20
> > > > OMG, LOL, this one is awesome :) The longest build error ever, ever,
> > > > ever seen! Fscking awesome, someone gets Guiness World Record :)
> > > >=20
> > > >   LD      drivers/staging/built-in.o
> > > > drivers/staging/rtl8192e/built-in.o: In function `rtl8192_setBBreg':
> > > > (.text+0xae00): multiple definition of `rtl8192_setBBreg'
> > > > drivers/staging/rtl8192u/built-in.o:(.text+0xa1a0): first defined h=
ere
> > >=20
> > > You built both of these drivers into the kernel, which causes the
> > > problem.  Try building them as modules, or just one as a module, and
> > > that will solve the problem.
> >=20
> > We probably should create some Kconfig magic to prevent this situation?
> >=20
> > 	depends (othermodule !=3D 'y') || (myself !=3D 'y')
> >=20
> > or am I on the wrong track here?
>=20
> Just make each module depend on 'm' so that they can not be built into
> the kernel, and all should be fine.

Surely the real fix is to make sure that the global symbols in these
drivers are unique ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__28_Nov_2010_08_21_26_+1100_bymJPn1RYDap9y4p
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM8XZWAAoJEDMEi1NhKgbsyVUH/j6kRYjklCyEdLtGFSxHv/AI
aZVjfwsjs0cSxsiMsK+sB3iM5XFuQRPMXaX0E+3Ej0vwsbZeR1iRe3VQfuUbSuMI
bMDrmMQaPa2OOAusdhxBFOxdjh+fknENdZnl8VzP3m0+hfKNQwgaKhipZ9eEbq7u
OqD6NEEG/CpAoS0n/la9I9OENXwWS6w/LpIr1mkwKSECwxcTi8fdO8pnRsWn7AXc
MIXBpqN3/ee00uftUklFJm1j+UH66AsG1X3L70qo8ABNZl9JVYETLmkjge8r7lCY
8hHVzMxr5hy6h/+y7uH8RZjcCOdjqDwpQblFhdIg9R0o6Gsdf0xr/iSmMF4ZGFc=
=EKBe
-----END PGP SIGNATURE-----

--Signature=_Sun__28_Nov_2010_08_21_26_+1100_bymJPn1RYDap9y4p--
