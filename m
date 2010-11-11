Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab0KKAYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 19:24:42 -0500
Received: from gir.skynet.ie ([193.1.99.77]:40490 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756699Ab0KKAYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 19:24:41 -0500
Date: Thu, 11 Nov 2010 00:24:27 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1011110021320.12522@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-45100448-1289435067=:12522"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-45100448-1289435067=:12522
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

This is a bunch of drm fixes, it includes couple of regression fixers on 
radeon that could cause oops/memory corruptions, along with few Intel 
fixers. It also fixes the Kconfig for the poulsbo stub.

I've started taking Chris's pull requests now, so all the intel drm 
changes should start coming via my tree always now, unless they are pretty 
exceptional or I'm away.

Dave.

The following changes since commit a7bcf21e60c73cb7f7c13fad928967d7e47c3cac:

  Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2010-11-08 11:54:53 -0800)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (5):
      drm/radeon/kms/evergreen: add missing pm.vblank_sync update in vbl handler
      drm/radeon/kms: make the connector code less verbose
      drm/radeon/kms: don't disable shared encoders on pre-DCE3 display blocks
      drm/radeon/kms: add support for clock/data path routers
      drm/radeon/kms: fix thermal sensor reporting on rv6xx

Chris Wilson (7):
      drm/i915: Flush read-only buffers from the active list upon idle as well
      drm/i915: Apply big hammer to serialise buffer access between rings
      drm/i915: Allow powersave modparam to be adjusted at runtime.
      drm/i915: SNB BLT workaround
      drm/i915: Avoid might_fault during pwrite whilst holding our mutex
      drm/i915/ringbuffer: Use the HEAD auto-reporting mechanism
      drm/i915: Fix LVDS fixed-mode regression from 219adae1

Christoph Fritz (1):
      drm/i915: opregion_setup: iounmap correct address

Dan Carpenter (1):
      i915: signedness bug in check_overlay_src()

Dave Airlie (1):
      Merge branch 'drm-intel-fixes' of git://git.kernel.org/.../ickle/drm-intel

Ingo Molnar (1):
      drm/stub/Kconfig: fix Kconfig for stub driver.

Jesse Barnes (1):
      drm/i915: Fix the graphics frequency clamping at init and when IPS is active.

Joe Perches (3):
      drivers/gpu/drm/vmwgfx: Fix k.alloc switched arguments
      drivers/gpu/drm: Update WARN uses
      drivers/gpu: Use vzalloc

Kulikov Vasiliy (1):
      drm: vmwgfx: fix information leak to userland

Kyle McMartin (1):
      i915: reprogram power monitoring registers on resume

Michel Dänzer (1):
      drm/radeon/kms: Fix retrying ttm_bo_init() after it failed once.

Sam Tygier (1):
      DRM: ignore invalid EDID extensions

Takashi Iwai (1):
      drm/i915: Fix typo from "Enable DisplayPort Audio"

Thomas Hellstrom (10):
      drm/ttm: Documentation update
      drm/ttm: Use private locks for the default bo range manager
      drm/ttm: Remove pointless list_empty check
      drm/ttm: Remove mm init error printouts and checks
      drm/ttm: Add a barrier when unreserving
      drm/ttm: remove failed ttm binding error printout
      drm/ttm: Make sure a sync object doesn't disappear while we use it
      drm/ttm: Remove the CAP_SYS_ADMIN requirement for bo pinning
      drm/vmwgfx: Fix oops on failing bo pin
      drm/ttm: Be consistent on ttm_bo_init() failures

Tyson Whitehead (1):
      drm/radeon/kms: fix bugs in ddc and cd path router code

Zhenyu Wang (4):
      drm/i915: Fix KMS regression on Sandybridge/CPT
      drm/i915; Don't apply Ironlake FDI clock workaround to Sandybridge
      agp/intel: restore cache behavior on sandybridge
      agp/intel: fix cache control for sandybridge

 drivers/char/agp/intel-gtt.c               |    6 +-
 drivers/gpu/drm/drm_crtc_helper.c          |    2 +-
 drivers/gpu/drm/drm_edid.c                 |   26 +++++--
 drivers/gpu/drm/i915/i915_drv.c            |    2 +-
 drivers/gpu/drm/i915/i915_drv.h            |    1 +
 drivers/gpu/drm/i915/i915_gem.c            |  118 +++++++++++++++----------
 drivers/gpu/drm/i915/i915_gem_evict.c      |    8 +--
 drivers/gpu/drm/i915/i915_suspend.c        |    4 +-
 drivers/gpu/drm/i915/intel_display.c       |   70 +++++++++------
 drivers/gpu/drm/i915/intel_dp.c            |    2 +-
 drivers/gpu/drm/i915/intel_drv.h           |    1 +
 drivers/gpu/drm/i915/intel_lvds.c          |   16 +++-
 drivers/gpu/drm/i915/intel_opregion.c      |    2 +-
 drivers/gpu/drm/i915/intel_overlay.c       |    4 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c    |  129 +++++++++++++++++++++++++++-
 drivers/gpu/drm/i915/intel_ringbuffer.h    |    3 +
 drivers/gpu/drm/radeon/evergreen.c         |    8 ++-
 drivers/gpu/drm/radeon/r100.c              |    4 +-
 drivers/gpu/drm/radeon/r300.c              |    2 +-
 drivers/gpu/drm/radeon/r600.c              |   12 +--
 drivers/gpu/drm/radeon/radeon_atombios.c   |   27 ++++--
 drivers/gpu/drm/radeon/radeon_connectors.c |   16 ++--
 drivers/gpu/drm/radeon/radeon_display.c    |   18 +++--
 drivers/gpu/drm/radeon/radeon_encoders.c   |   26 ++++++
 drivers/gpu/drm/radeon/radeon_fence.c      |    3 +-
 drivers/gpu/drm/radeon/radeon_i2c.c        |   41 +++++++--
 drivers/gpu/drm/radeon/radeon_mode.h       |   17 +++-
 drivers/gpu/drm/radeon/radeon_object.c     |    4 +-
 drivers/gpu/drm/radeon/radeon_ttm.c        |    3 +-
 drivers/gpu/drm/radeon/rs400.c             |    2 +-
 drivers/gpu/drm/radeon/rs600.c             |    4 +-
 drivers/gpu/drm/ttm/ttm_bo.c               |   86 +++++--------------
 drivers/gpu/drm/ttm/ttm_bo_manager.c       |   81 ++++++++++--------
 drivers/gpu/drm/ttm/ttm_tt.c               |    4 +-
 drivers/gpu/drm/via/via_dmablit.c          |    4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c    |    1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c        |    5 +
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c        |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c    |    2 +-
 drivers/gpu/stub/Kconfig                   |    3 +
 include/drm/ttm/ttm_bo_api.h               |    4 +
 include/drm/ttm/ttm_bo_driver.h            |   79 ++++++++++++++++-
 42 files changed, 577 insertions(+), 275 deletions(-)
--29444707-45100448-1289435067=:12522--
