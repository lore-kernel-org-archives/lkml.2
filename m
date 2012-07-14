Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab2GNAY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 20:24:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41196 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab2GNAYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 20:24:54 -0400
Date: Fri, 13 Jul 2012 17:24:49 -0700
From: Tyler Hicks <tyhicks@canonical.com>
To: Tim Sally <tsally@atomicpeace.com>
Cc: dustin.kirkland@gazzang.com, ecryptfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] eCryptfs: check for eCryptfs cipher support at mount
Message-ID: <20120714002448.GB24393@boyd>
References: <20120711171152.GA16475@boyd>
 <1342134624-31564-1-git-send-email-tsally@atomicpeace.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="OwLcNYc0lM97+oe1"
Content-Disposition: inline
In-Reply-To: <1342134624-31564-1-git-send-email-tsally@atomicpeace.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-07-12 19:10:24, Tim Sally wrote:
> The issue occurs when eCryptfs is mounted with a cipher supported by
> the crypto subsystem but not by eCryptfs. The mount succeeds and an
> error does not occur until a write. This change checks for eCryptfs
> cipher support at mount time.
>=20
> Resolves Launchpad issue #338914, reported by Tyler Hicks in 03/2009.
> https://bugs.launchpad.net/ecryptfs/+bug/338914
>=20
> Signed-off-by: Tim Sally <tsally@atomicpeace.com>

Looks good! I've pushed it to the eCryptfs -next branch and it will go
in during the 3.6 merge window.

I'm looking forward to more eCryptfs patches from you. Thanks!

Tyler

> ---
>  fs/ecryptfs/main.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
>=20
> diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
> index df217dc..aee998d 100644
> --- a/fs/ecryptfs/main.c
> +++ b/fs/ecryptfs/main.c
> @@ -279,6 +279,7 @@ static int ecryptfs_parse_options(struct ecryptfs_sb_=
info *sbi, char *options,
>  	char *fnek_src;
>  	char *cipher_key_bytes_src;
>  	char *fn_cipher_key_bytes_src;
> +	u8 cipher_code;
> =20
>  	*check_ruid =3D 0;
> =20
> @@ -420,6 +421,18 @@ static int ecryptfs_parse_options(struct ecryptfs_sb=
_info *sbi, char *options,
>  	    && !fn_cipher_key_bytes_set)
>  		mount_crypt_stat->global_default_fn_cipher_key_bytes =3D
>  			mount_crypt_stat->global_default_cipher_key_size;
> +
> +	cipher_code =3D ecryptfs_code_for_cipher_string(
> +		mount_crypt_stat->global_default_cipher_name,
> +		mount_crypt_stat->global_default_cipher_key_size);
> +	if (!cipher_code) {
> +		ecryptfs_printk(KERN_ERR,
> +				"eCryptfs doesn't support cipher: %s.",
> +				mount_crypt_stat->global_default_cipher_name);
> +		rc =3D -EINVAL;
> +		goto out;
> +	}
> +
>  	mutex_lock(&key_tfm_list_mutex);
>  	if (!ecryptfs_tfm_exists(mount_crypt_stat->global_default_cipher_name,
>  				 NULL)) {
> --=20
> 1.7.10.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe ecryptfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--OwLcNYc0lM97+oe1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJQALxQAAoJENaSAD2qAscKJJAP/2f98CITfgwIzaL6Hc9ZzY8R
ZZwo+JJCOv7UqsOtPNb9WYSQ2F5aoMrY4BkYLLj4RLxAwuEk3M/e/gYpP7VSrCPd
L2+/q+bJ/D8DOJGHDCaqcpTkD2jVz16AsuK7gH5+Z68ALBr8aqtl9QPfYs9Wwxwj
5QCdpa9iWZp+cegDUBH6QreFtkoZWK6S9kTNGZ+jAWdFdYSD51QupybwFTk69OzG
2znUnjFqwUzp86CZDau3nohrJo9yz74a0vpku96wOIvSzgRTkqaSCBGbim20O5Ir
iQ1RSwie8NLT8D2wnROr3erOrbcEdzWP5GJ2130TlM1xvDbNbOhIFmM17+Os6W9h
VNeRNbXlIh0gkXI/kBOWiMJ2hc3cduSWhRQa3PFFGES5IcwCXFln8H7v2nC+9GRy
Q+Ap03zKKfnUETvGpu22jt5EDqSbBC/wvQk08qy9n1zNm4fX277ppzCIMblPrf/R
9A/dGZlIm3dMpx8I8EkqcFp9IJEbSX2fxB1FBxqtzwu9sp3uEN1C9PvaqNnAzwU9
gHnfpMZ5qf3sFCD4xmEECCepk5uC2J4Ay3va5DmEGgKO5ZTeDvW6HgB4p/At2N4u
zLCDPWDk95DpRjXosyqN1qUPjyB5tkZBRcX2VsW83PXoeZa81e1wK/KFYROh912R
ORmC81Y3VDDN6Ta2W/DX
=KrfE
-----END PGP SIGNATURE-----

--OwLcNYc0lM97+oe1--
