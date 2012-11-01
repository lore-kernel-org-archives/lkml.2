Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761142Ab2KALKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 07:10:19 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48468 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab2KALKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 07:10:16 -0400
Date: Thu, 1 Nov 2012 13:04:18 +0200
From: Felipe Balbi <balbi@ti.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: "Cousson, Benoit" <b-cousson@ti.com>, <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, <linux-omap@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
Message-ID: <20121101110418.GF410@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <C9715CB7-D3E2-4CA7-8A93-2B10E8B70640@antoniou-consulting.com>
 <20121031180935.GL12739@atomide.com>
 <50918223.6080003@ti.com>
 <8AD2F7AF-8315-442B-A394-1A38DAB29F52@antoniou-consulting.com>
 <20121031212639.GQ12739@atomide.com>
 <8B058B00-6C21-4410-A24B-75651D49F6EC@antoniou-consulting.com>
 <20121031221402.GA29490@arwen.pp.htv.fi>
 <E4EE0D1F-C7AC-4620-86F2-D9C7C56E279F@antoniou-consulting.com>
 <50924DA3.1060901@ti.com>
 <F49CA12D-4DAC-4293-AD4D-FC7EDCEA6993@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sw7tCqrGA+HQ0/zt"
Content-Disposition: inline
In-Reply-To: <F49CA12D-4DAC-4293-AD4D-FC7EDCEA6993@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sw7tCqrGA+HQ0/zt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Nov 01, 2012 at 12:39:30PM +0200, Pantelis Antoniou wrote:
> >>>                 lcd@0 {
> >>>                         compatible =3D "adafruit,tft-lcd-1.8-red", "s=
itronix,st7735";
> >>>                         spi-max-frequency =3D <8000000>;
> >>>                         reg =3D <0>;
> >>>                         spi-cpol;
> >>>                         spi-cpha;
> >>>                         pinctrl-names =3D "default";
> >>>                         pinctrl-0 =3D <&lcd_pins>;
> >>>                         st7735-rst =3D <&gpio4 19 0>;
> >>>                         st7735-dc =3D <&gpio4 21 0>;
> >>>                 };
> >>>=20
> >>>         };
> >>> };
> >>>=20
> >=20
> > I guess there is no easy solution for that, but it looks to me that
> > what you have to do is to make the DT creation dynamic in your case.
> > Assuming you do not want to do that in the bootloader, you must do
> > that pretty early during the boot process to end up with a full
> > description of your DT tree before creating the devices.
> >=20
>=20
> Do it pretty early in the boot processes ended up with the am335xevm boar=
d file in the PSP tree.
>=20
> The whole set of possible cape designs cannot be controlled, nor do we wa=
nt to.
> We want to empower users to come up with their own designs without having=
 to do any kernel/boot loader
> hacking.

that's impossible since you will have to provide the capebus driver
anyway.

> > Each cape will have their own DTS and based on some board id you
> > will fix the DT dynamically.
> >=20
> > My point is that the issue you are facing is a real limitation of
> > DT, so you should fix the DT core and not workaround it by creating
> > artificial bindings / drivers.
> >=20
>=20
> You still haven't described any mechanism to deal with all the use
> cases I described.
>=20
> DT can't and will not deal with the complexity that we're facing right
> now.

and DT-itself shouldn't. I agree with Benoit that this should be built
at bootloader level, perhaps. Whatever you're doing in capebus, you
could do at kernel space, build your DT bindings in runtime, and pass
that DT blob to kernel.

One question though, what do you mean by "some capes are full blown
devices with their own drivers" ? Do you mean you have capes running
some other (RT)OS and communicating with linux somehow ? How does it
communicate to the bone ?

cheers

--=20
balbi

--Sw7tCqrGA+HQ0/zt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQklcyAAoJEIaOsuA1yqREUYwP/AwugWcpptAOP7Vl8BukfrOd
bQ1R6tSGYVQ+Iv8WJii4h7u0elKt+68iA56ceK5KqP/NUjG6r3MUdJMIZucbwiGl
6UIWxeYNyH5i6VziVtT582ApXuM5YAzu2TVKN9L0Z+zGlf8617ddKVmRnXr9/qPg
pFqZDc80kfoKKwZNrjd41ubtA3zn+Fc1v3lcU9t6QbLibP8M47OOEZNQPn0pCsJd
OdbHqBemfa8E62I4QiPOGjAwMW+ijjwOhVN4d4soMM4dMCkJ9SRPTymZnlQClEru
SsfdoaqrUjo7xz33YAW2BshFjSgo9Gx6BQDgKeb1/QTDGRKdD/tmUkpe9AOsSq8d
gr1ISHyjZkgvmR5hZJT/pNOE5IpekD03OZmHT8bt3awh21ne++914hjz6ptW7n4+
eP3xSSq2+N7V95lJ2WYO7+DIE4UESQW7KpIdpEP7eWtmPjerfMNf7zhpeMzhiDY7
42q0E5QxfKPNj7COhTDlHicyKEDxf1Q77jhRG/pLv5CA7CNMVrfGc9FtUEg+rhKe
wJpGnALHOnhNpQiGDsEl4jNuGGv82JiynEd9jXD+H0rncCwkvugrlE9N+JjeRsfd
8he2bregyX/Mj8N0aTG6sB9cdrJSijJFqKlqitGpMnnEPRE+FGGwlb3jD6J6ZwKe
B8TqVntYLF+19cFJV7tQ
=6DTe
-----END PGP SIGNATURE-----

--Sw7tCqrGA+HQ0/zt--
