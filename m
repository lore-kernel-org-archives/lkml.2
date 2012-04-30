Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab2D3Jyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 05:54:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38002 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752297Ab2D3Jye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 05:54:34 -0400
Date: Mon, 30 Apr 2012 10:54:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kevin Hilman <khilman@ti.com>
Cc: "J, KEERTHY" <j-keerthy@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, rjw@sisk.pl,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        j-pihet@ti.com, durgadoss.r@intel.com
Subject: Re: [PATCH V3 00/10] PM: Create the AVS(Adaptive Voltage Scaling)
Message-ID: <20120430095429.GB3170@opensource.wolfsonmicro.com>
References: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
 <20120426191159.GA9415@sirena.org.uk>
 <CAJ6a13a6WN9h1QZynpEOf-R6RXwWBZ2eOPkTeNc15JX_YfAz_w@mail.gmail.com>
 <20120427175657.GP18260@opensource.wolfsonmicro.com>
 <87397o3n4y.fsf@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8P1HSweYDcXXzwPJ"
Content-Disposition: inline
In-Reply-To: <87397o3n4y.fsf@ti.com>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8P1HSweYDcXXzwPJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 27, 2012 at 02:01:17PM -0700, Kevin Hilman wrote:
> Mark Brown <broonie@opensource.wolfsonmicro.com> writes:

> > But presumably these things should integrate somehow - for example,
> > should devfreq and cpufreq be providing inputs into what AVS is doing,
> > and if so how?

> The way it is currently designed, cpufreq/devfreq/regulator layers don't
> need to know about AVS.

Yes, and that was a part of my concern, but see below.

> The higher-level layers only know about the "nominal" voltage.  AVS
> hardware does automatic, adaptive, micro-adjustments around that nominal
> voltage, and these micro-adjustments are managed by the AVS hardware
> sending commands to the PMIC.  (specifically, on OMAP, the AVS sensors
> provide inputs to the voltage processor (VP) which provide inputs to the
> voltage controller (VC) which sends commands to the PMIC[1].)

Right, that's what I'd understood it to be. =20

> The driver proposed here is primarily for initializing the various
> parameters/sensitivity/etc. of the AVS hardware, but the actual voltage
> adjustments are done in hardware by VC/VP.

It's not just a driver, though - it's also creating this power/avs
thing, though now I look at the code rather than just its shape there's
not actually an abstraction being added here, it's mostly just straight
code motion of the arch/arm code that's there already.  The changelog
and the shape of the code make it sound like this is intended to be
somewhat generic when really it's providing some OMAP specific tuning
for the device which is much less of a concern.

I guess for now it's probably OK to just clarify in the documentation
and say that whoever adds the second driver has to work on making this
generic :)

This does also sound rather like it's in a similar area to the current
management work which Durgadoss R (CCed) was working on, though with a
slightly different application and in the OMAP case it's pretty much all
hidden in the external processor.

--8P1HSweYDcXXzwPJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPnmFNAAoJEBus8iNuMP3dhM8P/2QSv9mJ0brc+jjv0V77iy7f
/fXc7pneBBwXwUPC5RJJGS0Qc/iTjaTN2QfYpw8TjdnuEKsOpwuz1W4UCZNRWKxu
72dXmNB2u1F+Tf9rXBHZqW2OE6slDhuvhIdly/rOwjjmf6IGf37vJb2i+fA8V0gW
aevaGzwC3asRM1QQxQ3fAKx7Xc4kdULG0ifJ/7mYoeFK0IBEHLusClhVJFTGOZ1i
aHjD2I0ASGt7O1N3Ewg2a+uxaDjNvGLBRI2UxdmSoI68ygTIwizUkUFuZ1ozoP3I
BP9AX3YuRZXwxVNYOv0sNSNgQ50mE7NYYbGinw7NiUyDHIQ9WSEml4ltJLC3Pt01
vtrECuEy1ck7ewrGhbRvzrCnArOiVnt7cUYBd2TxGp3P8kJ0tnp9JvRnjYT6T3G7
ISAlckx6ZcUaDCU0JxHhc4XmksI5upw0LojrwnlPJMOjcLkr6rr5e7t2d+3E4G2u
lh0Uw5xNnT6Sthj2OS5wNTtzPrC5ltk2LLSAxhEM2fybEmg6twvxdAa19RpofyT0
zgMtqA9vwjMintaGLdq05MNyeIGFu/ChJ55Y5rh8z0lQN3x0OJlD4nwN/dMadut+
U/vOAP12ug4V6GamKuWrejOjKEpUVJdRoKNTWK6G9ZcajIa0ZAX+KTNFKvR+PAYz
veNrHzL4OvV/3MabrWpy
=WsSD
-----END PGP SIGNATURE-----

--8P1HSweYDcXXzwPJ--
