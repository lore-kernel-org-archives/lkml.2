Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab1I0SDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:03:48 -0400
Received: from home.keithp.com ([63.227.221.253]:60610 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601Ab1I0SDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:03:47 -0400
From: Keith Packard <keithp@keithp.com>
To: Chris Wilson <chris@chris-wilson.co.uk>, Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH 6/9] drm/i915: Fix PCH SSC reference clock settings
In-Reply-To: <e0d58a$1mfd94@orsmga002.jf.intel.com>
References: <yunbou6lxb4.fsf@aiko.keithp.com> <1317103906-4649-1-git-send-email-keithp@keithp.com> <1317103906-4649-7-git-send-email-keithp@keithp.com> <e0d58a$1mfd94@orsmga002.jf.intel.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Tue, 27 Sep 2011 11:03:43 -0700
Message-ID: <yunr531981s.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Sep 2011 17:47:10 +0100, Chris Wilson <chris@chris-wilson.co.uk>=
 wrote:
> On Mon, 26 Sep 2011 23:11:43 -0700, Keith Packard <keithp@keithp.com> wro=
te:
> > The PCH refclk settings are global, so we need to look at all of the
> > encoders, not just the current encoder when deciding how to configure
> > it. Also, handle systems with more than one panel (any combination of
> > PCH/non-PCH eDP and LVDS).
>=20
> As I read it, this sets the refclk not on the active configuration, but
> on all the hardware detected for the system whether enabled or not.

Correct. We cannot randomly turn ref clocks on/off without also
disconnecting them from the PLLs that they drive.

What we could do is figure out which of the two clocks need to be
enabled and modify the mode set code to turn them on when needed before
setting the mode, and then turn them off after, when they aren't
needed. This would leave them off until needed, which might be nice?

This will make changing the driver to not disable the panel at startup
time harder; we'll need to switch the panel to the non-SSC reference,
turn the SSC reference off, reconfigure it and then switch the panel
back to the SSC reference. That's a project for a future change though.

> There are two basic changes here, the cleanup and improvement to the logic
> based on what type of output is connected and the second change to
> determine which outputs are active.

Right, the logic fixes ensure that the clocks are programmed in the
right sequence and that LVDS, eDP and pch-EDP all get SSC as necessary.

The change in dealing with the outputs means that the clocks are
programmed based not on which outputs are active, but on all possible
outputs, ensuring that the programming never changes in response to mode
setting requests.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOgg//Qp8BWwlsTdMRAhCRAKCMJ6fvWSXUIIrGsD1GiOpjS/xKJQCg0HsO
a0SH9zyQxpVVDg/debAc44k=
=q8BO
-----END PGP SIGNATURE-----
--=-=-=--
