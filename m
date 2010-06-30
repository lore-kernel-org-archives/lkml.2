Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab0F3BDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 21:03:23 -0400
Received: from gir.skynet.ie ([193.1.99.77]:37117 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab0F3BDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 21:03:22 -0400
Date: Wed, 30 Jun 2010 02:03:04 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: [git pull] drm fixes + agp + one fb patch
Message-ID: <alpine.DEB.2.00.1006300202190.30052@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

one fb layer fix in a flag I introduced,

the rest are drm fixes:
radeon fixes: the larger ones in the command stream checker for older cards,
which was causing a lot of userspace apps to fail. Also some powerpc server fixes.
along with some updates to the evergreen command stream checker introduced in -rc1.

agp: fix issue with warning on memory allocation + fallback to vmalloc.
ttm: fix regression introduced in -rc1 in memory allocation paths.

The following changes since commit 7e27d6e778cd87b6f2415515d7127eba53fe5d02:

  Linux 2.6.35-rc3 (2010-06-11 19:14:04 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Adam Jackson (1):
      drm/fb: Fix video= mode computation

Alex Deucher (7):
      drm/radeon/kms: fix bandwidth calculation when sideport is present
      drm/radeon/kms: fix DP after DPMS cycle
      drm/radeon/kms: fix typo in evergreen_gpu_init
      drm/radeon/kms: disable frac fb dividers for rs6xx
      drm/radeon/kms: avoid oops on mac r4xx cards
      drm/radeon/kms: fix typos in evergreen command checker
      drm/radeon/kms: add some missing regs to evergreen gpu init

Cedric Godin (1):
      drm/radeon/kms: fix dpms state on resume

Dave Airlie (7):
      drm/radeon: fix dual-head on rv250
      radeon/kms: fix powerpc/rn50 untiled behaviour.
      agp: drop vmalloc flag.
      agp: add no warn since we have a fallback to vmalloc paths
      drm/radeon: add fake RN50 table for powerpc
      drm/radeon/kms: don't read attempt to read bios from VRAM on unposted GPU.
      fb: fix colliding defines for fb flags.

Jerome Glisse (2):
      drm/ttm: non pooled page allocation should have GFP_USER set
      drm/radeon/kms: Force HDP_NONSURF to maximum size

Matt Turner (1):
      drm/radeon/kms: return ret in cursor_set failure path

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
 drivers/gpu/drm/radeon/r600.c                   |    2 +-
 drivers/gpu/drm/radeon/radeon_asic.c            |    7 ++
 drivers/gpu/drm/radeon/radeon_bios.c            |    4 +
 drivers/gpu/drm/radeon/radeon_combios.c         |   32 +++++++++
 drivers/gpu/drm/radeon/radeon_cursor.c          |    2 +-
 drivers/gpu/drm/radeon/radeon_device.c          |    7 ++
 drivers/gpu/drm/radeon/radeon_encoders.c        |    4 +-
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |   22 +++----
 drivers/gpu/drm/radeon/radeon_mode.h            |    1 +
 drivers/gpu/drm/radeon/reg_srcs/evergreen       |   10 ++--
 drivers/gpu/drm/radeon/rs690.c                  |    6 +--
 drivers/gpu/drm/radeon/rv770.c                  |    2 +-
 drivers/gpu/drm/ttm/ttm_page_alloc.c            |    2 +-
 include/linux/agp_backend.h                     |    1 -
 include/linux/fb.h                              |    4 +-
 24 files changed, 182 insertions(+), 84 deletions(-)
