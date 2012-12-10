Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab2LJIyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:54:12 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:39400 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab2LJIyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:54:11 -0500
Date: Mon, 10 Dec 2012 19:54:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20121210195402.1042a8ea5bfb57bb758007ac@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__10_Dec_2012_19_54_02_+1100_j1wXgxCBDP_XWgcz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Dec_2012_19_54_02_+1100_j1wXgxCBDP_XWgcz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (x86_64
allmodconfig) failed like this:

mm/migrate.c: In function 'migrate_misplaced_transhuge_page_put':
mm/migrate.c:1666:2: error: incompatible type for argument 3 of 'update_mmu=
_cache_pmd'
arch/x86/include/asm/pgtable.h:792:20: note: expected 'struct pmd_t *' but =
argument is of type 'pmd_t'

Caused by commit 7f7f03ce3820 ("mm, numa: Implement migrate-on-fault lazy
NUMA strategy for regular and THP pages") from the tip tree and expose by
commit "x86: convert update_mmu_cache() and update_mmu_cache_pmd() to
functions" from the akpm tree.

I applied the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 10 Dec 2012 19:50:57 +1100
Subject: [PATCH] mm,numa: fix update_mmu_cache_pmd call

Fixes this build error:

mm/migrate.c: In function 'migrate_misplaced_transhuge_page_put':
mm/migrate.c:1666:2: error: incompatible type for argument 3 of 'update_mmu=
_cache_pmd'
arch/x86/include/asm/pgtable.h:792:20: note: expected 'struct pmd_t *' but =
argument is of type 'pmd_t'

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 5be98e5..964a8c1 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1663,7 +1663,7 @@ int migrate_misplaced_transhuge_page_put(struct mm_st=
ruct *mm,
 	page_add_new_anon_rmap(new_page, vma, haddr);
=20
 	set_pmd_at(mm, haddr, pmd, entry);
-	update_mmu_cache_pmd(vma, address, entry);
+	update_mmu_cache_pmd(vma, address, &entry);
 	page_remove_rmap(page);
 	/*
 	 * Finish the charge transaction under the page table lock to
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__10_Dec_2012_19_54_02_+1100_j1wXgxCBDP_XWgcz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQxaMqAAoJEECxmPOUX5FEENsP/1g8U+nNYRadfj6c/0wzYYbB
ec3rI7/vx1xD7GlOdvNV8KTlJE1s6tGSZWDEwSeSXqHqJj865Up21I3wHZEH4dJX
lmI6BFyxR28R4Vqj2jb0gK5p9tiMcssnxeM7ODwr/zrjCrpHs86+y3BRA1Lg0MQQ
rv9TPOafW1ms5nrGNBHemUJwBsnVR1SIi0nxF9yudYN61+kwN2vnoc0zEF0f4qWh
rCoQFRY6qonROhLBY8sBFueep7p4/k+GvrOUTn/DAZZJBVV2tZ6uU7FIz7+fO6eX
Zbad4/u4DkXEZPwq4+3E8NOP1zEiT6nTHEPVN2yC7Ue0mwCfbtCDIXmF4rZVBRtS
1etPBIWoJ/NAtRiRx2ooAGYssanIho/g/Tt1JbBYFj6OecRvcEyavVm5dOlb9dFd
ZUXpz62W/FKIDd5qTnFFWL+u4gKa1klX1oZz1DMVFU+xhYZPjslvK1KwVCB5Nrpu
NirkD4Mq+/Cd10poKo4jgtO5IL15y/A8gZiEUmDO4j9Ri124WOJ3Gk+8Q40cpCTY
+AVfpnKOVBe7NaNlExDQxmrzYOBXRkHHn47GKBvuIR21rk792rhMX/sRF/TUL/L4
ZuP41t6giT5y7epHupEebIgb5vtZp7TCRxXaOBwvOa6VrgcTdhKxHhzFZ9d/rEtU
0tdmO1F4FAVonKB1HLCI
=q/ia
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Dec_2012_19_54_02_+1100_j1wXgxCBDP_XWgcz--
