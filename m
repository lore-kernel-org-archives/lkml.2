Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab1EOVaD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 17:30:03 -0400
Received: from home.keithp.com ([63.227.221.253]:49455 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab1EOVaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 17:30:00 -0400
From: "Keith Packard" <keithp@keithp.com>
To: Dave Airlie <airlied@linux.ie>
Subject: [PULL] drm-intel-next
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Date: Sun, 15 May 2011 14:29:55 -0700
Message-ID: <yunr57z3b58.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


Here's most of the patches I'm hoping to land in 2.6.40:

 * Ivybridge support (Gen7)
 * Forcewake fixes for Sandybridge (And ivybridge).
 * Temporary FB for load detect (hoping for some cleanups here)

Still pending:

 * More modesetting cleanups (as always)
 * Disabling FBC on Ironlake to enable RC6 instead

This sequence also assigns me as the the drm/i915 maintainer.

The following changes since commit 2fb4e61d9471867677c97bf11dba8f1e9dfa7f7c:

  drm/i915/lvds: Only act on lid notify when the device is on (2011-05-09 0=
9:13:22 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/keithp/linux-2.6.git drm-in=
tel-next

Ben Widawsky (10):
      drm/i915: fix ilk rc6 teardown locking
      drm/1915: ringbuffer wait for idle function
      drm/i915: fix rc6 initialization on Ironlake
      drm/i915: debugfs for context information
      drm/i915: proper use of forcewake
      drm/i915: reference counted forcewake
      drm/i915: forcewake struct mutex locking fixes
      drm/i915: move gen6 rps handling to workqueue
      drm/i915: debugfs interface for forcewake reference count
      drm/i915: forcewake debugfs fix

Chris Wilson (12):
      drm/i915: Move the irq wait queue initialisation into the ring init
      drm/i915: Simplify return value from intel_get_load_detect_pipe
      drm/i915: Propagate failure to set mode for load-detect pipe
      drm/i915: Don't store temporary load-detect variables in the generic =
encoder
      drm/i915: Remove unused supported_crtc from intel_load_detect_pipe
      drm/i915: Pass the saved adjusted_mode when adding to the load-detect=
 crtc
      drm/i915: Remove dead code from intel_get_load_detect_pipe()
      drm/i915: Remove dead code from intel_release_load_detect_pipe()
      drm/i915: Attach a fb to the load-detect pipe
      drm/i915: Rename agp_type to cache_level
      drm/i915: Do not clflush snooped objects
      drm/i915: Disable all outputs early, before KMS takeover

Eric Anholt (12):
      drm/i915: Split the crtc_mode_set function along HAS_PCH_SPLIT() line=
s.
      drm/i915: Move the vblank pre/post modeset to the common crtc_mode_se=
t.
      drm/i915: Remove the PCH paths from the pre-Ironlake crtc_mode_set().
      drm/i915: Drop the eDP paths from the pre-Ironlake crtc_mode_set.
      drm/i915: Drop the remaining bit of Ironlake code from i9xx_crtc_mode=
_set().
      drm/i915: Drop non-HAS_PCH_SPLIT() code from ironlake_crtc_mode_set().
      drm/i915: Drop remaining pre-Ironlake code from ironlake_crtc_mode_se=
t().
      drm/i915: Clean up leftover DPLL and LVDS register choice from pch sp=
lit.
      drm/i915: Fold the DPLL limit defines into the structs that use them.
      drm/i915: Use existing function instead of open-coding fence reg clea=
r.
      drm/i915: Add support for fence registers on Ivybridge.
      drm/i915: Update the location of the ringbuffers' HWS_PGA registers f=
or IVB.

Jesse Barnes (20):
      drm/i915: use i915_enable_rc6 on SNB too
      drm/i915: make FDI training a display function
      drm/i915: split irq handling into per-chipset functions
      drm/i915: split enable/disable vblank code into chipset specific func=
tions
      drm/i915: add IS_GEN7 macro to cover Ivy Bridge and later
      drm/i915: add IS_IVYBRIDGE macro for checks
      drm/i915: Ivy Bridge has split display and pipe control
      drm/i915: add swizzle/tiling support for Ivy Bridge
      drm/i915: manual FDI training for Ivy Bridge
      drm/i915: treat Ivy Bridge watermarks like Sandy Bridge
      drm/i915: interrupt & vblank support for Ivy Bridge
      drm/i915: page flip support for Ivy Bridge
      drm/i915: ring support for Ivy Bridge
      agp/intel: add Ivy Bridge support
      drm/i915: add PantherPoint PCH ID
      drm/i915: add Ivy Bridge PCI IDs and driver feature structs
      drm/i915: set IBX pch type explicitly
      drm/i915: split clock gating init into per-chipset functions
      drm/i915: add Ivybridge clock gating init function
      drm/i915: split PCH clock gating init

Keith Packard (1):
      MAINTAINERS: Switch maintainer for drm/i915 to Keith Packard

 MAINTAINERS                             |    4 +-
 drivers/char/agp/intel-agp.c            |    3 +
 drivers/char/agp/intel-agp.h            |    8 +
 drivers/char/agp/intel-gtt.c            |   10 +
 drivers/gpu/drm/i915/i915_debugfs.c     |  128 ++-
 drivers/gpu/drm/i915/i915_dma.c         |   60 +-
 drivers/gpu/drm/i915/i915_drv.c         |   61 +-
 drivers/gpu/drm/i915/i915_drv.h         |  111 +-
 drivers/gpu/drm/i915/i915_gem.c         |   36 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c     |   35 +-
 drivers/gpu/drm/i915/i915_gem_tiling.c  |    2 +-
 drivers/gpu/drm/i915/i915_irq.c         |  310 ++++-
 drivers/gpu/drm/i915/i915_reg.h         |   35 +-
 drivers/gpu/drm/i915/i915_suspend.c     |    3 +-
 drivers/gpu/drm/i915/intel_crt.c        |   24 +-
 drivers/gpu/drm/i915/intel_display.c    | 2370 ++++++++++++++++++---------=
----
 drivers/gpu/drm/i915/intel_drv.h        |   19 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c |   38 +-
 drivers/gpu/drm/i915/intel_ringbuffer.h |   35 +-
 drivers/gpu/drm/i915/intel_tv.c         |   13 +-
 20 files changed, 2124 insertions(+), 1181 deletions(-)


=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFN0EXTQp8BWwlsTdMRAvCSAKCMk6R63HeOORDJN/HQfpqCSCDbXgCg2n9K
azgmItDTHnbo/ohA7WcFlP0=
=Es+5
-----END PGP SIGNATURE-----
--=-=-=--
