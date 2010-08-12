Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996Ab0HLB7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 21:59:15 -0400
Received: from gir.skynet.ie ([193.1.99.77]:58609 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758831Ab0HLB7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 21:59:13 -0400
Date: Thu, 12 Aug 2010 02:58:58 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes + nouveau update
Message-ID: <alpine.DEB.2.00.1008120258230.2271@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-268306906-1281578338=:2271"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-268306906-1281578338=:2271
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT


Hi Linus,

repeat request with some additional fixes, nouveau started using io-mapping and this made ppc64 build unhappy, and also make the m68k build happier by dropping unneeded vga.h from vgaarb. Two powerpc radeon kms fixes, and two radeon command checker fixes.

The optimist in me is saying you just missed the previous pull req, the realist is saying I should drop the nouveau Fermi updates,
but since its a staging driver I don't think it should block this pull. I can drop the edid cleanups but they looked nice and not too
damaging.

So summary highlights from previous:
nouveau: add GTX4xx (Fermi) KMS support
radeon: i2c rework to fix problems on r600/700 cards that require i2c routing support.
core: fixed pci domain support that doesn't break userspace API

lots of misc fixes.

Dave.

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
      drm/radeon/kms: r600 CS parser fixes
      drm/radeon/kms: unify i2c handling
      drm/radeon/kms: rework combios i2c handling
      drm/radeon/kms: add support for router objects
      drm/radeon/kms: add additional quirk for Acer rv620 laptop
      drm/radeon/kms: mark 3D power states as performance
      drm/radeon/kms: another r6xx/r7xx CS checker fix

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

Benjamin Herrenschmidt (3):
      drm: Fix support for PCI domains
      drm/radeon: Fix pci_map_page() error checking
      drm/radeon: Add probing of clocks from device-tree

Chris Wilson (4):
      drm: Propagate error code from fb_create()
      drm: Only set DPMS once on the CRTC not after every encoder.
      drm: Use ENOENT consistently for the error return for an unmatched handle.
      drm: Remove count_lock for calling lastclose() after 58474713 (v2)

Dan Carpenter (2):
      drm/nouveau: unwind on load errors
      radeon: handle errors in radeon_hwmon_init()

Dave Airlie (4):
      Merge remote branch 'nouveau/for-airlied' of /ssd/git/drm-nouveau-next into drm-core-next
      drm/radeon: drop old and broken mesa warning
      vgaarb: drop vga.h include
      io-mapping: move asm include inside the config option

Davidlohr Bueso (1):
      DRM: Replace kmalloc/memset combos with kzalloc

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

Marek Ol¹ák (2):
      drm/radeon: add a way to revoke hyper-z access
      drm/radeon/kms: allow FG_ALPHA_VALUE on r5xx

 drivers/gpu/drm/ati_pcigart.c               |    2 +-
 drivers/gpu/drm/drm_bufs.c                  |   33 +-
 drivers/gpu/drm/drm_crtc.c                  |    6 +-
 drivers/gpu/drm/drm_crtc_helper.c           |   10 +-
 drivers/gpu/drm/drm_edid.c                  |  841 +++++++++------------------
 drivers/gpu/drm/drm_edid_modes.h            |  380 ++++++++++++
 drivers/gpu/drm/drm_fops.c                  |   16 +-
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
 drivers/gpu/drm/radeon/r600_cp.c            |    2 +-
 drivers/gpu/drm/radeon/r600_cs.c            |   33 +-
 drivers/gpu/drm/radeon/radeon.h             |    2 +
 drivers/gpu/drm/radeon/radeon_atombios.c    |  180 +++++-
 drivers/gpu/drm/radeon/radeon_clocks.c      |   81 +++
 drivers/gpu/drm/radeon/radeon_combios.c     |  388 ++++++-------
 drivers/gpu/drm/radeon/radeon_connectors.c  |   45 +-
 drivers/gpu/drm/radeon/radeon_cs.c          |    2 +-
 drivers/gpu/drm/radeon/radeon_cursor.c      |    2 +-
 drivers/gpu/drm/radeon/radeon_device.c      |    3 +-
 drivers/gpu/drm/radeon/radeon_display.c     |   34 +-
 drivers/gpu/drm/radeon/radeon_gem.c         |   12 +-
 drivers/gpu/drm/radeon/radeon_i2c.c         |   82 +++
 drivers/gpu/drm/radeon/radeon_kms.c         |   28 +-
 drivers/gpu/drm/radeon/radeon_mode.h        |   24 +
 drivers/gpu/drm/radeon/radeon_pm.c          |   24 +-
 drivers/gpu/drm/radeon/reg_srcs/rv515       |    1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c         |    8 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c         |    2 +-
 include/drm/drmP.h                          |   22 +-
 include/drm/drm_core.h                      |    2 +-
 include/drm/drm_crtc.h                      |   37 +--
 include/drm/drm_edid.h                      |    6 +
 include/linux/io-mapping.h                  |    3 +-
 include/linux/vgaarb.h                      |    1 -
 70 files changed, 2518 insertions(+), 1202 deletions(-)
 create mode 100644 drivers/gpu/drm/drm_edid_modes.h
 create mode 100644 drivers/gpu/drm/nouveau/nvc0_fb.c
 create mode 100644 drivers/gpu/drm/nouveau/nvc0_fifo.c
 create mode 100644 drivers/gpu/drm/nouveau/nvc0_graph.c
 create mode 100644 drivers/gpu/drm/nouveau/nvc0_instmem.c
--29444707-268306906-1281578338=:2271--
