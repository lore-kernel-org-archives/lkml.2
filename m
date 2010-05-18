Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab0ERDhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 23:37:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54839 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab0ERDhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 23:37:20 -0400
Date: Tue, 18 May 2010 13:37:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: build failure after merge of the block tree
Message-Id: <20100518133710.8b1545dd.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__18_May_2010_13_37_10_+1000_WyGs035oBlbgt_AN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_May_2010_13_37_10_+1000_WyGs035oBlbgt_AN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

After merging the block tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

block/blk-core.c: In function 'laptop_mode_timer_fn':
block/blk-core.c:503: error: too few arguments to function 'bdi_start_write=
back'

Caused by commit e913fc825dc685a444cb4c1d0f9d32f372f59861 ("writeback:
fix WB_SYNC_NONE writeback from umount") from the block tree interacting
with commit 42bd225c0ba7c95af39293d39a950c48e7e5cb23 (""laptop-mode: Make
flushes per-device" fix") also from the block tree.  The merge
6205ed4658a0df8c2879519977bbed6853014016 should have changed the code in
block/blk-core.c that moved from mm/page-writeback.c.

Mind you, I think that the change to laptop_mode_timer_fn in commit
e913fc825dc685a444cb4c1d0f9d32f372f59861 was wrong anyway (the 0 should
have been added at the end, surely).

I have used the block tree from next-20100517 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__18_May_2010_13_37_10_+1000_WyGs035oBlbgt_AN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvyC2YACgkQjjKRsyhoI8zOZACgm+SatbD3aZxkIHqg5RCJ2kSK
/RsAn1Y/QtFB5B2AJSGTNBJ2H0BdlUD0
=sU3c
-----END PGP SIGNATURE-----

--Signature=_Tue__18_May_2010_13_37_10_+1000_WyGs035oBlbgt_AN--
