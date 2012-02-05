Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab2BEW3N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:29:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51417 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143Ab2BEW3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:29:08 -0500
Date: Mon, 6 Feb 2012 09:28:51 +1100
From: NeilBrown <neilb@suse.de>
To: dedekind1@gmail.com
Cc: David Woodhouse <David.Woodhouse@intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Crash in mtd_cls_suspend because mtd is NULL.
Message-ID: <20120206092851.5b33b014@notabene.brown>
In-Reply-To: <1328245104.6750.6.camel@sauron.fi.intel.com>
References: <20120203105057.11a86f26@notabene.brown>
	<1328245104.6750.6.camel@sauron.fi.intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/j1iiH_PcybnP._060v5WcJI"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/j1iiH_PcybnP._060v5WcJI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 03 Feb 2012 06:58:24 +0200 Artem Bityutskiy <dedekind1@gmail.com>
wrote:

> On Fri, 2012-02-03 at 10:50 +1100, NeilBrown wrote:
> > Hi,
> >  I just tried to suspend my GTA04 (OMAP based mobile phone platform) ru=
nning
> > 3.3-rc2 and it crashed in mtd_cls_suspend because mtd was NULL.
> >=20
> > So for me, it looks like the following patch is a regression.
> >=20
> > Is there anything I can do to help find the correct resolution here.
> >=20
> > (It has some flash memory but I am not using it at all).
>=20
> Neil, there is a fix:
>=20
> http://git.infradead.org/users/dedekind/l2-mtd.git/commit/da50432777e184d=
d889f077cf06a74aa24cb80d9
>=20
> I should just be merged upstream. It was discussed here:
>=20
> http://patchwork.ozlabs.org/patch/138551/
>=20

Thanks!

I pulled in the  whole 'master' branch and it is much better....
(which is to say that suspend gets a bit further, and the thing that causes
it to break isn't MTD (it is libertas_sdio..)).

Thanks,
NeilBrown

--Sig_/j1iiH_PcybnP._060v5WcJI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTy8CpDnsnt1WYoG5AQJYBxAAlEzUEXeJyuer8YXbUs3r/7/0KxGBhy/L
XvNSa8dMWWwifGujCywI+KpqSEi3ARLDJTKM/q1hq7OKL77hyytfmVMDblfj758d
SpIoG+xHXEggf8HJBhJge63jtSp7OLSeEO6Glg34KOEK6FMvbPQ1CNn+34g7KvcL
I/8HcLiF6ZzMBzZdqfkHQf8tiUVBPPbjQFQwcgrmiEsPBZGdGnsA+DBPUffewfNB
D9NrYqNsdRLRbez0Z4x+yrsqkoAqR+CEZC9yu+JlFa61AK/338iT+FkBdTjjprvZ
K2Ua2F7L/Lx2WgR7HKfdxZA58zBeaVDllg5VKi9M6crNGLfNdPxIAxu2Cy4MW+uK
ItqoQkYlLBGLf8838sYP7orlj+nLgBb4BD946dRm4gN2Gmonb4seGCwHQ4RGP8xj
HeDxkXUTEz7d+68ib4bQMfQCc8jM15IzdNQidgjHQk6oAGje37vAAzefLicYZE5d
7daA0mUctxvslxt3CYLTUzUpfAaYYRZb3NOVItt+jkqY66h4GJNXxhmZIUzJMEXP
HzoSvUy08QGMLc32s+aOcwHhXNaU+i/w3hRDeR28qUpj3pV6E74DHM37/ArX6mZB
OEJqiO8ZSRWP+1aNp3PevZ7dBXiCovxqr4cPyQ3gyDzn40QRaxiOBW27k7tLvLDo
gHSFxgPWFL0=
=E9re
-----END PGP SIGNATURE-----

--Sig_/j1iiH_PcybnP._060v5WcJI--
