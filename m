Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab2JHAf6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 20:35:58 -0400
Received: from gir.skynet.ie ([193.1.99.77]:38029 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988Ab2JHAf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 20:35:56 -0400
Date: Mon, 8 Oct 2012 01:35:53 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm for 3.7-rc1 (part 2)
Message-ID: <alpine.DEB.2.00.1210080132110.20143@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

This is the follow-up pull, 3 pieces

a) exynos next stuff, was delayed but looks okay to me, one patch in v4l 
bits but it was acked by v4l person.
b) UAPI disintegration bits
c) intel fixes - DP fixes, hang fixes, other misc fixes.

Dave.

The following changes since commit 0b8e74c6f44094189dbe78baf4101acc7570c6af:

  Merge branch 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media (2012-10-07 17:49:05 +0900)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux.git drm-next

for you to fetch changes up to 1f31c69dac71bebc0f00bc8534a6345782045501:

  Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-next (2012-10-07 21:13:54 +1000)

----------------------------------------------------------------

Adam Jackson (6):
      drm: Export drm_probe_ddc()
      drm/dp: Update DPCD defines
      drm/i915/dp: Fetch downstream port info if needed during DPCD fetch
      drm/i915/dp: Be smarter about connection sense for branch devices
      drm/dp: Document DP spec versions for various DPCD registers
      drm/dp: Make sink count DP 1.2 aware

Ben Widawsky (2):
      drm/i915: Fix set_caching locking
      drm/i915: Fix GT_MODE default value

Chris Wilson (3):
      drm/i915: Actually invalidate the TLB for the SandyBridge HW contexts w/a
      drm/i915: Flush the pending flips on the CRTC before modification
      drm/i915: Try harder to complete DP training pattern 1

Daniel Vetter (2):
      drm/i915: call drm_handle_vblank before finish_page_flip
      drm/i915: don't frob the vblank ts in finish_page_flip

Dave Airlie (3):
      Merge branch 'disintegrate-drm' of git://git.infradead.org/users/dhowells/linux-headers into drm-next
      Merge branch 'exynos-drm-next' of git://git.infradead.org/users/kmpark/linux-samsung into drm-next
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-next

David Howells (1):
      UAPI: (Scripted) Disintegrate include/drm

Dmitry Rogozhkin (1):
      drm/i915: EBUSY status handling added to i915_gem_fault().

Inki Dae (16):
      drm/exynos: added device object to subdrv's remove callback as argument
      drm/exynos: separated subdrv_probe function into two parts.
      drm/exynos: separeated fimd_power_on into some parts.
      drm/exynos: fixed duplicated mode setting.
      drm/exynos: add wait_for_vblank callback interface.
      drm/exynos: make sure that hardware overlay for fimd is disabled
      drm/exynos: make sure that hardware overlay for hdmi is disabled
      drm/exynos: check NV12M format specific to Exynos properly
      drm/exynos: update crtc to plane safely
      drm/exynos: Disable plane when released
      drm/exynos: add pid to g2d_runqueue_node
      drm/exynos: fix duplicated mutex lock issue
      drm/exynos: check crtc's dpms mode at page flip
      drm/exynos: check crtc's dpms mode at SetCrtc
      drm/exynos: support drm_wait_vblank feature for VIDI
      drm/exynos: fix display power call issue.

Jani Nikula (1):
      drm/i915: use adjusted_mode instead of mode for checking the 6bpc force flag

Jesse Barnes (1):
      drm/i915: set swizzling to none on VLV

Joonyoung Shim (2):
      drm/exynos: fix to calculate CRTC shown via screen
      drm/exynos: fix kcalloc size of g2d cmdlist node

Leela Krishna Amudala (1):
      drm/exynos: add platform_device_id table and driver data for drm fimd

Mika Kuoppala (1):
      drm/i915: print warning if vmi915_gem_fault error is not handled

Rahul Sharma (9):
      drm: exynos: remove drm hdmi platform data struct
      drm: exynos: hdmi: add support for exynos5 ddc
      drm: exynos: hdmi: add support for exynos5 hdmiphy
      drm: exynos: hdmi: add support for platform variants for mixer
      drm: exynos: hdmi: add support to disable video processor in mixer
      drm: exynos: hdmi: add support for exynos5 mixer
      drm: exynos: hdmi: replace is_v13 with version check in hdmi
      drm: exynos: hdmi: add support for exynos5 hdmi
      drm: exynos: hdmi: remove drm common hdmi platform data struct

Sachin Kamat (1):
      drm/exynos: Fix potential NULL pointer dereference

Tomasz Stanislawski (5):
      media: s5p-hdmi: add HPD GPIO to platform data
      drm: exynos: hdmi: support for platform variants
      drm: exynos: hdmi: fix interrupt handling
      drm: exynos: hdmi: use s5p-hdmi platform data
      drm: exynos: hdmi: turn off HPD interrupt in HDMI chip

 drivers/gpu/drm/drm_edid.c                    |    3 +-
 drivers/gpu/drm/exynos/exynos_ddc.c           |   22 +-
 drivers/gpu/drm/exynos/exynos_drm_connector.c |   50 +-
 drivers/gpu/drm/exynos/exynos_drm_connector.h |    4 +
 drivers/gpu/drm/exynos/exynos_drm_core.c      |  100 ++-
 drivers/gpu/drm/exynos/exynos_drm_crtc.c      |   20 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.h       |   19 +-
 drivers/gpu/drm/exynos/exynos_drm_encoder.c   |  116 ++-
 drivers/gpu/drm/exynos/exynos_drm_fb.c        |   65 +-
 drivers/gpu/drm/exynos/exynos_drm_fb.h        |   20 +-
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c     |    3 +
 drivers/gpu/drm/exynos/exynos_drm_fimd.c      |  117 ++-
 drivers/gpu/drm/exynos/exynos_drm_g2d.c       |    5 +-
 drivers/gpu/drm/exynos/exynos_drm_hdmi.c      |   62 +-
 drivers/gpu/drm/exynos/exynos_drm_hdmi.h      |    3 +
 drivers/gpu/drm/exynos/exynos_drm_plane.c     |   58 +-
 drivers/gpu/drm/exynos/exynos_drm_vidi.c      |   24 +-
 drivers/gpu/drm/exynos/exynos_hdmi.c          |  196 +++--
 drivers/gpu/drm/exynos/exynos_hdmiphy.c       |   12 +-
 drivers/gpu/drm/exynos/exynos_mixer.c         |  240 +++++--
 drivers/gpu/drm/exynos/regs-mixer.h           |    3 +
 drivers/gpu/drm/i915/i915_gem.c               |   14 +-
 drivers/gpu/drm/i915/i915_gem_context.c       |    2 +-
 drivers/gpu/drm/i915/i915_gem_tiling.c        |    5 +-
 drivers/gpu/drm/i915/i915_irq.c               |   16 +-
 drivers/gpu/drm/i915/i915_reg.h               |    3 +
 drivers/gpu/drm/i915/intel_display.c          |   52 +-
 drivers/gpu/drm/i915/intel_dp.c               |   73 +-
 drivers/gpu/drm/i915/intel_drv.h              |    2 +
 drivers/gpu/drm/i915/intel_pm.c               |    5 +
 include/drm/Kbuild                            |   15 -
 include/drm/drm_crtc.h                        |    1 +
 include/drm/drm_dp_helper.h                   |  101 ++-
 include/drm/exynos_drm.h                      |  175 +----
 include/drm/i915_drm.h                        |  920 +-----------------------
 include/media/s5p_hdmi.h                      |    2 +
 include/uapi/drm/Kbuild                       |   15 +
 include/{ => uapi}/drm/drm.h                  |    0
 include/{ => uapi}/drm/drm_fourcc.h           |    0
 include/{ => uapi}/drm/drm_mode.h             |    0
 include/{ => uapi}/drm/drm_sarea.h            |    0
 include/uapi/drm/exynos_drm.h                 |  203 ++++++
 include/{ => uapi}/drm/i810_drm.h             |    0
 include/uapi/drm/i915_drm.h                   |  947 +++++++++++++++++++++++++
 include/{ => uapi}/drm/mga_drm.h              |    0
 include/{ => uapi}/drm/nouveau_drm.h          |    0
 include/{ => uapi}/drm/r128_drm.h             |    0
 include/{ => uapi}/drm/radeon_drm.h           |    0
 include/{ => uapi}/drm/savage_drm.h           |    0
 include/{ => uapi}/drm/sis_drm.h              |    0
 include/{ => uapi}/drm/via_drm.h              |    0
 include/{ => uapi}/drm/vmwgfx_drm.h           |    0
 52 files changed, 2267 insertions(+), 1426 deletions(-)
 rename include/{ => uapi}/drm/drm.h (100%)
 rename include/{ => uapi}/drm/drm_fourcc.h (100%)
 rename include/{ => uapi}/drm/drm_mode.h (100%)
 rename include/{ => uapi}/drm/drm_sarea.h (100%)
 create mode 100644 include/uapi/drm/exynos_drm.h
 rename include/{ => uapi}/drm/i810_drm.h (100%)
 create mode 100644 include/uapi/drm/i915_drm.h
 rename include/{ => uapi}/drm/mga_drm.h (100%)
 rename include/{ => uapi}/drm/nouveau_drm.h (100%)
 rename include/{ => uapi}/drm/r128_drm.h (100%)
 rename include/{ => uapi}/drm/radeon_drm.h (100%)
 rename include/{ => uapi}/drm/savage_drm.h (100%)
 rename include/{ => uapi}/drm/sis_drm.h (100%)
 rename include/{ => uapi}/drm/via_drm.h (100%)
 rename include/{ => uapi}/drm/vmwgfx_drm.h (100%)
