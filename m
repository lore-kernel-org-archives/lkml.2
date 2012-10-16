Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab2JPGoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 02:44:11 -0400
Received: from gir.skynet.ie ([193.1.99.77]:45322 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061Ab2JPGoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 02:44:09 -0400
Date: Tue, 16 Oct 2012 07:44:06 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1210160738100.19767@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1963980744-1350369846=:19767"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1963980744-1350369846=:19767
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

fixes for i915, nouveau and radeon

i915: haswell stability, modeset rework fallout, ums fix
nouveau: misc fixes from code rework
radeon: pll rework fixes, more 2 level PTE cleanups.
core: warning fixes on 32-bit.

Dave.

The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux.git drm-fixes

for you to fetch changes up to 8a00b6af4cc547725f231c8367ddc7cb56b2cf76:

  nouveau: fix warning on 32-bit build. (2012-10-16 16:40:53 +1000)

----------------------------------------------------------------
Alex Deucher (5):
      drm/radeon: fix compilation with backlight disabled
      drm/radeon: allocate PPLLs from low to high
      drm/radeon: update comments to clarify VM setup (v2)
      drm/radeon/cayman: set VM max pfn at MC init
      drm/radeon: check if pcie gen 2 is already enabled (v2)

Ben Skeggs (1):
      drm/nouveau/bios: fix typo in error message

Chris Wilson (2):
      drm/i915: Disallow preallocation of requests
      drm/i915: fixup i915_gem_object_get_page inline helper

Christian König (3):
      drm/radeon: allocate page tables on demand v4
      drm/radeon: don't add the IB pool to all VMs v2
      drm/radeon: separate pt alloc from lru add

Daniel Vetter (5):
      drm/i915: paper over a pipe-enable vs pageflip race
      drm/i915: disable wc gtt pte mappings on gen2
      drm/i915: rip out the pipe A quirk for i855gm
      drm/i915: fixup the plane->pipe fixup code
      drm/i915/dvo-ch7xxx: fix get_hw_state

Dave Airlie (5):
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes
      Merge branch 'drm-fixes-3.7' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
      drm: fix warning on 32-bit.
      Merge branch 'drm-nouveau-fixes' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes
      nouveau: fix warning on 32-bit build.

Egbert Eich (1):
      drm/radeon: Don't destroy I2C Bus Rec in radeon_ext_tmds_enc_destroy().

Jani Nikula (1):
      drm/i915: fix non-DP-D eDP backlight cleanup and module reload

Kenneth Graunke (1):
      drm/i915: Set guardband clipping workaround bit in the right register.

Luca Tettamanti (1):
      drm/radeon: use %zu for formatting size_t

Marcin Slusarz (1):
      drm/nv50/fb: fix double free of vram mm

Martin Peres (3):
      drm/nouveau/hwmon: fix the initialization condition
      drm/nouveau/pm: fix a typo related to the move to the therm subdev
      drm/nouveau/pm: do not stop reclocking if failing to set the fan speed

Max Filippov (1):
      drm/nouveau: only call ttm_agp_tt_create when __OS_HAS_AGP

Randy Dunlap (1):
      drm: radeon: fix printk format warning

Rodrigo Vivi (1):
      drm/i915: HSW CRW stability magic

Thomas Friebel (1):
      drm/radeon: fix spelling typos in debugging output

Willy Tarreau (1):
      drm/i915: remove useless BUG_ON which caused a regression in 3.5.

 drivers/char/agp/intel-gtt.c                    |    2 +-
 drivers/gpu/drm/drm_info.c                      |    2 +-
 drivers/gpu/drm/i915/dvo_ch7xxx.c               |    6 +-
 drivers/gpu/drm/i915/i915_drv.h                 |    9 +-
 drivers/gpu/drm/i915/i915_gem.c                 |   19 +-
 drivers/gpu/drm/i915/i915_reg.h                 |    2 +-
 drivers/gpu/drm/i915/intel_display.c            |   47 ++-
 drivers/gpu/drm/i915/intel_dp.c                 |    3 +-
 drivers/gpu/drm/i915/intel_overlay.c            |   72 +----
 drivers/gpu/drm/i915/intel_pm.c                 |    4 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/dcb.c  |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv50.c   |    1 -
 drivers/gpu/drm/nouveau/core/subdev/therm/fan.c |    2 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c            |    2 +
 drivers/gpu/drm/nouveau/nouveau_pm.c            |    6 +-
 drivers/gpu/drm/radeon/atombios_crtc.c          |    8 +-
 drivers/gpu/drm/radeon/evergreen.c              |    7 +-
 drivers/gpu/drm/radeon/ni.c                     |   12 +-
 drivers/gpu/drm/radeon/r600.c                   |    6 +
 drivers/gpu/drm/radeon/radeon.h                 |   14 +-
 drivers/gpu/drm/radeon/radeon_acpi.c            |    6 +-
 drivers/gpu/drm/radeon/radeon_atpx_handler.c    |    2 +-
 drivers/gpu/drm/radeon/radeon_cs.c              |    1 +
 drivers/gpu/drm/radeon/radeon_device.c          |    4 +
 drivers/gpu/drm/radeon/radeon_gart.c            |  374 ++++++++++++++++-------
 drivers/gpu/drm/radeon/radeon_kms.c             |   22 +-
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |   48 ++-
 drivers/gpu/drm/radeon/radeon_ring.c            |    2 +-
 drivers/gpu/drm/radeon/si.c                     |    7 +-
 29 files changed, 443 insertions(+), 249 deletions(-)
--29444707-1963980744-1350369846=:19767--
