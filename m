Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab0EaOvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 10:51:24 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:35603 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab0EaOvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 10:51:23 -0400
X-Greylist: delayed 502 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 May 2010 10:51:22 EDT
From: Martin Steigerwald <Martin@lichtvoll.de>
To: stable@kernel.org
Subject: [stable] please consider drm radeon kms agp release
Date: Mon, 31 May 2010 16:42:41 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-tp42-toi-3.1-radeon-kms-agp-suspend-04981-gb9a071a-dirty; KDE/4.4.3; i686; ; )
Cc: =?iso-8859-1?q?J=E9r=F4me_Glisse?= <glisse@freedesktop.org>,
       Alex Deucher <alexdeucher@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2061228.qr21Lqbp1g";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201005311642.49843.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2061228.qr21Lqbp1g
Content-Type: multipart/mixed;
  boundary="Boundary-01=_ir8AM+mPPZ15Ogz"
Content-Transfer-Encoding: 7bit


--Boundary-01=_ir8AM+mPPZ15Ogz
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline


Hi Greg, hi stable kernel team,

Please consider the attached patch from J=E9r=F4me Glisse. It fixes drm rad=
eon=20
KMS after coming out from a snapshot cycle [1] - no matter whether I use=20
userspace software suspend or TuxOnIce.

Verified on my notebook ThinkPad T42 and by cedric, the reporter of above=20
bug.

Thanks.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=3D15969#c14

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--Boundary-01=_ir8AM+mPPZ15Ogz
Content-Type: text/x-patch;
  charset="UTF-8";
  name="0001-drm-radeon-kms-release-AGP-bridge-at-suspend.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-drm-radeon-kms-release-AGP-bridge-at-suspend.patch"

=46rom bc19ff2e0bff31523af06bc089b71b4f46478837 Mon Sep 17 00:00:00 2001
=46rom: Jerome Glisse <jglisse@redhat.com>
Date: Fri, 21 May 2010 14:19:07 +0200
Subject: [PATCH] drm/radeon/kms: release AGP bridge at suspend

I think it's good to release the AGP bridge at suspend
and reacquire it at resume. Also fix :
https://bugzilla.kernel.org/show_bug.cgi?id=3D15969

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
=2D--
 drivers/gpu/drm/radeon/radeon.h        |    1 +
 drivers/gpu/drm/radeon/radeon_agp.c    |    5 +++++
 drivers/gpu/drm/radeon/radeon_device.c |    2 ++
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeo=
n.h
index 034218c..4c7204a 100644
=2D-- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -566,6 +566,7 @@ typedef int (*radeon_packet3_check_t)(struct radeon_cs_=
parser *p,
  */
 int radeon_agp_init(struct radeon_device *rdev);
 void radeon_agp_resume(struct radeon_device *rdev);
+void radeon_agp_suspend(struct radeon_device *rdev);
 void radeon_agp_fini(struct radeon_device *rdev);
=20
=20
diff --git a/drivers/gpu/drm/radeon/radeon_agp.c b/drivers/gpu/drm/radeon/r=
adeon_agp.c
index 28e473f..f40dfb7 100644
=2D-- a/drivers/gpu/drm/radeon/radeon_agp.c
+++ b/drivers/gpu/drm/radeon/radeon_agp.c
@@ -270,3 +270,8 @@ void radeon_agp_fini(struct radeon_device *rdev)
 	}
 #endif
 }
+
+void radeon_agp_suspend(struct radeon_device *rdev)
+{
+	radeon_agp_fini(rdev);
+}
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeo=
n/radeon_device.c
index 7b629e3..ed6a724 100644
=2D-- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -748,6 +748,8 @@ int radeon_suspend_kms(struct drm_device *dev, pm_messa=
ge_t state)
 	/* evict remaining vram memory */
 	radeon_bo_evict_vram(rdev);
=20
+	radeon_agp_suspend(rdev);
+
 	pci_save_state(dev->pdev);
 	if (state.event =3D=3D PM_EVENT_SUSPEND) {
 		/* Shut down the device */
=2D-=20
1.7.0.1


--Boundary-01=_ir8AM+mPPZ15Ogz--

--nextPart2061228.qr21Lqbp1g
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkwDyuIACgkQmRvqrKWZhMdX/wCeKA+iL4tdqoalBVa5rjRUTPJL
BqYAnRG5jhoIuMlYhMwB7BlTYgZ0MqxQ
=BdHr
-----END PGP SIGNATURE-----

--nextPart2061228.qr21Lqbp1g--
