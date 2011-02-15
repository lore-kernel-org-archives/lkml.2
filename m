Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab1BOXEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 18:04:24 -0500
Received: from gir.skynet.ie ([193.1.99.77]:39619 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755093Ab1BOXEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 18:04:22 -0500
Date: Tue, 15 Feb 2011 23:03:54 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1102152258030.5315@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1647677421-1297811034=:5315"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1647677421-1297811034=:5315
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Slightly bigger than I'd prefer, but we got a lot of endian fixes for 
radeon spread out all over the place, Alex has hopefully discovered the 
correct answer for the PLL nightmares, also a race condition on GPU reset 
that was causing an oops and full machine hang. Usually smattering of 
Intel fixes, RC6 power saving is off again due to hard hangs on some 
machines, and a resume regression fix.

Hopefully along with Len's ACPI pull we are rid of most of the regressions 
now.

Dave.

The following changes since commit 091994cfb8e7d7a372c2d547778a91012d899e16:

  Merge branch 'spi/merge' of git://git.secretlab.ca/git/linux-2.6 (2011-02-13 07:59:48 -0800)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (9):
      drm/radeon/kms: fix interlaced modes on dce4+
      drm/radeon/kms: add connector table for mac g5 9600
      drm/radeon/kms: evergreen/ni big endian fixes (v2)
      drm/radeon/kms: use linear aligned for 6xx/7xx bo blits
      drm/radeon/kms: use linear aligned for evergreen/ni bo blits
      drm/radeon/kms: improve 6xx/7xx CS error output
      drm/radeon/kms: fix a few more atombios endian issues
      drm/radeon/kms: add bounds checking to avivo pll algo
      drm/radeon/kms: hopefully fix pll issues for real (v3)

Chris Wilson (7):
      drm/i915: Invalidate TLB caches on SNB BLT/BSD rings
      drm/i915/lvds: Restore dithering on native modes for gen2/3
      drm/i915: Disable RC6 on Ironlake
      drm/i915/sdvo: If we have an EDID confirm it matches the mode of the connection
      drm/i915: Trigger modesetting if force-audio changes
      drm/i915/tv: Use polling rather than interrupt-based hotplug
      drm/i915: Fix resume regression from 5d1d0cc

Cédric Cano (3):
      drm/radeon: 6xx/7xx non-kms endian fixes
      drm/radeon/kms: atombios big endian fixes
      drm/radeon/kms: 6xx/7xx big endian fixes

Dave Airlie (3):
      drm/radeon: fix memory debugging since d961db75ce86a84f1f04e91ad1014653ed7d9f46
      drm/radeon: fix race between GPU reset and TTM delayed delete thread.
      Merge remote branch 'intel/drm-intel-fixes' of /ssd/git/drm-next into drm-fixes

Jesper Juhl (1):
      radeon mkregtable: Add missing fclose() calls

Kees Cook (1):
      drm: do not leak kernel addresses via /proc/dri/*/vma

Marek Ol¨ák (3):
      drm/radeon/kms: optimize CS state checking for r100->r500
      drm/radeon/kms: fix tracking of BLENDCNTL, COLOR_CHANNEL_MASK, and GB_Z on r300
      drm/radeon/kms: check AA resolve registers on r300

Xiao Jiang (1):
      drm: fix wrong usages of drm_device in DRM Developer's Guide

 Documentation/DocBook/drm.tmpl                  |    6 +-
 drivers/gpu/drm/drm_info.c                      |    9 +-
 drivers/gpu/drm/i915/i915_drv.c                 |    5 +-
 drivers/gpu/drm/i915/i915_drv.h                 |    1 +
 drivers/gpu/drm/i915/i915_reg.h                 |    4 +-
 drivers/gpu/drm/i915/intel_display.c            |   95 ++++++++++++----------
 drivers/gpu/drm/i915/intel_dp.c                 |   36 +++++++--
 drivers/gpu/drm/i915/intel_drv.h                |    1 -
 drivers/gpu/drm/i915/intel_hdmi.c               |   39 ++++++++--
 drivers/gpu/drm/i915/intel_lvds.c               |   12 ++--
 drivers/gpu/drm/i915/intel_ringbuffer.c         |   26 ++++---
 drivers/gpu/drm/i915/intel_sdvo.c               |   66 +++++++++++++---
 drivers/gpu/drm/i915/intel_tv.c                 |   43 +++++++---
 drivers/gpu/drm/radeon/atombios_crtc.c          |   98 +++++++++-------------
 drivers/gpu/drm/radeon/evergreen.c              |   22 ++++-
 drivers/gpu/drm/radeon/evergreen_blit_kms.c     |   23 ++++--
 drivers/gpu/drm/radeon/evergreen_blit_shaders.c |    8 ++
 drivers/gpu/drm/radeon/evergreend.h             |    1 +
 drivers/gpu/drm/radeon/mkregtable.c             |    5 +-
 drivers/gpu/drm/radeon/r100.c                   |   63 ++++++++++++++-
 drivers/gpu/drm/radeon/r100_track.h             |   13 ++--
 drivers/gpu/drm/radeon/r200.c                   |   18 ++++
 drivers/gpu/drm/radeon/r300.c                   |   42 +++++++++-
 drivers/gpu/drm/radeon/r300_reg.h               |    2 +
 drivers/gpu/drm/radeon/r600.c                   |   22 ++++-
 drivers/gpu/drm/radeon/r600_blit.c              |   11 ++-
 drivers/gpu/drm/radeon/r600_blit_kms.c          |   29 +++++--
 drivers/gpu/drm/radeon/r600_blit_shaders.c      |    4 +
 drivers/gpu/drm/radeon/r600_cp.c                |   31 ++++++--
 drivers/gpu/drm/radeon/r600_cs.c                |   46 ++++++-----
 drivers/gpu/drm/radeon/r600d.h                  |    9 +-
 drivers/gpu/drm/radeon/radeon_atombios.c        |   48 ++++++------
 drivers/gpu/drm/radeon/radeon_combios.c         |   47 +++++++++++
 drivers/gpu/drm/radeon/radeon_device.c          |    4 +
 drivers/gpu/drm/radeon/radeon_display.c         |   10 +++
 drivers/gpu/drm/radeon/radeon_drv.h             |    1 +
 drivers/gpu/drm/radeon/radeon_encoders.c        |   24 ++++--
 drivers/gpu/drm/radeon/radeon_mode.h            |    1 +
 drivers/gpu/drm/radeon/radeon_ttm.c             |    4 +-
 drivers/gpu/drm/radeon/reg_srcs/r300            |    6 +-
 drivers/gpu/drm/radeon/reg_srcs/r420            |    7 +--
 drivers/gpu/drm/radeon/reg_srcs/rs600           |    6 +-
 drivers/gpu/drm/radeon/reg_srcs/rv515           |    7 +--
 drivers/gpu/drm/radeon/rs690.c                  |   12 ++--
 drivers/gpu/drm/radeon/rv770.c                  |    6 +-
 drivers/gpu/drm/radeon/rv770d.h                 |    8 +-
 46 files changed, 679 insertions(+), 302 deletions(-)
--29444707-1647677421-1297811034=:5315--
