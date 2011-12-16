Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986Ab1LPBuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 20:50:14 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:46751 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757710Ab1LPBuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 20:50:11 -0500
Date: Fri, 16 Dec 2011 12:50:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, majianpeng <majianpeng@gmail.com>
Subject: linux-next: build failure after merge of the block tree
Message-Id: <20111216125001.33635d34b5397292e6190b9a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__16_Dec_2011_12_50_01_+1100_Z=O9cjr_4MhogIjr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Dec_2011_12_50_01_+1100_Z=O9cjr_4MhogIjr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

After merging the block tree, today's linux-next build (x86_64
allmodconfig) failed like this:

block/cfq-iosched.c: In function 'cfq_init_queue':
block/cfq-iosched.c:3690:14: error: 'cic_index_lock' undeclared (first use =
in this function)
block/cfq-iosched.c:3691:15: error: 'cic_index_ida' undeclared (first use i=
n this function)
block/cfq-iosched.c:3691:34: error: 'struct cfq_data' has no member named '=
cic_index'

Presumably this was not build tested with CONFIG_CFQ_GROUP_IOSCHED set.

Caused by commit a73f730d013f ("block, cfq: move cfqd->cic_index to
q->id") interacting with commit 2984ff38ccf6 ("cfq-iosched: free
cic_index if blkio_alloc_blkg_stats fails").

I have used the block tree from next-20111215 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__16_Dec_2011_12_50_01_+1100_Z=O9cjr_4MhogIjr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO6qPJAAoJEECxmPOUX5FEBH8P/R4JTVvL3iOSxXeeYdUS6R5N
wVIajTEWivRJHk2OjJ8+MEgDdQfZ386vuuoCKzAKPmDWgERL6RQCCAkVfhGdeFyn
2ww+zQ8Ji4sCiv9VbsBrl31Fe5OQyORct54coo6JgcsfLVBHapqnCTcczGEIVq1t
qCtOJAhINEb+73hHEn5qP33qWhbhZitLX/kzpmEQ/LN9OZtIhTZmfBEd8gV3dGN9
vH58qVObefhDYKSziHVEVz4dkKeC2aT393bxU7xcC4zf04ptaES/MTkLFOzAig9K
128Y3f7wrB0W+mt1BcjU4V+VMV9scP3isHgavZAuXnicQQhoNafxx6gVkU/mUmBe
uaoImo/7PbUpq5hblVrrLbPBalcMr3w+5GYE/MIE9Yila4hpyfFZyP0WlCJuNGTJ
qUZIFSwvEq1AGhXeT/g1cRwHucUMsLqPmmofpRICHA2YJJsVjyM9PZ4y02ys7tKH
XDqLCuRcpEHyGGeO5k3m+c2lXnddRWg+qeYbnJgR7qsLpFcWvfKGeLHSIpcTUQPo
UuM6PrXmQ0sDfq2tKSU8iIFVl1/SALRL8N70CBgq7jygRU4sDgPkiUH3pbbRGz4h
KILwFOCS/3TxQftOV9Aw4ipoUOy7kvXLzZ43Mph73iO0OP6UngTf5vMYpcMEDUPk
lb9jzJ54lyzM4wc0Pzlg
=zQTV
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Dec_2011_12_50_01_+1100_Z=O9cjr_4MhogIjr--
