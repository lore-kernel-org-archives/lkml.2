Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab2KLD42 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 22:56:28 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:41141 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2KLD40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 22:56:26 -0500
Date: Mon, 12 Nov 2012 10:43:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michel Lespinasse <walken@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [next:akpm 157/313] arch/tile/mm/hugetlbpage.c:256:20: error:
 'mm' undeclared
Message-Id: <20121112104350.f173bba176ed68e27f9df564@canb.auug.org.au>
In-Reply-To: <20121109062249.GB7022@google.com>
References: <509c99fa.8Yp/oQzMiknhbdrT%fengguang.wu@intel.com>
	<20121109062249.GB7022@google.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__12_Nov_2012_10_43_50_+1100_FQI+uY30gCOcZgyS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__12_Nov_2012_10_43_50_+1100_FQI+uY30gCOcZgyS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 8 Nov 2012 22:22:49 -0800 Michel Lespinasse <walken@google.com> wro=
te:
>
> commit 86234092170b43771c3f6257cb320ff6e2c10c52
> Author: Michel Lespinasse <walken@google.com>
> Date:   Thu Nov 8 22:13:58 2012 -0800
>=20
>     fix mm: use vm_unmapped_area() in hugetlbfs on tile architecture
>=20
> diff --git a/arch/tile/mm/hugetlbpage.c b/arch/tile/mm/hugetlbpage.c
> index 6f74cce053e1..650ccff8378c 100644
> --- a/arch/tile/mm/hugetlbpage.c
> +++ b/arch/tile/mm/hugetlbpage.c
> @@ -253,7 +253,7 @@ static unsigned long hugetlb_get_unmapped_area_topdow=
n(struct file *file,
>  	info.flags =3D VM_UNMAPPED_AREA_TOPDOWN;
>  	info.length =3D len;
>  	info.low_limit =3D PAGE_SIZE;
> -	info.high_limit =3D mm->mmap_base;
> +	info.high_limit =3D current->mm->mmap_base;
>  	info.align_mask =3D PAGE_MASK & ~huge_page_mask(h);
>  	info.align_offset =3D 0;
>  	addr =3D vm_unmapped_area(&info);

Added to the akpm tree today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__12_Nov_2012_10_43_50_+1100_FQI+uY30gCOcZgyS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQoDg2AAoJEECxmPOUX5FEu88P/26FQ4XrZYnWIqCCQlXiPhEB
hEVnoehvHl0dAPbwQoA2iGNbWOp4AmEwn9TllWIaVDZTbNN2FP0ps7Agq065TkYf
ni6mhjn685e1oOTI/VMwfLUtcXLi0W7l5/h1TrlH0EZECRdHb2wboETjSSMpVdrM
trhl+ev+5RWQHi0UDljj3MFJGAKRXwM84QQS9nt3nHLK8vuTOf0yc1wHlm3eYBC7
X/YtzQoyNc9nrV+t12EW6Kf9oUgi6XOX5YinFC8KhcPP+4mzJbocVdCKqexQuvoz
gd3a/E0i3AFYG88XmOhXbQqVejb4TD7MiS+i+MD+614AZUFvIJ+2vDhHbKczgIw5
gY53Q5oo7aRQtlCKW0Rj8+ADZkV2KoP+UM5/Rc9LxiLjfdVk5ewd3i51bjrVZLN/
8ElRlGnd0WxKKS/VESfqQZPcpSFjWsS/c0goEEKLV6SB1c5+4SI4vL35CtzKG6em
tMY92MI0L5u/Dx6uLtEAi7vs4nO3t2mJODsZVKsEDZIag5fle7RkyrBEWlLkKKkr
kgI/qSwNxhGC+1qcmrWU9GOXP68eoI7GsgCfAQMAD2/YaGmMCMhQfqNFecAseGwn
JMlxU9W8cSMUjAxSEDYo3U1V1tBIQClJIayDH1GQR2YyqnTzK7naxtMbcWQVtoDO
XrX1QCzbRhKtPMTPuM1J
=FPN8
-----END PGP SIGNATURE-----

--Signature=_Mon__12_Nov_2012_10_43_50_+1100_FQI+uY30gCOcZgyS--
