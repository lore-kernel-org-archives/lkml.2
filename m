Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab0HWDeH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 23:34:07 -0400
Received: from gir.skynet.ie ([193.1.99.77]:48716 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179Ab0HWDeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 23:34:04 -0400
Date: Mon, 23 Aug 2010 04:33:49 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1008230431490.7906@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Mostly radeon and nouveau regression fixes + one AGP regression fix, along 
with the information leak + not possible but should be checked for 
corruption.

Dave.

The following changes since commit 31ce4bfdfd10bf5db9bf85c92bbe0cf2edbdcad8:

  io-mapping: move asm include inside the config option (2010-08-12 11:47:50 +1000)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-core-next

Alex Deucher (15):
      drm/radeon/kms: DCE3/4 AdjustPixelPll updates
      drm/radeon/kms: rework encoder handling
      drm/radeon/kms: DCE3/4 transmitter fixes
      drm/radeon/kms/atom: clean up dig atom handling
      drm/radeon/kms/pm: bail early if nothing's changing
      drm/radeon/kms/DCE3+: switch pads to ddc mode when going i2c
      drm/radeon/kms: add missing asic callback assignment for evergreen
      drm/radeon/kms: rework radeon_dp_detect() logic
      drm/radeon/kms: fix agp mode setup on cards that use pcie bridges
      drm/radeon/kms: don't enable MSIs on AGP boards
      drm/radeon/kms: add back missing break in info ioctl
      drm/radeon/kms: set encoder type to DVI for HDMI on evergreen
      drm/radeon/kms: fix sideport detection on newer rs880 boards
      drm/radeon/kms: try to detect tv vs monitor for underscan
      drm/radeon/kms: fix typo in radeon_compute_pll_gain

Ben Skeggs (8):
      drm/nv50: fix minor thinko from nvc0 changes
      drm/nouveau: fix race condition when under memory pressure
      drm/nouveau: check for error when allocating/mapping dummy page
      drm/nouveau: remove warning about unknown tmds table revisions
      drm/nouveau: punt some more log messages to debug level
      drm/nv50-nvc0: ramht_size is meant to be in bytes, not entries
      drm/nvc0: fix thinko in instmem suspend/resume
      drm/nouveau: fix earlier mistake when fixing merge conflict

Dan Carpenter (2):
      drm: fix end of loop test
      drm: move dereference below check

Dave Airlie (4):
      drm: stop information leak of old kernel stack.
      drm: block userspace under allocating buffer and having drivers overwrite it (v2)
      drm/radeon: fix passing wrong type to gem object create.
      Merge remote branch 'nouveau/for-airlied' of /ssd/git/drm-nouveau-next into drm-core-next

Francisco Jerez (3):
      drm/nouveau: Don't try DDC on the dummy I2C channel.
      drm/nouveau: Add TV-out quirk for an MSI nForce2 IGP.
      drm/nouveau: Workaround missing GPIO tables on an Apple iMac G4 NV18.

Jean Delvare (1):
      drm/radeon: Fix stack data leak

Jerome Glisse (1):
      drm/radeon/kms: fix GTT/VRAM overlapping test

 drivers/gpu/drm/drm_drv.c                       |   25 ++-
 drivers/gpu/drm/drm_fb_helper.c                 |    3 +-
 drivers/gpu/drm/drm_vm.c                        |    2 +-
 drivers/gpu/drm/i810/i810_dma.c                 |   30 ++--
 drivers/gpu/drm/i830/i830_dma.c                 |   28 ++--
 drivers/gpu/drm/i915/i915_dma.c                 |   80 ++++----
 drivers/gpu/drm/mga/mga_state.c                 |   26 ++--
 drivers/gpu/drm/nouveau/nouveau_bios.c          |   42 +++--
 drivers/gpu/drm/nouveau/nouveau_bo.c            |   15 ++
 drivers/gpu/drm/nouveau/nouveau_channel.c       |   24 ++--
 drivers/gpu/drm/nouveau/nouveau_connector.c     |    6 +-
 drivers/gpu/drm/nouveau/nouveau_drv.h           |    1 +
 drivers/gpu/drm/nouveau/nouveau_gem.c           |   36 +++-
 drivers/gpu/drm/nouveau/nouveau_i2c.c           |    2 +-
 drivers/gpu/drm/nouveau/nouveau_sgdma.c         |   12 +-
 drivers/gpu/drm/nouveau/nv17_tv.c               |    8 +
 drivers/gpu/drm/nouveau/nv50_instmem.c          |    2 +-
 drivers/gpu/drm/nouveau/nvc0_instmem.c          |   13 +-
 drivers/gpu/drm/r128/r128_state.c               |   35 ++--
 drivers/gpu/drm/radeon/atombios_crtc.c          |   51 +++++-
 drivers/gpu/drm/radeon/atombios_dp.c            |    2 +-
 drivers/gpu/drm/radeon/radeon_agp.c             |    8 +-
 drivers/gpu/drm/radeon/radeon_asic.c            |    1 +
 drivers/gpu/drm/radeon/radeon_atombios.c        |   39 +++--
 drivers/gpu/drm/radeon/radeon_combios.c         |  104 ++++++------
 drivers/gpu/drm/radeon/radeon_connectors.c      |   26 +--
 drivers/gpu/drm/radeon/radeon_device.c          |    2 +-
 drivers/gpu/drm/radeon/radeon_display.c         |   15 ++-
 drivers/gpu/drm/radeon/radeon_encoders.c        |  223 ++++++++++++-----------
 drivers/gpu/drm/radeon/radeon_fb.c              |    2 +-
 drivers/gpu/drm/radeon/radeon_i2c.c             |    7 +
 drivers/gpu/drm/radeon/radeon_irq_kms.c         |    5 +-
 drivers/gpu/drm/radeon/radeon_kms.c             |   79 ++++----
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c     |    2 +-
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    7 +-
 drivers/gpu/drm/radeon/radeon_mode.h            |    3 +-
 drivers/gpu/drm/radeon/radeon_pm.c              |    5 +
 drivers/gpu/drm/radeon/radeon_state.c           |   56 +++---
 drivers/gpu/drm/savage/savage_bci.c             |    8 +-
 drivers/gpu/drm/sis/sis_mm.c                    |   12 +-
 drivers/gpu/drm/via/via_dma.c                   |   28 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c             |   34 ++--
 include/drm/drmP.h                              |    6 +-
 include/drm/i830_drm.h                          |   28 ++--
 include/drm/i915_drm.h                          |    1 +
 include/drm/mga_drm.h                           |    2 +-
 include/drm/nouveau_drm.h                       |   13 ++
 include/drm/radeon_drm.h                        |    4 +-
 include/drm/savage_drm.h                        |    8 +-
 49 files changed, 676 insertions(+), 495 deletions(-)
