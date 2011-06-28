Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab1F1HKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 03:10:16 -0400
Received: from 207-126-122-235.ip.openhosting.com ([207.126.122.235]:55442
	"EHLO drepperk.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755735Ab1F1HJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 03:09:04 -0400
Message-ID: <4E097DCE.1090004@akkadia.org>
Date: Tue, 28 Jun 2011 03:07:58 -0400
From: Ulrich Drepper <drepper@akkadia.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, wilsons@start.ca, linux-man@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH] Add cloexec information to fdinfo
References: <201106100355.p5A3t8Aa024924@drepperk.user.openhosting.com> <20110620143131.9c6e040c.akpm@linux-foundation.org>
In-Reply-To: <20110620143131.9c6e040c.akpm@linux-foundation.org>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9A9705871A68BA8FF54D72F8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9A9705871A68BA8FF54D72F8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 06/20/2011 05:31 PM, Andrew Morton wrote:
> Does FD_ISSET return 0 or 1?  Or 0 or non-zero?
>=20
> For x86 it's the former.
>=20
> <checks the architectures>
>=20
> arch/h8300/include/asm/posix_types.h: busted
> #define __FD_ISSET(d, set)      ((set)->fds_bits[__FDELT(d)] & __FDMASK=
(d))
>=20
> arch/m68k/include/asm/posix_types.h: busted
> #define __FD_ISSET(d, set)      ((set)->fds_bits[__FDELT(d)] & __FDMASK=
(d))
>=20
> arch/xtensa/include/asm/posix_types.h: busted
> #define __FD_ISSET(d, set)      ((set)->fds_bits[__FDELT(d)] & __FDMASK=
(d))

I agree, this is an issue.  Existing code works around this.  We should
use the attached patch on top of the existing one.


This doesn't invalidate your patch to harmonize the architectures but
the above is what existing code does.  I didn't use a tab in the output
since the initial string is long enough to force the subsequent text in
a new column.  Using a single space seemed more visually pleasing.



Signed-off-by: Ulrich Drepper <drepper@gmail.com>

--- a/fs/proc/base.c	2011-06-28 02:54:01.888793757 -0400
+++ b/fs/proc/base.c	2011-06-28 02:54:30.668664335 -0400
@@ -1939,7 +1939,7 @@
 					 "cloexec:\t%d\n",
 					 (long long) file->f_pos,
 					 file->f_flags,
-					 cloexec);
+					 cloexec ? FD_CLOEXEC : 0);
 			}
 			spin_unlock(&files->file_lock);
 			put_files_struct(files);


--------------enig9A9705871A68BA8FF54D72F8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAk4Jfc4ACgkQ2ijCOnn/RHQ05gCgu4yikszRPlgoAIDnhuhVzyA4
v4EAmwURz4ww9sirtln/5ELsYayqV2fD
=Xsaa
-----END PGP SIGNATURE-----

--------------enig9A9705871A68BA8FF54D72F8--
