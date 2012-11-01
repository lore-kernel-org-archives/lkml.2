Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab2KAMqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 08:46:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37406 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746Ab2KAMqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 08:46:23 -0400
Date: Thu, 1 Nov 2012 14:40:25 +0200
From: Felipe Balbi <balbi@ti.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: <balbi@ti.com>, "Cousson, Benoit" <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, <linux-omap@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
Message-ID: <20121101124025.GA12489@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <50918223.6080003@ti.com>
 <8AD2F7AF-8315-442B-A394-1A38DAB29F52@antoniou-consulting.com>
 <20121031212639.GQ12739@atomide.com>
 <8B058B00-6C21-4410-A24B-75651D49F6EC@antoniou-consulting.com>
 <20121031221402.GA29490@arwen.pp.htv.fi>
 <E4EE0D1F-C7AC-4620-86F2-D9C7C56E279F@antoniou-consulting.com>
 <50924DA3.1060901@ti.com>
 <F49CA12D-4DAC-4293-AD4D-FC7EDCEA6993@antoniou-consulting.com>
 <20121101110418.GF410@arwen.pp.htv.fi>
 <3AF5A6FC-61D9-40CA-85B3-81C2C788CB76@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <3AF5A6FC-61D9-40CA-85B3-81C2C788CB76@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Nov 01, 2012 at 01:26:10PM +0200, Pantelis Antoniou wrote:
> Hi=20
>=20
> On Nov 1, 2012, at 1:04 PM, Felipe Balbi wrote:
>=20
> > Hi,
> >=20
> > On Thu, Nov 01, 2012 at 12:39:30PM +0200, Pantelis Antoniou wrote:
> >>>>>                lcd@0 {
> >>>>>                        compatible =3D "adafruit,tft-lcd-1.8-red", "=
sitronix,st7735";
> >>>>>                        spi-max-frequency =3D <8000000>;
> >>>>>                        reg =3D <0>;
> >>>>>                        spi-cpol;
> >>>>>                        spi-cpha;
> >>>>>                        pinctrl-names =3D "default";
> >>>>>                        pinctrl-0 =3D <&lcd_pins>;
> >>>>>                        st7735-rst =3D <&gpio4 19 0>;
> >>>>>                        st7735-dc =3D <&gpio4 21 0>;
> >>>>>                };
> >>>>>=20
> >>>>>        };
> >>>>> };
> >>>>>=20
> >>>=20
> >>> I guess there is no easy solution for that, but it looks to me that
> >>> what you have to do is to make the DT creation dynamic in your case.
> >>> Assuming you do not want to do that in the bootloader, you must do
> >>> that pretty early during the boot process to end up with a full
> >>> description of your DT tree before creating the devices.
> >>>=20
> >>=20
> >> Do it pretty early in the boot processes ended up with the am335xevm b=
oard file in the PSP tree.
> >>=20
> >> The whole set of possible cape designs cannot be controlled, nor do we=
 want to.
> >> We want to empower users to come up with their own designs without hav=
ing to do any kernel/boot loader
> >> hacking.
> >=20
> > that's impossible since you will have to provide the capebus driver
> > anyway.
> >=20
>=20
> The generic cape bus driver can handle the easy stuff. More complex
> stuff can be supported with per-cape drivers.

likewise:

the generic stuff can be handled by FDT easily, the more complex stuff
can be supported by dynamically changing FDT blob, no ?

> >>> Each cape will have their own DTS and based on some board id you
> >>> will fix the DT dynamically.
> >>>=20
> >>> My point is that the issue you are facing is a real limitation of
> >>> DT, so you should fix the DT core and not workaround it by creating
> >>> artificial bindings / drivers.
> >>>=20
> >>=20
> >> You still haven't described any mechanism to deal with all the use
> >> cases I described.
> >>=20
> >> DT can't and will not deal with the complexity that we're facing right
> >> now.
> >=20
> > and DT-itself shouldn't. I agree with Benoit that this should be built
> > at bootloader level, perhaps. Whatever you're doing in capebus, you
> > could do at kernel space, build your DT bindings in runtime, and pass
> > that DT blob to kernel.
>=20
> We're just passing the buck someplace else. We're not fixing the problem.
> What makes you think that dealing with this in the bootloader is going
> to be simpler?

I never said it was supposed to be simpler, it just doesn't sound like
something the kernel should care about. Kernel cares about the

>=20
> >=20
> > One question though, what do you mean by "some capes are full blown
> > devices with their own drivers" ? Do you mean you have capes running
> > some other (RT)OS and communicating with linux somehow ? How does it
> > communicate to the bone ?
>=20
> Some have FPGAs.
> https://specialcomp.com/beaglebone/BeagleBone_FPGA.html

how does linux communicate with those ? What they are matters very
little ;-) All we need is an interface to load binaries to the FPGA.

> Some capes have their own MCUs.
> A recent one has an 6502 communicating with uio_pruss.
> https://github.com/ohporter/b6502

that uses remoteproc, so I assume it's using OMAP's mailbox ?

Again I say that this is not a 'capebus', it's just another device
which we use another interface to talk to.

i2c devices will be children of the omap i2c controller, spi devices
will be children of the omap mcspi, GPMC devices will need the GPMC
controller and so on, but none of this looks like argument to introduce
a fake bus into the kernel.

--=20
balbi

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQkm25AAoJEIaOsuA1yqRE5Z8P/0iAunEwv3K4xN1ivY4WMBNt
TdhXJJ9bw7KT2P7+OwWRO4RdArRPw+1CWwuh3OfY4xtR1iAY/oO/kEZDKmixLo2Z
pQS53ACp8X6DQxLBaJEbD4ljb5ffV5hSLxAXLSNKXG2cpiY8HarW3/k+yh+3xr2d
WUijYFoMmMSV2PCqAMboRiQ7LG/ZjT+MaLbXUSddOmXo02kEUB+Or0n0eGn/V9aO
anveDpLgS0o0MGQG0BOrifYuWUGMcqlf+Cdi62pI1XgPyUI0RA4LzGkXzE1pql2G
DsYug2l7IeBkLjTQsFffYFydn1FL8QLJ3cvXy29H5LvrjpWm/Mh+e+eYzd/eHbn/
3Uy9gYmBPXGNvt2FNbNoQRH6KDC/KONyOhJ5ggla9PoaAmeQkDH/P16C9Ey4dg9o
YuFp5KqKsJWMvD7rRhUF4aSRbYMszFCC7HRAzPkoocpKYpQ2KXBOxXmSBGmGMuva
YuhC23LYvlGjmJ55sw/8gPJR6kZl4pb21FpF0GWSFe6IahgNgL7FTE3gRu9VozGx
Uvit0NevtogLkzvaVi6eB9+HfFYItoKeqOBqCfO6usTU8ElGgJ/RvtnYhPTJf0jG
WuepEh8MUbTNswedDS0XNLr0tqxUsr3OTCMdtkEEN8QN0VBbowS6nwf55zG3CECC
w92/TuPRFrF2t9CFQvVP
=HjVI
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
