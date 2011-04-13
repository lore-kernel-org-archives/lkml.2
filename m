Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab1DMAo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 20:44:58 -0400
Received: from gir.skynet.ie ([193.1.99.77]:46865 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757417Ab1DMAo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 20:44:56 -0400
Date: Wed, 13 Apr 2011 01:43:59 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1104130138170.12900@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1339693671-1302655449=:12900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1339693671-1302655449=:12900
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

This should have gone out a few days ago, but I was trapped watching 
Disney shows with my daughter at home and I wanted to check it on a few 
more machines,

Its got two reverts, one for a change I pushed out by accident to -fixes, 
the other for a Xen/TTM change, that looks to be causing non-Xen 
problems so punting on it for now. The rest is mostly nouveau + radeon 
fixes, the radeon ones fix a few regressions and stability problems on 
newer cards.

I suspect I'll have a few more intel fixes and v2 of the i915 patch I 
reverted out of this pull, it fixes a problem on the dual-gpu laptops reported a 
long while ago.

The following changes since commit 94c8a984ae2adbd9a9626fb42e0f2faf3e36e86f:

  Merge branch 'bugfixes' of git://git.linux-nfs.org/projects/trondmy/nfs-2.6 (2011-04-08 11:47:35 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (7):
      drm/radeon/kms: pll tweaks for rv6xx
      drm/radeon/kms: make radeon i2c put/get bytes less noisy
      drm/radeon/kms: clean up gart dummy page handling
      drm/radeon/kms: fix suspend on rv530 asics
      drm/radeon/kms: fix pcie_p callbacks on btc and cayman
      drm/radeon/kms: add voltage type to atom set voltage function
      drm/radeon/kms: properly program vddci on evergreen+

Ben Skeggs (5):
      drm/nouveau: implement init table opcode 0x5c
      drm/nouveau: quirk for XFX GT-240X-YA
      drm/nv50: use "nv86" tlb flush method on everything except 0x50/0xac
      drm/nv50-nvc0: remove some code that doesn't belong here
      drm/nvc0: improve vm flush function

Dave Airlie (4):
      i915: restore only the mode of this driver on lastclose
      Merge remote branch 'nouveau/drm-nouveau-fixes' of /ssd/git/drm-nouveau-next into drm-fixes
      Revert "ttm: Utilize the DMA API for pages that have TTM_PAGE_FLAG_DMA32 set."
      Revert "i915: restore only the mode of this driver on lastclose"

David Dillow (1):
      drm/nv50-nvc0: work around an evo channel hang that some people see

Emil Velikov (1):
      nv30: Fix parsing of perf table

Konstantin Khlebnikov (1):
      i915: select VIDEO_OUTPUT_CONTROL for ACPI_VIDEO

Marcin Slusarz (1):
      drm/nouveau: fix oops on unload with disabled LVDS panel

Michel Dänzer (2):
      radeon: Fix KMS CP writeback on big endian machines.
      drm/radeon: Fix KMS legacy backlight support if CONFIG_BACKLIGHT_CLASS_DEVICE=m.

Roy Spliet (1):
      drm/nouveau: correct memtiming table parsing for nv4x

 drivers/gpu/drm/Kconfig                         |    1 +
 drivers/gpu/drm/nouveau/nouveau_bios.c          |   53 +++++++++++++++-
 drivers/gpu/drm/nouveau/nouveau_drv.h           |    2 +-
 drivers/gpu/drm/nouveau/nouveau_mem.c           |   76 +++++++++++++++--------
 drivers/gpu/drm/nouveau/nouveau_perf.c          |    2 +-
 drivers/gpu/drm/nouveau/nouveau_state.c         |   12 +---
 drivers/gpu/drm/nouveau/nv04_dfp.c              |   13 ++--
 drivers/gpu/drm/nouveau/nv50_crtc.c             |    3 -
 drivers/gpu/drm/nouveau/nv50_evo.c              |    1 +
 drivers/gpu/drm/nouveau/nv50_graph.c            |    2 +-
 drivers/gpu/drm/nouveau/nvc0_vm.c               |   24 +++++---
 drivers/gpu/drm/radeon/atom.c                   |    6 ++-
 drivers/gpu/drm/radeon/atombios_crtc.c          |    6 ++
 drivers/gpu/drm/radeon/evergreen.c              |   17 +++---
 drivers/gpu/drm/radeon/r600.c                   |    6 +--
 drivers/gpu/drm/radeon/radeon.h                 |   12 +++-
 drivers/gpu/drm/radeon/radeon_asic.c            |    2 +-
 drivers/gpu/drm/radeon/radeon_atombios.c        |   30 ++++++---
 drivers/gpu/drm/radeon/radeon_fence.c           |    2 +-
 drivers/gpu/drm/radeon/radeon_gart.c            |    2 +
 drivers/gpu/drm/radeon/radeon_i2c.c             |    4 +-
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    2 +-
 drivers/gpu/drm/radeon/radeon_pm.c              |   11 +++-
 drivers/gpu/drm/radeon/radeon_ring.c            |    2 +-
 drivers/gpu/drm/radeon/rs600.c                  |    2 +-
 drivers/gpu/drm/radeon/rv770.c                  |    6 +--
 drivers/gpu/drm/ttm/ttm_page_alloc.c            |   26 +-------
 drivers/gpu/stub/Kconfig                        |    1 +
 28 files changed, 201 insertions(+), 125 deletions(-)
--29444707-1339693671-1302655449=:12900--
