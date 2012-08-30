Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab2H3F3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 01:29:41 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53918 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab2H3F3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 01:29:40 -0400
Date: Thu, 30 Aug 2012 06:29:37 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
cc: linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1208300628050.25206@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1259355809-1346304577=:25206"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1259355809-1346304577=:25206
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

a bunch of scattered fixes ati/intel/nouveau, couple of core ones,
nothing too shocking or different.

Dave.

The following changes since commit fea7a08acb13524b47711625eebea40a0ede69a0:

  Linux 3.6-rc3 (2012-08-22 13:29:06 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux.git drm-fixes

for you to fetch changes up to 6f33814bd4d9cfe76033a31b1c0c76c960cd8e4b:

  drm: Add EDID_QUIRK_FORCE_REDUCED_BLANKING for ASUS VW222S (2012-08-30 14:14:12 +1000)

----------------------------------------------------------------
Alex Deucher (5):
      drm/radeon: don't disable plls that are in use by other crtcs
      drm/radeon/atom: rework DIG modesetting on DCE3+
      drm/radeon/atom: powergating fixes for DCE6
      drm/radeon: rework panel mode setup
      drm/radeon: fix dig encoder selection on DCE61

Ben Skeggs (1):
      drm/nvc0/copy: check PUNITS to determine which copy engines are disabled

Calvin Walton (1):
      i915: Quirk no_lvds on Gigabyte GA-D525TUD ITX motherboard

Chris Wilson (1):
      drm/i915: Use the correct size of the GTT for placing the per-process entries

Christian König (1):
      drm/radeon: fix double free in radeon_gpu_reset

Dave Airlie (3):
      Merge branch 'drm-nouveau-fixes' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes
      Merge branch 'drm-fixes-3.6' of git://people.freedesktop.org/~agd5f/linux into drm-fixes

Forest Bond (1):
      gma500: Consider CRTC initially active.

Jakob Bornecrantz (1):
      drm: Check for invalid cursor flags

Jerome Glisse (1):
      drm/radeon: force dma32 to fix regression rs4xx,rs6xx,rs740

Marek Ol¨ák (3):
      drm/radeon: fix reading CB_COLORn_MASK from the CS
      drm/radeon: initialize tracked CS state
      drm/radeon: add proper checking of RESOLVE_BOX command for r600-r700

Paul Menzel (1):
      drm: Add EDID_QUIRK_FORCE_REDUCED_BLANKING for ASUS VW222S

Vijay Purushothaman (1):
      drm/i915: fix color order for BGR formats on IVB

Ville Syrjälä (1):
      drm: Initialize object type when using DRM_MODE() macro

Xu, Anhua (1):
      drm/i915: fix wrong order of parameters in port checking functions

 drivers/gpu/drm/drm_crtc.c                 |    2 +-
 drivers/gpu/drm/drm_edid.c                 |    3 +
 drivers/gpu/drm/gma500/psb_intel_display.c |    3 +
 drivers/gpu/drm/i915/i915_gem_gtt.c        |    2 +-
 drivers/gpu/drm/i915/intel_display.c       |   12 +--
 drivers/gpu/drm/i915/intel_lvds.c          |    8 ++
 drivers/gpu/drm/i915/intel_sprite.c        |    4 +-
 drivers/gpu/drm/nouveau/nouveau_state.c    |    6 +-
 drivers/gpu/drm/radeon/atombios_crtc.c     |   36 ++++---
 drivers/gpu/drm/radeon/atombios_dp.c       |   29 +++---
 drivers/gpu/drm/radeon/atombios_encoders.c |  140 +++++++++++++++-------------
 drivers/gpu/drm/radeon/r600_cs.c           |   30 +++++-
 drivers/gpu/drm/radeon/r600d.h             |    8 ++
 drivers/gpu/drm/radeon/radeon_device.c     |    5 +-
 drivers/gpu/drm/radeon/radeon_drv.c        |    3 +-
 drivers/gpu/drm/radeon/reg_srcs/r600       |    1 -
 include/drm/drm_crtc.h                     |    3 +-
 include/drm/drm_mode.h                     |    5 +-
 18 files changed, 174 insertions(+), 126 deletions(-)
--29444707-1259355809-1346304577=:25206--
