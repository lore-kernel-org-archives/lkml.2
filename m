Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750932Ab1KAFPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 01:15:18 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:52942 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab1KAFPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 01:15:13 -0400
Date: Tue, 1 Nov 2011 16:15:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.de>
Subject: linux-next: manual merge of the block tree with Linus' tree
Message-Id: <20111101161500.79aebe8d8f30162ea542a818@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_Nov_2011_16_15_00_+1100_labJD+dRz2rbPf5V"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Nov_2011_16_15_00_+1100_labJD+dRz2rbPf5V
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
drivers/md/raid10.c between commit fd01b88c75a7 ("md: remove typedefs:
mddev_t -> struct mddev") from Linus' tree and commit 5a7bbad27a41
("block: remove support for bio remapping from ->make_request") from the
block tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/md/raid10.c
index c025a82,ea5fc0b..0000000
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@@ -842,11 -830,11 +842,11 @@@ static void unfreeze_array(struct r10co
  	spin_unlock_irq(&conf->resync_lock);
  }
 =20
- static int make_request(struct mddev *mddev, struct bio * bio)
 -static void make_request(mddev_t *mddev, struct bio * bio)
++static void make_request(struct mddev *mddev, struct bio * bio)
  {
 -	conf_t *conf =3D mddev->private;
 -	mirror_info_t *mirror;
 -	r10bio_t *r10_bio;
 +	struct r10conf *conf =3D mddev->private;
 +	struct mirror_info *mirror;
 +	struct r10bio *r10_bio;
  	struct bio *read_bio;
  	int i;
  	int chunk_sects =3D conf->chunk_mask + 1;
@@@ -1176,12 -1156,11 +1174,11 @@@ retry_write
 =20
  	if (do_sync || !mddev->bitmap || !plugged)
  		md_wakeup_thread(mddev->thread);
- 	return 0;
  }
 =20
 -static void status(struct seq_file *seq, mddev_t *mddev)
 +static void status(struct seq_file *seq, struct mddev *mddev)
  {
 -	conf_t *conf =3D mddev->private;
 +	struct r10conf *conf =3D mddev->private;
  	int i;
 =20
  	if (conf->near_copies < conf->raid_disks)

--Signature=_Tue__1_Nov_2011_16_15_00_+1100_labJD+dRz2rbPf5V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOr4BUAAoJEECxmPOUX5FEu94P/25qbjPwzR+36yn5gYsDh2/F
g0d7zwI4MgxPqRoN3/VOdEQDcl5st1iDXPalkdbTisGVhZg2odVbeMbfb+RCOfa/
TDrkz0PP4KSSHHKN96g2t8bwBusWg7t7Ocyi8QcQGZlrS1T4VC6HjJrt/Szx6Epv
u/29GjCBIBdv3XZipEvXGBmBFfFruUbdM/YTO89ubuk5dA+8i8W5/vQOSrvyP3yl
01BW3rhtVDyXSy9pXbgnqUFM9qJQ77EMo3dnCZoOS8NfPQXXYuF1/VZZf6D2k5hx
3IjRpNOuaKwBMM0yDzWAawigltE73FPslCPcSAehIzX+80Z/an2VT7t2igE5Ql7Q
idIanBsREmCFlUbdnuxFQf3YC85FvKNPDIjfGBomm0fT50r2qrUT9MkkJQ4qoh0C
mkyX2LsXCrrw9qbc2klvbShpQlC6qHrybfkIzc2bOERJf5hPCZe21f6XnfE7GvPj
BoheDeBNK4RvctmOvwQ6RJ7zCeBZbkDKPZzTHaDyEyvptoilRymc+l9wskLPETrc
PficEKIDMI2Ixgwz/z+uoiFubNYyfSdBM7fOpUfS1uKAVXsX+rpYxZ94nZ3VkLmS
EBox7Hwo41xrpf6OC1uI4IoSru0n5bJy4hzBiFWApOqiHAWQqZAVZRBUWbBCAc6i
Cm6LLJWRsbG0F5p8LW7l
=cpRD
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Nov_2011_16_15_00_+1100_labJD+dRz2rbPf5V--
