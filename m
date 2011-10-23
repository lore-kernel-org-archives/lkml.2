Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab1JWH1t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 03:27:49 -0400
Received: from home.keithp.com ([63.227.221.253]:38078 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474Ab1JWH1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 03:27:48 -0400
From: "Keith Packard" <keithp@keithp.com>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        Intel drivers <Intel-gfx@lists.freedesktop.org>
Subject: [PULL] drm-intel-next
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sun, 23 Oct 2011 00:27:42 -0700
Message-ID: <yunfwikb21d.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


Here's a pile of new code for the 3.2 series.

Overview:

 * 3 pipe support for IVB.
 * eDP fixes for SNB
 * Interrupt race condition fixes
 * Switch from MI_FLUSH to PIPECONTROL
 * VT-d work-around for ILK

The following changes since commit 0ac225e56997ef89f46eb51b02799a685b78f214:

  Merge branch 'drm-intel-fixes' into drm-intel-next (2011-09-28 14:44:38 -=
0700)

are available in the git repository at:

  git://people.freedesktop.org/~keithp/linux drm-intel-next

Adam Jackson (8):
      drm/i915: Remove "i2c_speed" nonsense from child device table
      drm/i915: Fix multifunction SDVO detection
      drm/i915: Rename intel_sdvo_hdmi_sink_detect
      drm/i915: Remove redundant bit shifting from intel_gmbus_set_speed
      drm/i915/dp: Fix the math in intel_dp_link_required
      drm/i915/dp: Remove eDP special cases from bandwidth checks
      drm/i915/dp: Introduce is_cpu_edp()
      drm/i915/dp: Fix eDP on PCH DP on CPT/PPT

Andi Kleen (1):
      i915: Move i915_read/write out of line

Ben Widawsky (3):
      drm/i915: Remove early exit on i915_gpu_idle
      drm/i915: ILK + VT-d workaround
      drm: Add Panel Self Refresh DP addresses

Chris Wilson (1):
      drm/i915: Defend against userspace creating a gem object with size=3D=
=3D0

Daniel Vetter (7):
      drm/i915: close PM interrupt masking races in the irq handler
      drm/i915: close PM interrupt masking races in the rps work func
      drm/i915: properly cancel rps_work on module unload v2
      drm/i915: fix swizzling on gen6+
      drm/i915: simplify swapin/out swizzle checking a bit
      io-mapping: ensure io_mapping_map_atomic _is_ atomic
      drm/i915: drop KM_USER0 argument to k(un)map_atomic

David Woodhouse (2):
      intel-iommu: Workaround IOTLB hang on Ironlake GPU
      intel-iommu: Export a flag indicating that the IOMMU is used for iGFX.

Jesse Barnes (19):
      drm/i915: Use PIPE_CONTROL for flushing on gen6+.
      drm/i915: always set FDI composite sync bit
      drm/i915: PLL macro cleanup and pipe assertion check
      drm/i915: support 3 pipes on IVB+
      drm/i915: split refclk code out of ironlake_crtc_mode_set
      drm/i915: use transcoder select bits on VGA and HDMI on CPT
      drm/i915: fix PCH PLL assertion check for 3 pipes
      drm/i915: add PLL sharing support to handle 3 pipes
      drm/i915: fix debug output for 3 pipe configs
      drm/i915: fix IVB cursor support
      drm/i915: fix transcoder PLL select masking
      drm/i915: export a CPT mode set verification function
      drm/i915: set watermarks for third pipe on IVB
      drm/i915: if transcoder disable fails, say which
      drm/i915: remove transcoder PLL mashing from mode_set per specs
      drm/i915: read full receiver capability field during DP hot plug
      drm/i915: add DP test request handling
      drm/i915: fix ILK+ infoframe support
      drm/i915: use correct SPD type value

Keith Packard (30):
      drm/i915: broken copyright encoding in intel_bios.c
      drm/i915: Use DRM_DEBUG_KMS for all messages in intel_bios.c
      drv/i915: Pull display_clock_mode out of VBT table
      drm/i915: Document a few more BDB_GENERAL_FEATURES bits from PCH BIOS
      drm/i915: Allow SSC parameter to override VBT value
      drm/i915: Fix PCH SSC reference clock settings
      drm/i915: Use CK505 as non-SSC source where available
      drm/i915: All PCH refclks are 120MHz
      drm/i915: Initialize PCH refclks at modeset init time
      drm/i915: Enable digital port hotplug on PCH systems
      drm/i915: Shut down PCH interrupts during irq_uninstall
      drm/i915: Only use VBT panel mode on eDP if no EDID is found
      drm/i915: Check eDP power when doing aux channel communications
      drm/i915: Unlock PCH_PP_CONTROL always
      drm/i915: Check for eDP inside edp panel on/off funcs
      drm/i915: Turn force VDD back off when panel running in intel_dp_dpms
      drm/i915: Ensure panel is on during DPMS off
      drm/i915: Delay DP i2c initialization until panel power timings are c=
omputed
      drm/i915: Wrap DP EDID fetch functions to enable eDP panel power
      drm/i915: Enable eDP panel power during I2C initialization sequence
      drm/i915: Ensure eDP powered up during DP_SET_POWER operation in dp_p=
repare
      drm/i915: Correct eDP panel power sequencing delay computations
      drm/i915: Move eDP panel fixed mode from dev_priv to intel_dp
      drm/i915: edp_panel_on does not need to return a bool
      drm/i915: Create helper functions to determine eDP power state
      drm/i915: Disable eDP VDD in a delayed work proc instead of synchrono=
usly
      drm/i915: Restrict ILK-specific eDP power hack to ILK
      drm/i915: No need to wait for eDP power off delay if panel is on
      Merge branch 'edp-training-fixes' into drm-intel-next
      Merge branch 'fix-pch-refclk' into foo

Kenneth Graunke (2):
      drm/i915: Remove implied length of 2 from GFX_OP_PIPE_CONTROL #define.
      drm/i915: Rename PIPE_CONTROL bit defines to be less terse.

Takashi Iwai (1):
      drm/i915/panel: Always record the backlight level again (but cleverly)

 drivers/char/agp/intel-gtt.c            |   28 ++
 drivers/gpu/drm/i915/i915_dma.c         |    4 +-
 drivers/gpu/drm/i915/i915_drv.c         |   47 +++-
 drivers/gpu/drm/i915/i915_drv.h         |   31 +--
 drivers/gpu/drm/i915/i915_gem.c         |   16 +-
 drivers/gpu/drm/i915/i915_gem_debug.c   |    6 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c     |   30 ++
 drivers/gpu/drm/i915/i915_gem_tiling.c  |   15 +-
 drivers/gpu/drm/i915/i915_irq.c         |   36 ++-
 drivers/gpu/drm/i915/i915_reg.h         |   65 +++-
 drivers/gpu/drm/i915/intel_bios.c       |   19 +-
 drivers/gpu/drm/i915/intel_bios.h       |   20 +-
 drivers/gpu/drm/i915/intel_crt.c        |   18 +-
 drivers/gpu/drm/i915/intel_display.c    |  409 +++++++++++++++------
 drivers/gpu/drm/i915/intel_dp.c         |  588 +++++++++++++++++++++++----=
----
 drivers/gpu/drm/i915/intel_drv.h        |    7 +-
 drivers/gpu/drm/i915/intel_hdmi.c       |   30 +-
 drivers/gpu/drm/i915/intel_i2c.c        |    8 +-
 drivers/gpu/drm/i915/intel_lvds.c       |    8 +-
 drivers/gpu/drm/i915/intel_panel.c      |   21 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c |  150 +++++++-
 drivers/gpu/drm/i915/intel_sdvo.c       |   21 +-
 drivers/iommu/intel-iommu.c             |   31 +-
 include/drm/drm_dp_helper.h             |   61 ++++
 include/drm/intel-gtt.h                 |    2 +
 include/linux/io-mapping.h              |    4 +
 26 files changed, 1244 insertions(+), 431 deletions(-)


=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTqPB7jYtFsjWk68qAQhgGxAAribnoWkGu2GElly7hOJ5BFj1Wd2HQhCW
fp2uHnKwF3OTsUFJwiWvUw0Tuh6ZXvRt5Mx9MyXWpgb7aEOTcUyFNFs/ex3v9BjA
XNToDBMOCBsLbrl47JonuyhAxh4n2qnihQhsWExD7wKaPpHpdj7Q6PqwoSZytyYv
WJAeDzb/JdJ4EErzP1W52TeK6RVGtzH+h1H4PKUdJK2DTTzWmvQ08rbpLYcXIe6Q
gwzSgXDelydXKYCchhmmOh8STiOe+u8O9muZHKcFlK/Rih2YdT4PUeeyZ6gp2lWU
Hsfm1YSEBwL/2s1YDSecePSJbY9ASMGtOaohC6xyT+S2UCb2j6nebnO5MvbxZqWe
YzXJYqV1JI1zjtmcycW9MwBRlxAarwMDOioDjBzXsiByd/mmO3qpm2VFHgHcPdYk
Q1TP2x+E9DLcgEWgfDKWbgDXDMv6ZDOFe+6h3/+Yqx7RYoRWXNA6CtxEL4k6QxXp
klp8cUcZKudxUCiNVhHeNTBhS3+Qi6n0aj+wmZhINbTIDnkLmD9Y233Z3xRNzr9R
AwrP7BQZtOOMxT9oEk8mNWROnhaI0r+rXs9KbJaLk0nDazilIFq0S5NU7aCMVtPP
7KA/fi8ZDkj+8QaBA7uDilUe0po3RvdnkuNw2JP1EjTLV26Pwu/LYv5ntkwA0Y3Q
TY33kAADNEE=
=Ygex
-----END PGP SIGNATURE-----
--=-=-=--
