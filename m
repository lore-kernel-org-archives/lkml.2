Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab2K1Ahz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 19:37:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46735 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668Ab2K1Ahy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 19:37:54 -0500
Date: Wed, 28 Nov 2012 11:37:40 +1100
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Torsten Kaiser <just.for.lkml@googlemail.com>,
        Peter Maloney <peter.maloney@brockmann-consult.de>
Subject: [PULL REQUEST] one bugfix for md in 3.7-rc
Message-ID: <20121128113740.71bc0927@notabene.brown>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/mAEfAr9c3k.a_ceNLlUU=zJ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/mAEfAr9c3k.a_ceNLlUU=zJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Linus,
 another md bugfix ... and it isn't even Friday!

Thanks,
NeilBrown


The following changes since commit 884162df2aadd7414bef4935e1a54976fd4e3988:

  md/raid10: decrement correct pending counter when writing to replacement.=
 (2012-11-22 15:12:42 +1100)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md-3.7-fixes

for you to fetch changes up to 874807a83139abc094f939e93623c5623573d543:

  md/raid1{,0}: fix deadlock in bitmap_unplug. (2012-11-27 12:14:40 +1100)

----------------------------------------------------------------
Single bugfix for raid1/raid10.

Fixes a recently introduced deadlock.

----------------------------------------------------------------
NeilBrown (1):
      md/raid1{,0}: fix deadlock in bitmap_unplug.

 drivers/md/raid1.c  | 2 +-
 drivers/md/raid10.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 636bae0..a0f7309 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -963,7 +963,7 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool f=
rom_schedule)
 	struct r1conf *conf =3D mddev->private;
 	struct bio *bio;
=20
-	if (from_schedule) {
+	if (from_schedule || current->bio_list) {
 		spin_lock_irq(&conf->device_lock);
 		bio_list_merge(&conf->pending_bio_list, &plug->pending);
 		conf->pending_count +=3D plug->pending_cnt;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0d5d0ff..c9acbd7 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1069,7 +1069,7 @@ static void raid10_unplug(struct blk_plug_cb *cb, boo=
l from_schedule)
 	struct r10conf *conf =3D mddev->private;
 	struct bio *bio;
=20
-	if (from_schedule) {
+	if (from_schedule || current->bio_list) {
 		spin_lock_irq(&conf->device_lock);
 		bio_list_merge(&conf->pending_bio_list, &plug->pending);
 		conf->pending_count +=3D plug->pending_cnt;

--Sig_/mAEfAr9c3k.a_ceNLlUU=zJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBULVc1Dnsnt1WYoG5AQKxiBAAruj4cGCnZMTMFU3tcD5RHg21MKyBwpIf
KKJ00taVHZCY9vd16dwyBUYd+U7kQPyKD88zkQM+M1uNZp3sm/0dQlkUD1FdQiYM
fOnxZc4SixnneMi7uWqSzxG4zeK4xRfL0k5ueXuRLDko/zZa1opaLjbLqcLvKENd
gD8sbGfSJZhzQvwYba331Kc8lOBwFOUXk/WY+ZkABZlnChkmnBbVrNSHmuZTBXnX
S5kHcIZHhYhVKbqi79VgsfVvFUi39IGcb6wEE6lY7Qds5sHvjWAMHCXPeLZWYxtV
VgTdcl4AZQA+FUgSGFm0ewDgHHE2au1L1BG1QLtmeK0IA/7DWR0hxeOuFrNGshSm
EVZTZ+cyaNXTYYvAHmYGMgPmytQx5HlzuXTmRgBKhMgsrGMMv1Dr8wityPqYuuZl
rWu8hAvPWqjDgcPHzAnkOzrwpmcHPV8jy8GbYIRE/DnJqZx1sF8uOvdnpi1EHPIV
eW7MBFtcBiqFLhw8YUXomYRZIJQ9A3XEChMJQ755fqsbGo2fQyapbmoXd6U4v6y6
WaSOVnYmaMoLa+iPPV/02r7k+erCz+YlnOe/0kLXkgCeAb1BcP2tohvibrQQ1RP5
r6T1qOsDyrBKzapUE+37SAJ3yNnL1NAgbdhvBaMOwz0QYd0rAWp1QCz2nuCPd6YB
kHnBa6f63vs=
=pOeF
-----END PGP SIGNATURE-----

--Sig_/mAEfAr9c3k.a_ceNLlUU=zJ--
