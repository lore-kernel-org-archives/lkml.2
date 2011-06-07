Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab1FGEgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 00:36:41 -0400
Received: from gir.skynet.ie ([193.1.99.77]:52150 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab1FGEgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 00:36:39 -0400
Date: Tue, 7 Jun 2011 05:36:02 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1106070533010.14714@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

this is just the Intel and nouveau fixes, this alongside the radeon fixes 
pull that is outstanding, it has one serious intel regression fix for 945 
machines that got broken in the ivybridge support, along with a few fixes 
from nouveau.

Dave.

The following changes since commit 59c5f46fbe01a00eedf54a23789634438bb80603:

  Linux 3.0-rc2 (2011-06-06 18:06:33 +0900)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Ben Skeggs (5):
      drm/nvc0: recognise 0xdX chipsets as NV_C0
      drm/nouveau: don't create accel engine objects when noaccel=1
      drm/nouveau: fix vram page mapping when crossing page table boundaries
      drm/nouveau: fix leak of gart mm node
      drm/nv40: fall back to paged dma object for the moment

Chris Wilson (5):
      drm/i915: s/addr & ~PAGE_MASK/offset_in_page(addr)/
      drm/i915: Replace ironlake_compute_wm0 with g4x_compute_wm0
      drm/i915/crt: Explicitly return false if connected to a digital monitor
      drm/i915: Remove unused enum "chip_family"
      drm/i915: Share the common force-audio property between connectors

Dan Carpenter (1):
      drm/i915: fix if statement in ivybridge irq handler

Daniel Vetter (2):
      drm/i915: Only print out the actual number of fences for i915_error_state
      drm/915: fix relaxed tiling on gen2: tile height

Dave Airlie (2):
      Merge remote branch 'keithp/drm-intel-fixes' of /ssd/git/drm-next into drm-fixes
      Merge remote branch 'nouveau/drm-nouveau-fixes' of /ssd/git/drm-nouveau-next into drm-fixes

Francisco Jerez (1):
      drm/nv17-nv40: Fix modesetting failure when pitch == 4096px (fdo bug 35901).

Hans de Goede (1):
      drm/i915: Add a no lvds quirk for the Asus EeeBox PC EB1007

Jason Stubbs (1):
      drm/i915: fix regression after clock gating init split

Nicolas Kaiser (1):
      drm: i915: correct return status in intel_hdmi_mode_valid()

 drivers/gpu/drm/i915/i915_debugfs.c     |    2 +-
 drivers/gpu/drm/i915/i915_drv.h         |    8 +--
 drivers/gpu/drm/i915/i915_gem.c         |   26 ++++----
 drivers/gpu/drm/i915/i915_irq.c         |    2 +-
 drivers/gpu/drm/i915/intel_crt.c        |    4 +
 drivers/gpu/drm/i915/intel_display.c    |   89 ++++++------------------
 drivers/gpu/drm/i915/intel_dp.c         |   15 +----
 drivers/gpu/drm/i915/intel_drv.h        |    1 +
 drivers/gpu/drm/i915/intel_hdmi.c       |   16 +----
 drivers/gpu/drm/i915/intel_lvds.c       |    8 ++
 drivers/gpu/drm/i915/intel_modes.c      |   30 ++++++++
 drivers/gpu/drm/i915/intel_sdvo.c       |   14 +---
 drivers/gpu/drm/nouveau/nouveau_hw.c    |    2 +
 drivers/gpu/drm/nouveau/nouveau_mem.c   |    4 +-
 drivers/gpu/drm/nouveau/nouveau_sgdma.c |    2 +-
 drivers/gpu/drm/nouveau/nouveau_state.c |  114 ++++++++++++++++---------------
 drivers/gpu/drm/nouveau/nouveau_vm.c    |    1 +
 drivers/gpu/drm/nouveau/nv04_crtc.c     |    8 ++-
 drivers/gpu/drm/nouveau/nvreg.h         |    2 +
 19 files changed, 161 insertions(+), 187 deletions(-)
