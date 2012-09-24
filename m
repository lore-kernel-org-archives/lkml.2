Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab2IXNMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 09:12:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36058 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab2IXNMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 09:12:32 -0400
Date: Mon, 24 Sep 2012 23:12:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: linux-next: manual merge of the akpm tree with the vfs tree
Message-Id: <20120924231229.766863ea8c36d3a4760f2b4a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_23_12_29_+1000_fG1nhFozhUV7D+k."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_23_12_29_+1000_fG1nhFozhUV7D+k.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/ia64/kernel/perfmon.c between commit f9bd4f3ed24d ("make get_file()
return its argument") from the vfs tree and commit "mm: kill vma flag
VM_RESERVED and mm->reserved_vm counter" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/ia64/kernel/perfmon.c
index f388b4e,2eae90e..0000000
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@@ -2306,8 -2306,8 +2306,8 @@@ pfm_smpl_buffer_alloc(struct task_struc
  	 * partially initialize the vma for the sampling buffer
  	 */
  	vma->vm_mm	     =3D mm;
 -	vma->vm_file	     =3D filp;
 +	vma->vm_file	     =3D get_file(filp);
- 	vma->vm_flags	     =3D VM_READ| VM_MAYREAD |VM_RESERVED;
+ 	vma->vm_flags	     =3D VM_READ | VM_MAYREAD | VM_DONTEXPAND | VM_DONTDUM=
P;
  	vma->vm_page_prot    =3D PAGE_READONLY; /* XXX may need to change */
 =20
  	/*

--Signature=_Mon__24_Sep_2012_23_12_29_+1000_fG1nhFozhUV7D+k.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYFw9AAoJEECxmPOUX5FE1QQP/2mX3TDzai5a8dwgAg0qqFHd
LAn7koWbHQjC4l3tMEOfAgbHOB5pfbd06H/BOldJmhkQc+UfmspOkIqDOnQewaf1
R4+vlHfhbRTrodsWtpMDfJKQmWtMwMz6jhPMDI1GTwtuJtCJGJn4sWDGkviac1sU
fbphpdMklWyRKyo/A/vCPRVx2Ksa1LxKSwDlEpI8LG5cWL0i3apW0/keooMHx3sm
WFFWWKy1Kjyl+p/iP0Tv61NVGgDVfoGEhxxWyDfqjr06AEUyIvHL3xkhZkZE4c/R
n/Uc0gNZLP1c/lXkJ6J7we7ncYsWTKDc+AKoNKQwt4YZixBOZPupTg18SwImmpbH
r8WT2ZFm5koGM7vUyFb+R4qUL3scn8LQJHJb4TStUWK80CCDvyU/PPNQGSDznd7p
0rJhQjMqN6rEMwi45/iifzHEpBw68Ujxxo1AnvVjwogao5l3/QcAl9uHADKhDvFY
S8/+u7JQvSk9EFKjHOu5vGoX7bgVBD/X4/6QQ7MAkY9laaxVmlSSJK4O+cbGK5NB
i0Dl29fp/kb4s7myh8ecSZiAvwYck4cMLC6AH3uwDRp85Kuen+E9EHc9pcGZ7N37
uoNI8lqUmeE/xlqiT4pnOAMR13k3C612VV7vBclGrT2qg5P/5YENBDoCu8u2tKt7
OocM6CznfpKbuPvk6HvJ
=VpZD
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_23_12_29_+1000_fG1nhFozhUV7D+k.--
