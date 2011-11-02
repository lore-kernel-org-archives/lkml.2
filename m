Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446Ab1KBUFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:05:30 -0400
Received: from home.keithp.com ([63.227.221.253]:52059 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab1KBUF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:05:28 -0400
From: Keith Packard <keithp@keithp.com>
To: Adam Jackson <ajax@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 3/7] drm/i915: Treat PCH eDP like DP in most places
In-Reply-To: <4EB19BB4.6030505@redhat.com>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com> <1320214830-12696-4-git-send-email-keithp@keithp.com> <20111102092019.3a635632@jbarnes-desktop> <4EB17A50.6050804@redhat.com> <yun8vnywhvh.fsf@aiko.keithp.com> <4EB19BB4.6030505@redhat.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 02 Nov 2011 13:05:23 -0700
Message-ID: <yunipn2uw70.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 02 Nov 2011 15:36:20 -0400, Adam Jackson <ajax@redhat.com> wrote:

> The VBT is going to be crap.

The only question then is what to do with hardware that doesn't have the
DPCD value -- that's "new" in revision 0x11, after all.

How about this:

commit 34ebe02cc78f20ae6b7865c5087c3b5ac7810185
Author: Keith Packard <keithp@keithp.com>
Date:   Wed Nov 2 13:03:47 2011 -0700

    drm/i915: Use DPCD value for max DP lanes where possible
=20=20=20=20
    Fall back to the VBT value for eDP monitors only when DPCD is missing
    the value.
=20=20=20=20
    Signed-off-by: Keith Packard <keithp@keithp.com>

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_d=
p.c
index 02b56ce..93b082a 100644
=2D-- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -154,6 +154,8 @@ intel_edp_link_config(struct intel_encoder *intel_encod=
er,
 static int
 intel_dp_max_lane_count(struct intel_dp *intel_dp)
 {
+       struct drm_device *dev =3D intel_dp->base.base.dev;
+       struct drm_i915_private *dev_priv =3D dev->dev_private;
        int max_lane_count =3D 4;
=20
        if (intel_dp->dpcd[DP_DPCD_REV] >=3D 0x11) {
@@ -164,6 +166,8 @@ intel_dp_max_lane_count(struct intel_dp *intel_dp)
                default:
                        max_lane_count =3D 4;
                }
+       } else if (is_edp(intel_dp)) {
+               max_lane_count =3D dev_priv->edp.lanes;
        }
        return max_lane_count;
 }
@@ -765,12 +769,11 @@ intel_dp_set_m_n(struct drm_crtc *crtc, struct drm_di=
splay_mode *mode,
                        continue;
=20
                intel_dp =3D enc_to_intel_dp(encoder);
=2D               if (intel_dp->base.type =3D=3D INTEL_OUTPUT_DISPLAYPORT |=
| is_pch_edp(intel_dp)) {
+               if (intel_dp->base.type =3D=3D INTEL_OUTPUT_DISPLAYPORT ||
+                   intel_dp->base.type =3D=3D INTEL_OUTPUT_EDP)
+               {
                        lane_count =3D intel_dp->lane_count;
                        break;
=2D               } else if (is_cpu_edp(intel_dp)) {
=2D                       lane_count =3D dev_priv->edp.lanes;
=2D                       break;
                }
        }
=20


=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTrGigzYtFsjWk68qAQj2ow/+M/NfNYe/9l132wJLHLK2l1z9/QdqjoFe
naZipuUWtWeZ9der142UMZCZiO3WE+8IvIDghoOxinc/8vHSQ4S55UvVnRM3BpCo
HAdjvszumKcZlMCZ84AmV5bt9V0+1lUaHkor7S0/nT7ZBnqZwFHT4sDt58wDPkJe
O/oTG1kbF8VPZImHn09IC82lFXkTkKYa2TDXnL9us/AvTLFVKbKa0w5+Hkna8iXy
vPipqbMn7N7s1TvpDlA/L23qrxFOgiI1mmiCCHPwnK6d8AndwOuAygCHptwjEL+I
5dcehonzdrxWkGaCE6/2aO8ZKaE9fQ2u5anxzZgwCCLVDA0d+sYzsp4AlgomQS1h
X6Z3rO+RQ2y1y1xoJPMmhNbuYmleqxCN8SWcRI1ccGyN9QZUVhLi8vrnfeueuT8d
dHpBRn6IB3l3P2vak0OmaoPb+bk4pY0ZGofuLDcbC/92om8InhJyhZ+vcUTSJR6T
xcB8bmkGt8vP3XtXxcy1rw3cZXWHLQRIbnuXsodQ3z5mZ1fYTn9iRUE/LY8Oq9gE
TOcp6/hWUSYNFF4uaEnSx9FyYlJEf2GnugHzCoZX9lHftHTbqNou6FwKIuXSxluq
URhZyx+VM+5vTygilUBspbFXgZDn+V1XREoBjXQDBQNYJM1CNmWrItHq9ktqSZ9H
WEXTv1A4WaM=
=506D
-----END PGP SIGNATURE-----
--=-=-=--
