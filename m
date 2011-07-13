Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab1GMQjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 12:39:47 -0400
Received: from home.keithp.com ([63.227.221.253]:38466 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756183Ab1GMQjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 12:39:46 -0400
From: "Keith Packard" <keithp@keithp.com>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        Intel drivers <Intel-gfx@lists.freedesktop.org>
Subject: [PULL] drm-intel-next
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 13 Jul 2011 09:39:41 -0700
Message-ID: <yunoc0y9lte.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


Here's most of the patches I'm hoping to land after 3.0:

 * FBC cleanups from Chris Wilson. Fixes 'missing' CPU writes to the
   front buffer. We've enabled FBC by default, if we find regressions
   again, we'll turn it off before the release.

 * DP and HDMI support for formats other than 8bpc from Jesse
   Barnes. Supports depth 30 frame buffers at 10bpc.

 * Shared LLC support (SNB, IVB) from Eric Anholt and Chris
   Wilson. Shares the LLC between CPU and GPU, avoiding main memory
   traffic latencies.

 * Ring frequency scaling (SNB, IVB) from Jesse Barnes. This makes
   memory bus speed track the GPU clock in addition to the CPU clock,
   keeping memory running at full speed when the GPU is busy and the CPU
   is idle.

 * Disable hangcheck module parameter from Ben Widawsky. This exports a
   module parameter to keep the kernel from resetting the GPU. It's
   useful for GPU debugging where the GPU may be stuck waiting for the
   debugger.

The following changes since commit a94919eaddaa3fede1df8563ce4d761a75374645:

  drm/i915/ringbuffer: Idling requires waiting for the ring to be empty (20=
11-07-12 10:35:45 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/keithp/linux-2.6.git drm=
-intel-next

Ben Widawsky (1):
      drm/i915: hangcheck disable parameter

Chris Wilson (14):
      drm/i915: Introduce i915_gem_object_finish_gpu()
      drm/i915: Introduce i915_gem_object_finish_gtt()
      drm/i915/gtt: Split out i915_gem_gtt_rebind_object()
      drm/i915: Add an interface to dynamically change the cache level
      drm/i915: Mark the cursor and the overlay as being part of the displa=
y planes
      drm/i915: Combine pinning with setting to the display plane
      drm/i915: Only export the generic intel_disable_fbc() interface
      drm/i915: Replace direct calls to vfunc.disable_fbc with intel_disabl=
e_fbc()
      drm/i915: Remove vestigial pitch from post-gen2 FBC control routines
      drm/i915: Use of a CPU fence is mandatory to update FBC regions upon =
CPU writes
      drm/i915: Set persistent-mode for ILK/SNB framebuffer compression
      drm/i915: Disable FBC across page-flipping
      drm/i915: Perform intel_enable_fbc() from a delayed task
      drm/i915: Share the common work of disabling active FBC before updati=
ng

Eric Anholt (2):
      drm/i915: Use the uncached domain for the display planes
      drm/i915: Use the LLC mode on gen6 for everything but display.

Hugh Dickins (1):
      drm/i915: more struct_mutex locking

Jesse Barnes (13):
      cpufreq: expose a cpufreq_quick_get_max routine
      drm/i915: load a ring frequency scaling table v3
      drm/i915: enable ring freq scaling, RC6 and graphics turbo on Ivy Bri=
dge v3
      drm/i915: don't set SDVO color range on ILK+
      drm/i915: don't set transcoder bpc on CougarPoint
      drm/i915: set bpc for DP transcoder
      drm/i915: split out Ironlake pipe bpp picking code
      drm/i915: split out plane update code
      drm/i915: use pipe bpp in DP link bandwidth calculations
      drm/i915: use pipe bpp when setting HDMI bpc
      drm: bpp and depth changes require full mode sets
      drm/i915: check for supported depth at fb init time
      drm/i915: use pipe bpp in DP link bandwidth calculation

Keith Packard (14):
      drm/i915: i915_gem_object_finish_gtt must always release gtt mmap
      drm/i915: Enable i915 frame buffer compression by default

 drivers/cpufreq/cpufreq.c               |   20 +
 drivers/gpu/drm/drm_crtc_helper.c       |    5 +
 drivers/gpu/drm/i915/i915_debugfs.c     |   41 ++-
 drivers/gpu/drm/i915/i915_dma.c         |    4 +-
 drivers/gpu/drm/i915/i915_drv.c         |    5 +-
 drivers/gpu/drm/i915/i915_drv.h         |   27 +-
 drivers/gpu/drm/i915/i915_gem.c         |  191 ++++++++--
 drivers/gpu/drm/i915/i915_gem_gtt.c     |   39 +-
 drivers/gpu/drm/i915/i915_irq.c         |   13 +-
 drivers/gpu/drm/i915/i915_reg.h         |    5 +-
 drivers/gpu/drm/i915/i915_suspend.c     |    8 +-
 drivers/gpu/drm/i915/intel_display.c    |  699 +++++++++++++++++++++++----=
----
 drivers/gpu/drm/i915/intel_dp.c         |   17 +-
 drivers/gpu/drm/i915/intel_drv.h        |    9 +
 drivers/gpu/drm/i915/intel_hdmi.c       |    8 +-
 drivers/gpu/drm/i915/intel_overlay.c    |    6 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c |    6 +-
 include/linux/cpufreq.h                 |    5 +
 18 files changed, 842 insertions(+), 266 deletions(-)


=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOHcpNQp8BWwlsTdMRAkJIAJ4naE64fwfovGDQYm1dqlT39eT24gCgrnd+
g4mW+cWpzZsINi8nLGUflxM=
=A1MQ
-----END PGP SIGNATURE-----
--=-=-=--
