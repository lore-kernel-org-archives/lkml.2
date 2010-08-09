Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074Ab0HIW4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 18:56:46 -0400
Received: from gir.skynet.ie ([193.1.99.77]:45913 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755055Ab0HIW4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 18:56:41 -0400
Date: Mon, 9 Aug 2010 23:56:26 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm tree some more bits
Message-ID: <alpine.DEB.2.00.1008092349350.20864@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1259364222-1281394586=:20864"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1259364222-1281394586=:20864
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT


The main reason for this, is Ben got a nvidia fermi card and added 
modesetting support just before the window opened, there is no accel 
support, but having kms support for these GPUs is a good start. Its all 
the GTX4xx cards.

The other bulk is because ajax moved a load of modes to their own header 
file because they were making things ugly, Alex added support for a new 
modesetting object that we are seeing used on radeons in the field, with 
this they can bring up a monitor in a few configurations that aren't 
possible before. Also there is an API change to the hyperz info ioctl we 
just added that we'd really like to make before -rc1 along with an oops 
fixer in that function.

Also myself and BenH discussed fixing pci domains a long time ago, and we 
forgot to finish the job, so his patch to make drm work on non-0 domains 
without breaking userspace is in here finally.

The following changes since commit 96576a9e1a0cdb8a43d3af5846be0948f52b4460:

  agp: intel-agp: do not use PCI resources before pci_enable_device() (2010-08-05 12:28:25 +1000)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-core-next

Adam Jackson (5):
      drm: Remove unused fields from drm_display_info
      drm/edid: Add detailed block walk for CEA extensions
      drm/edid: Add detailed block walk for VTB extensions
      drm/edid: Rewrite mode parse to use the generic detailed block walk
      drm/edid: Split mode lists out to their own header for readability

Alex Deucher (7):
      drm/radeon/kms: clean up r6xx/r7xx blit init
      drm/radeon/kms: r600 CS parser fixes
      drm/radeon/kms: unify i2c handling
      drm/radeon/kms: rework combios i2c handling
      drm/radeon/kms: add support for router objects
      drm/radeon/kms: add additional quirk for Acer rv620 laptop
      drm/radeon/kms: mark 3D power states as performance

Ben Skeggs (11):
      drm/nv50: use custom i2c algo for dp auxch
      drm/nouveau: remove unused ttm bo list
      drm/nvc0: starting point for GF100 support, everything stubbed
      drm/nvc0: allow INIT_GPIO
      drm/nvc0: implement memory detection
      drm/nvc0: rudimentary instmem support
      drm/nvc0: fix evo dma object so we display something
      drm/nvc0: implement crtc pll setting
      drm/nvc0: backup bar3 channel on suspend
      drm/nouveau: reduce severity of some "error" messages
      drm/nvc0: fix typo in PRAMIN flush

Benjamin Herrenschmidt (1):
      drm: Fix support for PCI domains

Chris Wilson (3):
      drm: Propagate error code from fb_create()
      drm: Only set DPMS once on the CRTC not after every encoder.
      drm: Use ENOENT consistently for the error return for an unmatched handle.

Dan Carpenter (2):
      drm/nouveau: unwind on load errors
      radeon: handle errors in radeon_hwmon_init()

Dave Airlie (1):
      Merge remote branch 'nouveau/for-airlied' of /ssd/git/drm-nouveau-next into drm-core-next

Dr. David Alan Gilbert (1):
      drm/radeon/kms: add missing copy from user

Francisco Jerez (13):
      drm/nouveau: Fix AGP reset when AGP FW is already enabled on init.
      drm/nouveau: Don't pass misaligned offsets to io_mapping_map_atomic_wc().
      drm/nouveau: Fix the INIT_CONFIGURE_PREINIT BIOS opcode.
      drm/nouveau: Ack the context switch interrupt before switching contexts.
      drm/nv10: Fix up switching of NV10TCL_DMA_VTXBUF.
      drm/nv17-nv4x: Attempt to init some external TMDS transmitters.
      drm/nouveau: No need to set slave TV encoder configs explicitly.
      drm/nv30: Workaround dual TMDS brain damage.
      drm/nouveau: Init dcb->or on cards that have no usable DCB table.
      drm/i2c/ch7006: Don't use POWER_LEVEL_FULL_POWER_OFF on early chip versions.
      drm/nv04: Fix up SGRAM density detection.
      drm/nv30: Fix PFB init for nv31.
      drm/nouveau: Fix DCB TMDS config parsing.

James Simmons (1):
      drm: expand gamma_set

Marcin Ko¶cielnicki (2):
      drm/nouveau: implement init table op 0x57, INIT_LTIME
      drm/nouveau: implement init table opcodex 0x5e and 0x9a

Marek Ol¹ák (1):
      drm/radeon: add a way to revoke hyper-z access

 drivers/gpu/drm/drm_crtc.c                  |    6 +-
 drivers/gpu/drm/drm_crtc_helper.c           |   10 +-
 drivers/gpu/drm/drm_edid.c                  |  841 +++++++++------------------
 drivers/gpu/drm/drm_edid_modes.h            |  380 ++++++++++++
 drivers/gpu/drm/drm_gem.c                   |    2 +-
 drivers/gpu/drm/drm_ioctl.c                 |    1 +
 drivers/gpu/drm/i2c/ch7006_drv.c            |    1 +
 drivers/gpu/drm/i2c/ch7006_mode.c           |    5 +-
 drivers/gpu/drm/i2c/ch7006_priv.h           |    1 +
 drivers/gpu/drm/i915/i915_gem.c             |   26 +-
 drivers/gpu/drm/i915/i915_gem_tiling.c      |    4 +-
 drivers/gpu/drm/i915/intel_display.c        |   15 +-
 drivers/gpu/drm/i915/intel_fb.c             |    4 +-
 drivers/gpu/drm/nouveau/Makefile            |    8 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c      |  194 ++++++-
 drivers/gpu/drm/nouveau/nouveau_bios.h      |    1 +
 drivers/gpu/drm/nouveau/nouveau_bo.c        |    6 -
 drivers/gpu/drm/nouveau/nouveau_connector.c |   19 +-
 drivers/gpu/drm/nouveau/nouveau_display.c   |    6 +-
 drivers/gpu/drm/nouveau/nouveau_dp.c        |   87 ++--
 drivers/gpu/drm/nouveau/nouveau_drv.h       |   45 ++-
 drivers/gpu/drm/nouveau/nouveau_encoder.h   |    6 +
 drivers/gpu/drm/nouveau/nouveau_fbcon.c     |    2 +
 drivers/gpu/drm/nouveau/nouveau_gem.c       |    8 +-
 drivers/gpu/drm/nouveau/nouveau_hw.c        |   11 +-
 drivers/gpu/drm/nouveau/nouveau_i2c.c       |   41 +-
 drivers/gpu/drm/nouveau/nouveau_i2c.h       |    8 +-
 drivers/gpu/drm/nouveau/nouveau_irq.c       |    6 +-
 drivers/gpu/drm/nouveau/nouveau_mem.c       |   15 +-
 drivers/gpu/drm/nouveau/nouveau_reg.h       |   18 +-
 drivers/gpu/drm/nouveau/nouveau_state.c     |   91 +++-
 drivers/gpu/drm/nouveau/nv04_crtc.c         |   15 +-
 drivers/gpu/drm/nouveau/nv04_dfp.c          |   73 +++
 drivers/gpu/drm/nouveau/nv04_tv.c           |   10 +-
 drivers/gpu/drm/nouveau/nv10_graph.c        |  175 ++++--
 drivers/gpu/drm/nouveau/nv30_fb.c           |   24 +-
 drivers/gpu/drm/nouveau/nv50_crtc.c         |   34 +-
 drivers/gpu/drm/nouveau/nv50_display.c      |    5 +-
 drivers/gpu/drm/nouveau/nvc0_fb.c           |   38 ++
 drivers/gpu/drm/nouveau/nvc0_fifo.c         |   96 +++
 drivers/gpu/drm/nouveau/nvc0_graph.c        |   75 +++
 drivers/gpu/drm/nouveau/nvc0_instmem.c      |  232 ++++++++
 drivers/gpu/drm/radeon/r600.c               |   14 +-
 drivers/gpu/drm/radeon/r600_blit_kms.c      |   16 +-
 drivers/gpu/drm/radeon/r600_cs.c            |   27 +-
 drivers/gpu/drm/radeon/radeon.h             |    2 +
 drivers/gpu/drm/radeon/radeon_atombios.c    |  180 +++++-
 drivers/gpu/drm/radeon/radeon_combios.c     |  388 ++++++-------
 drivers/gpu/drm/radeon/radeon_connectors.c  |   45 +-
 drivers/gpu/drm/radeon/radeon_cs.c          |    2 +-
 drivers/gpu/drm/radeon/radeon_cursor.c      |    2 +-
 drivers/gpu/drm/radeon/radeon_display.c     |   34 +-
 drivers/gpu/drm/radeon/radeon_gem.c         |   12 +-
 drivers/gpu/drm/radeon/radeon_i2c.c         |   82 +++
 drivers/gpu/drm/radeon/radeon_kms.c         |   28 +-
 drivers/gpu/drm/radeon/radeon_mode.h        |   24 +
 drivers/gpu/drm/radeon/radeon_pm.c          |   24 +-
 drivers/gpu/drm/radeon/rv770.c              |   14 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c         |    8 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c         |    2 +-
 include/drm/drmP.h                          |   22 +-
 include/drm/drm_core.h                      |    2 +-
 include/drm/drm_crtc.h                      |   37 +--
 include/drm/drm_edid.h                      |    6 +
 64 files changed, 2431 insertions(+), 1185 deletions(-)
 create mode 100644 drivers/gpu/drm/drm_edid_modes.h
 create mode 100644 drivers/gpu/drm/nouveau/nvc0_fb.c
 create mode 100644 drivers/gpu/drm/nouveau/nvc0_fifo.c
 create mode 100644 drivers/gpu/drm/nouveau/nvc0_graph.c
 create mode 100644 drivers/gpu/drm/nouveau/nvc0_instmem.c
--29444707-1259364222-1281394586=:20864--
