Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab2DIWZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 18:25:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37866 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078Ab2DIWZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 18:25:18 -0400
Date: Tue, 10 Apr 2012 08:25:06 +1000
From: NeilBrown <neilb@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Shuah Khan <shuahkhan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, rpurdie@linux.intel.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] LEDS-One-Shot-Timer-Trigger-implementation
Message-ID: <20120410082506.51eaa64b@notabene.brown>
In-Reply-To: <20120409000646.GA24185@core.coreip.homeip.net>
References: <1333310039.2879.4.camel@lorien2>
	<20120406165353.ab667eb0.akpm@linux-foundation.org>
	<1333808024.2728.39.camel@lorien2>
	<20120407215641.GA4539@core.coreip.homeip.net>
	<20120409094219.57d321cb@notabene.brown>
	<20120409000646.GA24185@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+GQ9E0K=/ICwD.1Zt_sH2I8"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/+GQ9E0K=/ICwD.1Zt_sH2I8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 8 Apr 2012 17:06:46 -0700 Dmitry Torokhov <dmitry.torokhov@gmail.co=
m>
wrote:

> On Mon, Apr 09, 2012 at 09:42:19AM +1000, NeilBrown wrote:

> > Also, I don't think 'ff' allows for "vibrate for N milliseconds".
> > It appears that one uses the "rumble" effect and have to say "turn it o=
n",
> > then "turn it off".  Is that correct?
>=20
> No, it is not.
>=20
> > I found 'struct ff_replay' which has a 'length' which is a duration, bu=
t it
> > doesn't seem to be used.
>=20
> It does, see drivers/input/ff-memless.c where it us used to schedule
> when effect starts and how long it should play. Non memoryless devices
> (such as iforce) are supposed to schedule effects themselves.
>=20
> >=20
> > How would you tell the force feedback framework to play the vibrator for
> > 120ms, then stop?
>=20
> By specifying replay->length =3D 120

You seem to make a convincing case.  I'll explore this some more and see wh=
at
it is like in practice.


Clipping from above:

>=20
> Well, if you consider "input" is really "hid" then FF is really
> appropriate for iterfacing with a human.
>=20

A slightly related question.  My phone has accelerometers in it.  I want to
use them entirely a human-interface-devices.  The device itself can detect
inversions and taps and jerks and I want to report just those to user-space,
preferably via the input (aka hid :-) subsystem.  However my understanding =
is
that accelerometer drivers aren't welcome as input drivers.  Is that still
true?
There is nothing 'industrial' about these accelerometers so I would like to
avoid 'iio'.  What are your thoughts about this?

Thanks,
NeilBrown

--Sig_/+GQ9E0K=/ICwD.1Zt_sH2I8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4Nhwjnsnt1WYoG5AQK1XA//evHrlnLpSCtOmMEVrmzcxwDwEUHmTc22
Cbd3tlKgm+wyZxO14zYq7dqJiBAcQ/9iYlYHlhJ3nra88qH5jGzqdklmYVx1csGh
5fc7NwdXfHhJnP43QhkZK9AGabYUU8dKLO4RUw6bx5OsEYiU90nAdsFCdTmpae4P
Mguiq409hz6bA9M9XIry79kSVZlJAZ1/hDQfhiRUZzGSKktYXM1Tnowo/t3yoQJT
BUl2BgqNdiXfcQayQ2HHGEA8C629QUir0G15d1vYC2bl86mIdxK4rLSoO8S8PDkD
wA9UvF2I4bK76/5hqrjZI5dR8XkHB2RL+VvUHHXE64t9XUUcZLOifo97I9VTZe9H
VAB+Q4Ex6sGPsPxOYEUgDyzK4FCn6Ew9LEZz5NzPzjxisgrLARW7xpRoNG5m+tun
kTbLCfDTbcR8tVUzx3nffDlf9+p/eU4fv/o2PJCRS4BooLxoVoqGUmLftIoZrPq+
qjjsu6/YF+CiIbjHbrThDJ/jsvGulrweapCaYFTeyAA011CgRDIJr0LOmFj95ed8
oLWSOkG8/bgglEelzWAbFf+AAKB8fz8Jz/fOcQscVfyP+g6aHfINGnZlxvOoCJv8
TikCs/PfBtst0pps0kEi6oVwrSWL1Iv+0+uQumeKPCPA0li39P67pSWSfbQHS1gx
W50VG5up0CM=
=IX2t
-----END PGP SIGNATURE-----

--Sig_/+GQ9E0K=/ICwD.1Zt_sH2I8--
