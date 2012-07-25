Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab2GYX0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 19:26:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55029 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751233Ab2GYX0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 19:26:53 -0400
Message-ID: <1343258796.5132.164.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] posix_types.h: Cleanup stale __NFDBITS and related
 definitions
From: Ben Hutchings <ben@decadent.org.uk>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, law@redhat.com,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 26 Jul 2012 00:26:36 +0100
In-Reply-To: <20120725144033.GK10534@zod.bos.redhat.com>
References: <20120725144033.GK10534@zod.bos.redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-zdhD5o7FuWw//HmAsCRe"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zdhD5o7FuWw//HmAsCRe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-07-25 at 10:40 -0400, Josh Boyer wrote:
> Recently, glibc made a change to suppress sign-conversion warnings in FD_=
SET
> (glibc commit ceb9e56b3d1).  This uncovered an issue with the kernel's
> definition of __NFDBITS if applications #include <linux/types.h> after
> including <sys/select.h>.  A build failure would be seen when passing the
> -Werror=3Dsign-compare and -D_FORTIFY_SOURCE=3D2 flags to gcc.
>=20
> It was suggested that the kernel should either match the glibc definition=
 of
> __NFDBITS or remove that entirely.  The current in-kernel uses of __NFDBI=
TS
> can be replaced with BITS_PER_LONG, and there are no uses of the related
> __FDELT and __FDMASK defines.  Given that, we'll continue the cleanup tha=
t
> was started with commit 8b3d1cda4f5f ("posix_types: Remove fd_set macros"=
)
> and drop the remaining unused macros.
>=20
> Additionally, linux/time.h has similar macros defined that expand to noth=
ing
> so we'll remove those at the same time.
>=20
> Reported-by: Jeff Law <law@redhat.com>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> CC: <stable@vger.kernel.org>

# v3.4+

(as 8b3d1cda4f5f went into 3.4)

> Signed-off-by: Josh Boyer <jwboyer@redhat.com>
[...]

--=20
Ben Hutchings
Humans are not rational beings; they are rationalising beings.

--=-zdhD5o7FuWw//HmAsCRe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUBCArOe/yOyVhhEJAQpAMhAAn2SzB0Ui/gJBHln/WfOzenWUZ/nJZJCo
b08GN2JKYSluXglPqUpT3l+7PR45bsmHBQBB8qN6UquREwjcyX6HBSKXKAlxTb0j
haS5hF16B2LrXputSBAPw76gpQxTrKVshfC8sypCIgOMYHr9ltLqkQ6x4cS0W1sW
BcNrgT6Z9LInncif4gaA362uufS9c3VDPO+t+Szcva/BvdgcKKoDiASgqRsfh6di
thNYjLcsmnyzdAcpwHn7UWwOA7juNnXsukvj0M8wIH93OU/rzb3JDZ5jEn1LTSkX
22JtSozq/ibb2YB8SPZSXgb1PRb6yLYF69W7P/l5JBYdlDwG/7Rj+IVa/bcSy9HI
0Kw7ynNRWNiN45R6pUUFh3xP5GpaEMFwrsEQDXkgWl5ixhH5uc+KH0rnTMQCt3TZ
gGCAu86icvquw5eCn41LzzHLPfcebdpk0Xw16VBZRUWkqjh5PL9cvuUkFNzqvXYb
iyOsO9lKOYd7EuowfEsvIse+dvm6T3HmLZz1mjqG8wzbVglgPyhTtFD0xGAihiOA
/NkArXQ5YncHv1Pgy0GSgZeKgszhwNCKtnlrMkjEgdjNOSkvtwvPP9dVE7veueyN
4jbBxQ68wqicmeeLIZlG4pbEt/S6vVWDwehEuaOUsACB2vSTo9hPgAiJsrCmICJq
0fVbEzqWckg=
=1vOR
-----END PGP SIGNATURE-----

--=-zdhD5o7FuWw//HmAsCRe--
