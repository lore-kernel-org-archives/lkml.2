Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab2LAT3Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 14:29:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:53146 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab2LAT3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 14:29:22 -0500
Date: Sat, 1 Dec 2012 20:29:17 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 0/8] Support for Tegra 2D hardware
Message-ID: <20121201192917.GA19348@avionic-0098.adnet.avionic-design.de>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
 <20121201144512.GA18209@avionic-0098.adnet.avionic-design.de>
 <50BA397C.7050707@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <50BA397C.7050707@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:teRHckmpi1xtm4dHzqr1G3HlobFVraBjgd5pH+uDlM4
 cwVxuKpwgZ9M0jpjOU6V7Ume9s+GlArPlmm/FdOn/zspFHtuma
 2nG/8eVZx4LOmr5r2EotZMWyWnVI3LXIxS3V4+WciIruREpcI8
 kueBenc21CvUPD7Ur+8hhT0fwoqqJlQl3rUubPBNzLmv1fQyqi
 Ca6ZlRBcCnswzxkhLEp0zJk16UuWyHpFLsNXXRLZuQrD7DcqgO
 MwO/jd9659GbfFH7INuH/bAaBT9UKJfxrEEnHF+GzokwwlEqWt
 1ewSrLvIavvqscl3Gte5svcyGR7D51MHDDL3/aTAuuWS6IHLNz
 cFkfDo/zceXo+JKzNgdfc91cVEc8B+qVGBdSw4i9qaSF62vbIf
 5iOM4H7xpx0uk6UnLWQH7rXmdLoCvTQ4g0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 01, 2012 at 07:08:12PM +0200, Terje Bergstr=C3=B6m wrote:
> On 01.12.2012 16:45, Thierry Reding wrote:
> > I did some prototyping on how a libdrm API could look like a few weeks
> > back. I should clean the patches up some and push them to a public
> > repository or to the mailing lists for review.
>=20
> Ok. Sorry about the delay - I recently learned I need separate
> permission for user space contribution, so I'm pushing to get that
> permission.

Oh dear. Doesn't sound like fun. =3D)

> > There isn't actually much more than a bit of framework along with two
> > IOCTLs that allow creating and looking up a Tegra-specific GEM. The
> > related kernel patches aren't available anywhere since I didn't deem
> > them ready yet. At that time I wasn't even sure if we'd need special
> > allocations other than what the dumb BO infrastructure provides. They
> > implement some parts of what you've implemented in this series as well,
> > with some slight differences.
>=20
> Ok, the BO infra is still under flux as we're designing the best place
> and work split.

Yes, I've put the prototype under a --enable-tegra-experimental-api
switch, which has been used in the past for helpers that weren't
finalized yet.

> > While I can't find the quote right now, I seem to remember that you said
> > at some point that you were planning on adding some 2D acceleration bits
> > to libdrm. I don't think that's the right place. That code should rather
> > go into the DDX. libdrm should instead provide a thin layer on top of
> > the DRM IOCTLs to manage buffers and submit command streams. I hope I
> > can finish the cleanup of my libdrm patches over the weekend and push
> > them out so this may become clearer. Maybe I can even get the
> > corresponding kernel patches pushed out.
>=20
> Yep, that's exactly what I actually posed as a question in one of the
> earlier mails. We also agree that 2D bits should not stay in libdrm.
> That's why we've kept the 2D bits design-wise separate from the host1x
> stream generation.
>=20
> We don't yet have any other place to put 2D functions in, so we'll
> probably post them as part of patch series to libdrm. We'll just add a
> disclaimer that the 2D code won't remain in libdrm, and wanted to get
> the code out to review as a code example. We can put the 2D code either
> to a separate library or to DDX, whichever is preferred.

FWIW, I've done some work on an initial DDX, which is basically a fork
of xf86-video-modesetting rebranded and with some cleanup like ripping
out the PCI support. I wanted to do some testing before pushing it out
and I think I can get that done on Monday.

Posting the code early is exactly the right thing to do. We still have
to figure out quite a number of things and we can always move code
between the various components of the whole stack.

> The host1x command stream generation would still remain in libdrm. That
> seems to be the pattern with other hardware.

Yes, I fully agree.

Thierry

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQulqNAAoJEN0jrNd/PrOhtvoP/1WqBc2SPWYo3PvBus2z1jV9
/zG9pPLJ5VKMeS1zUF/xcb+1gDsZ+F0tTwaXOS+Nl0tzqN2lrHmsKXc5dFp2Ix3x
aREZ/01FvhigVCWuT4sUUDayauZuyQeZ17b+6UHuTcbWT6DjRkmlmq0wAdLcSq3D
qYKDJD/0loR7sUM/MeJCqE/rDl5uMTH0Vrs3frv+waupC56hbZ5s4zEhk7fzE0NE
q03ErJ4S4Fu1FjozKUrj8le5C/dTlXSDKVEt9DXDnDisY0ToxQPlO4/h9yhbyM4d
Ap4BoaES1v0BY1QprEkrxEdv9RPVMs1b5ejFdnLjevq7AOFEktLi85lP6/yqxqmx
nfwhSrI4CjXkTfE26tQsrVbznU4BDqzKwjEDhux+H8fDn4f47BqVGJ50Pi80V7Bn
yTSs86PG3zjw8m7D89GxqV1PvGwNh0GyQiQOUNq+ZMt8f5F0RiC+GdYqh7OESitY
BsHChmMd4NC0ZFwtYucQoUYxY94YhPHaWyoOPYzFf9hHG6e78sHCKrHq2dc2vnCE
3Scasr4d1LKx1k14YwgGqBCWCss6eMH47Q9oUeSzQl1MBMrjXzpKJbjohwDbt14K
lBEwLnv2OG5sJLdTqi0DZO7skofZFucsb64AYsQVqon2NKpxw4Smzwon3YiRVEd9
iuDVqn2Xp3HG16ayuEqO
=Ehdv
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
