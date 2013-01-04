Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab3ADGTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 01:19:50 -0500
Received: from gir.skynet.ie ([193.1.99.77]:54096 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab3ADGTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 01:19:49 -0500
Date: Fri, 4 Jan 2013 06:19:46 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] radeon and minor nouveau fixes
Message-ID: <alpine.DEB.2.00.1301040616350.20241@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Just a radeon pull from Alex, fixes a few regressions since 3.7 and 
reworks some of the reset handling, and two minor nouveau fixes I found on 
the list, Ben will be back next week to take care of the couple of larger 
nouveau patches that I see outstanding.

Dave.

The following changes since commit d5757dbe79870d825d0dec30074d48683e1d7e9a:

  Revert "drm: tegra: protect DC register access with mutex" (2012-12-30 21:58:20 +1000)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-next

for you to fetch changes up to eda85d6ad490923152544fba0473798b6cc0edf6:

  drm/nouveau: fix init with agpgart-uninorth (2013-01-04 16:04:33 +1000)

----------------------------------------------------------------
Aaro Koskinen (1):
      drm/nouveau: fix init with agpgart-uninorth

Alex Deucher (8):
      drm/radeon: add connector table for Mac G4 Silver
      drm/radeon/r6xx: fix DMA engine for ttm bo transfers
      drm/radeon: fix typo in evergreen dma fence
      drm/radeon: add GPU reset flags
      drm/radeon: switch to a finer grained reset for r6xx/7xx
      drm/radeon: switch to a finer grained reset for evergreen
      drm/radeon: switch to a finer grained reset for cayman/TN
      drm/radeon: switch to a finer grained reset for SI (v2)

Dave Airlie (1):
      Merge branch 'drm-fixes-3.8' of git://people.freedesktop.org/~agd5f/linux into drm-next

Guenter Roeck (1):
      drm: nouveau: Fix build warning seen if HWMON is undefined

Jerome Glisse (4):
      drm/radeon: add debugfs file for dma rings
      drm/radeon: improve ring debugfs printing
      drm/radeon: print dma status reg on lockup (v2)
      drm/radeon: reset dma engine on gpu reset (v2)

Niels Ole Salscheider (1):
      drm/radeon: Properly handle DDC probe for DP bridges

 drivers/gpu/drm/nouveau/nouveau_bo.c       |   2 +-
 drivers/gpu/drm/nouveau/nouveau_pm.c       |   4 +-
 drivers/gpu/drm/radeon/evergreen.c         |  86 +++++++++++++++++------
 drivers/gpu/drm/radeon/evergreend.h        |  14 +++-
 drivers/gpu/drm/radeon/ni.c                | 106 +++++++++++++++++++++--------
 drivers/gpu/drm/radeon/nid.h               |   3 +-
 drivers/gpu/drm/radeon/r600.c              |  89 ++++++++++++++++++------
 drivers/gpu/drm/radeon/radeon.h            |   5 ++
 drivers/gpu/drm/radeon/radeon_combios.c    |  51 ++++++++++++++
 drivers/gpu/drm/radeon/radeon_connectors.c |  10 +--
 drivers/gpu/drm/radeon/radeon_display.c    |  13 ++--
 drivers/gpu/drm/radeon/radeon_i2c.c        |  10 ++-
 drivers/gpu/drm/radeon/radeon_mode.h       |   5 +-
 drivers/gpu/drm/radeon/radeon_ring.c       |  24 +++++--
 drivers/gpu/drm/radeon/si.c                |  78 ++++++++++++++++++---
 drivers/gpu/drm/radeon/sid.h               |  18 +++++
 16 files changed, 416 insertions(+), 102 deletions(-)
