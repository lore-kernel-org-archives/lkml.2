Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab1K0GAw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 01:00:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58255 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab1K0GAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 01:00:50 -0500
Date: Sun, 27 Nov 2011 17:00:13 +1100
From: NeilBrown <neilb@suse.de>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-raid@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [PATCH 17/62] md: remove the second argument of
 k[un]map_atomic()
Message-ID: <20111127170013.20d180a9@notabene.brown>
In-Reply-To: <1322371662-26166-18-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
	<1322371662-26166-18-git-send-email-amwang@redhat.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Qdl12FHP_lk.3ELq_DsDIDz"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Qdl12FHP_lk.3ELq_DsDIDz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 27 Nov 2011 13:26:57 +0800 Cong Wang <amwang@redhat.com> wrote:

>=20
> Signed-off-by: Cong Wang <amwang@redhat.com>

This and patch 57/62

 Acked-by: NeilBrown <neilb@suse.de>

thanks.

Not sure why there are two separate patches to md/bitmap.c though...

... and I cannot offically 'ack' the dm-crypt.c parts of this as I'm not the
    maintainer.  'md' and 'dm' are separate systems in the same directory -
    confusing, isn't it :-(

NeilBrown


> ---
>  drivers/md/bitmap.c   |   36 ++++++++++++++++++------------------
>  drivers/md/dm-crypt.c |    8 ++++----
>  2 files changed, 22 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 7878712..8659515 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -457,7 +457,7 @@ void bitmap_update_sb(struct bitmap *bitmap)
>  		return;
>  	}
>  	spin_unlock_irqrestore(&bitmap->lock, flags);
> -	sb =3D kmap_atomic(bitmap->sb_page, KM_USER0);
> +	sb =3D kmap_atomic(bitmap->sb_page);
>  	sb->events =3D cpu_to_le64(bitmap->mddev->events);
>  	if (bitmap->mddev->events < bitmap->events_cleared)
>  		/* rocking back to read-only */
> @@ -467,7 +467,7 @@ void bitmap_update_sb(struct bitmap *bitmap)
>  	/* Just in case these have been changed via sysfs: */
>  	sb->daemon_sleep =3D cpu_to_le32(bitmap->mddev->bitmap_info.daemon_slee=
p/HZ);
>  	sb->write_behind =3D cpu_to_le32(bitmap->mddev->bitmap_info.max_write_b=
ehind);
> -	kunmap_atomic(sb, KM_USER0);
> +	kunmap_atomic(sb);
>  	write_page(bitmap, bitmap->sb_page, 1);
>  }
> =20
> @@ -478,7 +478,7 @@ void bitmap_print_sb(struct bitmap *bitmap)
> =20
>  	if (!bitmap || !bitmap->sb_page)
>  		return;
> -	sb =3D kmap_atomic(bitmap->sb_page, KM_USER0);
> +	sb =3D kmap_atomic(bitmap->sb_page);
>  	printk(KERN_DEBUG "%s: bitmap file superblock:\n", bmname(bitmap));
>  	printk(KERN_DEBUG "         magic: %08x\n", le32_to_cpu(sb->magic));
>  	printk(KERN_DEBUG "       version: %d\n", le32_to_cpu(sb->version));
> @@ -497,7 +497,7 @@ void bitmap_print_sb(struct bitmap *bitmap)
>  	printk(KERN_DEBUG "     sync size: %llu KB\n",
>  			(unsigned long long)le64_to_cpu(sb->sync_size)/2);
>  	printk(KERN_DEBUG "max write behind: %d\n", le32_to_cpu(sb->write_behin=
d));
> -	kunmap_atomic(sb, KM_USER0);
> +	kunmap_atomic(sb);
>  }
> =20
>  /*
> @@ -603,7 +603,7 @@ static int bitmap_read_sb(struct bitmap *bitmap)
>  		return err;
>  	}
> =20
> -	sb =3D kmap_atomic(bitmap->sb_page, KM_USER0);
> +	sb =3D kmap_atomic(bitmap->sb_page);
> =20
>  	chunksize =3D le32_to_cpu(sb->chunksize);
>  	daemon_sleep =3D le32_to_cpu(sb->daemon_sleep) * HZ;
> @@ -664,7 +664,7 @@ success:
>  		bitmap->events_cleared =3D bitmap->mddev->events;
>  	err =3D 0;
>  out:
> -	kunmap_atomic(sb, KM_USER0);
> +	kunmap_atomic(sb);
>  	if (err)
>  		bitmap_print_sb(bitmap);
>  	return err;
> @@ -689,7 +689,7 @@ static int bitmap_mask_state(struct bitmap *bitmap, e=
num bitmap_state bits,
>  		return 0;
>  	}
>  	spin_unlock_irqrestore(&bitmap->lock, flags);
> -	sb =3D kmap_atomic(bitmap->sb_page, KM_USER0);
> +	sb =3D kmap_atomic(bitmap->sb_page);
>  	old =3D le32_to_cpu(sb->state) & bits;
>  	switch (op) {
>  	case MASK_SET:
> @@ -703,7 +703,7 @@ static int bitmap_mask_state(struct bitmap *bitmap, e=
num bitmap_state bits,
>  	default:
>  		BUG();
>  	}
> -	kunmap_atomic(sb, KM_USER0);
> +	kunmap_atomic(sb);
>  	return old;
>  }
> =20
> @@ -881,12 +881,12 @@ static void bitmap_file_set_bit(struct bitmap *bitm=
ap, sector_t block)
>  	bit =3D file_page_offset(bitmap, chunk);
> =20
>  	/* set the bit */
> -	kaddr =3D kmap_atomic(page, KM_USER0);
> +	kaddr =3D kmap_atomic(page);
>  	if (bitmap->flags & BITMAP_HOSTENDIAN)
>  		set_bit(bit, kaddr);
>  	else
>  		__set_bit_le(bit, kaddr);
> -	kunmap_atomic(kaddr, KM_USER0);
> +	kunmap_atomic(kaddr);
>  	pr_debug("set file bit %lu page %lu\n", bit, page->index);
>  	/* record page number so it gets flushed to disk when unplug occurs */
>  	set_page_attr(bitmap, page, BITMAP_PAGE_DIRTY);
> @@ -1050,10 +1050,10 @@ static int bitmap_init_from_disk(struct bitmap *b=
itmap, sector_t start)
>  				 * if bitmap is out of date, dirty the
>  				 * whole page and write it out
>  				 */
> -				paddr =3D kmap_atomic(page, KM_USER0);
> +				paddr =3D kmap_atomic(page);
>  				memset(paddr + offset, 0xff,
>  				       PAGE_SIZE - offset);
> -				kunmap_atomic(paddr, KM_USER0);
> +				kunmap_atomic(paddr);
>  				write_page(bitmap, page, 1);
> =20
>  				ret =3D -EIO;
> @@ -1061,12 +1061,12 @@ static int bitmap_init_from_disk(struct bitmap *b=
itmap, sector_t start)
>  					goto err;
>  			}
>  		}
> -		paddr =3D kmap_atomic(page, KM_USER0);
> +		paddr =3D kmap_atomic(page);
>  		if (bitmap->flags & BITMAP_HOSTENDIAN)
>  			b =3D test_bit(bit, paddr);
>  		else
>  			b =3D test_bit_le(bit, paddr);
> -		kunmap_atomic(paddr, KM_USER0);
> +		kunmap_atomic(paddr);
>  		if (b) {
>  			/* if the disk bit is set, set the memory bit */
>  			int needed =3D ((sector_t)(i+1) << (CHUNK_BLOCK_SHIFT(bitmap))
> @@ -1207,10 +1207,10 @@ void bitmap_daemon_work(struct mddev *mddev)
>  			    bitmap->mddev->bitmap_info.external =3D=3D 0) {
>  				bitmap_super_t *sb;
>  				bitmap->need_sync =3D 0;
> -				sb =3D kmap_atomic(bitmap->sb_page, KM_USER0);
> +				sb =3D kmap_atomic(bitmap->sb_page);
>  				sb->events_cleared =3D
>  					cpu_to_le64(bitmap->events_cleared);
> -				kunmap_atomic(sb, KM_USER0);
> +				kunmap_atomic(sb);
>  				write_page(bitmap, bitmap->sb_page, 1);
>  			}
>  			spin_lock_irqsave(&bitmap->lock, flags);
> @@ -1233,7 +1233,7 @@ void bitmap_daemon_work(struct mddev *mddev)
>  						  -1);
> =20
>  				/* clear the bit */
> -				paddr =3D kmap_atomic(page, KM_USER0);
> +				paddr =3D kmap_atomic(page);
>  				if (bitmap->flags & BITMAP_HOSTENDIAN)
>  					clear_bit(file_page_offset(bitmap, j),
>  						  paddr);
> @@ -1242,7 +1242,7 @@ void bitmap_daemon_work(struct mddev *mddev)
>  						file_page_offset(bitmap,
>  								 j),
>  						paddr);
> -				kunmap_atomic(paddr, KM_USER0);
> +				kunmap_atomic(paddr);
>  			} else if (*bmc <=3D 2) {
>  				*bmc =3D 1; /* maybe clear the bit next time */
>  				set_page_attr(bitmap, page, BITMAP_PAGE_PENDING);
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 8c2a000..db6b516 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -590,9 +590,9 @@ static int crypt_iv_lmk_gen(struct crypt_config *cc, =
u8 *iv,
>  	int r =3D 0;
> =20
>  	if (bio_data_dir(dmreq->ctx->bio_in) =3D=3D WRITE) {
> -		src =3D kmap_atomic(sg_page(&dmreq->sg_in), KM_USER0);
> +		src =3D kmap_atomic(sg_page(&dmreq->sg_in));
>  		r =3D crypt_iv_lmk_one(cc, iv, dmreq, src + dmreq->sg_in.offset);
> -		kunmap_atomic(src, KM_USER0);
> +		kunmap_atomic(src);
>  	} else
>  		memset(iv, 0, cc->iv_size);
> =20
> @@ -608,14 +608,14 @@ static int crypt_iv_lmk_post(struct crypt_config *c=
c, u8 *iv,
>  	if (bio_data_dir(dmreq->ctx->bio_in) =3D=3D WRITE)
>  		return 0;
> =20
> -	dst =3D kmap_atomic(sg_page(&dmreq->sg_out), KM_USER0);
> +	dst =3D kmap_atomic(sg_page(&dmreq->sg_out));
>  	r =3D crypt_iv_lmk_one(cc, iv, dmreq, dst + dmreq->sg_out.offset);
> =20
>  	/* Tweak the first block of plaintext sector */
>  	if (!r)
>  		crypto_xor(dst + dmreq->sg_out.offset, iv, cc->iv_size);
> =20
> -	kunmap_atomic(dst, KM_USER0);
> +	kunmap_atomic(dst);
>  	return r;
>  }
> =20


--Sig_/Qdl12FHP_lk.3ELq_DsDIDz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTtHR9znsnt1WYoG5AQLPsg/9GVXSJGhag+EcUSOcz43F3G3vKmNf49X1
nLlojndqgFUX0aSd/jtpnvmgaphxKJqL1H5e3IBed1IuKdubH4v5Pz2ldvnoXcbj
CIT43pR1yU0Qt2Mw6D/tCn96+ga6WYFEP8AvPBEGLF657/c0UuvazmsgG4W2bdl2
seavz6k0kRsGfLvSNZG99tZYBHua73Rar0H7dAL13lc/H4rDmAqKbnh1RQMbj5rM
e7BkwbaquQLv61+/k/jSMhwMDJm0rEHpCRAJCqZoAafec2Xp4tXyfr4Ej0VczRcx
sRBBfpgUQvhJPRKM4fBQu85ojfhGSPJoyxrVUlkj/3iQ2Rzam5dkYDTlSPDxaOZE
gdh81WGVf1klcOjP+bXdM7+VPkDwrIu39NrPNciorvz2tubzEc0T+fyl3vODws7x
5J3Tb1DcPRjny5Um49cGX5DnUQFUJaIkvYUkoLWeA6iOZBaxsZHykh/f9kxih3jW
Pj5d4gA7gzv1TjY4QkotcU2uUjXMUXLXCNJ3McmKzxFqvgRAmwIpZz/qYy2UfVmy
R/3yHEocrztmLJxUN3QU9dSOV8cqRuMRSFWhaKVi0wxGOwr4i9k6zXYqkvP4Drvz
g9PT44RBGItY89a+lXorrkc8z5iU1GBRbjAEDNvZvvmIxH7QOLTz7dDBiPHv8rzR
Ztj4zsBm2zs=
=puUx
-----END PGP SIGNATURE-----

--Sig_/Qdl12FHP_lk.3ELq_DsDIDz--
