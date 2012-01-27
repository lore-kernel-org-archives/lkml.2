Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab2A0Pla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 10:41:30 -0500
Received: from gir.skynet.ie ([193.1.99.77]:50215 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176Ab2A0Pl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 10:41:29 -0500
Date: Fri, 27 Jan 2012 15:41:27 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes (intel + exynos + misc)
Message-ID: <alpine.DEB.2.00.1201271538340.30895@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

This contains mainly a bunch of intel fixes, mainly fixing up the missing 
irq problems on Ivybridge, a set of exynos fixes, one gma500 and one agp.

Thanks,
Dave.

The following changes since commit 9f1feed2e16652a6e599ed4a73b4c501bb3d4568:

  drm/ttm: fix two regressions since move_notify changes (2012-01-25 18:54:28 +0000)

are available in the git repository at:
  ssh://people.freedesktop.org/~/linux drm-fixes

Daniel Vetter (7):
      drm/i915: convert force_wake_get to func pointer in the gpu reset code
      drm/i915: protect force_wake_(get|put) with the gt_lock
      drm/i915: paper over missed irq issues with force wake voodoo
      drm/i915: rip out the HWSTAM missed irq workaround
      drm/i915: allow userspace forcewake references also on gen7
      drm/i915: debugfs: show semaphore registers also on gen7
      drm/i915: fixup forcewake spinlock fallout in drpc debugfs function

Dave Airlie (2):
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~keithp/linux into drm-fixes
      Merge branch 'exynos-drm-fixes' of git://git.infradead.org/users/kmpark/linux-samsung into drm-fixes

Duncan Laurie (1):
      CHROMIUM: i915: Add DMI override to skip CRT initialization on ZGB

Eric Anholt (3):
      drm/i915: Print debugfs object list sizes in KiB instead of bytes.
      drm/i915: Correct debugfs printout for RC1e.
      drm/i915: Re-enable gen7 RC6 and GPU turbo after resume.

Eugeni Dodonov (2):
      drm/i915: simplify pipe checking
      drm/i915: handle 3rd pipe

Inki Dae (3):
      drm/exynos: fixed build dependency for DRM_EXYNOS_FIMD
      MAINTAINERS: added maintainer entry for Exynos DRM Driver.
      drm/exynos: fixed pm feature for fimd module.

Jesse Barnes (2):
      drm/i915: mask transcoder select bits before setting them on LVDS
      drm/i915: sprite init failure on pre-SNB is not a failure

Joel Sass (1):
      drm/i915: Add Clientron E830 to the ignore LVDS list

Keith Packard (5):
      Merge branch 'drm-intel-next-fixes' into drm-intel-fixes
      drm/i915: Move reset forcewake processing to gen6_do_reset
      drm/i915: Hold gt_lock during reset
      drm/i915: Hold gt_lock across forcewake register reads
      Revert "drm/i915: Work around gen7 BLT ring synchronization issues."

Michal Kubecek (1):
      agp: fix scratch page cleanup

Paulo Zanoni (1):
      drm/i915/sdvo: always set positive sync polarity

Rodrigo Vivi (2):
      drm/i915: Fix TV Out refresh rate.
      drm/i915: Removing TV Out modes.

Rohit Jain (1):
      drm/i915: VBT Parser cleanup for eDP block

Ryan Mallon (1):
      gma500: Fix suspend/resume functions

Seung-Woo Kim (2):
      drm/exynos: use release_mem_region instead of release_resource
      drm/exynos: fix build dependency for DRM_EXYNOS_HDMI

 MAINTAINERS                              |    3 +
 drivers/char/agp/backend.c               |   12 ++--
 drivers/gpu/drm/exynos/Kconfig           |    4 +-
 drivers/gpu/drm/exynos/exynos_drm_fimd.c |  109 +++++++++++++-----------
 drivers/gpu/drm/exynos/exynos_hdmi.c     |    8 +-
 drivers/gpu/drm/gma500/framebuffer.c     |    8 +-
 drivers/gpu/drm/i915/i915_debugfs.c      |   31 +++++---
 drivers/gpu/drm/i915/i915_dma.c          |    1 +
 drivers/gpu/drm/i915/i915_drv.c          |   56 ++++++++++---
 drivers/gpu/drm/i915/i915_drv.h          |   10 ++-
 drivers/gpu/drm/i915/i915_irq.c          |    3 +-
 drivers/gpu/drm/i915/i915_suspend.c      |   11 ++-
 drivers/gpu/drm/i915/intel_bios.h        |    6 +-
 drivers/gpu/drm/i915/intel_crt.c         |   23 +++++
 drivers/gpu/drm/i915/intel_display.c     |   22 +++---
 drivers/gpu/drm/i915/intel_lvds.c        |    8 ++
 drivers/gpu/drm/i915/intel_ringbuffer.c  |   41 ++++++----
 drivers/gpu/drm/i915/intel_sdvo.c        |    8 +-
 drivers/gpu/drm/i915/intel_sprite.c      |    8 +--
 drivers/gpu/drm/i915/intel_tv.c          |  138 ++----------------------------
 20 files changed, 245 insertions(+), 265 deletions(-)
