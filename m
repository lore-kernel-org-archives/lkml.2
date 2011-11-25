Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab1KYUG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 15:06:58 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:56850 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab1KYUG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 15:06:57 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH 4/8] firmware: Sigma: Mark firmware strutcs packed
Date: Fri, 25 Nov 2011 15:07:09 -0500
User-Agent: KMail/1.13.7 (Linux/3.1.1; KDE/4.6.5; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        drivers@analog.com, stable@kernel.org
References: <1322138908-32127-1-git-send-email-lars@metafoo.de> <201111241219.37220.vapier@gentoo.org> <4ECF7274.2020502@metafoo.de>
In-Reply-To: <4ECF7274.2020502@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6001962.6MGELvzzio";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201111251507.11404.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6001962.6MGELvzzio
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 25 November 2011 05:48:20 Lars-Peter Clausen wrote:
> On 11/24/2011 06:19 PM, Mike Frysinger wrote:
> > On Thursday 24 November 2011 07:48:23 Lars-Peter Clausen wrote:
> >> Mark structs which are embedded into the firmware as packed to avoid
> >> alignment issues.
> >=20
> > while in general this makes sense, i designed the struct layout
> > specifically to work on any sane system.  that means 8bits align on
> > 8bits, 16bits align on 16bits, and 32bits align on 32bits.
> >=20
> > do you see any place where this is not the case ?  otherwise, using
> > __packed by itself doesn't make much sense unless you also change all
> > the loads from the struct to the get_unaligned variety which would add
> > useless overhead to many embedded parts.
> >=20
> > all in all, i'd omit the __packed markings since they're unnecessary.
>=20
> While you are right I think it's generally a good idea to mark anything as
> packed, where we don't have direct influence on the alignment, to avoid
> unpleasant suppresses.

don't we though ?  the ADI peeps writing the driver code work directly with=
=20
the ADI sigmadsp peeps for the firmware needs.  so as long as we make sure =
the=20
layout stays sane, then it stays sane ... otherwise, we need to be vigilant=
 to=20
make sure people don't go slipping in useless get_unaligned calls to the co=
de. =20
if they see "__packed", they think it's correct.
=2Dmike

--nextPart6001962.6MGELvzzio
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJOz/VvAAoJEEFjO5/oN/WBoRcP/3nz961j45gqQijHKCzEaExl
Da4FFpkOYo7xhYz5oGF4q4O7YPUnFjgKKfP+Rl26fMmDAQD4cLpmCYDpcFbkOUtq
0it9kbW5gBO56oWopk4wqKzMFHP9nvrzqGhNwJreDV059HbjwryRx1Icf9u+XvmJ
hRQ7j0Tw09HNLoJBxVRBLX0LYYxTiGBRZS3Azc18nWzlmyTVAMcvPkjoupBArrz6
t1/sTC4Ce1PPYP6slhnggWPvsnfVIsBikLCghgWJjYJPsTyoiNzhgVZ7ObLXguQ1
WmJ78Hkvh2bwHab4cWTIjm4o636X5BzUd3+SuObGjbOvgQ6Kgxyc3FFYYd1GZyAe
FhXNZbsCJXq1D5nr7x6TE0gc9LSFGNtJP2b7YYS/beb4+aU8gIIoNLOaH7yYzT15
HZb4eXrNgh3+O3GMkSAEB4zTVnhpjG9/XBpXKJS2dV1S+K4Xk6F1xONaytDRZEFn
WqP0mVTzMvcitmEDwNL4Fxp/rGF578SPsSw1nEnlXQ9APvfV6ENXJeLLkgs2hShF
+8GjjlLiQRQ3oIHjwcA6HOF6WkRpi6wu4tx8kIi7y7x+WWw4AUyIOovaqfiw8Tp7
qdsW+wgOXfSQ4EuiZL5U9a9uLkkxKDzPCYP94qNd0d7J5S1YojMNJ6FH+QRauzh7
F7OCZvRFQ21/xhjcEglm
=PI6J
-----END PGP SIGNATURE-----

--nextPart6001962.6MGELvzzio--
