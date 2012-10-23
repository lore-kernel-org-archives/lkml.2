Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab2JWATn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 20:19:43 -0400
Received: from gir.skynet.ie ([193.1.99.77]:49925 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754355Ab2JWATm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 20:19:42 -0400
Date: Tue, 23 Oct 2012 01:19:39 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1210230117590.5647@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

fixes for intel and nouveau mainly.

intel: disable HSW by default, sdvo fixes, link train regression fix
nouveau: acpi rom loading regression fix, with a few other fixes from the 
rework
core: just other minor fixes and race fixes for ttm.

Dave.

The following changes since commit 6f0c0580b70c89094b3422ba81118c7b959c7556:

  Linux 3.7-rc2 (2012-10-20 12:11:32 -0700)

are available in the git repository at:
  git://people.freedesktop.org/~airlied/linux drm-fixes

Ben Skeggs (4):
      drm/nouveau/bios: fetch full 4KiB block to determine ACPI ROM image size
      drm/nv41/vm: don't init hw pciegart on boards with agp bridge
      drm/nouveau/fb: fix reporting of memory type on GF8+ IGPs
      drm/nouveau/clock: fix missing pll type/addr when matching default entry

Chris Wilson (2):
      drm/i915: Add no-lvds quirk for Supermicro X7SPA-H
      drm/i915: Initialize obj->pages before use by i915_gem_object_do_bit17_swizzle()

Daniel Vetter (2):
      Revert "drm/i915: Try harder to complete DP training pattern 1"
      drm/i915: shut up spurious WARN in the gtt fault handler

Dave Airlie (2):
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes
      Merge branch 'drm-nouveau-fixes' of git://git.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes

Egbert Eich (4):
      DRM/i915: Don't delete DPLL Multiplier during DAC init.
      DRM/i915: Add QUIRK_INVERT_BRIGHTNESS for NCR machines.
      DRM/i915: Don't clone SDVO LVDS with analog.
      DRM/i915: Restore sdvo_flags after dtd->mode->dtd Roundrtrip.

Marcin Slusarz (5):
      drm/nouveau: handle same-fb page flips
      drm/nouveau: fix nouveau_mm/nouveau_mm_node leak
      drm/nouveau: warn when trying to free mm which is still in use
      drm/nouveau: validate vbios size
      drm/debugfs: remove redundant info from gem_names

Martin Peres (1):
      drm/nouveau/bios: improve error handling when reading the vbios from ACPI

Rodrigo Vivi (1):
      drm/i915: Insert i915_preliminary_hw_support variable.

Thierry Reding (3):
      drm: fb: cma: Fix typo in debug message
      drm: fb: cma: Fail gracefully on allocation failure
      drm: platform: Don't initialize driver-private data

Thomas Hellstrom (2):
      drm/ttm: Fix a theoretical race
      drm/ttm: Fix a theoretical race in ttm_bo_cleanup_refs()

 drivers/gpu/drm/drm_fb_cma_helper.c             |    4 +-
 drivers/gpu/drm/drm_info.c                      |    2 -
 drivers/gpu/drm/drm_platform.c                  |    1 -
 drivers/gpu/drm/i915/i915_drv.c                 |   13 +++++++++
 drivers/gpu/drm/i915/i915_drv.h                 |    1 +
 drivers/gpu/drm/i915/i915_gem.c                 |    7 +++-
 drivers/gpu/drm/i915/intel_crt.c                |   15 +----------
 drivers/gpu/drm/i915/intel_display.c            |   32 +++++++++++++++++++++++
 drivers/gpu/drm/i915/intel_dp.c                 |   15 +++++++---
 drivers/gpu/drm/i915/intel_lvds.c               |    8 +++++
 drivers/gpu/drm/i915/intel_sdvo.c               |   14 +++++++---
 drivers/gpu/drm/nouveau/core/core/gpuobj.c      |    5 +++
 drivers/gpu/drm/nouveau/core/core/mm.c          |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/base.c |   30 ++++++++++++++++-----
 drivers/gpu/drm/nouveau/core/subdev/bios/pll.c  |   10 +++----
 drivers/gpu/drm/nouveau/core/subdev/fb/nv50.c   |    1 +
 drivers/gpu/drm/nouveau/core/subdev/vm/nv41.c   |    3 +-
 drivers/gpu/drm/nouveau/core/subdev/vm/nv44.c   |    3 +-
 drivers/gpu/drm/nouveau/nouveau_display.c       |   14 ++++++---
 drivers/gpu/drm/shmobile/shmob_drm_drv.c        |   12 +++-----
 drivers/gpu/drm/ttm/ttm_bo.c                    |   24 ++++++++++-------
 21 files changed, 148 insertions(+), 68 deletions(-)
