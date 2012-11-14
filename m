Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928Ab2KNKyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:54:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:58973 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932870Ab2KNKyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:54:11 -0500
Date: Wed, 14 Nov 2012 11:54:06 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: tegra: Add Tegra20 host1x support
Message-ID: <20121114105406.GA31455@avionic-0098.mockup.avionic-design.de>
References: <1352467202-27903-1-git-send-email-thierry.reding@avionic-design.de>
 <1352467202-27903-2-git-send-email-thierry.reding@avionic-design.de>
 <50A357D3.9080002@nvidia.com>
 <20121114084931.GA31837@avionic-0098.mockup.avionic-design.de>
 <50A3712E.7000104@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <50A3712E.7000104@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:u6tUhfVS72vyiLR+DshhGXrUeud9j3zHkZ/Hkqrnl5j
 jxWJzCiyEPBMLItbtHMbh1db9gUWNnIrB7oXnAZZFYy7Ccovo+
 lCCSXEFo/d9yqqRhnUTT2OBypS1UuqrW5SCl5Lj4MhPaBZxR30
 vbtOh8TwKSVhULs/d+8MCuR5TxP/IowE3ofgl6UO6vdCiqG7ex
 PQWzzAS0FG0fdO/pTcUy9qgfiCb/BVcbAMZbptD3/uvLQoVbrq
 +IP8G1ymr0jlw+wRf4LKdMEZSXWzb4eKGMsrfjcWxrPpAn6XwC
 vHJyP4oEwfxBjNljpDMriVHZ5b7NDYaIUYMG9apGH7jJPpnpQU
 iPQS8SO4X6wn2MFv+jH9pVcCCu0PrKKdFh2WecudmE8i1wsGpM
 RXUsf2TZQ6SVaSz3F3BR2PY3YyL6FklnK8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 14, 2012 at 12:23:42PM +0200, Terje Bergstr=C3=B6m wrote:
> On 14.11.2012 10:49, Thierry Reding wrote:
> > Can you find out how the host1x clock is setup without this change? I
> > was told that freezes can occur when you try to access the registers
> > without the host1x clock being enabled. However, the host1x driver
> > should take care to properly setup the clock.
> >=20
> > To find out if the non-running clock is the issue, can you try to patch
> > that line and make the final element true instead of false? That should
> > enable the clock on boot so that it should always be running.
>=20
> I tried with fastboot and U-Boot, and whenever that line is there,
> kernel boot will halt at nvhost init. Same happens if I just change the
> false to true.
>=20
> nvhost will enable the clock and disable as it need. Also, part of
> host1x initialization did proceed, but it ended up hanging after a few
> registers were initialized. So it's not a case of host1x being off, but
> host1x hanging after a while.
>=20
> If I change this line to:
>=20
>        { "host1x",     "pll_p",        216000000,      false },
>=20
> it will also work properly. It looks like we have some problem with
> pll_c in Tegra20, or clock configuration with your patch. In Tegra30,
> pll_c with 144MHz seems to work fine, but on Tegra20, it doesn't.
>=20
> In internal kernel, we use pll_c for host1x, so hardware shouldn't be
> the problem here.

I suppose that if things work properly without this line, then we should
probably just drop it. Stephen, any objections?

Thierry

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQo3hOAAoJEN0jrNd/PrOhCAoQAKAriYOM+dJ3OTL+dEyVWrnA
NWFavmVPOYH88J+eTruPRUUFVAq5k3KP8Wm2OHmIEIokUtO5jZ5b9bOxfW33jCuF
MyZORPPKR7bihvhPzcHKhWy77hd2BwWnvRWIkE3BCPeN7jBKfg8kp1nOkeVRQwLj
OlyzgntCsyKuMuMruXXaZh/qrf8oBjrhl5zBsjyRE/Scdi/ZnYGcZFt2dyKAGKO3
trrRiXsmMMXZrPqqXutmJscISsVJumIceTGIcBHKLukGVaMn8ojr3t05yPU4Gq0M
GS0CINjJUq27EPB63gRw0NWcb/iGunfHs5IopDAVFYGz3M5LPVEUov+jkN/1gvf3
jhzl48mnCpJFPPG5VFGQxZCQt+S7Hv+Dq1/qHvZN7DwL9lsWAUkXitfIv2Pgjpdq
f7qZR2VQUDPMmKhZ6c0uIjgBCvJwNttwhY3d+KEX0JxxpTBkQm1gJrQBrYY2G5lz
GizCidvmHCgPwGG1fI6jbL0+2a7oiXG2Z+RuUd64wZHtUxgfalMNCqKyGgCqfgD0
pca6A7kJQtItsHDCmHX/fYeZIBNYunSn9z0gQxA1lWnPmiwTu2wFHiU2WFCKcGvH
slouX42puZxba497gFSC11NzgVi5LrapvtDA5it7vWdrxj2gmvSUhsiET0GmVNoa
6C6sl+p7Vzt4MmO8Nfyp
=2DRu
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
