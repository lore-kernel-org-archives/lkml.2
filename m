Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805Ab1I3XOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 19:14:51 -0400
Received: from home.keithp.com ([63.227.221.253]:35246 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab1I3XOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 19:14:44 -0400
From: Keith Packard <keithp@keithp.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 06/21] drm/i915: Unlock PCH_PP_CONTROL always
In-Reply-To: <20110930170946.GF2859@phenom.ffwll.local>
References: <20110923085243.6e4b7b4c@jbarnes-x220> <1317344993-24945-1-git-send-email-keithp@keithp.com> <1317344993-24945-7-git-send-email-keithp@keithp.com> <20110930170946.GF2859@phenom.ffwll.local>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 30 Sep 2011 16:14:40 -0700
Message-ID: <yunty7t62sf.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Sep 2011 19:09:46 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:

> grep shows that we also write to PCH_PP_CONTROL in intel_lvds.c in the
> dpms functions - any reasons these two writes are left out?

Upon a bit of review:

  The bspec makes it clear that this write protect key only needs to
  be written for eDP on DPA -- it's a work-around for a bug where panel
  power sequencing wouldn't work right.

  The LVDS code does disable write protect in the _init function, which
  seems global enough, but misses the resume case. We shouldn't ever
  need to set this field though; it write protects registers only
  when the panel is running. We could presumably remove the
  write protect disable entirely in the LVDS code.

So, I think the patch as written is correct.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOhk1hQp8BWwlsTdMRAo+XAJ9Rr7HxRaCkdshHbI0irxyiTSZ1GwCdGvED
YPiHdl4nkRRgn/0Ue4hQy5g=
=FdjR
-----END PGP SIGNATURE-----
--=-=-=--
