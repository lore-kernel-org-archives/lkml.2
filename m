Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405Ab2INKYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 06:24:30 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42066 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758977Ab2INKY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 06:24:29 -0400
Date: Fri, 14 Sep 2012 11:24:26 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1209141115510.21518@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1953620635-1347618266=:21518"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1953620635-1347618266=:21518
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


I realise this a bit bigger than I would want at this point,

exynos is a large chunk, I got them to half what they wanted already, and 
hey its ARM based, so not going to hurt many people,

radeon has only two fixes, but the PLL fixes were a bit bigger, 
but required for a lot of scenarios, the fence fix is really urgent

vmwgfx: I've pulled in a dumb ioctl support patch that I was going to 
shove in later and cc stable, but we need it asap, its mainly to stop mesa 
growing a really ugly dependency in userspace to run stuff on vmware, and 
if I don't stick it in the kernel now, everyone will have to ship ugly 
userspace libs to workaround it.

nouveau: single urgent fix found in F18 testing, causes X 
to not start properly when f18 plymouth is used

i915: smattering of fixes and debug quieting

gma500: single regression fix

so as I said a bit large, but its fairly well scattered and its all stuff 
I'll be shipping in F18's 3.6 kernel.

Dave.

The following changes since commit 0bd1189e239c76eb3a50e458548fbe7e4a5dfff1:

  Merge branch 'for-3.6-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq (2012-09-12 07:16:54 +0800)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 610bd7da160f76f1644ecb4cd7f39511b49a22cc:

  drm/nouveau: fix booting with plymouth + dumb support (2012-09-14 15:45:01 +1000)

----------------------------------------------------------------
Alan Cox (1):
      gma500: Fix regression on Oaktrail devices

Alex Deucher (1):
      drm/radeon: rework pll selection (v3)

Alexander Shishkin (1):
      drm/i915: initialize dpio_lock spin lock

Christian König (1):
      drm/radeon: make 64bit fences more robust v3

Daniel Vetter (2):
      drm/i915: set the right gen3 flip_done mode also at resume
      drm/i915: fix up the IBX transcoder B check

Dave Airlie (6):
      drm/i915/edp: get the panel delay before powering up
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes
      vmwgfx: add dumb ioctl support
      Merge branch 'exynos-drm-fixes' of git://git.infradead.org/users/kmpark/linux-samsung into drm-fixes
      Merge branch 'drm-fixes-3.6' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
      drm/nouveau: fix booting with plymouth + dumb support

Inki Dae (2):
      drm/exynos: fixed page align bug.
      drm/exynos: remove DRM_FORMAT_NV12M from plane module

Jani Nikula (2):
      drm/i915: only enable sdvo hotplug irq if needed
      drm/i915: do not expose a dysfunctional backlight interface to userspace

Mandeep Singh Baines (1):
      drm/exynos: fix double call of drm_prime_(init/destroy)_file_private

Sachin Kamat (9):
      drm/exynos: Remove redundant check in exynos_hdmi.c file
      drm/exynos: Remove redundant check in exynos_drm_fimd.c file
      drm/exynos: Use devm_kzalloc in exynos_drm_vidi.c file
      drm/exynos: Use devm_kzalloc in exynos_drm_hdmi.c file
      drm/exynos: Use devm_* functions in exynos_drm_g2d.c file
      drm/exynos: Add dependency for G2D in Kconfig
      drm/exynos: Make g2d_pm_ops static
      drm/exynos: Add missing braces around sizeof in exynos_hdmi.c
      drm/exynos: Add missing braces around sizeof in exynos_mixer.c

Thomas Meyer (1):
      drm/exynos: Use ERR_CAST inlined function instead of ERR_PTR(PTR_ERR(.. [1]

Tomasz Stanislawski (1):
      drm/exynos: add dummy support for dmabuf-mmap

Ville Syrjälä (1):
      drm: Drop the NV12M and YUV420M formats

 drivers/gpu/drm/exynos/Kconfig             |   2 +-
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c |   7 ++
 drivers/gpu/drm/exynos/exynos_drm_drv.c    |   2 -
 drivers/gpu/drm/exynos/exynos_drm_fimd.c   |   5 -
 drivers/gpu/drm/exynos/exynos_drm_g2d.c    |  52 ++-------
 drivers/gpu/drm/exynos/exynos_drm_gem.c    |   4 +-
 drivers/gpu/drm/exynos/exynos_drm_hdmi.c   |   3 +-
 drivers/gpu/drm/exynos/exynos_drm_plane.c  |   1 -
 drivers/gpu/drm/exynos/exynos_drm_vidi.c   |   4 +-
 drivers/gpu/drm/exynos/exynos_hdmi.c       |  11 +-
 drivers/gpu/drm/exynos/exynos_mixer.c      |   6 +-
 drivers/gpu/drm/gma500/oaktrail_device.c   |   2 +
 drivers/gpu/drm/i915/i915_dma.c            |   1 +
 drivers/gpu/drm/i915/i915_irq.c            |   3 -
 drivers/gpu/drm/i915/intel_display.c       |   6 +-
 drivers/gpu/drm/i915/intel_dp.c            |  11 +-
 drivers/gpu/drm/i915/intel_panel.c         |  31 ++++--
 drivers/gpu/drm/i915/intel_pm.c            |   3 +
 drivers/gpu/drm/i915/intel_sdvo.c          |  15 ++-
 drivers/gpu/drm/nouveau/nouveau_display.c  |   2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c     | 163 +++++++++++++++++++++++------
 drivers/gpu/drm/radeon/radeon_fence.c      |   8 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c        |   5 +
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h        |  10 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c   |  73 +++++++++++++
 include/drm/drm_fourcc.h                   |   6 +-
 26 files changed, 298 insertions(+), 138 deletions(-)
--29444707-1953620635-1347618266=:21518--
