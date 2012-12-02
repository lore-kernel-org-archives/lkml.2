Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab2LBUzh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 15:55:37 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:54549 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab2LBUzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 15:55:35 -0500
Date: Sun, 2 Dec 2012 21:55:27 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: Dave Airlie <airlied@gmail.com>, Lucas Stach <dev@lynxeye.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
Message-ID: <20121202205527.GA22086@avionic-0098.adnet.avionic-design.de>
References: <20121129114704.GB6150@avionic-0098.adnet.avionic-design.de>
 <50B7AB93.5060207@wwwdotorg.org>
 <1354265429.1479.187.camel@tellur>
 <50B9EDA9.2000500@nvidia.com>
 <20121201151020.GC18209@avionic-0098.adnet.avionic-design.de>
 <50BA3668.1010504@nvidia.com>
 <1354383291.1503.25.camel@tellur>
 <50BA5AB2.8000604@nvidia.com>
 <CAPM=9tzUYkMZhwReSDLxvMYvgDmXukajm8EMqtzqmcNeD+oMAw@mail.gmail.com>
 <50BB3A5D.6070304@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <50BB3A5D.6070304@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:R1as919DdpnjyIYlBzTcOGQDCTS13fq3VxwOlF8uKAa
 xMgS49tCZKEnsMt5mNk2k6/GQNPP7g81RClDiu2yGYO3GAFCti
 qMrrWrKKZ6lKs7PZDj24wxApV2BEW67hy01HSdj7un+1QcpeYu
 ohg4bNyVq4qwv2Zy2+p9QIWCzA4Ujz3GHbQxdEq3cJmKcrl74j
 /PBOIunhOGYnOVtup7T8Jp/v7zkregvjUyxal1djbPobvmiwvf
 h3WE8gfw2lKH0l6xT/FzkZRuKehN824vxcPkIuln/AODFZVOiU
 tFts7eedVkAMrPjZHJZL9OgUoE6iu0wuExlIP1VjN24I5vq+KI
 FYxC0gHn6NQKmkl8JUMYwamEGAQo2e/lSqoQ7MPP11BXwcdaAE
 zuOw27UnnNJYbfYhZQbek6u6TFFJMZ0P8o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 02, 2012 at 01:24:13PM +0200, Terje Bergstr=C3=B6m wrote:
> On 01.12.2012 23:42, Dave Airlie wrote:
> > Guys I think you guys might be overthniking things here.
> >=20
> > I know you have some sort of upstream/downstream split, but really in
> > the upstream kernel, we don't care about that, so don't make it our
> > problem.
>=20
> I am not trying to make anything your problem. Most of the issues we
> have already worked out with a good solution that all active
> participants have agreed with. We have only a couple of disagreements
> with Thierry.
>=20
> My goal is to get a good open source co-operation and trying to prevent
> a code fork while still maintaining good design. That way everybody
> wins. The way to do that is to base our BSP on upstream kernel.

Yes, that's exactly what you should be doing.

> I'm not trying to here throw code over the fence and flee. This is a
> genuine attempt to work together. I want to prevent the "we" (kernel
> community excluding NVIDIA) and "you" (NVIDIA) that a split code base
> would cause in the long run. I'd like to just talk about "we" including
> NVIDIA.

FWIW I'm convinced that you're genuinely trying to make this work and
nobody welcomes this more than me. However it is only natural if you
dump such a large body of code on the community that people will
disagree with some of the design decisions.

So when I comment on the design or patches in general, it is not my
intention to exclude you or NVIDIA in any way. All I'm trying to do is
spot problematic or unclear parts that will make working with the code
any more difficult than it has to be.

> > There is no need for any sort of stable API between host1x and the sub
> > drivers, we change APIs in the kernel the whole time it isn't a
> > problem.
> >=20
> > If you need to change the API, submit a single patch changing it
> > across all the drivers in the tree, collecting Acks or not as needed.
> > We do this the whole time, I've never had or seen a problem with it.
> >=20
> > We don't do separate subsystems APIs set in stone bullshit, and all
> > subsystem maintainers are used to dealing with these sort of issues.
> > You get an ack from one maintainer and the other one sticks it in his
> > tree with a note to Linus.
> >=20
> > You can put the code where you want, maybe just under drivers/gpu
> > instead of drivers/video or drivers/gpu/drm, just make sure you have a
> > path for it into the kernel.
>=20
> Follows exactly my thinking, as the location of host1x driver has no
> practical consequence to me.
>=20
> Thierry proposed drivers/gpu/host1x. I'd like to see a couple of
> comments on that proposal, and if it sticks, follow that.
>=20
> Thierry, did you mean that host1x driver would be in drivers/gpu/host1x,
> and tegradrm in drivers/gpu/drm/tegra, or would we put both in same
> directory?

Since tegra-drm is a DRM driver it should stay in drivers/gpu/drm. I can
also live with the host1x driver staying in drivers/video, but I don't
think it's the proper location and drivers/gpu/host1x seems like a much
better fit.

Thierry

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQu8A/AAoJEN0jrNd/PrOh9W4P/3kiHYiSJO7icJXK2W0CM4Au
H7od1z2pAl+uZzZRHypaVAqpA3nDzZnFrn+zIAbWHe17wW+wdIf+KUDNomsiYKyC
pkWczIGQbU9slw1q0sr2IpJ124e3lPiGs2YjFfmvl+Sj3xPrY51Nl8B4RDXxjlSe
yBRpmHsO8ZEmpiqHazb09U/cZfo/Fng6qVdz+MP5iV5p07hqfA8IQJiBNvHXXO8w
AeaiNeXMFP29ykZ18FpqLhZUdD84M9CdN8KI35nRLKfjVXv2gS3MfiMnB2XjvaZC
OovFPOV7IKPMQyRFjrjs7RC6nmVf5sm+OFb+2FUpeTIVCzRMaE8X3doggng4ETjq
TRbe0i0+uViQ1UbH61+g09xZ1QMHIXumraQAeK47GRccP9J35NTYsEURopIDeUQI
cpFyhYw9ETTpTFdNoCa5kAkG0L0c+hLlruio3KrVcqjBaF7Py+P9VJW4VqHVEFmW
Q9kgd95tyVqqxEBqnsnkNAjcQ3yXRxEvdKRkrHVLbuycWl1SW0ou4Hjg3wnmVIrs
w41r3JjYX+cm6nDL2gDhVNqbyQ32nsNRxYTmh9Q4RoJtstaeukbKlFxIN0HuAry9
HokuOWXEZZNwvZljKtDS3ajMsuvGvqUnEW8qo9iTu7zHVTxO3KD31v/I785yhfIT
t/ILSUYS1wq4kmQ7kEFh
=ZpTe
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
