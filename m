Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab2KIEKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 23:10:10 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56033 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2KIEKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 23:10:07 -0500
Date: Fri, 9 Nov 2012 15:09:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>
Subject: linux-next: build failure after merge of the final tree (akpm tree
 related)
Message-Id: <20121109150957.4f274fa7b3a75c9baaa1b7ff@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Nov_2012_15_09_57_+1100_5Da1.+6uGnVCVm0y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Nov_2012_15_09_57_+1100_5Da1.+6uGnVCVm0y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc64 defconfig)
failed like this:

arch/sparc/kernel/sys_sparc_64.c: In function 'arch_get_unmapped_area':
arch/sparc/kernel/sys_sparc_64.c:92:16: error: unused variable 'start_addr'=
 [-Werror=3Dunused-variable]
arch/sparc/kernel/sys_sparc_64.c: In function 'arch_get_unmapped_area_topdo=
wn':
arch/sparc/kernel/sys_sparc_64.c:194:20: error: 'do_colour_align' undeclare=
d (first use in this function)
arch/sparc/kernel/sys_sparc_64.c:194:20: note: each undeclared identifier i=
s reported only once for each function it appears in
arch/sparc/kernel/sys_sparc_64.c:194:51: error: 'shm_align_mask' undeclared=
 (first use in this function)

Caused by commit "mm: use vm_unmapped_area() on sparc64 architecture".  I
have reverted that commit for today (and the following fix patch).

arch/sparc/mm/hugetlbpage.c: In function 'hugetlb_get_unmapped_area_topdown=
':
arch/sparc/mm/hugetlbpage.c:63:25: error: unused variable 'vma' [-Werror=3D=
unused-variable]

Caused by commit "mm: use vm_unmapped_area() in hugetlbfs on sparc64
architecture".  I have reverted that commit for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__9_Nov_2012_15_09_57_+1100_5Da1.+6uGnVCVm0y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQnIIVAAoJEECxmPOUX5FEet0P/RtgpcMmr/u/2ZytHZvpmhcm
UD7JCqv/4vOeEr8CkC4HqKj05DGcWhz2k2Vpd2lu3PjFf5TmdEzKoLfRhDrrhmwu
NLAuUOxngW+VsFic1scKwzC+jBf7zBkFZIQBeq6xwvT9+0L5jvhXRJtI3ufQx6WH
f63UNCsgV4pErTaDpN2LyipIirmnuIvpGEJaMuJ8AJc6S8rGyf6/uzccEYGBhmSD
s/jaqBf8+O8xNEhG+NKaV2dQIyU4v4DbDNhq0Hgravk8qTfbj8fexKM7kheTxC55
FPNRjDNtdMvoWJXrdDgSS5kY9XzvSDq6FHikcpfZud3yVU9W1EJjJeotFInKsjlA
ndhipSMJOCJpQD/F6hqFe94Lw+ePhphmfP8a1kMQDx4nAOTuV5k8fAUb+Nktfb8n
fiT0JTM+JhTW7uBRo3wtGl2X/w/PKjpaZgY0ao3xvYbmgIaX4acTc/2pvJdM/fc7
A7Gj7Z65YMWh9/gNOmFBqxkbomPGfrfMPpEcYxtmkmfaYiKaleAceuJ7HQzkwegK
xyujb5rpN3xelxAMzMRDyNYqlLzXumVv1f9O+Cxp/HazA/zmNAnOtcO6q7FnsSui
14oRdg3+BuhDgj4A+J/goqECo6if4YToI1fK/8N6drTE7qx9c7aa2tb2BBjyhCMw
JMwOhA6BWJNJZZMhHLSp
=sixC
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Nov_2012_15_09_57_+1100_5Da1.+6uGnVCVm0y--
