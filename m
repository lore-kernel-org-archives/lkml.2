Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933498Ab2BBXvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:51:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48402 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757763Ab2BBXvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:51:12 -0500
Date: Fri, 3 Feb 2012 10:50:57 +1100
From: NeilBrown <neilb@suse.de>
To: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: David Woodhouse <David.Woodhouse@intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Crash in mtd_cls_suspend because mtd is NULL.
Message-ID: <20120203105057.11a86f26@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_V2jOMSuY_KcRZq4Jyjsn4k"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_V2jOMSuY_KcRZq4Jyjsn4k
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi,
 I just tried to suspend my GTA04 (OMAP based mobile phone platform) running
3.3-rc2 and it crashed in mtd_cls_suspend because mtd was NULL.

So for me, it looks like the following patch is a regression.

Is there anything I can do to help find the correct resolution here.

(It has some flash memory but I am not using it at all).

Thanks,
NeilBrown




commit 079c985e7a6f4ce60f931cebfdd5ee3c38347e31
Author: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date:   Fri Dec 30 17:15:59 2011 +0200

    mtd: do not use mtd->suspend and mtd->resume directly
   =20
    Just call the 'mtd_suspend()' and 'mtd_resume()' - they will do nothing
    if the operation is not defined.
   =20
    Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 66494ee..6ae9ca0 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -119,10 +119,7 @@ static int mtd_cls_suspend(struct device *dev, pm_mess=
age_t
 {
        struct mtd_info *mtd =3D dev_get_drvdata(dev);
=20
-       if (mtd && mtd->suspend)
-               return mtd_suspend(mtd);
-       else
-               return 0;
+       return mtd_suspend(mtd);
 }
=20
 static int mtd_cls_resume(struct device *dev)


--Sig_/_V2jOMSuY_KcRZq4Jyjsn4k
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTyshYTnsnt1WYoG5AQKazQ//YODOIdPlM3x7fzzSLYGmiIlFbf25wuL5
0Ja1Kf9j0VjvnL/nsVBHwRT52jWhnWktktuEvTc/UUJXiBUMDpUrsbwwRr89D6km
4Rx1g0Q8Maag4jutcFoLFGYVdmZFpOagyoOcGBZu1Te0VC1RiQjTfl+hnuMYyWl5
Ngtfb9a4NFzIMrgg/Em4xnovqusoviwvX/ijf0eGLNejDkreOSrn1tG78w1HQBD2
qrPmPK1f/qWwyHdqHToafg0bN8/TqyNmD7rVk+qh7nk7VYSP7zxmi+tFZdxebUwB
v/swKuFarVuEsXVkcEt66s0I8lIZXDZzY48478RkMFmOuTbQo1wWixeol0Jk8tw2
gVnXrp8sFSfAf1naxmemoaPggmPetIlipE7WEOfIG5zbNjGnTNdceaOLta5B2F7E
RkQvvmk7Q/0IXefm27hq+QYGPUvoboKPuuyglkYGYZO4EX6uB66HPzgUKdqKrv5E
+CAIo0rcLi5cUnlMEpwbQ9ehp0VcX5TQOJoM+W7Y3ztF+mj7d1g7siw+FAaEukto
q4nVD/2FB0Qv9ZXxZyOILFYl63vOfJ6IwIsc2Vn8kt+Uw+f0N0E9F+rtpCGOqE2C
oypSJ0T7qcSjH9GY3wYjPDudueURvJ3rhORf1D6EuqawJeBL/hS0fKJ40redEoDl
IODebBraVZ4=
=CrKA
-----END PGP SIGNATURE-----

--Sig_/_V2jOMSuY_KcRZq4Jyjsn4k--
