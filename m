Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab1AOCKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 21:10:37 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:56210 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab1AOCKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 21:10:35 -0500
Date: Sat, 15 Jan 2011 13:10:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20110115131027.2c07ccb0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__15_Jan_2011_13_10_27_+1100_hNSpGVEiXVydVZiM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__15_Jan_2011_13_10_27_+1100_hNSpGVEiXVydVZiM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc32 defconfig)
failed like this:

In file included from arch/sparc/include/asm/pgtable_32.h:455,
                 from arch/sparc/include/asm/pgtable.h:6,
                 from include/linux/mm.h:41,
                 from arch/sparc/kernel/process_32.c:17:
include/asm-generic/pgtable.h: In function 'pmdp_get_and_clear':
include/asm-generic/pgtable.h:96: error: implicit declaration of function '=
__pmd'
include/asm-generic/pgtable.h:96: error: incompatible types when returning =
type 'int' but 'pmd_t' was expected

and *lots* more.

Caused by commit e2cda322648122dc400c85ada80eaddbc612ef6a ("thp: add pmd
mangling generic functions").  This has already been reported broken in
other architectures as well.

I have just left it for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__15_Jan_2011_13_10_27_+1100_hNSpGVEiXVydVZiM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNMQITAAoJEDMEi1NhKgbsz3YH/AzT7jgf6SrD6WR1dYSbXcuO
CqntKj+wGZstEVqsW51IP/5DdcUpx1kBSzN+KoPA1bCZUH+KxRDEeVYU/bCzz7NX
zXaiNq7XFJhi5I1dqeBzD9eXEcJtvDHPcS7jYLEx97fRGLQfhM+J9yO36IpIPQNX
bsmVxG3jvimXfjy5LWXe/M8AQvFMIilFYQlWvTgTMRUm6xth4K6IRIg9PXMNV/2z
SgAHDmM489ujw9ZTaxdAbfLhnquyoSMppaKCLEUiXazNxf/O5zI2OoAFX8PdqHRT
Pz4NKrLU2siNKxLe+wn6ETC1qgtjwWadHMStDAyQphJpA5DHMG7tjkYywNY/UNU=
=wzLi
-----END PGP SIGNATURE-----

--Signature=_Sat__15_Jan_2011_13_10_27_+1100_hNSpGVEiXVydVZiM--
