Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab2IUCtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 22:49:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47209 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854Ab2IUCtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 22:49:41 -0400
Date: Fri, 21 Sep 2012 12:49:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Neil Brown <neilb@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@fusionio.com>
Subject: linux-next: manual merge of the md tree with the block tree
Message-Id: <20120921124927.2008f0556cf6c0069c1d94c8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Sep_2012_12_49_27_+1000_OZMIBoIcVItl4nO3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Sep_2012_12_49_27_+1000_OZMIBoIcVItl4nO3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Neil,

Today's linux-next merge of the md tree got a conflict in
drivers/md/raid0.c between commit 4363ac7c13a9 ("block: Implement support
for WRITE SAME") from the block tree and commit c9264cda8f11 ("md: raid 0
supports TRIM") from the md tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/md/raid0.c
index a9e4fa9,1a8e5e3..0000000
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@@ -422,7 -431,7 +431,8 @@@ static int raid0_run(struct mddev *mdde
  	if (md_check_no_bitmap(mddev))
  		return -EINVAL;
  	blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
 +	blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);
+ 	blk_queue_max_discard_sectors(mddev->queue, mddev->chunk_sectors);
 =20
  	/* if private is not null, we are here after takeover */
  	if (mddev->private =3D=3D NULL) {

--Signature=_Fri__21_Sep_2012_12_49_27_+1000_OZMIBoIcVItl4nO3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQW9W3AAoJEECxmPOUX5FE4awP/jzIyru4QdkPduSxEegAfvgR
pv9TMOh14Ly+1s/kcs4fYthvnQ+DRrnZn3cm9aHVoZJWwMHYc5V6J6BWk27iNsBv
ZbS9SBaoQq5SaFYf47dIDDbYGRi0Cc/tvcyXKmiEHc91OgV9lSgoANBhFwDHJRPF
gaE/EF2Rkg2GptZmJ0ylVUqoWvambJ6Wy/ltKu6i1lsc2s9Ch1+ElITmpgFfylB/
31oXjU/Kdp5vRFgAtzQHPzpMmQmQdUn4ZZpENNUA0MAI5oYZCKXISBQNUkbXDoI3
yrzeGlapamS9LAacG/b2a5t/6W0hzmuCX2O2D1bBJqDBLlv1gq8sxPCM8mNsczlI
UJPzviVcHQvX/wBRnnVwt9nTA9B/R6SRUTM9ewyV3LXJihS4g66kHligkZwJTSek
VHmmiDitFL5I3WLcqC6QL5eKfRxrzqHkdW7FLrfsDb27Mk7+WSE/RFA2yfl9k23w
UqaYCVxS5mCUETFqLmG8LxYjUh2I+sWo5UXd/o4wNw6iKMawG8hkFL+0ve5nW873
d94whhsuiL9/8SmiS80ORnyBf+QHxsCq6oaGVt7Sph0U4njl/zN8vrS/fksDw913
5Xbe8D//ft3dSXAIn9S4b4lcL2IXEY2tZBiPpa43YE8dOm1ZoB5do2mFbnpPvtJE
oi337wMIhBqJlwACqVoP
=eKqD
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Sep_2012_12_49_27_+1000_OZMIBoIcVItl4nO3--
