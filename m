Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759014Ab2EQAtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 20:49:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44037 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758907Ab2EQAtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 20:49:06 -0400
Message-ID: <4FB44AF1.4060103@gmail.com>
Date: Thu, 17 May 2012 02:48:49 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Eliminating UDF iocharset!=utf8 code (Re: [PATCH 6/8] Support non-BMP
 characters in UDF)
References: <4FB2E25E.900@gmail.com> <20120516143448.GD27661@quack.suse.cz> <4FB3C44F.6080409@gmail.com> <20120516200459.GD1687@quack.suse.cz> <4FB44856.40102@gmail.com>
In-Reply-To: <4FB44856.40102@gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigD4A3D0FE102BEDA51465E91C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD4A3D0FE102BEDA51465E91C
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


> I've noticed another duplication in the UDF code: there
> is NLS support and separate UTF-8 support. UTF-8 is support by 2 ways
> actually: with -o utf8 and -o iocharset=3Dutf8 which imply different
> codepaths. Specific UTF-8 support is probably slightly faster by
> avoiding calls and basically doing everything with shifts (or can be
> made so with a small patch). Should I perhaps kill one of them? Is
> iocharset!=3Dutf8 still of any importance? I haven't seen it in ages.
> Perhaps we could keep just the performant UTF-8 support and map
> iocharset=3Dutf8 to it and drop iocharset!=3Dutf8? iocharset!=3Dutf8 pr=
obably
> has no users anyway so keeping it we're likely to keep bugs and code
> duplication with no benefit.
>=20

Linux seems to support UTF-8-only pretty strongly: http://yarchive.net/co=
mp/linux/utf8.html
(message from Sun, 15 Feb 2004 02:42:45 GMT).
And I completely agree.
If it's ok to kill iocharset!=3Dutf8 I'll propose a series of 3 patches (=
killing iocharset!=3Dutf8,
extending utf16toutf8/utf8toutf16 for unaligned input, changing UDF code =
to use common functions)


--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enigD4A3D0FE102BEDA51465E91C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF0EAREKAAYFAk+0SvEACgkQNak7dOguQgnrOAD/dSk+wlkYznIDZoPBLzB2aKaJ
nHi1E0txGIZ9ubJ2L08A+IbeRt7TQW9HZAlc+4Jpm5HuwrwUfbH0hMFNSttYpK4=
=fFNP
-----END PGP SIGNATURE-----

--------------enigD4A3D0FE102BEDA51465E91C--
