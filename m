Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab2LEUos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 15:44:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:60100 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab2LEUoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 15:44:46 -0500
Date: Wed, 5 Dec 2012 21:44:39 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
Message-ID: <20121205204439.GA2763@avionic-0098.adnet.avionic-design.de>
References: <1353935954-13763-7-git-send-email-tbergstrom@nvidia.com>
 <20121205083335.GA20984@avionic-0098.adnet.avionic-design.de>
 <50BF1DAA.8030805@nvidia.com>
 <20121205111332.GA25676@avionic-0098.adnet.avionic-design.de>
 <50BF345A.8050201@nvidia.com>
 <CAKMK7uGPf=TEW8DL-K1KYPhMZALTZhFsSb2DBxDVgFct1kUjSA@mail.gmail.com>
 <20121205122209.GB29943@avionic-0098.adnet.avionic-design.de>
 <CAKMK7uFy=Hkqqqom=yOZ8dgSGjRT4JCJuJK7coJ+i=OyovKcYQ@mail.gmail.com>
 <20121205132843.GA2834@avionic-0098.adnet.avionic-design.de>
 <CAKMK7uG2OHOmH8OJJmZ4uoNWwoeA0wRyiE4VdR9C3ajC1ZBZDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <CAKMK7uG2OHOmH8OJJmZ4uoNWwoeA0wRyiE4VdR9C3ajC1ZBZDw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:a3z3zOlcB9hnufT/c7Wex/6nc9izv0V+kR4tfYYKoAe
 6FbSMTUcHeEWxu2Hbho/84tUw0OrYnq4Czy4J5chxBc+dl2HSV
 VwNDMEp/VZpth3CPdevi6oAEAHuvoIOsNoAGOp+9uShORRB7vY
 n/lm/+okGJbIV/x+82n6wgjDqCEd0yObxi/RH7YB0TvAKF5GYb
 EfKpCXw6TrsvO3gTZu0FvdklD36mQFwE3tKyaohz3rGR59NAiq
 rwwMMymo3IVQ3I1Vzs6ZsGnynLfuWeKMDBAoxz6XPFXOxBCuQ9
 puxSMpj5HnESKyi78R6e2wxp8thpW6/y3PDi0XeolpCkoujkhL
 HM9lg0KoCV7qqaFtxh2CXXJVNX9zS2pa7TymZy0Aq7QsSzTFhw
 XkAltGQcaVF5skttv6pHZK5GSriMuNy+9g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 05, 2012 at 05:34:30PM +0100, Daniel Vetter wrote:
> On Wed, Dec 5, 2012 at 2:28 PM, Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
> >> Imo that's worse, since now drm manages even more of the driver->hw
> >> binding process. In my dream world the drm driver just registers a
> >> normal driver at module load time directly with whatever bus it's
> >> interested in, and then, from it the bus' ->probe callback setups up
> >> the entire driver, calling down into drm to setup up interfaces to
> >> userspace (dev node, sysfs, and whatever is required to implement the
> >> ioctls) and uses the various helper libraries provided. So host1x
> >> providing a virtual device that tegradrm can match sounds much better
> >> (if that helps in decoupling from host1x).
> >
> > Okay, now I see where you're going. You want to replace the various
> > drm_*_init() functions with something more fine-grained that does the
> > initialization manually in each driver. Is that it? The obvious
> > disadvantage is that a lot of code would have to be duplicated, though
> > that can presumably be factored out into further helpers if necessary.
> >
> > On that note, I just noticed that drm_platform_init() actually binds a
> > single platform_device to the drm_driver, which isn't going to work very
> > well in case there are two devices that want to use the same driver. It
> > would be nice to get rid of that limitation as well while at it.
>=20
> Yeah, it's the lack of generality that irks me, and writing driver
> init code is one giant sequence of setup function calls anyway -
> sprinkling 1-2 more doesn't really matter, but helps a lot if it
> results in the driver being in full control (e.g. if you need to
> reorder due to some special requirement, that's much easier to do then
> than with the current hoop-jumping). But like I've said, a bit a
> bigger fish to fry, just wanted to point you into that direction ...

I have quite a number of things to finish up myself and this sounds like
quite a bit of work.

> >> Or simply call the tegradrm setup from host1x directly, creating a
> >> depency on the tegradrm module. When trying to unload host1x it can
> >> then also call down into tegradrm to tear down the drm device.
> >> Afterwards you should be able to unload tegradrm without fuzz. And if
> >> the hard dependcy is an issue for other host1x clients this
> >> setup/teardown could be wrapped into an #ifdef CONFIG_TEGRADRM.
> >
> > This is what I originally proposed. However, since tegra-drm will need
> > to call functions provided by host1x we have a cyclic dependency.
> > Wouldn't that prevent either module from being unloaded?
>=20
> You could pass down a host1x interface struct with a vtable to
> tegradrm (plus some static inline helpers to make those not a pain to
> call).

That sounds very interesting. It's also in line with what Terje proposed
earlier, making the host1x into a helper library, only the registration
part would remain with host1x. So in this kind of setup, the host1x
driver would initialize tegra-drm with something like:

	int tegra_drm_init(struct device *parent, const struct host1x_ops *ops)
	{
		struct platform_device *pdev =3D to_platform_device(parent);
		int err;

		err =3D drm_platform_init(&tegra_drm_driver, pdev);
		...
	}

The DRM driver's .load() callback would of course have to be passed the
ops pointer. Either that or indeed some kind of custom setup function is
needed instead of calling drm_platform_init().

Maybe I should go and give such an implementation a shot, see where it
ends up.

> The other possibility (and I'm not proud at all of that code)
> which we've used in the intel-ips driver is to use symbol_get at
> runtime - but there the requirement was explicitly that intel-ips
> needs to work on server systems without the drm/i915 driver loaded,
> but still always have the support for interacting with it compiled in
> (to make distros happy). It's all rather awkward though ...

Hehe, indeed. Adding a dummy platform device suddenly doesn't sound that
bad. =3D)

Thierry

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQv7I3AAoJEN0jrNd/PrOhEEkP/1KlZIUxEYZ6jah4yarWnT1M
I+SWy/Rhf+qqtLF7l8lBNiSh7YUTr5G7TbFBAMBQJvjFIHiKCeGJS691s/BfaMDK
VveqDzqbnDioG5tVTyJdvECmaYi6UGVJ8dfphFXxwmfwMp5xd7BKAYmdmtXTmtzK
9XUxZkS27yw6asmZa5nz9R0Go4PWCyaCOsMNICwRqrRBgsDdm8k0SI9XEaPw2dow
sp2t7nmzq62fTQJZfdk+8QDae3RZHTdXuQQgrescmKRMBTpOO74RcrfiUenr4zCK
5aEBx70bzE6kDLvJmtC9sVumaquXBMKXhl2CDIzN+BYbrE/q/gr7y61ATAf0ml+8
0x+CwaeoPKu9pwHLEnaWf5vd0jTUckR3EBX4Q1gfFm4H3NsQVq5sXjTbJv5lVNvC
ezsuX29sjomKK24YTeMPBu+NJmaytyzyCXOrHcv0MOOlE0OrRoDcTPrCe718sG/Q
GjhDbSN2gjbc9Jdx6ihKnQgxg3vYckWhGS3VxBrVHfCtt2mcUquzd1CWRdlAvklE
S1O2B/+ni5QmVx7bdWovtEiND19ohNboepQAzVhTqP1iNujiIhsOOW7L+j1D1f76
lZx+OQ75+BE7M7wYT9kXt4hO4e8kjrAS8E3V0Z8Sim6GxIDIpDIdOhhiBARfDNEz
yPaPQEbRwK8FZ8JNIyDm
=GYS9
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
