Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab2LAPLW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 10:11:22 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:55438 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab2LAPLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 10:11:20 -0500
Date: Sat, 1 Dec 2012 16:10:20 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: Lucas Stach <dev@lynxeye.de>, Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
Message-ID: <20121201151020.GC18209@avionic-0098.adnet.avionic-design.de>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
 <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com>
 <20121128212301.GA25531@avionic-0098.adnet.avionic-design.de>
 <50B73710.2040102@nvidia.com>
 <20121129114704.GB6150@avionic-0098.adnet.avionic-design.de>
 <50B7AB93.5060207@wwwdotorg.org>
 <1354265429.1479.187.camel@tellur>
 <50B9EDA9.2000500@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qtZFehHsKgwS5rPz"
Content-Disposition: inline
In-Reply-To: <50B9EDA9.2000500@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:YzOiipPkI0cbqcGkNfnPYcsBseCklkg/QcwR8CgE3nL
 N+zrreqLXKGUgKaE0e11mIa3EcA0gLHrgeMge77spJ5ou13W6f
 1fDowTHbUA+je9UHNuGHRXwvaukqxqIIM+Cu95Yh2whEw+37W+
 MyzEqmVKTnfQZg7jvh2KHueUbBLvpPFFjgt/yzDR3OIz6Js2O9
 gJq96e6gFKlI64rIr1j0NXwhJaLdpKW1f+wk6ipIMGJItZIFOP
 WBqA/mR4U85DbXN6DDR842sb7DeDChZ9zs9Fp6tv+IY22vqiwz
 VRHJ/vWGbS/KmBERKH8nEoYLCB1XYqbGWAdsHReyXsjRJljbwo
 KIMA9fOrOWSoYnLABvSgz4Kl4WHiv5GuXiDMIhQjjBa2wSNoX/
 1zK4lwnqAjWi5mz8GXM6zRkSb4YfdLWhbc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qtZFehHsKgwS5rPz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 01, 2012 at 01:44:41PM +0200, Terje Bergstr=C3=B6m wrote:
> On 30.11.2012 10:50, Lucas Stach wrote:
> > I'm with Thierry here. I think there is a fair chance that we won't get
> > the API right from the start, even when trying to come up with something
> > that sounds sane to everyone. It's also not desirable to delay gr2d
> > going into mainline until we are all completely satisfied with the API.
> >=20
> > I also fail to see how host1x module being in the DRM directory hinders
> > any downstream development. So I'm in favour of keeping host1x besides
> > the other DRM components to lower the burden for API changes and move it
> > out into some more generic directory, once we feel confident that the
> > API is reasonable stable.
>=20
> host1x module being in DRM directory hinders using nvhost from anywhere
> outside DRM in both upstream and downstream.

That's not true. Nothing keeps the rest of the kernel from using an API
exported by the tegra-drm driver.

> I also don't like first putting the driver in one place, and then
> moving it with a huge commit to another place.

Hehe, you're doing exactly that in this patch series. =3D)

> We'd just postpone exactly the problems that were indicated earlier:
> we'd need to synchronize two trees to remove code in one and add in
> another at the same time so that there wouldn't be conflicting host1x
> drivers. I'd rather just add it in final place once, and be done with
> it.

Yes, there would be a certain amount of synchronization needed, but as
Stephen correctly pointed out we could do that move through one tree
with the Acked-by of the other maintainer. The point is that we need to
do this once instead of everytime the API changes.

> But if it's a make-it-or-brake-it for upstreaming, I can move it to be a
> subdirectory under drivers/gpu/drm/tegra. Would this mean that we'd
> modify the MAINTAINER's file so that the tegradrm entry excludes host1x
> sub-directory, and I'd add another one which included only the host1x
> sub-directory? The host1x part would be Supported, whereas rest of
> tegradrm is Maintained.

An entry for drivers/gpu/drm/tegra/host1x would override an entry for
drivers/gpu/drm/tegra so no need to exclude it. That said, there's no
way to exclude an subdirectory in MAINTAINERS that I know of.

My main point for keeping host1x within tegra-drm for now was that it
could possibly help speed up the inclusion of the host1x code. Seeing
that there's still a substantial amount of work to be done and a need
for discussion I'm not sure if rushing this is the best way. In that
case there may be justification for putting it in a separate location
=66rom the start.

Thierry

--qtZFehHsKgwS5rPz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQuh3cAAoJEN0jrNd/PrOhK0wQALMgpGjr0xCldidQzYzoX0Xx
kf3OmyOnA2W+WVyYCdDRKjuyoamtmrjDYNKqbOqEK4Ri87nEgd6WoAyzsrBxNGjD
NWJt1TXszOgy0vYZcGE80QiEoqDAjSfTE530LSKkaSA1L/yjPQ0DmYcIWHs1AYnS
WEgN4uVcGOQisA1GxzUYu3D7LvIMxc84bH637QYOx1VYZZyBzqggOz3auzNITypB
XKhZHzi9ox60yNjKS5B9SSt7ZMyWJa+lz4em9v4suPDQWGl68GTmsaP8fjkJ45Ot
EOVDgI8UfRaC0pQC6DrDd/mjEPFrnpDpBJozqvFi5wJ8r0cJwzcO0WNI+qCFunuk
OZPjR+q1OSSa5rqkvhNf3/FiC+lxYRBJmGxwtMlZNIk52FCw9s3LT1txp/tqt5sg
ZQ8afztUH7/bFRz7xDZbrsA3FwdGt68bVswITW3Yz6cP3Z4IKBl5OradTVWZUfaO
D04GlDKa4p9xlbk04MJiiWbziC+uo1/PSTn9aiIho5R2+YXRM/z5tbvfoBf2kkNN
NwvvslzE7WvRVIylClryIojRsITci8WWl7mXjjY52igUqqlTa6RbY1v9SGCDIiqD
enJiEUzD/nRqrdRJniXAezIxnfTqhN5EhlwKJF1YzettW4ECvWFJnLyM643rSksY
11kNtHedMyAEJh+juJYa
=E6Dd
-----END PGP SIGNATURE-----

--qtZFehHsKgwS5rPz--
