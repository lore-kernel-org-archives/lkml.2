Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab1CNFTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 01:19:33 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39135 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab1CNFTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 01:19:30 -0400
Date: Mon, 14 Mar 2011 16:19:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jarkko Lavinen <jarkko.lavinen@nokia.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: linux-next: build failure after merge of the block tree
Message-Id: <20110314161919.15e6d983.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__14_Mar_2011_16_19_19_+1100_pi37OvzeRJPvB/Ve"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Mar_2011_16_19_19_+1100_pi37OvzeRJPvB/Ve
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

After merging the block tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/mtd/mtd_blkdevs.c: In function 'mtd_blktrans_cease_background':
drivers/mtd/mtd_blkdevs.c:127: error: implicit declaration of function 'elv=
_queue_empty'

Caused by commit 7eaceaccab5f ("block: remove per-queue plugging")
interacting with commit c7519dbf6f4b ("mtd_blkdevs: Add background
processing support") from the mtd tree.

I have no idea how to fix this up, so I have reverted the above commit
from them mtd tree (along with commits a32159024620 "mtd: Add mtdswap
block driver" and 89d8d32060de "mtd: fix printf format warnings, mostly
lack of %zd for size_t, in mtdswap" that depend on it).

Jens, maybe you could advise the mtd guys.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__14_Mar_2011_16_19_19_+1100_pi37OvzeRJPvB/Ve
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNfaVXAAoJEDMEi1NhKgbscBcH/i7m9rmFclEsha93WvWIh+Ym
JSOpsavdTE76gYEqN6ENe5AOSB2xeAtOShXAW3qUsCx/udes0wnUu8C8mGnXGANq
G102oDCr66chKKVsVDd5wl1eioi+/Q2YbfhNQlFRqwgro3nDAwesaC2PxgHkcOP7
0hk5FKW4iNe/mR/84rcaeL9xkut4yckhslhE+BVEv2J9u+AyuvigwjB1rcW2sUWP
je0jr3fxCJakr6f56XaXkiytf2WEdLZrmiS2ZZEpKhBulkWM67vRzipD3ehlUusn
KX2APnOwgyRvyIocuh2hQ+s9CsJFqQg7b0xReYWTXatwLG5T5j+R0pUCF/B/OBI=
=ksrx
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Mar_2011_16_19_19_+1100_pi37OvzeRJPvB/Ve--
