Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab2EMWQe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 18:16:34 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47342 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab2EMWQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 18:16:32 -0400
Message-ID: <4FB032BB.6060209@gmail.com>
Date: Mon, 14 May 2012 00:16:27 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Evgeniy Dushistov <dushistov@mail.ru>
Subject: Re: [PATCH] update i_blocks on UFS
References: <4FAFBCAE.1050401@gmail.com> <20120513215925.GA1998@maclin>
In-Reply-To: <20120513215925.GA1998@maclin>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig5A543657D5A42F93CDB03259"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5A543657D5A42F93CDB03259
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 13.05.2012 23:59, Evgeniy Dushistov wrote:

> On Sun, May 13, 2012 at 03:52:46PM +0200, Vladimir '=CF=86-coder/phcode=
r' Serbinenko wrote:
>> UFS code dosn't update i_blocks which leads to the problems ranging fr=
om wrong
>> stat/du to long symlinks (as opposed to inline ones) being damaged. Th=
is is
>> a fix.
>>
>=20
> Yes, when quota support was removed, code that update statistic
> about usage of blocks also was removed. But why so big change to fix th=
is?
> I found this problem some time ago and fixed it with code bellow,
> but may be I missed something?
>=20

Hm, I don't know why this code wasn't in my copy. Was it already
propagated to Linus' tree? When will it be? Which tree I should merge
from to get your latest fixes?
My code avoided counting metadata blocks (the ones holding the pointers
to actual blocks in indirect, double-indirect and triple-indirect
chains). I thought that i_blocks doesn't take into account the
metablocks but quick experiment with NetBSD image proved me wrong. So I
retract this patch altogether.
My UFS file size limit patch remains though.

--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enig5A543657D5A42F93CDB03259
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+wMrwACgkQNak7dOguQgk1ZQEAqd8Jsj+L5ZzHY1zM/X28Y+T3
BmuugZPsL7ZwaBolwesA/1iaNkvyEkSsMXq5qrZ5rflF/zxLcY2UTlzG6PyNsjwS
=zzKc
-----END PGP SIGNATURE-----

--------------enig5A543657D5A42F93CDB03259--
