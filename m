Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab1HOTa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 15:30:29 -0400
Received: from home.keithp.com ([63.227.221.253]:36148 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091Ab1HOTa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 15:30:28 -0400
From: "Keith Packard" <keithp@keithp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] drm-intel-fixes (drm/i915 driver)
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org
Date: Mon, 15 Aug 2011 12:30:24 -0700
Message-ID: <yuny5yuwjzj.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


Two bug fixes, a new platform backlight driver and a bit of debug output
for IVB interrupts:

 * Dual-display mode setting manipulations on SNB machines would sometimes
   accidentally turn off all outputs.

 * Attempts to use UMS would segfault in the kernel and generate a pile
   of spurious kernel diagnostics. Detecting a few more KMS-only
   features in the general paths fixes this.

 * Expose a native backlight driver for machines that don't bother to
   have suitable platform or ACPI drivers.

 * Share an SNB interrupt debug function for IVB.

The following changes since commit 322a8b034003c0d46d39af85bf24fee27b902f48:

  Linux 3.1-rc1 (2011-08-07 18:23:30 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/keithp/linux-2.6.git drm=
-intel-fixes

Jesse Barnes (2):
      drm/i915: show interrupt info on IVB
      drm/i915: split out PCH refclk update code

Keith Packard (6):
      drm/i915: Wait for LVDS panel power sequence
      drm/i915: Leave LVDS registers unlocked
      drm/i915: Fix PCH port pipe select in CPT disable paths
      drm/i915: Remove unused 'reg' argument to dp_pipe_enabled
      drm/i915: Can't do accurate vblank timestamps with UMS
      drm/i915: Cannot set clock gating under UMS

Matthew Garrett (1):
      Not all systems expose a firmware or platform mechanism for changing =
the backlight intensity on i915, so add native driver support.

 drivers/gpu/drm/i915/i915_debugfs.c   |    2 +-
 drivers/gpu/drm/i915/i915_drv.h       |    4 +
 drivers/gpu/drm/i915/i915_irq.c       |    6 +-
 drivers/gpu/drm/i915/i915_reg.h       |   13 +--
 drivers/gpu/drm/i915/i915_suspend.c   |    3 +-
 drivers/gpu/drm/i915/intel_display.c  |  187 +++++++++++++++++++++++------=
---
 drivers/gpu/drm/i915/intel_dp.c       |    7 ++
 drivers/gpu/drm/i915/intel_drv.h      |    3 +-
 drivers/gpu/drm/i915/intel_lvds.c     |   82 ++++++--------
 drivers/gpu/drm/i915/intel_opregion.c |    1 -
 drivers/gpu/drm/i915/intel_panel.c    |   72 +++++++++++++-
 11 files changed, 264 insertions(+), 116 deletions(-)

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOSXPQQp8BWwlsTdMRAm+kAKDgi+MDH+o0m6k+flcpIBenCGaR3wCaA5L8
pDWUBPCdnYlnUU+jI9qAOZw=
=0vaW
-----END PGP SIGNATURE-----
--=-=-=--
