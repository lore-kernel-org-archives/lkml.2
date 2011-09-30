Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab1I3R6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 13:58:31 -0400
Received: from home.keithp.com ([63.227.221.253]:47554 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690Ab1I3R6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 13:58:30 -0400
From: Keith Packard <keithp@keithp.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 04/21] drm/i915: Only use VBT panel mode on eDP if no EDID is found
In-Reply-To: <20110930163235.GD2859@phenom.ffwll.local>
References: <20110923085243.6e4b7b4c@jbarnes-x220> <1317344993-24945-1-git-send-email-keithp@keithp.com> <1317344993-24945-5-git-send-email-keithp@keithp.com> <20110930163235.GD2859@phenom.ffwll.local>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 30 Sep 2011 10:58:26 -0700
Message-ID: <yun4nzt9akd.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Sep 2011 18:32:35 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:

> Ok, this is way over my head, just checked whether the patch does what it
> claims to - nice exercise in reading dp modeset code ;-)

Yeah, it's purely heuristic -- the VBT contains a mode which was
originally for the LVDS. It's unclear whether it should ever be applied
to an eDP panel, but absent other information, it seems like we should
at least consider it.

Many LVDS panels don't bother to include an EDID rom, or the vendor
didn't bother to hook up the DDC wire; presumably it's cheaper for them
to stick more data in the VBIOS than add hardware.  However, there are
some LVDS panels with EDID roms which contain *incorrect* mode data for
the panel (amazing, I know), and so the driver prefers to use the VBT
data when both are present.

eDP, on the other hand, doesn't require any additional wiring (at least)
to connect up the DDC channel, and eDP panels are required to provide
EDID data. So far, in my (very small) sample set, I've got one machine
which provides accurate VBT *and* EDID data (an HP 2540p) and one
machine which provides inaccurate VBT data but accurate EDID data (a
MacBook air). So, I just decided to prefer the EDID data.

One option would be to extract the current mode from the hardware when
the driver starts and use that if present. But, that might mean that
you'd get different modes depending on whether the machine booted with
the lid closed or open, which seems like a bad plan.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOhgNCQp8BWwlsTdMRAgpnAKDXF/UMpXRwLgDslnMmlO7//slNFACg3TFq
ihZSnNvvpZAjd2Sc5KlkJ6g=
=GM5A
-----END PGP SIGNATURE-----
--=-=-=--
