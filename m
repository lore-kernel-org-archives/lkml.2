Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab2EVFoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 01:44:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34476 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab2EVFoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 01:44:18 -0400
Date: Tue, 22 May 2012 15:44:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20120522154411.e054ecb074bfca2e633ef5b3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_May_2012_15_44_11_+1000_6Er4MniNjEboAc.6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_May_2012_15_44_11_+1000_6Er4MniNjEboAc.6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in mm/memory.c
between commit 4f74d2c8e827 ("vm: remove 'nr_accounted' calculations from
the unmap_vmas() interfaces") from Linus' tree and commit cbc91f71b51b
("uprobes/core: Decrement uprobe count before the pages are unmapped")
from the tip tree.

Following discussion between Linus and Andred, I fixed it up as below for
now.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/memory.c
index 1e77da6,84427aa..0000000
--- a/mm/memory.c
+++ b/mm/memory.c
@@@ -1307,6 -1309,12 +1309,9 @@@ static void unmap_single_vma(struct mmu
  	if (end <=3D vma->vm_start)
  		return;
 =20
+ 	if (vma->vm_file)
+ 		uprobe_munmap(vma, start, end);
+=20
 -	if (vma->vm_flags & VM_ACCOUNT)
 -		*nr_accounted +=3D (end - start) >> PAGE_SHIFT;
 -
  	if (unlikely(is_pfn_mapping(vma)))
  		untrack_pfn_vma(vma, 0, 0);
 =20

--Signature=_Tue__22_May_2012_15_44_11_+1000_6Er4MniNjEboAc.6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPuyerAAoJEECxmPOUX5FEBU0P/1Nf4Ob0YA4MJMLsK6FtdQQa
4G2wj2WxhmWFPq2igaaEc4CiluEmtkR9XdgghmgmLfV5306QmFujfqE7n3DS8An9
Uu9rHxQc3JNfr9D6t5YRCRTYyJdaB31pZyb1KkyeLLOLSu+hJnStyEzGzhp+FeSO
G+3Rs6/lAmI0QuZC8acrT/mh8SvjcPI/huW2GyGTeexKoCJDdxkdf8YxAvmZyrqy
V0CiyTzVHOUYARbvwp2Xc1KnoTzMC3SV3rRgnmos38eY05N3T5FR9/ez9eDgoHpO
M9pB9vpxhDKc9EUyjXvYxrm2z9GzVYT5VUhcn98wCkpsF4mF21ej+O6d1YWH2DxP
DGif3jzFtOp32SsWCtpOkcPkM1YBcpLYeyCn3B13C9BQzJBHcJGwe62RxuJoeSWP
QHQdlFACIVtKu9a/mJ+YY1w9nytomzj9/FIoaYTjUOwsdvEvWKzhtA5Cw5nw6VXk
gmJHy7kJyjjVA2b7Gb4EZXdC4TnFzzu5RvbVCnUjQEXXE56opDiHvkCT1jrfqiIy
SLr6pzXSCoH39LI2x59NuUHs38ew2eowOeAp4+UuEWVfIceFxdBEirzoRZzb3ac3
FSLGuCcGR3mwyJI7K4qR0pE75swTq/Vpshrc7ega/d2bm1U5KzJq3UWDJZ/6Vrco
L4OTIzElVuHEB8y6MvvR
=YsnO
-----END PGP SIGNATURE-----

--Signature=_Tue__22_May_2012_15_44_11_+1000_6Er4MniNjEboAc.6--
