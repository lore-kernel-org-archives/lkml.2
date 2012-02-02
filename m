Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933436Ab2BBTp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:45:57 -0500
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:53887 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932680Ab2BBTp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:45:56 -0500
Date: Thu, 2 Feb 2012 21:45:50 +0200
From: Felipe Balbi <balbi@ti.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Felipe Balbi <balbi@ti.com>, Tarun Kanti DebBarma <tarun.kanti@ti.com>,
        linux-omap@vger.kernel.org, khilman@ti.com, tony@atomide.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Charulatha V <charu@ti.com>
Subject: Re: [PATCH v9 01/25] gpio/omap: remove dependency on gpio_bank_count
Message-ID: <20120202194545.GA29351@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
 <1328203851-20435-2-git-send-email-tarun.kanti@ti.com>
 <20120202184106.GC29215@legolas.emea.dhcp.ti.com>
 <20120202191630.GT15343@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <20120202191630.GT15343@ponder.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 02, 2012 at 12:16:30PM -0700, Grant Likely wrote:
> On Thu, Feb 02, 2012 at 08:41:07PM +0200, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Thu, Feb 02, 2012 at 11:00:27PM +0530, Tarun Kanti DebBarma wrote:
> > > diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
> > > index 0b05629..6ea7390 100644
> > > --- a/drivers/gpio/gpio-omap.c
> > > +++ b/drivers/gpio/gpio-omap.c
> > > @@ -28,7 +28,10 @@
> > >  #include <asm/gpio.h>
> > >  #include <asm/mach/irq.h>
> > > =20
> > > +static LIST_HEAD(omap_gpio_list);
> >=20
> > I guess it's now too late because patch is acked and everything, but I
> > think if you make the driver handle one bank alone and just instantiate
> > it multiple times (omap_gpio.0, omap_gpio.1, omap_gpio.3, etc) driver
> > would be faaaaaar simpler.
>=20
> Is there any shared state between the banks?  On my very cursory glance it
> looked like banks still have some interaction between them.  If not, then
> yes I agree that multiple instances would be better.

A quick glance at the TRM shows that banks have separate address spaces
and IRQ lines. I think it's done this way because we can handoff one (or
more) bank to other cores on the SoC, so they need to be pretty
independent.

I could be missing something though.

--=20
balbi

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPKufpAAoJEIaOsuA1yqREhXoP/RNcQWnfcr5pv76ySF1cita9
XzTgVo64I0pJ2FxrrEGDWT0YsFIkL9NMTyojZiGmvCaxdQYcGk+OWzEdIt02tsXu
ezk3DrWRndxM4P3wLoiRqTVt0NzUxNAU3Rt+6fBs1u3Ofxig8BQOtg8RlM87D9O7
RA6sU2KKM3H+yPWuW62CHu9DSqyIzjzgeEHeW1fiKAfzInMj04MwFvCV+bZ+PuOe
KtlHAnIhyChq3wNubtErEX2w2n9ak/S/p0T9APWywZyWfJwhZ4Mmg9Hxna4gPnDr
kTcuvHIwkcss7D4m96foEz7w2rtfTPSEhu8JNI/gk0vik6rNSMMe/k4ZVcTelPS9
2Qy2LsAVKihwvD8s+rFHHTdUgfvks+PMpoQ5Gk869ORwiq9cGgq9tq+nn6bRZRJ+
OIllCsLN178xA+sQRZSaTJxVjrMtg7IHSMhY6Vfclh+E098AJxP4aQGF4mJF/MUa
xLADMHkPaUZh+lJKi8Rcs6Eu66ibNM9x7XeODmoE+oVpC8ycerHILJR3mUO5jdOi
9Mk30AtJ9PfWWr6nJMkYzeWGahoE0XS31ozemUs62DJVAi6F64hoIlBQSU7hcuKV
7Bvcxxj7V0XT/hE/b50FuYUSyfeTXR1reHabE/l4udugnpYw4VDsKKiEjHEGSUs7
mIlmW4mzv6TChVen/lRe
=atn8
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
