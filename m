Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485Ab2AYUMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 15:12:21 -0500
Received: from home.keithp.com ([63.227.221.253]:48111 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab2AYUMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 15:12:19 -0500
From: "Keith Packard" <keithp@keithp.com>
To: Dave Airlie <airlied@gmail.com>
Subject: [PULL] drm-intel-fixes
User-Agent: Notmuch/0.11 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "drivers, Intel" <Intel-gfx@lists.freedesktop.org>,
        dri-devel@lists.freedesktop.org
Date: Wed, 25 Jan 2012 12:12:15 -0800
Message-ID: <86d3a7czj4.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


A bunch of patches which fix IVB-specific troubles:

 * A selection of code which was labeled for SNB, but needs to be run on
   IVB as well.

 * A replacement for the quick-hack IVB lost-IRQ issue. This appears to
   help on SNB as well, but for now it's only enabled on IVB in case we
   discover problems with it.
=20=20=20
 * Fix some 3-pipe issues

And, a couple of minor mode setting fixes.

The following changes since commit dcd6c92267155e70a94b3927bce681ce74b80d1f:

  Linux 3.3-rc1 (2012-01-19 15:04:48 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/keithp/linux drm-intel-fixes

Daniel Vetter (7):
      drm/i915: convert force_wake_get to func pointer in the gpu reset code
      drm/i915: protect force_wake_(get|put) with the gt_lock
      drm/i915: paper over missed irq issues with force wake voodoo
      drm/i915: rip out the HWSTAM missed irq workaround
      drm/i915: allow userspace forcewake references also on gen7
      drm/i915: debugfs: show semaphore registers also on gen7
      drm/i915: fixup forcewake spinlock fallout in drpc debugfs function

Duncan Laurie (1):
      CHROMIUM: i915: Add DMI override to skip CRT initialization on ZGB

Eric Anholt (3):
      drm/i915: Print debugfs object list sizes in KiB instead of bytes.
      drm/i915: Correct debugfs printout for RC1e.
      drm/i915: Re-enable gen7 RC6 and GPU turbo after resume.

Eugeni Dodonov (2):
      drm/i915: simplify pipe checking
      drm/i915: handle 3rd pipe

Jesse Barnes (2):
      drm/i915: mask transcoder select bits before setting them on LVDS
      drm/i915: sprite init failure on pre-SNB is not a failure

Joel Sass (1):
      drm/i915: Add Clientron E830 to the ignore LVDS list

Keith Packard (5):
      Merge branch 'drm-intel-next-fixes' into drm-intel-fixes
      drm/i915: Move reset forcewake processing to gen6_do_reset
      drm/i915: Hold gt_lock during reset
      drm/i915: Hold gt_lock across forcewake register reads
      Revert "drm/i915: Work around gen7 BLT ring synchronization issues."

Paulo Zanoni (1):
      drm/i915/sdvo: always set positive sync polarity

Rodrigo Vivi (2):
      drm/i915: Fix TV Out refresh rate.
      drm/i915: Removing TV Out modes.

Rohit Jain (1):
      drm/i915: VBT Parser cleanup for eDP block

 drivers/gpu/drm/i915/i915_debugfs.c     |   31 +++++---
 drivers/gpu/drm/i915/i915_dma.c         |    1 +
 drivers/gpu/drm/i915/i915_drv.c         |   56 ++++++++++---
 drivers/gpu/drm/i915/i915_drv.h         |   10 ++-
 drivers/gpu/drm/i915/i915_irq.c         |    3 +-
 drivers/gpu/drm/i915/i915_suspend.c     |   11 ++-
 drivers/gpu/drm/i915/intel_bios.h       |    6 +-
 drivers/gpu/drm/i915/intel_crt.c        |   23 +++++
 drivers/gpu/drm/i915/intel_display.c    |   22 +++---
 drivers/gpu/drm/i915/intel_lvds.c       |    8 ++
 drivers/gpu/drm/i915/intel_ringbuffer.c |   41 ++++++----
 drivers/gpu/drm/i915/intel_sdvo.c       |    8 +-
 drivers/gpu/drm/i915/intel_sprite.c     |    8 +--
 drivers/gpu/drm/i915/intel_tv.c         |  138 ++-------------------------=
----
 14 files changed, 167 insertions(+), 199 deletions(-)


=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTyBiHzYtFsjWk68qAQg9TxAAnVKV2GF+szyh3MktS2PJ6OFeYMHZ5Qlw
EaB7nxoXp1sUxTcMNAI7AyZfqRaeuRWzDsGdJqy/EL0PEDs6Pf2ZvTWskmNYtQrc
SClu0blvizsK5LGrDJuCBJJ3PtzaQ2WBYJo30gQ8eNCbEeKv4RyXi/T0CxCYajmi
68ZPniP+mg50P+PxQdrJC4PrrOqD9zZtD5UFm1eCbFg1unHB3QGcpB32KGZqxx0e
Zzei53q8wcKomycB2BOzN45/njh2GZaSGmOmVtgCGo/uk/HbDi4WnM5l3NnNMRch
Hh3399kiCB2EEg3REe3CiAVhv6LL6LMWPI1LswA9TNP6ehTfzUZFc6ENMJwYF2KB
cfpnBiv26GWF51o7vut8Dc7MFqzENt+jGM7+T4LiTJkVytdLZviIkkhWXRNQXBlB
ZR2Whciurx7YChZYcGCGsuz0bDNnildS0HGKOZaol7H72BEHH54x5VugjhArArlq
KWjxrv3mOWKkp+SWfoyxzGQ9pePcKS6eIhJt1g/jV2WCvDb7PG7Yw4MvnMd0+AKX
3OUxVXzARYU9H4FPzQa+8GLZFYSopauEkb/vCZmMa7e5eyINggEQE+2DLo0yzGfy
wCEe2ZUlVnX643xhunlF7ORBZN7qitU6I4XQ0q3rifluI0fdFJdheclF/ZEc1Jll
rn+GtoXw6JE=
=HpaK
-----END PGP SIGNATURE-----
--=-=-=--
