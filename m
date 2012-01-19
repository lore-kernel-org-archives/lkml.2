Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab2ASIso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 03:48:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53921 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab2ASIsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 03:48:41 -0500
Date: Thu, 19 Jan 2012 02:48:36 -0600
From: Tyler Hicks <tyhicks@canonical.com>
To: Li Wang <liwang@nudt.edu.cn>
Cc: ecryptfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] eCryptfs: infinite loop bug
Message-ID: <20120119084836.GA29477@boyd>
References: <12011815300568720b5d1587bb777fed0d5b016f0854@nudt.edu.cn>
 <4F16E4BC.5080100@gmail.com>
 <526922120.05125@eyou.net>
 <12011909443668a7a65ff897afc93db177848236f08f@nudt.edu.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <12011909443668a7a65ff897afc93db177848236f08f@nudt.edu.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-01-19 09:44:36, Li Wang wrote:
>=20
>=20
> Hi,
>   Thanks Cong Wang for the kind reminding regarding the patch format.

The commit message still needs some work. But there's no need to drag
out the process for a fix like this, so I'll rewrite the commit message
and reply to this email with the cleaned up version. Let me know if you
have any problems with that. You'll still be credited as the author.

For future kernel patches, please see "15) The canonical patch format"
of Documentation/SubmittingPatches and "5.4: PATCH FORMATTING AND
CHANGELOGS" of Documentation/development-process/5.Posting for more
information on how the commit message should be written.

Also, your email came across in base64 encoding. I'm not sure of the
reason for that or how to fix it.

>   We did notice that the total_remaining_zeroes need be revised as well,=
=20
> and the start_offset_in_page, num_bytes need not be revised (always small=
er=20

Yes, size_t will work fine, as Linus confirmed.

> than PAGE_CACHE_SIZE, even the huge page size is supported,=20
> the 4G page size is not present in the current world?)
> but we forget to include the revision for total_remaining_zeroes, so here=
 comes the patch.

I really appreciate the patch - thanks!

Tyler

>=20
> Cheers,
> Li Wang
>=20
> Signed-off-by: Li Wang <liwang@nudt.edu.cn>
>                Yunchuan Wen <wenyunchuan@kylinos.com.cn>
>=20
> ---
>=20
> --- a/fs/ecryptfs/read_write.c	2012-01-19 17:34:54.666940824 +0800
> +++ b/fs/ecryptfs/read_write.c	2012-01-19 17:35:16.257940840 +0800
> @@ -130,13 +130,13 @@ int ecryptfs_write(struct inode *ecryptf
>  		pgoff_t ecryptfs_page_idx =3D (pos >> PAGE_CACHE_SHIFT);
>  		size_t start_offset_in_page =3D (pos & ~PAGE_CACHE_MASK);
>  		size_t num_bytes =3D (PAGE_CACHE_SIZE - start_offset_in_page);
> -		size_t total_remaining_bytes =3D ((offset + size) - pos);
> +		loff_t total_remaining_bytes =3D ((offset + size) - pos);
> =20
>  		if (num_bytes > total_remaining_bytes)
>  			num_bytes =3D total_remaining_bytes;
>  		if (pos < offset) {
>  			/* remaining zeros to write, up to destination offset */
> -			size_t total_remaining_zeros =3D (offset - pos);
> +			loff_t total_remaining_zeros =3D (offset - pos);
> =20
>  			if (num_bytes > total_remaining_zeros)
>  				num_bytes =3D total_remaining_zeros;
>=20
>=20
>=20
>=20
>=20
> ---------- Origin message ----------
> >From=EF=BC=9A"Tyler Hicks" <tyhicks@canonical.com>
> >To=EF=BC=9A"Cong Wang" <xiyou.wangcong@gmail.com>
> >Subject=EF=BC=9ARe: [PATCH] eCryptfs: infinite loop bug
> >Date=EF=BC=9A2012-01-19 05:40:51
>=20
> On 2012-01-18 23:26:52, Cong Wang wrote:
> > On 01/18/2012 03:30 PM, Li Wang wrote:
> > >Hi,
> > > There is an infinite loop bug in eCryptfs, to make it present,
> > >just truncate to generate a huge file (>=3D 4G) on a 32-bit machine
> > >under the plain text foleder mounted with eCryptfs, a simple command
> > >'truncate -s 4G dummy' is enough. Note: 4GB is smaller than 4G,
> > >therefore the following command 'truncate -s 4GB dummy' will not trigg=
er this bug.
> > >The bug comes from a data overflow, the patch below fixes it.
> > >
> > >
> >
> > Hi,
> >
> > Your patch is not correctly generated, you need to make the diff on
> > top of the source tree.
> >
> > Also, after reviewing the code, I think there are more places need
> > to fix. Can you try my patch below?

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJPF9jkAAoJENaSAD2qAscKZFkQAMzQiD0gLlYjxOk/0A8L+Rnq
zaNdl19gTmz/sGBbYIXNhfdO25hhyZUVTKA0f4vSuibBCjCUA2ma73mJIFssDw2x
nCscPVLlUb3AQJY8KqNlGu+dSvYWTdeHJzKISvJvsZwXa1TTcYlusbT5Djdi1pYK
SHfAjFrrwgD6ZI1tBtOMoxkfo+oMA6SNtwzAKAoeZn61vFDgIsFU1Gw/Bz+2yOg+
NGwEPeqtM6JLyQEMMyduR4V04IEwlKLXsAIXWUw92CzI3tLouHsUinuWITR99ZJj
OBaazfPkMAENGfofHUAap6egKSqes5A7YolYBUt10KUuDPR0AT/q1O5Xbd+4uDeo
oIB57ODGK8TcF3TuRe9Ou/x2jj249IfjDH2ahSg0MSBfozmviPrhyfegyx1Lyplh
Kq6GnMN7n18NdWulsmCj+++11PKg88ekdvl0QIsglP9S56LJvAUn3L0fNSmrH4hK
wLycn5FmT12Q6hZ47ZFxP8DBU/VSn3RFjibJ0kTMT3FiOSpuYegEMXEx8sATAr1X
OOrnaD7KMRfILDkhqsMPAWumeXKAK4erlig5Bs70dtoS9rZcYtv7GgiddOYtDSwU
cLHPhThKnV02w+WqrxMm6TL+kiUNvtPGv8gT8LxjC/ezu9JbQkb0hGKBwx7MAfKm
lv7tz1kDNFgPThjn2P2p
=5lWY
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
