Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583Ab2CaKUL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 06:20:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38442 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758229Ab2CaKT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 06:19:59 -0400
Date: Sat, 31 Mar 2012 11:19:54 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Erik Gilling <konkers@google.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        NeilBrown <neilb@suse.de>, gregkh@linuxfoundation.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arve =?iso-8859-1?Q?Hj=F8nnevag?= <arve@android.com>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        myungjoo.ham@gmail.com, John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Joerg Roedel <joerg.roedel@amd.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mike Lockwood <lockwood@android.com>, Dima Zavin <dmitriyz@google.com>
Subject: Re: [PATCH v6 1/5] Extcon (external connector): import Android's
 switch class and modify.
Message-ID: <20120331101953.GA3163@opensource.wolfsonmicro.com>
References: <1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com>
 <1330344939-18394-1-git-send-email-myungjoo.ham@samsung.com>
 <1330344939-18394-2-git-send-email-myungjoo.ham@samsung.com>
 <20120309124119.GV3273@opensource.wolfsonmicro.com>
 <CACSP8ShU5tu=9N53PtYMLyFVFMS9whNRhMvu7nu8rBoPuVCy+Q@mail.gmail.com>
 <20120330100742.GB21950@opensource.wolfsonmicro.com>
 <CACSP8SjhOZcXZa2hCNsH8zS+hm8X-i9uNm50UH=_VwOV=BJGmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <CACSP8SjhOZcXZa2hCNsH8zS+hm8X-i9uNm50UH=_VwOV=BJGmA@mail.gmail.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 30, 2012 at 10:29:27AM -0700, Erik Gilling wrote:

> I'm also not in favor of having functionality conditionally compiled
> based on CONFIG_ANDROID.  If fact, going through the patch stack
> there's much more that changes the ABI from the switch driver than
> just the name.  Android asumes that there is a single "switch" for
> each logical entity (called cable types in extcon) each with a binary
> state (0,1).  Here things have changed to have a single extcon
> instance that can have a bitmask of states which are sent as strings
> in the uevent.

The binary status thing isn't true for the original Android switch API,
at least not in all cases - for headsets it's a tristate indicating if
there's nothing, a headphone or headset plugged in.  This does wind up
being a bitmask because the numbers are 0, 1 and 2 but it isn't really
clear to me if this is intentional or just an effect of counting.

> As it stands, this patch does not solve the cases where we use switch
> today and we'll probably continue to carry the switch driver in the
> common android tree.  If, instead, we got rid of the idea of multiple
> states and mutual exclusivity and relied on the driver that uses
> extcon to have multiple instances for each logical entity and deal
> with mutual exclusion itself, we'd have a driver that would be pretty
> easy to support in android.

What's the advantage in not having information about mutual exclusion in
the core, and why would a userspace that isn't interested in this care? =20
It seems like this could be used by userspace to do interesting things,
and I rather suspect you'll find some vendors have added features along
those lines in their Android devices.  For example, having different
configurations for desk docks and car docks even if both end up
connecting the same things up.

Even if the userspace ABI doesn't expose the information it seems
sensible to factor out the code for handling this into the core so
there's less work to do in individual drivers.

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPdtpDAAoJEBus8iNuMP3diXIP/1MyalzhkFE/cSpF5K8wvdm9
dYepdvMQxTNkHul9EYJw+m302sgMXrtULLHkuneVXgy8GEfrGhiKm0S01uRd54qg
xxhe4gGHqa+KOsEMVQ9gt4mmh+/0bRUaWm1AWRWhRSlHt6wUFuy8icH86c363gA1
Frvel5blgEAWNat7i944dgv7GJO6liiYgwXOSs/96PjY+0nICzE5QKn2RpRMz8sn
DOx8Ye8eGxmLIeGV1wwXlRMZj2y7uUErMLZPzMgWDXq5gQqzCxDgzxHEWNODuBN5
10VjCnkkTG8/EMLaJUV9xD/NU1bi4mDkFjjKX5FoROMFm0fiECd7hrrNmlMELgkp
jZ/addwJgibvZYxrnQdbEtSZRHQGm6s9E6tGqz6PN9rfIjZNOlAhAI19qOX4ts4Y
XPG+NfsW7iglPnTsOBSWnG+aX5Gm3A4esZPenKIzYSy32dJNHPe1rrvXwEDHp9iY
EQBaFnwLMbOw6VjHAIRj1332Lhq2/vQ4OuuL55ET/R8olrZ2ilaVKzOJLmcH5wIT
f4yrqzHK0/PhZzLvZOQop1KXI0RY1ofJxOyiU1pugwkzgcHU32/tu4mainjpMnli
zSXO3wGPAMsU0rDVjfDH7aWiOxqCw8tSvoY205w0QEo72ffhkthFv+/KITimPA3R
o5be8x6FFx4n98EQogoD
=7b0m
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
