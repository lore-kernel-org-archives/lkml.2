Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964991Ab2J3RbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:31:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33366 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933622Ab2J3RbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:31:17 -0400
Date: Tue, 30 Oct 2012 19:25:13 +0200
From: Felipe Balbi <balbi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Felipe Balbi <balbi@ti.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-input@vger.kernel.org>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121030172513.GA3993@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20121024185818.GB772@arwen.pp.htv.fi>
 <20121025205901.GA3827@sirena.org.uk>
 <20121026062008.GA21734@arwen.pp.htv.fi>
 <20121026160316.GY18814@opensource.wolfsonmicro.com>
 <20121029194901.GA30152@arwen.pp.htv.fi>
 <20121030112410.GM4511@opensource.wolfsonmicro.com>
 <20121030114949.GC28722@arwen.pp.htv.fi>
 <20121030140714.GO4511@opensource.wolfsonmicro.com>
 <20121030151642.GE29159@arwen.pp.htv.fi>
 <20121030155821.GU4511@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20121030155821.GU4511@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 30, 2012 at 03:58:21PM +0000, Mark Brown wrote:
> > > > and this is one of the issues we're all trying to solve today so we=
 have
> > > > single zImage approach for the ARM port.
>=20
> > > I don't see the relevance of single zImage here; device tree is suppo=
sed
> > > to solve that one.
>=20
> > DT is part of the deal. DT alone will solve nothing.
>=20
> If DT isn't relevant I'm not sure what you're saying about single

I didn't say DT is irrelevant. I said it's not the *only* thing.

> zImage?  The only relevance I can see for that is the data and
> configuration bloating the kernel, something that DT is supposed to
> address - this is the main use case where DT has benefits.
>=20
> > > Well, nothing's going to stop that happening if people are determined
> > > enough - one could equally see that there'll be flags getting passed =
to
> > > control the ordering of calls if things are open coded.  I would expe=
ct
> > > that with a power domain style approach any data would be being passed
> > > directly and bypassing the driver completely.
>=20
> > situations like that would be a lot more rare in open coded case, don't
> > you think ? Also a lot more local, since they will show up on a driver
> > source code which is used in a small set of use cases, instead of being
> > part of the pm domain implementation for the entire platform.
>=20
> I don't see how open coding helps prevent people doing silly things, it
> seems like it'd have at most neutral impact (and of course it does
> require going round all the drivers every time someone comes up with a
> new idea for doing things which is a bit tedious).
>=20
> > > Essentially all the patches I'm seeing adding pinctrl are totally
> > > mindless, most of them are just doing the initial setup on boot and n=
ot
> > > doing any active management at runtime at all.
>=20
> > have you considered that might be just a first step ? I have mentioned
> > this before. We first add the bare minimum and work on PM optimizations
> > later. You can be sure most likely those mindless patches you're seeing
> > are probably building blocks for upcoming patches adding sleep/idle
> > modes.
>=20
> The sleep/idle modes are just a basic extension of the same idea, I'd
> not anticipate much difference there (and indeed anything where pinmux
> power saving makes a meaningful impact will I suspect need to be using
> runtime PM to allow SoC wide power savings anyway).
>=20
> > > A big part of my point here is that it's not at all clear to me that =
it
> > > is the driver which knows what's going on.  For SoC-specific IPs you =
can
> > > be confident about how the SoC integration looks but for IPs that get
> > > reused widely this becomes less true. =20
>=20
> > I don't think so. As long as we keep the meaning of the 'default'
> > pinctrl state to mean that this is the working state for the IP,
> > underlying pinctrl-$arch implementation should know how to set muxing up
> > properly, no ?
>=20
> But then this comes round to the mindless code that ought to be factored
> out :)  Only the more interesting cases that do something unusual really
> register here.

fair enough. I see your point. Not saying I agree though, just that this
discussion has been flying for far too long, so feel free to provide
patches implementing what you're defending here ;-)

Guess code will speak for itself. On way or another, we need OMAP keypad
driver working in mainline and I don't think your arguments are strong
enough to keep $SUBJECT from being merged, unless you can provide
something stable/tested for v3.8 merge window.

--=20
balbi

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQkA14AAoJEIaOsuA1yqRE7AsQAKJYP2aHJ4QbUdgHW6D6AOTW
ydvJh/siK+rYQFnM/h5VcKjbB7igvFO+d+LheV48oQCBLLzqEeQLWjhTz2wYIasz
WLUyMRzVN7U51i8FwQmujBgXGCdM7CsAWpy12NW8u8zD6e4p+2kTx3iOZcAKLHqd
A1mI7kB5Xw60u3eVx53Hn/KYnUgb47YzWdgFMiCPHg2kBA9gtYF4nrpTpVejo1fR
TqHxF3x0bXoYzNZ5XXkmQ0msdgh0KFbHDZB7WEguvCExDkbTmkx6BYdZARK7uzcb
Bm6/UYShGkQp7SQmazoOgVjZ1jhDteeTB4vO4J7+6vAsZLF0lFEgip/EkA/SXaGm
EPrXMpuXKPQTudyXIeHQdNMtqUGv7EYalQ+lthKE3v+sithAZMCYYj0EE583I8uC
LoEn4TFWmGB/HRZfvKXMCu4zQp+4VgxTJgya60HGkiartks1ttRvPq2aSUMK2Ujx
NnehPYdz7nStFvM2XPCCVwrmhjSaztfIMoWbOjT0vqKX9iTXzradNHcWgYKqeXGO
36mbFePxfGc7YCbN40i9MO2YVNaL1VO9PetQVWwugFWWQU3MniLkJjSWgyCZtqMM
NC7c8w2qy3R4Ks8t0/se9SItoGODiyM5LtNaSWHYxw724gBVHQc6mhUOrNhOKMQk
sNkKDLeT4k15Sn+FKgnR
=NEZa
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
