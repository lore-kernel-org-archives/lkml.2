Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab1JaCI4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 22:08:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44317 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444Ab1JaCIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 22:08:55 -0400
Date: Mon, 31 Oct 2011 13:08:59 +1100
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: PULL REQUEST - serious md/RAID10 bug in 3.1 when activating a
 hot-spare.
Message-ID: <20111031130859.121d5620@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nxzPJl3EIPvjtbe=aRQZlEu"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/nxzPJl3EIPvjtbe=aRQZlEu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Linus et al,

 I just discovered a fairly serious flaw that I introduced into 3.1 - detai=
ls
 below.

 Anyone running RAID10 with 3.1 is advised to either apply this patch or
 revert an earlier kernel as soon as possible.  In the mean time, remove any
 hot spares from an RAID10 array.

NeilBrown


The following changes since commit d890fa2b0586b6177b119643ff66932127d58afa:

  md: Fix some bugs in recovery_disabled handling. (2011-10-26 11:54:39 +11=
00)

are available in the git repository at:
  git://neil.brown.name/md for-linus

  last commit being 7fcc7c8acf0fba44d19a713207af7e58267c1179

NeilBrown (1):
      md/raid10:  Fix bug when activating a hot-spare.

 drivers/md/raid10.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)



commit 7fcc7c8acf0fba44d19a713207af7e58267c1179
Author: NeilBrown <neilb@suse.de>
Date:   Mon Oct 31 12:59:44 2011 +1100

    md/raid10:  Fix bug when activating a hot-spare.
   =20
    This is a fairly serious bug in RAID10.
   =20
    When a RAID10 array is degraded and a hot-spare is activated, the
    spare does not take up the empty slot, but rather replaces the first
    working device.
    This is likely to make the array non-functional.   It would normally
    be possible to recover the data, but that would need care and is not
    guaranteed.
   =20
    This bug was introduced in commit
       2bb77736ae5dca0a189829fbb7379d43364a9dac
    which first appeared in 3.1.
   =20
    Cc: stable@kernel.org
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 132c18e..c025a82 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1355,7 +1355,7 @@ static int raid10_add_disk(struct mddev *mddev, struc=
t md_rdev *rdev)
 		struct mirror_info *p =3D &conf->mirrors[mirror];
 		if (p->recovery_disabled =3D=3D mddev->recovery_disabled)
 			continue;
-		if (!p->rdev)
+		if (p->rdev)
 			continue;
=20
 		disk_stack_limits(mddev->gendisk, rdev->bdev,

--Sig_/nxzPJl3EIPvjtbe=aRQZlEu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTq4DPDnsnt1WYoG5AQIuihAAkZiSy+m2tK21mI9VP0beUV3j8NaI/Do8
n7hNYshzjRq8CR/8cLmUzYN2U2yaD515+ezDO9fEjG/hiiB4MllUClqEhmXYBgmP
Kojxl8kKCjpGdYsAZhkzQkQGpaxotxD8fqvrKYQvMMXaCLUrB9XVD88YTONmvbEZ
tIdyinfEzj02QPfi4rTiE3QHgNkPbhGxfSJ6eMeAqTW0Ve1PMRejapZ//UoJYbj+
yNqMpUn3i2h0UTB2vl4bMlcdgwV4mTHn90AgmGL7Salm1c6yKyvgjrMhOCv8lvIZ
jqzqfOUT0fXgNkEejIvYIPQC7+tzAxgwyhC+lvxPC55PPJ6YwmKKUw7OW0E4xyie
ifQN7jS2LbsWeUpak55pqMGdCJmteBU3LFzaw7wzAO12D/ZpAYmSmmFY1cuwWjEO
xVB+8lvvEruY+7BzVkvmigq2Fh/iKDD26hdHAh0wi6V5fIKy/z1zLcqj4pUSjGWU
8W7pYWNe0GggPdis//VP/K54c2+gwvtY5WogdM8LVxgwfHg69kpu/Mp7QQAY98b+
yFmgPkErHnKitEm5W6HU5KM9LxpPMsDEENiglLDuvK1IVmWOExtyzscW8fDh6t22
97hDHTxMg0JZ70E0YS1h3q2FDcQ/RMZgZXsuvQ2ZRvMEq4/ZflTGmSJOQSRnLofG
v84wm+yR6bs=
=g5Dl
-----END PGP SIGNATURE-----

--Sig_/nxzPJl3EIPvjtbe=aRQZlEu--
