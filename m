Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179Ab0KSBWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 20:22:13 -0500
Received: from gir.skynet.ie ([193.1.99.77]:47815 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585Ab0KSBWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 20:22:12 -0500
Date: Fri, 19 Nov 2010 01:21:57 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1011190118480.8681@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Just a fixes tree for -rc3 if possible, it did get rebased recently as I 
had to get the nouveau pull cleaned, but I'd been running the non-nouveau 
bits for a few days, there is also one late regression fix from Alex and 
some fixups after Jean pushed an i2c change that broke the kms drivers.

Otherwise its mostly just modesetting fixups and radeon tiling fixes.

Dave.

The following changes since commit 0143832cc96d0bf78486297aad5c8fb2c2ead02a:

  Merge branch 'urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6 (2010-11-13 10:00:15 -0800)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (12):
      drm/radeon/kms: fix and unify tiled buffer alignment checking for r6xx/7xx
      drm/radeon/kms: fix typo in r600 cs checker
      drm/radeon/kms: turn the backlight off explicitly for dpms
      drm/radeon/kms/atom: set sane defaults in atombios_get_encoder_mode()
      drm/radeon/kms: properly power up/down the eDP panel as needed (v4)
      drm/radeon/kms/atom: cleanup and unify DVO handling
      drm/radeon/kms/atom: add proper external encoders support
      drm/radeon/kms: register an i2c adapter name for the dp aux bus
      drm/radeon/kms: fix alignment when allocating buffers
      drm/radeon/kms: fix tiling info on evergreen
      drm/radeon/kms: fix i2c pad masks on rs4xx
      drm/radeon/kms: i2c s/sprintf/snprintf/g for safety

Andy Lutomirski (1):
      nouveau: Acknowledge HPD irq in handler, not bottom half

Ben Skeggs (3):
      drm/nva3: fix overflow in fixed point math used for pll calculation
      drm/nv50: implement possible workaround for NV86 PGRAPH TLB flush hang
      drm/nouveau: don't expose backlight control when available through ACPI

Dave Airlie (1):
      Merge remote branch 'nouveau/for-airlied' of /ssd/git/drm-nouveau-next into drm-fixes

Francisco Jerez (17):
      drm/nouveau: Fix sleep while atomic in the semaphore code.
      drm/nouveau: Reject modes exceeding the integrated TMDS maximum bandwidth.
      drm/nv04-nv40: Fall back to panel rescaling if we have no usable native mode.
      drm/nv11: Fix bad PLL detection false positive.
      drm/nouveau: Some random cleanups.
      drm/nouveau: Avoid lock dependency between ramht and ramin spinlocks.
      drm/nouveau: Reduce severity of the unknown getparam error.
      drm/nouveau: Expose some BO usage flags to userspace.
      drm/nv10: Balance RTs expected to be accessed simultaneously by the 3d engine.
      drm/nv04: Fix scanout over the 16MB mark.
      drm/nouveau: Use "force" to decide if analog load detection is ok or not.
      drm/nouveau: Don't poll LVDS outputs.
      drm/nv10-nv20: Fix instability after MPLL changes.
      drm/nouveau: Don't use load detection for connector polling.
      drm/nouveau: Return error from nouveau_gpuobj_new if we're out of RAMIN.
      drm/nouveau: Make PCIE GART size depend on the available RAMIN space.
      drm/nouveau: Fix a few confusions between "chipset" and "card_type".

Jiri Slaby (1):
      drm/nouveau: ratelimit IRQ messages

Lucas Stach (1):
      drm/nouveau: fix nv40 pcie gart size

Martin Peres (1):
      drm/nouveau: Fix compilation issues in nouveau_pm when CONFIG_HWMON is not set

Roy Spliet (1):
      drm/nouveau/pm: improve memtiming mappings

Thomas Hellstrom (2):
      drm/vmwgfx: Fix up an error path during bo creation
      drm/ttm: Fix up a theoretical deadlock

Vasiliy Kulikov (1):
      drm: radeon: fix error value sign

 drivers/gpu/drm/nouveau/nouveau_backlight.c     |    9 +
 drivers/gpu/drm/nouveau/nouveau_bios.c          |    2 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c            |   43 +++-
 drivers/gpu/drm/nouveau/nouveau_connector.c     |   77 ++---
 drivers/gpu/drm/nouveau/nouveau_connector.h     |    3 -
 drivers/gpu/drm/nouveau/nouveau_drv.h           |   55 +---
 drivers/gpu/drm/nouveau/nouveau_fence.c         |    7 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c           |   36 ++-
 drivers/gpu/drm/nouveau/nouveau_hw.c            |    8 +-
 drivers/gpu/drm/nouveau/nouveau_hw.h            |   19 ++
 drivers/gpu/drm/nouveau/nouveau_i2c.c           |    2 +-
 drivers/gpu/drm/nouveau/nouveau_irq.c           |   42 ++--
 drivers/gpu/drm/nouveau/nouveau_mem.c           |   49 ++--
 drivers/gpu/drm/nouveau/nouveau_object.c        |    2 +-
 drivers/gpu/drm/nouveau/nouveau_pm.c            |    7 +-
 drivers/gpu/drm/nouveau/nouveau_ramht.c         |   71 +++--
 drivers/gpu/drm/nouveau/nouveau_sgdma.c         |   14 +-
 drivers/gpu/drm/nouveau/nouveau_state.c         |   17 +-
 drivers/gpu/drm/nouveau/nouveau_temp.c          |    2 +-
 drivers/gpu/drm/nouveau/nv04_crtc.c             |    7 +-
 drivers/gpu/drm/nouveau/nv04_dfp.c              |   13 +-
 drivers/gpu/drm/nouveau/nv04_pm.c               |    9 +
 drivers/gpu/drm/nouveau/nv50_calc.c             |   16 +-
 drivers/gpu/drm/nouveau/nv50_crtc.c             |    4 +-
 drivers/gpu/drm/nouveau/nv50_display.c          |   35 ++-
 drivers/gpu/drm/nouveau/nv50_fifo.c             |    5 +
 drivers/gpu/drm/nouveau/nv50_graph.c            |   52 ++++
 drivers/gpu/drm/nouveau/nv50_instmem.c          |    1 -
 drivers/gpu/drm/radeon/evergreen.c              |   31 ++-
 drivers/gpu/drm/radeon/evergreen_blit_kms.c     |    2 +-
 drivers/gpu/drm/radeon/r600.c                   |    2 +-
 drivers/gpu/drm/radeon/r600_blit_kms.c          |    2 +-
 drivers/gpu/drm/radeon/r600_cs.c                |  311 ++++++++++++--------
 drivers/gpu/drm/radeon/r600d.h                  |    6 +
 drivers/gpu/drm/radeon/radeon.h                 |    4 +
 drivers/gpu/drm/radeon/radeon_benchmark.c       |    4 +-
 drivers/gpu/drm/radeon/radeon_combios.c         |   13 +
 drivers/gpu/drm/radeon/radeon_connectors.c      |   18 ++
 drivers/gpu/drm/radeon/radeon_device.c          |    2 +-
 drivers/gpu/drm/radeon/radeon_encoders.c        |  356 ++++++++++++++++++++---
 drivers/gpu/drm/radeon/radeon_gart.c            |    4 +-
 drivers/gpu/drm/radeon/radeon_gem.c             |    2 +-
 drivers/gpu/drm/radeon/radeon_i2c.c             |    8 +-
 drivers/gpu/drm/radeon/radeon_irq.c             |    4 +-
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    2 +-
 drivers/gpu/drm/radeon/radeon_mode.h            |    5 +-
 drivers/gpu/drm/radeon/radeon_object.c          |    7 +-
 drivers/gpu/drm/radeon/radeon_object.h          |    7 +-
 drivers/gpu/drm/radeon/radeon_ring.c            |    6 +-
 drivers/gpu/drm/radeon/radeon_test.c            |    4 +-
 drivers/gpu/drm/radeon/radeon_ttm.c             |    2 +-
 drivers/gpu/drm/radeon/rv770.c                  |    4 +-
 drivers/gpu/drm/ttm/ttm_bo.c                    |   11 +
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c        |   14 +-
 include/drm/nouveau_drm.h                       |    7 +
 55 files changed, 1021 insertions(+), 424 deletions(-)
