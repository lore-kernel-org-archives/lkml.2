Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab2LJI37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:29:59 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59981 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab2LJI35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:29:57 -0500
Date: Mon, 10 Dec 2012 19:29:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20121210192954.8f7f590fd44009ab6ee96947@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__10_Dec_2012_19_29_54_+1100_C/F5Tk2FRzjeIJHQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Dec_2012_19_29_54_+1100_C/F5Tk2FRzjeIJHQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in mm/mprotect.c
between commit  ("2083d67027ad") from the tip tree and commit "thp:
change split_huge_page_pmd() interface" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/mprotect.c
index b5be3f1,d74a6fb..0000000
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@@ -126,8 -89,8 +126,8 @@@ static inline unsigned long change_pmd_
  		next =3D pmd_addr_end(addr, end);
  		if (pmd_trans_huge(*pmd)) {
  			if (next - addr !=3D HPAGE_PMD_SIZE)
- 				split_huge_page_pmd(vma->vm_mm, pmd);
+ 				split_huge_page_pmd(vma, addr, pmd);
 -			else if (change_huge_pmd(vma, pmd, addr, newprot)) {
 +			else if (change_huge_pmd(vma, pmd, addr, newprot, prot_numa)) {
  				pages +=3D HPAGE_PMD_NR;
  				continue;
  			}

--Signature=_Mon__10_Dec_2012_19_29_54_+1100_C/F5Tk2FRzjeIJHQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQxZ2CAAoJEECxmPOUX5FEIKYP/isJKTlKNY1rHG4zAcPVtyl/
FCXlnWonsr8uOGcgL97mLi1iY7pEXe+2pusorllH+8OC/piUK2cQvuRimorPVNHS
cbELeahnVpuMagYBkdlmEEAar0xuVuEh9m457k8KEUNBu7OsyJ7faPjzusRM98zB
UiC1Ca92vTI7FOJY6SApTSL6Ds++IH4qTS3IGs/jxQWj1yLreqMwBM0uZbTydw3M
BzQzI7qGrxUw5CpDY3ssCSb4YjhCFGpXUgVsYKgrhMkTfFgkZIMmsH59EloaiQnX
qAlKUmLWV8p0yEibJcel8lQdJmQPIzNuYBE1KVSXQR0gxn07o8tdA3B08SoGMqLu
hcO86Xn9xMyRhBxY0K0vWl1B8kP2Wcf2KlNRrtupuUfBgqv1tsCcWUzNdsF2zIK2
SkWd+2YqPWPYEuko9i2LfAufasoQGIuNk1lEsC3AoP+T8F1IUe9bq8W3GG6DQNRw
G9DVlpfLVqbiaG7AjH8NKl2t76DF1vQi5KFaZTwJaRMRSQIpLkniAYc6KLtHJtJ/
HSWWPX/Z9S03uVQmIryg1Qh1pqq1vrTnLZ0xa4HPqoeWzteSzheqjY+YfassltIt
8YOFGXMoMOg+v7gk9swH6cNVQFYL5OJhpxP193WlXbzcSe6bez+pG0ZyVpVbF+Dl
VJuLWLk3vsxSjppz8bPJ
=93eZ
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Dec_2012_19_29_54_+1100_C/F5Tk2FRzjeIJHQ--
