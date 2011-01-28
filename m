Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab1A1Biv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 20:38:51 -0500
Received: from gir.skynet.ie ([193.1.99.77]:52839 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819Ab1A1Biu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 20:38:50 -0500
Date: Fri, 28 Jan 2011 01:38:24 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1101280136570.8640@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-2054926818-1296178704=:8640"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-2054926818-1296178704=:8640
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

radeon and nouveau fixes only, a couple of regressions, one evergreen 
GPU hang under load, and one big endian fix.

Dave.

The following changes since commit 6663050edd9c2e8b1e1f55c09459144d84c045f0:

  Merge branch 'fixes' of master.kernel.org:/home/rmk/linux-2.6-arm (2011-01-26 09:04:18 +1000)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (4):
      drm/radeon/kms: only enable HDMI mode if radeon audio is enabled
      drm/radeon/kms: clean up some magic numbers
      drm/radeon/kms: fix r6xx+ scanout on BE systems
      drm/radeon/kms: re-emit full context state for evergreen blits

Ben Skeggs (6):
      drm/nouveau: remove dead function definition
      drm/nouveau: probe for adt7473 before f75375
      drm/nvc0: fix incorrect TPC register setup
      drm/nvc0: implement irq handler for whatever's at 0x14xxxx
      drm/nvc0/grctx: correct an off-by-one
      drm/nv50: fix regression on IGPs

Dave Airlie (2):
      Merge branch 'drm-nouveau-next' of git://git.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes
      Merge branch 'drm-nouveau-next' of git://git.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes

Francisco Jerez (2):
      drm/nouveau: Workaround incorrect DCB entry on a GeForce3 Ti 200.
      drm/nv50: Fix race with PFIFO during PGRAPH context destruction.

Jerome Glisse (1):
      radeon/kms: fix dp displayport mode validation

Marek Ol¨ák (1):
      drm/radeon/kms: release CMASK access in preclose_kms

 drivers/gpu/drm/nouveau/nouveau_bios.c      |   15 ++++++++++
 drivers/gpu/drm/nouveau/nouveau_drv.h       |    3 --
 drivers/gpu/drm/nouveau/nouveau_temp.c      |    2 +-
 drivers/gpu/drm/nouveau/nv50_graph.c        |    3 ++
 drivers/gpu/drm/nouveau/nv50_vm.c           |    5 ---
 drivers/gpu/drm/nouveau/nvc0_graph.c        |   23 ++++++++++++++-
 drivers/gpu/drm/nouveau/nvc0_grctx.c        |    2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c      |   17 +++++++++++
 drivers/gpu/drm/radeon/atombios_dp.c        |    4 +-
 drivers/gpu/drm/radeon/evergreen_blit_kms.c |   39 ++++++++++++++++++++++----
 drivers/gpu/drm/radeon/r100.c               |   10 +++---
 drivers/gpu/drm/radeon/r300.c               |    7 +++-
 drivers/gpu/drm/radeon/r420.c               |    2 +-
 drivers/gpu/drm/radeon/r520.c               |    4 +-
 drivers/gpu/drm/radeon/r600_reg.h           |    6 +++-
 drivers/gpu/drm/radeon/radeon_encoders.c    |    6 ++--
 drivers/gpu/drm/radeon/radeon_kms.c         |    2 +
 drivers/gpu/drm/radeon/radeon_reg.h         |    2 +
 drivers/gpu/drm/radeon/rs400.c              |   15 ++++++----
 drivers/gpu/drm/radeon/rv515.c              |   10 +++---
 20 files changed, 132 insertions(+), 45 deletions(-)
--29444707-2054926818-1296178704=:8640--
