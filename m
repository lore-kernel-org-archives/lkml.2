Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab1AFD1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 22:27:24 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60852 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754754Ab1AFD1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 22:27:20 -0500
Date: Thu, 6 Jan 2011 14:27:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (tty
 tree related)
Message-Id: <20110106142710.a0a04883.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LFD.2.00.1012171107310.12146@localhost6.localdomain6>
References: <20101217171120.295b0c0c.sfr@canb.auug.org.au>
	<20101217070431.GA25192@kroah.com>
	<alpine.LFD.2.00.1012171107310.12146@localhost6.localdomain6>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__6_Jan_2011_14_27_10_+1100_+L+WgKxsEyi8NzF+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Jan_2011_14_27_10_+1100_+L+WgKxsEyi8NzF+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI Greg,

On Fri, 17 Dec 2010 11:16:17 +0100 (CET) Thomas Gleixner <tglx@linutronix.d=
e> wrote:
>
> On Thu, 16 Dec 2010, Greg KH wrote:
> > On Fri, Dec 17, 2010 at 05:11:20PM +1100, Stephen Rothwell wrote:
> > > Hi Greg,
> > >=20
> > > After merging the final tree, today's linux-next build (powerpc
> > > allyesconfig) failed like this:
> > >=20
> > > drivers/serial/apbuart.c:596: error: conflicting types for 'grlib_apb=
uart_configure'
> > > drivers/serial/apbuart.c:523: note: previous declaration of 'grlib_ap=
buart_configure' was here
> > >=20
> > > Caused by commit 35c64e5d13c3d7d8c4ad061ad5e20498b9160c24 ("drivers:
> > > serial: apbuart: Handle OF failures gracefully").  This build has
> > > CONFIG_SERIAL_GRLIB_GAISLER_APBUART_CONSOLE set ...
> > >=20
> > > I have reverted this commit for today.
> >=20
> > Ugh.  Thomas, care to send me a patch?
>=20
> Sorry, I missed the console part. Patch below.

Ping?

> Thanks,
>=20
> 	tglx
> ---
> Subject: drivers: serial: apbuart: Fixup apbuart_console_init()
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Fri, 17 Dec 2010 11:09:49 +0100
>=20
> commit 35c64e5d (drivers: serial: apbuart: Handle OF failures
> gracefully) missed that the modified grlib_apbuart_configure()
> function is called from apbuart_console_init() as well.
>=20
> Fix the fallout.
>=20
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  drivers/serial/apbuart.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> Index: linux-2.6-tip/drivers/serial/apbuart.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6-tip.orig/drivers/serial/apbuart.c
> +++ linux-2.6-tip/drivers/serial/apbuart.c
> @@ -520,11 +520,12 @@ static struct console grlib_apbuart_cons
>  };
> =20
> =20
> -static void grlib_apbuart_configure(void);
> +static int grlib_apbuart_configure(void);
> =20
>  static int __init apbuart_console_init(void)
>  {
> -	grlib_apbuart_configure();
> +	if (grlib_apbuart_configure())
> +		return -ENODEV;
>  	register_console(&grlib_apbuart_console);
>  	return 0;
>  }

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__6_Jan_2011_14_27_10_+1100_+L+WgKxsEyi8NzF+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNJTaOAAoJEDMEi1NhKgbsUnIH/RnPGiufxnNI/hShYw/py1dR
yanGoDgsT1Ie5doFpgtVzL5IjkKPs4s5md80ABrObNgOOGQ+26Hh6uCOmZbIAIzd
LGDHJmQdJ91WXM9KCxSI7pEFS0YiabvzjRHIffcmpBlU2Fp9GJ/uKIXIGN03MdKD
QtBZbc1spV1p8aosa3wXsKcSn+eqGpBaj48oLKWz3r1MF6mOqSgBLrgPVA+FxzL5
pkew7jdGhEOlMf5SHhJ+lFF5mszBaCipGtZsDO3ttcYTRNVSRar+mdAwHBc6KqAC
8V1N0PsV3DjpYg9QbkQIx9JTNO0CbSABcjsGbgHpJdS6kc16Q/ga1gPTjEC6AfY=
=Js4C
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Jan_2011_14_27_10_+1100_+L+WgKxsEyi8NzF+--
