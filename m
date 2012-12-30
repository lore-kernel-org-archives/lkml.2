Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab2L3MRe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 07:17:34 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:42027 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab2L3MRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 07:17:32 -0500
X-Greylist: delayed 408 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Dec 2012 07:17:32 EST
MIME-Version: 1.0
In-Reply-To: <1356862159.7991.6.camel@tellur>
References: <alpine.DEB.2.00.1212300420180.7673@skynet.skynet.ie>
	<1356862159.7991.6.camel@tellur>
Date: Sun, 30 Dec 2012 22:10:43 +1000
Message-ID: <CAPM=9txQs_a3phmzF8aQV9357mRYOrrZAgKAEJ9CUxV+dOvLoA@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Dave Airlie <airlied@gmail.com>
To: Lucas Stach <dev@lynxeye.de>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 30, 2012 at 8:09 PM, Lucas Stach <dev@lynxeye.de> wrote:
> Hello Dave,
>
> Am Sonntag, den 30.12.2012, 04:23 +0000 schrieb Dave Airlie:
>> Hi Linus,
>>
> [...]
>>
>> Lucas Stach (6):
>>       drm: tegra: protect DC register access with mutex
>         ^^^^ This patch is unnecessary and really shouldn't go in. There
> was a brief discussion on the list with the conclusion to disregard this
> patch.

Linus, I just reverted it on top, didn't want to cause a rebase on  that branch,

updated pull req.

The following changes since commit a49f0d1ea3ec94fc7cf33a7c36a16343b74bd565:

  Linux 3.8-rc1 (2012-12-21 17:19:00 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-next

for you to fetch changes up to d5757dbe79870d825d0dec30074d48683e1d7e9a:

  Revert "drm: tegra: protect DC register access with mutex"
(2012-12-30 21:58:20 +1000)

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
      drm/i915: Prefer CRTC 'active' rather than 'enabled' during WM
computations
      drm: Export routines for inserting preallocated nodes into the mm manager
      drm/i915: Preallocate the drm_mm_node prior to manipulating the
GTT drm_mm manager

Daniel Vetter (6):
      drm/i915: Implement WaDisableHiZPlanesWhenMSAAEnabled
      drm/i915: Implement WaSetupGtModeTdRowDispatch
      drm/i915: Implement workaround for broken CS tlb on i830/845
      drm/i915: don't disable disconnected outputs
      drm/i915: optionally disable shrinker lock stealing
      drm/i915: disable shrinker lock stealing for create_mmap_offset

Dave Airlie (5):
      drm/i915: fix flags in dma buf exporting
      Merge branch 'drm-nouveau-fixes-3.8' of
git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next
      Merge branch 'drm-fixes-3.8' of
git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge branch 'drm-intel-fixes' of
git://people.freedesktop.org/~danvet/drm-intel into drm-next
      Revert "drm: tegra: protect DC register access with mutex"

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
 drivers/gpu/drm/tegra/dc.c                         |  11 +-
 drivers/gpu/drm/tegra/drm.h                        |  18 ---
 drivers/gpu/drm/tegra/hdmi.c                       |  25 +---
 drivers/gpu/drm/tegra/host1x.c                     |   2 +
 include/drm/drm_mm.h                               |  25 +++-
 include/uapi/drm/i915_drm.h                        |  10 ++
 46 files changed, 880 insertions(+), 397 deletions(-)
