Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab1EVGXs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 02:23:48 -0400
Received: from home.keithp.com ([63.227.221.253]:34645 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab1EVGXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 02:23:42 -0400
From: Keith Packard <keithp@keithp.com>
To: Matt Mackall <mpm@selenic.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Regression with i915 and suspend on Thinkpad x220
In-Reply-To: <1306040157.3322.11.camel@calx>
References: <1306040157.3322.11.camel@calx>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sat, 21 May 2011 23:23:34 -0700
Message-ID: <yunlixz6yop.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sat, 21 May 2011 23:55:57 -0500, Matt Mackall <mpm@selenic.com> wrote:

> I've got a new Thinkpad x220 which won't wake up from suspend with
> 2.6.39, but works fine with 2.6.37.
>=20
> I bisected it down to this cset:
>=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dco=
mmit;h=3D4efe070896e1f7373c98a13713e659d1f5dee52a
>=20
> drm/i915: make the blitter report buffer modifications to the FBC unit

For now, you should be able to disable FBC:

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_dr=
v.c
index c34a8dd..2a82895 100644
=2D-- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -183,7 +183,7 @@ static const struct intel_device_info intel_sandybridge=
_d_info =3D {
 static const struct intel_device_info intel_sandybridge_m_info =3D {
 	.gen =3D 6, .is_mobile =3D 1,
 	.need_gfx_hws =3D 1, .has_hotplug =3D 1,
=2D	.has_fbc =3D 1,
+	.has_fbc =3D 0,
 	.has_bsd_ring =3D 1,
 	.has_blt_ring =3D 1,
 };

Let us know if this works. There's a patch heading for 2.6.40 that
provides a module parameter to control FBC from the kernel command
line. We've got a couple X220s on order and I hope we'll be able to
reproduce (and fix) this issue -- FBC saves enough power that we'd like
to be able to leave it enabled on hardware that supports it.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFN2KvmQp8BWwlsTdMRAlVMAJwJLRzn0vkqdCXchWFi5qHUY4JFqgCdEpV+
ebORWeBnh9l4MNqq1xZxlbs=
=2dZ6
-----END PGP SIGNATURE-----
--=-=-=--
