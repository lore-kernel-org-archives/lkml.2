Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab1JYHof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:44:35 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:54105 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab1JYHod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:44:33 -0400
Date: Tue, 25 Oct 2011 18:44:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: linux-next: manual merge of the tip tree with the cputime tree
Message-Id: <20111025184421.5da0ec4a2551e162cfa6bd78@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Oct_2011_18_44_21_+1100_GC//guEKRNl4JbBn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Oct_2011_18_44_21_+1100_GC//guEKRNl4JbBn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
kernel/sched_stats.h between commit f6116715d1ba ("[S390] cputime: add
sparse checking and cleanup") from the cputime tree and commit
ee30a7b2fc07 ("locking, sched: Annotate thread_group_cputimer as raw")
from the tip tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/sched_stats.h
index a455e62,87f9e36..0000000
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@@ -282,9 -282,10 +282,9 @@@ static inline void account_group_user_t
  	if (!cputimer->running)
  		return;
 =20
- 	spin_lock(&cputimer->lock);
+ 	raw_spin_lock(&cputimer->lock);
 -	cputimer->cputime.utime =3D
 -		cputime_add(cputimer->cputime.utime, cputime);
 +	cputimer->cputime.utime +=3D cputime;
- 	spin_unlock(&cputimer->lock);
+ 	raw_spin_unlock(&cputimer->lock);
  }
 =20
  /**
@@@ -305,9 -306,10 +305,9 @@@ static inline void account_group_system
  	if (!cputimer->running)
  		return;
 =20
- 	spin_lock(&cputimer->lock);
+ 	raw_spin_lock(&cputimer->lock);
 -	cputimer->cputime.stime =3D
 -		cputime_add(cputimer->cputime.stime, cputime);
 +	cputimer->cputime.stime +=3D cputime;
- 	spin_unlock(&cputimer->lock);
+ 	raw_spin_unlock(&cputimer->lock);
  }
 =20
  /**

--Signature=_Tue__25_Oct_2011_18_44_21_+1100_GC//guEKRNl4JbBn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOpmjVAAoJEECxmPOUX5FEwrYP/2xuosScAkag5ChaDUCAwzY0
kTRU06/rafPFxseEj9FuF+ARMzVg0HmYm4TUs+1364pCxRxe/FmkZOkVuJWfYiWY
mNH8l1q8K48ZvBHEbv+FrL2u2yIdEbe9zjtuGOaooeiblPeRkdljXx2hHFFPFB2c
7TnqZty/O3BeaYxlL8xuZ3zTg9Fkys2Y0rGWtfAdwudxFy5l8sLjdb+oriKLr51y
QEtGnxNifZ2LOjVaKlihFVbyBHnGtfckE0xFnFs2q8wvfOuDbuaDpnzOymu3G2YJ
cxO3A30vDDsWpx8RKIZwIU2NGEPcazqyjL8IjeO7b9TS2ClNOFsvwMY7NGa5x6pH
wtNhf5EYbAMMoUBnQIG2X6IS+4J65e8JcY7jt+uw4BLyCccPoGh3/hvCcoXEDeXb
/0YR/OHEohDPWAYJxoBjMxRcWYuaDZ/52Ero1wsVfyAm/V/tYiS/48OLN9Rba2ZR
AD6gmoGK4Q7nkm9pHMOOTPS5Fiq0/IlD3cSRU1i0iJeog4+xQuaFekcMmJnpkoBS
9Ru4LFqRusaBz+Gpe6piqwM69mfldes2WClblguZoZf1bsqsOR+fFujq1en5Cx0v
CCvV/hbsm1YRVkf7YhjOVLaFs/LSDZVqkas5ppHuiU2mL87yOwrOu+Oyl3fnSKQ6
79IYlPBtUj/xa1Cr9wY0
=bvUW
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Oct_2011_18_44_21_+1100_GC//guEKRNl4JbBn--
