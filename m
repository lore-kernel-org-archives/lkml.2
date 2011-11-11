Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab1KKO6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 09:58:17 -0500
Received: from gir.skynet.ie ([193.1.99.77]:47971 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab1KKO6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 09:58:15 -0500
Date: Fri, 11 Nov 2011 14:59:35 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, keithp@keithp.com
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1111111455020.21745@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-325784425-1321023575=:21745"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-325784425-1321023575=:21745
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Pretty much fixes for everything, nouveau and radeon are the main ones, 
some vmwgfx also, and one exynos. A few core drm fixes and cleanups.

I've included 3 i915 fixes, one serious hang, one build and one leak, I 
know Keith has these queued but he seems to have been a bit busy and I'd 
rather at least these 3 were upstream, so he can sort the rest out later.

Dave.


The following changes since commit 1ea6b8f48918282bdca0b32a34095504ee65bab5:

  Linux 3.2-rc1 (2011-11-07 16:16:02 -0800)

are available in the git repository at:
  git://people.freedesktop.org/~airlied/linux drm-fixes

Adam Jackson (1):
      drm/nouveau: Fix bandwidth calculation for DisplayPort

Alex Deucher (6):
      drm/radeon/kms: fix use of vram scratch page on evergreen/ni
      drm/radeon/kms: make an aux failure debug only
      drm/radeon/kms: remove extraneous calls to radeon_pm_compute_clocks()
      drm/radeon/kms/pm: add a proper pm profile init function for fusion
      drm/radeon/kms: optimize r600_pm_profile_init
      drm/radeon/kms/pm: switch to dynamically allocating clock mode array

Ben Skeggs (12):
      drm: make sure drm_vblank_init() has been called before touching vbl_lock
      drm/nouveau: fix oops if i2c bus not found in nouveau_i2c_identify()
      drm/nv50/bios: fixup mpll programming from the init table parser
      drm/nv50/gr: typo fix, how about we not reset fifo during graph init?
      drm/nv50/vram: fix incorrect detection of bank count on newer chipsets
      drm/nv40/pm: fix issues on igp chipsets, which don't have memory
      drm/nvc0/vram: skip disabled PBFB subunits
      drm/nvc0: enable acceleration on 0xc8 by default
      drm/nvc0/gr: fix some bugs in grctx generation
      drm/nvc1: hacky workaround to fix accel issues
      drm/nvc0/gr: fixup the mmio list register writes for 0xc1
      drm/nvc0: enable acceleration for nvc1 by default

Christoph Bumiller (1):
      drm/nvc0/vram: storage type 0xc3 is not compressed

Dan Carpenter (3):
      drm/i915: fix if statement (bogus semi-colon)
      drm/nouveau: testing the wrong variable
      drm/radeon/benchmark: signedness bug in radeon_benchmark_move()

Dave Airlie (1):
      Merge branch 'drm-nouveau-fixes' of git://git.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes

Eric Anholt (1):
      drm/i915: Fix object refcount leak on mmappable size limit error path.

Francisco Jerez (1):
      drm/nv10: Change the BO size threshold determining the memory placement range.

Ilija Hadzic (2):
      drm: do not sleep on vblank while holding a mutex
      drm: add some comments to drm_wait_vblank and drm_queue_vblank_event

Inki Dae (1):
      drm/exynos: added padding to be 64-bit align.

Jakob Bornecrantz (3):
      vmwgfx: Close screen object system
      vmwgfx: Initialize clip rect loop correctly in surface dirty
      vmwgfx: Only allow 64x64 cursors

Jesse Barnes (1):
      drm: try to restore previous CRTC config if mode set fails

Keith Packard (1):
      agp: iommu_gfx_mapped only available if CONFIG_INTEL_IOMMU is set

Kyungmin Park (1):
      MAINTAINERS: exynos: Add EXYNOS DRM maintainer entry

Marcin Slusarz (3):
      drm/nouveau: initialize chan->fence.lock before use
      drm/nouveau: by default use low bpp framebuffer on low memory cards
      drm: serialize access to list of debugfs files

Maxim Levitsky (1):
      drm/nv50: fix stability issue on NV86.

Michel Dänzer (1):
      drm/radeon: Make sure CS mutex is held across GPU reset.

Paul Bolle (1):
      drm: drop select of SLOW_WORK

Randy Dunlap (1):
      drm: fix kconfig unmet dependency warning

Vinson Lee (1):
      drm: Ensure string is null terminated.

 MAINTAINERS                                 |    7 ++
 drivers/char/agp/intel-gtt.c                |    7 +-
 drivers/gpu/drm/Kconfig                     |    2 +-
 drivers/gpu/drm/drm_crtc.c                  |    4 +-
 drivers/gpu/drm/drm_crtc_helper.c           |   13 +++
 drivers/gpu/drm/drm_debugfs.c               |   12 ++-
 drivers/gpu/drm/drm_drv.c                   |    2 +-
 drivers/gpu/drm/drm_irq.c                   |   22 ++++--
 drivers/gpu/drm/i915/i915_debugfs.c         |    5 +-
 drivers/gpu/drm/i915/i915_gem.c             |    2 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c      |   22 +++--
 drivers/gpu/drm/nouveau/nouveau_bo.c        |    2 +-
 drivers/gpu/drm/nouveau/nouveau_channel.c   |    1 +
 drivers/gpu/drm/nouveau/nouveau_connector.c |    2 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c     |   11 +++-
 drivers/gpu/drm/nouveau/nouveau_fence.c     |    2 -
 drivers/gpu/drm/nouveau/nouveau_i2c.c       |    2 +-
 drivers/gpu/drm/nouveau/nouveau_perf.c      |    2 +-
 drivers/gpu/drm/nouveau/nouveau_state.c     |   13 +++-
 drivers/gpu/drm/nouveau/nv40_pm.c           |   20 ++++-
 drivers/gpu/drm/nouveau/nv50_graph.c        |    4 +-
 drivers/gpu/drm/nouveau/nv50_grctx.c        |    2 +-
 drivers/gpu/drm/nouveau/nv50_vram.c         |    2 +-
 drivers/gpu/drm/nouveau/nvc0_graph.c        |   41 +++++++--
 drivers/gpu/drm/nouveau/nvc0_grctx.c        |   31 +++----
 drivers/gpu/drm/nouveau/nvc0_vram.c         |   16 +++--
 drivers/gpu/drm/radeon/atombios_crtc.c      |    6 --
 drivers/gpu/drm/radeon/atombios_dp.c        |    2 +-
 drivers/gpu/drm/radeon/evergreen.c          |   53 ++++++++++++-
 drivers/gpu/drm/radeon/r600.c               |  118 +++++++-------------------
 drivers/gpu/drm/radeon/radeon.h             |   50 +++++++++++-
 drivers/gpu/drm/radeon/radeon_asic.c        |    2 +-
 drivers/gpu/drm/radeon/radeon_asic.h        |    1 +
 drivers/gpu/drm/radeon/radeon_atombios.c    |  118 ++++++++++++++++++---------
 drivers/gpu/drm/radeon/radeon_benchmark.c   |    2 +-
 drivers/gpu/drm/radeon/radeon_cs.c          |   14 ++--
 drivers/gpu/drm/radeon/radeon_device.c      |   16 +++-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |    6 --
 drivers/gpu/drm/radeon/radeon_pm.c          |   18 ++++
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c         |   14 +++-
 include/drm/drmP.h                          |    4 +-
 include/drm/exynos_drm.h                    |    2 +
 42 files changed, 441 insertions(+), 234 deletions(-)
--29444707-325784425-1321023575=:21745--
