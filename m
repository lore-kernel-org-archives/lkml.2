Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab1HDDOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 23:14:37 -0400
Received: from home.keithp.com ([63.227.221.253]:56398 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756188Ab1HDDOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 23:14:30 -0400
From: "Keith Packard" <keithp@keithp.com>
To: Dave Airlie <airlied@linux.ie>
Subject: [PULL] drm-intel-next
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        Intel drivers <Intel-gfx@lists.freedesktop.org>
Date: Wed, 03 Aug 2011 20:14:25 -0700
Message-ID: <yunhb5xlvfy.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


Here's a pile of fixes on top of the stuff already in drm-core-next.

 * Pile of mode setting fixes which eliminate a selection of bugs and
   other annoyances. Eliminates the 'stripey' effect when going from
   two to one monitor, makes hot-plug work after suspend/resume, turns
   off the pipe/plane in DPMS off.

 * DP mode setting cleanups and pessimizations that should recover from
   unexpected situations better.

 * HDMI info frame changes, including the addition of SPD (source
   product description) frames.

 * RC6 enabled by default (again). Given that we don't understand why it
   doesn't work, and that we've found and fixed at least a couple of
   RC6-related bugs, maybe it works now? Prepare to see this reverted
   before 3.1 if we get regression reports (sigh).

The following changes since commit 5a96a899bbdee86024ab9ea6d02b9e242faacbed

  Merge branch 'drm-core-next' of git://git.kernel.org/pub/scm/linux/kernel=
/git/airlied/drm-2.6 (2011-07-26 09:21:09 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/keithp/linux-2.6.git drm=
-intel-next

Adam Jackson (10):
      drm/i915/dp: Zero the DPCD data before connection probe
      drm/i915/dp: Move DPCD dump to common code instead of PCH-only
      drm/i915/dp: Read more DPCD registers on connection probe
      drm/i915/dp: Better hexdump of DPCD
      drm/i915/dp: Retry DPCD fetch on G4X too
      drm/i915/dp: Explicitly request 8/10 channel coding
      drm/i915/pch: Fix integer math bugs in panel fitting
      drm/i915/dp: Explicitly disable symbol scrambling while training
      drm/i915/dp: Don't turn CPT DP ports on too early
      drm/i915/pch: Save/restore PCH_PORT_HOTPLUG across suspend

Jesse Barnes (15):
      drm/i915: provide more error output when mode sets fail
      drm/i915: load the LUT before pipe enable on ILK+
      drm/i915: apply timing generator bug workaround on CPT and PPT
      drm/i915: flush plane control changes on ILK+ as well
      drm/i915: fix CB tuning check for ILK+
      drm/i915/hdmi: send AVI info frames on ILK+ as well
      drm/i915: add GPU max frequency control file
      drm/i915: provide more error output when mode sets fail
      drm/i915: apply phase pointer override on SNB+ too
      drm/i915: don't use uninitialized EDID bpc values when picking pipe b=
pp
      drm/i915/dp: wait for previous AUX channel activity to clear
      drm: track CEA version number if present
      drm/i915/hdmi: split infoframe setting from infoframe type code
      drm/i915/hdmi: HDMI source product description infoframe support
      drm/i915: allow cache sharing policy control

Keith Packard (14):
      drm/i915: Skip GPU wait for scanout pin while wedged
      drm/i915: Initialize RCS ring status page address in intel_render_rin=
g_init_dri
      drm/i915: Hold mode_config->mutex during hotplug processing
      drm/i915: Fixup for 'Hold mode_config->mutex during hotplug'
      drm/i915: Use dp_detect_common in hotplug helper function
      drm/i915: Rename i915_dp_detect_common to intel_dp_get_dpcd
      drm/i915: In intel_dp_init, replace read of DPCD with intel_dp_get_dp=
cd
      drm/i915: DP_PIPE_ENABLED must check transcoder on CPT
      Revert and fix "drm/i915/dp: remove DPMS mode tracking from DP"
      drm/i915: Set crtc DPMS mode to ON in intel_crtc_mode_set
      drm/i915: Flush other plane register writes
      drm/i915: Ignore GPU wedged errors while pinning scanout buffers
      Revert "drm/i915/dp: Zero the DPCD data before connection probe"
      drm/i915: Try enabling RC6 by default (again)

Michel Alexandre Salim (1):
      drm/i915: Add quirk to disable SSC on Sony Vaio Y2

Ole Henrik Jahren (1):
      drm/i915: Fix typo in DRM_I915_OVERLAY_PUT_IMAGE ioctl define

Pieterjan Camerlynck (1):
      i915: add Dell OptiPlex FX170 to intel_no_lvds

 drivers/gpu/drm/drm_edid.c              |    9 ++
 drivers/gpu/drm/i915/i915_debugfs.c     |  189 +++++++++++++++++++++++++++=
++++
 drivers/gpu/drm/i915/i915_dma.c         |    6 +-
 drivers/gpu/drm/i915/i915_drv.c         |    2 +-
 drivers/gpu/drm/i915/i915_drv.h         |    1 +
 drivers/gpu/drm/i915/i915_gem.c         |    2 +-
 drivers/gpu/drm/i915/i915_irq.c         |    3 +
 drivers/gpu/drm/i915/i915_reg.h         |   36 ++++++-
 drivers/gpu/drm/i915/i915_suspend.c     |    2 +
 drivers/gpu/drm/i915/intel_display.c    |  138 ++++++++++++++++++-----
 drivers/gpu/drm/i915/intel_dp.c         |  111 ++++++++++++-------
 drivers/gpu/drm/i915/intel_drv.h        |   23 ++++
 drivers/gpu/drm/i915/intel_hdmi.c       |  158 ++++++++++++++++++++++----
 drivers/gpu/drm/i915/intel_lvds.c       |    8 ++
 drivers/gpu/drm/i915/intel_panel.c      |    4 +
 drivers/gpu/drm/i915/intel_ringbuffer.c |    3 +
 include/drm/drm_crtc.h                  |    2 +
 include/drm/i915_drm.h                  |    2 +-
 18 files changed, 594 insertions(+), 105 deletions(-)

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOOg6RQp8BWwlsTdMRAlDRAKDZeZhe1/bhGV8hKOlZYnqTPyGYqACeOp1V
j1W179MtzVpT5HMIxhyFM2A=
=kFwu
-----END PGP SIGNATURE-----
--=-=-=--
