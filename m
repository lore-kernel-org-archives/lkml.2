Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab2JRGWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 02:22:17 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52415 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab2JRGWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 02:22:15 -0400
Date: Thu, 18 Oct 2012 17:22:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: linux-next: build failure after merge of the final tree (tip/s390
 trees related)
Message-Id: <20121018172201.b81dcc8fe40868256f532364@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__18_Oct_2012_17_22_01_+1100_dyWMS8fv./DAH75Z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__18_Oct_2012_17_22_01_+1100_dyWMS8fv./DAH75Z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (s390 allyesconfig)
failed like this:

mm/huge_memory.c:1424:2: error: implicit declaration of function 'pmd_pgpro=
t' [-Werror=3Dimplicit-function-declaration]
mm/huge_memory.c:1424:7: error: incompatible types when assigning to type '=
pgprot_t' from type 'int'

(see http://kisskb.ellerman.id.au/kisskb/buildresult/7383823/)

Caused by commit 35d3d3427314 ("s390/thp: select
HAVE_ARCH_TRANSPARENT_HUGEPAGE") from the s390 tree interacting with
commit 93c9d633bd9e ("mm/thp: Preserve pgprot across huge page split")
from the tip tree.

N.B. Mips also selects HAVE_ARCH_TRANSPARENT_HUGEPAGE as of commit
e21a828a1bba ("MIPS: Transparent Huge Pages support") from the mips tree
and so will be broken in some configs now as well.

Anyone have suggested merge fix patches I can apply?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__18_Oct_2012_17_22_01_+1100_dyWMS8fv./DAH75Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQf6AJAAoJEECxmPOUX5FEJfYP/R1P5W8BdqzX/JJgvRraTF80
+3TTMcj+fXREJeBEr3iKIH/L16bO6lIcYE5qhvo1ow3o9gCU3n3tzy+YP3Oe1+gw
WW+oMej50aF7p2ejYWJiX//L6ZLu0oXu3A9mg7UtNtbUUAESrAEILs5/GyrSib4A
ay4qWCqQxBLf0EQLh55I/Q/LZuLAuB/GYh5oZiX4y07ODFxma58lKnYrbqBFmXfb
a1LhlCyWlKO0KJAHHrBPzToM+Vmbexh5P5VuH4hjSiSEaZxQ/Yo2tj8zchK3XnLr
Qze/6aBIKkbnthvwoBhd6dWkFxSfiQkx7jSRmtJUg261WQN9idtCBlrfwhAf0RFL
LTXHMnTQJlmlkm0T9z21xHm6rgQ8Vug0Ep34imhJ3YsTPmnr61pyzUCdrBBgeiaJ
WEYD4in/OUOjcJ5MuVLhlfdqmH1wHfZ20X0ftmqH4XnYK1Y6+0Cyyn3knHaDSKaV
FLwkPsynbPPlcIoVjE3EYha9epc/JI/gG7aDq2hAv81orzvcF8amuxFVoHCG8f78
F3JY7155wdgbdvFUJq7U7UemINcLGqVQPvjpZfvNi019PddnQ0jK9YypUhaqLPD7
qzpfVzO4cGOfLF3Fwt/kZ2Ik5F6k8KIgk5WsEeNRXPNhOHnhAIPSa4zhd7J/JGoC
Tlmh1qkUUASi9Afhdjo8
=4DdM
-----END PGP SIGNATURE-----

--Signature=_Thu__18_Oct_2012_17_22_01_+1100_dyWMS8fv./DAH75Z--
