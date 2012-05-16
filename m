Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab2EPPOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:14:35 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36173 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960Ab2EPPOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:14:32 -0400
Message-ID: <4FB3C44F.6080409@gmail.com>
Date: Wed, 16 May 2012 17:14:23 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 6/8] Support non-BMP characters in UDF
References: <4FB2E25E.900@gmail.com> <20120516143448.GD27661@quack.suse.cz>
In-Reply-To: <20120516143448.GD27661@quack.suse.cz>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigC7DADA256DDDADA4D90BF5CE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC7DADA256DDDADA4D90BF5CE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 16.05.2012 16:34, Jan Kara wrote:

> On Wed 16-05-12 01:10:22, Vladimir '=CF=86-coder/phcoder' Serbinenko wr=
ote:
>> I also have a counterpart for mkudffs/udf-tools but sourceforge homepa=
ge
>> seems to be abandoned does anybody know if there is a new homepage for=

>> mkudffs?
>   Thanks for the patch!

You're welcome. Thanks for reviewing.

 It looks OK but shouldn't we rather use the helper
> functions you introduced in the NLS code? It look wrong to replicate
> decoding of UTF16 here.
>=20

The helper functions are limited to buffers aligned on 16-bit boundary
which is not the case of this buffer. I see following solutions:
0) Homegrown like in previous patch
1) Add a new "endianness" UTF16_LITTLE_ENDIAN_UNALIGNED
2) Split code for "compressed" vs "uncompressed" and copy the string to
a temporary buffer in "uncompressed" branch.
3) Like 2 but make buffer sliding and contain only 2 elements.

I think 1 or 3 would be the most reasonable. Which solution do you prefer=
?

--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enigC7DADA256DDDADA4D90BF5CE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+zxE8ACgkQNak7dOguQgm9AwD+PGqXGYMaJz/cKGkXXAb9APaV
EcUMpVq7kBqPrJ4HgXMBAJQGv6t3UxdADMpTVjzEWuNB58kWnvGOUpke/LWFqHmp
=SbQk
-----END PGP SIGNATURE-----

--------------enigC7DADA256DDDADA4D90BF5CE--
