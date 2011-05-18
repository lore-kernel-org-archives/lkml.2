Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236Ab1EROkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 10:40:52 -0400
Received: from home.keithp.com ([63.227.221.253]:39395 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856Ab1EROkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 10:40:51 -0400
From: Keith Packard <keithp@keithp.com>
To: Chris Wilson <chris@chris-wilson.co.uk>, Mihai Moldovan <ionic@ionic.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915/sdvo: Reorder i2c initialisation before ddc proxy
In-Reply-To: <e0d58a$78jc@orsmga002.jf.intel.com>
References: <4DD2648C.6020309@ionic.de> <1305637430-16026-1-git-send-email-chris@chris-wilson.co.uk> <yunei3wssyb.fsf@aiko.keithp.com> <e0d58a$78jc@orsmga002.jf.intel.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 18 May 2011 07:40:42 -0700
Message-ID: <yun8vu42hsl.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 18 May 2011 09:04:11 +0100, Chris Wilson <chris@chris-wilson.co.uk>=
 wrote:
> On Tue, 17 May 2011 18:22:52 -0700, Keith Packard <keithp@keithp.com> wro=
te:
> > On Tue, 17 May 2011 14:03:50 +0100, Chris Wilson <chris@chris-wilson.co=
.uk> wrote:
> > > The ddc proxy depends upon the underlying i2c bus being selected. Und=
er
> > > certain configurations, the i2c-adapter functionality is queried duri=
ng
> > > initialisation and so may trigger an OOPS during boot. Hence, we need=
 to
> > > reorder the initialisation of the ddc proxy until after we hook up th=
e i2c
> > > adapter for the SDVO device.
> >=20
> > I'd love more explanation here about how this code ever worked -- what
> > are these 'certain configurations' of which you speak?
>=20
> The condition under which it fails is when the i2c_add_adapter calls into
> i2c_detect which will attempt to probe all valid addresses on the adapter
> iff there is a pre-existing i2c_driver with the same class as the freshly
> added i2c_adapter.

Lovely.

> So it appears to depend upon having compiled in (or loaded such a module
> before i915.ko) an i2c-driver that likes to futz over the i2c_adapters
> claiming DDC support.

Thanks for your additional explanation, as I said, the patch looks sane
on the face of it (always nice to initialize values before use).

I've marked this as reviewed, added your additional explanation and
merged it to drm-intel-next. Seems like it might like a cc to stable?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFN09pqQp8BWwlsTdMRAlsXAJ9+kTMh6s/zd6IiZG4a2zhWDVm8zACcCuEm
QBqaTWTHdT5NIbuTIscwckY=
=sjqQ
-----END PGP SIGNATURE-----
--=-=-=--
