Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab2KLD4z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 22:56:55 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46065 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab2KLD41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 22:56:27 -0500
Date: Mon, 12 Nov 2012 10:49:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michel Lespinasse <walken@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>
Subject: Re: linux-next: build warning after merge of the final tree (akpm
 tree related)
Message-Id: <20121112104946.7b32bfa5724398b6f0363567@canb.auug.org.au>
In-Reply-To: <20121109043047.GA17999@google.com>
References: <20121109151903.19728e9a7a8fe9e509bb523e@canb.auug.org.au>
	<20121109043047.GA17999@google.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__12_Nov_2012_10_49_46_+1100_sL8o5H1fobsl2.ST"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__12_Nov_2012_10_49_46_+1100_sL8o5H1fobsl2.ST
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michel,

On Thu, 8 Nov 2012 20:30:47 -0800 Michel Lespinasse <walken@google.com> wro=
te:
>
> commit 1c98949798ce7a1d4a910775623e1830cf88a92c
> Author: Michel Lespinasse <walken@google.com>
> Date:   Thu Nov 8 20:26:34 2012 -0800
>=20
>     fix mm: use vm_unmapped_area() on sparc32 architecture
>=20
> diff --git a/arch/sparc/kernel/sys_sparc_32.c b/arch/sparc/kernel/sys_spa=
rc_32.c
> index a59bc637f9af..a20b5ab4c701 100644
> --- a/arch/sparc/kernel/sys_sparc_32.c
> +++ b/arch/sparc/kernel/sys_sparc_32.c
> @@ -38,7 +38,6 @@ asmlinkage unsigned long sys_getpagesize(void)
> =20
>  unsigned long arch_get_unmapped_area(struct file *filp, unsigned long ad=
dr, unsigned long len, unsigned long pgoff, unsigned long flags)
>  {
> -	struct vm_area_struct * vmm;
>  	struct vm_unmapped_area_info info;
> =20
>  	if (flags & MAP_FIXED) {
>=20
> commit aa96ebbc9ec664ddafc841f7631c4a092b10c0d8
> Author: Michel Lespinasse <walken@google.com>
> Date:   Thu Nov 8 20:25:48 2012 -0800
>=20
>     fix mm: use vm_unmapped_area() in hugetlbfs on sparc64 architecture
>=20
> diff --git a/arch/sparc/mm/hugetlbpage.c b/arch/sparc/mm/hugetlbpage.c
> index 42e5dba6cb26..d2b59441ebdd 100644
> --- a/arch/sparc/mm/hugetlbpage.c
> +++ b/arch/sparc/mm/hugetlbpage.c
> @@ -60,7 +60,6 @@ hugetlb_get_unmapped_area_topdown(struct file *filp, co=
nst unsigned long addr0,
>  				  const unsigned long pgoff,
>  				  const unsigned long flags)
>  {
> -	struct vm_area_struct *vma;
>  	struct mm_struct *mm =3D current->mm;
>  	unsigned long addr =3D addr0;
>  	struct vm_unmapped_area_info info;
>=20
> commit ff4dd9742ce0a5f7c703013e70eeb84b845c8fa2
> Author: Michel Lespinasse <walken@google.com>
> Date:   Thu Nov 8 20:24:53 2012 -0800
>=20
>     mm-use-vm_unmapped_area-on-sparc64-architecture-fix2
>=20
> diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_spa=
rc_64.c
> index 2a5d61587ca2..a836ee967ecb 100644
> --- a/arch/sparc/kernel/sys_sparc_64.c
> +++ b/arch/sparc/kernel/sys_sparc_64.c
> @@ -89,7 +89,6 @@ unsigned long arch_get_unmapped_area(struct file *filp,=
 unsigned long addr, unsi
>  	struct mm_struct *mm =3D current->mm;
>  	struct vm_area_struct * vma;
>  	unsigned long task_size =3D TASK_SIZE;
> -	unsigned long start_addr;
>  	int do_color_align;
>  	struct vm_unmapped_area_info info;
> =20
> @@ -191,7 +190,7 @@ arch_get_unmapped_area_topdown(struct file *filp, con=
st unsigned long addr0,
>  	info.length =3D len;
>  	info.low_limit =3D PAGE_SIZE;
>  	info.high_limit =3D mm->mmap_base;
> -	info.align_mask =3D do_colour_align ? (PAGE_MASK & shm_align_mask) : 0;
> +	info.align_mask =3D do_color_align ? (PAGE_MASK & (SHMLBA - 1)) : 0;
>  	info.align_offset =3D pgoff << PAGE_SHIFT;
>  	addr =3D vm_unmapped_area(&info);
> =20
>=20
> commit ed558f3723a4ac2fb71d6c8fc70116994af6e61d
> Author: Michel Lespinasse <walken@google.com>
> Date:   Thu Nov 8 20:22:36 2012 -0800
>=20
>     mm-use-vm_unmapped_area-on-arm-architecture-fix2
>=20
> diff --git a/arch/arm/mm/mmap.c b/arch/arm/mm/mmap.c
> index f4fec6d43d50..10062ceadd1c 100644
> --- a/arch/arm/mm/mmap.c
> +++ b/arch/arm/mm/mmap.c
> @@ -57,7 +57,6 @@ arch_get_unmapped_area(struct file *filp, unsigned long=
 addr,
>  {
>  	struct mm_struct *mm =3D current->mm;
>  	struct vm_area_struct *vma;
> -	unsigned long start_addr;
>  	int do_align =3D 0;
>  	int aliasing =3D cache_is_vipt_aliasing();
>  	struct vm_unmapped_area_info info;
>=20

All added to the akpm tree today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__12_Nov_2012_10_49_46_+1100_sL8o5H1fobsl2.ST
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQoDmaAAoJEECxmPOUX5FEAzcP/3KBZrTHVaHOtlVDRw38tBYn
8hp0jIJv5827yhmVt3WeXdhbng0lqUU7Glg0N5Y0ib+abxNsXVNp9KEjuNtTDFZB
VEWULHBOzFKSx//VmMn2lv7DHWviNAcMvWvrxVuteA25bqzSjdsWdnGhYXj0l0WJ
NcVsPG6QgCuCk8xdjk/3yXOvju4erZoA+wPjisaTrzGqq53mabdKzi50mSrJbmlh
MFokXubatPM6O0WczBZJmUyfPnScRXElLQvC4PDKjdjMuUVIBf0wqaY4FNmxOVUL
rFP9dmOQdpu08vCVwixZ2y7poIvmRkOUQVR1+ydz32PSBvI+OAFCO2Qyps4HPnwp
fOgy1QRWmtifgdxjEeU+wnw5iJh7H7QaPCfKmOI9uoGdjSXAyELSJoqjwQmXQLvc
sFq/Znch6I/m7ARvHtsp7SEpumaXEO5csC8FptGNT4EdAGjD+lp7otcLlGAjl92B
HOg83fxyLZWljcP54pmj93cBUciIte070bcDU3ZsNg9la2inyIOtH6kjlolfitVy
axIFpDLExEkB89w2kXvb77quofxI4dT0QWaaYyg3rWpDOn26EfQvdYehW97MVtjK
Ri9PLBXlHsmQ8hzdSIw4MUIL6tWhuvZXnFGZdYYCe2AJ/P9qYFo2mJjA3BRiwg2w
JQ8R4rLGA60RznJcYTtN
=igC6
-----END PGP SIGNATURE-----

--Signature=_Mon__12_Nov_2012_10_49_46_+1100_sL8o5H1fobsl2.ST--
