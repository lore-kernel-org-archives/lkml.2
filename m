Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684Ab1KISHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 13:07:37 -0500
Received: from home.keithp.com ([63.227.221.253]:39449 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932607Ab1KISHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 13:07:35 -0500
From: Keith Packard <keithp@keithp.com>
To: Michel Alexandre Salim <salimma@fedoraproject.org>,
        intel-gfx@lists.freedesktop.org
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] drm/i915: Honor SSC quirk table over the default, unless set by user
In-Reply-To: <4EBAAAA5.7030807@fedoraproject.org>
References: <1320855178.5081.9.camel@fauix11.informatik.uni-erlangen.de> <4EBAAAA5.7030807@fedoraproject.org>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 09 Nov 2011 10:07:31 -0800
Message-ID: <yunvcqtxj8c.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 09 Nov 2011 17:30:29 +0100, Michel Alexandre Salim <salimma@fedorap=
roject.org> wrote:
> Additional note: while I've not touched the line since it does not
> affect me, it seems that i915_panel_use_ssc *cannot* be less than 0
> since that variable is declared as unsigned.

Oops. That's the bug here -- we're supposed to make it so that the
command line can override the quirks, but there's no way to use a quirk
given the mis-declared parameter.

This is untested...

From=20e64ecadef40e3c2035cd4e9b967ffd83489bdea0 Mon Sep 17 00:00:00 2001
From: Keith Packard <keithp@keithp.com>
Date: Wed, 9 Nov 2011 09:57:50 -0800
Subject: [PATCH] drm/i915: Module parameters using '-1' as default must be
 signed type

Testing i915_panel_use_ssc for the default value was broken, so the
driver would never autodetect the correct value.

Signed-off-by: Keith Packard <keithp@keithp.com>
=2D--
 drivers/gpu/drm/i915/i915_drv.c |    4 ++--
 drivers/gpu/drm/i915/i915_drv.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_dr=
v.c
index 548e04b..13488be 100644
=2D-- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -67,7 +67,7 @@ module_param_named(i915_enable_rc6, i915_enable_rc6, int,=
 0600);
 MODULE_PARM_DESC(i915_enable_rc6,
 		"Enable power-saving render C-state 6 (default: true)");
=20
=2Dunsigned int i915_enable_fbc __read_mostly =3D -1;
+int i915_enable_fbc __read_mostly =3D -1;
 module_param_named(i915_enable_fbc, i915_enable_fbc, int, 0600);
 MODULE_PARM_DESC(i915_enable_fbc,
 		"Enable frame buffer compression for power savings "
@@ -79,7 +79,7 @@ MODULE_PARM_DESC(lvds_downclock,
 		"Use panel (LVDS/eDP) downclocking for power savings "
 		"(default: false)");
=20
=2Dunsigned int i915_panel_use_ssc __read_mostly =3D -1;
+int i915_panel_use_ssc __read_mostly =3D -1;
 module_param_named(lvds_use_ssc, i915_panel_use_ssc, int, 0600);
 MODULE_PARM_DESC(lvds_use_ssc,
 		"Use Spread Spectrum Clock with panels [LVDS/eDP] "
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_dr=
v.h
index d2da91f..4a9c1b9 100644
=2D-- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1000,10 +1000,10 @@ extern int i915_panel_ignore_lid __read_mostly;
 extern unsigned int i915_powersave __read_mostly;
 extern unsigned int i915_semaphores __read_mostly;
 extern unsigned int i915_lvds_downclock __read_mostly;
=2Dextern unsigned int i915_panel_use_ssc __read_mostly;
+extern int i915_panel_use_ssc __read_mostly;
 extern int i915_vbt_sdvo_panel_type __read_mostly;
 extern unsigned int i915_enable_rc6 __read_mostly;
=2Dextern unsigned int i915_enable_fbc __read_mostly;
+extern int i915_enable_fbc __read_mostly;
 extern bool i915_enable_hangcheck __read_mostly;
=20
 extern int i915_suspend(struct drm_device *dev, pm_message_t state);
=2D-=20
1.7.7

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTrrBYzYtFsjWk68qAQg9cRAA3NkmdfpZASzNgLwoW2ZAxW6sO9GwR9En
dVaKb1+WRYmvja612WLwswwteqW1HZi0cNtlEvSmu0tpHAHEcOZ4vOmz4RvdA/iW
3tXk4glEI5bCwJseL6+yjn+jQcOOqBviI+FrT9bb0+hLwqIc2L4Oq2miW1ZbvpQ4
sJWZ2XoCW+BVID2PeafYswKWN9dQEHRX7olzMWyG2F1725TMhMhJm3iIy1fy3/Y3
r9wiZkc22CUVVmeUuIAkGNUAUKw3OW1TONyoea/eBx6bWo9n0t973fF/Bemqw9OW
qpJnNxOWdHTvLHiohJZRozfK30WA8tl6TFHM6HTr93uNyhF51o74ZyF8F+MxCRsA
kREFfNyvlLZdmnK4V4UTkPvz33D7DlqS6HCnEVa0bXeHkWaOKc7DVYh7QxGafIOP
wZ+HdmdDtzq6SAC9KdXvmrVWcNMRKnhtJCOQzC6ri9rfjSp6kiqH+D0c3CxckBTY
m/CtGGu+kJCMd7nqGu+G1WclyND7CZ+AUBLT2dhozB2F8ddcAdcwu/B1WnAYmFBR
QGg23xAr7MJTznfzGCJulUjioocelSQ/GIp0LH5jMVfY/ubvlmfbwZUQ2JKwMN2l
jHfmU/nFmXfpNTG9ukGoKbBjqwzS3vEsvCI0gaoYPPBbkJRzQ+TtYUx+6Hw7ECVH
ieldpX2aiBU=
=hPt0
-----END PGP SIGNATURE-----
--=-=-=--
