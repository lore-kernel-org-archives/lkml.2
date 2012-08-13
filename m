Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab2HMXee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 19:34:34 -0400
Received: from gir.skynet.ie ([193.1.99.77]:46254 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140Ab2HMXec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 19:34:32 -0400
Date: Tue, 14 Aug 2012 00:34:29 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1208140033160.8559@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1324198250-1344900870=:8559"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1324198250-1344900870=:8559
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

radeon and intel fixes mostly, one fix to the mgag200 driver to not hang 
on certain server variants.

Dave.

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux.git drm-fixes

for you to fetch changes up to 7bac6b46607f2f44075cb45dd5b0b4d2e7c80695:

  Merge branch 'drm-fixes-3.6' of git://people.freedesktop.org/~agd5f/linux into drm-fixes (2012-08-14 09:25:01 +1000)

----------------------------------------------------------------

Alan Cox (3):
      vlv: it might be wise if we initialised the flag value...
      i915: fix error path leak in intel_sdvo_write_cmd
      i915: Remove silly test

Alex Deucher (9):
      drm/radeon: fix handling for ddc type 5 on combios
      drm/radeon/dce4+: set a more reasonable cursor watermark
      drm/radeon: properly handle SS overrides on TN (v2)
      drm/radeon: properly handle crtc powergating
      drm/radeon: fix bank tiling parameters on evergreen
      drm/radeon: fix bank tiling parameters on cayman
      drm/radeon: fix ordering in pll picking on dce4+
      drm/radeon: add some new SI pci ids
      drm/radeon: fix some missing parens in asic macros

Alexey Khoroshilov (1):
      drm/edid: Fix potential memory leak in edid_load()

Chris Wilson (1):
      drm/i915: Workaround hang with BSD and forcewake on SandyBridge

Christian König (1):
      drm/radeon: fix bank tiling parameters on SI

Daniel Vetter (2):
      drm/i915: fix forcewake related hangs on snb
      drm/i915: correctly order the ring init sequence

Dave Airlie (4):
      i915: don't map imported dma-bufs for dmar.
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      drm/mgag200: fix G200ER pll picking algorithm
      Merge branch 'drm-fixes-3.6' of git://people.freedesktop.org/~agd5f/linux into drm-fixes

Devendra Naga (1):
      drm/i915: remove unused variable

Dmitrii Cherkasov (1):
      drm/radeon: fix typo in function header comment

Eric Anholt (1):
      drm/i915: Don't forget to apply SNB PIPE_CONTROL GTT workaround.

Hunt Xu (1):
      drm/i915: make rc6 in sysfs functions conditional

Jerome Glisse (2):
      drm/radeon: do not reenable crtc after moving vram start address
      drm/radeon: fence virtual address and free it once idle v4

Marek Ol¨ák (4):
      drm/radeon/kms: allow "invalid" DB formats as a means to disable DB
      drm/radeon/kms: reorder code in r600_check_texture_resource
      drm/radeon/kms: add MSAA texture support for r600-evergreen
      drm/radeon/kms: implement timestamp userspace query (v2)

Paulo Zanoni (1):
      drm/i915: add more Haswell PCI IDs

Stéphane Marchesin (1):
      drm/i915: Make intel_panel_get_backlight static.

Thomas Meyer (1):
      drm/udl: Use ERR_CAST inlined function instead of ERR_PTR(PTR_ERR(.. [1]

 drivers/char/agp/intel-agp.h                |   39 +++++++++++++--
 drivers/char/agp/intel-gtt.c                |   60 +++++++++++++++++++++-
 drivers/gpu/drm/drm_edid_load.c             |    8 +--
 drivers/gpu/drm/i915/i915_drv.c             |   31 +++++++++++-
 drivers/gpu/drm/i915/i915_gem_context.c     |    1 -
 drivers/gpu/drm/i915/i915_gem_execbuffer.c  |   20 ++++----
 drivers/gpu/drm/i915/i915_gem_gtt.c         |    3 +-
 drivers/gpu/drm/i915/i915_sysfs.c           |   12 +++++
 drivers/gpu/drm/i915/intel_display.c        |    1 +
 drivers/gpu/drm/i915/intel_drv.h            |   20 ++++----
 drivers/gpu/drm/i915/intel_i2c.c            |    3 --
 drivers/gpu/drm/i915/intel_panel.c          |    2 +-
 drivers/gpu/drm/i915/intel_pm.c             |    6 ++-
 drivers/gpu/drm/i915/intel_ringbuffer.c     |    7 ++-
 drivers/gpu/drm/i915/intel_sdvo.c           |    5 +-
 drivers/gpu/drm/mgag200/mgag200_mode.c      |   12 +++--
 drivers/gpu/drm/radeon/atombios_crtc.c      |   22 ++++++---
 drivers/gpu/drm/radeon/evergreen.c          |   71 +++++----------------------
 drivers/gpu/drm/radeon/evergreen_cs.c       |   13 ++++-
 drivers/gpu/drm/radeon/evergreend.h         |    2 +
 drivers/gpu/drm/radeon/ni.c                 |   14 ++++--
 drivers/gpu/drm/radeon/r600.c               |   20 ++++++++
 drivers/gpu/drm/radeon/r600_cs.c            |   65 +++++++++++++-----------
 drivers/gpu/drm/radeon/r600d.h              |    3 ++
 drivers/gpu/drm/radeon/radeon.h             |   12 +++--
 drivers/gpu/drm/radeon/radeon_asic.h        |   10 ++--
 drivers/gpu/drm/radeon/radeon_atombios.c    |   49 +++++++++++++-----
 drivers/gpu/drm/radeon/radeon_combios.c     |   57 +++++++++++++--------
 drivers/gpu/drm/radeon/radeon_cs.c          |   32 ++++++++++--
 drivers/gpu/drm/radeon/radeon_cursor.c      |    6 ++-
 drivers/gpu/drm/radeon/radeon_device.c      |    1 +
 drivers/gpu/drm/radeon/radeon_drv.c         |    5 +-
 drivers/gpu/drm/radeon/radeon_gart.c        |   26 ++++++++--
 drivers/gpu/drm/radeon/radeon_gem.c         |   13 +----
 drivers/gpu/drm/radeon/radeon_kms.c         |   35 ++++++++++---
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |    4 ++
 drivers/gpu/drm/radeon/radeon_mode.h        |    1 +
 drivers/gpu/drm/radeon/radeon_object.c      |    6 +--
 drivers/gpu/drm/radeon/rv515.c              |   13 -----
 drivers/gpu/drm/radeon/si.c                 |   35 +++++++++++--
 drivers/gpu/drm/radeon/sid.h                |    3 ++
 drivers/gpu/drm/udl/udl_gem.c               |    2 +-
 include/drm/drm_pciids.h                    |    3 ++
 include/drm/radeon_drm.h                    |    2 +
 44 files changed, 516 insertions(+), 239 deletions(-)
--29444707-1324198250-1344900870=:8559--
