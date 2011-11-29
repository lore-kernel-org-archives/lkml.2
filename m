Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411Ab1K2FLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 00:11:41 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:38215 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab1K2FLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 00:11:40 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH 2/8] firmware: Sigma: Skip header during CRC generation
Date: Tue, 29 Nov 2011 00:11:38 -0500
User-Agent: KMail/1.13.7 (Linux/3.1.0; KDE/4.6.5; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        drivers@analog.com, stable@kernel.org
References: <1322138908-32127-1-git-send-email-lars@metafoo.de> <201111251500.52711.vapier@gentoo.org> <4ED33EB1.6030200@metafoo.de>
In-Reply-To: <4ED33EB1.6030200@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2740893.6fvx74g6eV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201111290011.40710.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2740893.6fvx74g6eV
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 28 November 2011 02:56:33 Lars-Peter Clausen wrote:
> On 11/25/2011 09:00 PM, Mike Frysinger wrote:
> > On Friday 25 November 2011 03:55:42 Lars-Peter Clausen wrote:
> >> On 11/24/2011 06:21 PM, Mike Frysinger wrote:
> >>> On Thursday 24 November 2011 07:48:21 Lars-Peter Clausen wrote:
> >>>> The firmware header is not part of the CRC, so skip it. Otherwise the
> >>>> firmware will be rejected due to non-matching CRCs.
> >>>=20
> >>> that's because you didn't compare to the right value ;).  include the
> >>> CRC -> compare to 0.  omit the CRC -> compare to the CRC value.
> >>=20
> >> Does this really work if the CRC is inserted somewhere in the middle of
> >> the bytestream?
> >=20
> > i don't think the position matters to the CRC algorithm used by sigmads=
p.
> > math principle: a ^ b ^ c is the same thing as b ^ a ^ c and c ^ b ^ a.
>=20
> If CRC algorithms  were commutative they would be pretty weak, I guess ;)

that doesn't stop people from implementing them this way ;).  the last CRC=
=20
code i did actually implement and test related to the Blackfin arch did hav=
e=20
this property (the bootrom).  so i just included the computed CRC value and=
=20
made sure the end result is 0.

> > i could be wrong as to the CRC algo used though.  simple enough for you
> > to check -- i implemented this firmware code based on a spec i wrote up
> > for the sigmadsp peeps; i never actually had real firmware to test with.
>=20
> It does not work.

ok, i withdraw my complaints here then :)
=2Dmike

--nextPart2740893.6fvx74g6eV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJO1GmMAAoJEEFjO5/oN/WBMksQAI8EPCXMigXxM/E2qtGtIa/r
bH9IBwTYFBtiYdV4Ub/Yywqfv19IQQoz9YFcrRLVQLTyc/eYHprVXzjsGVD4SMjt
chD5BhrC07YtcStLbu60XSs8r1vXmdVb36GE6c/WVxF9mNyyQlNmJ6mV20FbQUpZ
F18q6V1c5s/Z7q+RL8aZZfvDFT8lWV11pqQOM/IDpbrZK2hDureqLVkw6+j5CNcL
8C+dYpEK60JC2x6amq8Q3EGM5UvVzJEgfosbfMc5+opn69BYscjS3wcq6T1Q0JsC
dF4wOwcTKztmOmPHhfRZYqNSXyH3tGI+yjnAmKGKTm5HVenhdIMNcwbnzOBDUKH3
H495qrInkTMChcW9XVeGM/znfDuwTussMSkoR+PaRe7ZQWEZcGegvhAW2Y2GCh6X
jp7NmBr+D6bfXz+7b6QaCoaDftLcLiXqLpU3fgzJ6r1pLBuil4CQAjVCuuCUWWZa
Kmbuj/39W9xHraD63WpGE2ad1W/uSL6d7GtBH95h78Mdov9oOMqOzlzzsRPs0Ae7
wfeVzftEH773m7ON11a2upgC0zNOSH4U81+o6Jbpy3ZUdqmcNL4IIXa4emoAOx4Y
dW2Qd2QKAOKDU+q0vWGNbZ2kvr+6nS532gGyWQloCqHt/dt022M2R2Ts4XXNBrmE
hrfOdxxn4jAHJ+hQ3owu
=q02O
-----END PGP SIGNATURE-----

--nextPart2740893.6fvx74g6eV--
