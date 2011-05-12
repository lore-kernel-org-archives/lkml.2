Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab1ELSwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:52:38 -0400
Received: from home.keithp.com ([63.227.221.253]:41268 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379Ab1ELSwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:52:36 -0400
From: Keith Packard <keithp@keithp.com>
To: Melchior FRANZ <melchior.franz@gmail.com>, linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH] Revert "drm/i915: Only enable the plane after setting the fb base (pre-ILK)"
In-Reply-To: <201105121849.09225@rk-nord.at>
References: <BANLkTi=9fGdBw=r_dDE3KSPfjU0UjXBZFw@mail.gmail.com> <201105121849.09225@rk-nord.at>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 12 May 2011 11:52:29 -0700
Message-ID: <yun39kjah02.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


This reverts commit 49183b2818de6899383bb82bc032f9344d6791ff.

Franz Melchior:

 This patch introduces a bug on my infamous "Acer Travelmate
 5735Z-452G32Mnss": when KMS takes over, the frame buffer contents
 get completely garbled up on screen, with colored stripes and
 unreadable text (photo on request). Only when X11 is started, the
 screen gets restored again. Closing and re-opening the lid partly
 cures the mess, too: it makes the font readable, though horizontally
 stretched.

=2D--

On Thu, 12 May 2011 18:49:08 +0200, Melchior FRANZ <melchior.franz@gmail.co=
m> wrote:

> * Linus Torvalds -- Tuesday 10 May 2011:
> > But please do test, just to make sure that 39-final is good.
>=20
> > Chris Wilson (4):
> >       drm/i915: Only enable the plane after setting the fb base (pre-IL=
K)
>=20
> This patch introduces a bug on my infamous "Acer Travelmate
> 5735Z-452G32Mnss": when KMS takes over, the frame buffer contents
> get completely garbled up on screen, with colored stripes and
> unreadable text (photo on request). Only when X11 is started, the
> screen gets restored again. Closing and re-opening the lid partly
> cures the mess, too: it makes the font readable, though horizontally
> stretched.
>=20
> Reverting 49183b2818de6899383bb82bc032f9344d6791ff fixes the
> bug.

It's Whack-a-Mole time! Fix one laptop, break another. We'll pick 'no
regressions' over 'fixes existing bug' today.

 drivers/gpu/drm/i915/intel_display.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/in=
tel_display.c
index 373c2a0..2166ee0 100644
=2D-- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -5154,6 +5154,8 @@ static int intel_crtc_mode_set(struct drm_crtc *crtc,
=20
 	I915_WRITE(DSPCNTR(plane), dspcntr);
 	POSTING_READ(DSPCNTR(plane));
+	if (!HAS_PCH_SPLIT(dev))
+		intel_enable_plane(dev_priv, plane, pipe);
=20
 	ret =3D intel_pipe_set_base(crtc, x, y, old_fb);
=20
=2D-=20
1.7.5.1

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFNzCxuQp8BWwlsTdMRAsWrAJ93tX1JXU7jePhI7f0i00M59OOBpgCeIjp2
BLUL6t7IVvgZlPN6tq2VTm8=
=mYZa
-----END PGP SIGNATURE-----
--=-=-=--
