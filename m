Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab1GMUJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 16:09:36 -0400
Received: from home.keithp.com ([63.227.221.253]:50902 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab1GMUJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 16:09:35 -0400
From: "Keith Packard" <keithp@keithp.com>
To: "Wilson\, Chris" <chris@chris-wilson.co.uk>,
        "drivers\, Intel" <Intel-gfx@lists.freedesktop.org>
Subject: [PATCH] drm/i915: Add quirk to disable SSC on Lenovo U160 LVDS
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Date: Wed, 13 Jul 2011 13:09:28 -0700
Message-ID: <yuntyaq7xjb.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


We've tried several times to make this machine 'just work', but every
patch that does causes many other machines to fail. This adds a quirk
which special cases this hardware and forces ssc to be
disabled. There's no way to override this from the command line; that
would be a significantly more invasive change.

Signed-off-by: Keith Packard <keithp@keithp.com>
Tested-by: Robse <rob-se@live.de>

=2D--
 drivers/gpu/drm/i915/i915_drv.h      |    1 +
 drivers/gpu/drm/i915/intel_display.c |   15 ++++++++++++++-
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_dr=
v.h
index f245c58..6042921 100644
=2D-- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -262,6 +262,7 @@ enum intel_pch {
 };
=20
 #define QUIRK_PIPEA_FORCE (1<<0)
+#define QUIRK_LVDS_SSC_DISABLE (1<<1)
=20
 struct intel_fbdev;
=20
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/in=
tel_display.c
index 21b6f93..252c6f0 100644
=2D-- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4305,7 +4305,8 @@ static void intel_update_watermarks(struct drm_device=
 *dev)
=20
 static inline bool intel_panel_use_ssc(struct drm_i915_private *dev_priv)
 {
=2D	return dev_priv->lvds_use_ssc && i915_panel_use_ssc;
+	return dev_priv->lvds_use_ssc && i915_panel_use_ssc
+		&& !(dev_priv->quirks & QUIRK_LVDS_SSC_DISABLE);
 }
=20
 static int i9xx_crtc_mode_set(struct drm_crtc *crtc,
@@ -7810,6 +7811,15 @@ static void quirk_pipea_force (struct drm_device *de=
v)
 	DRM_DEBUG_DRIVER("applying pipe a force quirk\n");
 }
=20
+/*
+ * Some machines (Lenovo U160) do not work with SSC on LVDS for some reason
+ */
+static void quirk_ssc_force_disable (struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv =3D dev->dev_private;
+	dev_priv->quirks |=3D QUIRK_LVDS_SSC_DISABLE;
+}
+
 struct intel_quirk {
 	int device;
 	int subsystem_vendor;
@@ -7838,6 +7848,9 @@ struct intel_quirk intel_quirks[] =3D {
 	/* 855 & before need to leave pipe A & dpll A up */
 	{ 0x3582, PCI_ANY_ID, PCI_ANY_ID, quirk_pipea_force },
 	{ 0x2562, PCI_ANY_ID, PCI_ANY_ID, quirk_pipea_force },
+
+	/* Lenovo U160 cannot use SSC on LVDS */
+	{ 0x0046, 0x17aa, 0x3920, quirk_ssc_force_disable },
 };
=20
 static void intel_init_quirks(struct drm_device *dev)
=2D-=20
1.7.5.4



=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOHft4Qp8BWwlsTdMRAvGiAJ9Mde2rzwcSJYNxpyJmSpxGgcWptgCgwLPm
d9uVx2o0+NvrskkBVhwvi3A=
=oO8O
-----END PGP SIGNATURE-----
--=-=-=--
