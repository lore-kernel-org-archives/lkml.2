Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab1DWRP1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 13:15:27 -0400
Received: from glenfiddich.ikibiki.org ([88.191.124.82]:47323 "EHLO
	glenfiddich.ikibiki.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab1DWRPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 13:15:24 -0400
Date: Sat, 23 Apr 2011 19:15:22 +0200
From: Cyril Brulebois <kibi@debian.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH 3/4] Documentation/00-INDEX.sh: add script to help
 keeping the index up-to-date
Message-ID: <20110423171522.GF32680@debian.org>
References: <1303575344-10403-1-git-send-email-kibi@debian.org>
 <1303575344-10403-3-git-send-email-kibi@debian.org>
 <20110423093304.8a31e512.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eNMatiwYGLtwo1cJ"
Content-Disposition: inline
In-Reply-To: <20110423093304.8a31e512.rdunlap@xenotime.net>
Organization: Debian
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eNMatiwYGLtwo1cJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Randy Dunlap <rdunlap@xenotime.net> (23/04/2011):
> but what am I doing wrong?
>=20
> cd Documentation
> sh ./00-INDEX.sh
>=20
> The "undocumented" list looks correct (well, it could omit .orig files),
> but the "Documented but missing" list contains words, e.g.:

Looks like sed's not filtering out lines before '00-INDEX'; my reading
of POSIX sed specification[1] would seem to confirm the filtering
should work, see:
    [2addr]d
    Delete the pattern space and start the next cycle.

 1. http://pubs.opengroup.org/onlinepubs/007908799/xcu/sed.html

Maybe some regex fun then; what if you remove the anchors (^ and $)?

And anyway, using sed --posix to disable all GNU extensions gives the
expected output here (with GNU sed version 4.2.1).

What's your sed/system, so that I can check what's going on there, and
how to deal with it?

Using 'grep -A $ABIGNUMBER' could be a workaround I guess, but a ugly
one=E2=80=A6

KiBi.

--eNMatiwYGLtwo1cJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk2zCSoACgkQeGfVPHR5Nd0FwwCeM2cHLx9R5NIkeSRVha4hTpe1
wN0AoIBcd02MN6gyoofvgkcqIspMWjNG
=hWD9
-----END PGP SIGNATURE-----

--eNMatiwYGLtwo1cJ--
