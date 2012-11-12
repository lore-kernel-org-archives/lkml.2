Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab2KLD4d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 22:56:33 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48900 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2KLD43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 22:56:29 -0500
Date: Mon, 12 Nov 2012 11:00:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>
Subject: Re: linux-next: build failure after merge of the final tree (akpm
 tree related)
Message-Id: <20121112110005.92ef4eb2561c484b2751937d@canb.auug.org.au>
In-Reply-To: <20121108200154.03e507ed.akpm@linux-foundation.org>
References: <20121109145832.dfdc4985b490290f5e4f185c@canb.auug.org.au>
	<20121108200154.03e507ed.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__12_Nov_2012_11_00_05_+1100__GlVUdJFs0PdgQys"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__12_Nov_2012_11_00_05_+1100__GlVUdJFs0PdgQys
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 8 Nov 2012 20:01:54 -0800 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> oop, I fixed that but forgot to commit the changes, sorry.
>=20
> 	s/mm/current->mm/

I have applied this to the akpm tree today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 12 Nov 2012 10:51:18 +1100
Subject: [PATCH] mm: fix for use vm_unmapped_area() in hugetlbfs on i386 ar=
chitecture

Fix-from: Adnrew Morton <akpm@linux-foundation.org>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/mm/hugetlbpage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
index c00c4a4..ae1aa71 100644
--- a/arch/x86/mm/hugetlbpage.c
+++ b/arch/x86/mm/hugetlbpage.c
@@ -296,7 +296,7 @@ static unsigned long hugetlb_get_unmapped_area_topdown(=
struct file *file,
 	info.flags =3D VM_UNMAPPED_AREA_TOPDOWN;
 	info.length =3D len;
 	info.low_limit =3D PAGE_SIZE;
-	info.high_limit =3D mm->mmap_base;
+	info.high_limit =3D current->mm->mmap_base;
 	info.align_mask =3D PAGE_MASK & ~huge_page_mask(h);
 	info.align_offset =3D 0;
 	addr =3D vm_unmapped_area(&info);
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__12_Nov_2012_11_00_05_+1100__GlVUdJFs0PdgQys
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQoDwFAAoJEECxmPOUX5FEzDcP/i+iTBbN7DfaHrg7H2Ef0lDb
kvfDzViF3qb9LBUT6PAYg0EFdi+1R4mNvOyO5rLxsV2EziJqLRINywK02Zdd9v1x
CM2R0iYMAcLKT8qEypPoN5kLULlqov0styn1Dn3+OFKx7GzsZ8WOM34zdRlGhgsQ
7cVcWFP7d4Rdh6k/4Rgwb7XwTKzLA2rxoBK8Ew5Z6CkGHnFmSrOD+elTXCwzDqRk
zOOJzpBw7vTw/h/lkb7eBk8hz10g+b3PYQXgcNcIm7NaDWQr5FSfvVAcV7UQAzFe
O5vwHYGFT9jSIcfbSFmLTsaIBQafGW8CjUv51McsJge+3NaHHnH1pp4zM52h+cbT
rPwRp62qe1QAYY3TysutzvR1iZzq2LjFCwjNmoFg4xLau8msoGO0uo0mmVpfm4yH
lkhBA3E4dcOxUYwA5+MCwzvg3F67kdIaHRON3koq3UEmSXuSmXcCTsVjAj04fQuM
anfxPhBSmLB/61axN7tZgYhvO819rHRApPrddk5MznUxpelVbv6Dzly3JKho444G
8Tq7UnSUXwiTkovn5HiZnpdKkb55NfGE1BeuUj2F8oE6GY0w/Y55OJfReJrHY90H
Qkrnp2M1YHTqi3pbAMto4KRWFCS4bfn8xxjtI4d0YZCvqrTBBbRnXvUdlQowStIP
M9NdF37/vT0G9LjWYQEO
=Z0Fk
-----END PGP SIGNATURE-----

--Signature=_Mon__12_Nov_2012_11_00_05_+1100__GlVUdJFs0PdgQys--
