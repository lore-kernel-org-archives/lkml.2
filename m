Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab2LEMEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 07:04:44 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:56114 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab2LEMEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 07:04:41 -0500
Date: Wed, 5 Dec 2012 13:04:29 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
Message-ID: <20121205120429.GA29943@avionic-0098.adnet.avionic-design.de>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
 <1353935954-13763-7-git-send-email-tbergstrom@nvidia.com>
 <20121205083335.GA20984@avionic-0098.adnet.avionic-design.de>
 <50BF1DAA.8030805@nvidia.com>
 <20121205111332.GA25676@avionic-0098.adnet.avionic-design.de>
 <50BF345A.8050201@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <50BF345A.8050201@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:WNFHqeMFpX4ArHKE9Zwvl2fRT3DWK+MrwbKBtG3nbg6
 XUJgnL7JWfF+aCxY3E3hOxSdg9NX7eWumtSqUCVgZ6Y+P5nf3E
 5TR1cyY3Ybz6XIv0Us9cKUE8eUqD45/x/HRByyxGO4jECTyThK
 Cxt7sCX6n5ittk5C+SLd2bXAalnXViEAqZQJL/lH5jykJaMUU7
 MS4zP3txNpV95yc6xQ3EGCQSt7iX7Eors4SoFiA623gK/09eHO
 NzL89jrePcvau5NBPRRKdduuxoDvoAICXKIyTUS9KAnEMelWef
 C7Z9KL2UPl+ax9SoE272iQEVOyJUEzeshaDo2Us5vK00na1LSE
 LsoQ+2QyYvnUdLbidfL00d4FRvxz4sh6dTn5NWEPDpLCptvR3s
 uveYlpOHEI7lyMTuxUNKGWVT68vg4uz2T1nAKYKyZ/c5+UZY3h
 4Luiy
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 05, 2012 at 01:47:38PM +0200, Terje Bergstr=C3=B6m wrote:
> On 05.12.2012 13:13, Thierry Reding wrote:
[...]
> > Oh well, at the time nobody from NVIDIA was involved so I wrote that
> > code in preparation for proper host1x support that I thought I would
> > have to add myself at some point. I'm more than glad that I don't have
> > to do this all by myself. However the patch proposed in this series
> > breaks a number of requirements such as proper encapsulation, which I
> > already mentioned in more detail in another mail.
>=20
> Hmm, I'm not sure if I remember that you refer to by the proper
> encapsulation. Is that the fact that we bind DRM to a sub-client?

Yes, but there's more. For instance I went to great lengths to make sure
there's no global data whatsoever. So all the data is bound to the
host1x device in the current code. I know many other drivers like to
take a shortcut and just put these things into global variables but I
didn't want to.

> > The problem that this solves is that the DRM driver needs to be bound to
> > a specific platform device. None of the DRM subdevices are suitable
> > because they are only part of the whole DRM device. I think that host1x
> > is the only device that fits here.
> >=20
> > Note that this is only an administrative problem. It shouldn't interfere
> > with the way host1x works. The goal is that the DRM device is registered
> > at the proper hierarchical location.
> >=20
> > The circular dependency is indeed a problem, though. Quite frankly I
> > have no idea how to solve this. However the approach taken in the
> > current patch will break several other requirements as I already
> > explained.
>=20
> The problem with doing drm_platform_init() with host1x device as
> parameter is that drm_get_platform_dev() will take control of drvdata.
> We'd need to put host1x specific struct host1x pointer to some other
> place and I'm not sure what that place could be.

Not anymore. I submitted a patch so that it no longer does that. The
patch was merged about a month and a half ago.

> You're right in that binding to a sub-device is not a nice way. DRM
> framework just needs a "struct device" to bind to. exynos seems to solve
> this by introducing a virtual device and bind to that. I'm not sure if
> this is the best way, but worth considering?

That was discussed a few months back already and nobody seemed to like
the idea. In fact it was as a result of that discussion that Stephen
brought up the idea to register the DRM driver from a central host1x
driver (it may also have been part of a discussion on IRC, I don't
remember exactly).

At the time I spent some time on a patch that introduced drm_soc_init()
to solve this by creating a dummy struct device and registering the
driver on top of that. But I abandoned it in favour of fixing the DRM
platform support code. The approach also didn't provide for the proper
encapsulation.

Thierry

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQvzhNAAoJEN0jrNd/PrOhIeMP/2/V0pxcl4DCTygfnj8uKpct
Kq114ZrGx8hZxjOCFQ62hFcANKjDB83NTgjGyAViECYsEdlyP6LJ+1UBgHWhq3/j
k7mHEBEUqGT5/ZLauDB7K1GBSKoWcu/qvfkIBV/UdfIQaXzffgxRN7xuP1/1ljaO
SjAqplgqUualzPz+AiXXP9JbvuJKyt6p8K/JLvbNTh68GS6wRGbbdoYQ51k2lLtI
EGVf2whswkOCSdZ8SRIzNeFf96eoqnlsD/VPuxTf9I5X260r3MM8Hu3FOt37WTQj
e8dKg++uk6aBoR1moG4C5fe29ihNhoii2kaPsv5ViOODUUZNA2DFtsvItCsk/y6Z
AzKIYSNf6BF9Rfkaz65TN3tQTG6tnDmMGlogCdrRMNIJiaNLMJjwvxJhMT+jhP7T
iI1yBmdiHJIluMdz2FkT9gt0eqi13zenkuQ0HaGSAS6B1zTjbBh1Ww4N1aLoEIK3
h79bWkq/WQyJcA3FlnOjEwTeTFz6ZMXyTI+S6wmzd04wFSgqLfXZdyXNE1AsPgl4
DXpw9f9ft/lXhDSS/27HVyNUIXZJTJ/8Xo284xcs1GM0b9qebcmSf0yGnZ85vNi5
jkOAdxfpJFBA8QRPQpgzMXysNbYkORlP/kVFoW445eJVC3CiP65XE4v+SUhFMEFa
ZFKGhrWV1BqsxShzx8Vr
=84c4
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
