Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127Ab2BJUQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:16:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59294 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758575Ab2BJUQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:16:12 -0500
Date: Fri, 10 Feb 2012 14:16:06 -0600
From: Tyler Hicks <tyhicks@canonical.com>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Dustin Kirkland <dustin.kirkland@gazzang.com>,
        ecryptfs@vger.kernel.org
Subject: Re: [PATCH 29/60] ecryptfs: remove the second argument of
 k[un]map_atomic()
Message-ID: <20120210201605.GC15606@boyd>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
 <1328852421-19678-30-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="sHrvAb52M6C8blB9"
Content-Disposition: inline
In-Reply-To: <1328852421-19678-30-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sHrvAb52M6C8blB9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-02-10 13:39:50, Cong Wang wrote:
> Signed-off-by: Cong Wang <amwang@redhat.com>

Thanks - Looks good to me.

I'm not sure if you want me to pick this up or if you want to continue
to keep track of the entire pile of patches. Either way, I went ahead
and pushed it to
git://git.kernel.org/pub/scm/linux/kernel/git/tyhicks/ecryptfs.git#next

Tyler

> ---
>  fs/ecryptfs/mmap.c       |    4 ++--
>  fs/ecryptfs/read_write.c |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
> index 10ec695..a46b3a8 100644
> --- a/fs/ecryptfs/mmap.c
> +++ b/fs/ecryptfs/mmap.c
> @@ -150,7 +150,7 @@ ecryptfs_copy_up_encrypted_with_header(struct page *p=
age,
>  			/* This is a header extent */
>  			char *page_virt;
> =20
> -			page_virt =3D kmap_atomic(page, KM_USER0);
> +			page_virt =3D kmap_atomic(page);
>  			memset(page_virt, 0, PAGE_CACHE_SIZE);
>  			/* TODO: Support more than one header extent */
>  			if (view_extent_num =3D=3D 0) {
> @@ -163,7 +163,7 @@ ecryptfs_copy_up_encrypted_with_header(struct page *p=
age,
>  							       crypt_stat,
>  							       &written);
>  			}
> -			kunmap_atomic(page_virt, KM_USER0);
> +			kunmap_atomic(page_virt);
>  			flush_dcache_page(page);
>  			if (rc) {
>  				printk(KERN_ERR "%s: Error reading xattr "
> diff --git a/fs/ecryptfs/read_write.c b/fs/ecryptfs/read_write.c
> index 5c0106f..b2a34a1 100644
> --- a/fs/ecryptfs/read_write.c
> +++ b/fs/ecryptfs/read_write.c
> @@ -156,7 +156,7 @@ int ecryptfs_write(struct inode *ecryptfs_inode, char=
 *data, loff_t offset,
>  			       ecryptfs_page_idx, rc);
>  			goto out;
>  		}
> -		ecryptfs_page_virt =3D kmap_atomic(ecryptfs_page, KM_USER0);
> +		ecryptfs_page_virt =3D kmap_atomic(ecryptfs_page);
> =20
>  		/*
>  		 * pos: where we're now writing, offset: where the request was
> @@ -179,7 +179,7 @@ int ecryptfs_write(struct inode *ecryptfs_inode, char=
 *data, loff_t offset,
>  			       (data + data_offset), num_bytes);
>  			data_offset +=3D num_bytes;
>  		}
> -		kunmap_atomic(ecryptfs_page_virt, KM_USER0);
> +		kunmap_atomic(ecryptfs_page_virt);
>  		flush_dcache_page(ecryptfs_page);
>  		SetPageUptodate(ecryptfs_page);
>  		unlock_page(ecryptfs_page);
> --=20
> 1.7.7.6
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe ecryptfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--sHrvAb52M6C8blB9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJPNXsFAAoJENaSAD2qAscK23UP/1dn27t6G6VNBhJORlDCEmRD
mG7rO4BGLMHS76Hukg5cwmhOUb1BVrxfZL5/8aJ8eDqiVpPMtlsxxZ1LKtHPU9V6
BxD65oVwoTMV8mI1PZpbne8lRZPXi31IENUi50Po/UzLfqqiSJh2fuo1p+me3+zV
q82ZCfdgW1xvvieCglbeY4i7IZdnn7fWPBqUPbbs0MtBhYER4zpRRM0wgNr6J/mE
2+mdLYzjczRTRiCsMpT3eze7TPqYC2UcsT/WW3UxFN96ej9XF67YAFcEZ6NvXGpc
em6ocnGKQKmkStUi6gjsb/uG0axBdPOaQqg57BB7zL8oBkdTqgWYjbQ5YIb17pWl
X1Th5cyor9WfLgpEO09jUHXeRLxLcXLfRLA+19o4qh4yNxOrPH/SUNbaLecgeD13
CMtnQL7Ko2YhkNfWpLHMbql0hVrKFXqpYF6dnQMK2r2pUWLsiMCm7kfnxsM8Rb/b
v1lJyA0hAtleozwPKc93p9Z5eRLZoknFn11/xQJqtAFjkvXrDnn2xUjtqTgwJZcM
zfZbrOLLWApmf0D5jl1f5u+Aj70hFAKz44foQuYe1VvFxd8pFkUB+qnSmjOnHBkn
zYLOgVpyBUExm8Kh6+xXHQdzChI2hgguMFmksySlq62eajjNHOWKw0RwgMFaLdhn
6zP/Csug8aj77EEHWnQ7
=qw8c
-----END PGP SIGNATURE-----

--sHrvAb52M6C8blB9--
