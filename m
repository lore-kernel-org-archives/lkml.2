Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab2EaJ1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 05:27:46 -0400
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:35538 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752066Ab2EaJ1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 05:27:45 -0400
Date: Thu, 31 May 2012 12:26:05 +0300
From: Felipe Balbi <balbi@ti.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Felipe Balbi <balbi@ti.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [RFC PATCH] clk: add extension API
Message-ID: <20120531092603.GM5377@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1338285540-24407-1-git-send-email-pdeschrijver@nvidia.com>
 <4FC5DFCF.1020606@codeaurora.org>
 <20120531075125.GL8026@tbergstrom-lnx.Nvidia.com>
 <20120531081841.GG5377@arwen.pp.htv.fi>
 <20120531083131.GQ8026@tbergstrom-lnx.Nvidia.com>
 <20120531085432.GK5377@arwen.pp.htv.fi>
 <20120531090518.GR8026@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="20XocjIeMTCm4X0r"
Content-Disposition: inline
In-Reply-To: <20120531090518.GR8026@tbergstrom-lnx.Nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--20XocjIeMTCm4X0r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, May 31, 2012 at 12:05:18PM +0300, Peter De Schrijver wrote:
> >=20
> > What if a module needs two clocks and you drive the reset on both of the
> > clocks ? What would happen ?
> >=20
>=20
> Only 'leave clocks' have this reset method and a module can only have 1 of
> them.

fair enough... got mislead by you "every module has at least one clock"
statement.

> > > but then we would have the keep a list of IDs (1 per module) which th=
e drivers
> > > can use to call some tegra reset function which would in the end use =
registers
> > > in the same memory area to cause a reset. (the registers controlling
> > > modulereset are interleaved with those controlling the enable/disable=
 of the
> > > main moduleclock and bitpositions are identical)
> >=20
> > Well, under a generic device-level API, you could just call an internal
> > clk_reset() function because you know which clocks feed into which
> > devices anyway. It could look something like:
> >=20
> > on Tegra:
> >=20
> > device_reset(dev)
> > 	-> dev_pm_domain->reset()
> > 		-> tegra_periph_reset()
> >=20
>=20
> These methods are also needed internally by the powergating code.

so ? Just call them when you need...

> > on OMAP:
> >=20
> > device_reset(dev)
> > 	-> dev_pm_domain->reset()
> > 		-> omap_hwmod_reset()
> >=20
> >=20
> > btw:
> >=20
> > tegra_periph_reset(....)
> > {
> > 	tegra_periph_reset_assert(...);
> > 	udelay(2);
> > 	tegra_periph_reset_deassert(...);
> > }
>=20
> which uses the clockframework currently.

no problems there. The point is that you already know which clock feed
into which device, so if you have a device-based API for device
soft-reset, you can figure out which exact clock to toggle, right ?

--=20
balbi

--20XocjIeMTCm4X0r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPxzkrAAoJEIaOsuA1yqRELgUP+QEmkIvqVmzCIQHIxIiD53xS
gbFBg9KDMkXZZdNENSZ371ZQQ1VwyGYCpQVqPGDmaEmEOAaE4LR/SoIB3Vpd6HFf
wvGtHX29+vCdYKtKqyAdqfcYUPY2I5fJWpcQTVZC97hIph8OpMIB3P0hqJF5hbsP
u29N63mQomxvONcn8p9tRZQtb0j/XZ7ltUE0Aju9lQRhK63u4omLLPa4VCG7DySv
7nvpynaP3MgrevigcDJeoCSJrcwHiV/4wYR2qBv3/YusnydZ2hd6+hhRyxK6ZMD3
CsYKJTOPh8sBcdwbyuwYzQcsvdDi7rCdu/xxirRVt58GVFlBll1FJreSN0+Joh1o
s0sEPtH0pYnEvexOv+RbpcMX0zuSWK7wx+nj6yw4QxaOB4lBlOt/7fRSQcUmGlAw
PF7dp0gcdJxKXEwuqvliCq/3qUcIZTTjKZF/0f2kzhWzM5FuAGaEeLo+f6PtFXyc
hOwNE+xSC8i5TSiDRbbpVmmH5qgQJY6iMZ3xk7ylTloPfNhHLTenEWjszW7ul/CG
Dg92HPyg+kvLZxCOIHWzsRG6Vn1+6TBSw+Wp4wZxLQ8zlfLEwTFFIcqabc0TTkrN
b0NYaMKooxncCagBNCPHvgIUqWLnW4+SvIJWmplt5crKDf1e18MSG6464Tly5Eoz
9zqkbP/wo5isnJaDazbY
=UnTv
-----END PGP SIGNATURE-----

--20XocjIeMTCm4X0r--
