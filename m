Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841Ab2DJOHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 10:07:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59786 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754338Ab2DJOHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 10:07:53 -0400
Date: Tue, 10 Apr 2012 15:07:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] x86, intel_mid: ADC management
Message-ID: <20120410140749.GL7499@opensource.wolfsonmicro.com>
References: <20120410131930.28186.85370.stgit@bob.linux.org.uk>
 <20120410131206.GB31551@sirena.org.uk>
 <20120410142501.6045c6c0@pyramind.ukuu.org.uk>
 <20120410133339.GK7499@opensource.wolfsonmicro.com>
 <20120410144235.1e05efd4@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jtcAeju3WzRmRF+o"
Content-Disposition: inline
In-Reply-To: <20120410144235.1e05efd4@pyramind.ukuu.org.uk>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jtcAeju3WzRmRF+o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 10, 2012 at 02:42:35PM +0100, Alan Cox wrote:
> > Right, but fundamentally it's just a general purpose ADC which looks
> > just the same as all the other SoC/PMIC ADCs.  Like I say the decision
> > for that hardware was to push it in via IIO.=20

> Your decision maybe. And it's one that makes no sense.

> As I said this is a low level interface for driver enabling including

It's not just me, it's where all the ARM SoCs and their PMICs are going.
If you look on the IIO list you'll see patches for at least the AT91=20

> early boot time stuff, and its on a platform that's unlikely to want or
> ever use and suck in the big blob of IIO code.

Could you be more specific about what this early boot time stuff is?
Looking at the changelogs in there it all looks like the standard
battery monitoring and power supply stuff that these ADCs get used for -
just based on the changelogs there doesn't appear to be anything
remarkable here.

There's already a standard adaptor to map IIO into at least hwmon, not
sure about the power supply subsystem.  There were also some other
things people were doing in areas like thermal management that were
using this sort of hardware in generic ways.

> If you want an IIO interface to it you can write one, it's just a low
> level resource manager.

We can't just keep on going round adding new custom interfaces every
time someone supports a new SoC - it means we end up having to sit and
write lots of per-device adaptor code to integrate things and it's
hard for us to factor common code out of drivers when we've not got any
kind of framework for them.

If IIO is totally unsuitable then someone needs to make the case for a
new subsystem for this class of hardware and provide that subsystem but
it seems entirely obvious that there is a general class of hardware here
which is widely implemented.

--jtcAeju3WzRmRF+o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPhD6uAAoJEBus8iNuMP3dIPYQAI9EiYTDt0RU87anZt2TtIKt
ejqfAN2qhqIjzyVm3erBWC1pudD6NUZMpK9+VFDrefVN5mAl89c8oUeX6PVmMVab
hfyj7oy30Uz32eNnsYimA0tgzfL4YGJQXPdUmbjYtlx24r7Srz50ktiZ/YhgfnsT
hdswxUDB6+MVkZFDZ+30zQrt3AIUk06wTgZnYEHyO4ajv/5dhO4twd36ns8dirW6
Cpt1W+RX+yUdY6scR909pLeHsHe9D2x+rGHkzST6w8518xKOjtVJ5B8Izo9xrMk0
LiZTgB8lx1yEr5ByzTFmvyh9Wl21Nddd/ZaIJyAZtThYuzGSCz+6k7at3UfG/VCW
ActigOkvu1UQ4A/wGJ1hVXVNdTNzhn0fft0ByGdAfGpL7TAl6Pn8zgnejsdkO+6x
1M3zu7UASMyCw1wXukjkTkJm/evVtaDRYmb4pueHJmLjGPSPugQ9QGhzv9SPy5bI
nNygyX/E4I5lzdIb9qvEt/q8JFhCRSlGbxnt9fLWj5D1jW3xmRRKdFH134H+0mXm
EkjbJrxNGxEcv0rS0CejaACMxEq34Xl5so7xgk1y/fuwmKb3tXIDPJ6X8mmfzpXr
hQgZuahoP5INLNFDwkr8HUbveqN/Howajq41azZeL15B66/QImOys4opWzEWZn7x
C5W/PyVMV9JUgR+LKCMM
=g2qg
-----END PGP SIGNATURE-----

--jtcAeju3WzRmRF+o--
