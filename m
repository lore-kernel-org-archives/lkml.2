Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab2KCLfL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 07:35:11 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33149 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755758Ab2KCLfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 07:35:08 -0400
Date: Sat, 3 Nov 2012 11:35:06 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1211031132460.25857@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

scattered selection of fixes:
radeon: load detect fixes from SuSE/AMD
intel: misc i830, sdvo regression, vesafb kickoff ums fix
exynos: maintainers entry update + fixes
udl: fix stride scanout issue

its slightly bigger than I'd probably like, but nothing looked dangerous 
enough to hold off on.

Dave.

The following changes since commit 4936b172d699434547addbe452c2d600ea6a4baf:

  Merge branch 'drm-nouveau-fixes' of git://people.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes (2012-10-31 13:46:09 +1000)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

Alex Deucher (1):
      drm/radeon: add load detection support for ext DAC on R200 (v2)

Chris Wilson (1):
      drm/i915: Only kick out vesafb if we takeover the fbcon with KMS

Daniel Vetter (3):
      drm/i915: fix overlay on i830M
      drm/i915: VGA needs to be on pipe A on i830M
      drm/i915: clear the entire sdvo infoframe buffer

Dave Airlie (4):
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes
      Merge branch 'drm-fixes-3.7' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Merge branch 'exynos-drm-fixes' of git://git.kernel.org/.../daeinki/drm-exynos into drm-fixes
      drm/udl: fix stride issues scanning out stride != width*bpp

Egbert Eich (6):
      DRM/Radeon: Fix Load Detection on legacy primary DAC.
      DRM/Radeon: Fix primary DAC Load Detection for RV100 chips.
      DRM/Radeon: On DVI-I use Load Detection when EDID is bogus.
      DRM/Radeon: Clean up code in TV DAC load detection.
      DRM/Radeon: Fix TV DAC Load Detection for single CRTC chips.
      DRM/radeon: For single CRTC GPUs move handling of CRTC_CRT_ON to crtc_dpms().

Igor Murzov (1):
      drm/radeon: fix ATPX function documentation

Inki Dae (2):
      drm/exynos: fix display on issue
      MAINTAINERS: Add git repository for Exynos DRM

Jani Nikula (1):
      drm/i915: be less verbose about inability to provide vendor backlight

Peter Senna Tschudin (1):
      drivers/gpu/drm/radeon/evergreen_cs.c: Remove unnecessary semicolon

Rahul Sharma (1):
      drm: exynos: removed warning due to missing typecast for mixer driver data

Rob Clark (1):
      drm/exynos: add support for ARCH_MULTIPLATFORM

 MAINTAINERS                                     |    1 +
 drivers/gpu/drm/exynos/Kconfig                  |    2 +-
 drivers/gpu/drm/exynos/exynos_drm_connector.c   |    1 +
 drivers/gpu/drm/exynos/exynos_drm_encoder.c     |   33 +++--
 drivers/gpu/drm/exynos/exynos_mixer.c           |    2 +-
 drivers/gpu/drm/i915/i915_dma.c                 |    3 +-
 drivers/gpu/drm/i915/intel_crt.c                |    2 +-
 drivers/gpu/drm/i915/intel_overlay.c            |   14 ++-
 drivers/gpu/drm/i915/intel_panel.c              |    2 +-
 drivers/gpu/drm/i915/intel_sdvo.c               |   62 ++++++---
 drivers/gpu/drm/i915/intel_sdvo_regs.h          |    2 +
 drivers/gpu/drm/radeon/evergreen_cs.c           |    2 +-
 drivers/gpu/drm/radeon/radeon_atpx_handler.c    |    4 +-
 drivers/gpu/drm/radeon/radeon_connectors.c      |   28 +++-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c     |   15 ++-
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |  175 +++++++++++++++++++----
 drivers/gpu/drm/udl/udl_drv.h                   |    2 +-
 drivers/gpu/drm/udl/udl_fb.c                    |   12 +-
 drivers/gpu/drm/udl/udl_transfer.c              |    5 +-
 19 files changed, 275 insertions(+), 92 deletions(-)
