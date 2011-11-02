Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016Ab1KBRiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 13:38:16 -0400
Received: from home.keithp.com ([63.227.221.253]:35327 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932240Ab1KBRiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 13:38:15 -0400
From: Keith Packard <keithp@keithp.com>
To: Chris Wilson <chris@chris-wilson.co.uk>, intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 6/7] drm/i915: Try harder during dp pattern 1 link training
In-Reply-To: <e39f63$2h6thv@fmsmga002.fm.intel.com>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com> <1320214830-12696-7-git-send-email-keithp@keithp.com> <e39f63$2h6thv@fmsmga002.fm.intel.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 02 Nov 2011 10:38:11 -0700
Message-ID: <yunzkgev30c.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 02 Nov 2011 09:12:13 +0000, Chris Wilson <chris@chris-wilson.co.uk>=
 wrote:

> This would seem to be a separate chunk to initiate training on only the
> lanes we intend to use.
> -Chris

Here's that patch separated out:

commit e7fecae483754ca9a42312be18f58ceb454702fe
Author: Keith Packard <keithp@keithp.com>
Date:   Wed Nov 2 10:17:59 2011 -0700

    drm/i915: Initiate DP link training only on the lanes we'll be using
=20=20=20=20
    Limit the link training setting command to the lanes needed for the
    current mode. It seems vaguely possible that a monitor will try to
    train the other lanes and fail in some way, so this seems like the
    safer plan.
=20=20=20=20
    Signed-off-by: Keith Packard <keithp@keithp.com>

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_d=
p.c
index 0a4fa64..02b56ce 100644
=2D-- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1567,8 +1567,9 @@ intel_dp_set_link_train(struct intel_dp *intel_dp,
=20
        ret =3D intel_dp_aux_native_write(intel_dp,
                                        DP_TRAINING_LANE0_SET,
=2D                                       intel_dp->train_set, 4);
=2D       if (ret !=3D 4)
+                                       intel_dp->train_set,
+                                       intel_dp->lane_count);
+       if (ret !=3D intel_dp->lane_count)
                return false;
=20
        return true;


=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTrGAAzYtFsjWk68qAQiqCw/9ExKFv8Lj3ZRW9mh2uhBytDgabJlk6q8X
jQBE0XxvLrRY/gAUKLLebE7Oy6PVvOtaHaVW5nj58irbXQq7g80vaOAOFK3z/Yj0
z9QQdcKqXYrzZLxxZMgtcMOrkfyQUJEy6xnFr7GQE3Z312FILNGBsNT7HWLY769W
cdM/TZ5iUbGEK4Uw1dfSh6oy3rtPt9IAAWsxgPsc9iYrc8VmQLfGeDlc4ioxMRkZ
XpvP/89kaWfxZq+f4Kk4fO+z1EbiBZ6RQRqPtf7fZ5SVGg/P+sukGcXRW/yQFrjD
O+LBQAShxFQn/a5t8qTODDKQwbyIukSZDQlJmisdOSL7fF6pZf+Gt4s9byPjSHh+
7utv7r9yWtD957pp0BnPXkLIFutKOyVdhScHf/jZp0cIUi/2wClmS/pEzZ0bi9dC
xVpe0Szt74kAU99uDw2RCfaR0Whk3x+3uApCG4Z7Pykej4N/sRnDtaIqR/OE9x+t
Y2pDxXP2s0qf0VCaeBdgQwVRdblHUH4MErK1X66rk4M+6nG2+rLcK+vHb1RuU/G9
qU6O90QKY7XutVoZ0Sd96GcfMjMZAog/yA2HvS1NaLRGatVjWmmhMgZFAPpAfCmh
D8HJY+gr0eXwhONeurD2VtQRwqS4i4wwHTzym/t1OwUe2DBG83A7+RwWw0CJNzWI
TpffdEqsLZ0=
=Ra/1
-----END PGP SIGNATURE-----
--=-=-=--
