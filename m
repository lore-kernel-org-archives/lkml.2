Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab1ITQgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:36:36 -0400
Received: from home.keithp.com ([63.227.221.253]:36612 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab1ITQgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:36:35 -0400
From: Keith Packard <keithp@keithp.com>
To: Chris Wilson <chris@chris-wilson.co.uk>, Dave Airlie <airlied@redhat.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/i915: Enable digital port hotplug on PCH systems
In-Reply-To: <d08817$1gj40m@azsmga001.ch.intel.com>
References: <1316533641-13478-1-git-send-email-keithp@keithp.com> <d08817$1gj40m@azsmga001.ch.intel.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Tue, 20 Sep 2011 09:36:31 -0700
Message-ID: <yuniponf9ww.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 20 Sep 2011 17:24:21 +0100, Chris Wilson <chris@chris-wilson.co.uk>=
 wrote:
> On Tue, 20 Sep 2011 08:47:21 -0700, Keith Packard <keithp@keithp.com> wro=
te:
> > We were relying on the BIOS to set these bits, which doesn't always
> > happen.
>=20
> Do we need to clear IRQ bits on uninstall, for example to prevent
> "Interrupt 19: no one cared!" or is that due to a different cause?

Probably a good plan, but of course that's separate from turning on the
hotplug hardware in the PCH. Something like:

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_ir=
q.c
index c22823b..adeab2a 100644
=2D-- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -2044,6 +2044,10 @@ static void ironlake_irq_uninstall(struct drm_device=
 *dev)
 	I915_WRITE(GTIMR, 0xffffffff);
 	I915_WRITE(GTIER, 0x0);
 	I915_WRITE(GTIIR, I915_READ(GTIIR));
+
+	I915_WRITE(SDEIMR, 0xffffffff);
+	I915_WRITE(SDEIER, 0x0);
+	I915_WRITE(SDEIIR, I915_READ(SDEIIR));
 }
=20
 static void i915_driver_irq_uninstall(struct drm_device * dev)

> More of a general question really. The patch itself looks good and
> matches against the spec afaics.

I was amused to learn that the BIOS on my machine actually turns on the
hotplug hardware for no good reason, so things 'worked' without this
code on many machines. I wonder how many DP/DVI/HDMI machines aren't
actually doing hotplug today...

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOeMEPQp8BWwlsTdMRArqBAJ9crXczcwb2Zl5rJAQ/8110izZGHACglXyq
DKRpdqQGKWX0y1xvo++LcHs=
=Z4iz
-----END PGP SIGNATURE-----
--=-=-=--
