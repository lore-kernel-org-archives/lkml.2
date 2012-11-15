Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992696Ab2KOGcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 01:32:14 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45244 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992602Ab2KOGcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 01:32:12 -0500
Date: Thu, 15 Nov 2012 17:32:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20121115173207.00a48446007cd99735d4e592@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Nov_2012_17_32_07_+1100_tEo9lo7S0wcWZH.a"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Nov_2012_17_32_07_+1100_tEo9lo7S0wcWZH.a
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in mm/mprotect.c
between commit a9463d90124a ("mm: Count the number of pages affected in
change_protection()") from the tip tree and commit "thp: change
split_huge_page_pmd() interface" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/mprotect.c
index 6ff2d5e,cbafe4b..0000000
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@@ -89,11 -83,9 +89,11 @@@ static inline unsigned long change_pmd_
  		next =3D pmd_addr_end(addr, end);
  		if (pmd_trans_huge(*pmd)) {
  			if (next - addr !=3D HPAGE_PMD_SIZE)
- 				split_huge_page_pmd(vma->vm_mm, pmd);
+ 				split_huge_page_pmd(vma, addr, pmd);
 -			else if (change_huge_pmd(vma, pmd, addr, newprot))
 +			else if (change_huge_pmd(vma, pmd, addr, newprot)) {
 +				pages +=3D HPAGE_PMD_NR;
  				continue;
 +			}
  			/* fall through */
  		}
  		if (pmd_none_or_clear_bad(pmd))

--Signature=_Thu__15_Nov_2012_17_32_07_+1100_tEo9lo7S0wcWZH.a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQpIxnAAoJEECxmPOUX5FE2tIP/1K0Pic0N3Sn/uAbOoTQ8Paj
jt9k77IqopclSMr0W9XjVm8AHIhWFwSMzXUmhhG8Ssxiul/MnJ//I2Q9feEkggNR
Jb2M3wr2bvDCuortI4Tnvi+wCX3l6WaV9hrG8SEii7DgnG3Fzd8L7ntkOpIEicJa
pWfuZnKSdYQwsC5Cowdr6wI+np3oD1ekBmIOlXystiEtXYr1uT8qV+8e2d9wvCnM
u31zkr1Y/bO4AN3Z8z/UiQi/wwLx70Nef/TpR2FD3QadNgNDZQP1jH1i4D456dG7
tU2Q6m+nH/dj7R3YXplc6JCu9Uk0wBwgDGHtItmdpsg2096Af9e/sxtEGLXzLy4g
ZGhJVdogY7sEPXkCh9BS6gQTTONP87Kig5fabqeFbpZXRR+WuDzjzfXTUE6LlR4P
w/DVTsUWBPf0Ydi1kSPDf+47ocjA5U6kOeYe6UI/A/9wgzxqPum58IvRoBT3qE84
fgAZMB5sk3uiY1akjn0RrRVR9kZPfQEzH+D0iIhg8dfbwCyKll7thzwtpDD9JJqP
HG9slhv+pxBvDU2dPGldyyX6Q+EruTvA8zuE90+f5ZpshTZunwShI5eeDkuPCzBP
QcMhlmm1AIwCo0NsRnJDwmhj+n0pAdzBDJLgrQOSZYHIeoavfxM8DkegR5i8UCuR
Me2ZOVhWXMdD9o5NdmU9
=wlC1
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Nov_2012_17_32_07_+1100_tEo9lo7S0wcWZH.a--
