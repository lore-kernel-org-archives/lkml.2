Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab1JDGO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 02:14:26 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:59124 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab1JDGOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 02:14:24 -0400
Date: Tue, 4 Oct 2011 17:14:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Jerome Marchand <jmarchan@redhat.com>
Subject: linux-next: manual merge of the staging tree with the block tree
Message-Id: <20111004171415.db52e4eb5c913afeba0a3bee@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Oct_2011_17_14_15_+1100_Klqg0K1B1gETGnQ="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Oct_2011_17_14_15_+1100_Klqg0K1B1gETGnQ=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/zram/zram_drv.c between commit 5a7bbad27a41 ("block:
remove support for bio remapping from ->make_request") from the block
tree and commit 0900beae178a ("staging: zram: fix zram locking") from the
staging tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/zram/zram_drv.c
index 02589ca,b9926ee..0000000
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@@ -572,9 -573,18 +573,17 @@@ static void zram_make_request(struct re
  	}
 =20
  	__zram_make_request(zram, bio, bio_data_dir(bio));
+ 	up_read(&zram->init_lock);
+=20
 -	return 0;
++	return;
+=20
+ error_unlock:
+ 	up_read(&zram->init_lock);
+ error:
+ 	bio_io_error(bio);
 -	return 0;
  }
 =20
- void zram_reset_device(struct zram *zram)
+ void __zram_reset_device(struct zram *zram)
  {
  	size_t index;
 =20

--Signature=_Tue__4_Oct_2011_17_14_15_+1100_Klqg0K1B1gETGnQ=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOiqQ3AAoJEECxmPOUX5FEukwP/R8Rjn74C8CWGsv0FPVe7uJ0
pfzwpfaQl6xSvBZA7ZF+m6HLsfw/98DE8ffu6tnq+H1aa/C6+vkH4Sxe7/pHVrGc
9yfuS0TCTpTxTmBZ74J7TcZfzeild/IQ6ZhsRfDRYS0r0F6tWf4A7Q6hrvotSAey
DTIBDPYqnTpC+SUp/WS9i/cuHw21ZnEI51ldoBjSq7xB4PAKiCCNW8U2xEZOvxBu
PzoMX7lHCTj2BMhdauuO63PhywcWQlwX29tyjsgHJP1yFJWTv75zgRrX4k5hXPoM
9s4dr/zpzZZxHk77Pb3Qht2Ub/uNfnkqfZz85sn76mIQyQRaHBBJKCMhnlts+xNL
QY8PNQ91OaHLLuZD4bhN246Wc9VoIehHXfrFH3HxmjTMj6eV6TH4a6wJ+0EStr4N
86RNFNEs6B/9xg0tlQjNLQkZk8xuZhQLqMH/G5PtvV2u/fKifJTEvNFBW3kO8BKm
FESCMkFw9p9w0uUxO9HvBSr02eWQpojclmTa0pY8G3c9WeFx0UUcMs3ew73UrWO7
e9uZuvdCjZ3QrXy2OF2Ar57sPRpcfmRA4yyumdx1cEY8U7+qgkQpj53IvQMY8Dhq
BLU6c7uQxh/i1hDlb229SZgii13lxUgojzagYp5JWu4IQcqMIE8cBtTn+QXn6i5J
w/+hLTiGwGCzYXqi/C0h
=og2j
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Oct_2011_17_14_15_+1100_Klqg0K1B1gETGnQ=--
