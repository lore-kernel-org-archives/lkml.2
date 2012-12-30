Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab2L3EXt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 23:23:49 -0500
Received: from gir.skynet.ie ([193.1.99.77]:36149 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228Ab2L3EXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 23:23:47 -0500
Date: Sun, 30 Dec 2012 04:23:44 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1212300420180.7673@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

bit larger due to me not bothering to do anything since before Xmas, and 
other people working too hard after I had clearly given up.

Its got the 3 main x86 driver fixes pulls, and a bunch of tegra fixes, 
doesn't fix the Ironlake bug yet, but that does seem to be getting closer.

radeon: gpu reset fixes and userspace packet support
i915: watermark fixes, workarounds, i830/845 fix,
nouveau: nvd9/kepler microcode fixes, accel is now enabled and working,
gk106 support
tegra: misc fixes.

Dave.

The following changes since commit a49f0d1ea3ec94fc7cf33a7c36a16343b74bd565:

  Linux 3.8-rc1 (2012-12-21 17:19:00 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-next

for you to fetch changes up to 500df2e5d870ef5be3d37f0798f770028b69fd47:

  drm: tegra: program only one window during modeset (2012-12-30 14:01:35 +1000)

----------------------------------------------------------------
Alex Deucher (1):
      drm/radeon: add WAIT_UNTIL to evergreen VM safe reg list

Ben Skeggs (8):
      drm/nouveau: initial support for GK106
      drm/nouveau/bios: update gpio parsing apis to match current design
      drm/nouveau/bios: implement opcode 0xa9
      drm/nouveau/bios: parse/display extra version component
      drm/nouveau/mxm: silence output if no bios data
      drm/nouveau/bios: cache ramcfg strap on later chipsets
      drm/nvc0/graph: fix fuc, and enable acceleration on GF119
      drm/nve0/graph: fix fuc, and enable acceleration on all known chipsets

Chris Wilson (6):
      drm/i915: Fixup cursor latency used for IVB lp3 watermarks
      drm/i915: Double the cursor self-refresh latency on Valleyview
      drm/i915: Clear self-refresh watermarks when disabled
      drm/i915: Prefer CRTC 'active' rather than 'enabled' during WM computations
      drm: Export routines for inserting preallocated nodes into the mm manager
      drm/i915: Preallocate the drm_mm_node prior to manipulating the GTT drm_mm manager

Daniel Vetter (6):
      drm/i915: Implement WaDisableHiZPlanesWhenMSAAEnabled
      drm/i915: Implement WaSetupGtModeTdRowDispatch
      drm/i915: Implement workaround for broken CS tlb on i830/845
      drm/i915: don't disable disconnected outputs
      drm/i915: optionally disable shrinker lock stealing
      drm/i915: disable shrinker lock stealing for create_mmap_offset

Dave Airlie (4):
      drm/i915: fix flags in dma buf exporting
      Merge branch 'drm-nouveau-fixes-3.8' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next
      Merge branch 'drm-fixes-3.8' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-next

Jerome Glisse (4):
      drm/radeon: don't leave fence blocked process on failed GPU reset
      drm/radeon: avoid deadlock in pm path when waiting for fence
      drm/radeon: restore modeset late in GPU reset path
      drm/radeon: add support for MEM_WRITE packet

Krzysztof Mazur (1):
      i915: ensure that VGA plane is disabled

Lucas Stach (6):
      drm: tegra: fix front_porch <-> back_porch mixup
      drm: tegra: don't leave clients host1x member uninitialized
      drm: tegra: protect DC register access with mutex
      drm: tegra: remove redundant tegra2_tmds_config entry
      drm: tegra: clean out old gem prototypes
      drm: tegra: program only one window during modeset

 drivers/gpu/drm/drm_mm.c                           |  41 ++++--
 drivers/gpu/drm/i915/i915_dma.c                    |   3 +
 drivers/gpu/drm/i915/i915_drv.h                    |   8 ++
 drivers/gpu/drm/i915/i915_gem.c                    |  77 +++++-----
 drivers/gpu/drm/i915/i915_gem_dmabuf.c             |   2 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |   2 +
 drivers/gpu/drm/i915/i915_irq.c                    |  12 ++
 drivers/gpu/drm/i915/i915_reg.h                    |   4 +-
 drivers/gpu/drm/i915/intel_display.c               |  23 ++-
 drivers/gpu/drm/i915/intel_pm.c                    | 160 ++++++++++++++++++---
 drivers/gpu/drm/i915/intel_ringbuffer.c            |  76 ++++++++--
 drivers/gpu/drm/i915/intel_ringbuffer.h            |   1 +
 .../drm/nouveau/core/engine/graph/fuc/gpcnve0.fuc  |   5 +
 .../nouveau/core/engine/graph/fuc/gpcnve0.fuc.h    |  17 ++-
 .../drm/nouveau/core/engine/graph/fuc/hubnvc0.fuc  |  10 ++
 .../nouveau/core/engine/graph/fuc/hubnvc0.fuc.h    | 147 +++++++++----------
 .../drm/nouveau/core/engine/graph/fuc/hubnve0.fuc  |  13 ++
 .../nouveau/core/engine/graph/fuc/hubnve0.fuc.h    | 157 ++++++++++----------
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c   |  11 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.h   |   1 +
 drivers/gpu/drm/nouveau/core/engine/graph/nve0.c   |   3 +-
 drivers/gpu/drm/nouveau/core/include/subdev/bios.h |   1 +
 .../drm/nouveau/core/include/subdev/bios/gpio.h    |   8 +-
 .../drm/nouveau/core/include/subdev/bios/init.h    |   1 +
 drivers/gpu/drm/nouveau/core/include/subdev/gpio.h |   2 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/base.c    |   5 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/gpio.c    | 128 ++++++++++-------
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c    |  65 ++++++++-
 drivers/gpu/drm/nouveau/core/subdev/device/nve0.c  |  28 ++++
 drivers/gpu/drm/nouveau/core/subdev/gpio/base.c    |   9 +-
 drivers/gpu/drm/nouveau/core/subdev/gpio/nv50.c    |   9 +-
 drivers/gpu/drm/nouveau/core/subdev/gpio/nvd0.c    |   9 +-
 drivers/gpu/drm/nouveau/core/subdev/mxm/base.c     |   2 +-
 drivers/gpu/drm/radeon/evergreen_cs.c              |  30 ++++
 drivers/gpu/drm/radeon/r600_cs.c                   |  29 ++++
 drivers/gpu/drm/radeon/radeon.h                    |   3 +-
 drivers/gpu/drm/radeon/radeon_device.c             |  17 ++-
 drivers/gpu/drm/radeon/radeon_drv.c                |   3 +-
 drivers/gpu/drm/radeon/radeon_fence.c              |  49 ++++---
 drivers/gpu/drm/radeon/radeon_pm.c                 |  15 +-
 drivers/gpu/drm/tegra/dc.c                         |  24 +++-
 drivers/gpu/drm/tegra/drm.h                        |  19 +--
 drivers/gpu/drm/tegra/hdmi.c                       |  25 +---
 drivers/gpu/drm/tegra/host1x.c                     |   2 +
 include/drm/drm_mm.h                               |  25 +++-
 include/uapi/drm/i915_drm.h                        |  10 ++
 46 files changed, 894 insertions(+), 397 deletions(-)
