Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab2DHXmc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 19:42:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982Ab2DHXmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 19:42:31 -0400
Date: Mon, 9 Apr 2012 09:42:19 +1000
From: NeilBrown <neilb@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Shuah Khan <shuahkhan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, rpurdie@linux.intel.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] LEDS-One-Shot-Timer-Trigger-implementation
Message-ID: <20120409094219.57d321cb@notabene.brown>
In-Reply-To: <20120407215641.GA4539@core.coreip.homeip.net>
References: <1333310039.2879.4.camel@lorien2>
	<20120406165353.ab667eb0.akpm@linux-foundation.org>
	<1333808024.2728.39.camel@lorien2>
	<20120407215641.GA4539@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/tluDqp6O.RegOGJ4sxkO_gD"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/tluDqp6O.RegOGJ4sxkO_gD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 7 Apr 2012 14:56:41 -0700 Dmitry Torokhov <dmitry.torokhov@gmail.co=
m>
wrote:

> Hi Shuah,
>=20
> On Sat, Apr 07, 2012 at 08:13:44AM -0600, Shuah Khan wrote:
> >=20
> > > > +This feature will help implement vibrate functionality which requi=
res one
> > > > +time activation of vibrate mode without a continuous vibrate on/of=
f cycles.
> > >=20
> > > They make vibrating LED? ;)
> > >=20
> > > What's going on here?  You're proposing to repurpose the LEDs code to
> > > drive vibration devices?  Or some devices couple a LED with a vibrati=
on
> > > device?
> >=20
> > I owe you filling in the blanks type explanation. Let me describe the
> > use-case I am trying to address first. Vibrater function on phones is
> > implemented using PWM pins on SoC or PMIC. When there is no such
> > hardware present, a software solution is needed. Currently two drivers
> > timed-gpio and timed-output (under staging/android in Linux 3.3)
> > together implement the software vibrate feature. The main functionality
> > it implements is the one time enables of timer to prevent user space
> > crashes leaving the phone in vibrate mode causing the battery to drain.
> > leds as it is implemented currently, is not suitable to address this
> > use-case as it doesn't support one time enables.
>=20
> So why do not you use memoryless force feedback framework that other
> devices use (see drivers/input/misc/*vibra.c drivers).
>=20
> Thanks.
>=20

I don't see that using a "force feedback" "input" device to control a
vibrator - which is neither "force feedback" nor "input", makes any more
sense than using an "led" device to control something that isn't an LED.
So we are even there.

I think driving leds by writing to sysfs files is lot easier (for scripting
languages particularly) than the ioctls or binary writes needed for managing
input devices.

Of course, if the 'input' framework were used for controlling all LEDs -
rather than just the LEDs on keyboard - then it might make sense...

Also, I don't think 'ff' allows for "vibrate for N milliseconds".
It appears that one uses the "rumble" effect and have to say "turn it on",
then "turn it off".  Is that correct?
I found 'struct ff_replay' which has a 'length' which is a duration, but it
doesn't seem to be used.

How would you tell the force feedback framework to play the vibrator for
120ms, then stop?

Thanks,
NeilBrown

--Sig_/tluDqp6O.RegOGJ4sxkO_gD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4IiWznsnt1WYoG5AQLjKBAAsYj93t/SI1hF4BcTjfqTl0zANhzRovV8
Ag3JyXtXHYrf54+hwg3jDbmdsAxRFU+B7xKe8E5wyt2veltzttrUVo4uCIILyF4H
C6OCCM5Bw5QKvy6HvUtVX7/PkhA42zNENnPCgWDT0nLurNqWzJrrScR0rHgeAwlv
9JDi11KtagOgiCLPgeR5wz8E9HAtOFY9Y03AjOOiy5oMrfWUdUCkeR4owSQ0d2Jh
80TmSOYr8dSQw1zqgDkDfAqA7oYU7mo7R6PGvMWcgD0pbEHhdKWa+7SPNojM/CaL
D+zRhW+uK2sBhJRoEO18rlC3p7gy2Dyv4mrAW+nw9R1zCPuK3/D15YNtT/owQzWx
dwc6AZYibKfcDpYI1tLGNpmw2z3gIkdD9/2pH65udUjs7AUIRnYtH8bdLqR/hf77
sAPxRkIQKKzDvxYy8XS+9MIUfJt5DxJIj122KHCF89ib/iolJeC4/re23rxGWb1L
GboLzXqRFilqcwQ1q9KWjj1PBChFM7bc9b6WTdCI6W5ZhK4LSjuC/ZWA1rxBhmDK
vU7Pv1X/0+wGJScWt7OuyCdHRQgwou2X90j7FRDbHsj9ZWWZ7SGKJUCJluhBHGHU
ebiF6nyMsCsBOuHBF2KqR6/VDLh4J5ddZgclbEeNJkY5zINEITz+rSdUgMBlGOFH
qYUIVgLIxQQ=
=Fgmf
-----END PGP SIGNATURE-----

--Sig_/tluDqp6O.RegOGJ4sxkO_gD--
