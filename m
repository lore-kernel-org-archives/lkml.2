Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab2EREms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 00:42:48 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43494 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab2EREmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 00:42:46 -0400
Message-ID: <4FB5D33A.1040400@gmail.com>
Date: Fri, 18 May 2012 06:42:34 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Evgeniy Dushistov <dushistov@mail.ru>
Subject: Re: [PATCH] Increase file size limit on FreeBSD UFS flavours
References: <4FAFBC30.4040305@gmail.com> <20120517161052.d37cf8ae.akpm@linux-foundation.org>
In-Reply-To: <20120517161052.d37cf8ae.akpm@linux-foundation.org>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigA50AC12157E24E0E37636298"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA50AC12157E24E0E37636298
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 18.05.2012 01:10, Andrew Morton wrote:

> On Sun, 13 May 2012 15:50:40 +0200
> Vladimir '__-coder/phcoder' Serbinenko  <phcoder@gmail.com> wrote:
>=20
>> Increase the file size limit on FreeBSD UFS flavours.
>>
>> Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
>>
>> diff --git a/fs/ufs/super.c b/fs/ufs/super.c
>> index ac8e279..7e80a68 100644
>> --- a/fs/ufs/super.c
>> +++ b/fs/ufs/super.c
>> @@ -768,6 +768,7 @@ static int ufs_fill_super(struct super_block *sb, =
void *data, int silent)
>>  		uspi->s_fshift =3D 9;
>>  		uspi->s_sbsize =3D super_block_size =3D 1536;
>>  		uspi->s_sbbase =3D 0;
>> +		sb->s_maxbytes =3D MAX_LFS_FILESIZE;
>>  		flags |=3D UFS_DE_44BSD | UFS_UID_44BSD | UFS_ST_44BSD | UFS_CG_44B=
SD;
>>  		break;
>>  	case UFS_MOUNT_UFSTYPE_UFS2:
>> @@ -778,6 +779,7 @@ static int ufs_fill_super(struct super_block *sb, =
void *data, int silent)
>>  		uspi->s_fshift =3D 9;
>>  		uspi->s_sbsize =3D super_block_size =3D 1536;
>>  		uspi->s_sbbase =3D  0;
>> +		sb->s_maxbytes =3D MAX_LFS_FILESIZE;
>>  		flags |=3D UFS_TYPE_UFS2 | UFS_DE_44BSD | UFS_UID_44BSD | UFS_ST_44=
BSD | UFS_CG_44BSD;
>>  		break;
>>  	=09
>=20
> But MAX_NON_LFS exists for a reason.  Before this change, the Linux UFS=

> implementation had never had to deal with >4G files (I assume).
>=20
> Are you telling us that the fs has been thoroughly audited and tested
> with large files and that it all worked OK with no other changes?
>=20

The comment indicated that this was simply because the author wasn't
sure as to which UFS flavours actually supported big files. I've tested
it only by creating big file, unmounting the filesystem and then
comparing the read against another UFS implementation (the one in GRUB)
and obtaining perfect match. I haven't done any thorough audit.


--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enigA50AC12157E24E0E37636298
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+10zoACgkQNak7dOguQgkNGgEAwGO4gj6qo0lvoR/TH6UdgdSc
gOq4hsPjDmI1s8gyBKMA/3GhEPxWAUNmvDC9DNOjKOlxWomYTRuy+EBQLHXc5QJt
=j/vV
-----END PGP SIGNATURE-----

--------------enigA50AC12157E24E0E37636298--
