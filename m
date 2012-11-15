Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab2KOHLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 02:11:08 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50589 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab2KOHLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 02:11:06 -0500
Date: Thu, 15 Nov 2012 08:11:01 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: tegra: Add Tegra20 host1x support
Message-ID: <20121115071101.GA15528@avionic-0098.mockup.avionic-design.de>
References: <1352467202-27903-1-git-send-email-thierry.reding@avionic-design.de>
 <1352467202-27903-2-git-send-email-thierry.reding@avionic-design.de>
 <50A357D3.9080002@nvidia.com>
 <20121114084931.GA31837@avionic-0098.mockup.avionic-design.de>
 <50A3712E.7000104@nvidia.com>
 <20121114105406.GA31455@avionic-0098.mockup.avionic-design.de>
 <50A3C485.7080704@wwwdotorg.org>
 <20121114200415.GA10335@avionic-0098.mockup.avionic-design.de>
 <50A49211.4060303@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <50A49211.4060303@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:WHuFB1MOjt7nEIXMwCnSBUr9bSQYutyxULceKeHk4YO
 odA51DgmhytSbDj3wx2KlroFOX/hNwnBVODYBZApNWDaqvOc+A
 ryW86nAhyMdoveurcM9EBeDh7iEEGr0lcvzD248wS77W2Ei293
 Tr19vq05Q0Zye+DjEZzeg6WTlNzwnqlAF9jyiymGeoHpWDpmFi
 4z9UiE2MhG3UWBljiRGGNxK953l5gwxN9bDv86hN9Fug4OyUPa
 iCV5VkQRzFx6RS1xSSwb5ji/+ZZFeNC451RW8sPUnuiPukVJz/
 ZdA21dLiqs/TxJLI2L5/cHfU4R+OBKvyozU6eAeA5SdAcmfu6J
 ZS3tPwK29FKEMMx3G1ioz7r4ch21/PgrPWeQtP5oqOxNtME0qp
 R3LwezLSPuRp9ZDiHtQd6TIYbQTIMyBf0QLYUsrDNJ6GJPVeP5
 LgVJo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 15, 2012 at 08:56:17AM +0200, Terje Bergstr=C3=B6m wrote:
> On 14.11.2012 22:04, Thierry Reding wrote:
> > According to tegra20_clocks_data.c, the maximum clock frequency for
> > host1x is 166 MHz, so 216 is probably not a good idea. 150 MHz sounds
> > sensible, though.
> >=20
> > I was going to send a new version of the patch set tonight, but I'll
> > wait until I can test it tomorrow and once Terje has reported back that
> > things work fine.
>=20
> Hi,
>=20
> I tried with 150MHz, 133.3MHz, 100MHz and as an act of desperation
> 300MHz. None of them worked. pll_p with 216MHz seems to be the only
> option that works on my board.
>=20
> But, as said, this seems to affect only the case where nvhost is
> integrated, too, so your patch creates a working DRM and frame buffer,
> so I'm fine with leaving it as it was in the original patch set.

I just tried with 150 MHz as well and it seems to work properly. So as
Stephen pointed out, 144 MHz is not a supported frequency for host1x,
and therefore I'll just leave the valid (and working) 150 MHz in.

> Meanwhile, we need to figure out if we somehow misprogram PLLC or host1x
> clock when it's attached to PLLC on Tegra20.

Yes, absolutely. Among other things there's still the upcoming and much
needed rework of the PLL frequency table code, so while at that we could
look at the issue you're seeing as well.

Thierry

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQpJWFAAoJEN0jrNd/PrOhMYcP/1058PAw6WMUj7Jy/pk/HT4G
x3qF9hdxJGvEzPplLIlDWKWL1CVSV0U7a9nIbjJj44puaWsievLTxGLfzuq7qDkf
uaoN3GI6JRwZjunFUPJnBzJaaTNl8tgWRCqgyEunVLsz9tPUrRuReyWkq1hp5xSt
Cwnqc+DBSO/IXzJuPYBmRGWCBkNBwZ9gh1iSVGaSK1uswU3LPic2ZYYYtxFlBfUi
cJlTlWcOzPsXgqI1NXEH51L0EP3Z7RwZ4ZBZDN8SFgjjITz+AlMNucu0fPV9XkVq
9y7MBXcagjFBL4buyyv71G5NETHv7DhDv3fazYTcjeCWyF63XwJLDkZwDZPgyOrv
gZMRDhf2NJQbJNfbL2R0YTQNgcDYUwG1hUGSfSIZ/A+hxwV1O6yt3jzabR2bh0HE
FVQG5kWVnA9xP0DEcM8fLXVVO4U/i6sl8QPQH/3Wk7UcOKm5hzNMbGNSz047nO5p
b9A5jam7qSkQlbQTxqPBT9P8ZgXLe47xu8MfYiy/AWk6cctIjfTqiyiNLudW/s1g
Nr8WsSjS51S5y5hLV9yDHxXyzI0ifn01plmGsBByE4LD89GMbJftT6lPhdc8IVMm
yn6lwj4MSkTorrtXEIPSYRNu8jYW43fpU07X9lvcybD4Xw4GzvEvuREVBWUW8FBE
BkCn+8pEKNoriy6x4ULU
=PYDF
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
