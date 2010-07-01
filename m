Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab0GADHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 23:07:06 -0400
Received: from gir.skynet.ie ([193.1.99.77]:58227 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651Ab0GADHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 23:07:04 -0400
Date: Thu, 1 Jul 2010 04:06:45 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org,
       DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: [git pull] drm + agp + one fb (v2)
Message-ID: <alpine.DEB.2.00.1007010403460.610@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Okay same tree as yesterday, with the fix for the regression Markus 
reported (good fast work by Alex), fix for resume on one of my laptops, 
Rafael's resume fix, and a dynpm fix that I missed.

Otherwise:
one fb layer fix in a flag I introduced,

the rest are drm fixes:
radeon fixes: the larger ones in the command stream checker for older 
cards,
which was causing a lot of userspace apps to fail. Also some powerpc 
server fixes.
along with some updates to the evergreen command stream checker introduced 
in -rc1.

agp: fix issue with warning on memory allocation + fallback to vmalloc.
ttm: fix regression introduced in -rc1 in memory allocation paths.


The following changes since commit 7e27d6e778cd87b6f2415515d7127eba53fe5d02:

  Linux 2.6.35-rc3 (2010-06-11 19:14:04 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Adam Jackson (1):
      drm/fb: Fix video= mode computation

Alex Deucher (10):
      drm/radeon/kms: fix bandwidth calculation when sideport is present
      drm/radeon/kms: fix DP after DPMS cycle
      drm/radeon/kms: fix typo in evergreen_gpu_init
      drm/radeon/kms: disable frac fb dividers for rs6xx
      drm/radeon/kms: avoid oops on mac r4xx cards
      drm/radeon/kms: fix typos in evergreen command checker
      drm/radeon/kms: add some missing regs to evergreen gpu init
      drm/radeon/kms/igp: fix possible divide by 0 in bandwidth code (v2)
      drm/radeon/kms/pm: fix power state indexing on igp chips in dynpm mode
      drm/radeon/kms: remove rv100 bios connector quirk

Cedric Godin (1):
      drm/radeon/kms: fix dpms state on resume

Dave Airlie (8):
      drm/radeon: fix dual-head on rv250
      radeon/kms: fix powerpc/rn50 untiled behaviour.
      agp: drop vmalloc flag.
      agp: add no warn since we have a fallback to vmalloc paths
      drm/radeon: add fake RN50 table for powerpc
      drm/radeon/kms: don't read attempt to read bios from VRAM on unposted GPU.
      fb: fix colliding defines for fb flags.
      drm/radeon: add quirk to make HP nx6125 laptop resume.

Jerome Glisse (2):
      drm/ttm: non pooled page allocation should have GFP_USER set
      drm/radeon/kms: Force HDP_NONSURF to maximum size

Matt Turner (1):
      drm/radeon/kms: return ret in cursor_set failure path

Rafael J. Wysocki (1):
      DRM / radeon / KMS: Fix hibernation regression related to radeon PM (was: Re: [Regression, post-2.6.34] Hibernation broken on machines with radeon/KMS and r300)

Roland Scheidegger (3):
      drm/radeon/kms: CS checker texture fixes for r1xx/r2xx/r3xx
      drm/radeon/r200: handle more hw tex coord types
      drm/radeon/r100/r200: fix calculation of compressed cube maps

 drivers/char/agp/generic.c                      |    6 +-
 drivers/gpu/drm/drm_fb_helper.c                 |   19 ++++--
 drivers/gpu/drm/radeon/atombios_crtc.c          |    2 +-
 drivers/gpu/drm/radeon/evergreen.c              |   35 ++++++++--
 drivers/gpu/drm/radeon/evergreen_cs.c           |    4 +-
 drivers/gpu/drm/radeon/evergreend.h             |    3 +
 drivers/gpu/drm/radeon/r100.c                   |   81 +++++++++++++---------
 drivers/gpu/drm/radeon/r200.c                   |    5 ++
 drivers/gpu/drm/radeon/r300.c                   |    5 ++
 drivers/gpu/drm/radeon/r600.c                   |   17 ++++--
 drivers/gpu/drm/radeon/radeon.h                 |    4 +-
 drivers/gpu/drm/radeon/radeon_asic.c            |    7 ++
 drivers/gpu/drm/radeon/radeon_bios.c            |    4 +
 drivers/gpu/drm/radeon/radeon_combios.c         |   49 +++++++++++---
 drivers/gpu/drm/radeon/radeon_cursor.c          |    2 +-
 drivers/gpu/drm/radeon/radeon_device.c          |    7 ++
 drivers/gpu/drm/radeon/radeon_encoders.c        |    4 +-
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |   22 +++----
 drivers/gpu/drm/radeon/radeon_mode.h            |    1 +
 drivers/gpu/drm/radeon/radeon_pm.c              |   41 ++++++++++--
 drivers/gpu/drm/radeon/reg_srcs/evergreen       |   10 ++--
 drivers/gpu/drm/radeon/rs690.c                  |   41 ++++++------
 drivers/gpu/drm/radeon/rv770.c                  |    2 +-
 drivers/gpu/drm/ttm/ttm_page_alloc.c            |    2 +-
 include/linux/agp_backend.h                     |    1 -
 include/linux/fb.h                              |    4 +-
 26 files changed, 257 insertions(+), 121 deletions(-)
