Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab2DWFpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 01:45:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53256 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab2DWFpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 01:45:54 -0400
Date: Mon, 23 Apr 2012 15:45:46 +1000
From: NeilBrown <neilb@suse.de>
To: Jonas Bonn <jonas@southpole.se>
Cc: shuahkhan@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Subject: Re: [PATCH ] leds: add new transient trigger for one shot timer
 support
Message-ID: <20120423154546.415bd6c0@notabene.brown>
In-Reply-To: <1335158999.5139.47.camel@jerome.southpole.se>
References: <1333310039.2879.4.camel@lorien2>
	<1334064283.10826.6.camel@ted>
	<1334507752.2723.3.camel@lorien2>
	<1334894674.3051.18.camel@lorien2>
	<1334983269.2435.90.camel@jerome.southpole.se>
	<1335138687.2882.20.camel@lorien2>
	<20120423115610.2da4d4d7@notabene.brown>
	<1335158999.5139.47.camel@jerome.southpole.se>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_baR=jjRX/ibaAZo3AdZtZR"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_baR=jjRX/ibaAZo3AdZtZR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Apr 2012 07:29:59 +0200 Jonas Bonn <jonas@southpole.se> wrote:

>=20
> On Mon, 2012-04-23 at 11:56 +1000, NeilBrown wrote:
> > I wonder if we should allow control of the brightness during the "on" t=
ime as
> > well.
> > You could set the brightness after enabling the timer, but awkward paus=
es or
> > races could then leave the "led" permanently on.
>=20
> echo transient > trigger
> echo 200 > duration
> echo 1 > activate
context switch - lots of IO - time passes, 200ms or more, led gets turned of
and then back to:
> echo 100 > brightness

led gets turned on and there is nothing to turn it off.

Not a likely case I agree, but not impossible.

The problem is that just setting the brightness will turn the led on
independent of the start of the trigger (unless you set the brightness to 0=
 -
that disables the trigger).

Thanks,
NeilBrown

>=20
> Worst case, the brightness doesn't get set and you get a 'bright' LED
> until it expires... but at least it does expire!
>=20
> >=20
> > Possibly we could hook into led_set_brightness() and restart the timer
> > whenever the brightness was set - and remember the setting.
>=20
> An easy way to do this might be to check the brightness setting at the
> time the timer expires and save this value.  Next time the LED is
> activated, we use this brightness setting instead of FULL_ON.  It would
> be nice to keep this trigger self-contained and not have to hook into
> led_set_brightness
>=20
> You make interesting point about using the brightness property as the
> actual timer trigger, though.  That's pretty elegant, but it does
> require hooking into led_set_brightness.
>=20
> /Jonas


--Sig_/_baR=jjRX/ibaAZo3AdZtZR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5Tsiznsnt1WYoG5AQJzDxAAi6s6QH/DueRZFviljEHUpcDQxQ0kxOvm
Sfh5cGKIMM0xEn+CxbtRFvVpxJhZv5Pza4vapIGxFAeSuav0Xlr5lWm0+37mCDyN
A98nN6+u/HFPMOy9QpBXj0q8l3yrW+gFkqvPSSTsmLKqiiYipuLU0eY5ODfYYkwq
OlTNcYKm7nfXT6JztXrqcz+fuqPD2qLLUxlFdHDQ/OTpMqucuTwrNt+85pGpV+XX
VczSi+osicZZNtTGcPlnbndFAp3zAiX2ZCAsl22QjtFS+xo66P3rwB9FL4pvZSQG
Mt1IVh8wTfiPBbYoqh7eGLBPdAcnYCG06V+Oky69Ridh/zskSX/PeOkx4aOA3CST
DAjEJuM9qsmIJ1VdbgUiP8Ih4rn5o5q2SVcZBW2UzD+hFH/KizAlLvUMCIDTESsu
p3mYyXlrmXcrLOWu88Lx3GUDAZMckSUiAzCvC/ATfhakvAqDxQB0nzzZB/oOeo4B
5Y2i+Z3Q6d8/MsYNZcRZGHL7r02ujRq5QGUUQq9QIvdgKVi1RYR4ErJQ7weQXvZv
N6PgqjVIz+Lcdd9iSRwHrC95NC6kdBeoUNdWzKVQIvXdzQ45BCN6rKKMfSLyZrnd
Ti1cLP80OPlf6H/MyRDZLf5KgCgQkHqEPTivBNjKLdPdqmMU6g/u3qwDeJLZRPLy
uGerH9B6CgQ=
=C4Q0
-----END PGP SIGNATURE-----

--Sig_/_baR=jjRX/ibaAZo3AdZtZR--
