Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab2L1VVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 16:21:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:61318 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab2L1VVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 16:21:34 -0500
Date: Fri, 28 Dec 2012 22:21:25 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dev@lynxeye.de" <dev@lynxeye.de>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [PATCHv4 5/8] drm: tegra: Remove redundant host1x
Message-ID: <20121228212125.GA4615@avionic-0098.adnet.avionic-design.de>
References: <1356089964-5265-1-git-send-email-tbergstrom@nvidia.com>
 <1356089964-5265-6-git-send-email-tbergstrom@nvidia.com>
 <20121221143614.GA16167@avionic-0098.adnet.avionic-design.de>
 <50D55820.7030302@nvidia.com>
 <50D938AC.50001@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <50D938AC.50001@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:YQTgEdwScEXktzIaSL174qRHv5nBKkjffgkUS/ishHP
 d+Rwrd4rmT4hhOk+89bNidWesZkGWTe8+UenmDcd/0Ejv6R5X6
 j0DZV90NoOazUuthyHMUzoYcqPWbLuoUwzxgm4Hv50OGuvJ3SW
 GJkiCuoGO5269lgnvtgpiy9J1jx8lYwhu7nGeV007UJMK5LbXZ
 NZgTnSFmuH0hLqtDV4kRDoeKjyQf5O907LiF+rujTfevW+yufa
 kyb15x8X/D7XDDwybwTbZzaLdxu9oAshVbL+D5+TS1LgV1cj5+
 Dli7QmaVLKdXKwEqGUbeLS+q66FZb7Oqf7u4KCzzpGoZ4maR5N
 JgZvPYv/mL/ZdCvSY27IkBsxfIVBuFnOPqV/OoCy6mldccoKlK
 RrtZy806GkwsDhUc5SiRR5O8dLWD/cJBiU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 24, 2012 at 10:25:00PM -0700, Stephen Warren wrote:
> On 12/21/2012 11:50 PM, Terje Bergstr=C3=B6m wrote:
> > On 21.12.2012 16:36, Thierry Reding wrote:
> >> On Fri, Dec 21, 2012 at 01:39:21PM +0200, Terje Bergstrom wrote:
> >>> +static struct platform_driver tegra_drm_platform_driver =3D {
> >>> +	.driver =3D {
> >>> +		.name =3D "tegradrm",
> >>
> >> This should be "tegra-drm" to match the module name.
> >=20
> > We've actually created two problems.
> >=20
> > First is that the device name should match driver name which should
> > match module name. But host1x doesn't know the module name of tegradrm.
>=20
> There's no hard requirement for the device/driver name to match the
> module name. It's good thing to do, but nothing will blow up if it don't
> (modules can use MODULE_ALIAS() to declare which drivers they expose).
>=20
> But, what's the problem with host1x knowing the driver name; the host1x
> driver and tegradrm driver are both part of the same code-base, so this
> seems trivial to achieve.

Indeed. If we define the name to match the tegra-drm module name, then
just changing the above line is fine. This doesn't need to be automatic.
Making sure that both strings match in both drivers is enough.

> > Second problem is that host1x driver creates tegradrm device even if
> > tegradrm isn't loaded to system.
>=20
> That's fine. If there's no driver, the device simply won't be probe()d.
> That's just like a device node existing in device tree, but the driver
> for it not being enabled in the kernel, or the relevant module not being
> inserted.
>=20
> > These mean that the device has to be created in tegra-drm module to have
>=20
> I definitely disagree here.

Instead of going over this back and forth, I've decided to rewrite this
patch from scratch the way I think it should be done. Maybe that'll make
things clearer. I haven't tested it on real hardware yet because I don't
have access over the holidays, but I'll post the patch once I've
verified that it actually works. The code is based on patches 1-4 of
this series and is meant to replace patch 5.

Thierry

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ3g1VAAoJEN0jrNd/PrOhdNYP+QF1RmnARufjikZWLFir28f2
loifaKJIkJAljifL+reDZdPzMRi6EZ2PYp6Sxllf2Yq6LJvH5JHkfjW7iME9DRT9
RBg/bZm6lxX2yBjY3z1gCEO0E/iBoXaYfBRc6GmbqPjjbsn5ntBscDsJTt9uo2GQ
2qlv+X6M3yyWOooFanGfTteLqn6ERXmIo1OEgzHaouNlFTsf8IzJ7sMn9oq0fefh
BnYKT/bFIbJxLCS+D3jWyXxxDpuqlG+8nbpTwmAp/oR6j6swDYyUrfq3GKjfhOMi
+LY9a/McBMRVMe7mfZlBO/RC+sjoVBM003Z7JxAADjR3MkgWfuYLI3WRu3rl2P9b
2nbSwAhdO9+Xchz82lD1TkBkOEQm87huSrxH/yqm7tJSbsbnLBReFYE5iBFth6OH
IG+dF3ShTVh6KgUN1zH2ienyvwP1j+7KW1yDTu8ZVilMnmiJ72Yx+yh41NeMPgOE
c/Rh20+JwV32rNf4iXkOpKdQtimph0X0kax+baW4QD5S5IF0/2Caf/VHDwdspXza
paBGQLeLWGoUz0wONFobuUKJ+l3lOJ1TKW/RLLPcm1yEOGHRXSMCidI4J9VqD9Lm
Tivj/mjTqpTXI1sf0LyVco5D2VuE3dYGVeRjr66ZRor7KmJxKP+7Ibl8YE57Jb3o
Gt3AkB1Ps1xvi3Ve9gP9
=qjEI
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
