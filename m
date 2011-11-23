Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab1KWJyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 04:54:31 -0500
Received: from gir.skynet.ie ([193.1.99.77]:59070 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924Ab1KWJy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 04:54:29 -0500
Date: Wed, 23 Nov 2011 09:56:27 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1111230954160.23906@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-275782521-1322042187=:23906"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-275782521-1322042187=:23906
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Keith finally decloaked and sent me his -fixes queue so this is mostly 
that along with some radeon i2c fixes/cleanups, a radeon fix for some 
userspace problems and a couple of drm core and vga arb fixes.

I have some exynos changes I might send separatly to you, as that driver 
only went in during the merge window so it not like they can really cause 
any regressions.

Dave.

The following changes since commit 6991b8f2a3193397461104a27be417addb8d032b:

  drm/radeon/kms: fix segfault in pm rework (2011-11-15 19:44:03 +0000)

are available in the git repository at:
  git://people.freedesktop.org/~airlied/linux drm-fixes

Adam Jackson (1):
      drm/i915: intel_choose_pipe_bpp_dither messages should be DRM_DEBUG_KMS

Alex Deucher (2):
      drm/radeon/kms: fix up gpio i2c mask bits for r4xx for real
      drm/radeon/kms/atom: unify i2c gpio table handling

Ben Widawsky (1):
      drm/i915: forcewake warning fixes in debugfs

Dan Carpenter (1):
      drm/i915: fix if statement (bogus semi-colon)

Daniel Vetter (4):
      drm/i915: disable temporal dithering on the internal panel
      drm/i915: only match on PCI_BASE_CLASS_DISPLAY
      drm/i915: Ivybridge still has fences!
      drm/i915: add constants to size fence arrays and fields

Dave Airlie (1):
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~keithp/linux into drm-fixes

Eric Anholt (3):
      drm/i915: Fix object refcount leak on mmappable size limit error path.
      drm/i915: Turn on a required 3D clock gating bit on Sandybridge.
      drm/i915: Turn on another required clock gating bit on gen6.

Jesse Barnes (1):
      drm/i915: enable cacheable objects on Ivybridge

Julia Lawall (1):
      drivers/gpu/vga/vgaarb.c: add missing kfree

Keith Packard (12):
      agp: iommu_gfx_mapped only available if CONFIG_INTEL_IOMMU is set
      drm/i915: Use mode_config.mutex in ironlake_panel_vdd_work
      drm/i915: Module parameters using '-1' as default must be signed type
      drm/i915: Move common PCH_PP_CONTROL setup to ironlake_get_pp_control
      drm/i915: Remove link_status field from intel_dp structure
      drm/i915: Treat PCH eDP like DP in most places
      drm/i915: Let panel power sequencing hardware do its job
      drm/i915: Make DP prepare/commit consistent with DP dpms
      drm/i915: Try harder during dp pattern 1 link training
      drm/i915: Remove trailing white space
      drm/i915: Initiate DP link training only on the lanes we'll be using
      drm/i915: Use DPCD value for max DP lanes.

Marek Ol¨ák (1):
      drm/radeon/kms: add a CS ioctl flag not to rewrite tiling flags in the CS

Rakib Mullick (1):
      drm, i915: Fix memory leak in i915_gem_busy_ioctl().

Takashi Iwai (1):
      drm/i915: Fix inconsistent backlight level during disabled

Thomas Hellstrom (1):
      ttm: Don't return the bo reserved on error path

Xi Wang (1):
      drm: integer overflow in drm_mode_dirtyfb_ioctl()

 drivers/gpu/drm/drm_crtc.c               |    4 +
 drivers/gpu/drm/i915/i915_debugfs.c      |   57 ++++-
 drivers/gpu/drm/i915/i915_drv.c          |    6 +-
 drivers/gpu/drm/i915/i915_drv.h          |   19 +-
 drivers/gpu/drm/i915/i915_gem.c          |   12 +-
 drivers/gpu/drm/i915/i915_irq.c          |    1 +
 drivers/gpu/drm/i915/i915_reg.h          |   21 ++-
 drivers/gpu/drm/i915/i915_suspend.c      |    2 +
 drivers/gpu/drm/i915/intel_display.c     |   33 ++-
 drivers/gpu/drm/i915/intel_dp.c          |  411 +++++++++++++++++-------------
 drivers/gpu/drm/i915/intel_panel.c       |    3 +-
 drivers/gpu/drm/radeon/evergreen_cs.c    |   92 ++++---
 drivers/gpu/drm/radeon/r300.c            |   94 ++++---
 drivers/gpu/drm/radeon/r600_cs.c         |   26 ++-
 drivers/gpu/drm/radeon/radeon.h          |    3 +-
 drivers/gpu/drm/radeon/radeon_atombios.c |  204 +++++++---------
 drivers/gpu/drm/radeon/radeon_cs.c       |   11 +-
 drivers/gpu/drm/radeon/radeon_drv.c      |    3 +-
 drivers/gpu/drm/ttm/ttm_bo.c             |    8 +-
 drivers/gpu/vga/vgaarb.c                 |   18 +-
 include/drm/drm_mode.h                   |    2 +
 include/drm/radeon_drm.h                 |    4 +
 22 files changed, 601 insertions(+), 433 deletions(-)
--29444707-275782521-1322042187=:23906--
