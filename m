Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186Ab2EQAhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 20:37:53 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62254 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab2EQAhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 20:37:51 -0400
Message-ID: <4FB44856.40102@gmail.com>
Date: Thu, 17 May 2012 02:37:42 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 6/8] Support non-BMP characters in UDF
References: <4FB2E25E.900@gmail.com> <20120516143448.GD27661@quack.suse.cz> <4FB3C44F.6080409@gmail.com> <20120516200459.GD1687@quack.suse.cz>
In-Reply-To: <20120516200459.GD1687@quack.suse.cz>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig91B12E0B53F410406496C528"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig91B12E0B53F410406496C528
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 16.05.2012 22:04, Jan Kara wrote:

> On Wed 16-05-12 17:14:23, Vladimir '=CF=86-coder/phcoder' Serbinenko wr=
ote:
>> On 16.05.2012 16:34, Jan Kara wrote:
>>> On Wed 16-05-12 01:10:22, Vladimir '=CF=86-coder/phcoder' Serbinenko =
wrote:
>>>> I also have a counterpart for mkudffs/udf-tools but sourceforge home=
page
>>>> seems to be abandoned does anybody know if there is a new homepage f=
or
>>>> mkudffs?
>   Oh, and I forgot to reply here: mkudffs is really unmaintained. But a=
lso
> it's not used too much AFAIK. Most people use genisoimage to generate u=
df
> filesystems.

But it doesn't seem to be appropriate for non-optical media.


>> 0) Homegrown like in previous patch
>> 1) Add a new "endianness" UTF16_LITTLE_ENDIAN_UNALIGNED
>> 2) Split code for "compressed" vs "uncompressed" and copy the string t=
o
>> a temporary buffer in "uncompressed" branch.
>> 3) Like 2 but make buffer sliding and contain only 2 elements.
>>
>> I think 1 or 3 would be the most reasonable. Which solution do you pre=
fer?
>   I think 1 would be the best since then it can be easily reused by oth=
er
> filesystems which may have similar issue.
>=20

Ok, I'll do it. I've noticed another duplication in the UDF code: there
is NLS support and separate UTF-8 support. UTF-8 is support by 2 ways
actually: with -o utf8 and -o iocharset=3Dutf8 which imply different
codepaths. Specific UTF-8 support is probably slightly faster by
avoiding calls and basically doing everything with shifts (or can be
made so with a small patch). Should I perhaps kill one of them? Is
iocharset!=3Dutf8 still of any importance? I haven't seen it in ages.
Perhaps we could keep just the performant UTF-8 support and map
iocharset=3Dutf8 to it and drop iocharset!=3Dutf8? iocharset!=3Dutf8 prob=
ably
has no users anyway so keeping it we're likely to keep bugs and code
duplication with no benefit.

--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enig91B12E0B53F410406496C528
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+0SFYACgkQNak7dOguQglETwD/V8ECStEspbMYRCtaTO9HSaFJ
m1wM3tbCgGLoZh3omWEBALTH3NqgBSacQessZcXlX/kS4oCEFU5ZgMCiwMDdzDFe
=8I1s
-----END PGP SIGNATURE-----

--------------enig91B12E0B53F410406496C528--
