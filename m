Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab2LLQIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 11:08:35 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57503 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413Ab2LLQId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 11:08:33 -0500
Date: Wed, 12 Dec 2012 17:08:29 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
Message-ID: <20121212160829.GA30278@avionic-0098.adnet.avionic-design.de>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
 <1353935954-13763-7-git-send-email-tbergstrom@nvidia.com>
 <20121205083335.GA20984@avionic-0098.adnet.avionic-design.de>
 <50BF1DAA.8030805@nvidia.com>
 <20121205111332.GA25676@avionic-0098.adnet.avionic-design.de>
 <50BF345A.8050201@nvidia.com>
 <20121205120429.GA29943@avionic-0098.adnet.avionic-design.de>
 <50C5CAB5.3040000@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <50C5CAB5.3040000@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:Mv5W3NSH4QdMPQGNuknrorgiAG9qscs7YiBLAix/d32
 Cw3Tpck/ElqGcXvMMwuoYLhxBI+jWFAuVRD0Q3wGeXY4ldY6ke
 DRwnkAPhgGnkSfMfobZ3wTWmFv7y9CpHuF+aGchwTBR8w6htMC
 6wzxffOODjtd9JiLioDo+7NmSy0YSHnxG36K+RV+il/XulDC4T
 MtUG4FgI4tHayaGZGe5MENwuCywKg9vOI3tq+9AND4HpcPc044
 Hv0jN6JNRHRl45/sQUmICOO6lb9Y2Qrr244/mResQ/7fvj0Rxd
 /+fxJuqCqm/1TJMb+DanGtQMIv+SgbOP0y8qVIX+Fb8BnPAY4i
 42JScn7nw4fE17+B/0CbGz5t0Z1TqfT6QGsr0rjnL21xvHlKOm
 t24UVQuIVjV8WPN8RVGR8ClZbrY4iD4bKmz9x3Ti03cUK7rJ/r
 93XMQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 10, 2012 at 01:42:45PM +0200, Terje Bergstr=C3=B6m wrote:
> On 05.12.2012 14:04, Thierry Reding wrote:
> > On Wed, Dec 05, 2012 at 01:47:38PM +0200, Terje Bergstr=C3=B6m wrote:
> >> You're right in that binding to a sub-device is not a nice way. DRM
> >> framework just needs a "struct device" to bind to. exynos seems to sol=
ve
> >> this by introducing a virtual device and bind to that. I'm not sure if
> >> this is the best way, but worth considering?
> >=20
> > That was discussed a few months back already and nobody seemed to like
> > the idea. In fact it was as a result of that discussion that Stephen
> > brought up the idea to register the DRM driver from a central host1x
> > driver (it may also have been part of a discussion on IRC, I don't
> > remember exactly).
> >=20
> > At the time I spent some time on a patch that introduced drm_soc_init()
> > to solve this by creating a dummy struct device and registering the
> > driver on top of that. But I abandoned it in favour of fixing the DRM
> > platform support code. The approach also didn't provide for the proper
> > encapsulation.
>=20
> I've managed to go through all the other feedback and implement a
> solution to most of them, so now I have some slack to actually think
> about the initialization. Sorry about this, but you (meaning all the
> reviewers) did give us a _lot_ to do. :-) Fortunately, the driver
> actually became a lot better, too.
>=20
> Back to the topic of tegradrm init. The root cause of the problem is
> that DRM framework needs some device to assign itself to. The problem is
> that this device doesn't have any physical counterpart, as it's only for
> storing a pointer in DRM framework. Please correct me if this is wrong.
>=20
> Moving the client registration to ping pong between DRM and host1x has
> its problems. host1x driver itself has no use for a list of client
> devices. It can just iterate its children in case it needs them. In
> tegradrm, you need a list of devices under tegradrm control, which might
> or might not be the same as list of devices under host1x hardware.
>=20
> The solutions that many other DRM drivers seem to employ are the virtual
> devices. Exynos and OMAP drivers do this, as does SH Mobile DRM driver.
> So I think I'd still go this way, as it's the path of minimum
> resistance, least amount of code and most localized change. I know it's
> not ideal, but I'd also not like to get stuck in this.

I've briefly discussed this with Stephen on IRC because I thought I had
remembered him objecting to the idea of adding a dummy device just for
this purpose. It turns out, however, that what he didn't like was to add
a dummy node to the DT just to make this happen, but he has no (strong)
objections to a dummy platform device.

While I'm not very happy about that solution, I've been going over it
for a week now and haven't come up with any better alternative that
doesn't have its own disadvantages. So perhaps we should go ahead and
implement that. For the host1x driver this really just means creating a
platform device and adding it to the system, with some of the fields
tweaked to make things work.

Is this something that you can take care of in your patch series? I
could also implement this on top of the current driver and then all your
patch series would have to do is remove host1x.c from tegra-drm and
instantiate the platform device itself.

Thierry

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQyKv9AAoJEN0jrNd/PrOho6YP/Rwfh39fMvmD6ZX61DaDlOqH
ETOMGBe3/cn684GTLTUE8ZTvoQu0kuKWnVqTSw6FbObQECZ9Bo1LADCAtmZkJ9Ss
GuqKfZPSonAENw3rSzW4ETpvmPtN6vf1xiNQT4u62GFieJKUVmzRPCI3VXps+Pjm
4BYZofuxHuHjjjaPws/W3MJX+Tpl+t0hHSH7fwIrk/CbCtuZ/ZUZb/joxX5JgSla
OqVLhbbKbPLyRCTmFb+K6g8+TjGdC8l7XCrFMohiVz0OM3IhqLi0c3UbPaVYX87t
efTU9MLPw0R8mBgw0PYLRBwdZGQEro9OuLrdmvQSpcDtXSqM+qjNE+z/bApy7yIo
viZ3g7OArXBMpJFTDkdlj3u+4foYtfL3HNccMcuR9FhK707ZTku/8q+umn1q5kJm
pMC6lofr3CUtRVy5g2z9/44+VE0oxq5OpBMtKSyBIl74F2yHClGDgYvogsxXAGzB
t/Q1a3vCdDDxR13AYzJvHiKwc+fX6T3IXR8xLoJP9bOblkCltp5HZFdwaeSi38tK
llG08Fg464ogVKXlFZ1DhTa4eKrctNY1QmCftlbVbOz2RNWxoY7yuM9xtIcPdFdL
G3gZOngXQWIn70SFoJ2Gl4fxiNF9cGDx5uDj9clA9PvtfKNOGNUrS9LIuRz5rv56
mcOdVhzrZdwW7krPxcTx
=F3KD
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
