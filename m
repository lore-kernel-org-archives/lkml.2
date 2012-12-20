Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab2LTUbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 15:31:17 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:56827 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab2LTUbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 15:31:10 -0500
Date: Thu, 20 Dec 2012 21:30:59 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
Message-ID: <20121220203059.GA12977@avionic-0098.adnet.avionic-design.de>
References: <50CA175F.60002@wwwdotorg.org>
 <50CAC2AC.1010704@nvidia.com>
 <50CB5205.1030303@wwwdotorg.org>
 <50CB850F.9090704@nvidia.com>
 <20121216121603.GA31780@avionic-0098.adnet.avionic-design.de>
 <50D2D792.1050401@nvidia.com>
 <50D34775.5010606@wwwdotorg.org>
 <50D34F00.4080308@nvidia.com>
 <50D3511F.2090308@wwwdotorg.org>
 <50D35287.3040509@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <50D35287.3040509@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:aTeaD0djZRmO+I4Q7kST4H6ZoQ8wE5RSe6YKwjMxocT
 UuEkTpX9Wy7R76T6yTbXo7EPqyOzD7QOfGgnc4zNG1qhMqCriZ
 H8XDa2x5GOhKDe7z+BPuvOSi6kkrwvPYjaiSmFJLN3W/LDn7hN
 JL8Qde1XqU3F7WhiWBG2J7PNXlSKBV+hXn22oPrZWJV/yg3Mzv
 SsgIOZlai5o+4K0QHnxGnKY8AeuYNqZo7OSV++kWDsAVVqGIZj
 fAJQgiNqBfbmgFpfDKioVPyH231M2UOwbrMNS86khIoLzQYnFQ
 BX9F+zMrlAkAshJKOHwyAg+rTsTzijuxgxMmCo1ryu4BydKTsa
 7z02k4ft8+0nrcqgdhf6waxSBCy28UXepQ4KH4NatIAK55qJZ/
 T4yCqBZpcoe14hwSySsM/QmdPVk40wm9r4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 20, 2012 at 08:01:43PM +0200, Terje Bergstr=C3=B6m wrote:
> On 20.12.2012 19:55, Stephen Warren wrote:
> > So it's fine for the tegradrm driver to manipulate the tegradrm
> > (virtual) device's drvdata pointer.
> >=20
> > It's not fine for tegradrm to manipulate the drvdata pointer of other
> > devices; the host1x children. The drvdata pointer for other devices is
> > reserved for those devices' driver's use only.
>=20
> They're all tegradrm drivers, so tegradrm can manipulate its drvdata.
> The other simple way is global pointer. Let's aim now for a simple
> solution, and if later we find out it causes problems, let's fix it then.

The problem with your proposed solution is that, even any of Stephen's
valid objections aside, it won't work. Once the tegra-drm module is
unloaded, the driver's data will be left in the current state and the
link to the dummy device will be lost.

I don't think waiting for things to fail is the right option here. If we
can make out this problem now, then now is the time to fix it. No
excuses.

And quite frankly given how all the various host1x components are
interlinked I think having a single function that gets the DRM dummy
device for DRM-related clients isn't that bad.

Thierry

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ03WDAAoJEN0jrNd/PrOh1WgQAK/rL1FnYmQuGqGMjtHjNjWQ
kWygOKJ6T4HZB9KvjANxpmdDUNvPxexJM00UPExzwmDDv5K86wGx+1nwSazyvIag
VBRli2Wiv04F2JzM6jjnLPLfYb59E+eczrMljfaBTx/wXPUbTkrEbAXb50pyZF1K
NMjOF+PT2ToYGIdPN1ZVQFjkq/KDxTC1XuNSjtRZQtkdZmG+SAiFUUPM8I8VA4y+
FOhYLDvznTijtQgMZcUxyut2Jg/TqcMHk0N2Phbbdl+lqZDrCwoS4ZxvmCLWc8MI
NAfBYjREcH+w8GactIjS4G93ZfNTKuZ/wRGcRHE592q/wjsEH+UNaPmHpJ3CQk8L
yZ98JmeIdUAz+2NW05VOL/80GRlPRJK0OkteLgJDzCBmADjqmh9bfMsa8RomHaNH
UOpah/uKSGwEin5UhDF9ptJfs+Jyoe2XRGd8wczK6dxp6t9wYEy0JEwnLfyBIqBs
Yb70sLGqIHPrd/fixYbYtyn1BiKVSenUm6DfZWBjs6n319UzGkBxTPsh9FywPpHg
2pWEOGVAyAtDIZI8VbhBkx6HDEOXDRsHnMsuWuqg7xXZZobP+VZChIyiE8pjA4GZ
rDblnVJMTUDcNCQMwFUvFmGHuVcGYFreQB9LtNElLriVFcY25u/G5B5YmposDB8x
e3NDGLxbIPIEfWs2muCd
=w19B
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
