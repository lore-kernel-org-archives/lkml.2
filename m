Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab2ALMCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 07:02:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58271 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab2ALMC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 07:02:28 -0500
Date: Thu, 12 Jan 2012 13:02:25 +0100
From: Tyler Hicks <tyler.hicks@canonical.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] ecryptfs: Print inode on metadata error
Message-ID: <20120112120225.GC4717@boyd>
References: <1326301242-5817-1-git-send-email-tim.gardner@canonical.com>
 <1326301242-5817-3-git-send-email-tim.gardner@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2JFBq9zoW8cOFH7v"
Content-Disposition: inline
In-Reply-To: <1326301242-5817-3-git-send-email-tim.gardner@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2JFBq9zoW8cOFH7v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-01-11 18:00:42, Tim Gardner wrote:
> If a lower file system file is corrupted, then ecryptfs prints
> a generic and mostly useless log message when attempting to
> read metadata. Print the inode associated with the file
> so that a user can do something about it, e.g.,
>=20
> find -inum INODE_NUM
>=20
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> Cc: Tyler Hicks <tyler.hicks@canonical.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---

This looks good to me. I'll get it applied. Thanks!

Tyler

>  fs/ecryptfs/crypto.c |   14 +++++++++-----
>  1 files changed, 9 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
> index ac063bd..affad0c 100644
> --- a/fs/ecryptfs/crypto.c
> +++ b/fs/ecryptfs/crypto.c
> @@ -1612,8 +1612,9 @@ int ecryptfs_read_metadata(struct dentry *ecryptfs_=
dentry)
>  	rc =3D ecryptfs_read_lower(page_virt, 0, crypt_stat->extent_size,
>  				 ecryptfs_inode);
>  	if (rc < 0) {
> -		printk(KERN_ERR "%s: Could not read %u bytes\n",
> -			__func__, crypt_stat->extent_size);
> +		printk(KERN_ERR "%s: Could not read %zu bytes, inode %lu\n",
> +			__func__, crypt_stat->extent_size,
> +			ecryptfs_inode->i_ino);
>  		goto out;
>  	}
> =20
> @@ -1625,7 +1626,8 @@ int ecryptfs_read_metadata(struct dentry *ecryptfs_=
dentry)
>  		rc =3D ecryptfs_read_xattr_region(page_virt, ecryptfs_inode);
>  		if (rc) {
>  			printk(KERN_DEBUG "Valid eCryptfs headers not found in "
> -			       "file header region or xattr region\n");
> +			       "file header region or xattr region, inode %lu\n",
> +				ecryptfs_inode->i_ino);
>  			rc =3D -EINVAL;
>  			goto out;
>  		}
> @@ -1634,7 +1636,8 @@ int ecryptfs_read_metadata(struct dentry *ecryptfs_=
dentry)
>  						ECRYPTFS_DONT_VALIDATE_HEADER_SIZE);
>  		if (rc) {
>  			printk(KERN_DEBUG "Valid eCryptfs headers not found in "
> -			       "file xattr region either\n");
> +			       "file xattr region either, inode %lu\n",
> +				ecryptfs_inode->i_ino);
>  			rc =3D -EINVAL;
>  		}
>  		if (crypt_stat->mount_crypt_stat->flags
> @@ -1645,7 +1648,8 @@ int ecryptfs_read_metadata(struct dentry *ecryptfs_=
dentry)
>  			       "crypto metadata only in the extended attribute "
>  			       "region, but eCryptfs was mounted without "
>  			       "xattr support enabled. eCryptfs will not treat "
> -			       "this like an encrypted file.\n");
> +			       "this like an encrypted file, inode %lu\n",
> +				ecryptfs_inode->i_ino);
>  			rc =3D -EINVAL;
>  		}
>  	}
> --=20
> 1.7.8.3
>=20

--2JFBq9zoW8cOFH7v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJPDsvRAAoJENaSAD2qAscKwhkP/icJ1qVrz9Qv6sUEjPgn/mPg
y51hXOIjuPB3DqC29HdDIMJtaVJq557/fX5pg3MSr2EtUcVG1qzlZSpQSB1Gg1Ag
CX/2/93hakf2GKl1LsnjlxGVbm+PYRqNGumU42JL32F2T0AVyExugk6zaa0ic+TF
LVZgfyljBpV7vEfTSZdb2eA2nU+kAIhj3bHP+3uRJeuAo0bg9Gi0FDgQ5r2Jen33
Fq1/jCFiE138rVzmwht7hhCwXhR/Ql0Sh+iKKWmaM9v1hN7FcKPF7RVT85ME56cK
VAxcSasA8a+2SW2kMov1tYgs6zE+eXY2FaL8QdNbXbmIs58udVycpd9PTogCaUc5
U9A3fh54zgIAWZHmTC4wCpIwDgEllbP4G4DAPRjZmdKik1bTs3S+2dZlUzKkw9OG
DFSHIUDm4CL44UkhngxIOTRdd5y6XYeAsarfp1UGYM0hFnYgWZkABZVY4fZs7toA
LJaEXYt28jC8a22G2kvs1N4UlgBXc2yyKDZwgZkotiWhZ+JTjZA7hPtTbx8Obc8a
u7F/DgWKe6ObJE0i1B9tnMz1caSqRWXlDPiFcoVq7UBZRT70tXtiLvGgfIyYZuWF
6Ahwfht79xdIpwam6samL3qWjFaRCou/umWDY2ufuHhaRv32s4AD7kc6rvoK4r+/
F9lM/F18VTkbKQ4gkXux
=n2UV
-----END PGP SIGNATURE-----

--2JFBq9zoW8cOFH7v--
