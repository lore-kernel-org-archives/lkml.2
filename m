Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab2DZHOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 03:14:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43442 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180Ab2DZHOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 03:14:23 -0400
Date: Thu, 26 Apr 2012 17:14:16 +1000
From: NeilBrown <neilb@suse.de>
To: NeilBrown <neilb@suse.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: twl4030 power button: don't lose presses on
 resume
Message-ID: <20120426171416.32db6d5b@notabene.brown>
In-Reply-To: <20120425152603.3d24547f@notabene.brown>
References: <20120425122139.512c6890@notabene.brown>
	<20120425050919.GB27843@core.coreip.homeip.net>
	<20120425152603.3d24547f@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/iKxvBJ=CNT/l.5fL2nznWv="; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/iKxvBJ=CNT/l.5fL2nznWv=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Apr 2012 15:26:03 +1000 NeilBrown <neilb@suse.de> wrote:

> On Tue, 24 Apr 2012 22:09:19 -0700 Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
>=20
> > Hi Neil,
> >=20
> > On Wed, Apr 25, 2012 at 12:21:39PM +1000, NeilBrown wrote:
> > >=20
> > > If we press and release the power button before the press interrupt is
> > > handled - as can happen on resume - we lose the press event so the
> > > release event is ignored and we don't know what happened to cause the
> > > wakeup.
> >=20
> > What kind of latency do you observe?
>=20
> When I have debugging enabled, hundreds of milliseconds.
>=20
> When I don't have debugging enabled ... it doesn't tell me, but I'm fairly
> sure it is several tens of milliseconds and the button press can be quick=
er
> than that.
>=20
> If it will help I can try to instrument the driver and get some timings.

I added a bit of tracing.

It looks like a fast button press typically shows about 120ms between 'pres=
s'
and 'release', though I have seen as low as 70ms.
When I don't have PM_DEBUG debugging on, the 'press' interrupt gets handled
in about 14ms.
So it seems likely that the times that I suffered from the problem and so
wrote the patch, I had PM_DEBUG enabled which slows resume down quite a lot.

So I cannot make a strong case for these patches.  However I think it is
safer to have them than not :-)

Thanks,
NeilBrown

--Sig_/iKxvBJ=CNT/l.5fL2nznWv=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5j1yDnsnt1WYoG5AQL15RAAodLmMyHEpRMZfttyjNrAh4KXRHa8/VAk
2rS9t+DgrOEk0oAeOI1AHw3FE8vo2tqv/hfahXw/UX/Yws86D+tNEhI3y0NHundh
TR+smI3Daz5Y4z8VcBY1ZGCdHskvUVNtLUMv+INL3/dYiZqdRvkN600PVZrFdEhg
MtjAG9nYpbHeVNP1LhYbhUT/PJA0MrfN1jyuDPBrJcm4iui8cZHY7Qj2aHYKlePt
sX7D8PG+2K9RWBlidMV3UXi5mE6d/Im2ER0UIf6AWIwIT7xKP2sEIwFR/MjZ6Hl0
0OMB7nCyZVUGqYiW5X+2J9cLtZMw0NhGSDVz9tPTg5bowNW8Dr9hzMxaShca/JvZ
HDssI5ffsyanDMGOf4JFWDATtRfLUELZhIIX8WlSzo1xbN74FXX7D8bD64xJAsYO
SSnPK3zleP5BqwLs9Vo8JjGeeM6zARiZ5M5W5dhFshWYZNUzg14AtyZCg02NnEc4
ItU+sqD+Vx0gUmcfEgB6Lc9nFmmYk2oImrCQNJGz0UjqR1WP9e3/Jgf85GcaTMDy
fJOJM7AReNf5Yw5lxY2EvSfJy+LVYR6GMbYSyEE1huEW8CCtAlAm2Efq8uw/vmHB
fj+ywPNv9i5FnFTVaByB7a0un1Hq4DLcYQBjuCozyaIERLEGbWbHGWsz6MBbNmWz
KlFHTyBbni0=
=ll+V
-----END PGP SIGNATURE-----

--Sig_/iKxvBJ=CNT/l.5fL2nznWv=--
