Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761528Ab2DLRnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 13:43:23 -0400
Received: from gir.skynet.ie ([193.1.99.77]:50400 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756704Ab2DLRnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 13:43:22 -0400
Date: Thu, 12 Apr 2012 18:43:20 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1204121803130.3905@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

mostly exynos and intel,

intel has 3 regression fixers (more info in intel merge commit), along 
with some other make hw work fixes,
exynos has some cleanups and an ioctl fix

couple of radeon fixes, couple of build fixes, and a savage userspace 
interface possible overflow fix.

Dave.

The following changes since commit 258f742635360175564e9470eb060ff4d4b984e7:

  modpost: Fix modpost license checking of vmlinux.o (2012-04-09 20:52:56 -0700)

are available in the git repository at:
  git://people.freedesktop.org/~airlied/linux drm-fixes

Alex Deucher (2):
      drm/radeon/kms: fix DVO setup on some r4xx chips
      drm/radeon: only add the mm i2c bus if the hw_i2c module param is set

Arnd Bergmann (1):
      drm/radeon: replace udelay with mdelay for long timeouts

Chris Wilson (2):
      drm/i915: Finish any pending operations on the framebuffer before disabling
      drm/i915/ringbuffer: Exclude last 2 cachlines of ring on 845g

Daniel Vetter (4):
      drm/i915: properly compute dp dithering for user-created modes
      Revert "drm/i915: reenable gmbus on gen3+ again"
      drm/i915: implement ColorBlt w/a
      drm/i915: clear fencing tracking state when retiring requests

Dave Airlie (2):
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-intel-fixes
      Merge branch 'exynos-drm-fixes' of git://git.infradead.org/users/kmpark/linux-samsung into drm-intel-fixes

Inki Dae (3):
      drm/exynos: fixed page align and code clean.
      drm/exynos: fixed duplicated page allocation bug.
      drm/exynos: fixed exynos broken ioctl

Jesse Barnes (1):
      drm/i915: make rc6 module parameter read-only

Joonyoung Shim (6):
      drm/exynos: remove unnecessary type conversion of hdmi and mixer
      drm/exynos: remove unused codes in hdmi and mixer
      drm/exynos: rename s/HDMI_OVERLAY_NUMBER/MIXER_WIN_NR
      drm/exynos: use define instead of default_win member in struct mixer_context
      drm/exynos: fix struct for operation callback functions to driver name
      drm/exynos: fix to pointer manager member of struct exynos_drm_subdrv

Randy Dunlap (1):
      vgaarb.h: fix build warnings

Seung-Woo Kim (1):
      drm/exynos: add format list of plane

Xi Wang (1):
      drm/savage: fix integer overflows in savage_bci_cmdbuf()

acreese (1):
      drm/i915: Removed IVB forced enable of sprite dest key.

 drivers/gpu/drm/exynos/exynos_drm_buf.c         |   47 +++-------
 drivers/gpu/drm/exynos/exynos_drm_core.c        |   14 ++--
 drivers/gpu/drm/exynos/exynos_drm_drv.h         |   10 +-
 drivers/gpu/drm/exynos/exynos_drm_fimd.c        |   20 +++--
 drivers/gpu/drm/exynos/exynos_drm_gem.c         |   45 ++++++++--
 drivers/gpu/drm/exynos/exynos_drm_gem.h         |    2 +
 drivers/gpu/drm/exynos/exynos_drm_hdmi.c        |  107 ++++++++++-------------
 drivers/gpu/drm/exynos/exynos_drm_hdmi.h        |   23 ++---
 drivers/gpu/drm/exynos/exynos_drm_plane.c       |    4 +
 drivers/gpu/drm/exynos/exynos_drm_vidi.c        |   20 +++--
 drivers/gpu/drm/exynos/exynos_hdmi.c            |   42 ++++-----
 drivers/gpu/drm/exynos/exynos_mixer.c           |   40 ++++-----
 drivers/gpu/drm/i915/i915_drv.c                 |    2 +-
 drivers/gpu/drm/i915/i915_gem.c                 |    2 +
 drivers/gpu/drm/i915/i915_reg.h                 |    3 +
 drivers/gpu/drm/i915/intel_display.c            |   69 +++++++++++----
 drivers/gpu/drm/i915/intel_dp.c                 |   49 ++++++++---
 drivers/gpu/drm/i915/intel_i2c.c                |    2 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c         |    2 +-
 drivers/gpu/drm/i915/intel_sprite.c             |    1 -
 drivers/gpu/drm/radeon/atombios_encoders.c      |    4 +
 drivers/gpu/drm/radeon/r100.c                   |    2 +-
 drivers/gpu/drm/radeon/r600.c                   |    2 +-
 drivers/gpu/drm/radeon/r600_cp.c                |    6 +-
 drivers/gpu/drm/radeon/radeon_clocks.c          |   24 +++---
 drivers/gpu/drm/radeon/radeon_combios.c         |    8 +-
 drivers/gpu/drm/radeon/radeon_i2c.c             |    4 +
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |   12 ++--
 drivers/gpu/drm/savage/savage_state.c           |    6 +-
 include/drm/exynos_drm.h                        |    5 +-
 include/linux/vgaarb.h                          |    2 +
 31 files changed, 325 insertions(+), 254 deletions(-)
