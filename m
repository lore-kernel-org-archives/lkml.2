Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab0DPRrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 13:47:16 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:36581 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702Ab0DPRrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 13:47:14 -0400
From: Eric Anholt <eric@anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] drm-intel fixes for 2.6.34-rc2
Date: Fri, 16 Apr 2010 10:47:11 -0700
Message-ID: <87k4s770io.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

The following changes since commit 01e77706cdde7c0b47e5ca1f4284a795504c7c40:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://gitorious.org/linux-omap-dss2/linux

OK, this is sort of a test pull request to you.  I've heard that big
entirely-mechanical changes are accepted during release cycle to avoid
conflicts during merging.  There are two of them here: "Rename
intel_output to intel_encoder" (done with sed) and "introduce
to_intel_bo helper" (I suspect the same).  The first is prep for the
multi-function SDVO cards that some embedded devices are using, and the
other is prep to cut out a pointless pointer in the GEM objects, of
which normal systems will have hundreds to thousands.  This seems like a
good time to land these patches, since .34 -> .33 cherry-picking is
about done, and it'll make .35 -> .34 easy.

If what I've heard is wrong, I can go rebase these guys out.  The other
changes are small and pretty well tested at this point -- I've had them
in the tree for a while and I rebased out a patch people complained
about.

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel for-linus

Daniel Vetter (2):
      drm/i915: introduce to_intel_bo helper
      agp/intel: intel_845_driver is an agp driver!

Eric Anholt (2):
      drm/i915: Rename intel_output to intel_encoder.
      drm/i915: Rename many remaining uses of "output" to encoder or connector.

Robert Hooker (1):
      drm/i915: Disable FBC on 915GM and 945GM.

Stefan Bader (1):
      drm/i915: Add no_lvds entry for the Clientron U800

Zhao Yakui (1):
      drm/i915: Ignore LVDS EDID when it is unavailabe or invalid

 drivers/char/agp/intel-agp.c           |    3 -
 drivers/gpu/drm/i915/i915_debugfs.c    |    2 +-
 drivers/gpu/drm/i915/i915_drv.c        |    6 +-
 drivers/gpu/drm/i915/i915_drv.h        |    4 +
 drivers/gpu/drm/i915/i915_gem.c        |  132 +++---
 drivers/gpu/drm/i915/i915_gem_debug.c  |    4 +-
 drivers/gpu/drm/i915/i915_gem_tiling.c |   10 +-
 drivers/gpu/drm/i915/i915_irq.c        |    8 +-
 drivers/gpu/drm/i915/intel_crt.c       |   68 ++--
 drivers/gpu/drm/i915/intel_display.c   |   96 ++--
 drivers/gpu/drm/i915/intel_dp.c        |  256 ++++++------
 drivers/gpu/drm/i915/intel_drv.h       |   18 +-
 drivers/gpu/drm/i915/intel_dvo.c       |   92 ++--
 drivers/gpu/drm/i915/intel_fb.c        |    2 +-
 drivers/gpu/drm/i915/intel_hdmi.c      |   86 ++--
 drivers/gpu/drm/i915/intel_lvds.c      |   81 ++--
 drivers/gpu/drm/i915/intel_modes.c     |   22 +-
 drivers/gpu/drm/i915/intel_overlay.c   |    6 +-
 drivers/gpu/drm/i915/intel_sdvo.c      |  731 ++++++++++++++++----------------
 drivers/gpu/drm/i915/intel_tv.c        |   96 ++--
 20 files changed, 871 insertions(+), 852 deletions(-)

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvIop8ACgkQHUdvYGzw6veM5gCffacOMYQa8LxCT6S/4AUUVlhU
dFYAnRIqTIr/T6XDSVVuh9arFMBxWoKJ
=35o5
-----END PGP SIGNATURE-----
--=-=-=--
