Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab2JVPJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:09:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50779 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab2JVPJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:09:01 -0400
Date: Mon, 22 Oct 2012 17:08:35 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Prisk <linux@prisktech.co.nz>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 2/3] PWM: vt8500: Update vt8500 PWM driver support
Message-ID: <20121022150835.GA31704@avionic-0098.mockup.avionic-design.de>
References: <1350643135-13197-1-git-send-email-linux@prisktech.co.nz>
 <201210221150.22004.arnd@arndb.de>
 <20121022120706.GA19467@avionic-0098.mockup.avionic-design.de>
 <201210221352.08352.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <201210221352.08352.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:eSG5dFlSGCmiy/IsUXKDQFbWsVFde9v3LOzqEsPkjdh
 cz5vF00CYrt3qZwqyHNNvNLdpZPwchQC4voOJjC9br7quFX64l
 Vu3AA01UNsLE1YJPPcMoUDd4r0ZMgsW9bvTKQFMxdi400KN6l2
 gxiag1av6v/JrD6ajFA2yYpIWhWgDI2HHeJX6vrhJuthBUAVjK
 ITPGORsY5M/jzMLsOU1Zxto4zSZ+uum+efXwF1f76R0H8PVi0O
 eiKlRwGwcmox5S8l1s7UNxqQuWsq+0OMu7wrlsBWqMSuS2tATa
 Pv+SFw3vvxWfx9j4veALoOraaUusKvG+4gxpAhVMTz68HQmx/i
 XAOLaWCFLYmT/bxcyFkJLAj6JzYUjOUG2gwBJp6rqYUbASwbA2
 1A47lMXwUfUwSLsisKlUysB7OazQ+G5rpGujb/sADKyvA7Mnmi
 ATDER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 22, 2012 at 01:52:08PM +0000, Arnd Bergmann wrote:
> On Monday 22 October 2012, Thierry Reding wrote:
> > > As long as we get build warnings for leaving out the __devinit/__deve=
xit
> > > annotations, I would generally recommend putting them in. If we do a
> > > patch to remove all of them, a couple extra instances will not cause
> > > any more troubles than we already have.
> >=20
> > I've never seen any build warnings for leaving __devinit/__devexit out.
> > Where does that happen?
>=20
> Section mismatches usually result into warnings from modpost, like
>=20
> WARNING: modpost: Found 1 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=3Dy'
>=20
> Actually doing that gives you an output like this (currently on exynos_de=
fconfig):
>=20
> $ make CONFIG_DEBUG_SECTION_MISMATCH=3Dy
> WARNING: drivers/pinctrl/built-in.o(.devinit.text+0x124): Section mismatc=
h in reference from the function samsung_pinctrl_probe() to the function .i=
nit.text:samsung_gpiolib_register()
> The function __devinit samsung_pinctrl_probe() references
> a function __init samsung_gpiolib_register().
> If samsung_gpiolib_register is only used by samsung_pinctrl_probe then
> annotate samsung_gpiolib_register with a matching annotation.
>=20
> or like this (now fixed in socfpga_defconfig):
>=20
> WARNING: drivers/net/ethernet/stmicro/stmmac/stmmac.o(.text+0x5d4c): Sect=
ion mismatch in reference from the function stmmac_pltfr_probe() to the fun=
ction .devinit.text:stmmac_probe_config_dt()
> The function stmmac_pltfr_probe() references
> the function __devinit stmmac_probe_config_dt().
> This is often because stmmac_pltfr_probe lacks a __devinit=20
> annotation or the annotation of stmmac_probe_config_dt is wrong.
>=20
> I believe you normally don't get warnings for functions that could be
> marked __devinit and only call regular functions, but there are
> a couple of __devinit infrastructure functions that you can't call
> from a function that isn't __init or __devinit.

Right. If you get those warnings you shouldn't be dropping the
annotations. But I don't think that is the case for this driver. Tony,
can you confirm that the driver still builds properly without warnings
if you drop the __devinit/__devexit?

Thierry

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQhWFzAAoJEN0jrNd/PrOhFCQQAKMHBz7jnAR78ywN8ofDIzpp
fiDKdOPvmfm7QDCfgcLMO66iSqFeKkBgQ3PBYC4ZxMCqBIPJOaDyI6Az/qhBIbYz
Z0VMjg/Wi821OcAtCpqurCNrOUlu2/0x8jVg51ldt1vizuJXtWQlIEBTUh8eh0Rp
6UFaFqJ1FPQfJOAlqX8PMGxjKnRN9RVBW+NNyd5VQUMXwv9PdlqUmGCMR8bNsL83
gasxjJ+J9Yn0fbqYBeSkP/Qn2uZ3vBW0SOX4JaKBFrpmAvxTSuW2aoqs2CiL5q2o
siGiEGm3j7/4bC8AUQ6Zqq7eTEva8t6PXhTXM0+HvyadyIjGdOIqUKDpd60Ldjvp
ebuS9XPTy1j8gg2f5LlOA+7+0ANEKODfdxG2jOeCsKAGJIzZaTu0dAF3fzr8x4/v
R1Qx+VZicL48d3X5fQaz8TWdtkQkzUHCtqsLOA8p+KEvMcSQUnVwRg+UELM+2UHp
dNd7k7QC157T2YN2tlaTKpkprqdeUzgszMr1V3/rB9ogZHGPuQ0+Ovy83wvix6bX
rVp8XqV4TqdweuyDgQsjwKN1oLYpwomNMe1ZDIr//A23Isqjg50cOCl8gMX/5/US
GD76fuASM9oC5cC9vnJdMScSYg6IUqlCrs0t1tkcVqugkChXnQkPvMW5marve3Dl
QgSeBRftxVgQM49qg//u
=IzT3
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
