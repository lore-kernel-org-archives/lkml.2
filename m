Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908Ab0CXUgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 16:36:20 -0400
Received: from vps.mortis.eu ([79.99.135.181]:60906 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756745Ab0CXUgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 16:36:17 -0400
Date: Wed, 24 Mar 2010 21:35:56 +0100
From: Giel van Schijndel <me@mortis.eu>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jean Delvare <khali@linux-fr.org>,
       Jonathan Cameron <jic23@cam.ac.uk>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] [RFC] hwmon: f71882fg: Add watchdog API for
 F71808E and F71889
Message-ID: <20100324203555.GA19046@salidar.me.mortis.eu>
References: <1269385936-3440-1-git-send-email-me@mortis.eu>
 <1269385936-3440-2-git-send-email-me@mortis.eu>
 <1269385936-3440-3-git-send-email-me@mortis.eu>
 <1269385936-3440-4-git-send-email-me@mortis.eu>
 <4BA9CF57.4030504@redhat.com>
 <20100324093651.GG6368@salidar.me.mortis.eu>
 <4BA9EA5C.9060506@redhat.com>
 <20100324153550.GK6368@salidar.me.mortis.eu>
 <20100324155151.2482952f@lxorguk.ukuu.org.uk>
 <4BAA3BEB.6010902@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <4BAA3BEB.6010902@redhat.com>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 24, 2010 at 05:20:59PM +0100, Hans de Goede wrote:
> On 03/24/2010 04:51 PM, Alan Cox wrote:
>>> hold on the SIO port range. This would thus interfere with the
>>> operation of the f71882fg driver. I.e. it would prevent the device
>>> probing stage from working, thus preventing it from loading *after*
>>> my in-development watchdog driver.
>>=20
>> There are two ways to deal with that really
>>=20
>> 1. Add a multi-function driver - it finds the chip and claims the
>> port regions and then provides methods for locked access to them as
>> well as creating other device instances that the drivers map to
>> (probably platform devices ?) which in turn trigger the
>> loading/binding of the relevant low level devices.
>>=20
>> 2. Fix the kernel request_resource stuff to support a sleeping non
>> exclusive resource so request/free of regions can be used as a
>> resource semaphore by co-operative devices.
>>=20
>> #2 is actually not hard but when I did the patch originally it then
>> wasn't needed by the driver I had in mind for other reasons.
>>=20
>> See http://groups.google.com/group/linux.kernel/msg/1425fc2aad32e6ea
>>=20
>> Maybe its worth resurrecting ?
>=20
> Or, a bit more specific solution would be to resurrect the superio
> lock coordinator patches, which were written (but never merged) 2
> years ago to solve exactly this problem:
> http://lists.lm-sensors.org/pipermail/lm-sensors/2008-July/023743.html

When performing some searches I find messages going back to at least
september 2006 [1] [2]. With multiple occurences of these patches being
"dusted off". They never got applied though, and for that (*not*
applying them) I cannot find any reason. Is there any? Or did people
just become uninterested and let the patches "collect dust"?

Then regarding Alan's patch. The fact that it is a *lot* simpler than
Jim Cromie's SuperIO locks coordinator is IMHO a significant advantage
over the latter. Furthermore, "lock coordinator" seems like a bad name
to me, since those patches seem especially concerned with centralising
the way that SuperIO devices are probed for. Thus if the only thing
required is to serialize resource access I think plain-ol' locking
(with the ability to block on the lock, rather than polling for it).

[1] http://lists.lm-sensors.org/pipermail/lm-sensors/2006-June/016476.html
[2] http://lkml.org/lkml/2006/9/14/20

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuqd6sACgkQZBYm/87l50K6KwCdEMTmQ2Y4k0yi8GcWOSHIeel8
g90An3Yso3XhFqwniMyIwEa/gOSQ9uPw
=NFuC
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
