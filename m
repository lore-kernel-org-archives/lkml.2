Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab2K2MOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 07:14:40 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:52098 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab2K2MOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 07:14:38 -0500
Date: Thu, 29 Nov 2012 13:14:30 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Lucas Stach <dev@lynxeye.de>
Cc: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>,
        Dave Airlie <airlied@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 8/8] drm: tegra: Add gr2d device
Message-ID: <20121129121430.GA3846@avionic-0098.adnet.avionic-design.de>
References: <50B60EFF.1050703@nvidia.com>
 <1354109602.1479.66.camel@tellur>
 <50B61845.6060102@nvidia.com>
 <1354111565.1479.73.camel@tellur>
 <50B6237B.8010808@nvidia.com>
 <1354115609.1479.91.camel@tellur>
 <50B63A70.8020107@nvidia.com>
 <1354128408.1479.137.camel@tellur>
 <50B71A28.5060807@nvidia.com>
 <1354180153.1479.162.camel@tellur>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <1354180153.1479.162.camel@tellur>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:g72e4NLcR2ZkwJMSWE7qK/gBOH6UMuFY/u8KPYth5DN
 824sHHLtmqLekjE6FB9Hwwbed93kGBfERqkO7hcctHHNFCoftG
 8nTYlu90lVlNBgjDqc0T5+tJwmrQgKdpYxtuOLe+BVQd+Rpxo9
 jnmEmWWJLlhRKsC9xYv74cYyytfcxrtCS+4IADToUppOoFUVxu
 zCnE5a7+DlHfpfoIiKBvnmfd7H6UlARf99gZYLVcl3fz5poIcA
 Jovp9lZ0HJZFuWibuqKdWjr+3fpgOPtQBcgsPwyp8QLp3Sn3Z/
 6nndkzDQmJhWFMX3Fw/0kaJM7ySevHyeT7J9VzBLcaAqY/Yfyj
 P9RWgY5DNONTqHg7vlMOK5TqGgixgsk+5wLti2auyHaVn/d1Ei
 I3cHFH9QqakO/pn97g6jLlLs+UP8si+rZo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 29, 2012 at 10:09:13AM +0100, Lucas Stach wrote:
> Am Donnerstag, den 29.11.2012, 10:17 +0200 schrieb Terje Bergstr=C3=B6m:
> > On 28.11.2012 20:46, Lucas Stach wrote:
> > > Am Mittwoch, den 28.11.2012, 18:23 +0200 schrieb Terje Bergstr=C3=B6m:
> > >> Sorry. I promised in another thread a write-up explaining the design=
=2E I
> > >> still owe you guys that.
> > > That would be really nice to have. I'm also particularly interested in
> > > how you plan to do synchronization of command streams to different
> > > engines working together, if that's not too much to ask for now. Like
> > > userspace uploading a texture in a buffer, 2D engine doing mipmap
> > > generation, 3D engine using mipmapped texture.
> >=20
> > I can briefly explain (and then copy-paste to a coherent text once I get
> > to it) how inter-engine synchronization is done. It's not specifically
> > for 2D or 3D, but generic to any host1x client.
> [...]
> Thanks for that.
> [...]
>=20
> > > 2. Move the exposed DRM interface more in line with other DRM drivers.
> > > Please take a look at how for example the GEM_EXECBUF ioctl works on
> > > other drivers to get a feeling of what I'm talking about. Everything
> > > using the display, 2D and maybe later on the 3D engine should only de=
al
> > > with GEM handles. I really don't like the idea of having a single
> > > userspace application, which uses engines with similar and known
> > > requirements (DDX) dealing with dma-buf handles or other similar high
> > > overhead stuff to do the most basic tasks.
> > > If we move down the allocator into nvhost we can use buffers allocated
> > > from this to back GEM or V4L2 buffers transparently. The ioctl to
> > > allocate a GEM buffer shouldn't do much more than wrapping the nvhost
> > > buffer.
> >=20
> > Ok, this is actually what we do downstream. We use dma-buf handles only
> > for purposes where they're really needed (in fact, none yet), and use
> > our downstream allocator handles for the rest. I did this, because
> > benchmarks were showing that memory management overhead shoot through
> > the roof if I tried doing everything via dma-buf.
> >=20
> > We can move support for allocating GEM handles to nvhost, and GEM
> > handles can be treated just as another memory handle type in nvhost.
> > tegradrm would then call nvhost for allocation.
> >=20
> We should aim for a clean split here. GEM handles are something which is
> really specific to how DRM works and as such should be constructed by
> tegradrm. nvhost should really just manage allocations/virtual address
> space and provide something that is able to back all the GEM handle
> operations.
>=20
> nvhost has really no reason at all to even know about GEM handles. If
> you back a GEM object by a nvhost object you can just peel out the
> nvhost handles from the GEM wrapper in the tegradrm submit ioctl handler
> and queue the job to nvhost using it's native handles.

That certainly sounds sensible to me. We would obviously no longer be
able to reuse the CMA GEM helpers, but if it makes things easier to
handle in general that's definitely something we can live with.

If I understand this correctly it would also allow us to do the buffer
management within host1x and therefore allow the differences between
Tegra20 (CMA) and Tegra30 (IOMMU) allocations to be handled in one
central place. That would indeed make things a lot easier in the host1x
client drivers.

> This way you would also be able to construct different handles (like GEM
> obj or V4L2 buffers) from the same backing nvhost object. Note that I'm
> not sure how useful this would be, but it seems like a reasonable design
> to me being able to do so.

Wouldn't that be useful for sharing buffers between DRM and V4L2 using
dma-buf? I'm not very familiar with how exactly importing and exporting
work with dma-buf, so maybe I need to read up some more.

Thierry

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQt1GmAAoJEN0jrNd/PrOhfJkP/iZfByPP6xGaBeMO6Lc7s2uw
pVuqVTOrFJJWASXTwy3j5/3WEQ6k1QroOH+vbB8ChDGTRve63WsAAXWmVAU4w7kn
H86S4G1EefGSYawLD2msUP+/Rb8cjZSI/6es9/S0A91dK7qY12sBWWCIwfILlFu9
onqvvHFJsfusblVuwJMYZ1ys6KLh/cE5U+lT9toGj/I1vNtugq4kei/d97krs3ra
v6mSvu1o0pPbDtuxyS4qCm6QMQon9ES63SiOWEjVeiwRmWktdzuowUf6gCHIe1lx
cSsF3p0whcT/iLB4z6QdhWVqVLmvUz5ehaGZcBMMS2F9e5joHD/lkDPytjz/RuGa
ZEaGaG4JV4nMNDRI7SJHYZ2Dv4+UE7oDQDu4zRpjGyRnElvEbiDnw2yT5/86gD4b
GBQYvQXjtm2f0XEsaomYpw2+gxv6TE/IjCqJJgluL6gZ58PxuI3xhQWglYlvW1jF
k7tw6MMVTZxynump3uwYhDmG6OmnzifrqVjNRkAynTjHhhdvYBpU04zdFuBZkkwU
ctdyzB3Zg/6P+ZhjwFETL8233cfpcsjNwv01KUi/W/Ne/c0b8kODlY692QtqwYPZ
5qBHx776g0r+0dkdJ47AvCZtekphIqCLG+AksUxGJyCzvbOHSw9QRfWIXrJsGu7/
RsRb+bqoTU+FYS7HY1cw
=FBfz
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
