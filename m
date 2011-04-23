Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab1DWVFk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 17:05:40 -0400
Received: from glenfiddich.ikibiki.org ([88.191.124.82]:33318 "EHLO
	glenfiddich.ikibiki.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911Ab1DWVFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 17:05:38 -0400
Date: Sat, 23 Apr 2011 23:05:37 +0200
From: Cyril Brulebois <kibi@debian.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH 3/4] Documentation/00-INDEX.sh: add script to help
 keeping the index up-to-date
Message-ID: <20110423210537.GI32680@debian.org>
References: <1303575344-10403-1-git-send-email-kibi@debian.org>
 <1303575344-10403-3-git-send-email-kibi@debian.org>
 <20110423093304.8a31e512.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qLni7iB6Dl8qUSwk"
Content-Disposition: inline
In-Reply-To: <20110423093304.8a31e512.rdunlap@xenotime.net>
Organization: Debian
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qLni7iB6Dl8qUSwk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Randy Dunlap <rdunlap@xenotime.net> (23/04/2011):
> The "undocumented" list looks correct (well, it could omit .orig
> files), but the "Documented but missing" list contains words, e.g.:
> [=E2=80=A6]

One coffee later=E2=80=A6 Looks like your grep is behaving as if "grep -F" =
was
passed; that might be better with an explicit "grep -G" (which is the
default), see patch below?

diff --git a/Documentation/00-INDEX.sh b/Documentation/00-INDEX.sh
index 31d92d2..f22c260 100755
--- a/Documentation/00-INDEX.sh
+++ b/Documentation/00-INDEX.sh
@@ -4,7 +4,7 @@
 # Try and keep the 00-INDEX file up-to-date.
=20
 # List all entries below the 00-INDEX entry:
-documented=3D$(sed '1,/^00-INDEX$/d' 00-INDEX|grep -v '^\s'|sed 's,/$,,')
+documented=3D$(sed '1,/^00-INDEX$/d' 00-INDEX|grep -G -v '^\s'|sed 's,/$,,=
')
=20
 # List all files/directories except 00-INDEX* and Makefile:
 present=3D$(ls -1|grep -v '^00-INDEX'|grep -v '^Makefile$')


Maybe some grep alias in your environment? I couldn't reproduce the
behaviour you mentioned even using (unpack+PATH+LD_LIBRARY_PATH)
pcre-7.8-2.fc11.ppc.rpm and sed-4.2.1-1.fc11.ppc.rpm, until I tried
various options like passing -F to grep.

KiBi.

--qLni7iB6Dl8qUSwk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk2zPyEACgkQeGfVPHR5Nd2PJACdE/is+AYLo3e68jtKRsFY4Kr/
wFEAoKTFDRWFn06ozf8L5IFow5TzUe+N
=JpLY
-----END PGP SIGNATURE-----

--qLni7iB6Dl8qUSwk--
