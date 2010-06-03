Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933781Ab0FCD22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 23:28:28 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59182 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933730Ab0FCD20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 23:28:26 -0400
Date: Thu, 3 Jun 2010 04:28:07 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [git pull] drm updates
Message-ID: <alpine.DEB.2.00.1006030421120.21882@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1877074978-1275535687=:21882"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1877074978-1275535687=:21882
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT


Okay this isn't strictly all fixes, so pushback if you believe its too 
much.

vmware update: this is a staging driver and they are backport from a 
tested vmware tree, so I think they are low risk and align the staging 
driver with what vmware are working on.
evergreen command stream checker: lots of lines, but its a baseline to 
people to experiment on, it doesn't interact with any released userspace 
code yet so can't regress anything.

The rest is nouveau fixes from Ben, some nouveau/switcheroo fixes from me 
(one for a regression in -rc1), two trivial vgaarb patches, two TTM fixes 
(one for a regression in -rc1), and some typos in docs.

The following changes since commit cf22f20ade30f8c03955324aaf27b1049e182600:
  Dave Airlie (1):
        drm/radeon: fix the r100/r200 ums block 0 page fix

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

Alex Deucher (7):
      drm/radeon/kms/evergreen: add initial CS parser
      drm/radeon/kms/pm: add support for SetVoltage cmd table (V2)
      drm/radeon/kms/pm: enable SetVoltage on r7xx/evergreen
      drm/radeon/kms/pm: patch default power state with default clocks/voltages on r6xx+
      drm/radeon/kms/pm: radeon_set_power_state fixes
      drm/radeon/kms/pm: voltage fixes
      drm/radeon/kms: make sure display hw is disabled when suspending

Ben Skeggs (8):
      drm/nouveau: fix POST detection for certain chipsets
      drm/nv40: allow cold-booting of nv4x chipsets
      drm/nouveau: don't execute INIT_GPIO unless we're really running the table
      drm/nv50: fix duallink_possible calculation for DCB 4.0 cards
      drm/nv50: obey dcb->duallink_possible
      drm/nouveau: fix dual-link displays when plugged into single-link outputs
      drm/nv50: use alternate source of SOR_MODE_CTRL for DP hack
      drm/nv50: cast IGP memory location to u64 before shifting

Dave Airlie (6):
      drm/nouveau: attempt to get bios from ACPI v3
      drm/nouveau: fixup confusion over which handle the DSM is hanging off.
      drm/kms: disable/enable poll around switcheroo on/off
      Merge branch 'drm-vmware-fixes' into drm-testing
      Merge branch 'drm-switcheroo-fixes' into drm-testing
      Merge remote branch 'nouveau/for-airlied' of ../drm-nouveau-next into drm-testing

Jakob Bornecrantz (12):
      drm/vmwgfx: Assume larger framebuffer max size.
      drm/vmwgfx: Fix single framebuffer detection.
      drm/vmwgfx: Make sure to unpin old and pin new framebuffer.
      drm/vmwgfx: Get connector status from detection function.
      drm/vmwgfx: Support older hardware.
      drm/vmwgfx: Remove duplicate member from struct vmw_legacy_display_unit.
      drm/vmwgfx: Don't use SVGA_REG_ENABLE in modesetting code.
      drm/vmwgfx: Some modesetting cleanups and fixes.
      drm/vmwgfx: Unpause overlay on update.
      drm/vmwgfx: Print warnings in kernel log about bo pinning that fails.
      drm/vmwgfx: Fix framebuffer modesetting
      drm/vmwgfx: Allow userspace to change default layout. Bump minor.

Maarten Maathuis (1):
      drm/nouveau: allow cursor image and position to survive suspend

Marcin Ko¶cielnicki (1):
      drm/nouveau: Add getparam for current PTIMER time.

Nicolas Kaiser (1):
      drm: fix typos in Linux DRM Developer's Guide

Thomas Hellstrom (6):
      drm/vmwgfx: Add kernel throttling support. Bump minor.
      drm/vmwgfx: Reserve first part of VRAM for framebuffer.
      drm/vmwgfx: Remove some leftover debug messages.
      drm/ttm: Fix cached TTM page allocation.
      drm/ttm: Fix ttm_page_alloc.c
      drm/vmwgfx: Fix vga save / restore with display topology.

Tiago Vignatti (2):
      vgaarb: convert pr_devel() to pr_debug()
      vgaarb: use MIT license

 Documentation/DocBook/drm.tmpl              |   12 +-
 drivers/gpu/drm/drm_crtc_helper.c           |   28 +-
 drivers/gpu/drm/i915/i915_dma.c             |    4 +-
 drivers/gpu/drm/nouveau/nouveau_acpi.c      |   71 ++-
 drivers/gpu/drm/nouveau/nouveau_bios.c      |   71 ++-
 drivers/gpu/drm/nouveau/nouveau_connector.c |   34 +-
 drivers/gpu/drm/nouveau/nouveau_crtc.h      |    2 +
 drivers/gpu/drm/nouveau/nouveau_drv.c       |   29 +
 drivers/gpu/drm/nouveau/nouveau_drv.h       |    5 +
 drivers/gpu/drm/nouveau/nouveau_mem.c       |    3 +-
 drivers/gpu/drm/nouveau/nouveau_state.c     |    6 +
 drivers/gpu/drm/nouveau/nv04_cursor.c       |    1 +
 drivers/gpu/drm/nouveau/nv50_cursor.c       |    1 +
 drivers/gpu/drm/nouveau/nv50_sor.c          |    7 +-
 drivers/gpu/drm/radeon/Makefile             |    7 +-
 drivers/gpu/drm/radeon/evergreen.c          |    5 +
 drivers/gpu/drm/radeon/evergreen_cs.c       | 1356 +++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/evergreen_reg.h      |    3 +
 drivers/gpu/drm/radeon/evergreend.h         |  464 +++++++++
 drivers/gpu/drm/radeon/r600.c               |    6 +
 drivers/gpu/drm/radeon/radeon.h             |    1 +
 drivers/gpu/drm/radeon/radeon_asic.c        |    4 +-
 drivers/gpu/drm/radeon/radeon_asic.h        |    1 +
 drivers/gpu/drm/radeon/radeon_atombios.c    |   70 ++-
 drivers/gpu/drm/radeon/radeon_combios.c     |    7 +-
 drivers/gpu/drm/radeon/radeon_device.c      |    9 +
 drivers/gpu/drm/radeon/radeon_pm.c          |   75 +-
 drivers/gpu/drm/radeon/reg_srcs/evergreen   |  611 ++++++++++++
 drivers/gpu/drm/radeon/rs600.c              |    3 +-
 drivers/gpu/drm/radeon/rv770.c              |    5 +
 drivers/gpu/drm/ttm/ttm_page_alloc.c        |   64 +-
 drivers/gpu/drm/vmwgfx/Makefile             |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c         |   24 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h         |   49 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c     |    9 +
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c          |   87 +--
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c       |  173 ++++
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c        |   23 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_irq.c         |   17 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c         |  203 +++-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.h         |    4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c         |  189 +++-
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c     |    2 +
 drivers/gpu/vga/vgaarb.c                    |   61 +-
 include/drm/drm_crtc_helper.h               |    3 +
 include/drm/nouveau_drm.h                   |    1 +
 include/drm/vmwgfx_drm.h                    |   26 +
 include/linux/vgaarb.h                      |   21 +
 48 files changed, 3538 insertions(+), 321 deletions(-)
 create mode 100644 drivers/gpu/drm/radeon/evergreen_cs.c
 create mode 100644 drivers/gpu/drm/radeon/reg_srcs/evergreen
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
--29444707-1877074978-1275535687=:21882--
